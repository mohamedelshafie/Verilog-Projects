//Using 2 half adders to create full adder: 
module half_adder(
input a,b,
output sum,carry);
assign sum = a^b;
assign carry = a&b;
endmodule

module full_adder(
input a,b,c,
output sum,carry);
wire sum1,carry1,carry2;

half_adder half1(
.a(a),.b(b),.sum(sum1),.carry(carry1));

half_adder half2(
.a(c),.b(sum1),.sum(sum),.carry(carry2));

assign carry = carry2 | carry1;

endmodule

//another way using dataflow modeling:

/*module full_adder(
input a,b,c,
output sum,carry);
assign {carry,sum} = a+b+c;
endmodule*/

//another way in structural modeling:

/*module full_adder(
input a,b,c,
output sum,carry);
wire sum1,carry1,carry2;
xor(sum1,a,b);
and(carry1,a,b);
xor(sum,sum1,c);
and(carry2,sum1,c);
or(carry,carry1,carry2);
endmodule*/

//another way in behavioural modeling:

/*module full_adder(
input a,b,c,
output reg sum,carry);
always @(a or b or c)
begin 
sum = a^b^c;
carry = (a&b) | ((a^b)&c);
end
endmodule*/