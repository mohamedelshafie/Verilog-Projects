/*
* Module: MIPS Pipelined Processor
* File Name: MIPS_Pipe.v
* Description: Instantiation of blocks in the MIPS Pipelined Processor.
* Author: Mohamed Elshafie
*/


module MIPS_Pipe (

    /************************ Input Ports ************************/
    input  clk, reset,
    /************************ Output Ports ************************/
    output  [15:0] test_value
);
    
/************************ Internal Signals ************************/
wire stall_F_wire, stall_D_wire, flush_E_wire;
wire forwardA_D_wire, forwardB_D_wire;
wire [1:0] forwardA_E_wire, forwardB_E_wire;
wire [4:0] Rs_D_wire, Rt_D_wire, Rs_E_wire, Rt_E_wire;
wire [4:0] WriteReg_W_wire, writeReg_E_wire, WriteReg_M_wire;
wire RegWrite_E_wire, RegWrite_M_wire, RegWrite_W_wire, MemtoReg_M_wire;
wire [5:0] op_code_wire, funct_wire;
wire jump_wire, memtoReg_wire, memWrite_wire, MemtoReg_E_wire;
wire ALU_src_wire, reg_dest_wire, reg_write_wire, branch_wire;
wire [2:0] ALU_control_wire;
/************************ Code Start ************************/
control_unit unit_1 (
    .C_op_code(op_code_wire),
    .C_funct(funct_wire),
    .C_jump(jump_wire),
    .C_memtoReg(memtoReg_wire),
    .C_memWrite(memWrite_wire),
    .C_ALU_src(ALU_src_wire),
    .C_reg_dest(reg_dest_wire),
    .C_reg_write(reg_write_wire),
    .C_ALU_control(ALU_control_wire),
    .C_branch(branch_wire)

);

data_path unit_2 (
    .clk(clk),
    .reset(reset),
    .stall_F(stall_F_wire),
    .stall_D(stall_D_wire),
    .Jump_D(jump_wire),
    .branch_D(branch_wire),
    .forwardA_D(forwardA_D_wire),
    .forwardB_D(forwardB_D_wire),
    .RegWrite_D(reg_write_wire),
    .MemtoReg_D(memtoReg_wire),
    .MemWrite_D(memWrite_wire),
    .ALUSrc_D(ALU_src_wire),
    .RegDst_D(reg_dest_wire),
    .flush_E(flush_E_wire),
    .forwardA_E(forwardA_E_wire),
    .forwardB_E(forwardB_E_wire),
    .ALUControl_D(ALU_control_wire),
    .Rs_E_out(Rs_E_wire),
    .Rs_D_out(Rs_D_wire),
    .Rt_D_out(Rt_D_wire),
    .Rt_E_out(Rt_E_wire),
    .test_value(test_value),
    .WriteReg_W_out(WriteReg_W_wire),
    .writeReg_E_out(writeReg_E_wire),
    .WriteReg_M_out(WriteReg_M_wire),
    .MemtoReg_E_wire(MemtoReg_E_wire),
    .RegWrite_E_wire(RegWrite_E_wire),
    .RegWrite_M_wire(RegWrite_M_wire),
    .RegWrite_W_wire(RegWrite_W_wire),
    .MemtoReg_M_wire(MemtoReg_M_wire),
    .op_code(op_code_wire),
    .func(funct_wire)

);

hazard_unit unit_3 (
    .Rs_D(Rs_D_wire),
    .Rt_D(Rt_D_wire),
    .Rs_E(Rs_E_wire),
    .Rt_E(Rt_E_wire),
    .writeReg_E(writeReg_E_wire),
    .writeReg_M(WriteReg_M_wire),
    .writeReg_W(WriteReg_W_wire),
    .H_branch_D(branch_wire),
    .MemtoReg_E(MemtoReg_E_wire),
    .memtoReg_M(MemtoReg_M_wire),
    .reg_write_E(RegWrite_E_wire),
    .reg_write_M(RegWrite_M_wire),
    .reg_write_W(RegWrite_W_wire),
    .H_stall_F(stall_F_wire),
    .H_stall_D(stall_D_wire),
    .H_flush_E(flush_E_wire),
    .H_forwardA_D(forwardA_D_wire),
    .H_forwardB_D(forwardB_D_wire),
    .H_forwardA_E(forwardA_E_wire),
    .H_forwardB_E(forwardB_E_wire),
    .H_Jump_D(jump_wire)
);


endmodule