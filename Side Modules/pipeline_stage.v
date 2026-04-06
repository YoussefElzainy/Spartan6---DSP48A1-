module pipeline_stage #(
    parameter WIDTH = 18, // width of the input and the output
    parameter RSTTYPE = "SYNC" // default reset type is synchronous
) (
    input [WIDTH - 1 : 0] in,
    input clk, // clock signal 
    input clk_en, // clock enable
    input sel, // defines the number of pipelining stages 
    input rst, // reset
    output [WIDTH - 1 : 0] out
);

reg [WIDTH - 1 : 0] in_r;

// generate block according to the type of the reset (sync - async)
generate
    // synchronous reset
    if (RSTTYPE == "SYNC") begin
        always @(posedge clk) begin
            if (rst) begin
                in_r <= 0;
            end
            else begin
                if(clk_en)
                    in_r <= in;
            end
        end
    end
    // asynchronous reset
    else if (RSTTYPE == "ASYNC") begin
        always @(posedge clk or posedge rst) begin
            if (rst) begin
                in_r <= 0;
            end
            else begin
                if(clk_en)
                    in_r <= in; 
            end
        end
    end
endgenerate
    
    assign out = (sel)? in_r : in; 
    /*
        if the sel == 1 -> then there are pipeline stage -> out = in_r
        if the sel == 0 -> no pipeline stage -> out = in directly 
    */
endmodule