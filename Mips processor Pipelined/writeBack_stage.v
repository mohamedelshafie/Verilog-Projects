/*
* Module: Program Counter
* File Name: writeBack_stage.v
* Description: Unit updated at the rising edge of the clock. Contains the address of the instruction to execute. 
* Author: Mohamed Elshafie
*/

module writeBack_stage(

    /************************ Input Ports ************************/
    input wire [31:0] read_data_W, ALU_out_W,

    input wire memtoReg_W,

    /************************ Output Ports ************************/
    output wire [31:0] Result_W
);


/************************ Code Start ************************/
mux #(.width(31)) mux_4 (
    .in1(ALU_out_W),
    .in2(read_data_W),
    .sel(memtoReg_W),
    .out(Result_W)
);

endmodule