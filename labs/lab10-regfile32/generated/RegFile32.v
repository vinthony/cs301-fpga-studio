module RegFile32( // @[src/main/scala/RegFile32.scala 24:7]
  input         clock, // @[src/main/scala/RegFile32.scala 24:7]
  input         reset, // @[src/main/scala/RegFile32.scala 24:7]
  input  [4:0]  io_ra, // @[src/main/scala/RegFile32.scala 8:12]
  input  [4:0]  io_rb, // @[src/main/scala/RegFile32.scala 8:12]
  input  [4:0]  io_wa, // @[src/main/scala/RegFile32.scala 8:12]
  input  [31:0] io_wd, // @[src/main/scala/RegFile32.scala 8:12]
  input         io_we, // @[src/main/scala/RegFile32.scala 8:12]
  input         io_bypass, // @[src/main/scala/RegFile32.scala 8:12]
  input         io_clear, // @[src/main/scala/RegFile32.scala 8:12]
  output [31:0] io_qa, // @[src/main/scala/RegFile32.scala 8:12]
  output [31:0] io_qb, // @[src/main/scala/RegFile32.scala 8:12]
  output [31:0] io_rawA, // @[src/main/scala/RegFile32.scala 8:12]
  output [31:0] io_rawB, // @[src/main/scala/RegFile32.scala 8:12]
  output        io_forwardA, // @[src/main/scala/RegFile32.scala 8:12]
  output        io_forwardB // @[src/main/scala/RegFile32.scala 8:12]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_15;
  reg [31:0] _RAND_16;
  reg [31:0] _RAND_17;
  reg [31:0] _RAND_18;
  reg [31:0] _RAND_19;
  reg [31:0] _RAND_20;
  reg [31:0] _RAND_21;
  reg [31:0] _RAND_22;
  reg [31:0] _RAND_23;
  reg [31:0] _RAND_24;
  reg [31:0] _RAND_25;
  reg [31:0] _RAND_26;
  reg [31:0] _RAND_27;
  reg [31:0] _RAND_28;
  reg [31:0] _RAND_29;
  reg [31:0] _RAND_30;
  reg [31:0] _RAND_31;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] bank_0; // @[src/main/scala/RegFile32.scala 15:19]
  reg [31:0] bank_1; // @[src/main/scala/RegFile32.scala 15:19]
  reg [31:0] bank_2; // @[src/main/scala/RegFile32.scala 15:19]
  reg [31:0] bank_3; // @[src/main/scala/RegFile32.scala 15:19]
  reg [31:0] bank_4; // @[src/main/scala/RegFile32.scala 15:19]
  reg [31:0] bank_5; // @[src/main/scala/RegFile32.scala 15:19]
  reg [31:0] bank_6; // @[src/main/scala/RegFile32.scala 15:19]
  reg [31:0] bank_7; // @[src/main/scala/RegFile32.scala 15:19]
  reg [31:0] bank_8; // @[src/main/scala/RegFile32.scala 15:19]
  reg [31:0] bank_9; // @[src/main/scala/RegFile32.scala 15:19]
  reg [31:0] bank_10; // @[src/main/scala/RegFile32.scala 15:19]
  reg [31:0] bank_11; // @[src/main/scala/RegFile32.scala 15:19]
  reg [31:0] bank_12; // @[src/main/scala/RegFile32.scala 15:19]
  reg [31:0] bank_13; // @[src/main/scala/RegFile32.scala 15:19]
  reg [31:0] bank_14; // @[src/main/scala/RegFile32.scala 15:19]
  reg [31:0] bank_15; // @[src/main/scala/RegFile32.scala 15:19]
  reg [31:0] bank_16; // @[src/main/scala/RegFile32.scala 15:19]
  reg [31:0] bank_17; // @[src/main/scala/RegFile32.scala 15:19]
  reg [31:0] bank_18; // @[src/main/scala/RegFile32.scala 15:19]
  reg [31:0] bank_19; // @[src/main/scala/RegFile32.scala 15:19]
  reg [31:0] bank_20; // @[src/main/scala/RegFile32.scala 15:19]
  reg [31:0] bank_21; // @[src/main/scala/RegFile32.scala 15:19]
  reg [31:0] bank_22; // @[src/main/scala/RegFile32.scala 15:19]
  reg [31:0] bank_23; // @[src/main/scala/RegFile32.scala 15:19]
  reg [31:0] bank_24; // @[src/main/scala/RegFile32.scala 15:19]
  reg [31:0] bank_25; // @[src/main/scala/RegFile32.scala 15:19]
  reg [31:0] bank_26; // @[src/main/scala/RegFile32.scala 15:19]
  reg [31:0] bank_27; // @[src/main/scala/RegFile32.scala 15:19]
  reg [31:0] bank_28; // @[src/main/scala/RegFile32.scala 15:19]
  reg [31:0] bank_29; // @[src/main/scala/RegFile32.scala 15:19]
  reg [31:0] bank_30; // @[src/main/scala/RegFile32.scala 15:19]
  reg [31:0] bank_31; // @[src/main/scala/RegFile32.scala 15:19]
  wire  _T = io_wa != 5'h0; // @[src/main/scala/RegFile32.scala 16:63]
  wire  pending = io_we & ~io_clear & ~reset & _T; // @[src/main/scala/RegFile32.scala 17:51]
  wire [31:0] _GEN_97 = 5'h1 == io_ra ? bank_1 : bank_0; // @[src/main/scala/RegFile32.scala 18:{15,15}]
  wire [31:0] _GEN_98 = 5'h2 == io_ra ? bank_2 : _GEN_97; // @[src/main/scala/RegFile32.scala 18:{15,15}]
  wire [31:0] _GEN_99 = 5'h3 == io_ra ? bank_3 : _GEN_98; // @[src/main/scala/RegFile32.scala 18:{15,15}]
  wire [31:0] _GEN_100 = 5'h4 == io_ra ? bank_4 : _GEN_99; // @[src/main/scala/RegFile32.scala 18:{15,15}]
  wire [31:0] _GEN_101 = 5'h5 == io_ra ? bank_5 : _GEN_100; // @[src/main/scala/RegFile32.scala 18:{15,15}]
  wire [31:0] _GEN_102 = 5'h6 == io_ra ? bank_6 : _GEN_101; // @[src/main/scala/RegFile32.scala 18:{15,15}]
  wire [31:0] _GEN_103 = 5'h7 == io_ra ? bank_7 : _GEN_102; // @[src/main/scala/RegFile32.scala 18:{15,15}]
  wire [31:0] _GEN_104 = 5'h8 == io_ra ? bank_8 : _GEN_103; // @[src/main/scala/RegFile32.scala 18:{15,15}]
  wire [31:0] _GEN_105 = 5'h9 == io_ra ? bank_9 : _GEN_104; // @[src/main/scala/RegFile32.scala 18:{15,15}]
  wire [31:0] _GEN_106 = 5'ha == io_ra ? bank_10 : _GEN_105; // @[src/main/scala/RegFile32.scala 18:{15,15}]
  wire [31:0] _GEN_107 = 5'hb == io_ra ? bank_11 : _GEN_106; // @[src/main/scala/RegFile32.scala 18:{15,15}]
  wire [31:0] _GEN_108 = 5'hc == io_ra ? bank_12 : _GEN_107; // @[src/main/scala/RegFile32.scala 18:{15,15}]
  wire [31:0] _GEN_109 = 5'hd == io_ra ? bank_13 : _GEN_108; // @[src/main/scala/RegFile32.scala 18:{15,15}]
  wire [31:0] _GEN_110 = 5'he == io_ra ? bank_14 : _GEN_109; // @[src/main/scala/RegFile32.scala 18:{15,15}]
  wire [31:0] _GEN_111 = 5'hf == io_ra ? bank_15 : _GEN_110; // @[src/main/scala/RegFile32.scala 18:{15,15}]
  wire [31:0] _GEN_112 = 5'h10 == io_ra ? bank_16 : _GEN_111; // @[src/main/scala/RegFile32.scala 18:{15,15}]
  wire [31:0] _GEN_113 = 5'h11 == io_ra ? bank_17 : _GEN_112; // @[src/main/scala/RegFile32.scala 18:{15,15}]
  wire [31:0] _GEN_114 = 5'h12 == io_ra ? bank_18 : _GEN_113; // @[src/main/scala/RegFile32.scala 18:{15,15}]
  wire [31:0] _GEN_115 = 5'h13 == io_ra ? bank_19 : _GEN_114; // @[src/main/scala/RegFile32.scala 18:{15,15}]
  wire [31:0] _GEN_116 = 5'h14 == io_ra ? bank_20 : _GEN_115; // @[src/main/scala/RegFile32.scala 18:{15,15}]
  wire [31:0] _GEN_117 = 5'h15 == io_ra ? bank_21 : _GEN_116; // @[src/main/scala/RegFile32.scala 18:{15,15}]
  wire [31:0] _GEN_118 = 5'h16 == io_ra ? bank_22 : _GEN_117; // @[src/main/scala/RegFile32.scala 18:{15,15}]
  wire [31:0] _GEN_119 = 5'h17 == io_ra ? bank_23 : _GEN_118; // @[src/main/scala/RegFile32.scala 18:{15,15}]
  wire [31:0] _GEN_120 = 5'h18 == io_ra ? bank_24 : _GEN_119; // @[src/main/scala/RegFile32.scala 18:{15,15}]
  wire [31:0] _GEN_121 = 5'h19 == io_ra ? bank_25 : _GEN_120; // @[src/main/scala/RegFile32.scala 18:{15,15}]
  wire [31:0] _GEN_122 = 5'h1a == io_ra ? bank_26 : _GEN_121; // @[src/main/scala/RegFile32.scala 18:{15,15}]
  wire [31:0] _GEN_123 = 5'h1b == io_ra ? bank_27 : _GEN_122; // @[src/main/scala/RegFile32.scala 18:{15,15}]
  wire [31:0] _GEN_124 = 5'h1c == io_ra ? bank_28 : _GEN_123; // @[src/main/scala/RegFile32.scala 18:{15,15}]
  wire [31:0] _GEN_125 = 5'h1d == io_ra ? bank_29 : _GEN_124; // @[src/main/scala/RegFile32.scala 18:{15,15}]
  wire [31:0] _GEN_126 = 5'h1e == io_ra ? bank_30 : _GEN_125; // @[src/main/scala/RegFile32.scala 18:{15,15}]
  wire [31:0] _GEN_127 = 5'h1f == io_ra ? bank_31 : _GEN_126; // @[src/main/scala/RegFile32.scala 18:{15,15}]
  wire [31:0] rawA = io_ra == 5'h0 ? 32'h0 : _GEN_127; // @[src/main/scala/RegFile32.scala 18:15]
  wire [31:0] _GEN_129 = 5'h1 == io_rb ? bank_1 : bank_0; // @[src/main/scala/RegFile32.scala 18:{57,57}]
  wire [31:0] _GEN_130 = 5'h2 == io_rb ? bank_2 : _GEN_129; // @[src/main/scala/RegFile32.scala 18:{57,57}]
  wire [31:0] _GEN_131 = 5'h3 == io_rb ? bank_3 : _GEN_130; // @[src/main/scala/RegFile32.scala 18:{57,57}]
  wire [31:0] _GEN_132 = 5'h4 == io_rb ? bank_4 : _GEN_131; // @[src/main/scala/RegFile32.scala 18:{57,57}]
  wire [31:0] _GEN_133 = 5'h5 == io_rb ? bank_5 : _GEN_132; // @[src/main/scala/RegFile32.scala 18:{57,57}]
  wire [31:0] _GEN_134 = 5'h6 == io_rb ? bank_6 : _GEN_133; // @[src/main/scala/RegFile32.scala 18:{57,57}]
  wire [31:0] _GEN_135 = 5'h7 == io_rb ? bank_7 : _GEN_134; // @[src/main/scala/RegFile32.scala 18:{57,57}]
  wire [31:0] _GEN_136 = 5'h8 == io_rb ? bank_8 : _GEN_135; // @[src/main/scala/RegFile32.scala 18:{57,57}]
  wire [31:0] _GEN_137 = 5'h9 == io_rb ? bank_9 : _GEN_136; // @[src/main/scala/RegFile32.scala 18:{57,57}]
  wire [31:0] _GEN_138 = 5'ha == io_rb ? bank_10 : _GEN_137; // @[src/main/scala/RegFile32.scala 18:{57,57}]
  wire [31:0] _GEN_139 = 5'hb == io_rb ? bank_11 : _GEN_138; // @[src/main/scala/RegFile32.scala 18:{57,57}]
  wire [31:0] _GEN_140 = 5'hc == io_rb ? bank_12 : _GEN_139; // @[src/main/scala/RegFile32.scala 18:{57,57}]
  wire [31:0] _GEN_141 = 5'hd == io_rb ? bank_13 : _GEN_140; // @[src/main/scala/RegFile32.scala 18:{57,57}]
  wire [31:0] _GEN_142 = 5'he == io_rb ? bank_14 : _GEN_141; // @[src/main/scala/RegFile32.scala 18:{57,57}]
  wire [31:0] _GEN_143 = 5'hf == io_rb ? bank_15 : _GEN_142; // @[src/main/scala/RegFile32.scala 18:{57,57}]
  wire [31:0] _GEN_144 = 5'h10 == io_rb ? bank_16 : _GEN_143; // @[src/main/scala/RegFile32.scala 18:{57,57}]
  wire [31:0] _GEN_145 = 5'h11 == io_rb ? bank_17 : _GEN_144; // @[src/main/scala/RegFile32.scala 18:{57,57}]
  wire [31:0] _GEN_146 = 5'h12 == io_rb ? bank_18 : _GEN_145; // @[src/main/scala/RegFile32.scala 18:{57,57}]
  wire [31:0] _GEN_147 = 5'h13 == io_rb ? bank_19 : _GEN_146; // @[src/main/scala/RegFile32.scala 18:{57,57}]
  wire [31:0] _GEN_148 = 5'h14 == io_rb ? bank_20 : _GEN_147; // @[src/main/scala/RegFile32.scala 18:{57,57}]
  wire [31:0] _GEN_149 = 5'h15 == io_rb ? bank_21 : _GEN_148; // @[src/main/scala/RegFile32.scala 18:{57,57}]
  wire [31:0] _GEN_150 = 5'h16 == io_rb ? bank_22 : _GEN_149; // @[src/main/scala/RegFile32.scala 18:{57,57}]
  wire [31:0] _GEN_151 = 5'h17 == io_rb ? bank_23 : _GEN_150; // @[src/main/scala/RegFile32.scala 18:{57,57}]
  wire [31:0] _GEN_152 = 5'h18 == io_rb ? bank_24 : _GEN_151; // @[src/main/scala/RegFile32.scala 18:{57,57}]
  wire [31:0] _GEN_153 = 5'h19 == io_rb ? bank_25 : _GEN_152; // @[src/main/scala/RegFile32.scala 18:{57,57}]
  wire [31:0] _GEN_154 = 5'h1a == io_rb ? bank_26 : _GEN_153; // @[src/main/scala/RegFile32.scala 18:{57,57}]
  wire [31:0] _GEN_155 = 5'h1b == io_rb ? bank_27 : _GEN_154; // @[src/main/scala/RegFile32.scala 18:{57,57}]
  wire [31:0] _GEN_156 = 5'h1c == io_rb ? bank_28 : _GEN_155; // @[src/main/scala/RegFile32.scala 18:{57,57}]
  wire [31:0] _GEN_157 = 5'h1d == io_rb ? bank_29 : _GEN_156; // @[src/main/scala/RegFile32.scala 18:{57,57}]
  wire [31:0] _GEN_158 = 5'h1e == io_rb ? bank_30 : _GEN_157; // @[src/main/scala/RegFile32.scala 18:{57,57}]
  wire [31:0] _GEN_159 = 5'h1f == io_rb ? bank_31 : _GEN_158; // @[src/main/scala/RegFile32.scala 18:{57,57}]
  wire [31:0] rawB = io_rb == 5'h0 ? 32'h0 : _GEN_159; // @[src/main/scala/RegFile32.scala 18:57]
  wire  _forwardA_T = io_bypass & pending; // @[src/main/scala/RegFile32.scala 19:26]
  wire  forwardA = io_bypass & pending & io_ra != 5'h0 & io_ra == io_wa; // @[src/main/scala/RegFile32.scala 19:52]
  wire  forwardB = _forwardA_T & io_rb != 5'h0 & io_rb == io_wa; // @[src/main/scala/RegFile32.scala 20:52]
  assign io_qa = forwardA ? io_wd : rawA; // @[src/main/scala/RegFile32.scala 22:13]
  assign io_qb = forwardB ? io_wd : rawB; // @[src/main/scala/RegFile32.scala 22:45]
  assign io_rawA = io_ra == 5'h0 ? 32'h0 : _GEN_127; // @[src/main/scala/RegFile32.scala 18:15]
  assign io_rawB = io_rb == 5'h0 ? 32'h0 : _GEN_159; // @[src/main/scala/RegFile32.scala 18:57]
  assign io_forwardA = io_bypass & pending & io_ra != 5'h0 & io_ra == io_wa; // @[src/main/scala/RegFile32.scala 19:52]
  assign io_forwardB = _forwardA_T & io_rb != 5'h0 & io_rb == io_wa; // @[src/main/scala/RegFile32.scala 20:52]
  always @(posedge clock) begin
    if (reset) begin // @[src/main/scala/RegFile32.scala 15:{19,19}]
      bank_0 <= 32'h0;
    end else if (io_clear) begin // @[src/main/scala/RegFile32.scala 16:{17,32}]
      bank_0 <= 32'h0;
    end else if (io_we & io_wa != 5'h0) begin // @[src/main/scala/RegFile32.scala 15:19 16:70]
      if (5'h0 == io_wa) begin // @[src/main/scala/RegFile32.scala 15:19]
        bank_0 <= io_wd; // @[src/main/scala/RegFile32.scala 16:82]
      end
    end
    if (reset) begin // @[src/main/scala/RegFile32.scala 15:{19,19}]
      bank_1 <= 32'h0;
    end else if (io_clear) begin // @[src/main/scala/RegFile32.scala 16:{17,32}]
      bank_1 <= 32'h0;
    end else if (io_we & io_wa != 5'h0) begin // @[src/main/scala/RegFile32.scala 15:19 16:70]
      if (5'h1 == io_wa) begin // @[src/main/scala/RegFile32.scala 15:19]
        bank_1 <= io_wd; // @[src/main/scala/RegFile32.scala 16:82]
      end
    end
    if (reset) begin // @[src/main/scala/RegFile32.scala 15:{19,19}]
      bank_2 <= 32'h0;
    end else if (io_clear) begin // @[src/main/scala/RegFile32.scala 16:{17,32}]
      bank_2 <= 32'h0;
    end else if (io_we & io_wa != 5'h0) begin // @[src/main/scala/RegFile32.scala 15:19 16:70]
      if (5'h2 == io_wa) begin // @[src/main/scala/RegFile32.scala 15:19]
        bank_2 <= io_wd; // @[src/main/scala/RegFile32.scala 16:82]
      end
    end
    if (reset) begin // @[src/main/scala/RegFile32.scala 15:{19,19}]
      bank_3 <= 32'h0;
    end else if (io_clear) begin // @[src/main/scala/RegFile32.scala 16:{17,32}]
      bank_3 <= 32'h0;
    end else if (io_we & io_wa != 5'h0) begin // @[src/main/scala/RegFile32.scala 15:19 16:70]
      if (5'h3 == io_wa) begin // @[src/main/scala/RegFile32.scala 15:19]
        bank_3 <= io_wd; // @[src/main/scala/RegFile32.scala 16:82]
      end
    end
    if (reset) begin // @[src/main/scala/RegFile32.scala 15:{19,19}]
      bank_4 <= 32'h0;
    end else if (io_clear) begin // @[src/main/scala/RegFile32.scala 16:{17,32}]
      bank_4 <= 32'h0;
    end else if (io_we & io_wa != 5'h0) begin // @[src/main/scala/RegFile32.scala 15:19 16:70]
      if (5'h4 == io_wa) begin // @[src/main/scala/RegFile32.scala 15:19]
        bank_4 <= io_wd; // @[src/main/scala/RegFile32.scala 16:82]
      end
    end
    if (reset) begin // @[src/main/scala/RegFile32.scala 15:{19,19}]
      bank_5 <= 32'h0;
    end else if (io_clear) begin // @[src/main/scala/RegFile32.scala 16:{17,32}]
      bank_5 <= 32'h0;
    end else if (io_we & io_wa != 5'h0) begin // @[src/main/scala/RegFile32.scala 15:19 16:70]
      if (5'h5 == io_wa) begin // @[src/main/scala/RegFile32.scala 15:19]
        bank_5 <= io_wd; // @[src/main/scala/RegFile32.scala 16:82]
      end
    end
    if (reset) begin // @[src/main/scala/RegFile32.scala 15:{19,19}]
      bank_6 <= 32'h0;
    end else if (io_clear) begin // @[src/main/scala/RegFile32.scala 16:{17,32}]
      bank_6 <= 32'h0;
    end else if (io_we & io_wa != 5'h0) begin // @[src/main/scala/RegFile32.scala 15:19 16:70]
      if (5'h6 == io_wa) begin // @[src/main/scala/RegFile32.scala 15:19]
        bank_6 <= io_wd; // @[src/main/scala/RegFile32.scala 16:82]
      end
    end
    if (reset) begin // @[src/main/scala/RegFile32.scala 15:{19,19}]
      bank_7 <= 32'h0;
    end else if (io_clear) begin // @[src/main/scala/RegFile32.scala 16:{17,32}]
      bank_7 <= 32'h0;
    end else if (io_we & io_wa != 5'h0) begin // @[src/main/scala/RegFile32.scala 15:19 16:70]
      if (5'h7 == io_wa) begin // @[src/main/scala/RegFile32.scala 15:19]
        bank_7 <= io_wd; // @[src/main/scala/RegFile32.scala 16:82]
      end
    end
    if (reset) begin // @[src/main/scala/RegFile32.scala 15:{19,19}]
      bank_8 <= 32'h0;
    end else if (io_clear) begin // @[src/main/scala/RegFile32.scala 16:{17,32}]
      bank_8 <= 32'h0;
    end else if (io_we & io_wa != 5'h0) begin // @[src/main/scala/RegFile32.scala 15:19 16:70]
      if (5'h8 == io_wa) begin // @[src/main/scala/RegFile32.scala 15:19]
        bank_8 <= io_wd; // @[src/main/scala/RegFile32.scala 16:82]
      end
    end
    if (reset) begin // @[src/main/scala/RegFile32.scala 15:{19,19}]
      bank_9 <= 32'h0;
    end else if (io_clear) begin // @[src/main/scala/RegFile32.scala 16:{17,32}]
      bank_9 <= 32'h0;
    end else if (io_we & io_wa != 5'h0) begin // @[src/main/scala/RegFile32.scala 15:19 16:70]
      if (5'h9 == io_wa) begin // @[src/main/scala/RegFile32.scala 15:19]
        bank_9 <= io_wd; // @[src/main/scala/RegFile32.scala 16:82]
      end
    end
    if (reset) begin // @[src/main/scala/RegFile32.scala 15:{19,19}]
      bank_10 <= 32'h0;
    end else if (io_clear) begin // @[src/main/scala/RegFile32.scala 16:{17,32}]
      bank_10 <= 32'h0;
    end else if (io_we & io_wa != 5'h0) begin // @[src/main/scala/RegFile32.scala 15:19 16:70]
      if (5'ha == io_wa) begin // @[src/main/scala/RegFile32.scala 15:19]
        bank_10 <= io_wd; // @[src/main/scala/RegFile32.scala 16:82]
      end
    end
    if (reset) begin // @[src/main/scala/RegFile32.scala 15:{19,19}]
      bank_11 <= 32'h0;
    end else if (io_clear) begin // @[src/main/scala/RegFile32.scala 16:{17,32}]
      bank_11 <= 32'h0;
    end else if (io_we & io_wa != 5'h0) begin // @[src/main/scala/RegFile32.scala 15:19 16:70]
      if (5'hb == io_wa) begin // @[src/main/scala/RegFile32.scala 15:19]
        bank_11 <= io_wd; // @[src/main/scala/RegFile32.scala 16:82]
      end
    end
    if (reset) begin // @[src/main/scala/RegFile32.scala 15:{19,19}]
      bank_12 <= 32'h0;
    end else if (io_clear) begin // @[src/main/scala/RegFile32.scala 16:{17,32}]
      bank_12 <= 32'h0;
    end else if (io_we & io_wa != 5'h0) begin // @[src/main/scala/RegFile32.scala 15:19 16:70]
      if (5'hc == io_wa) begin // @[src/main/scala/RegFile32.scala 15:19]
        bank_12 <= io_wd; // @[src/main/scala/RegFile32.scala 16:82]
      end
    end
    if (reset) begin // @[src/main/scala/RegFile32.scala 15:{19,19}]
      bank_13 <= 32'h0;
    end else if (io_clear) begin // @[src/main/scala/RegFile32.scala 16:{17,32}]
      bank_13 <= 32'h0;
    end else if (io_we & io_wa != 5'h0) begin // @[src/main/scala/RegFile32.scala 15:19 16:70]
      if (5'hd == io_wa) begin // @[src/main/scala/RegFile32.scala 15:19]
        bank_13 <= io_wd; // @[src/main/scala/RegFile32.scala 16:82]
      end
    end
    if (reset) begin // @[src/main/scala/RegFile32.scala 15:{19,19}]
      bank_14 <= 32'h0;
    end else if (io_clear) begin // @[src/main/scala/RegFile32.scala 16:{17,32}]
      bank_14 <= 32'h0;
    end else if (io_we & io_wa != 5'h0) begin // @[src/main/scala/RegFile32.scala 15:19 16:70]
      if (5'he == io_wa) begin // @[src/main/scala/RegFile32.scala 15:19]
        bank_14 <= io_wd; // @[src/main/scala/RegFile32.scala 16:82]
      end
    end
    if (reset) begin // @[src/main/scala/RegFile32.scala 15:{19,19}]
      bank_15 <= 32'h0;
    end else if (io_clear) begin // @[src/main/scala/RegFile32.scala 16:{17,32}]
      bank_15 <= 32'h0;
    end else if (io_we & io_wa != 5'h0) begin // @[src/main/scala/RegFile32.scala 15:19 16:70]
      if (5'hf == io_wa) begin // @[src/main/scala/RegFile32.scala 15:19]
        bank_15 <= io_wd; // @[src/main/scala/RegFile32.scala 16:82]
      end
    end
    if (reset) begin // @[src/main/scala/RegFile32.scala 15:{19,19}]
      bank_16 <= 32'h0;
    end else if (io_clear) begin // @[src/main/scala/RegFile32.scala 16:{17,32}]
      bank_16 <= 32'h0;
    end else if (io_we & io_wa != 5'h0) begin // @[src/main/scala/RegFile32.scala 15:19 16:70]
      if (5'h10 == io_wa) begin // @[src/main/scala/RegFile32.scala 15:19]
        bank_16 <= io_wd; // @[src/main/scala/RegFile32.scala 16:82]
      end
    end
    if (reset) begin // @[src/main/scala/RegFile32.scala 15:{19,19}]
      bank_17 <= 32'h0;
    end else if (io_clear) begin // @[src/main/scala/RegFile32.scala 16:{17,32}]
      bank_17 <= 32'h0;
    end else if (io_we & io_wa != 5'h0) begin // @[src/main/scala/RegFile32.scala 15:19 16:70]
      if (5'h11 == io_wa) begin // @[src/main/scala/RegFile32.scala 15:19]
        bank_17 <= io_wd; // @[src/main/scala/RegFile32.scala 16:82]
      end
    end
    if (reset) begin // @[src/main/scala/RegFile32.scala 15:{19,19}]
      bank_18 <= 32'h0;
    end else if (io_clear) begin // @[src/main/scala/RegFile32.scala 16:{17,32}]
      bank_18 <= 32'h0;
    end else if (io_we & io_wa != 5'h0) begin // @[src/main/scala/RegFile32.scala 15:19 16:70]
      if (5'h12 == io_wa) begin // @[src/main/scala/RegFile32.scala 15:19]
        bank_18 <= io_wd; // @[src/main/scala/RegFile32.scala 16:82]
      end
    end
    if (reset) begin // @[src/main/scala/RegFile32.scala 15:{19,19}]
      bank_19 <= 32'h0;
    end else if (io_clear) begin // @[src/main/scala/RegFile32.scala 16:{17,32}]
      bank_19 <= 32'h0;
    end else if (io_we & io_wa != 5'h0) begin // @[src/main/scala/RegFile32.scala 15:19 16:70]
      if (5'h13 == io_wa) begin // @[src/main/scala/RegFile32.scala 15:19]
        bank_19 <= io_wd; // @[src/main/scala/RegFile32.scala 16:82]
      end
    end
    if (reset) begin // @[src/main/scala/RegFile32.scala 15:{19,19}]
      bank_20 <= 32'h0;
    end else if (io_clear) begin // @[src/main/scala/RegFile32.scala 16:{17,32}]
      bank_20 <= 32'h0;
    end else if (io_we & io_wa != 5'h0) begin // @[src/main/scala/RegFile32.scala 15:19 16:70]
      if (5'h14 == io_wa) begin // @[src/main/scala/RegFile32.scala 15:19]
        bank_20 <= io_wd; // @[src/main/scala/RegFile32.scala 16:82]
      end
    end
    if (reset) begin // @[src/main/scala/RegFile32.scala 15:{19,19}]
      bank_21 <= 32'h0;
    end else if (io_clear) begin // @[src/main/scala/RegFile32.scala 16:{17,32}]
      bank_21 <= 32'h0;
    end else if (io_we & io_wa != 5'h0) begin // @[src/main/scala/RegFile32.scala 15:19 16:70]
      if (5'h15 == io_wa) begin // @[src/main/scala/RegFile32.scala 15:19]
        bank_21 <= io_wd; // @[src/main/scala/RegFile32.scala 16:82]
      end
    end
    if (reset) begin // @[src/main/scala/RegFile32.scala 15:{19,19}]
      bank_22 <= 32'h0;
    end else if (io_clear) begin // @[src/main/scala/RegFile32.scala 16:{17,32}]
      bank_22 <= 32'h0;
    end else if (io_we & io_wa != 5'h0) begin // @[src/main/scala/RegFile32.scala 15:19 16:70]
      if (5'h16 == io_wa) begin // @[src/main/scala/RegFile32.scala 15:19]
        bank_22 <= io_wd; // @[src/main/scala/RegFile32.scala 16:82]
      end
    end
    if (reset) begin // @[src/main/scala/RegFile32.scala 15:{19,19}]
      bank_23 <= 32'h0;
    end else if (io_clear) begin // @[src/main/scala/RegFile32.scala 16:{17,32}]
      bank_23 <= 32'h0;
    end else if (io_we & io_wa != 5'h0) begin // @[src/main/scala/RegFile32.scala 15:19 16:70]
      if (5'h17 == io_wa) begin // @[src/main/scala/RegFile32.scala 15:19]
        bank_23 <= io_wd; // @[src/main/scala/RegFile32.scala 16:82]
      end
    end
    if (reset) begin // @[src/main/scala/RegFile32.scala 15:{19,19}]
      bank_24 <= 32'h0;
    end else if (io_clear) begin // @[src/main/scala/RegFile32.scala 16:{17,32}]
      bank_24 <= 32'h0;
    end else if (io_we & io_wa != 5'h0) begin // @[src/main/scala/RegFile32.scala 15:19 16:70]
      if (5'h18 == io_wa) begin // @[src/main/scala/RegFile32.scala 15:19]
        bank_24 <= io_wd; // @[src/main/scala/RegFile32.scala 16:82]
      end
    end
    if (reset) begin // @[src/main/scala/RegFile32.scala 15:{19,19}]
      bank_25 <= 32'h0;
    end else if (io_clear) begin // @[src/main/scala/RegFile32.scala 16:{17,32}]
      bank_25 <= 32'h0;
    end else if (io_we & io_wa != 5'h0) begin // @[src/main/scala/RegFile32.scala 15:19 16:70]
      if (5'h19 == io_wa) begin // @[src/main/scala/RegFile32.scala 15:19]
        bank_25 <= io_wd; // @[src/main/scala/RegFile32.scala 16:82]
      end
    end
    if (reset) begin // @[src/main/scala/RegFile32.scala 15:{19,19}]
      bank_26 <= 32'h0;
    end else if (io_clear) begin // @[src/main/scala/RegFile32.scala 16:{17,32}]
      bank_26 <= 32'h0;
    end else if (io_we & io_wa != 5'h0) begin // @[src/main/scala/RegFile32.scala 15:19 16:70]
      if (5'h1a == io_wa) begin // @[src/main/scala/RegFile32.scala 15:19]
        bank_26 <= io_wd; // @[src/main/scala/RegFile32.scala 16:82]
      end
    end
    if (reset) begin // @[src/main/scala/RegFile32.scala 15:{19,19}]
      bank_27 <= 32'h0;
    end else if (io_clear) begin // @[src/main/scala/RegFile32.scala 16:{17,32}]
      bank_27 <= 32'h0;
    end else if (io_we & io_wa != 5'h0) begin // @[src/main/scala/RegFile32.scala 15:19 16:70]
      if (5'h1b == io_wa) begin // @[src/main/scala/RegFile32.scala 15:19]
        bank_27 <= io_wd; // @[src/main/scala/RegFile32.scala 16:82]
      end
    end
    if (reset) begin // @[src/main/scala/RegFile32.scala 15:{19,19}]
      bank_28 <= 32'h0;
    end else if (io_clear) begin // @[src/main/scala/RegFile32.scala 16:{17,32}]
      bank_28 <= 32'h0;
    end else if (io_we & io_wa != 5'h0) begin // @[src/main/scala/RegFile32.scala 15:19 16:70]
      if (5'h1c == io_wa) begin // @[src/main/scala/RegFile32.scala 15:19]
        bank_28 <= io_wd; // @[src/main/scala/RegFile32.scala 16:82]
      end
    end
    if (reset) begin // @[src/main/scala/RegFile32.scala 15:{19,19}]
      bank_29 <= 32'h0;
    end else if (io_clear) begin // @[src/main/scala/RegFile32.scala 16:{17,32}]
      bank_29 <= 32'h0;
    end else if (io_we & io_wa != 5'h0) begin // @[src/main/scala/RegFile32.scala 15:19 16:70]
      if (5'h1d == io_wa) begin // @[src/main/scala/RegFile32.scala 15:19]
        bank_29 <= io_wd; // @[src/main/scala/RegFile32.scala 16:82]
      end
    end
    if (reset) begin // @[src/main/scala/RegFile32.scala 15:{19,19}]
      bank_30 <= 32'h0;
    end else if (io_clear) begin // @[src/main/scala/RegFile32.scala 16:{17,32}]
      bank_30 <= 32'h0;
    end else if (io_we & io_wa != 5'h0) begin // @[src/main/scala/RegFile32.scala 15:19 16:70]
      if (5'h1e == io_wa) begin // @[src/main/scala/RegFile32.scala 15:19]
        bank_30 <= io_wd; // @[src/main/scala/RegFile32.scala 16:82]
      end
    end
    if (reset) begin // @[src/main/scala/RegFile32.scala 15:{19,19}]
      bank_31 <= 32'h0;
    end else if (io_clear) begin // @[src/main/scala/RegFile32.scala 16:{17,32}]
      bank_31 <= 32'h0;
    end else if (io_we & io_wa != 5'h0) begin // @[src/main/scala/RegFile32.scala 15:19 16:70]
      if (5'h1f == io_wa) begin // @[src/main/scala/RegFile32.scala 15:19]
        bank_31 <= io_wd; // @[src/main/scala/RegFile32.scala 16:82]
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
  bank_0 = _RAND_0[31:0];
  _RAND_1 = {1{`RANDOM}};
  bank_1 = _RAND_1[31:0];
  _RAND_2 = {1{`RANDOM}};
  bank_2 = _RAND_2[31:0];
  _RAND_3 = {1{`RANDOM}};
  bank_3 = _RAND_3[31:0];
  _RAND_4 = {1{`RANDOM}};
  bank_4 = _RAND_4[31:0];
  _RAND_5 = {1{`RANDOM}};
  bank_5 = _RAND_5[31:0];
  _RAND_6 = {1{`RANDOM}};
  bank_6 = _RAND_6[31:0];
  _RAND_7 = {1{`RANDOM}};
  bank_7 = _RAND_7[31:0];
  _RAND_8 = {1{`RANDOM}};
  bank_8 = _RAND_8[31:0];
  _RAND_9 = {1{`RANDOM}};
  bank_9 = _RAND_9[31:0];
  _RAND_10 = {1{`RANDOM}};
  bank_10 = _RAND_10[31:0];
  _RAND_11 = {1{`RANDOM}};
  bank_11 = _RAND_11[31:0];
  _RAND_12 = {1{`RANDOM}};
  bank_12 = _RAND_12[31:0];
  _RAND_13 = {1{`RANDOM}};
  bank_13 = _RAND_13[31:0];
  _RAND_14 = {1{`RANDOM}};
  bank_14 = _RAND_14[31:0];
  _RAND_15 = {1{`RANDOM}};
  bank_15 = _RAND_15[31:0];
  _RAND_16 = {1{`RANDOM}};
  bank_16 = _RAND_16[31:0];
  _RAND_17 = {1{`RANDOM}};
  bank_17 = _RAND_17[31:0];
  _RAND_18 = {1{`RANDOM}};
  bank_18 = _RAND_18[31:0];
  _RAND_19 = {1{`RANDOM}};
  bank_19 = _RAND_19[31:0];
  _RAND_20 = {1{`RANDOM}};
  bank_20 = _RAND_20[31:0];
  _RAND_21 = {1{`RANDOM}};
  bank_21 = _RAND_21[31:0];
  _RAND_22 = {1{`RANDOM}};
  bank_22 = _RAND_22[31:0];
  _RAND_23 = {1{`RANDOM}};
  bank_23 = _RAND_23[31:0];
  _RAND_24 = {1{`RANDOM}};
  bank_24 = _RAND_24[31:0];
  _RAND_25 = {1{`RANDOM}};
  bank_25 = _RAND_25[31:0];
  _RAND_26 = {1{`RANDOM}};
  bank_26 = _RAND_26[31:0];
  _RAND_27 = {1{`RANDOM}};
  bank_27 = _RAND_27[31:0];
  _RAND_28 = {1{`RANDOM}};
  bank_28 = _RAND_28[31:0];
  _RAND_29 = {1{`RANDOM}};
  bank_29 = _RAND_29[31:0];
  _RAND_30 = {1{`RANDOM}};
  bank_30 = _RAND_30[31:0];
  _RAND_31 = {1{`RANDOM}};
  bank_31 = _RAND_31[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
