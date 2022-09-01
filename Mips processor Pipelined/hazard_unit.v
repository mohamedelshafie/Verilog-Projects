/*
* Module: Program Counter
* File Name: hazard_unit.v
* Description: Unit updated at the rising edge of the clock. Contains the address of the instruction to execute. 
* Author: Mohamed Elshafie
*/

module hazard_unit (
    /************************ Input Ports ************************/
    input  [4:0] Rs_D, Rt_D, Rs_E, Rt_E, writeReg_E, writeReg_M, writeReg_W,
    
    input  branch_D, MemtoReg_E, memtoReg_M, reg_write_E, reg_write_M, reg_write_W, Jump_D,

    /************************ Output Ports ************************/
    output  stall_F, stall_D, flush_E, forwardA_D, forwardB_D,

    output reg [1:0] forwardA_E, forwardB_E
);


/************************ Internal Signals ************************/
wire Lw_stall, branch_stall;


/************************ Code Start ************************/

assign Lw_stall = ((Rs_D == Rt_E) || (Rt_D == Rt_E)) && MemtoReg_E;

assign branch_stall = (branch_D & reg_write_E & ((writeReg_E == Rs_D) | (writeReg_E == Rt_D))) | (branch_D & memtoReg_M & ((writeReg_M == Rs_D) | (writeReg_M == Rt_D)));

assign stall_F = Lw_stall || branch_stall;

assign stall_D = Lw_stall || branch_stall;

assign flush_E = Lw_stall || branch_stall || Jump_D;

assign forwardA_D = (Rs_D != 5'd0) && (Rs_D == writeReg_M) && reg_write_M;

assign forwardB_D = (Rt_D != 5'd0) && (Rt_D == writeReg_M) && reg_write_M;

always @ (*)begin
    if((Rs_E != 5'd0) && (Rs_E == writeReg_M) && reg_write_M) forwardA_E = 2'b10;

    else if((Rs_E != 5'd0) && (Rs_E == writeReg_W) && reg_write_W) forwardA_E = 2'b01;

    else forwardA_E = 2'b00;
end

always @ (*)begin
    if((Rt_E != 5'd0) && (Rt_E == writeReg_M) && reg_write_M) forwardB_E = 2'b10;

    else if((Rt_E != 5'd0) && (Rt_E == writeReg_W) && reg_write_W) forwardB_E = 2'b01;

    else forwardB_E = 2'b00;
end

endmodule

