module DSP48A1 #(
    parameter A0REG = 0,
    parameter A1REG = 1,
    parameter B0REG = 0,
    parameter B1REG = 1,
    parameter CREG = 1,
    parameter DREG = 1,
    parameter MREG = 1,
    parameter PREG = 1,
    parameter CARRYINREG = 1,
    parameter CARRYOUTREG = 1,
    parameter OPMODEREG = 1,
    parameter CARRYINSEL = "OPMODE5",
    parameter B_INPUT = "DIRECT",
    parameter RSTTYPE = "SYNC"
) (
    /*----------------------DATA PORTS----------------------*/
    input [17:0] A, B, D,
    input [47:0] C,
    input CARRYIN,
    output [35:0] M,
    output [47:0] P,
    output CARRYOUT,
    output CARRYOUTF,

    /*----------------------CONTROL INPUT PORTS----------------------*/
    input CLK,
    input [7:0] OPMODE,

    /*----------------------CLOCK ENABLE INPUT PORTS----------------------*/
    input CEA, CEB, CEC, CED, CECARRYIN, CEM, CEOPMODE, CEP,

    /*----------------------RESET INPUT PORTS----------------------*/ 
    input RSTA, RSTB, RSTC, RSTD, RSTCARRYIN, RSTM, RSTOPMODE, RSTP,

    /*----------------------CASCADE PORTS----------------------*/
    output [17:0] BCOUT,
    input [47:0] PCIN,
    output [47:0] PCOUT
);

/*------------------------- OPMODE PIPELINE -------------------------*/
wire [7:0] OPMODE_OUT;
pipeline_stage #(.WIDTH(8), .RSTTYPE(RSTTYPE)) opmode_stage (
    .in(OPMODE), .clk(CLK), .rst(RSTOPMODE), .clk_en(CEOPMODE), .sel(OPMODEREG), .out(OPMODE_OUT)
);

/*------------------------- PORT D PIPELINE -------------------------*/
wire [17:0] D1_REG_OUT;
pipeline_stage #(.WIDTH(18), .RSTTYPE(RSTTYPE)) d_stage (
    .in(D), .clk(CLK), .rst(RSTD), .clk_en(CED), .sel(DREG), .out(D1_REG_OUT)
);

/*------------------------- PORT A PIPELINE (A0 -> A1) -------------------------*/
wire [17:0] A0_REG_OUT, A1_REG_OUT;
pipeline_stage #(.WIDTH(18), .RSTTYPE(RSTTYPE)) a0_stage (
    .in(A), .clk(CLK), .rst(RSTA), .clk_en(CEA), .sel(A0REG), .out(A0_REG_OUT)
);
pipeline_stage #(.WIDTH(18), .RSTTYPE(RSTTYPE)) a1_stage (
    .in(A0_REG_OUT), .clk(CLK), .rst(RSTA), .clk_en(CEA), .sel(A1REG), .out(A1_REG_OUT)
);

/*------------------------- PORT B PIPELINE (B0 -> Pre-Adder -> B1) -------------------------*/
wire [17:0] B_mux_in = (B_INPUT == "CASCADE") ? BCOUT : B; // Note: In hardware B_INPUT selects B or BCIN
wire [17:0] B0_REG_OUT, B1_REG_OUT;

pipeline_stage #(.WIDTH(18), .RSTTYPE(RSTTYPE)) b0_stage (
    .in(B_mux_in), .clk(CLK), .rst(RSTB), .clk_en(CEB), .sel(B0REG), .out(B0_REG_OUT)
);

// Pre-adder logic
wire [17:0] pre_add_sub_out;
pre_adder_subtracer #(.WIDTH(18)) pre_add_sub (
    .in0(D1_REG_OUT), .in1(B0_REG_OUT), .add_sub(OPMODE_OUT[6]), .out(pre_add_sub_out)
);

wire [17:0] mux_after_PreAddSub_out = (OPMODE_OUT[4]) ? pre_add_sub_out : B0_REG_OUT;

pipeline_stage #(.WIDTH(18), .RSTTYPE(RSTTYPE)) b1_stage (
    .in(mux_after_PreAddSub_out), .clk(CLK), .rst(RSTB), .clk_en(CEB), .sel(B1REG), .out(B1_REG_OUT)
);

assign BCOUT = B1_REG_OUT;

/*------------------------- PORT C PIPELINE -------------------------*/
wire [47:0] C1_REG_OUT;
pipeline_stage #(.WIDTH(48), .RSTTYPE(RSTTYPE)) c_stage (
    .in(C), .clk(CLK), .rst(RSTC), .clk_en(CEC), .sel(CREG), .out(C1_REG_OUT)
);

/*------------------------- MULTIPLIER & M REG -------------------------*/
wire [35:0] multiplier_out = A1_REG_OUT * B1_REG_OUT;
wire [35:0] M_REG_OUT;

pipeline_stage #(.WIDTH(36), .RSTTYPE(RSTTYPE)) m_stage (
    .in(multiplier_out), .clk(CLK), .rst(RSTM), .clk_en(CEM), .sel(MREG), .out(M_REG_OUT)
);
assign M = M_REG_OUT;

/*------------------------- POST-ADDER MUXES (X & Z) -------------------------*/
wire [47:0] X_out, Z_out;

// Mux X: 0:Zero, 1:M, 2:P, 3:Concatenate D:A:B
Mux4_1 MUX_X (
    .in0(48'b0),
    .in1({12'b0, M_REG_OUT}),
    .in2(P),
    .in3({D1_REG_OUT[11:0], A1_REG_OUT, B1_REG_OUT}),
    .sel(OPMODE_OUT[1:0]),
    .out(X_out)
);

// Mux Z: 0:Zero, 1:PCIN, 2:P, 3:C
Mux4_1 MUX_Z (
    .in0(48'b0),
    .in1(PCIN),
    .in2(P),
    .in3(C1_REG_OUT),
    .sel(OPMODE_OUT[3:2]),
    .out(Z_out)
);

/*------------------------- CARRY IN & POST-ADDER -------------------------*/
wire CARRYIN_MUX = (CARRYINSEL == "OPMODE5") ? OPMODE_OUT[5] : CARRYIN;
wire CARRYIN_STAGE;

pipeline_stage #(.WIDTH(1), .RSTTYPE(RSTTYPE)) cin_stage (
    .in(CARRYIN_MUX), .clk(CLK), .rst(RSTCARRYIN), .clk_en(CECARRYIN), .sel(CARRYINREG), .out(CARRYIN_STAGE)
);

wire [47:0] post_add_sub_out;
wire post_add_sub_cout;

Post_adder_substracter Post_add_substract(
    .in0(Z_out), .in1(X_out), .cin(CARRYIN_STAGE), .add_sub(OPMODE_OUT[7]),
    .out(post_add_sub_out), .cout(post_add_sub_cout)
);

/*------------------------- OUTPUT PIPELINES (P & CARRYOUT) -------------------------*/
pipeline_stage #(.WIDTH(1), .RSTTYPE(RSTTYPE)) CYO_stage (
    .in(post_add_sub_cout), .clk(CLK), .rst(RSTCARRYIN), .clk_en(CECARRYIN), .sel(CARRYOUTREG), .out(CARRYOUT)
);
assign CARRYOUTF = CARRYOUT;

pipeline_stage #(.WIDTH(48), .RSTTYPE(RSTTYPE)) PREG_stage (
    .in(post_add_sub_out), .clk(CLK), .rst(RSTP), .clk_en(CEP), .sel(PREG), .out(P)
);

assign PCOUT = P;

endmodule