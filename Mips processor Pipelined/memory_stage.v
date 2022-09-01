/*
* Module: Program Counter
* File Name: memory_stage.v
* Description: Unit updated at the rising edge of the clock. Contains the address of the instruction to execute. 
* Author: Mohamed Elshafie
*/

module memory_stage(

    /************************ Input Ports ************************/
    input wire [31:0] ALU_out_M, writeData_M, 

    input wire clk, memWrite_M, reset,

    /************************ Output Ports ************************/
    output wire [31:0] read_data_M,

    output wire [15:0] test_value
);



/************************ Code Start ************************/
RAM RAM_1 ( //Instantiation of the RAM block.
    .A(ALU_out_M),
    .WD(writeData_M),
    .WE(memWrite_M),
    .clk(clk),
    .reset(reset),
    .RD(read_data_M),
    .test(test_value)
);

endmodule