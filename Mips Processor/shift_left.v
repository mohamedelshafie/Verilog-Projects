/*
* Module: Shift Left
* File Name: shift_left.v
* Description: shift the input to the left twice
* Author: Mohamed Elshafie
*/
module shift_left #(parameter width =31)
(
/************************ Input Ports ************************/
input wire [width:0] in,

/************************ Output Ports ************************/
output reg [width:0] out

);

/************************ Code Start ************************/
always @ (*)begin
out = in<<2; //output is the input but shifted left by 2 
end
endmodule
