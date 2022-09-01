/*
* Module: Program Counter
* File Name: fetch_stage.v
* Description: Unit updated at the rising edge of the clock. Contains the address of the instruction to execute. 
* Author: Mohamed Elshafie
*/

module fetch_stage (

    /************************ Input Ports ************************/
    input wire clk, stall_F, reset,
    input wire [31:0] PC_in,

    /************************ Output Ports ************************/
    output wire [31:0] instr_F, PCPlus4_F
);

/************************ Internal Signals ************************/
wire [31:0] PC_out;


/************************ Code Start ************************/
PC PC_1 (

    .in(PC_in),
    .reset(reset),
    .clk(clk),
    .enable(stall_F),
    .out(PC_out)
);

ROM IM_1 (
    .A(PC_out),
    .RD(instr_F)
);

adder adder_1 (
    .A(PC_out),
    .B(32'd4),
    .C(PCPlus4_F)
);


endmodule




