/*
* Module: Memory stage pipeline register
* File Name: memory_reg_pipe.v
* Description: Register to sparate between execute & memory stages.
* Author: Mohamed Elshafie
*/

module memory_reg_pipe(

    /************************ Input Ports ************************/
    input wire clk,rst,

    input wire RegWrite_E, MemtoReg_E, MemWrite_E,

    input wire [31:0] ALUOut_E, WriteData_E,

    input wire [4:0] WriteReg_E,

    /************************ Output Ports ************************/
    output reg RegWrite_M, MemtoReg_M, MemWrite_M,

    output reg [31:0] ALUOut_M, WriteData_M,

    output reg [4:0] WriteReg_M
);

/************************ Code Start ************************/
always @ (posedge clk or negedge rst)begin
    if(!rst)begin
        RegWrite_M <= 1'd0;
        MemtoReg_M <= 1'd0;
        MemWrite_M <= 1'd0;
        ALUOut_M <= 32'd0;
        WriteData_M <= 32'd0;
        WriteReg_M <= 5'd0;
    end
    else begin
        RegWrite_M <= RegWrite_E;
        MemtoReg_M <= MemtoReg_E;
        MemWrite_M <= MemWrite_E;
        ALUOut_M <= ALUOut_E;
        WriteData_M <= WriteData_E;
        WriteReg_M <= WriteReg_E;
    end
end

endmodule