/*
* Module: Data Memory (RAM)
* File Name: RAM.v
* Description: The data memory is a RAM that provides a store for the CPU to load from and store to.
* Author: Mohamed Elshafie
*/
module RAM(
/************************ Input Ports ************************/
input wire [31:0] A,WD,
input wire WE,clk,reset,

/************************ Output Ports ************************/
output reg [31:0] RD,
output reg [15:0] test


);
/************************ Internal Variables ************************/
reg [31:0] ram [0:1023];
integer i;

/************************ Code Start ************************/
always @(posedge clk)begin

if(reset == 0)begin //check if reset signal is active low

for(i=0;i<100;i=i+1) ram[i] = 32'd0; //reset the whole memory, one entry at a time.
end
else if(WE == 1'b1)begin //check if write Enable signal is high.
ram[A] = WD; //write to the memory
end
end

always @ (*)begin
RD = ram[A]; //read from the memory

end
always @ (*)begin
test = ram[0]; //read the test value from the first entry in the memory
end
endmodule
