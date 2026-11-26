// Combinational teaching decomposition. No clock, state or signed arithmetic.
module CompareBit(
 input wire a,b,eq_in,lt_in,
 output wire eq_out,lt_out
);
 wire not_a, different, same, bit_less, take_less;
 assign not_a = ~a;
 assign different = a ^ b;
 assign same = ~different;
 assign bit_less = not_a & b;
 assign take_less = eq_in & bit_less;
 assign eq_out = eq_in & same;
 assign lt_out = lt_in | take_less;
endmodule

module Compare10(
 input wire [9:0] a,b,
 output wire eq,lt,
 output wire [10:0] prefix_eq,prefix_lt
);
 assign prefix_eq[10] = 1'b1;
 assign prefix_lt[10] = 1'b0;
 genvar bit_index;
 generate for(bit_index=0;bit_index<10;bit_index=bit_index+1)begin: stage
  CompareBit unit(.a(a[bit_index]),.b(b[bit_index]),
   .eq_in(prefix_eq[bit_index+1]),.lt_in(prefix_lt[bit_index+1]),
   .eq_out(prefix_eq[bit_index]),.lt_out(prefix_lt[bit_index]));
 end endgenerate
 assign eq = prefix_eq[0];
 assign lt = prefix_lt[0];
endmodule
