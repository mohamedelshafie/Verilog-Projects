module Controller (

    //---------------------- Input Ports ----------------------
    input clkk, resett,

    //input from reg file to indicate range of addresses of slave 0:
    input wire [31:0] slave0_addr1, 
    input wire [31:0] slave0_addr2,

    //input from reg file to indicate range of addresses of slave 1:
    input wire [31:0] slave1_addr1,
    input wire [31:0] slave1_addr2,

    //valid signal from the master on read address channel:
//    input wire ARVALID_M, 

    //Address from the master on read address channel:
    input wire [31:0] M_ADDR,

    //signal from the first FSM to indicate which master is sending data:
    //input wire data_M,

    //**********************************
    //input wire [3:0] ARID_M,

    //ready signal form each slave:
    input wire S0_ARREADY,
    input wire S1_ARREADY,

    //two valid signals from masters on read address channel:
    input wire M0_ARVALID, 
    input wire M1_ARVALID, 

    //two ready signals from masters on read data channel:
    input wire M0_RREADY,
    input wire M1_RREADY,

    //valid signal form each slave:
    input wire S0_RVALID,
    input wire S1_RVALID,

    //valid signal form each slave:
    input wire S0_RLAST,
    input wire S1_RLAST,
    

    //input wire [3:0] RID_S,
    //**********************************



//--------------------------------------------------------------------

    
    //ready signal form slave going to each master on read address channel:
    //input wire S_ARREADY_M0,
    //input wire S_ARREADY_M1,

    //last signal form slave going to each master on read data channel:
    //input wire S_RLAST_M0, 
    //input wire S_RLAST_M1, 

    //valid signal form slave going to each master on read data channel:
    //input wire S_RVALID_M0,
    //input wire S_RVALID_M1, 

    
    //---------------------- Output Ports ----------------------
    
    // select lines for muxs to choose which master control each channel:
    output reg select_slave_address, select_data_M0, select_data_M1,

    //enable signal based on the ID from slave to choose the right master:
    output reg en_S0, en_S1,
    output reg enable_S0, enable_S1,

    output reg select_master_address
);

//---------------------- Code Start ----------------------
reg [1:0] curr_state_slave, next_state_slave, curr_state_slave2;

reg [1:0] curr_state_address, next_state_address, next_state_slave2;



localparam Idle_address = 2'b00;
localparam M0_Address = 2'b01;
localparam M1_Address = 2'b10;

localparam Idle_slave = 2'b00;
localparam Slave0 = 2'b01;
localparam Slave1 = 2'b10;

localparam Idle_slave_2 = 2'b00;
localparam Slave0_2 = 2'b01;
localparam Slave1_2 = 2'b10;


always @(posedge clkk or negedge resett) begin
    if(!resett)begin
        curr_state_slave <= Idle_slave;
        curr_state_slave2 <= Idle_slave_2;
        curr_state_address <= Idle_address;

    end
    else begin
        curr_state_slave <= next_state_slave;
        curr_state_slave2 <= next_state_slave2;
        curr_state_address <= next_state_address;

    end
end


always @(*) begin
    //select_master_address = 1'b0;
    //next_state_slave = 2'b00;
    //en_S1 = 1'b0;
    //select_slave_address = 1'b0;
    //select_data_M1 = 1'b0;
    //select_data_M0 = 1'b0;
    //en_S0 = 1'b0;
    //next_state_slave2 = 2'b00;
    
    case (curr_state_address)
        Idle_address:begin
            //if(M0_ARVALID && M1_ARVALID)begin
            //    next_state_address = M0_Address; 
            //    select_master_address = 1'b0;
                
            //end
            //else begin
                if((M0_ARVALID && S0_ARREADY) || (M0_ARVALID && S1_ARREADY) || (M1_ARVALID && S0_ARREADY) || (M1_ARVALID && S1_ARREADY))begin
                    next_state_address = Idle_address;
                    select_master_address = 0;//synthesis
                    en_S0 = 1'b0; //synthesis 
                    en_S1 = 1'b0;//synthesis
                    //******************************************
                    select_slave_address = 0;//synthesis
                    select_data_M0 = 1'b0;//synthesis
                    select_data_M1 = 1'b0;//synthesis
                    //******************************************
                    
                end
                else if(M0_ARVALID)begin
                    next_state_address = M0_Address; 
                    select_master_address = 1'b0;
                    //******************************************
                    select_slave_address = 0;//synthesis
                    select_data_M0 = 1'b0;//synthesis
                    select_data_M1 = 1'b0;//synthesis
                    //******************************************
                    if(M_ADDR <= slave0_addr2 && M_ADDR >= slave0_addr1)begin
                        select_slave_address = 1'b0;  

                        select_data_M0 = 1'b0; //not sure this is the right place
                        en_S0 = 1'b0;  
                        en_S1 = 1'b1;

                    end
                    else if(M_ADDR <= slave1_addr2 && M_ADDR >= slave1_addr1)begin
                        select_slave_address = 1'b1;

                        select_data_M0 = 1'b1; //not sure this is the right place
                        en_S1 = 1'b0;
                        en_S0 = 1'b1;  
                    end
                    else begin
                        next_state_address = Idle_address;
                        select_slave_address = 0;//synthesis

                        select_data_M0 = 1'b0;//synthesis
                        en_S0 = 1'b0;//synthesis
                        en_S1 = 1'b0;//synthesis
                    end
                end
                else if(M1_ARVALID)begin
                    next_state_address = M1_Address; 
                    select_master_address = 1'b1;
                    //******************************************
                    select_slave_address = 0;//synthesis
                    select_data_M0 = 1'b0;//synthesis
                    select_data_M1 = 1'b0;//synthesis
                    //******************************************
                    if(M_ADDR <= slave0_addr2 && M_ADDR >= slave0_addr1)begin
                        select_slave_address = 1'b0;    

                        select_data_M1 = 1'b0; //not sure this is the right place
                        en_S0 = 1'b0;
                        en_S1 = 1'b0;

                    end
                    else if(M_ADDR <= slave1_addr2 && M_ADDR >= slave1_addr1)begin
                        select_slave_address = 1'b1;

                        select_data_M1 = 1'b1; //not sure this is the right place
                        en_S1 = 1'b1;
                        en_S0 = 1'b0;  
                    end
                    else begin
                        next_state_address = Idle_address;
                        select_slave_address = 0;//synthesis

                        select_data_M1 = 1'b0;//synthesis
                        en_S0 = 1'b0;//synthesis
                        en_S1 = 1'b0;//synthesis
                    end
                end
                else begin 
                    next_state_address = Idle_address;
                    select_master_address = 0;//synthesis
                    en_S0 = 1'b0;//synthesis
                    en_S1 = 1'b0;//synthesis
                    //******************************************
                    select_slave_address = 0;//synthesis
                    select_data_M0 = 1'b0;//synthesis
                    select_data_M1 = 1'b0;//synthesis
                    //******************************************
                end
            //end
        end
        M0_Address:begin
            en_S0 = 1'b0;//synthesis
            en_S1 = 1'b0;//synthesis
            select_master_address = 0;//synthesis
            //******************************************
            select_slave_address = 0;//synthesis
            select_data_M0 = 1'b0;//synthesis
            select_data_M1 = 1'b0;//synthesis
            //******************************************
            if((M0_ARVALID && !S0_ARREADY) || (M0_ARVALID && !S1_ARREADY))begin
                next_state_address = M0_Address;
                //next_state_slave = Idle_slave;//synthesis
            end
            else begin
                if(M0_ARVALID && S0_ARREADY) begin
                    next_state_slave = Slave0; 
            
            
                    next_state_address =Idle_address;
                end
            
                else if(M0_ARVALID && S1_ARREADY) begin
                    next_state_slave = Slave1;
            
            
                    next_state_address =Idle_address;
                end
                else begin
                    next_state_address =Idle_address;
                    //next_state_slave = Idle_slave;//synthesis
                end
            
            
            end
        end
        M1_Address:begin
            en_S0 = 1'b0;//synthesis
            en_S1 = 1'b0;//synthesis
            select_master_address = 0;//synthesis
            //******************************************
            select_slave_address = 0;//synthesis
            select_data_M0 = 1'b0;//synthesis
            select_data_M1 = 1'b0;//synthesis
            //******************************************
            if((M1_ARVALID && !S0_ARREADY) || (M1_ARVALID && !S1_ARREADY))begin
                next_state_address = M1_Address;
                //next_state_slave2 = Idle_slave;//synthesis
            end
            else begin
                if(M1_ARVALID && S0_ARREADY) begin

                    next_state_slave2 = Slave0_2;
            
                    next_state_address = Idle_address;

                end
            
                else if(M1_ARVALID && S1_ARREADY) begin

                    next_state_slave2 = Slave1_2; 
            
                    next_state_address = Idle_address; 
                end
            
                else begin
                    next_state_address = Idle_address;
                    next_state_slave2 = Idle_slave_2;//synthesis
                end
            end
        end
        default: begin
            next_state_address = Idle_address;
            en_S0 = 1'b0;//synthesis
            en_S1 = 1'b0;//synthesis
            select_master_address = 0;//synthesis
            select_slave_address = 0;//synthesis
            select_data_M0 = 1'b0;//synthesis
            select_data_M1 = 1'b0;//synthesis
        end
    endcase
    //--------------------------------------------------------------------------
    /*case(curr_state_slave)
        Idle_slave:begin
            //nothing
            //select_data_M0 = 0;//synthesis
            //select_data_M1 = 1'b0; //trying something
            //en_S0 = 0;//synthesis
            //en_S1 = 0;//synthesis
        end
            
        Slave0:begin
            
            //select_data_M0 = 1'b0; //not sure this is the right place
            //select_data_M1 = 1'b1; //trying something
            //en_S0 = 1'b0;
            //en_S1 = 1'b0;//synthesis
            
            if(M0_RREADY || S0_RVALID || S0_RLAST) begin
                next_state_slave = Slave0;
            end
            else if(M0_RREADY && S0_RVALID && S0_RLAST) begin
                next_state_slave = Slave0; 
            
            end

            else begin 
                next_state_slave = Idle_slave; //problem solved
                
            
            end
        end
        Slave1:begin
                
            //select_data_M0 = 1'b1; //not sure this is the right place
            //select_data_M1 = 1'b0; //trying something
            //en_S1 = 1'b0;
            //en_S0 = 1'b0;//synthesis
            
            if(M0_RREADY || S1_RVALID || S1_RLAST) begin
                next_state_slave = Slave1;
            end
            else if(M0_RREADY && S1_RVALID && S1_RLAST) begin
                next_state_slave = Slave1; 
            
            end

            else begin 
                next_state_slave = Idle_slave; //problem solved
                
            
            end
        end
        default: next_state_slave = Idle_slave;

    endcase
    //--------------------------------------------------------------------------
    case (curr_state_slave2)
        Idle_slave_2:begin
            //nothing
            //select_data_M1 = 0;//synthesis
            //select_data_M0 = 1'b0; //trying something
            //en_S0 = 1'b0;//synthesis
            //en_S1 = 1'b0;//synthesis
        end
        Slave0_2:begin
            
            //select_data_M1 = 1'b0; //not sure this is the right place
            //select_data_M0 = 1'b1; //trying something
            //en_S0 = 1'b1;
            //en_S1 = 1'b1;//synthesis
            
            if(M1_RREADY || S0_RVALID || S0_RLAST) begin
                next_state_slave2 = Slave0_2; 
            end
            else if(M1_RREADY && S0_RVALID && S0_RLAST) begin
                next_state_slave2 = Slave0_2; 
            
            end
            else begin 
                next_state_slave2 = Idle_slave_2;
            
            end
        end
        Slave1_2:begin
            
            //select_data_M1 = 1'b1; //not sure this is the right place
            //select_data_M0 = 1'b0; //trying something
            //en_S1 = 1'b1;
            //en_S0 = 1'b1;//synthesis
        
            if(M1_RREADY || S1_RVALID || S1_RLAST) begin
                next_state_slave2 = Slave1_2; 
            end
            if(M1_RREADY && S1_RVALID && S1_RLAST) begin
                next_state_slave2 = Slave1_2; 
        
            end
            else begin 
                next_state_slave2 = Idle_slave_2;
        
            end
        end
        default: next_state_slave2 = Idle_slave_2;
    endcase*/
end




endmodule


