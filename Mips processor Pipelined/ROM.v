/*
* Module: Instruction Memory (ROM)
* File Name: ROM.v
* Description: The instruction memory reads out, or fetches, the 32-bit instruction.
* Author: Mohamed Elshafie
*/
module ROM(
/************************ Input Ports ************************/
input wire [31:0] A,

/************************ Output Ports ************************/
output reg [31:0] RD

);
/************************ Internal Variables ************************/
reg [31:0] memory [0:1023];


/************************ Code Start ************************/
initial begin
    $readmemh("Program 1_GCD_of_two_numbers.txt",memory); //reading file that contains the program.
end

always @ (*)begin

RD = memory[A>>2]; //read from the memory


end

endmodule
