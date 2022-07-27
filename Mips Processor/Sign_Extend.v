module sign_extend(

input wire [15:0] instr,

output reg [31:0] signImm


);
always @(*)begin
if(instr[15]==1'b0)
signImm={ {16{1'b0} },instr};
else 
signImm={ {16{1'b1} },instr};
end
endmodule

