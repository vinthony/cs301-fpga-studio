module ButtonLeds( // @[src/main/scala/ButtonLeds.scala 7:7]
  input  [3:0] io_buttons, // @[src/main/scala/ButtonLeds.scala 8:12]
  output [3:0] io_leds // @[src/main/scala/ButtonLeds.scala 8:12]
);
  assign io_leds = io_buttons; // @[src/main/scala/ButtonLeds.scala 12:10]
endmodule
module TeachingButtonTop( // @[src/main/scala/ButtonLeds.scala 18:7]
  input         clock, // @[src/main/scala/ButtonLeds.scala 18:7]
  input         reset, // @[src/main/scala/ButtonLeds.scala 18:7]
  input  [4:0]  io_buttons, // @[src/main/scala/ButtonLeds.scala 19:12]
  input  [15:0] io_switches, // @[src/main/scala/ButtonLeds.scala 19:12]
  output [15:0] io_leds, // @[src/main/scala/ButtonLeds.scala 19:12]
  output [6:0]  io_seg, // @[src/main/scala/ButtonLeds.scala 19:12]
  output [3:0]  io_an, // @[src/main/scala/ButtonLeds.scala 19:12]
  output        io_dp // @[src/main/scala/ButtonLeds.scala 19:12]
);
  wire [3:0] core_io_buttons; // @[src/main/scala/ButtonLeds.scala 23:18]
  wire [3:0] core_io_leds; // @[src/main/scala/ButtonLeds.scala 23:18]
  ButtonLeds core ( // @[src/main/scala/ButtonLeds.scala 23:18]
    .io_buttons(core_io_buttons),
    .io_leds(core_io_leds)
  );
  assign io_leds = {12'h0,core_io_leds}; // @[src/main/scala/ButtonLeds.scala 25:15]
  assign io_seg = 7'h7f; // @[src/main/scala/ButtonLeds.scala 26:9]
  assign io_an = 4'hf; // @[src/main/scala/ButtonLeds.scala 26:29]
  assign io_dp = 1'h1; // @[src/main/scala/ButtonLeds.scala 26:46]
  assign core_io_buttons = io_buttons[3:0]; // @[src/main/scala/ButtonLeds.scala 24:30]
endmodule
