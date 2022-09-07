/*
* Module: Control Unit
* File Name: control_unit.v
* Description: computes the control signals based on the opcode and funct fields of the instruction.
* Author: Mohamed Elshafie
*/
module control_unit(

/************************ Input Ports ************************/
input  [5:0] C_op_code, C_funct,
//input wire zero,

/************************ Output Ports ************************/
output reg C_jump, C_memtoReg, C_memWrite, C_ALU_src, C_reg_dest, C_reg_write, C_branch,
output reg [2:0] C_ALU_control
//output wire PC_src
);
/************************ Internal Variables ************************/
reg [1:0] C_ALU_op;
//reg branch;

/************************ Parameters ************************/
parameter load_word = 6'b100011, store_word = 6'b101011, r_type = 6'b000000;
parameter add_immediate = 6'b001000, branch_if_equal = 6'b000100, jump_inst = 6'b000010;

parameter add = 6'b10_0000, sub = 6'b10_0010, slt = 6'b10_1010, mul = 6'b01_1100;
parameter and_alu = 6'b100100, or_alu = 6'b100101;

/************************ Code Start ************************/
//assign PC_src = branch & zero;

always @(*)begin

case(C_op_code) //generating different control signals based on the op code.
load_word:begin //in case of load word instruction
C_memtoReg <= 1;
C_ALU_src <= 1;
C_reg_write <= 1;
C_jump <= 0;
C_memWrite <= 0;
C_branch <= 0;
C_reg_dest <= 0;
C_ALU_op <= 2'b00;
end

store_word:begin //in case of store word instruction
C_memtoReg <= 1;
C_ALU_src <= 1;
C_reg_write <= 0;
C_jump <= 0;
C_memWrite <= 1;
C_branch <= 0;
C_reg_dest <= 0;
C_ALU_op <= 2'b00;
end

r_type:begin //in case of R-type instruction
C_memtoReg <= 0;
C_ALU_src <= 0;
C_reg_write <= 1;
C_jump <= 0;
C_memWrite <= 0;
C_branch <= 0;
C_reg_dest <= 1;
C_ALU_op <= 2'b10;
end

add_immediate:begin //in case of add immediate instruction
C_memtoReg <= 0;
C_ALU_src <= 1;
C_reg_write <= 1;
C_jump <= 0;
C_memWrite <= 0;
C_branch <= 0;
C_reg_dest <= 0;
C_ALU_op <= 2'b00;
end

branch_if_equal:begin //in case of branch instruction
C_memtoReg <= 0;
C_ALU_src <= 0;
C_reg_write <= 0;
C_jump <= 0;
C_memWrite <= 0;
C_branch <= 1;
C_reg_dest <= 0;
C_ALU_op <= 2'b01;
end

jump_inst:begin //in case of jump instruction
C_memtoReg <= 0;
C_ALU_src <= 0;
C_reg_write <= 0;
C_jump <= 1;
C_memWrite <= 0;
C_branch <= 0;
C_reg_dest <= 0;
C_ALU_op <= 2'b00;
end
default:begin //default case where no signals are generated.
C_memtoReg <= 0;
C_ALU_src <= 0;
C_reg_write <= 0;
C_jump <= 0;
C_memWrite <= 0;
C_branch <= 0;
C_reg_dest <= 0;
C_ALU_op <= 2'b00;
end
endcase
case(C_ALU_op) //generating the ALU control signals
2'b00:C_ALU_control <= 3'b010;
2'b01:C_ALU_control <= 3'b100;
2'b10:begin
case(C_funct)
add:C_ALU_control <= 3'b010;
sub:C_ALU_control <= 3'b100;
slt:C_ALU_control <= 3'b110;
mul:C_ALU_control <= 3'b101;
and_alu:C_ALU_control <= 3'b000;
or_alu:C_ALU_control <= 3'b001;
default: C_ALU_control = 3'b111;
endcase
end
default:C_ALU_control = 3'b111;
endcase
end

endmodule
