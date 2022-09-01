/*
* Module: Adder
* File Name: adder.v
* Description: adds two 32-bit data inputs and produces the 32-bit output.
* Author: Mohamed Elshafie
*/
/*
* This is a simple combination block. It is an adder block that adds two 32-bit data inputs 
* to each other (A and B) and produces the output to the 32-bit port C.
*/
module adder(
/************************ Input Ports ************************/
input wire [31:0] A,B,

/************************ Output Ports ************************/
output reg [31:0] C

);

/************************ Code Start ************************/
always @ (*)begin
C = A + B; //simple addition of two numbers
end
endmodule
