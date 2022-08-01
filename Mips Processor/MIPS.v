/*
* Module: MIPS Processor
* File Name: MIPS.v
* Description: Instantiation of the datapath, control unit, RAM, and the ROM to construct the MIPS processor.
* Author: Mohamed Elshafie
*/
module MIPS(
/************************ Input Ports ************************/
input clk, reset,

/************************ Output Ports ************************/
output [15:0] test_value


);
/************************ Internal Variables ************************/
wire memWrite_wire, memtoReg_wire, jump_wire, ALU_src_wire, reg_write_wire, reg_dest_wire, zero_wire, PC_src_wire;
wire [31:0] PC_wire, ALU_out_wire, write_data_wire, RAM_RD_wire, ROM_RD_wire;
wire [2:0] ALU_control_wire;


/************************ Code Start ************************/
control_unit control_unit1 ( //Instantiation of the control unit.
.op_code(ROM_RD_wire[31:26]),
.funct(ROM_RD_wire[5:0]),
.zero(zero_wire),
.jump(jump_wire),
.memtoReg(memtoReg_wire),
.memWrite(memWrite_wire),
.ALU_src(ALU_src_wire),
.reg_dest(reg_dest_wire),
.reg_write(reg_write_wire),
.ALU_control(ALU_control_wire),
.PC_src(PC_src_wire));

data_path data_path1( //Instantiation of the data path block.
.clk(clk),
.reset(reset),
.instr(ROM_RD_wire),
.read_data(RAM_RD_wire),
.jump(jump_wire),
.PC_src(PC_src_wire),
.memtoReg(memtoReg_wire),
.ALU_src(ALU_src_wire),
.reg_dest(reg_dest_wire),
.reg_write(reg_write_wire),
.ALU_control(ALU_control_wire),
.PC(PC_wire),
.ALU_out(ALU_out_wire),
.write_data(write_data_wire),
.zero(zero_wire));

RAM RAM1 ( //Instantiation of the RAM block.
.A(ALU_out_wire),
.WD(write_data_wire),
.WE(memWrite_wire),
.clk(clk),
.reset(reset),
.RD(RAM_RD_wire),
.test(test_value));

ROM ROM1 ( //Instantiation of the ROM block.
.A(PC_wire),
.RD(ROM_RD_wire));

endmodule
