module UARTBitTX( // @[src/main/scala/UARTBitTX.scala 6:7]
  input        clock, // @[src/main/scala/UARTBitTX.scala 6:7]
  input        reset, // @[src/main/scala/UARTBitTX.scala 6:7]
  input        io_step, // @[src/main/scala/UARTBitTX.scala 7:11]
  input        io_clear, // @[src/main/scala/UARTBitTX.scala 7:11]
  input        io_send, // @[src/main/scala/UARTBitTX.scala 7:11]
  input  [7:0] io_data, // @[src/main/scala/UARTBitTX.scala 7:11]
  output       io_tx, // @[src/main/scala/UARTBitTX.scala 7:11]
  output       io_busy, // @[src/main/scala/UARTBitTX.scala 7:11]
  output       io_done, // @[src/main/scala/UARTBitTX.scala 7:11]
  output       io_accepted, // @[src/main/scala/UARTBitTX.scala 7:11]
  output [3:0] io_phase, // @[src/main/scala/UARTBitTX.scala 7:11]
  output [7:0] io_captured // @[src/main/scala/UARTBitTX.scala 7:11]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  reg [3:0] phase; // @[src/main/scala/UARTBitTX.scala 12:19]
  reg [7:0] captured; // @[src/main/scala/UARTBitTX.scala 12:51]
  reg  done; // @[src/main/scala/UARTBitTX.scala 12:78]
  wire  busy = phase != 4'hf; // @[src/main/scala/UARTBitTX.scala 13:16]
  wire  _io_accepted_T_5 = ~busy; // @[src/main/scala/UARTBitTX.scala 14:67]
  wire [7:0] _GEN_0 = io_send ? io_data : captured; // @[src/main/scala/UARTBitTX.scala 18:{28,37} 12:51]
  wire [3:0] _GEN_1 = io_send ? 4'h0 : phase; // @[src/main/scala/UARTBitTX.scala 12:19 18:{28,52}]
  wire  _T_1 = phase == 4'h9; // @[src/main/scala/UARTBitTX.scala 19:18]
  wire [3:0] _phase_T_1 = phase + 4'h1; // @[src/main/scala/UARTBitTX.scala 20:26]
  wire [3:0] _GEN_2 = phase == 4'h9 ? 4'hf : _phase_T_1; // @[src/main/scala/UARTBitTX.scala 19:{25,31} 20:19]
  wire [3:0] _io_tx_T_4 = phase - 4'h1; // @[src/main/scala/UARTBitTX.scala 22:90]
  wire [7:0] _io_tx_T_5 = captured >> _io_tx_T_4; // @[src/main/scala/UARTBitTX.scala 22:82]
  wire  _io_tx_T_8 = phase == 4'h0 ? 1'h0 : _T_1 | _io_tx_T_5[0]; // @[src/main/scala/UARTBitTX.scala 22:29]
  assign io_tx = _io_accepted_T_5 | _io_tx_T_8; // @[src/main/scala/UARTBitTX.scala 22:12]
  assign io_busy = phase != 4'hf; // @[src/main/scala/UARTBitTX.scala 13:16]
  assign io_done = done; // @[src/main/scala/UARTBitTX.scala 23:23]
  assign io_accepted = io_step & ~io_clear & ~reset & io_send & ~busy; // @[src/main/scala/UARTBitTX.scala 14:64]
  assign io_phase = phase; // @[src/main/scala/UARTBitTX.scala 23:38]
  assign io_captured = captured; // @[src/main/scala/UARTBitTX.scala 23:57]
  always @(posedge clock) begin
    if (reset) begin // @[src/main/scala/UARTBitTX.scala 12:{19,19}]
      phase <= 4'hf;
    end else if (io_clear) begin // @[src/main/scala/UARTBitTX.scala 15:{16,22}]
      phase <= 4'hf;
    end else if (io_step) begin // @[src/main/scala/UARTBitTX.scala 12:19 16:20]
      if (_io_accepted_T_5) begin // @[src/main/scala/UARTBitTX.scala 18:14]
        phase <= _GEN_1;
      end else begin
        phase <= _GEN_2;
      end
    end
    if (reset) begin // @[src/main/scala/UARTBitTX.scala 12:{51,51}]
      captured <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/UARTBitTX.scala 15:{16,37}]
      captured <= 8'h0;
    end else if (io_step) begin // @[src/main/scala/UARTBitTX.scala 16:20 12:51]
      if (_io_accepted_T_5) begin // @[src/main/scala/UARTBitTX.scala 18:14 12:51]
        captured <= _GEN_0;
      end
    end
    if (reset) begin // @[src/main/scala/UARTBitTX.scala 12:{78,78}]
      done <= 1'h0;
    end else if (io_clear) begin // @[src/main/scala/UARTBitTX.scala 15:{16,47}]
      done <= 1'h0;
    end else if (io_step) begin // @[src/main/scala/UARTBitTX.scala 16:20 12:78]
      if (_io_accepted_T_5) begin // @[src/main/scala/UARTBitTX.scala 18:14 17:7]
        done <= 1'h0;
      end else begin
        done <= _T_1;
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
  phase = _RAND_0[3:0];
  _RAND_1 = {1{`RANDOM}};
  captured = _RAND_1[7:0];
  _RAND_2 = {1{`RANDOM}};
  done = _RAND_2[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
