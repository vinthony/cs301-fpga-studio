module UARTBitRX( // @[src/main/scala/UARTBitRX.scala 6:7]
  input        clock, // @[src/main/scala/UARTBitRX.scala 6:7]
  input        reset, // @[src/main/scala/UARTBitRX.scala 6:7]
  input        io_step, // @[src/main/scala/UARTBitRX.scala 7:11]
  input        io_clear, // @[src/main/scala/UARTBitRX.scala 7:11]
  input        io_rx, // @[src/main/scala/UARTBitRX.scala 7:11]
  output [7:0] io_data, // @[src/main/scala/UARTBitRX.scala 7:11]
  output [3:0] io_phase, // @[src/main/scala/UARTBitRX.scala 7:11]
  output       io_busy, // @[src/main/scala/UARTBitRX.scala 7:11]
  output       io_valid, // @[src/main/scala/UARTBitRX.scala 7:11]
  output       io_error // @[src/main/scala/UARTBitRX.scala 7:11]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
`endif // RANDOMIZE_REG_INIT
  reg [7:0] data; // @[src/main/scala/UARTBitRX.scala 11:18]
  reg [3:0] phase; // @[src/main/scala/UARTBitRX.scala 11:46]
  reg  valid; // @[src/main/scala/UARTBitRX.scala 11:75]
  reg  error; // @[src/main/scala/UARTBitRX.scala 11:102]
  wire  _T_1 = ~io_rx; // @[src/main/scala/UARTBitRX.scala 15:27]
  wire [3:0] _GEN_0 = ~io_rx ? 4'h0 : phase; // @[src/main/scala/UARTBitRX.scala 15:{34,40} 11:46]
  wire [7:0] _GEN_1 = ~io_rx ? 8'h0 : data; // @[src/main/scala/UARTBitRX.scala 11:18 15:{34,50}]
  wire [22:0] _data_T = 23'h1 << phase; // @[src/main/scala/UARTBitRX.scala 16:58]
  wire [22:0] _GEN_19 = {{15'd0}, data}; // @[src/main/scala/UARTBitRX.scala 16:47]
  wire [22:0] _data_T_1 = _GEN_19 | _data_T; // @[src/main/scala/UARTBitRX.scala 16:47]
  wire [22:0] _GEN_2 = io_rx ? _data_T_1 : {{15'd0}, data}; // @[src/main/scala/UARTBitRX.scala 11:18 16:{35,40}]
  wire [3:0] _phase_T_1 = phase + 4'h1; // @[src/main/scala/UARTBitRX.scala 16:80]
  wire [22:0] _GEN_3 = phase < 4'h8 ? _GEN_2 : {{15'd0}, data}; // @[src/main/scala/UARTBitRX.scala 11:18 16:23]
  wire [3:0] _GEN_4 = phase < 4'h8 ? _phase_T_1 : 4'hf; // @[src/main/scala/UARTBitRX.scala 16:{23,73} 17:48]
  wire  _GEN_5 = phase < 4'h8 ? 1'h0 : io_rx; // @[src/main/scala/UARTBitRX.scala 16:23 14:8 17:19]
  wire  _GEN_6 = phase < 4'h8 ? 1'h0 : _T_1; // @[src/main/scala/UARTBitRX.scala 14:23 16:23 17:33]
  wire [22:0] _GEN_8 = phase == 4'hf ? {{15'd0}, _GEN_1} : _GEN_3; // @[src/main/scala/UARTBitRX.scala 15:21]
  wire [22:0] _GEN_14 = io_step ? _GEN_8 : {{15'd0}, data}; // @[src/main/scala/UARTBitRX.scala 11:18 13:20]
  wire [22:0] _GEN_15 = io_clear ? 23'h0 : _GEN_14; // @[src/main/scala/UARTBitRX.scala 12:{16,21}]
  wire [22:0] _GEN_20 = reset ? 23'h0 : _GEN_15; // @[src/main/scala/UARTBitRX.scala 11:{18,18}]
  assign io_data = data; // @[src/main/scala/UARTBitRX.scala 19:9]
  assign io_phase = phase; // @[src/main/scala/UARTBitRX.scala 19:24]
  assign io_busy = phase != 4'hf; // @[src/main/scala/UARTBitRX.scala 19:46]
  assign io_valid = valid; // @[src/main/scala/UARTBitRX.scala 19:62]
  assign io_error = error; // @[src/main/scala/UARTBitRX.scala 19:78]
  always @(posedge clock) begin
    data <= _GEN_20[7:0]; // @[src/main/scala/UARTBitRX.scala 11:{18,18}]
    if (reset) begin // @[src/main/scala/UARTBitRX.scala 11:{46,46}]
      phase <= 4'hf;
    end else if (io_clear) begin // @[src/main/scala/UARTBitRX.scala 12:{16,32}]
      phase <= 4'hf;
    end else if (io_step) begin // @[src/main/scala/UARTBitRX.scala 13:20 11:46]
      if (phase == 4'hf) begin // @[src/main/scala/UARTBitRX.scala 15:21]
        phase <= _GEN_0;
      end else begin
        phase <= _GEN_4;
      end
    end
    if (reset) begin // @[src/main/scala/UARTBitRX.scala 11:{75,75}]
      valid <= 1'h0;
    end else if (io_clear) begin // @[src/main/scala/UARTBitRX.scala 12:{16,44}]
      valid <= 1'h0;
    end else if (io_step) begin // @[src/main/scala/UARTBitRX.scala 13:20 11:75]
      if (phase == 4'hf) begin // @[src/main/scala/UARTBitRX.scala 15:21 14:8]
        valid <= 1'h0;
      end else begin
        valid <= _GEN_5;
      end
    end
    if (reset) begin // @[src/main/scala/UARTBitRX.scala 11:{102,102}]
      error <= 1'h0;
    end else if (io_clear) begin // @[src/main/scala/UARTBitRX.scala 12:{16,59}]
      error <= 1'h0;
    end else if (io_step) begin // @[src/main/scala/UARTBitRX.scala 11:102 13:20]
      if (phase == 4'hf) begin // @[src/main/scala/UARTBitRX.scala 15:21 14:23]
        error <= 1'h0;
      end else begin
        error <= _GEN_6;
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
  data = _RAND_0[7:0];
  _RAND_1 = {1{`RANDOM}};
  phase = _RAND_1[3:0];
  _RAND_2 = {1{`RANDOM}};
  valid = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  error = _RAND_3[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
