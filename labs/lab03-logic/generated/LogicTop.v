module BasicGates( // @[src/main/scala/Logic.scala 6:7]
  input   io_a, // @[src/main/scala/Logic.scala 7:12]
  input   io_b, // @[src/main/scala/Logic.scala 7:12]
  output  io_andOut, // @[src/main/scala/Logic.scala 7:12]
  output  io_orOut, // @[src/main/scala/Logic.scala 7:12]
  output  io_notOut, // @[src/main/scala/Logic.scala 7:12]
  output  io_xorOut, // @[src/main/scala/Logic.scala 7:12]
  output  io_nandOut, // @[src/main/scala/Logic.scala 7:12]
  output  io_norOut // @[src/main/scala/Logic.scala 7:12]
);
  wire  _io_andOut_T = io_a & io_b; // @[src/main/scala/Logic.scala 12:19]
  wire  _io_orOut_T = io_a | io_b; // @[src/main/scala/Logic.scala 12:42]
  assign io_andOut = io_a & io_b; // @[src/main/scala/Logic.scala 12:19]
  assign io_orOut = io_a | io_b; // @[src/main/scala/Logic.scala 12:42]
  assign io_notOut = ~io_a; // @[src/main/scala/Logic.scala 12:62]
  assign io_xorOut = io_a ^ io_b; // @[src/main/scala/Logic.scala 13:19]
  assign io_nandOut = ~_io_andOut_T; // @[src/main/scala/Logic.scala 13:39]
  assign io_norOut = ~_io_orOut_T; // @[src/main/scala/Logic.scala 13:67]
endmodule
module SelectBit( // @[src/main/scala/Logic.scala 15:7]
  input   io_a, // @[src/main/scala/Logic.scala 16:12]
  input   io_b, // @[src/main/scala/Logic.scala 16:12]
  input   io_select, // @[src/main/scala/Logic.scala 16:12]
  output  io_out // @[src/main/scala/Logic.scala 16:12]
);
  assign io_out = io_select ? io_b : io_a; // @[src/main/scala/Logic.scala 17:14]
endmodule
module UnsignedCompare4( // @[src/main/scala/Logic.scala 19:7]
  input  [3:0] io_a, // @[src/main/scala/Logic.scala 20:12]
  input  [3:0] io_b, // @[src/main/scala/Logic.scala 20:12]
  output       io_lt, // @[src/main/scala/Logic.scala 20:12]
  output       io_eq, // @[src/main/scala/Logic.scala 20:12]
  output       io_gt // @[src/main/scala/Logic.scala 20:12]
);
  assign io_lt = io_a < io_b; // @[src/main/scala/Logic.scala 21:14]
  assign io_eq = io_a == io_b; // @[src/main/scala/Logic.scala 21:31]
  assign io_gt = io_a > io_b; // @[src/main/scala/Logic.scala 21:50]
endmodule
module LogicTop( // @[src/main/scala/Logic.scala 24:7]
  input        clock, // @[src/main/scala/Logic.scala 24:7]
  input        reset, // @[src/main/scala/Logic.scala 24:7]
  input  [3:0] io_a, // @[src/main/scala/Logic.scala 25:12]
  input  [3:0] io_b, // @[src/main/scala/Logic.scala 25:12]
  input        io_select, // @[src/main/scala/Logic.scala 25:12]
  output [5:0] io_gates, // @[src/main/scala/Logic.scala 25:12]
  output       io_selected, // @[src/main/scala/Logic.scala 25:12]
  output       io_lt, // @[src/main/scala/Logic.scala 25:12]
  output       io_eq, // @[src/main/scala/Logic.scala 25:12]
  output       io_gt // @[src/main/scala/Logic.scala 25:12]
);
  wire  gates_io_a; // @[src/main/scala/Logic.scala 30:19]
  wire  gates_io_b; // @[src/main/scala/Logic.scala 30:19]
  wire  gates_io_andOut; // @[src/main/scala/Logic.scala 30:19]
  wire  gates_io_orOut; // @[src/main/scala/Logic.scala 30:19]
  wire  gates_io_notOut; // @[src/main/scala/Logic.scala 30:19]
  wire  gates_io_xorOut; // @[src/main/scala/Logic.scala 30:19]
  wire  gates_io_nandOut; // @[src/main/scala/Logic.scala 30:19]
  wire  gates_io_norOut; // @[src/main/scala/Logic.scala 30:19]
  wire  mux_io_a; // @[src/main/scala/Logic.scala 33:17]
  wire  mux_io_b; // @[src/main/scala/Logic.scala 33:17]
  wire  mux_io_select; // @[src/main/scala/Logic.scala 33:17]
  wire  mux_io_out; // @[src/main/scala/Logic.scala 33:17]
  wire [3:0] cmp_io_a; // @[src/main/scala/Logic.scala 34:17]
  wire [3:0] cmp_io_b; // @[src/main/scala/Logic.scala 34:17]
  wire  cmp_io_lt; // @[src/main/scala/Logic.scala 34:17]
  wire  cmp_io_eq; // @[src/main/scala/Logic.scala 34:17]
  wire  cmp_io_gt; // @[src/main/scala/Logic.scala 34:17]
  wire [2:0] io_gates_lo = {gates_io_notOut,gates_io_orOut,gates_io_andOut}; // @[src/main/scala/Logic.scala 32:16]
  wire [2:0] io_gates_hi = {gates_io_norOut,gates_io_nandOut,gates_io_xorOut}; // @[src/main/scala/Logic.scala 32:16]
  BasicGates gates ( // @[src/main/scala/Logic.scala 30:19]
    .io_a(gates_io_a),
    .io_b(gates_io_b),
    .io_andOut(gates_io_andOut),
    .io_orOut(gates_io_orOut),
    .io_notOut(gates_io_notOut),
    .io_xorOut(gates_io_xorOut),
    .io_nandOut(gates_io_nandOut),
    .io_norOut(gates_io_norOut)
  );
  SelectBit mux ( // @[src/main/scala/Logic.scala 33:17]
    .io_a(mux_io_a),
    .io_b(mux_io_b),
    .io_select(mux_io_select),
    .io_out(mux_io_out)
  );
  UnsignedCompare4 cmp ( // @[src/main/scala/Logic.scala 34:17]
    .io_a(cmp_io_a),
    .io_b(cmp_io_b),
    .io_lt(cmp_io_lt),
    .io_eq(cmp_io_eq),
    .io_gt(cmp_io_gt)
  );
  assign io_gates = {io_gates_hi,io_gates_lo}; // @[src/main/scala/Logic.scala 32:16]
  assign io_selected = mux_io_out; // @[src/main/scala/Logic.scala 33:105]
  assign io_lt = cmp_io_lt; // @[src/main/scala/Logic.scala 34:75]
  assign io_eq = cmp_io_eq; // @[src/main/scala/Logic.scala 34:92]
  assign io_gt = cmp_io_gt; // @[src/main/scala/Logic.scala 34:109]
  assign gates_io_a = io_a[0]; // @[src/main/scala/Logic.scala 30:52]
  assign gates_io_b = io_b[0]; // @[src/main/scala/Logic.scala 30:72]
  assign mux_io_a = io_a[0]; // @[src/main/scala/Logic.scala 33:47]
  assign mux_io_b = io_b[0]; // @[src/main/scala/Logic.scala 33:65]
  assign mux_io_select = io_select; // @[src/main/scala/Logic.scala 33:82]
  assign cmp_io_a = io_a; // @[src/main/scala/Logic.scala 34:48]
  assign cmp_io_b = io_b; // @[src/main/scala/Logic.scala 34:63]
endmodule
