module RegisterCompare( // @[src/main/scala/StateElements.scala 7:7]
  input        clock, // @[src/main/scala/StateElements.scala 7:7]
  input        reset, // @[src/main/scala/StateElements.scala 7:7]
  input  [3:0] io_data, // @[src/main/scala/StateElements.scala 9:12]
  input        io_enable, // @[src/main/scala/StateElements.scala 9:12]
  input        io_clear, // @[src/main/scala/StateElements.scala 9:12]
  output [3:0] io_regInitQ, // @[src/main/scala/StateElements.scala 9:12]
  output [3:0] io_regEnableQ // @[src/main/scala/StateElements.scala 9:12]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  reg [3:0] explicit; // @[src/main/scala/StateElements.scala 13:23]
  reg [3:0] enabled; // @[src/main/scala/StateElements.scala 16:60]
  assign io_regInitQ = explicit; // @[src/main/scala/StateElements.scala 17:14]
  assign io_regEnableQ = enabled; // @[src/main/scala/StateElements.scala 17:38]
  always @(posedge clock) begin
    if (reset) begin // @[src/main/scala/StateElements.scala 13:{23,23}]
      explicit <= 4'h0;
    end else if (io_clear) begin // @[src/main/scala/StateElements.scala 14:{17,26}]
      explicit <= 4'h0;
    end else if (io_enable) begin // @[src/main/scala/StateElements.scala 13:23]
      explicit <= io_data; // @[src/main/scala/StateElements.scala 14:52]
    end
    if (reset | io_clear) begin // @[src/main/scala/StateElements.scala 16:{60,60}]
      enabled <= 4'h0;
    end else if (io_enable) begin // @[src/main/scala/StateElements.scala 16:60]
      enabled <= io_data; // @[src/main/scala/StateElements.scala 16:60]
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
  explicit = _RAND_0[3:0];
  _RAND_1 = {1{`RANDOM}};
  enabled = _RAND_1[3:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module EnabledCounter( // @[src/main/scala/StateElements.scala 19:7]
  input        clock, // @[src/main/scala/StateElements.scala 19:7]
  input        reset, // @[src/main/scala/StateElements.scala 19:7]
  input        io_enable, // @[src/main/scala/StateElements.scala 21:12]
  input        io_clear, // @[src/main/scala/StateElements.scala 21:12]
  output [3:0] io_count // @[src/main/scala/StateElements.scala 21:12]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [3:0] count; // @[src/main/scala/StateElements.scala 22:20]
  wire [3:0] _count_T_1 = count + 4'h1; // @[src/main/scala/StateElements.scala 23:62]
  assign io_count = count; // @[src/main/scala/StateElements.scala 24:11]
  always @(posedge clock) begin
    if (reset) begin // @[src/main/scala/StateElements.scala 22:{20,20}]
      count <= 4'h0;
    end else if (io_clear) begin // @[src/main/scala/StateElements.scala 23:{17,23}]
      count <= 4'h0;
    end else if (io_enable) begin // @[src/main/scala/StateElements.scala 22:20]
      count <= _count_T_1; // @[src/main/scala/StateElements.scala 23:49]
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
  count = _RAND_0[3:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module BlinkDivider( // @[src/main/scala/StateElements.scala 27:7]
  input        clock, // @[src/main/scala/StateElements.scala 27:7]
  input        reset, // @[src/main/scala/StateElements.scala 27:7]
  input        io_enable, // @[src/main/scala/StateElements.scala 30:12]
  input        io_clear, // @[src/main/scala/StateElements.scala 30:12]
  output       io_led, // @[src/main/scala/StateElements.scala 30:12]
  output [1:0] io_phase // @[src/main/scala/StateElements.scala 30:12]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  reg [1:0] phase; // @[src/main/scala/StateElements.scala 31:20]
  reg  led; // @[src/main/scala/StateElements.scala 31:55]
  wire [1:0] _phase_T_1 = phase + 2'h1; // @[src/main/scala/StateElements.scala 33:81]
  assign io_led = led; // @[src/main/scala/StateElements.scala 35:9]
  assign io_phase = phase; // @[src/main/scala/StateElements.scala 35:23]
  always @(posedge clock) begin
    if (reset) begin // @[src/main/scala/StateElements.scala 31:{20,20}]
      phase <= 2'h0;
    end else if (io_clear) begin // @[src/main/scala/StateElements.scala 32:{17,23}]
      phase <= 2'h0;
    end else if (io_enable) begin // @[src/main/scala/StateElements.scala 31:20 32:62]
      if (phase == 2'h2) begin // @[src/main/scala/StateElements.scala 33:35]
        phase <= 2'h0; // @[src/main/scala/StateElements.scala 33:41]
      end else begin
        phase <= _phase_T_1; // @[src/main/scala/StateElements.scala 33:74]
      end
    end
    if (reset) begin // @[src/main/scala/StateElements.scala 31:{55,55}]
      led <= 1'h0;
    end else if (io_clear) begin // @[src/main/scala/StateElements.scala 32:{17,32}]
      led <= 1'h0;
    end else if (io_enable) begin // @[src/main/scala/StateElements.scala 31:55 32:62]
      if (phase == 2'h2) begin // @[src/main/scala/StateElements.scala 33:35]
        led <= ~led; // @[src/main/scala/StateElements.scala 33:50]
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
  phase = _RAND_0[1:0];
  _RAND_1 = {1{`RANDOM}};
  led = _RAND_1[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module StateDemoTop( // @[src/main/scala/StateElements.scala 39:7]
  input        clock, // @[src/main/scala/StateElements.scala 39:7]
  input        reset, // @[src/main/scala/StateElements.scala 39:7]
  input  [3:0] io_data, // @[src/main/scala/StateElements.scala 40:12]
  input        io_enable, // @[src/main/scala/StateElements.scala 40:12]
  input        io_clear, // @[src/main/scala/StateElements.scala 40:12]
  output [3:0] io_qInit, // @[src/main/scala/StateElements.scala 40:12]
  output [3:0] io_qEnable, // @[src/main/scala/StateElements.scala 40:12]
  output [3:0] io_count, // @[src/main/scala/StateElements.scala 40:12]
  output       io_blink, // @[src/main/scala/StateElements.scala 40:12]
  output [1:0] io_phase // @[src/main/scala/StateElements.scala 40:12]
);
  wire  registers_clock; // @[src/main/scala/StateElements.scala 45:23]
  wire  registers_reset; // @[src/main/scala/StateElements.scala 45:23]
  wire [3:0] registers_io_data; // @[src/main/scala/StateElements.scala 45:23]
  wire  registers_io_enable; // @[src/main/scala/StateElements.scala 45:23]
  wire  registers_io_clear; // @[src/main/scala/StateElements.scala 45:23]
  wire [3:0] registers_io_regInitQ; // @[src/main/scala/StateElements.scala 45:23]
  wire [3:0] registers_io_regEnableQ; // @[src/main/scala/StateElements.scala 45:23]
  wire  counter_clock; // @[src/main/scala/StateElements.scala 45:66]
  wire  counter_reset; // @[src/main/scala/StateElements.scala 45:66]
  wire  counter_io_enable; // @[src/main/scala/StateElements.scala 45:66]
  wire  counter_io_clear; // @[src/main/scala/StateElements.scala 45:66]
  wire [3:0] counter_io_count; // @[src/main/scala/StateElements.scala 45:66]
  wire  divider_clock; // @[src/main/scala/StateElements.scala 45:108]
  wire  divider_reset; // @[src/main/scala/StateElements.scala 45:108]
  wire  divider_io_enable; // @[src/main/scala/StateElements.scala 45:108]
  wire  divider_io_clear; // @[src/main/scala/StateElements.scala 45:108]
  wire  divider_io_led; // @[src/main/scala/StateElements.scala 45:108]
  wire [1:0] divider_io_phase; // @[src/main/scala/StateElements.scala 45:108]
  RegisterCompare registers ( // @[src/main/scala/StateElements.scala 45:23]
    .clock(registers_clock),
    .reset(registers_reset),
    .io_data(registers_io_data),
    .io_enable(registers_io_enable),
    .io_clear(registers_io_clear),
    .io_regInitQ(registers_io_regInitQ),
    .io_regEnableQ(registers_io_regEnableQ)
  );
  EnabledCounter counter ( // @[src/main/scala/StateElements.scala 45:66]
    .clock(counter_clock),
    .reset(counter_reset),
    .io_enable(counter_io_enable),
    .io_clear(counter_io_clear),
    .io_count(counter_io_count)
  );
  BlinkDivider divider ( // @[src/main/scala/StateElements.scala 45:108]
    .clock(divider_clock),
    .reset(divider_reset),
    .io_enable(divider_io_enable),
    .io_clear(divider_io_clear),
    .io_led(divider_io_led),
    .io_phase(divider_io_phase)
  );
  assign io_qInit = registers_io_regInitQ; // @[src/main/scala/StateElements.scala 48:11]
  assign io_qEnable = registers_io_regEnableQ; // @[src/main/scala/StateElements.scala 48:45]
  assign io_count = counter_io_count; // @[src/main/scala/StateElements.scala 49:11]
  assign io_blink = divider_io_led; // @[src/main/scala/StateElements.scala 49:38]
  assign io_phase = divider_io_phase; // @[src/main/scala/StateElements.scala 49:63]
  assign registers_clock = clock;
  assign registers_reset = reset;
  assign registers_io_data = io_data; // @[src/main/scala/StateElements.scala 46:20]
  assign registers_io_enable = io_enable; // @[src/main/scala/StateElements.scala 46:49]
  assign registers_io_clear = io_clear; // @[src/main/scala/StateElements.scala 46:79]
  assign counter_clock = clock;
  assign counter_reset = reset;
  assign counter_io_enable = io_enable; // @[src/main/scala/StateElements.scala 47:20]
  assign counter_io_clear = io_clear; // @[src/main/scala/StateElements.scala 47:48]
  assign divider_clock = clock;
  assign divider_reset = reset;
  assign divider_io_enable = io_enable; // @[src/main/scala/StateElements.scala 47:76]
  assign divider_io_clear = io_clear; // @[src/main/scala/StateElements.scala 47:104]
endmodule
