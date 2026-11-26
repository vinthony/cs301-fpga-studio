module Immediate32( // @[src/main/scala/Decoder32.scala 5:7]
  input  [31:0] io_instruction, // @[src/main/scala/Decoder32.scala 6:12]
  input  [2:0]  io_format, // @[src/main/scala/Decoder32.scala 6:12]
  output [31:0] io_immediate // @[src/main/scala/Decoder32.scala 6:12]
);
  wire [19:0] _io_immediate_T_1 = io_instruction[31] ? 20'hfffff : 20'h0; // @[src/main/scala/Decoder32.scala 9:35]
  wire [31:0] _io_immediate_T_3 = {_io_immediate_T_1,io_instruction[31:20]}; // @[src/main/scala/Decoder32.scala 9:30]
  wire [31:0] _io_immediate_T_8 = {_io_immediate_T_1,io_instruction[31:25],io_instruction[11:7]}; // @[src/main/scala/Decoder32.scala 10:30]
  wire [18:0] _io_immediate_T_10 = io_instruction[31] ? 19'h7ffff : 19'h0; // @[src/main/scala/Decoder32.scala 11:35]
  wire [31:0] _io_immediate_T_15 = {_io_immediate_T_10,io_instruction[31],io_instruction[7],io_instruction[30:25],
    io_instruction[11:8],1'h0}; // @[src/main/scala/Decoder32.scala 11:30]
  wire [31:0] _io_immediate_T_17 = {io_instruction[31:12],12'h0}; // @[src/main/scala/Decoder32.scala 12:30]
  wire [10:0] _io_immediate_T_19 = io_instruction[31] ? 11'h7ff : 11'h0; // @[src/main/scala/Decoder32.scala 13:35]
  wire [31:0] _io_immediate_T_24 = {_io_immediate_T_19,io_instruction[31],io_instruction[19:12],io_instruction[20],
    io_instruction[30:21],1'h0}; // @[src/main/scala/Decoder32.scala 13:30]
  wire [31:0] _GEN_0 = 3'h4 == io_format ? _io_immediate_T_24 : 32'h0; // @[src/main/scala/Decoder32.scala 8:20 13:25 7:36]
  wire [31:0] _GEN_1 = 3'h3 == io_format ? _io_immediate_T_17 : _GEN_0; // @[src/main/scala/Decoder32.scala 8:20 12:25]
  wire [31:0] _GEN_2 = 3'h2 == io_format ? _io_immediate_T_15 : _GEN_1; // @[src/main/scala/Decoder32.scala 8:20 11:25]
  wire [31:0] _GEN_3 = 3'h1 == io_format ? _io_immediate_T_8 : _GEN_2; // @[src/main/scala/Decoder32.scala 8:20 10:25]
  assign io_immediate = 3'h0 == io_format ? _io_immediate_T_3 : _GEN_3; // @[src/main/scala/Decoder32.scala 8:20 9:25]
endmodule
module Decoder32( // @[src/main/scala/Decoder32.scala 16:7]
  input  [31:0] io_instruction, // @[src/main/scala/Decoder32.scala 17:12]
  output [5:0]  io_id, // @[src/main/scala/Decoder32.scala 17:12]
  output [2:0]  io_format, // @[src/main/scala/Decoder32.scala 17:12]
  output [3:0]  io_alu, // @[src/main/scala/Decoder32.scala 17:12]
  output [15:0] io_control, // @[src/main/scala/Decoder32.scala 17:12]
  output [4:0]  io_rd, // @[src/main/scala/Decoder32.scala 17:12]
  output [4:0]  io_rs1, // @[src/main/scala/Decoder32.scala 17:12]
  output [4:0]  io_rs2, // @[src/main/scala/Decoder32.scala 17:12]
  output [31:0] io_immediate, // @[src/main/scala/Decoder32.scala 17:12]
  output        io_valid, // @[src/main/scala/Decoder32.scala 17:12]
  output        io_effectiveRegWrite // @[src/main/scala/Decoder32.scala 17:12]
);
  wire [31:0] imm_io_instruction; // @[src/main/scala/Decoder32.scala 34:17]
  wire [2:0] imm_io_format; // @[src/main/scala/Decoder32.scala 34:17]
  wire [31:0] imm_io_immediate; // @[src/main/scala/Decoder32.scala 34:17]
  wire [31:0] _T = io_instruction & 32'hfe00707f; // @[src/main/scala/Decoder32.scala 27:26]
  wire [5:0] _GEN_0 = _T == 32'h33 ? 6'h0 : 6'h3f; // @[src/main/scala/Decoder32.scala 27:90 28:12 25:8]
  wire [2:0] _GEN_1 = _T == 32'h33 ? 3'h0 : 3'h7; // @[src/main/scala/Decoder32.scala 25:24 27:90 28:32]
  wire [15:0] _GEN_3 = _T == 32'h33 ? 16'hf : 16'h0; // @[src/main/scala/Decoder32.scala 25:104 27:90 29:80]
  wire [5:0] _GEN_4 = _T == 32'h40000033 ? 6'h1 : _GEN_0; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_5 = _T == 32'h40000033 ? 3'h0 : _GEN_1; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [15:0] _GEN_8 = _T == 32'h40000033 ? 16'hf : _GEN_3; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_9 = _T == 32'h1033 ? 6'h2 : _GEN_4; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_10 = _T == 32'h1033 ? 3'h0 : _GEN_5; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [2:0] _GEN_11 = _T == 32'h1033 ? 3'h5 : {{2'd0}, _T == 32'h40000033}; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire [15:0] _GEN_13 = _T == 32'h1033 ? 16'hf : _GEN_8; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_14 = _T == 32'h2033 ? 6'h3 : _GEN_9; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_15 = _T == 32'h2033 ? 3'h0 : _GEN_10; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_16 = _T == 32'h2033 ? 4'h8 : {{1'd0}, _GEN_11}; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire [15:0] _GEN_18 = _T == 32'h2033 ? 16'hf : _GEN_13; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_19 = _T == 32'h3033 ? 6'h4 : _GEN_14; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_20 = _T == 32'h3033 ? 3'h0 : _GEN_15; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_21 = _T == 32'h3033 ? 4'h9 : _GEN_16; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire [15:0] _GEN_23 = _T == 32'h3033 ? 16'hf : _GEN_18; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_24 = _T == 32'h4033 ? 6'h5 : _GEN_19; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_25 = _T == 32'h4033 ? 3'h0 : _GEN_20; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_26 = _T == 32'h4033 ? 4'h4 : _GEN_21; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire [15:0] _GEN_28 = _T == 32'h4033 ? 16'hf : _GEN_23; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_29 = _T == 32'h5033 ? 6'h6 : _GEN_24; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_30 = _T == 32'h5033 ? 3'h0 : _GEN_25; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_31 = _T == 32'h5033 ? 4'h6 : _GEN_26; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire [15:0] _GEN_33 = _T == 32'h5033 ? 16'hf : _GEN_28; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_34 = _T == 32'h40005033 ? 6'h7 : _GEN_29; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_35 = _T == 32'h40005033 ? 3'h0 : _GEN_30; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_36 = _T == 32'h40005033 ? 4'h7 : _GEN_31; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire [15:0] _GEN_38 = _T == 32'h40005033 ? 16'hf : _GEN_33; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_39 = _T == 32'h6033 ? 6'h8 : _GEN_34; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_40 = _T == 32'h6033 ? 3'h0 : _GEN_35; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_41 = _T == 32'h6033 ? 4'h3 : _GEN_36; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire [15:0] _GEN_43 = _T == 32'h6033 ? 16'hf : _GEN_38; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_44 = _T == 32'h7033 ? 6'h9 : _GEN_39; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_45 = _T == 32'h7033 ? 3'h0 : _GEN_40; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_46 = _T == 32'h7033 ? 4'h2 : _GEN_41; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire [15:0] _GEN_48 = _T == 32'h7033 ? 16'hf : _GEN_43; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [31:0] _T_20 = io_instruction & 32'h707f; // @[src/main/scala/Decoder32.scala 27:26]
  wire [5:0] _GEN_49 = _T_20 == 32'h13 ? 6'ha : _GEN_44; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_50 = _T_20 == 32'h13 ? 3'h1 : _GEN_45; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_51 = _T_20 == 32'h13 ? 4'h0 : _GEN_46; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire [15:0] _GEN_53 = _T_20 == 32'h13 ? 16'h10b : _GEN_48; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_54 = _T_20 == 32'h2013 ? 6'hb : _GEN_49; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_55 = _T_20 == 32'h2013 ? 3'h1 : _GEN_50; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_56 = _T_20 == 32'h2013 ? 4'h8 : _GEN_51; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire [15:0] _GEN_58 = _T_20 == 32'h2013 ? 16'h10b : _GEN_53; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_59 = _T_20 == 32'h3013 ? 6'hc : _GEN_54; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_60 = _T_20 == 32'h3013 ? 3'h1 : _GEN_55; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_61 = _T_20 == 32'h3013 ? 4'h9 : _GEN_56; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire [15:0] _GEN_63 = _T_20 == 32'h3013 ? 16'h10b : _GEN_58; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_64 = _T_20 == 32'h4013 ? 6'hd : _GEN_59; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_65 = _T_20 == 32'h4013 ? 3'h1 : _GEN_60; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_66 = _T_20 == 32'h4013 ? 4'h4 : _GEN_61; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire [15:0] _GEN_68 = _T_20 == 32'h4013 ? 16'h10b : _GEN_63; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_69 = _T_20 == 32'h6013 ? 6'he : _GEN_64; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_70 = _T_20 == 32'h6013 ? 3'h1 : _GEN_65; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_71 = _T_20 == 32'h6013 ? 4'h3 : _GEN_66; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire [15:0] _GEN_73 = _T_20 == 32'h6013 ? 16'h10b : _GEN_68; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_74 = _T_20 == 32'h7013 ? 6'hf : _GEN_69; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_75 = _T_20 == 32'h7013 ? 3'h1 : _GEN_70; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_76 = _T_20 == 32'h7013 ? 4'h2 : _GEN_71; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire [15:0] _GEN_78 = _T_20 == 32'h7013 ? 16'h10b : _GEN_73; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_79 = _T == 32'h1013 ? 6'h10 : _GEN_74; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_80 = _T == 32'h1013 ? 3'h1 : _GEN_75; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_81 = _T == 32'h1013 ? 4'h5 : _GEN_76; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire [15:0] _GEN_84 = _T == 32'h1013 ? 16'h10b : _GEN_78; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_85 = _T == 32'h5013 ? 6'h11 : _GEN_79; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_86 = _T == 32'h5013 ? 3'h1 : _GEN_80; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_87 = _T == 32'h5013 ? 4'h6 : _GEN_81; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire [15:0] _GEN_90 = _T == 32'h5013 ? 16'h10b : _GEN_84; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_91 = _T == 32'h40005013 ? 6'h12 : _GEN_85; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_92 = _T == 32'h40005013 ? 3'h1 : _GEN_86; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_93 = _T == 32'h40005013 ? 4'h7 : _GEN_87; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire [15:0] _GEN_96 = _T == 32'h40005013 ? 16'h10b : _GEN_90; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_97 = _T_20 == 32'h3 ? 6'h13 : _GEN_91; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_98 = _T_20 == 32'h3 ? 3'h1 : _GEN_92; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_99 = _T_20 == 32'h3 ? 4'h0 : _GEN_93; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire [15:0] _GEN_102 = _T_20 == 32'h3 ? 16'h111b : _GEN_96; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_103 = _T_20 == 32'h1003 ? 6'h14 : _GEN_97; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_104 = _T_20 == 32'h1003 ? 3'h1 : _GEN_98; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_105 = _T_20 == 32'h1003 ? 4'h0 : _GEN_99; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire [15:0] _GEN_108 = _T_20 == 32'h1003 ? 16'h511b : _GEN_102; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_109 = _T_20 == 32'h2003 ? 6'h15 : _GEN_103; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_110 = _T_20 == 32'h2003 ? 3'h1 : _GEN_104; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_111 = _T_20 == 32'h2003 ? 4'h0 : _GEN_105; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire [15:0] _GEN_114 = _T_20 == 32'h2003 ? 16'h911b : _GEN_108; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_115 = _T_20 == 32'h4003 ? 6'h16 : _GEN_109; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_116 = _T_20 == 32'h4003 ? 3'h1 : _GEN_110; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_117 = _T_20 == 32'h4003 ? 4'h0 : _GEN_111; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire [15:0] _GEN_120 = _T_20 == 32'h4003 ? 16'h111b : _GEN_114; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_121 = _T_20 == 32'h5003 ? 6'h17 : _GEN_115; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_122 = _T_20 == 32'h5003 ? 3'h1 : _GEN_116; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_123 = _T_20 == 32'h5003 ? 4'h0 : _GEN_117; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire [15:0] _GEN_126 = _T_20 == 32'h5003 ? 16'h511b : _GEN_120; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_127 = _T_20 == 32'h23 ? 6'h18 : _GEN_121; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_128 = _T_20 == 32'h23 ? 3'h2 : _GEN_122; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_129 = _T_20 == 32'h23 ? 4'h0 : _GEN_123; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire [15:0] _GEN_132 = _T_20 == 32'h23 ? 16'h127 : _GEN_126; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_133 = _T_20 == 32'h1023 ? 6'h19 : _GEN_127; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_134 = _T_20 == 32'h1023 ? 3'h2 : _GEN_128; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_135 = _T_20 == 32'h1023 ? 4'h0 : _GEN_129; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire [15:0] _GEN_138 = _T_20 == 32'h1023 ? 16'h4127 : _GEN_132; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_139 = _T_20 == 32'h2023 ? 6'h1a : _GEN_133; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_140 = _T_20 == 32'h2023 ? 3'h2 : _GEN_134; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_141 = _T_20 == 32'h2023 ? 4'h0 : _GEN_135; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire [15:0] _GEN_144 = _T_20 == 32'h2023 ? 16'h8127 : _GEN_138; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_145 = _T_20 == 32'h63 ? 6'h1b : _GEN_139; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_146 = _T_20 == 32'h63 ? 3'h3 : _GEN_140; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_147 = _T_20 == 32'h63 ? 4'h1 : _GEN_141; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire [15:0] _GEN_150 = _T_20 == 32'h63 ? 16'h47 : _GEN_144; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_151 = _T_20 == 32'h1063 ? 6'h1c : _GEN_145; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_152 = _T_20 == 32'h1063 ? 3'h3 : _GEN_146; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_153 = _T_20 == 32'h1063 ? 4'h1 : _GEN_147; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire [15:0] _GEN_156 = _T_20 == 32'h1063 ? 16'h47 : _GEN_150; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_157 = _T_20 == 32'h4063 ? 6'h1d : _GEN_151; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_158 = _T_20 == 32'h4063 ? 3'h3 : _GEN_152; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_159 = _T_20 == 32'h4063 ? 4'h8 : _GEN_153; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire [15:0] _GEN_162 = _T_20 == 32'h4063 ? 16'h47 : _GEN_156; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_163 = _T_20 == 32'h5063 ? 6'h1e : _GEN_157; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_164 = _T_20 == 32'h5063 ? 3'h3 : _GEN_158; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_165 = _T_20 == 32'h5063 ? 4'h8 : _GEN_159; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire [15:0] _GEN_168 = _T_20 == 32'h5063 ? 16'h47 : _GEN_162; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_169 = _T_20 == 32'h6063 ? 6'h1f : _GEN_163; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_170 = _T_20 == 32'h6063 ? 3'h3 : _GEN_164; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_171 = _T_20 == 32'h6063 ? 4'h9 : _GEN_165; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire [15:0] _GEN_174 = _T_20 == 32'h6063 ? 16'h47 : _GEN_168; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_175 = _T_20 == 32'h7063 ? 6'h20 : _GEN_169; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_176 = _T_20 == 32'h7063 ? 3'h3 : _GEN_170; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_177 = _T_20 == 32'h7063 ? 4'h9 : _GEN_171; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire [15:0] _GEN_180 = _T_20 == 32'h7063 ? 16'h47 : _GEN_174; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [31:0] _T_66 = io_instruction & 32'h7f; // @[src/main/scala/Decoder32.scala 27:26]
  wire [5:0] _GEN_181 = _T_66 == 32'h6f ? 6'h21 : _GEN_175; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_182 = _T_66 == 32'h6f ? 3'h5 : _GEN_176; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_183 = _T_66 == 32'h6f ? 4'h0 : _GEN_177; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire [15:0] _GEN_186 = _T_66 == 32'h6f ? 16'h2389 : _GEN_180; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_187 = _T_20 == 32'h67 ? 6'h22 : _GEN_181; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_188 = _T_20 == 32'h67 ? 3'h1 : _GEN_182; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_189 = _T_20 == 32'h67 ? 4'h0 : _GEN_183; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire [15:0] _GEN_192 = _T_20 == 32'h67 ? 16'h218b : _GEN_186; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_193 = _T_66 == 32'h37 ? 6'h23 : _GEN_187; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_194 = _T_66 == 32'h37 ? 3'h4 : _GEN_188; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_195 = _T_66 == 32'h37 ? 4'h0 : _GEN_189; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire [15:0] _GEN_198 = _T_66 == 32'h37 ? 16'h3109 : _GEN_192; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_199 = _T_66 == 32'h17 ? 6'h24 : _GEN_193; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_200 = _T_66 == 32'h17 ? 3'h4 : _GEN_194; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_201 = _T_66 == 32'h17 ? 4'h0 : _GEN_195; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire [15:0] _GEN_204 = _T_66 == 32'h17 ? 16'h309 : _GEN_198; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_205 = _T_20 == 32'hf ? 6'h25 : _GEN_199; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_206 = _T_20 == 32'hf ? 3'h6 : _GEN_200; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_207 = _T_20 == 32'hf ? 4'h0 : _GEN_201; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire [15:0] _GEN_210 = _T_20 == 32'hf ? 16'h801 : _GEN_204; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_211 = io_instruction == 32'h73 ? 6'h26 : _GEN_205; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_212 = io_instruction == 32'h73 ? 3'h6 : _GEN_206; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_213 = io_instruction == 32'h73 ? 4'h0 : _GEN_207; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire [15:0] _GEN_216 = io_instruction == 32'h73 ? 16'h401 : _GEN_210; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [2:0] _imm_io_format_T_4 = io_format - 3'h1; // @[src/main/scala/Decoder32.scala 35:64]
  Immediate32 imm ( // @[src/main/scala/Decoder32.scala 34:17]
    .io_instruction(imm_io_instruction),
    .io_format(imm_io_format),
    .io_immediate(imm_io_immediate)
  );
  assign io_id = io_instruction == 32'h100073 ? 6'h27 : _GEN_211; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  assign io_format = io_instruction == 32'h100073 ? 3'h6 : _GEN_212; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  assign io_alu = io_instruction == 32'h100073 ? 4'h0 : _GEN_213; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  assign io_control = io_instruction == 32'h100073 ? 16'h401 : _GEN_216; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  assign io_rd = io_instruction[11:7]; // @[src/main/scala/Decoder32.scala 32:55]
  assign io_rs1 = io_instruction[19:15]; // @[src/main/scala/Decoder32.scala 32:84]
  assign io_rs2 = io_instruction[24:20]; // @[src/main/scala/Decoder32.scala 32:114]
  assign io_immediate = imm_io_immediate; // @[src/main/scala/Decoder32.scala 36:15]
  assign io_valid = io_control[0]; // @[src/main/scala/Decoder32.scala 36:54]
  assign io_effectiveRegWrite = io_control[3] & io_rd != 5'h0; // @[src/main/scala/Decoder32.scala 37:39]
  assign imm_io_instruction = io_instruction; // @[src/main/scala/Decoder32.scala 34:53]
  assign imm_io_format = io_format >= 3'h1 & io_format <= 3'h5 ? _imm_io_format_T_4 : 3'h7; // @[src/main/scala/Decoder32.scala 35:21]
endmodule
module RegFile32( // @[src/main/scala/RegFile32.scala 25:7]
  input         clock, // @[src/main/scala/RegFile32.scala 25:7]
  input         reset, // @[src/main/scala/RegFile32.scala 25:7]
  input  [4:0]  io_ra, // @[src/main/scala/RegFile32.scala 8:12]
  input  [4:0]  io_rb, // @[src/main/scala/RegFile32.scala 8:12]
  input  [4:0]  io_wa, // @[src/main/scala/RegFile32.scala 8:12]
  input  [31:0] io_wd, // @[src/main/scala/RegFile32.scala 8:12]
  input         io_we, // @[src/main/scala/RegFile32.scala 8:12]
  input         io_clear, // @[src/main/scala/RegFile32.scala 8:12]
  output [31:0] io_rawA, // @[src/main/scala/RegFile32.scala 8:12]
  output [31:0] io_rawB, // @[src/main/scala/RegFile32.scala 8:12]
  output [31:0] io_saved_1, // @[src/main/scala/RegFile32.scala 8:12]
  output [31:0] io_saved_2, // @[src/main/scala/RegFile32.scala 8:12]
  output [31:0] io_saved_3, // @[src/main/scala/RegFile32.scala 8:12]
  output [31:0] io_saved_4, // @[src/main/scala/RegFile32.scala 8:12]
  output [31:0] io_saved_5, // @[src/main/scala/RegFile32.scala 8:12]
  output [31:0] io_saved_6, // @[src/main/scala/RegFile32.scala 8:12]
  output [31:0] io_saved_7, // @[src/main/scala/RegFile32.scala 8:12]
  output [31:0] io_saved_8, // @[src/main/scala/RegFile32.scala 8:12]
  output [31:0] io_saved_9, // @[src/main/scala/RegFile32.scala 8:12]
  output [31:0] io_saved_10, // @[src/main/scala/RegFile32.scala 8:12]
  output [31:0] io_saved_11, // @[src/main/scala/RegFile32.scala 8:12]
  output [31:0] io_saved_12, // @[src/main/scala/RegFile32.scala 8:12]
  output [31:0] io_saved_13, // @[src/main/scala/RegFile32.scala 8:12]
  output [31:0] io_saved_14, // @[src/main/scala/RegFile32.scala 8:12]
  output [31:0] io_saved_15, // @[src/main/scala/RegFile32.scala 8:12]
  output [31:0] io_saved_16, // @[src/main/scala/RegFile32.scala 8:12]
  output [31:0] io_saved_17, // @[src/main/scala/RegFile32.scala 8:12]
  output [31:0] io_saved_18, // @[src/main/scala/RegFile32.scala 8:12]
  output [31:0] io_saved_19, // @[src/main/scala/RegFile32.scala 8:12]
  output [31:0] io_saved_20, // @[src/main/scala/RegFile32.scala 8:12]
  output [31:0] io_saved_21, // @[src/main/scala/RegFile32.scala 8:12]
  output [31:0] io_saved_22, // @[src/main/scala/RegFile32.scala 8:12]
  output [31:0] io_saved_23, // @[src/main/scala/RegFile32.scala 8:12]
  output [31:0] io_saved_24, // @[src/main/scala/RegFile32.scala 8:12]
  output [31:0] io_saved_25, // @[src/main/scala/RegFile32.scala 8:12]
  output [31:0] io_saved_26, // @[src/main/scala/RegFile32.scala 8:12]
  output [31:0] io_saved_27, // @[src/main/scala/RegFile32.scala 8:12]
  output [31:0] io_saved_28, // @[src/main/scala/RegFile32.scala 8:12]
  output [31:0] io_saved_29, // @[src/main/scala/RegFile32.scala 8:12]
  output [31:0] io_saved_30, // @[src/main/scala/RegFile32.scala 8:12]
  output [31:0] io_saved_31 // @[src/main/scala/RegFile32.scala 8:12]
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
  assign io_rawA = io_ra == 5'h0 ? 32'h0 : _GEN_127; // @[src/main/scala/RegFile32.scala 18:15]
  assign io_rawB = io_rb == 5'h0 ? 32'h0 : _GEN_159; // @[src/main/scala/RegFile32.scala 18:57]
  assign io_saved_1 = bank_1; // @[src/main/scala/RegFile32.scala 21:11]
  assign io_saved_2 = bank_2; // @[src/main/scala/RegFile32.scala 21:11]
  assign io_saved_3 = bank_3; // @[src/main/scala/RegFile32.scala 21:11]
  assign io_saved_4 = bank_4; // @[src/main/scala/RegFile32.scala 21:11]
  assign io_saved_5 = bank_5; // @[src/main/scala/RegFile32.scala 21:11]
  assign io_saved_6 = bank_6; // @[src/main/scala/RegFile32.scala 21:11]
  assign io_saved_7 = bank_7; // @[src/main/scala/RegFile32.scala 21:11]
  assign io_saved_8 = bank_8; // @[src/main/scala/RegFile32.scala 21:11]
  assign io_saved_9 = bank_9; // @[src/main/scala/RegFile32.scala 21:11]
  assign io_saved_10 = bank_10; // @[src/main/scala/RegFile32.scala 21:11]
  assign io_saved_11 = bank_11; // @[src/main/scala/RegFile32.scala 21:11]
  assign io_saved_12 = bank_12; // @[src/main/scala/RegFile32.scala 21:11]
  assign io_saved_13 = bank_13; // @[src/main/scala/RegFile32.scala 21:11]
  assign io_saved_14 = bank_14; // @[src/main/scala/RegFile32.scala 21:11]
  assign io_saved_15 = bank_15; // @[src/main/scala/RegFile32.scala 21:11]
  assign io_saved_16 = bank_16; // @[src/main/scala/RegFile32.scala 21:11]
  assign io_saved_17 = bank_17; // @[src/main/scala/RegFile32.scala 21:11]
  assign io_saved_18 = bank_18; // @[src/main/scala/RegFile32.scala 21:11]
  assign io_saved_19 = bank_19; // @[src/main/scala/RegFile32.scala 21:11]
  assign io_saved_20 = bank_20; // @[src/main/scala/RegFile32.scala 21:11]
  assign io_saved_21 = bank_21; // @[src/main/scala/RegFile32.scala 21:11]
  assign io_saved_22 = bank_22; // @[src/main/scala/RegFile32.scala 21:11]
  assign io_saved_23 = bank_23; // @[src/main/scala/RegFile32.scala 21:11]
  assign io_saved_24 = bank_24; // @[src/main/scala/RegFile32.scala 21:11]
  assign io_saved_25 = bank_25; // @[src/main/scala/RegFile32.scala 21:11]
  assign io_saved_26 = bank_26; // @[src/main/scala/RegFile32.scala 21:11]
  assign io_saved_27 = bank_27; // @[src/main/scala/RegFile32.scala 21:11]
  assign io_saved_28 = bank_28; // @[src/main/scala/RegFile32.scala 21:11]
  assign io_saved_29 = bank_29; // @[src/main/scala/RegFile32.scala 21:11]
  assign io_saved_30 = bank_30; // @[src/main/scala/RegFile32.scala 21:11]
  assign io_saved_31 = bank_31; // @[src/main/scala/RegFile32.scala 21:11]
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
module ALU32( // @[src/main/scala/ALU32.scala 34:7]
  input  [31:0] io_a, // @[src/main/scala/ALU32.scala 7:12]
  input  [31:0] io_b, // @[src/main/scala/ALU32.scala 7:12]
  input  [3:0]  io_op, // @[src/main/scala/ALU32.scala 7:12]
  output [31:0] io_result // @[src/main/scala/ALU32.scala 7:12]
);
  wire [4:0] shift = io_b[4:0]; // @[src/main/scala/ALU32.scala 13:54]
  wire [31:0] _result_T_1 = io_a + io_b; // @[src/main/scala/ALU32.scala 15:25]
  wire [31:0] _result_T_3 = io_a - io_b; // @[src/main/scala/ALU32.scala 16:25]
  wire [31:0] _result_T_4 = io_a & io_b; // @[src/main/scala/ALU32.scala 17:25]
  wire [31:0] _result_T_5 = io_a | io_b; // @[src/main/scala/ALU32.scala 18:25]
  wire [31:0] _result_T_6 = io_a ^ io_b; // @[src/main/scala/ALU32.scala 19:25]
  wire [62:0] _GEN_9 = {{31'd0}, io_a}; // @[src/main/scala/ALU32.scala 20:26]
  wire [62:0] _result_T_7 = _GEN_9 << shift; // @[src/main/scala/ALU32.scala 20:26]
  wire [31:0] _result_T_9 = io_a >> shift; // @[src/main/scala/ALU32.scala 21:25]
  wire [31:0] _result_T_10 = io_a; // @[src/main/scala/ALU32.scala 22:27]
  wire [31:0] _result_T_12 = $signed(io_a) >>> shift; // @[src/main/scala/ALU32.scala 22:42]
  wire [31:0] _result_T_14 = io_b; // @[src/main/scala/ALU32.scala 23:42]
  wire [31:0] _GEN_0 = 4'h9 == io_op ? {{31'd0}, io_a < io_b} : 32'h0; // @[src/main/scala/ALU32.scala 14:16 24:19 13:25]
  wire [31:0] _GEN_1 = 4'h8 == io_op ? {{31'd0}, $signed(_result_T_10) < $signed(_result_T_14)} : _GEN_0; // @[src/main/scala/ALU32.scala 14:16 23:19]
  wire [31:0] _GEN_2 = 4'h7 == io_op ? _result_T_12 : _GEN_1; // @[src/main/scala/ALU32.scala 14:16 22:19]
  wire [31:0] _GEN_3 = 4'h6 == io_op ? _result_T_9 : _GEN_2; // @[src/main/scala/ALU32.scala 14:16 21:19]
  wire [31:0] _GEN_4 = 4'h5 == io_op ? _result_T_7[31:0] : _GEN_3; // @[src/main/scala/ALU32.scala 14:16 20:19]
  wire [31:0] _GEN_5 = 4'h4 == io_op ? _result_T_6 : _GEN_4; // @[src/main/scala/ALU32.scala 14:16 19:19]
  wire [31:0] _GEN_6 = 4'h3 == io_op ? _result_T_5 : _GEN_5; // @[src/main/scala/ALU32.scala 14:16 18:19]
  wire [31:0] _GEN_7 = 4'h2 == io_op ? _result_T_4 : _GEN_6; // @[src/main/scala/ALU32.scala 14:16 17:19]
  wire [31:0] _GEN_8 = 4'h1 == io_op ? _result_T_3 : _GEN_7; // @[src/main/scala/ALU32.scala 14:16 16:19]
  assign io_result = 4'h0 == io_op ? _result_T_1 : _GEN_8; // @[src/main/scala/ALU32.scala 14:16 15:19]
endmodule
module ArithmeticCPU( // @[src/main/scala/ArithmeticCPU.scala 9:7]
  input         clock, // @[src/main/scala/ArithmeticCPU.scala 9:7]
  input         reset, // @[src/main/scala/ArithmeticCPU.scala 9:7]
  input         io_step, // @[src/main/scala/ArithmeticCPU.scala 10:12]
  input         io_clear, // @[src/main/scala/ArithmeticCPU.scala 10:12]
  input  [31:0] io_instruction, // @[src/main/scala/ArithmeticCPU.scala 10:12]
  input         io_instructionValid, // @[src/main/scala/ArithmeticCPU.scala 10:12]
  output [31:0] io_pc, // @[src/main/scala/ArithmeticCPU.scala 10:12]
  output [31:0] io_retired, // @[src/main/scala/ArithmeticCPU.scala 10:12]
  output        io_halted, // @[src/main/scala/ArithmeticCPU.scala 10:12]
  output [2:0]  io_reason, // @[src/main/scala/ArithmeticCPU.scala 10:12]
  output [31:0] io_registers_0, // @[src/main/scala/ArithmeticCPU.scala 10:12]
  output [31:0] io_registers_1, // @[src/main/scala/ArithmeticCPU.scala 10:12]
  output [31:0] io_registers_2, // @[src/main/scala/ArithmeticCPU.scala 10:12]
  output [31:0] io_registers_3, // @[src/main/scala/ArithmeticCPU.scala 10:12]
  output [31:0] io_registers_4, // @[src/main/scala/ArithmeticCPU.scala 10:12]
  output [31:0] io_registers_5, // @[src/main/scala/ArithmeticCPU.scala 10:12]
  output [31:0] io_registers_6, // @[src/main/scala/ArithmeticCPU.scala 10:12]
  output [31:0] io_registers_7, // @[src/main/scala/ArithmeticCPU.scala 10:12]
  output [31:0] io_registers_8, // @[src/main/scala/ArithmeticCPU.scala 10:12]
  output [31:0] io_registers_9, // @[src/main/scala/ArithmeticCPU.scala 10:12]
  output [31:0] io_registers_10, // @[src/main/scala/ArithmeticCPU.scala 10:12]
  output [31:0] io_registers_11, // @[src/main/scala/ArithmeticCPU.scala 10:12]
  output [31:0] io_registers_12, // @[src/main/scala/ArithmeticCPU.scala 10:12]
  output [31:0] io_registers_13, // @[src/main/scala/ArithmeticCPU.scala 10:12]
  output [31:0] io_registers_14, // @[src/main/scala/ArithmeticCPU.scala 10:12]
  output [31:0] io_registers_15, // @[src/main/scala/ArithmeticCPU.scala 10:12]
  output [31:0] io_registers_16, // @[src/main/scala/ArithmeticCPU.scala 10:12]
  output [31:0] io_registers_17, // @[src/main/scala/ArithmeticCPU.scala 10:12]
  output [31:0] io_registers_18, // @[src/main/scala/ArithmeticCPU.scala 10:12]
  output [31:0] io_registers_19, // @[src/main/scala/ArithmeticCPU.scala 10:12]
  output [31:0] io_registers_20, // @[src/main/scala/ArithmeticCPU.scala 10:12]
  output [31:0] io_registers_21, // @[src/main/scala/ArithmeticCPU.scala 10:12]
  output [31:0] io_registers_22, // @[src/main/scala/ArithmeticCPU.scala 10:12]
  output [31:0] io_registers_23, // @[src/main/scala/ArithmeticCPU.scala 10:12]
  output [31:0] io_registers_24, // @[src/main/scala/ArithmeticCPU.scala 10:12]
  output [31:0] io_registers_25, // @[src/main/scala/ArithmeticCPU.scala 10:12]
  output [31:0] io_registers_26, // @[src/main/scala/ArithmeticCPU.scala 10:12]
  output [31:0] io_registers_27, // @[src/main/scala/ArithmeticCPU.scala 10:12]
  output [31:0] io_registers_28, // @[src/main/scala/ArithmeticCPU.scala 10:12]
  output [31:0] io_registers_29, // @[src/main/scala/ArithmeticCPU.scala 10:12]
  output [31:0] io_registers_30, // @[src/main/scala/ArithmeticCPU.scala 10:12]
  output [31:0] io_registers_31, // @[src/main/scala/ArithmeticCPU.scala 10:12]
  output [31:0] io_candidate, // @[src/main/scala/ArithmeticCPU.scala 10:12]
  output [4:0]  io_candidateRd, // @[src/main/scala/ArithmeticCPU.scala 10:12]
  output        io_commit // @[src/main/scala/ArithmeticCPU.scala 10:12]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
`endif // RANDOMIZE_REG_INIT
  wire [31:0] dec_io_instruction; // @[src/main/scala/ArithmeticCPU.scala 18:17]
  wire [5:0] dec_io_id; // @[src/main/scala/ArithmeticCPU.scala 18:17]
  wire [2:0] dec_io_format; // @[src/main/scala/ArithmeticCPU.scala 18:17]
  wire [3:0] dec_io_alu; // @[src/main/scala/ArithmeticCPU.scala 18:17]
  wire [15:0] dec_io_control; // @[src/main/scala/ArithmeticCPU.scala 18:17]
  wire [4:0] dec_io_rd; // @[src/main/scala/ArithmeticCPU.scala 18:17]
  wire [4:0] dec_io_rs1; // @[src/main/scala/ArithmeticCPU.scala 18:17]
  wire [4:0] dec_io_rs2; // @[src/main/scala/ArithmeticCPU.scala 18:17]
  wire [31:0] dec_io_immediate; // @[src/main/scala/ArithmeticCPU.scala 18:17]
  wire  dec_io_valid; // @[src/main/scala/ArithmeticCPU.scala 18:17]
  wire  dec_io_effectiveRegWrite; // @[src/main/scala/ArithmeticCPU.scala 18:17]
  wire  rf_clock; // @[src/main/scala/ArithmeticCPU.scala 18:46]
  wire  rf_reset; // @[src/main/scala/ArithmeticCPU.scala 18:46]
  wire [4:0] rf_io_ra; // @[src/main/scala/ArithmeticCPU.scala 18:46]
  wire [4:0] rf_io_rb; // @[src/main/scala/ArithmeticCPU.scala 18:46]
  wire [4:0] rf_io_wa; // @[src/main/scala/ArithmeticCPU.scala 18:46]
  wire [31:0] rf_io_wd; // @[src/main/scala/ArithmeticCPU.scala 18:46]
  wire  rf_io_we; // @[src/main/scala/ArithmeticCPU.scala 18:46]
  wire  rf_io_clear; // @[src/main/scala/ArithmeticCPU.scala 18:46]
  wire [31:0] rf_io_rawA; // @[src/main/scala/ArithmeticCPU.scala 18:46]
  wire [31:0] rf_io_rawB; // @[src/main/scala/ArithmeticCPU.scala 18:46]
  wire [31:0] rf_io_saved_1; // @[src/main/scala/ArithmeticCPU.scala 18:46]
  wire [31:0] rf_io_saved_2; // @[src/main/scala/ArithmeticCPU.scala 18:46]
  wire [31:0] rf_io_saved_3; // @[src/main/scala/ArithmeticCPU.scala 18:46]
  wire [31:0] rf_io_saved_4; // @[src/main/scala/ArithmeticCPU.scala 18:46]
  wire [31:0] rf_io_saved_5; // @[src/main/scala/ArithmeticCPU.scala 18:46]
  wire [31:0] rf_io_saved_6; // @[src/main/scala/ArithmeticCPU.scala 18:46]
  wire [31:0] rf_io_saved_7; // @[src/main/scala/ArithmeticCPU.scala 18:46]
  wire [31:0] rf_io_saved_8; // @[src/main/scala/ArithmeticCPU.scala 18:46]
  wire [31:0] rf_io_saved_9; // @[src/main/scala/ArithmeticCPU.scala 18:46]
  wire [31:0] rf_io_saved_10; // @[src/main/scala/ArithmeticCPU.scala 18:46]
  wire [31:0] rf_io_saved_11; // @[src/main/scala/ArithmeticCPU.scala 18:46]
  wire [31:0] rf_io_saved_12; // @[src/main/scala/ArithmeticCPU.scala 18:46]
  wire [31:0] rf_io_saved_13; // @[src/main/scala/ArithmeticCPU.scala 18:46]
  wire [31:0] rf_io_saved_14; // @[src/main/scala/ArithmeticCPU.scala 18:46]
  wire [31:0] rf_io_saved_15; // @[src/main/scala/ArithmeticCPU.scala 18:46]
  wire [31:0] rf_io_saved_16; // @[src/main/scala/ArithmeticCPU.scala 18:46]
  wire [31:0] rf_io_saved_17; // @[src/main/scala/ArithmeticCPU.scala 18:46]
  wire [31:0] rf_io_saved_18; // @[src/main/scala/ArithmeticCPU.scala 18:46]
  wire [31:0] rf_io_saved_19; // @[src/main/scala/ArithmeticCPU.scala 18:46]
  wire [31:0] rf_io_saved_20; // @[src/main/scala/ArithmeticCPU.scala 18:46]
  wire [31:0] rf_io_saved_21; // @[src/main/scala/ArithmeticCPU.scala 18:46]
  wire [31:0] rf_io_saved_22; // @[src/main/scala/ArithmeticCPU.scala 18:46]
  wire [31:0] rf_io_saved_23; // @[src/main/scala/ArithmeticCPU.scala 18:46]
  wire [31:0] rf_io_saved_24; // @[src/main/scala/ArithmeticCPU.scala 18:46]
  wire [31:0] rf_io_saved_25; // @[src/main/scala/ArithmeticCPU.scala 18:46]
  wire [31:0] rf_io_saved_26; // @[src/main/scala/ArithmeticCPU.scala 18:46]
  wire [31:0] rf_io_saved_27; // @[src/main/scala/ArithmeticCPU.scala 18:46]
  wire [31:0] rf_io_saved_28; // @[src/main/scala/ArithmeticCPU.scala 18:46]
  wire [31:0] rf_io_saved_29; // @[src/main/scala/ArithmeticCPU.scala 18:46]
  wire [31:0] rf_io_saved_30; // @[src/main/scala/ArithmeticCPU.scala 18:46]
  wire [31:0] rf_io_saved_31; // @[src/main/scala/ArithmeticCPU.scala 18:46]
  wire [31:0] alu_io_a; // @[src/main/scala/ArithmeticCPU.scala 18:76]
  wire [31:0] alu_io_b; // @[src/main/scala/ArithmeticCPU.scala 18:76]
  wire [3:0] alu_io_op; // @[src/main/scala/ArithmeticCPU.scala 18:76]
  wire [31:0] alu_io_result; // @[src/main/scala/ArithmeticCPU.scala 18:76]
  reg [31:0] pc; // @[src/main/scala/ArithmeticCPU.scala 17:17]
  reg [31:0] retired; // @[src/main/scala/ArithmeticCPU.scala 17:48]
  reg  halted; // @[src/main/scala/ArithmeticCPU.scala 17:78]
  reg [2:0] reason; // @[src/main/scala/ArithmeticCPU.scala 17:106]
  wire  supported = dec_io_valid & dec_io_id <= 6'h12; // @[src/main/scala/ArithmeticCPU.scala 23:30]
  wire  _bad_T = ~io_instructionValid; // @[src/main/scala/ArithmeticCPU.scala 24:12]
  wire  _bad_T_2 = pc[1:0] != 2'h0; // @[src/main/scala/ArithmeticCPU.scala 24:43]
  wire  bad = ~io_instructionValid | pc[1:0] != 2'h0 | ~supported; // @[src/main/scala/ArithmeticCPU.scala 24:50]
  wire  _commit_T_1 = io_step & ~halted; // @[src/main/scala/ArithmeticCPU.scala 25:22]
  wire  commit = io_step & ~halted & ~io_clear & ~reset & ~bad; // @[src/main/scala/ArithmeticCPU.scala 25:63]
  wire [1:0] _reason_T_4 = dec_io_id == 6'h27 ? 2'h1 : 2'h2; // @[src/main/scala/ArithmeticCPU.scala 31:71]
  wire [2:0] _reason_T_5 = _bad_T_2 ? 3'h4 : {{1'd0}, _reason_T_4}; // @[src/main/scala/ArithmeticCPU.scala 31:49]
  wire [2:0] _reason_T_6 = _bad_T ? 3'h3 : _reason_T_5; // @[src/main/scala/ArithmeticCPU.scala 31:20]
  wire [31:0] _pc_T_1 = pc + 32'h4; // @[src/main/scala/ArithmeticCPU.scala 32:25]
  wire [31:0] _retired_T_1 = retired + 32'h1; // @[src/main/scala/ArithmeticCPU.scala 32:46]
  wire  _GEN_0 = bad | halted; // @[src/main/scala/ArithmeticCPU.scala 29:16 30:15 17:78]
  Decoder32 dec ( // @[src/main/scala/ArithmeticCPU.scala 18:17]
    .io_instruction(dec_io_instruction),
    .io_id(dec_io_id),
    .io_format(dec_io_format),
    .io_alu(dec_io_alu),
    .io_control(dec_io_control),
    .io_rd(dec_io_rd),
    .io_rs1(dec_io_rs1),
    .io_rs2(dec_io_rs2),
    .io_immediate(dec_io_immediate),
    .io_valid(dec_io_valid),
    .io_effectiveRegWrite(dec_io_effectiveRegWrite)
  );
  RegFile32 rf ( // @[src/main/scala/ArithmeticCPU.scala 18:46]
    .clock(rf_clock),
    .reset(rf_reset),
    .io_ra(rf_io_ra),
    .io_rb(rf_io_rb),
    .io_wa(rf_io_wa),
    .io_wd(rf_io_wd),
    .io_we(rf_io_we),
    .io_clear(rf_io_clear),
    .io_rawA(rf_io_rawA),
    .io_rawB(rf_io_rawB),
    .io_saved_1(rf_io_saved_1),
    .io_saved_2(rf_io_saved_2),
    .io_saved_3(rf_io_saved_3),
    .io_saved_4(rf_io_saved_4),
    .io_saved_5(rf_io_saved_5),
    .io_saved_6(rf_io_saved_6),
    .io_saved_7(rf_io_saved_7),
    .io_saved_8(rf_io_saved_8),
    .io_saved_9(rf_io_saved_9),
    .io_saved_10(rf_io_saved_10),
    .io_saved_11(rf_io_saved_11),
    .io_saved_12(rf_io_saved_12),
    .io_saved_13(rf_io_saved_13),
    .io_saved_14(rf_io_saved_14),
    .io_saved_15(rf_io_saved_15),
    .io_saved_16(rf_io_saved_16),
    .io_saved_17(rf_io_saved_17),
    .io_saved_18(rf_io_saved_18),
    .io_saved_19(rf_io_saved_19),
    .io_saved_20(rf_io_saved_20),
    .io_saved_21(rf_io_saved_21),
    .io_saved_22(rf_io_saved_22),
    .io_saved_23(rf_io_saved_23),
    .io_saved_24(rf_io_saved_24),
    .io_saved_25(rf_io_saved_25),
    .io_saved_26(rf_io_saved_26),
    .io_saved_27(rf_io_saved_27),
    .io_saved_28(rf_io_saved_28),
    .io_saved_29(rf_io_saved_29),
    .io_saved_30(rf_io_saved_30),
    .io_saved_31(rf_io_saved_31)
  );
  ALU32 alu ( // @[src/main/scala/ArithmeticCPU.scala 18:76]
    .io_a(alu_io_a),
    .io_b(alu_io_b),
    .io_op(alu_io_op),
    .io_result(alu_io_result)
  );
  assign io_pc = pc; // @[src/main/scala/ArithmeticCPU.scala 34:8]
  assign io_retired = retired; // @[src/main/scala/ArithmeticCPU.scala 34:23]
  assign io_halted = halted; // @[src/main/scala/ArithmeticCPU.scala 34:42]
  assign io_reason = reason; // @[src/main/scala/ArithmeticCPU.scala 34:60]
  assign io_registers_0 = 32'h0; // @[src/main/scala/ArithmeticCPU.scala 34:81]
  assign io_registers_1 = rf_io_saved_1; // @[src/main/scala/ArithmeticCPU.scala 34:81]
  assign io_registers_2 = rf_io_saved_2; // @[src/main/scala/ArithmeticCPU.scala 34:81]
  assign io_registers_3 = rf_io_saved_3; // @[src/main/scala/ArithmeticCPU.scala 34:81]
  assign io_registers_4 = rf_io_saved_4; // @[src/main/scala/ArithmeticCPU.scala 34:81]
  assign io_registers_5 = rf_io_saved_5; // @[src/main/scala/ArithmeticCPU.scala 34:81]
  assign io_registers_6 = rf_io_saved_6; // @[src/main/scala/ArithmeticCPU.scala 34:81]
  assign io_registers_7 = rf_io_saved_7; // @[src/main/scala/ArithmeticCPU.scala 34:81]
  assign io_registers_8 = rf_io_saved_8; // @[src/main/scala/ArithmeticCPU.scala 34:81]
  assign io_registers_9 = rf_io_saved_9; // @[src/main/scala/ArithmeticCPU.scala 34:81]
  assign io_registers_10 = rf_io_saved_10; // @[src/main/scala/ArithmeticCPU.scala 34:81]
  assign io_registers_11 = rf_io_saved_11; // @[src/main/scala/ArithmeticCPU.scala 34:81]
  assign io_registers_12 = rf_io_saved_12; // @[src/main/scala/ArithmeticCPU.scala 34:81]
  assign io_registers_13 = rf_io_saved_13; // @[src/main/scala/ArithmeticCPU.scala 34:81]
  assign io_registers_14 = rf_io_saved_14; // @[src/main/scala/ArithmeticCPU.scala 34:81]
  assign io_registers_15 = rf_io_saved_15; // @[src/main/scala/ArithmeticCPU.scala 34:81]
  assign io_registers_16 = rf_io_saved_16; // @[src/main/scala/ArithmeticCPU.scala 34:81]
  assign io_registers_17 = rf_io_saved_17; // @[src/main/scala/ArithmeticCPU.scala 34:81]
  assign io_registers_18 = rf_io_saved_18; // @[src/main/scala/ArithmeticCPU.scala 34:81]
  assign io_registers_19 = rf_io_saved_19; // @[src/main/scala/ArithmeticCPU.scala 34:81]
  assign io_registers_20 = rf_io_saved_20; // @[src/main/scala/ArithmeticCPU.scala 34:81]
  assign io_registers_21 = rf_io_saved_21; // @[src/main/scala/ArithmeticCPU.scala 34:81]
  assign io_registers_22 = rf_io_saved_22; // @[src/main/scala/ArithmeticCPU.scala 34:81]
  assign io_registers_23 = rf_io_saved_23; // @[src/main/scala/ArithmeticCPU.scala 34:81]
  assign io_registers_24 = rf_io_saved_24; // @[src/main/scala/ArithmeticCPU.scala 34:81]
  assign io_registers_25 = rf_io_saved_25; // @[src/main/scala/ArithmeticCPU.scala 34:81]
  assign io_registers_26 = rf_io_saved_26; // @[src/main/scala/ArithmeticCPU.scala 34:81]
  assign io_registers_27 = rf_io_saved_27; // @[src/main/scala/ArithmeticCPU.scala 34:81]
  assign io_registers_28 = rf_io_saved_28; // @[src/main/scala/ArithmeticCPU.scala 34:81]
  assign io_registers_29 = rf_io_saved_29; // @[src/main/scala/ArithmeticCPU.scala 34:81]
  assign io_registers_30 = rf_io_saved_30; // @[src/main/scala/ArithmeticCPU.scala 34:81]
  assign io_registers_31 = rf_io_saved_31; // @[src/main/scala/ArithmeticCPU.scala 34:81]
  assign io_candidate = alu_io_result; // @[src/main/scala/ArithmeticCPU.scala 35:15]
  assign io_candidateRd = dec_io_rd; // @[src/main/scala/ArithmeticCPU.scala 35:45]
  assign io_commit = io_step & ~halted & ~io_clear & ~reset & ~bad; // @[src/main/scala/ArithmeticCPU.scala 25:63]
  assign dec_io_instruction = io_instruction; // @[src/main/scala/ArithmeticCPU.scala 19:21]
  assign rf_clock = clock;
  assign rf_reset = reset;
  assign rf_io_ra = dec_io_control[1] ? dec_io_rs1 : 5'h0; // @[src/main/scala/ArithmeticCPU.scala 20:16]
  assign rf_io_rb = dec_io_control[2] ? dec_io_rs2 : 5'h0; // @[src/main/scala/ArithmeticCPU.scala 20:64]
  assign rf_io_wa = dec_io_rd; // @[src/main/scala/ArithmeticCPU.scala 21:11]
  assign rf_io_wd = alu_io_result; // @[src/main/scala/ArithmeticCPU.scala 26:56]
  assign rf_io_we = commit & dec_io_effectiveRegWrite; // @[src/main/scala/ArithmeticCPU.scala 26:20]
  assign rf_io_clear = io_clear; // @[src/main/scala/ArithmeticCPU.scala 21:34]
  assign alu_io_a = rf_io_rawA; // @[src/main/scala/ArithmeticCPU.scala 22:11]
  assign alu_io_b = dec_io_control[8] ? dec_io_immediate : rf_io_rawB; // @[src/main/scala/ArithmeticCPU.scala 22:37]
  assign alu_io_op = dec_io_alu; // @[src/main/scala/ArithmeticCPU.scala 22:94]
  always @(posedge clock) begin
    if (reset) begin // @[src/main/scala/ArithmeticCPU.scala 17:{17,17}]
      pc <= 32'h0;
    end else if (io_clear) begin // @[src/main/scala/ArithmeticCPU.scala 27:{17,20}]
      pc <= 32'h0;
    end else if (_commit_T_1) begin // @[src/main/scala/ArithmeticCPU.scala 17:17 28:34]
      if (!(bad)) begin // @[src/main/scala/ArithmeticCPU.scala 29:16]
        pc <= _pc_T_1; // @[src/main/scala/ArithmeticCPU.scala 32:21]
      end
    end
    if (reset) begin // @[src/main/scala/ArithmeticCPU.scala 17:{48,48}]
      retired <= 32'h0;
    end else if (io_clear) begin // @[src/main/scala/ArithmeticCPU.scala 27:{17,33}]
      retired <= 32'h0;
    end else if (_commit_T_1) begin // @[src/main/scala/ArithmeticCPU.scala 28:34 17:48]
      if (!(bad)) begin // @[src/main/scala/ArithmeticCPU.scala 29:16]
        retired <= _retired_T_1; // @[src/main/scala/ArithmeticCPU.scala 32:37]
      end
    end
    if (reset) begin // @[src/main/scala/ArithmeticCPU.scala 17:{78,78}]
      halted <= 1'h0;
    end else if (io_clear) begin // @[src/main/scala/ArithmeticCPU.scala 27:{17,45}]
      halted <= 1'h0;
    end else if (_commit_T_1) begin // @[src/main/scala/ArithmeticCPU.scala 28:34 17:78]
      halted <= _GEN_0;
    end
    if (reset) begin // @[src/main/scala/ArithmeticCPU.scala 17:{106,106}]
      reason <= 3'h0;
    end else if (io_clear) begin // @[src/main/scala/ArithmeticCPU.scala 27:{17,61}]
      reason <= 3'h0;
    end else if (_commit_T_1) begin // @[src/main/scala/ArithmeticCPU.scala 17:106 28:34]
      if (bad) begin // @[src/main/scala/ArithmeticCPU.scala 17:106]
        reason <= _reason_T_6; // @[src/main/scala/ArithmeticCPU.scala 29:16]
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
  pc = _RAND_0[31:0];
  _RAND_1 = {1{`RANDOM}};
  retired = _RAND_1[31:0];
  _RAND_2 = {1{`RANDOM}};
  halted = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  reason = _RAND_3[2:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
