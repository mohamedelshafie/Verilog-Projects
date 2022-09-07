/*
* Module: Write Back Stage
* File Name: writeBack_stage.v
* Description: Instantiation of blocks in the Write Back stage. 
* Author: Mohamed Elshafie
*/

module writeBack_stage(

    /************************ Input Ports ************************/
    input wire [31:0] W_read_data_W, W_ALU_out_W,

    input wire W_memtoReg_W,

    /************************ Output Ports ************************/
    output wire [31:0] W_Result_W
);


/************************ Code Start ************************/
mux #(.width(31)) mux_4 ( //instantiation of the mux.
    .in1(W_ALU_out_W),
    .in2(W_read_data_W),
    .sel(W_memtoReg_W),
    .out(W_Result_W)
);

endmodule