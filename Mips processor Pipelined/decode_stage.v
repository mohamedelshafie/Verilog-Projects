/*
* Module: Program Counter
* File Name: decode_stage.v
* Description: Unit updated at the rising edge of the clock. Contains the address of the instruction to execute. 
* Author: Mohamed Elshafie
*/

module decode_stage(

    /************************ Input Ports ************************/
    input wire clk, reset,

    input wire [31:0] instr_D, PCPlus4_D, WD3_D, ALU_out_M,

    input wire [4:0] A3_D,

    input wire Jump_D, branch_D, forwardA_D, forwardB_D, reg_write_W,

    /************************ Output Ports ************************/
    output wire [31:0] PCbranch_D, RD1_D, RD2_D, signImm_D_out,

    output wire [4:0] Rs_D, Rt_D, Rd_D, 

    output wire [1:0] PC_src_D
);


/************************ Internal Signals ************************/
wire [27:0] shift2out;
wire [31:0] shift1out, mux1_out, mux2_out, signImm_D;
wire comp1_out, PC_src_D_0;
wire [27:0] shift1_in = {2'b00,instr_D[25:0]};

/************************ Code Start ************************/
assign signImm_D_out = signImm_D;
assign comp1_out = (mux1_out == mux2_out) ? 1'b1:1'b0 ;

assign PC_src_D_0 = comp1_out && branch_D;
assign PC_src_D = {Jump_D,PC_src_D_0};

assign Rs_D = instr_D[25:21];
assign Rt_D = instr_D[20:16];
assign Rd_D = instr_D[15:11];

//assign PCjump_D = {PCPlus4_D[31:28],shift2out};

reg_file register1 ( //instantiation of the register file.
    .A1(instr_D[25:21]),
    .A2(instr_D[20:16]),
    .A3(A3_D),
    .WD3(WD3_D),
    .clk(clk),
    .WE3(reg_write_W),
    .reset(reset),
    .RD1(RD1_D),
    .RD2(RD2_D));

sign_extend sign_extend_1 (
    .instr(instr_D[15:0]),
    .signImm(signImm_D)
);

shift_left #(.width(31))shift_1(
    .in(signImm_D),
    .out(shift1out)
);

// shift_left #(.width(27))shift_2(
//     .in(shift1_in),
//     .out(shift2out)
// );

adder adder_1 (
    .A(shift1out),
    .B(PCPlus4_D),
    .C(PCbranch_D)
);

mux #(.width(31)) mux_1 (
    .in1(RD1_D),
    .in2(ALU_out_M),
    .sel(forwardA_D),
    .out(mux1_out)
);

mux #(.width(31)) mux_2 (
    .in1(RD2_D),
    .in2(ALU_out_M),
    .sel(forwardB_D),
    .out(mux2_out)
);

// equality_comparator comp_1 (
//     .in1(mux1_out),
//     .in2(mux2_out),
//     .out(comp1_out)
// );


endmodule