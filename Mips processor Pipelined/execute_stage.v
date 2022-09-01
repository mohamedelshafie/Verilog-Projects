/*
* Module: Program Counter
* File Name: execute_stage.v
* Description: Unit updated at the rising edge of the clock. Contains the address of the instruction to execute. 
* Author: Mohamed Elshafie
*/

module execute_stage (

    /************************ Input Ports ************************/
    input wire [31:0] RD1_E, RD2_E, Result_W, ALU_out_M, signImm_E,

    input wire [2:0] ALU_control_E,

    input wire [4:0] Rt_E, Rd_E,

    input wire ALUSrc_E, reg_dest_E,

    input wire [1:0] forwardA_E, forwardB_E,
    /************************ Output Ports ************************/
    output wire [31:0] writeData_E, ALU_out_E, 

    output wire [4:0] writeReg_E
);

/************************ Internal Signals ************************/
wire [31:0] srcA_E, srcB_E;

/************************ Code Start ************************/
ALU ALU1 ( //instantiation of the ALU.
    .srcA(srcA_E),
    .srcB(srcB_E),
    .control(ALU_control_E),
    .result(ALU_out_E)
);

mux4x1 #(.width(31)) M1 (
    .in1(RD1_E),
    .in2(Result_W),
    .in3(ALU_out_M),
    .in4(32'd0),
    .sel(forwardA_E),
    .out(srcA_E)
);

mux4x1 #(.width(31)) M2 (
    .in1(RD2_E),
    .in2(Result_W),
    .in3(ALU_out_M),
    .in4(32'd0),
    .sel(forwardB_E),
    .out(writeData_E)
);

mux #(.width(31)) mux_3 (
    .in1(writeData_E),
    .in2(signImm_E),
    .sel(ALUSrc_E),
    .out(srcB_E)
);

mux #(.width(4)) mux_4 (
    .in1(Rt_E),
    .in2(Rd_E),
    .sel(reg_dest_E),
    .out(writeReg_E)
);
endmodule