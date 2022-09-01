/*
* Module: 4x1 Multiplexer
* File Name: mux4x1.v
* Description: parameterized 4X1 MUX.
* Author: Mohamed Elshafie
*/

module mux4x1 #(parameter width = 31)
(

/************************ Input Ports ************************/
input wire [width:0] in1,in2,in3,in4,

input wire [1:0] sel,

/************************ Output Ports ************************/
output reg [width:0] out

);

/************************ Code Start ************************/

always @ (*)begin
case (sel)
2'b00: out = in1; //select first input if selection line has 00 on it
2'b01: out = in2; //select second input if selection line has 01 on it
2'b10: out = in3; //select third input if selection line has 10 on it
2'b11: out = in4; //select fourth input if selection line has 11 on it
endcase
end


endmodule
