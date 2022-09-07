/*
* Module: Execute stage pipeline register
* File Name: execute_reg_pipe.v
* Description: Register to sparate between decode & execute stages.
* Author: Mohamed Elshafie
*/

module execute_reg_pipe (

    /************************ Input Ports ************************/
    input wire clr,rst,clk,

    input wire RegWrite_D, MemtoReg_D, MemWrite_D, ALUSrc_D, RegDst_D,

    input wire [2:0] ALUControl_D,

    input wire [4:0] Rs_D, Rt_D, Rd_D,

    input wire [31:0] signImm_D,

    input wire [31:0] RD1_D, RD2_D,

    /************************ Output Ports ************************/
    output reg RegWrite_E, MemtoReg_E, MemWrite_E, ALUSrc_E, RegDst_E,

    output reg [2:0] ALUControl_E,

    output reg [4:0] Rs_E, Rt_E, Rd_E,

    output reg [31:0] signImm_E,

    output reg [31:0] RD1_E, RD2_E
);

/************************ Code Start ************************/
always @ (posedge clk or negedge rst)begin
    if(!rst)begin
        RegWrite_E <= 1'd0;
        MemtoReg_E <= 1'd0;
        MemWrite_E <= 1'd0;
        ALUSrc_E <= 1'd0;
        RegDst_E <= 1'd0;
        ALUControl_E <= 3'd0;
        Rs_E <= 5'd0;
        Rt_E <= 5'd0;
        Rd_E <= 5'd0;
        signImm_E <= 32'd0;
        RD1_E <= 32'd0;
        RD2_E <= 32'd0;
    end
    else if(clr == 1'b1)begin
        RegWrite_E <= 1'd0;
        MemtoReg_E <= 1'd0;
        MemWrite_E <= 1'd0;
        ALUSrc_E <= 1'd0;
        RegDst_E <= 1'd0;
        ALUControl_E <= 3'd0;
        Rs_E <= 5'd0;
        Rt_E <= 5'd0;
        Rd_E <= 5'd0;
        signImm_E <= 32'd0;
        RD1_E <= 32'd0;
        RD2_E <= 32'd0;
    end
    else begin
        RegWrite_E <= RegWrite_D;
        MemtoReg_E <= MemtoReg_D;
        MemWrite_E <= MemWrite_D;
        ALUSrc_E <= ALUSrc_D;
        RegDst_E <= RegDst_D;
        ALUControl_E <= ALUControl_D;
        Rs_E <= Rs_D;
        Rt_E <= Rt_D;
        Rd_E <= Rd_D;
        signImm_E <= signImm_D;
        RD1_E <= RD1_D;
        RD2_E <= RD2_D;
    end
end

endmodule




