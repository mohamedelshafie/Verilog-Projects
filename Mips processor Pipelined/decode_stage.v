/*
* Module: Decode Stage
* File Name: decode_stage.v
* Description: Instantiation of blocks in the Decode stage.
* Author: Mohamed Elshafie
*/

module decode_stage(

    /************************ Input Ports ************************/
    input wire clk, reset,

    input wire [31:0] instr_D, D_PCPlus4_D, WD3_D, ALU_out_M,

    input wire [4:0] A3_D,

    input wire Jump_D, branch_D, forwardA_D, forwardB_D, reg_write_W,

    /************************ Output Ports ************************/
    output wire [31:0] PCbranch_D, D_RD1_D, D_RD2_D, signImm_D_out,

    output wire [4:0] D_Rs_D, D_Rt_D, D_Rd_D, 

    output wire [1:0] PC_src_D
);


/************************ Internal Signals ************************/
wire [27:0] shift2out;
wire [31:0] shift1out, mux1_out, mux2_out, signImm_D;
wire comp1_out, PC_src_D_0;
wire [27:0] shift1_in = {2'b00,instr_D[25:0]};

/************************ Code Start ************************/
assign signImm_D_out = signImm_D;
assign D_Rs_D = instr_D[25:21];
assign D_Rt_D = instr_D[20:16];
assign D_Rd_D = instr_D[15:11];
assign PC_src_D = {Jump_D,PC_src_D_0};
assign comp1_out = (mux1_out == mux2_out) ? 1'b1:1'b0 ;

assign PC_src_D_0 = comp1_out && branch_D;



reg_file register1 ( //instantiation of the register file.
    .A1(instr_D[25:21]),
    .A2(instr_D[20:16]),
    .A3(A3_D),
    .WD3(WD3_D),
    .clk(clk),
    .WE3(reg_write_W),
    .reset(reset),
    .RD1(D_RD1_D),
    .RD2(D_RD2_D));

sign_extend sign_extend_1 ( //instantiation of the sign extension.
    .instr(instr_D[15:0]),
    .signImm(signImm_D)
);

shift_left #(.width(31))shift_1( //instantiation of the shift left.
    .in(signImm_D),
    .outputt(shift1out)
);


adder adder_1 ( //instantiation of the adder.
    .A_1(shift1out),
    .B_2(D_PCPlus4_D),
    .C_3(PCbranch_D)
);

mux #(.width(31)) mux_1 ( //instantiation of the mux.
    .in1(D_RD1_D),
    .in2(ALU_out_M),
    .sel(forwardA_D),
    .out(mux1_out)
);

mux #(.width(31)) mux_2 ( //instantiation of the mux.
    .in1(D_RD2_D),
    .in2(ALU_out_M),
    .sel(forwardB_D),
    .out(mux2_out)
);



endmodule