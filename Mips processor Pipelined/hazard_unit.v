/*
* Module: Hazard Unit
* File Name: hazard_unit.v
* Description: Unit used to deal with Data & Control Hazards.
* Author: Mohamed Elshafie
*/

module hazard_unit (
    /************************ Input Ports ************************/
    input  [4:0] Rs_D, Rt_D, Rs_E, Rt_E, writeReg_E, writeReg_M, writeReg_W,
    
    input  H_branch_D, MemtoReg_E, memtoReg_M, reg_write_E, reg_write_M, reg_write_W, H_Jump_D,

    /************************ Output Ports ************************/
    output  H_stall_F, H_stall_D, H_flush_E, H_forwardA_D, H_forwardB_D,

    output reg [1:0] H_forwardA_E, H_forwardB_E
);


/************************ Internal Signals ************************/
wire Lw_stall, branch_stall;


/************************ Code Start ************************/

assign Lw_stall = ((Rs_D == Rt_E) || (Rt_D == Rt_E)) && MemtoReg_E;

assign branch_stall = (H_branch_D & reg_write_E & ((writeReg_E == Rs_D) | (writeReg_E == Rt_D))) | (H_branch_D & memtoReg_M & ((writeReg_M == Rs_D) | (writeReg_M == Rt_D)));

assign H_stall_F = Lw_stall || branch_stall;

assign H_stall_D = Lw_stall || branch_stall;

assign H_flush_E = Lw_stall || branch_stall || H_Jump_D;

assign H_forwardA_D = (Rs_D != 5'd0) && (Rs_D == writeReg_M) && reg_write_M;

assign H_forwardB_D = (Rt_D != 5'd0) && (Rt_D == writeReg_M) && reg_write_M;

always @ (*)begin
    if((Rs_E != 5'd0) && (Rs_E == writeReg_M) && reg_write_M) H_forwardA_E = 2'b10;

    else if((Rs_E != 5'd0) && (Rs_E == writeReg_W) && reg_write_W) H_forwardA_E = 2'b01;

    else H_forwardA_E = 2'b00;
end

always @ (*)begin
    if((Rt_E != 5'd0) && (Rt_E == writeReg_M) && reg_write_M) H_forwardB_E = 2'b10;

    else if((Rt_E != 5'd0) && (Rt_E == writeReg_W) && reg_write_W) H_forwardB_E = 2'b01;

    else H_forwardB_E = 2'b00;
end

endmodule

