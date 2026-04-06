module Post_adder_substracter (in0,in1,cin,add_sub,out,cout);
    input [47:0]in0,in1;
    input add_sub,cin;
    output reg [47:0]out;
    output reg cout;
    always @(*) begin
        
        if(~add_sub)
            {cout,out} = in0 +(in1+cin);
       
        else
            {cout,out} = in0 -(in1+cin);
    end
endmodule