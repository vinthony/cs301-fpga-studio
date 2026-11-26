module InputConditioner( // @[src/main/scala/InputConditioner.scala 7:7]
  input         clock, // @[src/main/scala/InputConditioner.scala 7:7]
  input         reset, // @[src/main/scala/InputConditioner.scala 7:7]
  input         io_raw, // @[src/main/scala/InputConditioner.scala 9:12]
  input         io_sample, // @[src/main/scala/InputConditioner.scala 9:12]
  input         io_clear, // @[src/main/scala/InputConditioner.scala 9:12]
  output        io_sync1, // @[src/main/scala/InputConditioner.scala 9:12]
  output        io_sync2, // @[src/main/scala/InputConditioner.scala 9:12]
  output        io_candidate, // @[src/main/scala/InputConditioner.scala 9:12]
  output [31:0] io_consecutive, // @[src/main/scala/InputConditioner.scala 9:12]
  output        io_stable, // @[src/main/scala/InputConditioner.scala 9:12]
  output        io_previous, // @[src/main/scala/InputConditioner.scala 9:12]
  output        io_event // @[src/main/scala/InputConditioner.scala 9:12]
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
  reg  first; // @[src/main/scala/InputConditioner.scala 15:20]
  reg  second; // @[src/main/scala/InputConditioner.scala 15:48]
  reg  candidate; // @[src/main/scala/InputConditioner.scala 16:24]
  reg [31:0] count; // @[src/main/scala/InputConditioner.scala 16:51]
  reg  stable; // @[src/main/scala/InputConditioner.scala 17:21]
  reg  previous; // @[src/main/scala/InputConditioner.scala 17:51]
  reg  event_; // @[src/main/scala/InputConditioner.scala 17:78]
  wire  _nextCandidate_T = second == candidate; // @[src/main/scala/InputConditioner.scala 19:31]
  wire  nextCandidate = second == candidate ? candidate : second; // @[src/main/scala/InputConditioner.scala 19:24]
  wire [31:0] _nextCount_T_3 = count + 32'h1; // @[src/main/scala/InputConditioner.scala 21:71]
  wire [31:0] _nextCount_T_4 = count == 32'hffffffff ? count : _nextCount_T_3; // @[src/main/scala/InputConditioner.scala 21:43]
  wire [31:0] nextCount = _nextCandidate_T ? _nextCount_T_4 : 32'h1; // @[src/main/scala/InputConditioner.scala 21:20]
  wire  nextStable = nextCount >= 32'h3 ? nextCandidate : stable; // @[src/main/scala/InputConditioner.scala 22:21]
  assign io_sync1 = first; // @[src/main/scala/InputConditioner.scala 30:11]
  assign io_sync2 = second; // @[src/main/scala/InputConditioner.scala 30:27]
  assign io_candidate = candidate; // @[src/main/scala/InputConditioner.scala 30:48]
  assign io_consecutive = count; // @[src/main/scala/InputConditioner.scala 30:74]
  assign io_stable = stable; // @[src/main/scala/InputConditioner.scala 31:12]
  assign io_previous = previous; // @[src/main/scala/InputConditioner.scala 31:32]
  assign io_event = event_; // @[src/main/scala/InputConditioner.scala 31:51]
  always @(posedge clock) begin
    if (reset) begin // @[src/main/scala/InputConditioner.scala 15:{20,20}]
      first <= 1'h0;
    end else if (io_clear) begin // @[src/main/scala/InputConditioner.scala 23:17 24:10]
      first <= 1'h0;
    end else if (io_sample) begin // @[src/main/scala/InputConditioner.scala 26:24]
      first <= io_raw; // @[src/main/scala/InputConditioner.scala 27:10]
    end
    if (reset) begin // @[src/main/scala/InputConditioner.scala 15:{48,48}]
      second <= 1'h0;
    end else if (io_clear) begin // @[src/main/scala/InputConditioner.scala 23:17 24:26]
      second <= 1'h0;
    end else if (io_sample) begin // @[src/main/scala/InputConditioner.scala 26:24]
      second <= first; // @[src/main/scala/InputConditioner.scala 27:25]
    end
    if (reset) begin // @[src/main/scala/InputConditioner.scala 16:{24,24}]
      candidate <= 1'h0;
    end else if (io_clear) begin // @[src/main/scala/InputConditioner.scala 23:17 24:45]
      candidate <= 1'h0;
    end else if (io_sample) begin // @[src/main/scala/InputConditioner.scala 16:24]
      if (!(second == candidate)) begin // @[src/main/scala/InputConditioner.scala 19:24]
        candidate <= second;
      end
    end
    if (reset) begin // @[src/main/scala/InputConditioner.scala 16:{51,51}]
      count <= 32'h0;
    end else if (io_clear) begin // @[src/main/scala/InputConditioner.scala 23:17 24:60]
      count <= 32'h0;
    end else if (io_sample) begin // @[src/main/scala/InputConditioner.scala 26:24]
      if (_nextCandidate_T) begin // @[src/main/scala/InputConditioner.scala 21:20]
        count <= _nextCount_T_4;
      end else begin
        count <= 32'h1;
      end
    end
    if (reset) begin // @[src/main/scala/InputConditioner.scala 17:{21,21}]
      stable <= 1'h0;
    end else if (io_clear) begin // @[src/main/scala/InputConditioner.scala 23:17 25:11]
      stable <= 1'h0;
    end else if (io_sample) begin // @[src/main/scala/InputConditioner.scala 26:24]
      if (nextCount >= 32'h3) begin // @[src/main/scala/InputConditioner.scala 22:21]
        stable <= nextCandidate;
      end
    end
    if (reset) begin // @[src/main/scala/InputConditioner.scala 17:{51,51}]
      previous <= 1'h0;
    end else if (io_clear) begin // @[src/main/scala/InputConditioner.scala 23:17 25:29]
      previous <= 1'h0;
    end else if (io_sample) begin // @[src/main/scala/InputConditioner.scala 26:24]
      previous <= stable; // @[src/main/scala/InputConditioner.scala 28:32]
    end
    if (reset) begin // @[src/main/scala/InputConditioner.scala 17:{78,78}]
      event_ <= 1'h0;
    end else if (io_clear) begin // @[src/main/scala/InputConditioner.scala 23:17 25:44]
      event_ <= 1'h0;
    end else if (io_sample) begin // @[src/main/scala/InputConditioner.scala 26:24]
      event_ <= nextStable & ~stable; // @[src/main/scala/InputConditioner.scala 28:46]
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
  first = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  second = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  candidate = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  count = _RAND_3[31:0];
  _RAND_4 = {1{`RANDOM}};
  stable = _RAND_4[0:0];
  _RAND_5 = {1{`RANDOM}};
  previous = _RAND_5[0:0];
  _RAND_6 = {1{`RANDOM}};
  event_ = _RAND_6[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
