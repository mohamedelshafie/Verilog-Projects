/*
* Module: Memory Stage
* File Name: memory_stage.v
* Description: Instantiation of blocks in the Memory stage.
* Author: Mohamed Elshafie
*/

module memory_stage(

    /************************ Input Ports ************************/
    input wire [31:0] M_ALU_out_M, M_writeData_M, 

    input wire clk, M_memWrite_M, reset,

    /************************ Output Ports ************************/
    output wire [31:0] M_read_data_M,

    output wire [15:0] M_test_value
);



/************************ Code Start ************************/
RAM RAM_1 ( //Instantiation of the RAM block.
    .A(M_ALU_out_M),
    .WD(M_writeData_M),
    .WE(M_memWrite_M),
    .clk(clk),
    .reset(reset),
    .RD(M_read_data_M),
    .test(M_test_value)
);

endmodule