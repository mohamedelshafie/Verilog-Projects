module mux #(parameter width = 31)
(

input wire [width:0] in1,in2,

input wire sel,

output reg [width:0] out

);

always @ (*)begin
case (sel)
1'b0: out = in1;
1'b1: out = in2;
endcase
end
endmodule
