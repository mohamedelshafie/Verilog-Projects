module AXI_Interconnect (
    //---------------------- Input Ports ----------------------
    input wire G_clk, G_reset,  //global clock and reset
    
    //inputs from master 0:
    input          M0_RREADY,
    input [31:0]   M0_ARADDR, 
    input [3:0]    M0_ARLEN, 
    input [2:0]    M0_ARSIZE, 
    input [1:0]    M0_ARBURST, 
    input          M0_ARVALID,

    //inputs from master 1:
    input          M1_RREADY,
    input [31:0]   M1_ARADDR, 
    input [3:0]    M1_ARLEN, 
    input [2:0]    M1_ARSIZE, 
    input [1:0]    M1_ARBURST, 
    input          M1_ARVALID,

    //inputs from the slave 0:
    input          S0_ARREADY, 
    input          S0_RVALID, 
    input          S0_RLAST, 
    input [1:0]    S0_RRESP, 
    input [31:0]   S0_RDATA, 
    
    //inputs from the slave 1:
    input          S1_ARREADY, 
    input          S1_RVALID, 
    input          S1_RLAST, 
    input [1:0]    S1_RRESP, 
    input [31:0]   S1_RDATA, 

    //addresses ranges for each slave:
    input [31:0] slave0_addr1,
    input [31:0] slave0_addr2,

    input [31:0] slave1_addr1,
    input [31:0] slave1_addr2,


    //---------------------- Output Ports ----------------------

    //outputs to master 0:
    output wire           ARREADY_M0, 
    output wire           RVALID_M0, 
    output wire           RLAST_M0, 
    output wire  [1:0]    RRESP_M0, 
    output wire  [31:0]   RDATA_M0, 

    //outputs to master 1:
    output wire           ARREADY_M1, 
    output wire           RVALID_M1, 
    output wire           RLAST_M1, 
    output wire  [1:0]    RRESP_M1, 
    output wire  [31:0]   RDATA_M1, 

    //outputs to the slave 0:
    output wire  [31:0]    ARADDR_S0,
    output wire  [3:0]     ARLEN_S0,
    output wire  [2:0]     ARSIZE_S0, 
    output wire  [1:0]     ARBURST_S0, 
    output wire            ARVALID_S0,
    output wire            RREADY_S0,

    //outputs to the slave 1:
    output wire  [31:0]    ARADDR_S1,
    output wire  [3:0]     ARLEN_S1,
    output wire  [2:0]     ARSIZE_S1, 
    output wire  [1:0]     ARBURST_S1, 
    output wire            ARVALID_S1,
    output wire            RREADY_S1
);

//------------------- Internal Signals -------------------

//select lines for muxs and demuxs coming from controller:
wire             S_addr_wire;
wire             M0_data_wire;
wire             M1_data_wire;
wire             M_addr_wire;

//wires connecting between a mux and a demux:
wire             ARVALID_wire;
wire  [31:0]     ARADDR_wire;
wire  [3:0]      ARLEN_wire;
wire  [2:0]      ARSIZE_wire;
wire  [1:0]      ARBURST_wire;

wire             en_S0_wire;
wire             en_S1_wire;

wire             enable_S0_wire;
wire             enable_S1_wire;

wire             RREADY_S0_wire;
wire             RREADY_S1_wire;

wire             RREADY_S0_wire_2;
wire             RREADY_S1_wire_2;

//---------------------- Code Start ----------------------

Controller Read_controller (
    .clkk                          (G_clk),
    .resett                        (G_reset),
    .slave0_addr1                  (slave0_addr1),
    .slave0_addr2                  (slave0_addr2),
    .slave1_addr1                  (slave1_addr1),
    .slave1_addr2                  (slave1_addr2),
    .M_ADDR                        (ARADDR_wire),
    .S0_ARREADY                    (S0_ARREADY),
    .S1_ARREADY                    (S1_ARREADY),
    .M0_ARVALID                    (M0_ARVALID),
    .M1_ARVALID                    (M1_ARVALID),
    .M0_RREADY                     (M0_RREADY),
    .M1_RREADY                     (M1_RREADY),
    .S0_RVALID                     (S0_RVALID),
    .S1_RVALID                     (S1_RVALID),
    .S0_RLAST                      (S0_RLAST),
    .S1_RLAST                      (S1_RLAST),

    .select_slave_address          (S_addr_wire),
    .select_data_M0                (M0_data_wire),
    .select_data_M1                (M1_data_wire),
    .select_master_address         (M_addr_wire),
    .en_S0                         (en_S0_wire),
    .en_S1                         (en_S1_wire),
    .enable_S0                     (enable_S0_wire),
    .enable_S1                     (enable_S1_wire)

);

//-------------- Address Channel ---------------------

//------------------ ARVALID -------------------------
Mux_2x1 #(.width(0)) arvalid_mux (
    .in1        (M0_ARVALID),
    .in2        (M1_ARVALID),
    .sel        (M_addr_wire),

    .out        (ARVALID_wire)
);
Demux_1x2 #(.width(0)) arvalid_demux (
    .in             (ARVALID_wire),
    .select         (S_addr_wire),

    .out1           (ARVALID_S0),
    .out2           (ARVALID_S1)
);

//------------------ ARADDR -------------------------
Mux_2x1 #(.width(31)) araddr_mux (
    .in1        (M0_ARADDR),
    .in2        (M1_ARADDR),
    .sel        (M_addr_wire), 

    .out        (ARADDR_wire)
);
Demux_1x2 #(.width(31)) araddr_demux (
    .in             (ARADDR_wire),
    .select         (S_addr_wire),

    .out1           (ARADDR_S0),
    .out2           (ARADDR_S1)
);

//------------------ ARLEN -------------------------
Mux_2x1 #(.width(3)) arlen_mux (
    .in1        (M0_ARLEN),
    .in2        (M1_ARLEN),
    .sel        (M_addr_wire), 

    .out        (ARLEN_wire)
);
Demux_1x2 #(.width(3)) arlen_demux (
    .in             (ARLEN_wire),
    .select         (S_addr_wire),

    .out1           (ARLEN_S0),
    .out2           (ARLEN_S1)
);

//------------------ ARSIZE -------------------------
Mux_2x1 #(.width(2)) arsize_mux (
    .in1        (M0_ARSIZE),
    .in2        (M1_ARSIZE),
    .sel        (M_addr_wire), 

    .out        (ARSIZE_wire)
);
Demux_1x2 #(.width(2)) arsize_demux (
    .in             (ARSIZE_wire),
    .select         (S_addr_wire),

    .out1           (ARSIZE_S0),
    .out2           (ARSIZE_S1)
);

//------------------ ARBURST -------------------------
Mux_2x1 #(.width(1)) arburst_mux (
    .in1        (M0_ARBURST),
    .in2        (M1_ARBURST),
    .sel        (M_addr_wire), 

    .out        (ARBURST_wire)
);
Demux_1x2 #(.width(1)) arburst_demux (
    .in             (ARBURST_wire),
    .select         (S_addr_wire),

    .out1           (ARBURST_S0),
    .out2           (ARBURST_S1)
);

//------------------ ARREADY -------------------------
Mux_2x1 #(.width(0)) arready_mux (
    .in1        (S0_ARREADY),
    .in2        (S1_ARREADY),
    .sel        (S_addr_wire), 

    .out        (ARREADY_wire)
);
Demux_1x2 #(.width(0)) arready_demux (
    .in             (ARREADY_wire),
    .select         (M_addr_wire),

    .out1           (ARREADY_M0),
    .out2           (ARREADY_M1)
);

//---------------- Data Channel ---------------------

//------------------ RREADY -------------------------
/*Demux_1x2_en #(.width(0)) rready_demux (
    .in             (M0_RREADY),
    .select         (M0_data_wire),
    .enable         (),
    .out1           (RREADY_S0),
    .out2           (RREADY_S1)
);
Demux_1x2_en #(.width(0)) rready_demux2 (
    .in             (M1_RREADY),
    .select         (M1_data_wire),
    .enable         (),
    .out1           (RREADY_S0),
    .out2           (RREADY_S1)
);*/
Demux_1x2 #(.width(0)) rready_demux (
    .in             (M0_RREADY),
    .select         (M0_data_wire),

    .out1           (RREADY_S0_wire),
    .out2           (RREADY_S1_wire)
);
Demux_1x2 #(.width(0)) rready_demux2 (
    .in             (M1_RREADY),
    .select         (M1_data_wire),

    .out1           (RREADY_S0_wire_2),
    .out2           (RREADY_S1_wire_2)
);

Mux_2x1 #(.width(0)) rready_mux (
    .in1        (RREADY_S0_wire),
    .in2        (RREADY_S0_wire_2),
    .sel        (en_S0_wire), 

    .out        (RREADY_S0)
);
Mux_2x1 #(.width(0)) rready_mux2 (
    .in1        (RREADY_S1_wire),
    .in2        (RREADY_S1_wire_2),
    .sel        (en_S1_wire), 

    .out        (RREADY_S1)
);
/*Mux_2x1_en #(.width(0)) rready_mux (
    .in1        (M0_RREADY),
    .in2        (M1_RREADY),
    .sel        (en_S0_wire), 
    .enable     (enable_S0_wire),

    .out        (RREADY_S0)
);
Mux_2x1_en #(.width(0)) rready_mux2 (
    .in1        (M0_RREADY),
    .in2        (M1_RREADY),
    .sel        (en_S1_wire), 
    .enable     (enable_S1_wire),

    .out        (RREADY_S1)
);*/
//------------------ RVALID -------------------------
Mux_2x1 #(.width(0)) rvalid_mux (
    .in1        (S0_RVALID),
    .in2        (S1_RVALID),
    .sel        (M0_data_wire), 

    .out        (RVALID_M0)
);
Mux_2x1 #(.width(0)) rvalid_mux2 (
    .in1        (S0_RVALID),
    .in2        (S1_RVALID),
    .sel        (M1_data_wire), 

    .out        (RVALID_M1)
);

//------------------ RDATA -------------------------
Mux_2x1 #(.width(31)) rdata_mux (
    .in1        (S0_RDATA),
    .in2        (S1_RDATA),
    .sel        (M0_data_wire), 

    .out        (RDATA_M0)
);
Mux_2x1 #(.width(31)) rdata_mux2 (
    .in1        (S0_RDATA),
    .in2        (S1_RDATA),
    .sel        (M1_data_wire), 

    .out        (RDATA_M1)
);

//------------------ RLAST -------------------------
Mux_2x1 #(.width(0)) rlast_mux (
    .in1        (S0_RLAST),
    .in2        (S1_RLAST),
    .sel        (M0_data_wire), 

    .out        (RLAST_M0)
);
Mux_2x1 #(.width(0)) rlast_mux2 (
    .in1        (S0_RLAST),
    .in2        (S1_RLAST),
    .sel        (M1_data_wire), 

    .out        (RLAST_M1)
);

//------------------ RRESP -------------------------
Mux_2x1 #(.width(1)) rresp_mux (
    .in1        (S0_RRESP),
    .in2        (S1_RRESP),
    .sel        (M0_data_wire), 

    .out        (RRESP_M0)
);
Mux_2x1 #(.width(1)) rresp_mux2 (
    .in1        (S0_RRESP),
    .in2        (S1_RRESP),
    .sel        (M1_data_wire), 

    .out        (RRESP_M1)
);

endmodule