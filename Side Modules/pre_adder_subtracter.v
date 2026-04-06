module pre_adder_subtracer #(
    parameter WIDTH = 18
) (
    input [WIDTH - 1 : 0] in0,
    input [WIDTH - 1 : 0] in1,
    input add_sub,
    output reg [WIDTH - 1 : 0] out
);

always @(*) begin
    if (~add_sub) begin
        out = in0 + in1;
    end
    else begin
        out = in0 - in1;
    end
end

    
endmodule