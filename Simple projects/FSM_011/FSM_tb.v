`timescale 1ns/1ns
module FSM_011_tb;
// Inputs
reg clk;
reg in;
// Outputs
wire out;
// Instantiate the Unit Under Test (UUT)
FSM_011 uut (
.clk(clk), 
.in(in), 
.out(out)
);
initial begin
clk = 0;
in = 0;
#150
in=0;
#100;
 in=1;
#100;
 in=0;
#100;
 in=0;
#100;
 in=1;
#100;
in=1;
#100;
in=0;
#100;
 in=1;
#100;
in=1;
end
always begin
#50 clk=~clk;
end      
endmodule
