/*
* Module: Sign Extention
* File Name: Sign_Extend.v
* Description: copies the sign bit of a short input into all of the upper bits of the longer output.
* Author: Mohamed Elshafie
*/
module sign_extend(
/************************ Input Ports ************************/
input wire [15:0] instr,

/************************ Output Ports ************************/
output reg [31:0] signImm


);

/************************ Code Start ************************/
always @(*)begin
if(instr[15]==1'b0) //check on the MSB of the instruction
signImm={ {16{1'b0} },instr}; //if the number is positive
else 
signImm={ {16{1'b1} },instr}; //if the number is negative
end
endmodule

