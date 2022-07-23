module FSM_011(

input clk,in,

output out

);

parameter stateA = 2'b00,stateB = 2'b01,stateC = 2'b10,stateD = 2'b11; //assign number for each state

reg[1:0] currentstate,nextstate = 2'b00; //initialization for the two reg

always @(in or  currentstate)
begin
case(currentstate) //converting the FSM diagram to code
stateA : if (in==0)
         nextstate = stateB;
         else
         nextstate = stateA;			
stateB : if (in==1)
         nextstate = stateC;
         else
         nextstate = stateB;
stateC :if (in==1)
         nextstate = stateD;
         else
         nextstate = stateB;
stateD :if (in==0)
         nextstate = stateB;
         else
         nextstate = stateA;
default  : nextstate = stateA;
endcase
end

always @(posedge clk)
begin
currentstate = nextstate;
end
assign out = ( currentstate == stateD) ? 1:0 ;
endmodule
