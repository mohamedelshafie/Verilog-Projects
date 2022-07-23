`timescale 10ns / 1ns
module trafic_light_tb;
	reg clk;
	reg rst;
	wire [2:0] a;
	wire [2:0] b;
	trafic uut (
		.clk(clk), 
		.rst(rst), 
		.a(a), 
		.b(b)
	);
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
	end
always begin
#50000000 clk=~clk;
end      
endmodule
