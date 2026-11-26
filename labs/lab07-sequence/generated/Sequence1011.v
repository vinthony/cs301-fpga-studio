module Sequence1011( // @[src/main/scala/Sequence1011.scala 8:7]
  input         clock, // @[src/main/scala/Sequence1011.scala 8:7]
  input         reset, // @[src/main/scala/Sequence1011.scala 8:7]
  input         io_bitIn, // @[src/main/scala/Sequence1011.scala 9:14]
  input         io_enable, // @[src/main/scala/Sequence1011.scala 9:14]
  output [1:0]  io_state, // @[src/main/scala/Sequence1011.scala 9:14]
  output [1:0]  io_nextState, // @[src/main/scala/Sequence1011.scala 9:14]
  output        io_candidate, // @[src/main/scala/Sequence1011.scala 9:14]
  output        io_hit, // @[src/main/scala/Sequence1011.scala 9:14]
  output [31:0] io_count // @[src/main/scala/Sequence1011.scala 9:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  reg [1:0] state; // @[src/main/scala/Sequence1011.scala 18:22]
  reg  hit; // @[src/main/scala/Sequence1011.scala 19:20]
  reg [31:0] count; // @[src/main/scala/Sequence1011.scala 20:22]
  wire [1:0] _next_T_1 = io_bitIn ? 2'h1 : 2'h2; // @[src/main/scala/Sequence1011.scala 24:26]
  wire [1:0] _next_T_2 = io_bitIn ? 2'h3 : 2'h0; // @[src/main/scala/Sequence1011.scala 25:26]
  wire [1:0] _GEN_0 = 2'h3 == state ? _next_T_1 : 2'h0; // @[src/main/scala/Sequence1011.scala 22:17 26:20 21:25]
  wire [1:0] _GEN_1 = 2'h2 == state ? _next_T_2 : _GEN_0; // @[src/main/scala/Sequence1011.scala 22:17 25:20]
  wire [1:0] _GEN_2 = 2'h1 == state ? _next_T_1 : _GEN_1; // @[src/main/scala/Sequence1011.scala 22:17 24:20]
  wire [1:0] next = 2'h0 == state ? {{1'd0}, io_bitIn} : _GEN_2; // @[src/main/scala/Sequence1011.scala 22:17 23:20]
  wire  candidate = state == 2'h3 & io_bitIn & ~reset; // @[src/main/scala/Sequence1011.scala 28:45]
  wire [31:0] _count_T_1 = count + 32'h1; // @[src/main/scala/Sequence1011.scala 32:38]
  assign io_state = state; // @[src/main/scala/Sequence1011.scala 34:12]
  assign io_nextState = reset ? 2'h0 : next; // @[src/main/scala/Sequence1011.scala 35:22]
  assign io_candidate = state == 2'h3 & io_bitIn & ~reset; // @[src/main/scala/Sequence1011.scala 28:45]
  assign io_hit = hit; // @[src/main/scala/Sequence1011.scala 37:10]
  assign io_count = count; // @[src/main/scala/Sequence1011.scala 38:12]
  always @(posedge clock) begin
    if (reset) begin // @[src/main/scala/Sequence1011.scala 18:{22,22}]
      state <= 2'h0;
    end else if (io_enable) begin // @[src/main/scala/Sequence1011.scala 29:19]
      if (2'h0 == state) begin // @[src/main/scala/Sequence1011.scala 22:17 23:20]
        state <= {{1'd0}, io_bitIn};
      end else if (2'h1 == state) begin // @[src/main/scala/Sequence1011.scala 22:17 24:20]
        state <= _next_T_1;
      end else begin
        state <= _GEN_1;
      end
    end
    if (reset) begin // @[src/main/scala/Sequence1011.scala 19:{20,20}]
      hit <= 1'h0;
    end else if (io_enable) begin // @[src/main/scala/Sequence1011.scala 29:19]
      hit <= candidate; // @[src/main/scala/Sequence1011.scala 19:20]
    end
    if (reset) begin // @[src/main/scala/Sequence1011.scala 20:{22,22}]
      count <= 32'h0;
    end else if (io_enable) begin // @[src/main/scala/Sequence1011.scala 29:19 20:22]
      if (candidate) begin // @[src/main/scala/Sequence1011.scala 32:21]
        count <= _count_T_1; // @[src/main/scala/Sequence1011.scala 20:22]
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  state = _RAND_0[1:0];
  _RAND_1 = {1{`RANDOM}};
  hit = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  count = _RAND_2[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
