/*
* Module: Execute Stage
* File Name: execute_stage.v
* Description: Instantiation of blocks in the Execute stage. 
* Author: Mohamed Elshafie
*/

module execute_stage (

    /************************ Input Ports ************************/
    input wire [31:0] E_RD1_E, E_RD2_E, E_Result_W, E_ALU_out_M, E_signImm_E,

    input wire [2:0] E_ALU_control_E,

    input wire [4:0] E_Rt_E, E_Rd_E,

    input wire E_ALUSrc_E, E_reg_dest_E,

    input wire [1:0] E_forwardA_E, E_forwardB_E,
    /************************ Output Ports ************************/
    output wire [31:0] E_writeData_E, E_ALU_out_E, 

    output wire [4:0] E_writeReg_E
);

/************************ Internal Signals ************************/
wire [31:0] srcA_E, srcB_E;

/************************ Code Start ************************/
ALU ALU1 ( //instantiation of the ALU.
    .srcA(srcA_E),
    .srcB(srcB_E),
    .control(E_ALU_control_E),
    .result(E_ALU_out_E)
);

mux4x1 #(.width(31)) M1 ( //instantiation of the mux.
    .in1(E_RD1_E),
    .in2(E_Result_W),
    .in3(E_ALU_out_M),
    .in4(32'd0),
    .sel(E_forwardA_E),
    .out(srcA_E)
);

mux4x1 #(.width(31)) M2 ( //instantiation of the mux.
    .in1(E_RD2_E),
    .in2(E_Result_W),
    .in3(E_ALU_out_M),
    .in4(32'd0),
    .sel(E_forwardB_E),
    .out(E_writeData_E)
);

mux #(.width(31)) mux_3 ( //instantiation of the mux.
    .in1(E_writeData_E),
    .in2(E_signImm_E),
    .sel(E_ALUSrc_E),
    .out(srcB_E)
);

mux #(.width(4)) mux_4 ( //instantiation of the mux.
    .in1(E_Rt_E),
    .in2(E_Rd_E),
    .sel(E_reg_dest_E),
    .out(E_writeReg_E)
);
endmodule