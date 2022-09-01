/*
* Module: Decode stage pipeline register
* File Name: decode_reg_pipe.v
* Description: Register to sparate between fetch & decode stages. 
* Author: Mohamed Elshafie
*/

module decode_reg_pipe(
    /************************ Input Ports ************************/
    input wire clr,clk,enable,reset,
    input wire [31:0] PCPlus4_F, instr_F,
    /************************ Output Ports ************************/
    output reg [31:0] PCPlus4_D, instr_D
);

/************************ Code Start ************************/
always @ (posedge clk or negedge reset)begin
    if(!reset) begin
        PCPlus4_D <= 32'd0;
        instr_D <= 32'd0;
    end
    else if((clr==1'b1) && !enable)begin
        PCPlus4_D <= 32'd0;
        instr_D <= 32'd0;
    end
    else if(!enable) begin
            PCPlus4_D <= PCPlus4_F;
            instr_D <= instr_F;
    end
end



endmodule