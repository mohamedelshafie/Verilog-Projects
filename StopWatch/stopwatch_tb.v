`timescale 1ns / 1ps
module stop_tb();
	// Inputs
	reg clock;
	reg reset;
	reg start;

	// Outputs
	wire a;
	wire b;
	wire c;
	wire d;
	wire e;
	wire f;
	wire g;
	wire dp;
	wire [3:0] an;

	// Instantiate the Unit Under Test (UUT)
	stopwatch dut (
		.clock(clock), 
		.reset(reset), 
		.start(start), 
		.a(a), 
		.b(b), 
		.c(c), 
		.d(d), 
		.e(e), 
		.f(f), 
		.g(g), 
		.dp(dp), 
		.an(an)
	);

initial
  begin
   clock = 0;
    forever
     #10 clock = ~clock;
  end

 initial begin
  // Initialize Inputs
  reset = 0;
  start = 1;

  // Wait 100 ns for global reset to finish
 end
endmodule