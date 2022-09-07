/*
* Module: Fetch Stage
* File Name: fetch_stage.v
* Description: Instantiation of blocks in the Fetch stage. 
* Author: Mohamed Elshafie
*/

module fetch_stage (

    /************************ Input Ports ************************/
    input wire clk, stall_F, reset,
    input wire [31:0] PC_in,

    /************************ Output Ports ************************/
    output wire [31:0] F_instr_F, F_PCPlus4_F
);

/************************ Internal Signals ************************/
wire [31:0] PC_out;


/************************ Code Start ************************/
PC PC_1 ( //instantiation of the program counter.

    .in(PC_in),
    .reset(reset),
    .clk(clk),
    .enable(stall_F),
    .out(PC_out)
);

ROM IM_1 ( //instantiation of the ROM.
    .A(PC_out),
    .RD(F_instr_F)
);

adder adder_1 ( //instantiation of the adder.
    .A_1(PC_out),
    .B_2(32'd4),
    .C_3(F_PCPlus4_F)
);


endmodule




