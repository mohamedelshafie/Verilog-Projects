/*
* Module: Program Counter
* File Name: PC.v
* Description: Unit updated at the rising edge of the clock. Contains the address of the instruction to execute. 
* Author: Mohamed Elshafie
*/
module PC(
/************************ Input Ports ************************/
input wire [31:0] in,
input wire reset,clk,

/************************ Output Ports ************************/
output reg [31:0] out
);

/************************ Code Start ************************/
always @ (posedge clk or negedge reset)begin

if(!reset)out <= 32'd0; //check if reset signal is active low
else out <= in;

end

endmodule

