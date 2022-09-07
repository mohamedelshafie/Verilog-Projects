/*
* Module: Data Path
* File Name: data_path.v
* Description: Instantiation of blocks in the data path.
* Author: Mohamed Elshafie
*/

module data_path (
    
    /************************ Input Ports ************************/
    input  clk, reset, stall_F, stall_D, Jump_D, branch_D, forwardA_D, 
    input  RegWrite_D, MemtoReg_D, MemWrite_D, ALUSrc_D, RegDst_D, 
    input forwardB_D, flush_E, 
    input  [1:0] forwardA_E, forwardB_E, 
    input  [2:0] ALUControl_D,

    /************************ Output Ports ************************/
    output  [4:0] Rs_E_out, Rs_D_out, Rt_D_out, Rt_E_out, 
    output  [15:0] test_value,
    output  [4:0] WriteReg_W_out, writeReg_E_out, WriteReg_M_out,
    output  MemtoReg_E_wire, RegWrite_E_wire, RegWrite_M_wire, 
    output RegWrite_W_wire, MemtoReg_M_wire,
    output  [5:0] op_code, func
);

/************************ Internal Signals ************************/
wire [31:0] mux_out, mux_in1, mux_in2, PCPlus4_D_wire;
wire [31:0] instr_F_wire, instr_D_wire, Result_W_wire;
wire [31:0] ALU_out_M_wire, RD1_D_wire, RD2_D_wire, signImm_D_wire;
wire [31:0] signImm_E_wire, RD1_E_wire, RD2_E_wire;
wire [31:0] WriteData_E_wire, ALU_out_E_wire, WriteData_M_wire;
wire [31:0] read_data_M_wire, read_data_W_wire, ALUOut_W_wire;
wire [1:0] PC_src_D;
wire ALUSrc_E_wire, MemWrite_E_wire, MemWrite_M_wire;
wire MemtoReg_W_wire, RegDst_E_wire, clr_D;
wire [4:0] Rd_D_wire, Rd_E_wire;
wire [2:0] ALUControl_E_wire;
wire [4:0] Rs_E, Rs_D_wire, Rt_D_wire, Rt_E_wire;
wire [4:0] WriteReg_W_wire, writeReg_E_wire, WriteReg_M_wire;
/************************ Code Start ************************/
assign Rs_E_out = Rs_E;
assign Rs_D_out = Rs_D_wire;
assign Rt_D_out = Rt_D_wire;
assign Rt_E_out = Rt_E_wire;

assign WriteReg_W_out = WriteReg_W_wire;
assign writeReg_E_out = writeReg_E_wire;
assign WriteReg_M_out = WriteReg_M_wire;
assign op_code = instr_D_wire[31:26];
assign func = instr_D_wire[5:0];
// Fetch Stage :
mux4x1 #(.width(31)) M3 ( //instantiation of the mux.
    .in1(mux_in1),
    .in2(mux_in2), 
    .in3({PCPlus4_D_wire[31:28],instr_D_wire[25:0],2'b00}),
    .in4(32'd0),
    .sel(PC_src_D),
    .out(mux_out)
);

fetch_stage stage_1 (
    .clk(clk),
    .stall_F(stall_F),
    .reset(reset),
    .PC_in(mux_out),
    .F_instr_F(instr_F_wire),
    .F_PCPlus4_F(mux_in1)
);

// Decode Stage :
assign clr_D = PC_src_D[0] || PC_src_D[1];

decode_reg_pipe pipe_1 (
    .clr(clr_D),
    .clk(clk),
    .enable(stall_D),
    .reset(reset),
    .PCPlus4_F(mux_in1),
    .instr_F(instr_F_wire),
    .PCPlus4_D(PCPlus4_D_wire),
    .instr_D(instr_D_wire)
);

decode_stage stage_2 (
    .clk(clk),
    .reset(reset),
    .instr_D(instr_D_wire),
    .D_PCPlus4_D(PCPlus4_D_wire),
    .WD3_D(Result_W_wire),
    .ALU_out_M(ALU_out_M_wire),
    .A3_D(WriteReg_W_wire),
    .Jump_D(Jump_D),
    .branch_D(branch_D),
    .forwardA_D(forwardA_D),
    .forwardB_D(forwardB_D),
    .reg_write_W(RegWrite_W_wire),
    .PCbranch_D(mux_in2),
    .D_RD1_D(RD1_D_wire),
    .D_RD2_D(RD2_D_wire),
    
    .signImm_D_out(signImm_D_wire),
    .D_Rs_D(Rs_D_wire),
    .D_Rt_D(Rt_D_wire),
    .D_Rd_D(Rd_D_wire),
    .PC_src_D(PC_src_D)
);

// Execute Stage :
execute_reg_pipe pipe_2 (
    .clr(flush_E),
    .rst(reset),
    .clk(clk),
    .RegWrite_D(RegWrite_D),
    .MemtoReg_D(MemtoReg_D),
    .MemWrite_D(MemWrite_D),
    .ALUSrc_D(ALUSrc_D),
    .RegDst_D(RegDst_D),
    .ALUControl_D(ALUControl_D),
    .Rs_D(Rs_D_wire),
    .Rt_D(Rt_D_wire),
    .Rd_D(Rd_D_wire),
    .signImm_D(signImm_D_wire),
    .RD1_D(RD1_D_wire),
    .RD2_D(RD2_D_wire),
    .RegWrite_E(RegWrite_E_wire),
    .MemtoReg_E(MemtoReg_E_wire),
    .MemWrite_E(MemWrite_E_wire),
    .ALUSrc_E(ALUSrc_E_wire),
    .RegDst_E(RegDst_E_wire),
    .ALUControl_E(ALUControl_E_wire),
    .Rs_E(Rs_E),
    .Rt_E(Rt_E_wire),
    .Rd_E(Rd_E_wire),
    .signImm_E(signImm_E_wire),
    .RD1_E(RD1_E_wire),
    .RD2_E(RD2_E_wire)

);

execute_stage stage_3 (
    .E_RD1_E(RD1_E_wire),
    .E_RD2_E(RD2_E_wire),
    .E_Result_W(Result_W_wire),
    .E_ALU_out_M(ALU_out_M_wire),
    .E_signImm_E(signImm_E_wire),
    .E_ALU_control_E(ALUControl_E_wire),
    .E_Rt_E(Rt_E_wire),
    .E_Rd_E(Rd_E_wire),
    .E_ALUSrc_E(ALUSrc_E_wire),
    .E_forwardA_E(forwardA_E),
    .E_forwardB_E(forwardB_E),
    .E_reg_dest_E(RegDst_E_wire),
    .E_writeData_E(WriteData_E_wire),
    .E_ALU_out_E(ALU_out_E_wire),
    .E_writeReg_E(writeReg_E_wire)
);

// Memory Stage :
memory_reg_pipe pipe_3 (
    .clk(clk),
    .rst(reset),
    .RegWrite_E(RegWrite_E_wire),
    .MemtoReg_E(MemtoReg_E_wire),
    .MemWrite_E(MemWrite_E_wire),
    .ALUOut_E(ALU_out_E_wire),
    .WriteData_E(WriteData_E_wire),
    .WriteReg_E(writeReg_E_wire),
    .RegWrite_M(RegWrite_M_wire),
    .MemtoReg_M(MemtoReg_M_wire),
    .MemWrite_M(MemWrite_M_wire),
    .ALUOut_M(ALU_out_M_wire),
    .WriteData_M(WriteData_M_wire),
    .WriteReg_M(WriteReg_M_wire)

);

memory_stage stage_4 (
    .M_ALU_out_M(ALU_out_M_wire),
    .M_writeData_M(WriteData_M_wire),
    .clk(clk),
    .M_memWrite_M(MemWrite_M_wire),
    .M_read_data_M(read_data_M_wire),
    .M_test_value(test_value),
    .reset(reset)

);

// Write Back Stage :
writeBack_reg_pipe pipe_4 (
    .clk(clk),
    .rst(reset),
    .RegWrite_M(RegWrite_M_wire),
    .MemtoReg_M(MemtoReg_M_wire),
    .WriteReg_M(WriteReg_M_wire),
    .ReaData_M(read_data_M_wire),
    .ALUOut_M(ALU_out_M_wire),
    .RegWrite_W(RegWrite_W_wire),
    .MemtoReg_W(MemtoReg_W_wire),
    .WriteReg_W(WriteReg_W_wire),
    .ReaData_W(read_data_W_wire),
    .ALUOut_W(ALUOut_W_wire)

);

writeBack_stage stage_5 (
    .W_read_data_W(read_data_W_wire),
    .W_ALU_out_W(ALUOut_W_wire),
    .W_memtoReg_W(MemtoReg_W_wire),
    .W_Result_W(Result_W_wire)

);
endmodule