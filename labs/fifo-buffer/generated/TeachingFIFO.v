module TeachingFIFO( // @[src/main/scala/TeachingFIFO.scala 6:7]
  input        clock, // @[src/main/scala/TeachingFIFO.scala 6:7]
  input        reset, // @[src/main/scala/TeachingFIFO.scala 6:7]
  input        io_step, // @[src/main/scala/TeachingFIFO.scala 9:11]
  input        io_clear, // @[src/main/scala/TeachingFIFO.scala 9:11]
  input        io_push, // @[src/main/scala/TeachingFIFO.scala 9:11]
  input        io_pop, // @[src/main/scala/TeachingFIFO.scala 9:11]
  input  [7:0] io_data, // @[src/main/scala/TeachingFIFO.scala 9:11]
  output       io_pushAccepted, // @[src/main/scala/TeachingFIFO.scala 9:11]
  output       io_popAccepted, // @[src/main/scala/TeachingFIFO.scala 9:11]
  output [7:0] io_head, // @[src/main/scala/TeachingFIFO.scala 9:11]
  output       io_valid, // @[src/main/scala/TeachingFIFO.scala 9:11]
  output       io_empty, // @[src/main/scala/TeachingFIFO.scala 9:11]
  output       io_full, // @[src/main/scala/TeachingFIFO.scala 9:11]
  output [1:0] io_readPointer, // @[src/main/scala/TeachingFIFO.scala 9:11]
  output [1:0] io_writePointer, // @[src/main/scala/TeachingFIFO.scala 9:11]
  output [2:0] io_count, // @[src/main/scala/TeachingFIFO.scala 9:11]
  output [7:0] io_saved_0, // @[src/main/scala/TeachingFIFO.scala 9:11]
  output [7:0] io_saved_1, // @[src/main/scala/TeachingFIFO.scala 9:11]
  output [7:0] io_saved_2, // @[src/main/scala/TeachingFIFO.scala 9:11]
  output [7:0] io_saved_3 // @[src/main/scala/TeachingFIFO.scala 9:11]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
`endif // RANDOMIZE_REG_INIT
  reg [7:0] mem_0; // @[src/main/scala/TeachingFIFO.scala 16:17]
  reg [7:0] mem_1; // @[src/main/scala/TeachingFIFO.scala 16:17]
  reg [7:0] mem_2; // @[src/main/scala/TeachingFIFO.scala 16:17]
  reg [7:0] mem_3; // @[src/main/scala/TeachingFIFO.scala 16:17]
  reg [1:0] rp; // @[src/main/scala/TeachingFIFO.scala 17:16]
  reg [1:0] wp; // @[src/main/scala/TeachingFIFO.scala 17:48]
  reg [2:0] count; // @[src/main/scala/TeachingFIFO.scala 17:83]
  wire  allowed = io_step & ~io_clear & ~reset; // @[src/main/scala/TeachingFIFO.scala 18:35]
  wire  takePop = allowed & io_pop & count != 3'h0; // @[src/main/scala/TeachingFIFO.scala 19:32]
  wire  takePush = allowed & io_push & (count < 3'h4 | takePop); // @[src/main/scala/TeachingFIFO.scala 20:34]
  wire [1:0] _wp_T_1 = wp + 2'h1; // @[src/main/scala/TeachingFIFO.scala 23:41]
  wire [1:0] _rp_T_1 = rp + 2'h1; // @[src/main/scala/TeachingFIFO.scala 24:23]
  wire [2:0] _count_T_1 = count + 3'h1; // @[src/main/scala/TeachingFIFO.scala 25:42]
  wire [2:0] _count_T_3 = count - 3'h1; // @[src/main/scala/TeachingFIFO.scala 26:42]
  wire [7:0] _GEN_20 = 2'h1 == rp ? mem_1 : mem_0; // @[src/main/scala/TeachingFIFO.scala 30:{14,14}]
  wire [7:0] _GEN_21 = 2'h2 == rp ? mem_2 : _GEN_20; // @[src/main/scala/TeachingFIFO.scala 30:{14,14}]
  wire [7:0] _GEN_22 = 2'h3 == rp ? mem_3 : _GEN_21; // @[src/main/scala/TeachingFIFO.scala 30:{14,14}]
  assign io_pushAccepted = allowed & io_push & (count < 3'h4 | takePop); // @[src/main/scala/TeachingFIFO.scala 20:34]
  assign io_popAccepted = allowed & io_pop & count != 3'h0; // @[src/main/scala/TeachingFIFO.scala 19:32]
  assign io_head = io_valid ? _GEN_22 : 8'h0; // @[src/main/scala/TeachingFIFO.scala 30:14]
  assign io_valid = count != 3'h0; // @[src/main/scala/TeachingFIFO.scala 29:17]
  assign io_empty = count == 3'h0; // @[src/main/scala/TeachingFIFO.scala 29:39]
  assign io_full = count == 3'h4; // @[src/main/scala/TeachingFIFO.scala 29:60]
  assign io_readPointer = rp; // @[src/main/scala/TeachingFIFO.scala 30:51]
  assign io_writePointer = wp; // @[src/main/scala/TeachingFIFO.scala 30:71]
  assign io_count = count; // @[src/main/scala/TeachingFIFO.scala 30:84]
  assign io_saved_0 = mem_0; // @[src/main/scala/TeachingFIFO.scala 30:100]
  assign io_saved_1 = mem_1; // @[src/main/scala/TeachingFIFO.scala 30:100]
  assign io_saved_2 = mem_2; // @[src/main/scala/TeachingFIFO.scala 30:100]
  assign io_saved_3 = mem_3; // @[src/main/scala/TeachingFIFO.scala 30:100]
  always @(posedge clock) begin
    if (reset) begin // @[src/main/scala/TeachingFIFO.scala 16:{17,17}]
      mem_0 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/TeachingFIFO.scala 21:{16,30}]
      mem_0 <= 8'h0;
    end else if (takePush) begin // @[src/main/scala/TeachingFIFO.scala 16:17 23:17]
      if (2'h0 == wp) begin // @[src/main/scala/TeachingFIFO.scala 16:17]
        mem_0 <= io_data; // @[src/main/scala/TeachingFIFO.scala 23:25]
      end
    end
    if (reset) begin // @[src/main/scala/TeachingFIFO.scala 16:{17,17}]
      mem_1 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/TeachingFIFO.scala 21:{16,30}]
      mem_1 <= 8'h0;
    end else if (takePush) begin // @[src/main/scala/TeachingFIFO.scala 16:17 23:17]
      if (2'h1 == wp) begin // @[src/main/scala/TeachingFIFO.scala 16:17]
        mem_1 <= io_data; // @[src/main/scala/TeachingFIFO.scala 23:25]
      end
    end
    if (reset) begin // @[src/main/scala/TeachingFIFO.scala 16:{17,17}]
      mem_2 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/TeachingFIFO.scala 21:{16,30}]
      mem_2 <= 8'h0;
    end else if (takePush) begin // @[src/main/scala/TeachingFIFO.scala 16:17 23:17]
      if (2'h2 == wp) begin // @[src/main/scala/TeachingFIFO.scala 16:17]
        mem_2 <= io_data; // @[src/main/scala/TeachingFIFO.scala 23:25]
      end
    end
    if (reset) begin // @[src/main/scala/TeachingFIFO.scala 16:{17,17}]
      mem_3 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/TeachingFIFO.scala 21:{16,30}]
      mem_3 <= 8'h0;
    end else if (takePush) begin // @[src/main/scala/TeachingFIFO.scala 16:17 23:17]
      if (2'h3 == wp) begin // @[src/main/scala/TeachingFIFO.scala 16:17]
        mem_3 <= io_data; // @[src/main/scala/TeachingFIFO.scala 23:25]
      end
    end
    if (reset) begin // @[src/main/scala/TeachingFIFO.scala 17:{16,16}]
      rp <= 2'h0;
    end else if (io_clear) begin // @[src/main/scala/TeachingFIFO.scala 21:{16,39}]
      rp <= 2'h0;
    end else if (takePop) begin // @[src/main/scala/TeachingFIFO.scala 17:16]
      rp <= _rp_T_1; // @[src/main/scala/TeachingFIFO.scala 24:16]
    end
    if (reset) begin // @[src/main/scala/TeachingFIFO.scala 17:{48,48}]
      wp <= 2'h0;
    end else if (io_clear) begin // @[src/main/scala/TeachingFIFO.scala 21:{16,47}]
      wp <= 2'h0;
    end else if (takePush) begin // @[src/main/scala/TeachingFIFO.scala 23:17]
      wp <= _wp_T_1; // @[src/main/scala/TeachingFIFO.scala 23:37]
    end
    if (reset) begin // @[src/main/scala/TeachingFIFO.scala 17:{83,83}]
      count <= 3'h0;
    end else if (io_clear) begin // @[src/main/scala/TeachingFIFO.scala 21:{16,58}]
      count <= 3'h0;
    end else if (takePop & ~takePush) begin // @[src/main/scala/TeachingFIFO.scala 26:{29,35}]
      count <= _count_T_3;
    end else if (takePush & ~takePop) begin // @[src/main/scala/TeachingFIFO.scala 25:29]
      count <= _count_T_1; // @[src/main/scala/TeachingFIFO.scala 25:35]
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
  mem_0 = _RAND_0[7:0];
  _RAND_1 = {1{`RANDOM}};
  mem_1 = _RAND_1[7:0];
  _RAND_2 = {1{`RANDOM}};
  mem_2 = _RAND_2[7:0];
  _RAND_3 = {1{`RANDOM}};
  mem_3 = _RAND_3[7:0];
  _RAND_4 = {1{`RANDOM}};
  rp = _RAND_4[1:0];
  _RAND_5 = {1{`RANDOM}};
  wp = _RAND_5[1:0];
  _RAND_6 = {1{`RANDOM}};
  count = _RAND_6[2:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
