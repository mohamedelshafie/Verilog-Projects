//up_down counter with sync reset
module counter_up_down(

input clk,rst,up_down,

output[3:0] count_out

);

reg[3:0] count;

always @ (posedge clk)
begin
if(rst)
count <= 0;
else if(up_down)
count <= count - 1;
else
count <= count + 1;
end
assign count_out = count;
endmodule
