/*
simple verilog code for a stopwatch counts up to 
10 minutes (9:59:9)
*/
module stopwatch(


input start,reset,clock,

output a,b,c,d,e,f,g,dp,
output[3:0] an

);

reg [3:0] reg_d0=0;
reg [3:0] reg_d1=0;
reg [3:0] reg_d2=0;
reg [3:0] reg_d3=0;
reg [22:0] ticker=0; //23 bits reg to count up to 5*10^6 bits
reg click=0;

always @ (posedge clock )
begin
 if(reset)
  ticker <= 0;
 else if(ticker == 5000000) 
  ticker <= 0; //when it reaches the max value reset it to count again

 else if(start) //only start if the input is high
  ticker <= ticker + 1;
  click <= ((ticker ==5000000)?1'b1:1'b0); //assign value to click to increment
end
always @ (posedge clock )
begin
 if (reset) //asynchronous reset
  begin
   reg_d0 <= 0;
   reg_d1 <= 0;
   reg_d2 <= 0;
   reg_d3 <= 0;
  end
 else if (click) //increment at every click
  begin
   if(reg_d0 == 9) //the digit that increment every 0.1 second (X:XX:9)
   begin 
    reg_d0 <= 0;
    if (reg_d1 == 9) //the units part of seconds part (X:X9:X)
    begin 
     reg_d1 <= 0;
     if (reg_d2 == 5) //the tens part of seconds part (X:5X:X)
     begin 
      reg_d2 <= 0;
      if(reg_d3 == 9) //the units part of minutes part (9:XX:X)
       reg_d3 <= 0;
      else
       reg_d3 <= reg_d3 + 1; //increment units part of minutes part (9:XX:X)
     end
     else 
      reg_d2 <= reg_d2 + 1; //increment tens part of seconds part (X:5X:X)
    end
    else 
     reg_d1 <= reg_d1 + 1; //increment units part of seconds part (X:X9:X)
   end 
   else 
    reg_d0 <= reg_d0 + 1; //increment the digit that increment every 0.1 second (X:XX:9)
  end
end
localparam N = 2;
reg [N-1:0]count=0; //reg that loops over the 4 digits of the 7 segment

always @ (posedge clock )
 begin
  if (reset)
   count <= 0;
  else
   count <= count + 1;
 end
reg [6:0] sseg_temp=0; 
reg [6:0]sseg=0;
reg [3:0]an_temp=0;
reg reg_dp=0;

always @ (posedge clock)
 begin
  case(count[N-1:N-2])
   2'b00 : 
    begin
     sseg = reg_d0;
     an_temp = 4'b1110;
     reg_dp = 1'b1;
    end
   
   2'b01:
    begin
     sseg = reg_d1;
     an_temp = 4'b1101;
     reg_dp = 1'b0;
    end
   
   2'b10:
    begin
     sseg = reg_d2;
     an_temp = 4'b1011;
     reg_dp = 1'b1;
    end
    
   2'b11:
    begin
     sseg = reg_d3;
     an_temp = 4'b0111;
     reg_dp = 1'b0;
	     count = 0;

    end
  endcase
 end
assign an = an_temp;

always @ (posedge clock)
 begin
  case(sseg) //assign values to 7 segment pins to print the number correctly
   4'd0 : sseg_temp = 7'b1000000;
   4'd1 : sseg_temp = 7'b1111001;
   4'd2 : sseg_temp = 7'b0100100;
   4'd3 : sseg_temp = 7'b0110000;
   4'd4 : sseg_temp = 7'b0011001;
   4'd5 : sseg_temp = 7'b0010010;
   4'd6 : sseg_temp = 7'b0000010;
   4'd7 : sseg_temp = 7'b1111000;
   4'd8 : sseg_temp = 7'b0000000;
   4'd9 : sseg_temp = 7'b0010000;
   default : sseg_temp = 7'b0111111; //dash
  endcase
 end
assign {g, f, e, d, c, b, a} = sseg_temp; 
assign dp = reg_dp;

endmodule

