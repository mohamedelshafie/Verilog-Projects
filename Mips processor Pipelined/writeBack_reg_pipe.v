/*
* Module: Write Back stage pipeline register
* File Name: writeBack_reg_pipe.v
* Description: Register to sparate between memory & writeBack stages.
* Author: Mohamed Elshafie
*/
module writeBack_reg_pipe(
    /************************ Input Ports ************************/

    input wire clk,rst,

    input wire RegWrite_M, MemtoReg_M,

    input wire [4:0] WriteReg_M,

    input wire [31:0] ReaData_M, ALUOut_M,

    /************************ Output Ports ************************/

    output reg RegWrite_W, MemtoReg_W,

    output reg [4:0] WriteReg_W,

    output reg [31:0] ReaData_W, ALUOut_W
);

/************************ Code Start ************************/
always @ (posedge clk or negedge rst)begin
    if(!rst)begin
        RegWrite_W <=1'd0;
        MemtoReg_W <=1'd0;
        WriteReg_W <=5'd0;
        ReaData_W <=32'd0;
        ALUOut_W <=32'd0;
    end
    else begin
        RegWrite_W <= RegWrite_M;
        MemtoReg_W <= MemtoReg_M;
        WriteReg_W <= WriteReg_M;
        ReaData_W <= ReaData_M;
        ALUOut_W <= ALUOut_M;

    end
end


endmodule