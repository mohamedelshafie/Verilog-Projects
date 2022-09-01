/*
* Module: Control Unit
* File Name: control_unit.v
* Description: computes the control signals based on the opcode and funct fields of the instruction.
* Author: Mohamed Elshafie
*/
module control_unit(

/************************ Input Ports ************************/
input  [5:0] op_code, funct,
//input wire zero,

/************************ Output Ports ************************/
output reg jump, memtoReg, memWrite, ALU_src, reg_dest, reg_write,branch,
output reg [2:0] ALU_control
//output wire PC_src
);
/************************ Internal Variables ************************/
reg [1:0] ALU_op;
//reg branch;

/************************ Parameters ************************/
parameter load_word = 6'b100011, store_word = 6'b101011, r_type = 6'b000000;
parameter add_immediate = 6'b001000, branch_if_equal = 6'b000100, jump_inst = 6'b000010;

parameter add = 6'b10_0000, sub = 6'b10_0010, slt = 6'b10_1010, mul = 6'b01_1100;
parameter and_alu = 6'b100100, or_alu = 6'b100101;

/************************ Code Start ************************/
//assign PC_src = branch & zero;

always @(*)begin

case(op_code) //generating different control signals based on the op code.
load_word:begin //in case of load word instruction
memtoReg <= 1;
ALU_src <= 1;
reg_write <= 1;
jump <= 0;
memWrite <= 0;
branch <= 0;
reg_dest <= 0;
ALU_op <= 2'b00;
end

store_word:begin //in case of store word instruction
memtoReg <= 1;
ALU_src <= 1;
reg_write <= 0;
jump <= 0;
memWrite <= 1;
branch <= 0;
reg_dest <= 0;
ALU_op <= 2'b00;
end

r_type:begin //in case of R-type instruction
memtoReg <= 0;
ALU_src <= 0;
reg_write <= 1;
jump <= 0;
memWrite <= 0;
branch <= 0;
reg_dest <= 1;
ALU_op <= 2'b10;
end

add_immediate:begin //in case of add immediate instruction
memtoReg <= 0;
ALU_src <= 1;
reg_write <= 1;
jump <= 0;
memWrite <= 0;
branch <= 0;
reg_dest <= 0;
ALU_op <= 2'b00;
end

branch_if_equal:begin //in case of branch instruction
memtoReg <= 0;
ALU_src <= 0;
reg_write <= 0;
jump <= 0;
memWrite <= 0;
branch <= 1;
reg_dest <= 0;
ALU_op <= 2'b01;
end

jump_inst:begin //in case of jump instruction
memtoReg <= 0;
ALU_src <= 0;
reg_write <= 0;
jump <= 1;
memWrite <= 0;
branch <= 0;
reg_dest <= 0;
ALU_op <= 2'b00;
end
default:begin //default case where no signals are generated.
memtoReg <= 0;
ALU_src <= 0;
reg_write <= 0;
jump <= 0;
memWrite <= 0;
branch <= 0;
reg_dest <= 0;
ALU_op <= 2'b00;
end
endcase
case(ALU_op) //generating the ALU control signals
2'b00:ALU_control <= 3'b010;
2'b01:ALU_control <= 3'b100;
2'b10:begin
case(funct)
add:ALU_control <= 3'b010;
sub:ALU_control <= 3'b100;
slt:ALU_control <= 3'b110;
mul:ALU_control <= 3'b101;
and_alu:ALU_control <= 3'b000;
or_alu:ALU_control <= 3'b001;
default: ALU_control = 3'b111;
endcase
end
default:ALU_control = 3'b111;
endcase
end

endmodule
