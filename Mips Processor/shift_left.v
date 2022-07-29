module shift_left #(parameter width =31)
(

input wire [width:0] in,

output reg [width:0] out

);

always @ (*)begin
out = in<<2;
end
endmodule
