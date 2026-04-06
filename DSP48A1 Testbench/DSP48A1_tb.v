`timescale 1ns / 1ps

module DSP48A1_tb ;

reg [17:0] A,B,D,BCIN; 
reg [47:0] C,PCIN;
reg [7:0] OPMODE; // FIXED: Typo 'OPMODD'
reg CLK,CARRYIN;
reg RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,
CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE;

wire [17:0] BCOUT; 
wire [47:0] PCOUT,P; 
wire [35:0] M ;
wire CARRYOUT ,CARRYOUTF; // FIXED: Typo 'CARRYOUTIF'

DSP48A1 DUT (
        .A(A), .B(B), .C(C), .D(D),
        .CARRYIN(CARRYIN),
        .M(M), .P(P), .PCOUT(PCOUT),
        .CARRYOUT(CARRYOUT), .CARRYOUTF(CARRYOUTF),
        .BCOUT(BCOUT),
        .CLK(CLK), .OPMODE(OPMODE),
        .CEA(CEA), .CEB(CEB), .CEC(CEC), .CED(CED),
        .CECARRYIN(CECARRYIN), .CEM(CEM), .CEOPMODE(CEOPMODE), .CEP(CEP),
        .RSTA(RSTA), .RSTB(RSTB), .RSTC(RSTC), .RSTD(RSTD),
        .RSTM(RSTM), .RSTOPMODE(RSTOPMODE), .RSTP(RSTP), .RSTCARRYIN(RSTCARRYIN),
        .PCIN(PCIN)
    );

integer i;
reg [47:0] past_P;
reg past_CARRYOUT;

initial begin
    CLK = 0;
    forever #5 CLK = ~CLK; 
end

task rst_check;
    begin
        RSTA = 1; RSTB = 1; RSTC = 1; RSTCARRYIN = 1; 
        RSTD = 1; RSTM = 1; RSTOPMODE = 1; RSTP = 1;

        A = $random; 
        B = $random; 
        D = $random; 
        BCIN = $random; 
        C = {$random, $random};       
        PCIN = {$random, $random};    
        CARRYIN = $random; 
        OPMODE = $random;

        @(posedge CLK);
        @(negedge CLK);

        if (P == 0 && M == 0 && BCOUT == 0 && PCOUT == 0 && CARRYOUT == 0 && CARRYOUTF == 0) begin
            $display("Time: %0t | SUCCESS: Reset Operation Verified.", $time);
        end else begin
            $display("Time: %0t | ERROR: Reset Operation Failed.", $time);
        end
        
        RSTA = 0; RSTB = 0; RSTC = 0; RSTCARRYIN = 0; 
        RSTD = 0; RSTM = 0; RSTOPMODE = 0; RSTP = 0;

        CEA = 1; CEB = 1; CEC = 1; CECARRYIN = 1; 
        CED = 1; CEM = 1; CEOPMODE = 1; CEP = 1;

        @(negedge CLK);
    end
endtask

task Path1_check;
    begin
        A = 20; 
        B = 10; 
        D = 25; 
        BCIN = $random; 
        C = 350;       
        PCIN = {$random, $random};    
        CARRYIN = $random; 
        OPMODE = 8'b11011101;

        @(posedge CLK); 
        for ( i = 0; i<4 ;i=i+1 ) begin
            @(negedge CLK);
        end

        // FIXED: Using actual Path 1 expected values
        if (P == 'h32 && PCOUT == 'h32 && M == 'h12c && BCOUT == 'hf && CARRYOUT == 0 && CARRYOUTF == 0) begin
            $display("Time: %0t | SUCCESS: Path 1 Verified.", $time);
        end else begin
            $display("Time: %0t | ERROR: Path 1 Failed.", $time);
        end
        @(negedge CLK);
    end
endtask

task Path2_check;
    begin
        A = 20; 
        B = 10; 
        D = 25; 
        BCIN = $random; 
        C = 350;       
        PCIN = {$random, $random};    
        CARRYIN = $random; 
        OPMODE = 8'b00010000;

        @(posedge CLK); 
        for ( i = 0; i<3 ;i=i+1 ) begin
            @(negedge CLK);
        end

        if (P == 0 && PCOUT == 0 && M == 'h2bc && BCOUT == 'h23 && CARRYOUT == 0 && CARRYOUTF == 0) begin
            $display("Time: %0t | SUCCESS: Path 2 Verified.", $time);
        end else begin
            $display("Time: %0t | ERROR: Path 2 Failed.", $time);
        end
        @(negedge CLK);
    end
endtask

task Path3_check;
    begin
        A = 20; 
        B = 10; 
        D = 25; 
        BCIN = $random; 
        C = 350;       
        PCIN = {$random, $random};    
        CARRYIN = $random; 
        OPMODE = 8'b00001010;

        past_P = P;
        past_CARRYOUT = CARRYOUT;

        @(posedge CLK); 
        for ( i = 0; i<3 ;i=i+1 ) begin
            @(negedge CLK);
        end

        // FIXED: Check current P against the saved past_P
        if (P == past_P && PCOUT == past_P && M == 'hc8 && BCOUT == 'ha && CARRYOUT == past_CARRYOUT && CARRYOUTF == past_CARRYOUT ) begin
            $display("Time: %0t | SUCCESS: Path 3 Verified.", $time);
        end else begin
            $display("Time: %0t | ERROR: Path 3 Failed.", $time);
        end
        @(negedge CLK);
    end
endtask

task Path4_check;
    begin
        A = 5; 
        B = 6; 
        D = 25; 
        BCIN = $random; 
        C = 350;       
        PCIN = 3000;    
        CARRYIN = $random; 
        OPMODE = 8'b10100111;

        @(posedge CLK); 
        for ( i = 0; i<3 ;i=i+1 ) begin
            @(negedge CLK);
        end

        if (P == 'hfe6fffec0bb1 && PCOUT == 'hfe6fffec0bb1 && M == 'h1e && BCOUT == 'h6 && CARRYOUT == 1 && CARRYOUTF == 1 ) begin
            $display("Time: %0t | SUCCESS: Path 4 Verified.", $time);
        end else begin
            $display("Time: %0t | ERROR: Path 4 Failed.", $time);
        end
        @(negedge CLK);
    end
endtask

initial begin
    rst_check();
    Path1_check();
    Path2_check();
    Path3_check();
    Path4_check();

end

endmodule