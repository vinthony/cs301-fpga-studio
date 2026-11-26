module FullAdder( // @[src/main/scala/Adders.scala 6:7]
  input   io_a, // @[src/main/scala/Adders.scala 7:14]
  input   io_b, // @[src/main/scala/Adders.scala 7:14]
  input   io_cin, // @[src/main/scala/Adders.scala 7:14]
  output  io_sum, // @[src/main/scala/Adders.scala 7:14]
  output  io_cout // @[src/main/scala/Adders.scala 7:14]
);
  wire  p = io_a ^ io_b; // @[src/main/scala/Adders.scala 11:16]
  assign io_sum = p ^ io_cin; // @[src/main/scala/Adders.scala 12:15]
  assign io_cout = io_a & io_b | p & io_cin; // @[src/main/scala/Adders.scala 13:29]
endmodule
module RippleAdder( // @[src/main/scala/Adders.scala 15:7]
  input  [3:0] io_a, // @[src/main/scala/Adders.scala 17:14]
  input  [3:0] io_b, // @[src/main/scala/Adders.scala 17:14]
  input        io_cin, // @[src/main/scala/Adders.scala 17:14]
  output [3:0] io_sum, // @[src/main/scala/Adders.scala 17:14]
  output       io_cout, // @[src/main/scala/Adders.scala 17:14]
  output [4:0] io_carries // @[src/main/scala/Adders.scala 17:14]
);
  wire  fa_io_a; // @[src/main/scala/Adders.scala 25:20]
  wire  fa_io_b; // @[src/main/scala/Adders.scala 25:20]
  wire  fa_io_cin; // @[src/main/scala/Adders.scala 25:20]
  wire  fa_io_sum; // @[src/main/scala/Adders.scala 25:20]
  wire  fa_io_cout; // @[src/main/scala/Adders.scala 25:20]
  wire  fa_1_io_a; // @[src/main/scala/Adders.scala 25:20]
  wire  fa_1_io_b; // @[src/main/scala/Adders.scala 25:20]
  wire  fa_1_io_cin; // @[src/main/scala/Adders.scala 25:20]
  wire  fa_1_io_sum; // @[src/main/scala/Adders.scala 25:20]
  wire  fa_1_io_cout; // @[src/main/scala/Adders.scala 25:20]
  wire  fa_2_io_a; // @[src/main/scala/Adders.scala 25:20]
  wire  fa_2_io_b; // @[src/main/scala/Adders.scala 25:20]
  wire  fa_2_io_cin; // @[src/main/scala/Adders.scala 25:20]
  wire  fa_2_io_sum; // @[src/main/scala/Adders.scala 25:20]
  wire  fa_2_io_cout; // @[src/main/scala/Adders.scala 25:20]
  wire  fa_3_io_a; // @[src/main/scala/Adders.scala 25:20]
  wire  fa_3_io_b; // @[src/main/scala/Adders.scala 25:20]
  wire  fa_3_io_cin; // @[src/main/scala/Adders.scala 25:20]
  wire  fa_3_io_sum; // @[src/main/scala/Adders.scala 25:20]
  wire  fa_3_io_cout; // @[src/main/scala/Adders.scala 25:20]
  wire  sums_1 = fa_1_io_sum; // @[src/main/scala/Adders.scala 22:58 27:13]
  wire  sums_0 = fa_io_sum; // @[src/main/scala/Adders.scala 22:58 27:13]
  wire [1:0] io_sum_lo = {sums_1,sums_0}; // @[src/main/scala/Adders.scala 29:18]
  wire  sums_3 = fa_3_io_sum; // @[src/main/scala/Adders.scala 22:58 27:13]
  wire  sums_2 = fa_2_io_sum; // @[src/main/scala/Adders.scala 22:58 27:13]
  wire [1:0] io_sum_hi = {sums_3,sums_2}; // @[src/main/scala/Adders.scala 29:18]
  wire  carry_1 = fa_io_cout; // @[src/main/scala/Adders.scala 22:19 27:38]
  wire [1:0] io_carries_lo = {carry_1,io_cin}; // @[src/main/scala/Adders.scala 29:71]
  wire  carry_4 = fa_3_io_cout; // @[src/main/scala/Adders.scala 22:19 27:38]
  wire  carry_3 = fa_2_io_cout; // @[src/main/scala/Adders.scala 22:19 27:38]
  wire  carry_2 = fa_1_io_cout; // @[src/main/scala/Adders.scala 22:19 27:38]
  wire [2:0] io_carries_hi = {carry_4,carry_3,carry_2}; // @[src/main/scala/Adders.scala 29:71]
  FullAdder fa ( // @[src/main/scala/Adders.scala 25:20]
    .io_a(fa_io_a),
    .io_b(fa_io_b),
    .io_cin(fa_io_cin),
    .io_sum(fa_io_sum),
    .io_cout(fa_io_cout)
  );
  FullAdder fa_1 ( // @[src/main/scala/Adders.scala 25:20]
    .io_a(fa_1_io_a),
    .io_b(fa_1_io_b),
    .io_cin(fa_1_io_cin),
    .io_sum(fa_1_io_sum),
    .io_cout(fa_1_io_cout)
  );
  FullAdder fa_2 ( // @[src/main/scala/Adders.scala 25:20]
    .io_a(fa_2_io_a),
    .io_b(fa_2_io_b),
    .io_cin(fa_2_io_cin),
    .io_sum(fa_2_io_sum),
    .io_cout(fa_2_io_cout)
  );
  FullAdder fa_3 ( // @[src/main/scala/Adders.scala 25:20]
    .io_a(fa_3_io_a),
    .io_b(fa_3_io_b),
    .io_cin(fa_3_io_cin),
    .io_sum(fa_3_io_sum),
    .io_cout(fa_3_io_cout)
  );
  assign io_sum = {io_sum_hi,io_sum_lo}; // @[src/main/scala/Adders.scala 29:18]
  assign io_cout = fa_3_io_cout; // @[src/main/scala/Adders.scala 22:19 27:38]
  assign io_carries = {io_carries_hi,io_carries_lo}; // @[src/main/scala/Adders.scala 29:71]
  assign fa_io_a = io_a[0]; // @[src/main/scala/Adders.scala 26:20]
  assign fa_io_b = io_b[0]; // @[src/main/scala/Adders.scala 26:40]
  assign fa_io_cin = io_cin; // @[src/main/scala/Adders.scala 22:19 23:12]
  assign fa_1_io_a = io_a[1]; // @[src/main/scala/Adders.scala 26:20]
  assign fa_1_io_b = io_b[1]; // @[src/main/scala/Adders.scala 26:40]
  assign fa_1_io_cin = fa_io_cout; // @[src/main/scala/Adders.scala 22:19 27:38]
  assign fa_2_io_a = io_a[2]; // @[src/main/scala/Adders.scala 26:20]
  assign fa_2_io_b = io_b[2]; // @[src/main/scala/Adders.scala 26:40]
  assign fa_2_io_cin = fa_1_io_cout; // @[src/main/scala/Adders.scala 22:19 27:38]
  assign fa_3_io_a = io_a[3]; // @[src/main/scala/Adders.scala 26:20]
  assign fa_3_io_b = io_b[3]; // @[src/main/scala/Adders.scala 26:40]
  assign fa_3_io_cin = fa_2_io_cout; // @[src/main/scala/Adders.scala 22:19 27:38]
endmodule
module LookaheadAdder4( // @[src/main/scala/Adders.scala 31:7]
  input  [3:0] io_a, // @[src/main/scala/Adders.scala 32:14]
  input  [3:0] io_b, // @[src/main/scala/Adders.scala 32:14]
  input        io_cin, // @[src/main/scala/Adders.scala 32:14]
  output [3:0] io_sum, // @[src/main/scala/Adders.scala 32:14]
  output       io_cout, // @[src/main/scala/Adders.scala 32:14]
  output [4:0] io_carries // @[src/main/scala/Adders.scala 32:14]
);
  wire [3:0] p = io_a ^ io_b; // @[src/main/scala/Adders.scala 37:16]
  wire [3:0] g = io_a & io_b; // @[src/main/scala/Adders.scala 37:37]
  wire  c_1 = g[0] | p[0] & io_cin; // @[src/main/scala/Adders.scala 40:16]
  wire  c_2 = g[1] | p[1] & g[0] | p[1] & p[0] & io_cin; // @[src/main/scala/Adders.scala 41:34]
  wire  c_3 = g[2] | p[2] & g[1] | p[2] & p[1] & g[0] | p[2] & p[1] & p[0] & io_cin; // @[src/main/scala/Adders.scala 42:60]
  wire  c_4 = g[3] | p[3] & g[2] | p[3] & p[2] & g[1] | p[3] & p[2] & p[1] & g[0] | p[3] & p[2] & p[1] & p[0] & io_cin; // @[src/main/scala/Adders.scala 43:94]
  wire [1:0] io_sum_lo = {c_1,io_cin}; // @[src/main/scala/Adders.scala 44:19]
  wire [2:0] io_sum_hi = {c_4,c_3,c_2}; // @[src/main/scala/Adders.scala 44:19]
  wire [4:0] _io_sum_T = {c_4,c_3,c_2,c_1,io_cin}; // @[src/main/scala/Adders.scala 44:19]
  assign io_sum = p ^ _io_sum_T[3:0]; // @[src/main/scala/Adders.scala 44:15]
  assign io_cout = g[3] | p[3] & g[2] | p[3] & p[2] & g[1] | p[3] & p[2] & p[1] & g[0] | p[3] & p[2] & p[1] & p[0] &
    io_cin; // @[src/main/scala/Adders.scala 43:94]
  assign io_carries = {io_sum_hi,io_sum_lo}; // @[src/main/scala/Adders.scala 44:65]
endmodule
module CompareAdders4( // @[src/main/scala/Adders.scala 47:7]
  input        clock, // @[src/main/scala/Adders.scala 47:7]
  input        reset, // @[src/main/scala/Adders.scala 47:7]
  input  [3:0] io_a, // @[src/main/scala/Adders.scala 48:14]
  input  [3:0] io_b, // @[src/main/scala/Adders.scala 48:14]
  input        io_cin, // @[src/main/scala/Adders.scala 48:14]
  output [4:0] io_ripple, // @[src/main/scala/Adders.scala 48:14]
  output [4:0] io_lookahead, // @[src/main/scala/Adders.scala 48:14]
  output [4:0] io_rippleCarries, // @[src/main/scala/Adders.scala 48:14]
  output [4:0] io_lookaheadCarries, // @[src/main/scala/Adders.scala 48:14]
  output       io_equal // @[src/main/scala/Adders.scala 48:14]
);
  wire [3:0] r_io_a; // @[src/main/scala/Adders.scala 54:17]
  wire [3:0] r_io_b; // @[src/main/scala/Adders.scala 54:17]
  wire  r_io_cin; // @[src/main/scala/Adders.scala 54:17]
  wire [3:0] r_io_sum; // @[src/main/scala/Adders.scala 54:17]
  wire  r_io_cout; // @[src/main/scala/Adders.scala 54:17]
  wire [4:0] r_io_carries; // @[src/main/scala/Adders.scala 54:17]
  wire [3:0] l_io_a; // @[src/main/scala/Adders.scala 54:53]
  wire [3:0] l_io_b; // @[src/main/scala/Adders.scala 54:53]
  wire  l_io_cin; // @[src/main/scala/Adders.scala 54:53]
  wire [3:0] l_io_sum; // @[src/main/scala/Adders.scala 54:53]
  wire  l_io_cout; // @[src/main/scala/Adders.scala 54:53]
  wire [4:0] l_io_carries; // @[src/main/scala/Adders.scala 54:53]
  RippleAdder r ( // @[src/main/scala/Adders.scala 54:17]
    .io_a(r_io_a),
    .io_b(r_io_b),
    .io_cin(r_io_cin),
    .io_sum(r_io_sum),
    .io_cout(r_io_cout),
    .io_carries(r_io_carries)
  );
  LookaheadAdder4 l ( // @[src/main/scala/Adders.scala 54:53]
    .io_a(l_io_a),
    .io_b(l_io_b),
    .io_cin(l_io_cin),
    .io_sum(l_io_sum),
    .io_cout(l_io_cout),
    .io_carries(l_io_carries)
  );
  assign io_ripple = {r_io_cout,r_io_sum}; // @[src/main/scala/Adders.scala 57:19]
  assign io_lookahead = {l_io_cout,l_io_sum}; // @[src/main/scala/Adders.scala 57:60]
  assign io_rippleCarries = r_io_carries; // @[src/main/scala/Adders.scala 58:20]
  assign io_lookaheadCarries = l_io_carries; // @[src/main/scala/Adders.scala 58:57]
  assign io_equal = io_ripple == io_lookahead; // @[src/main/scala/Adders.scala 59:25]
  assign r_io_a = io_a; // @[src/main/scala/Adders.scala 55:10]
  assign r_io_b = io_b; // @[src/main/scala/Adders.scala 55:26]
  assign r_io_cin = io_cin; // @[src/main/scala/Adders.scala 55:44]
  assign l_io_a = io_a; // @[src/main/scala/Adders.scala 56:10]
  assign l_io_b = io_b; // @[src/main/scala/Adders.scala 56:26]
  assign l_io_cin = io_cin; // @[src/main/scala/Adders.scala 56:44]
endmodule
