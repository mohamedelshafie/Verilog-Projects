/*
* Module: Register File
* File Name: reg_file.v
* Description: The Register File contains the 32 32-bit MIPS registers.
* Author: Mohamed Elshafie
*/
module reg_file(
/************************ Input Ports ************************/
input wire [4:0] A1,A2,A3,
input wire [31:0] WD3,
input wire clk,WE3,reset,

/************************ Output Ports ************************/
output reg [31:0] RD1,RD2

);
/************************ Internal Variables ************************/
reg [31:0] register [0:31];
integer i;

/************************ Code Start ************************/
always @ (negedge clk or negedge reset)begin

if(reset == 0)begin //check if reset signal is active low

for(i=0;i<32;i=i+1) register[i] <= 32'd0; //reset the whole register file, register by register.

end

else if(WE3 ==1)begin //check if write Enable signal is high.

register[A3] <= WD3; //write to the register file

end

end

always @ (*)fork //read from register file at two ports at the same time.

RD1 = register[A1];
RD2 = register[A2];

join
endmodule
