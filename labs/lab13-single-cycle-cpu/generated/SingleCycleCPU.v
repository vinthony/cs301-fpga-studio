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
  output        io_loadUnsigned, // @[src/main/scala/Decoder32.scala 17:12]
  output [15:0] io_control, // @[src/main/scala/Decoder32.scala 17:12]
  output [4:0]  io_rd, // @[src/main/scala/Decoder32.scala 17:12]
  output [4:0]  io_rs1, // @[src/main/scala/Decoder32.scala 17:12]
  output [4:0]  io_rs2, // @[src/main/scala/Decoder32.scala 17:12]
  output [31:0] io_immediate, // @[src/main/scala/Decoder32.scala 17:12]
  output        io_valid, // @[src/main/scala/Decoder32.scala 17:12]
  output        io_effectiveRegWrite, // @[src/main/scala/Decoder32.scala 17:12]
  output [2:0]  io_branchKind, // @[src/main/scala/Decoder32.scala 17:12]
  output [1:0]  io_trapKind // @[src/main/scala/Decoder32.scala 17:12]
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
  wire  _GEN_130 = _T_20 == 32'h23 ? 1'h0 : _T_20 == 32'h5003 | _T_20 == 32'h4003; // @[src/main/scala/Decoder32.scala 27:90 29:22]
  wire [15:0] _GEN_132 = _T_20 == 32'h23 ? 16'h127 : _GEN_126; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_133 = _T_20 == 32'h1023 ? 6'h19 : _GEN_127; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_134 = _T_20 == 32'h1023 ? 3'h2 : _GEN_128; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_135 = _T_20 == 32'h1023 ? 4'h0 : _GEN_129; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire  _GEN_136 = _T_20 == 32'h1023 ? 1'h0 : _GEN_130; // @[src/main/scala/Decoder32.scala 27:90 29:22]
  wire [15:0] _GEN_138 = _T_20 == 32'h1023 ? 16'h4127 : _GEN_132; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_139 = _T_20 == 32'h2023 ? 6'h1a : _GEN_133; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_140 = _T_20 == 32'h2023 ? 3'h2 : _GEN_134; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_141 = _T_20 == 32'h2023 ? 4'h0 : _GEN_135; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire  _GEN_142 = _T_20 == 32'h2023 ? 1'h0 : _GEN_136; // @[src/main/scala/Decoder32.scala 27:90 29:22]
  wire [15:0] _GEN_144 = _T_20 == 32'h2023 ? 16'h8127 : _GEN_138; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_145 = _T_20 == 32'h63 ? 6'h1b : _GEN_139; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_146 = _T_20 == 32'h63 ? 3'h3 : _GEN_140; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_147 = _T_20 == 32'h63 ? 4'h1 : _GEN_141; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire  _GEN_148 = _T_20 == 32'h63 ? 1'h0 : _GEN_142; // @[src/main/scala/Decoder32.scala 27:90 29:22]
  wire [15:0] _GEN_150 = _T_20 == 32'h63 ? 16'h47 : _GEN_144; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_151 = _T_20 == 32'h1063 ? 6'h1c : _GEN_145; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_152 = _T_20 == 32'h1063 ? 3'h3 : _GEN_146; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_153 = _T_20 == 32'h1063 ? 4'h1 : _GEN_147; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire  _GEN_154 = _T_20 == 32'h1063 ? 1'h0 : _GEN_148; // @[src/main/scala/Decoder32.scala 27:90 29:22]
  wire [15:0] _GEN_156 = _T_20 == 32'h1063 ? 16'h47 : _GEN_150; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_157 = _T_20 == 32'h4063 ? 6'h1d : _GEN_151; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_158 = _T_20 == 32'h4063 ? 3'h3 : _GEN_152; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_159 = _T_20 == 32'h4063 ? 4'h8 : _GEN_153; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire  _GEN_160 = _T_20 == 32'h4063 ? 1'h0 : _GEN_154; // @[src/main/scala/Decoder32.scala 27:90 29:22]
  wire [15:0] _GEN_162 = _T_20 == 32'h4063 ? 16'h47 : _GEN_156; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_163 = _T_20 == 32'h5063 ? 6'h1e : _GEN_157; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_164 = _T_20 == 32'h5063 ? 3'h3 : _GEN_158; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_165 = _T_20 == 32'h5063 ? 4'h8 : _GEN_159; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire  _GEN_166 = _T_20 == 32'h5063 ? 1'h0 : _GEN_160; // @[src/main/scala/Decoder32.scala 27:90 29:22]
  wire [15:0] _GEN_168 = _T_20 == 32'h5063 ? 16'h47 : _GEN_162; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_169 = _T_20 == 32'h6063 ? 6'h1f : _GEN_163; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_170 = _T_20 == 32'h6063 ? 3'h3 : _GEN_164; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_171 = _T_20 == 32'h6063 ? 4'h9 : _GEN_165; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire  _GEN_172 = _T_20 == 32'h6063 ? 1'h0 : _GEN_166; // @[src/main/scala/Decoder32.scala 27:90 29:22]
  wire [15:0] _GEN_174 = _T_20 == 32'h6063 ? 16'h47 : _GEN_168; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_175 = _T_20 == 32'h7063 ? 6'h20 : _GEN_169; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_176 = _T_20 == 32'h7063 ? 3'h3 : _GEN_170; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_177 = _T_20 == 32'h7063 ? 4'h9 : _GEN_171; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire  _GEN_178 = _T_20 == 32'h7063 ? 1'h0 : _GEN_172; // @[src/main/scala/Decoder32.scala 27:90 29:22]
  wire [15:0] _GEN_180 = _T_20 == 32'h7063 ? 16'h47 : _GEN_174; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [31:0] _T_66 = io_instruction & 32'h7f; // @[src/main/scala/Decoder32.scala 27:26]
  wire [5:0] _GEN_181 = _T_66 == 32'h6f ? 6'h21 : _GEN_175; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_182 = _T_66 == 32'h6f ? 3'h5 : _GEN_176; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_183 = _T_66 == 32'h6f ? 4'h0 : _GEN_177; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire  _GEN_184 = _T_66 == 32'h6f ? 1'h0 : _GEN_178; // @[src/main/scala/Decoder32.scala 27:90 29:22]
  wire [15:0] _GEN_186 = _T_66 == 32'h6f ? 16'h2389 : _GEN_180; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_187 = _T_20 == 32'h67 ? 6'h22 : _GEN_181; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_188 = _T_20 == 32'h67 ? 3'h1 : _GEN_182; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_189 = _T_20 == 32'h67 ? 4'h0 : _GEN_183; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire  _GEN_190 = _T_20 == 32'h67 ? 1'h0 : _GEN_184; // @[src/main/scala/Decoder32.scala 27:90 29:22]
  wire [15:0] _GEN_192 = _T_20 == 32'h67 ? 16'h218b : _GEN_186; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_193 = _T_66 == 32'h37 ? 6'h23 : _GEN_187; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_194 = _T_66 == 32'h37 ? 3'h4 : _GEN_188; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_195 = _T_66 == 32'h37 ? 4'h0 : _GEN_189; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire  _GEN_196 = _T_66 == 32'h37 ? 1'h0 : _GEN_190; // @[src/main/scala/Decoder32.scala 27:90 29:22]
  wire [15:0] _GEN_198 = _T_66 == 32'h37 ? 16'h3109 : _GEN_192; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_199 = _T_66 == 32'h17 ? 6'h24 : _GEN_193; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_200 = _T_66 == 32'h17 ? 3'h4 : _GEN_194; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_201 = _T_66 == 32'h17 ? 4'h0 : _GEN_195; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire  _GEN_202 = _T_66 == 32'h17 ? 1'h0 : _GEN_196; // @[src/main/scala/Decoder32.scala 27:90 29:22]
  wire [15:0] _GEN_204 = _T_66 == 32'h17 ? 16'h309 : _GEN_198; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_205 = _T_20 == 32'hf ? 6'h25 : _GEN_199; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_206 = _T_20 == 32'hf ? 3'h6 : _GEN_200; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_207 = _T_20 == 32'hf ? 4'h0 : _GEN_201; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire  _GEN_208 = _T_20 == 32'hf ? 1'h0 : _GEN_202; // @[src/main/scala/Decoder32.scala 27:90 29:22]
  wire [15:0] _GEN_210 = _T_20 == 32'hf ? 16'h801 : _GEN_204; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [5:0] _GEN_211 = io_instruction == 32'h73 ? 6'h26 : _GEN_205; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  wire [2:0] _GEN_212 = io_instruction == 32'h73 ? 3'h6 : _GEN_206; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  wire [3:0] _GEN_213 = io_instruction == 32'h73 ? 4'h0 : _GEN_207; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  wire  _GEN_214 = io_instruction == 32'h73 ? 1'h0 : _GEN_208; // @[src/main/scala/Decoder32.scala 27:90 29:22]
  wire [15:0] _GEN_216 = io_instruction == 32'h73 ? 16'h401 : _GEN_210; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  wire [2:0] _imm_io_format_T_4 = io_format - 3'h1; // @[src/main/scala/Decoder32.scala 35:64]
  wire [1:0] _io_trapKind_T_2 = io_id == 6'h27 ? 2'h2 : 2'h0; // @[src/main/scala/Decoder32.scala 39:40]
  Immediate32 imm ( // @[src/main/scala/Decoder32.scala 34:17]
    .io_instruction(imm_io_instruction),
    .io_format(imm_io_format),
    .io_immediate(imm_io_immediate)
  );
  assign io_id = io_instruction == 32'h100073 ? 6'h27 : _GEN_211; // @[src/main/scala/Decoder32.scala 27:90 28:12]
  assign io_format = io_instruction == 32'h100073 ? 3'h6 : _GEN_212; // @[src/main/scala/Decoder32.scala 27:90 28:32]
  assign io_alu = io_instruction == 32'h100073 ? 4'h0 : _GEN_213; // @[src/main/scala/Decoder32.scala 27:90 28:50]
  assign io_loadUnsigned = io_instruction == 32'h100073 ? 1'h0 : _GEN_214; // @[src/main/scala/Decoder32.scala 27:90 29:22]
  assign io_control = io_instruction == 32'h100073 ? 16'h401 : _GEN_216; // @[src/main/scala/Decoder32.scala 27:90 29:80]
  assign io_rd = io_instruction[11:7]; // @[src/main/scala/Decoder32.scala 32:55]
  assign io_rs1 = io_instruction[19:15]; // @[src/main/scala/Decoder32.scala 32:84]
  assign io_rs2 = io_instruction[24:20]; // @[src/main/scala/Decoder32.scala 32:114]
  assign io_immediate = imm_io_immediate; // @[src/main/scala/Decoder32.scala 36:15]
  assign io_valid = io_control[0]; // @[src/main/scala/Decoder32.scala 36:54]
  assign io_effectiveRegWrite = io_control[3] & io_rd != 5'h0; // @[src/main/scala/Decoder32.scala 37:39]
  assign io_branchKind = io_control[6] ? io_instruction[14:12] : 3'h0; // @[src/main/scala/Decoder32.scala 38:21]
  assign io_trapKind = io_id == 6'h26 ? 2'h1 : _io_trapKind_T_2; // @[src/main/scala/Decoder32.scala 39:19]
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
module SingleCycleCPU( // @[src/main/scala/SingleCycleCPU.scala 9:7]
  input         clock, // @[src/main/scala/SingleCycleCPU.scala 9:7]
  input         reset, // @[src/main/scala/SingleCycleCPU.scala 9:7]
  input         io_step, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  input         io_clear, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  input  [31:0] io_instruction, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  input         io_instructionValid, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  input  [15:0] io_switches, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  input  [4:0]  io_buttons, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [31:0] io_pc, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [31:0] io_retired, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output        io_halted, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [3:0]  io_reason, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [31:0] io_faultValue, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [31:0] io_registers_0, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [31:0] io_registers_1, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [31:0] io_registers_2, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [31:0] io_registers_3, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [31:0] io_registers_4, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [31:0] io_registers_5, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [31:0] io_registers_6, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [31:0] io_registers_7, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [31:0] io_registers_8, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [31:0] io_registers_9, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [31:0] io_registers_10, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [31:0] io_registers_11, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [31:0] io_registers_12, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [31:0] io_registers_13, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [31:0] io_registers_14, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [31:0] io_registers_15, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [31:0] io_registers_16, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [31:0] io_registers_17, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [31:0] io_registers_18, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [31:0] io_registers_19, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [31:0] io_registers_20, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [31:0] io_registers_21, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [31:0] io_registers_22, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [31:0] io_registers_23, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [31:0] io_registers_24, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [31:0] io_registers_25, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [31:0] io_registers_26, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [31:0] io_registers_27, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [31:0] io_registers_28, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [31:0] io_registers_29, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [31:0] io_registers_30, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [31:0] io_registers_31, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_0, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_1, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_2, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_3, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_4, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_5, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_6, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_7, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_8, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_9, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_10, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_11, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_12, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_13, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_14, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_15, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_16, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_17, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_18, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_19, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_20, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_21, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_22, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_23, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_24, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_25, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_26, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_27, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_28, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_29, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_30, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_31, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_32, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_33, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_34, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_35, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_36, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_37, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_38, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_39, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_40, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_41, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_42, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_43, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_44, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_45, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_46, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_47, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_48, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_49, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_50, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_51, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_52, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_53, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_54, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_55, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_56, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_57, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_58, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_59, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_60, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_61, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_62, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_63, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_64, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_65, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_66, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_67, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_68, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_69, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_70, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_71, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_72, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_73, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_74, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_75, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_76, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_77, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_78, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_79, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_80, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_81, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_82, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_83, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_84, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_85, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_86, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_87, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_88, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_89, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_90, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_91, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_92, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_93, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_94, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_95, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_96, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_97, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_98, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_99, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_100, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_101, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_102, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_103, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_104, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_105, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_106, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_107, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_108, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_109, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_110, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_111, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_112, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_113, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_114, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_115, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_116, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_117, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_118, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_119, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_120, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_121, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_122, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_123, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_124, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_125, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_126, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_127, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_128, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_129, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_130, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_131, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_132, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_133, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_134, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_135, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_136, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_137, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_138, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_139, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_140, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_141, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_142, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_143, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_144, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_145, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_146, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_147, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_148, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_149, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_150, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_151, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_152, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_153, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_154, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_155, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_156, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_157, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_158, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_159, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_160, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_161, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_162, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_163, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_164, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_165, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_166, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_167, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_168, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_169, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_170, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_171, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_172, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_173, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_174, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_175, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_176, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_177, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_178, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_179, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_180, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_181, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_182, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_183, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_184, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_185, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_186, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_187, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_188, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_189, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_190, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_191, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_192, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_193, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_194, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_195, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_196, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_197, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_198, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_199, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_200, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_201, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_202, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_203, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_204, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_205, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_206, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_207, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_208, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_209, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_210, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_211, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_212, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_213, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_214, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_215, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_216, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_217, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_218, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_219, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_220, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_221, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_222, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_223, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_224, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_225, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_226, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_227, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_228, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_229, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_230, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_231, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_232, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_233, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_234, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_235, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_236, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_237, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_238, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_239, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_240, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_241, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_242, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_243, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_244, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_245, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_246, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_247, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_248, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_249, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_250, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_251, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_252, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_253, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_254, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [7:0]  io_memory_255, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [15:0] io_led, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [31:0] io_display, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [31:0] io_candidate, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output [31:0] io_nextPC, // @[src/main/scala/SingleCycleCPU.scala 10:11]
  output        io_commit // @[src/main/scala/SingleCycleCPU.scala 10:11]
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
  reg [31:0] _RAND_32;
  reg [31:0] _RAND_33;
  reg [31:0] _RAND_34;
  reg [31:0] _RAND_35;
  reg [31:0] _RAND_36;
  reg [31:0] _RAND_37;
  reg [31:0] _RAND_38;
  reg [31:0] _RAND_39;
  reg [31:0] _RAND_40;
  reg [31:0] _RAND_41;
  reg [31:0] _RAND_42;
  reg [31:0] _RAND_43;
  reg [31:0] _RAND_44;
  reg [31:0] _RAND_45;
  reg [31:0] _RAND_46;
  reg [31:0] _RAND_47;
  reg [31:0] _RAND_48;
  reg [31:0] _RAND_49;
  reg [31:0] _RAND_50;
  reg [31:0] _RAND_51;
  reg [31:0] _RAND_52;
  reg [31:0] _RAND_53;
  reg [31:0] _RAND_54;
  reg [31:0] _RAND_55;
  reg [31:0] _RAND_56;
  reg [31:0] _RAND_57;
  reg [31:0] _RAND_58;
  reg [31:0] _RAND_59;
  reg [31:0] _RAND_60;
  reg [31:0] _RAND_61;
  reg [31:0] _RAND_62;
  reg [31:0] _RAND_63;
  reg [31:0] _RAND_64;
  reg [31:0] _RAND_65;
  reg [31:0] _RAND_66;
  reg [31:0] _RAND_67;
  reg [31:0] _RAND_68;
  reg [31:0] _RAND_69;
  reg [31:0] _RAND_70;
  reg [31:0] _RAND_71;
  reg [31:0] _RAND_72;
  reg [31:0] _RAND_73;
  reg [31:0] _RAND_74;
  reg [31:0] _RAND_75;
  reg [31:0] _RAND_76;
  reg [31:0] _RAND_77;
  reg [31:0] _RAND_78;
  reg [31:0] _RAND_79;
  reg [31:0] _RAND_80;
  reg [31:0] _RAND_81;
  reg [31:0] _RAND_82;
  reg [31:0] _RAND_83;
  reg [31:0] _RAND_84;
  reg [31:0] _RAND_85;
  reg [31:0] _RAND_86;
  reg [31:0] _RAND_87;
  reg [31:0] _RAND_88;
  reg [31:0] _RAND_89;
  reg [31:0] _RAND_90;
  reg [31:0] _RAND_91;
  reg [31:0] _RAND_92;
  reg [31:0] _RAND_93;
  reg [31:0] _RAND_94;
  reg [31:0] _RAND_95;
  reg [31:0] _RAND_96;
  reg [31:0] _RAND_97;
  reg [31:0] _RAND_98;
  reg [31:0] _RAND_99;
  reg [31:0] _RAND_100;
  reg [31:0] _RAND_101;
  reg [31:0] _RAND_102;
  reg [31:0] _RAND_103;
  reg [31:0] _RAND_104;
  reg [31:0] _RAND_105;
  reg [31:0] _RAND_106;
  reg [31:0] _RAND_107;
  reg [31:0] _RAND_108;
  reg [31:0] _RAND_109;
  reg [31:0] _RAND_110;
  reg [31:0] _RAND_111;
  reg [31:0] _RAND_112;
  reg [31:0] _RAND_113;
  reg [31:0] _RAND_114;
  reg [31:0] _RAND_115;
  reg [31:0] _RAND_116;
  reg [31:0] _RAND_117;
  reg [31:0] _RAND_118;
  reg [31:0] _RAND_119;
  reg [31:0] _RAND_120;
  reg [31:0] _RAND_121;
  reg [31:0] _RAND_122;
  reg [31:0] _RAND_123;
  reg [31:0] _RAND_124;
  reg [31:0] _RAND_125;
  reg [31:0] _RAND_126;
  reg [31:0] _RAND_127;
  reg [31:0] _RAND_128;
  reg [31:0] _RAND_129;
  reg [31:0] _RAND_130;
  reg [31:0] _RAND_131;
  reg [31:0] _RAND_132;
  reg [31:0] _RAND_133;
  reg [31:0] _RAND_134;
  reg [31:0] _RAND_135;
  reg [31:0] _RAND_136;
  reg [31:0] _RAND_137;
  reg [31:0] _RAND_138;
  reg [31:0] _RAND_139;
  reg [31:0] _RAND_140;
  reg [31:0] _RAND_141;
  reg [31:0] _RAND_142;
  reg [31:0] _RAND_143;
  reg [31:0] _RAND_144;
  reg [31:0] _RAND_145;
  reg [31:0] _RAND_146;
  reg [31:0] _RAND_147;
  reg [31:0] _RAND_148;
  reg [31:0] _RAND_149;
  reg [31:0] _RAND_150;
  reg [31:0] _RAND_151;
  reg [31:0] _RAND_152;
  reg [31:0] _RAND_153;
  reg [31:0] _RAND_154;
  reg [31:0] _RAND_155;
  reg [31:0] _RAND_156;
  reg [31:0] _RAND_157;
  reg [31:0] _RAND_158;
  reg [31:0] _RAND_159;
  reg [31:0] _RAND_160;
  reg [31:0] _RAND_161;
  reg [31:0] _RAND_162;
  reg [31:0] _RAND_163;
  reg [31:0] _RAND_164;
  reg [31:0] _RAND_165;
  reg [31:0] _RAND_166;
  reg [31:0] _RAND_167;
  reg [31:0] _RAND_168;
  reg [31:0] _RAND_169;
  reg [31:0] _RAND_170;
  reg [31:0] _RAND_171;
  reg [31:0] _RAND_172;
  reg [31:0] _RAND_173;
  reg [31:0] _RAND_174;
  reg [31:0] _RAND_175;
  reg [31:0] _RAND_176;
  reg [31:0] _RAND_177;
  reg [31:0] _RAND_178;
  reg [31:0] _RAND_179;
  reg [31:0] _RAND_180;
  reg [31:0] _RAND_181;
  reg [31:0] _RAND_182;
  reg [31:0] _RAND_183;
  reg [31:0] _RAND_184;
  reg [31:0] _RAND_185;
  reg [31:0] _RAND_186;
  reg [31:0] _RAND_187;
  reg [31:0] _RAND_188;
  reg [31:0] _RAND_189;
  reg [31:0] _RAND_190;
  reg [31:0] _RAND_191;
  reg [31:0] _RAND_192;
  reg [31:0] _RAND_193;
  reg [31:0] _RAND_194;
  reg [31:0] _RAND_195;
  reg [31:0] _RAND_196;
  reg [31:0] _RAND_197;
  reg [31:0] _RAND_198;
  reg [31:0] _RAND_199;
  reg [31:0] _RAND_200;
  reg [31:0] _RAND_201;
  reg [31:0] _RAND_202;
  reg [31:0] _RAND_203;
  reg [31:0] _RAND_204;
  reg [31:0] _RAND_205;
  reg [31:0] _RAND_206;
  reg [31:0] _RAND_207;
  reg [31:0] _RAND_208;
  reg [31:0] _RAND_209;
  reg [31:0] _RAND_210;
  reg [31:0] _RAND_211;
  reg [31:0] _RAND_212;
  reg [31:0] _RAND_213;
  reg [31:0] _RAND_214;
  reg [31:0] _RAND_215;
  reg [31:0] _RAND_216;
  reg [31:0] _RAND_217;
  reg [31:0] _RAND_218;
  reg [31:0] _RAND_219;
  reg [31:0] _RAND_220;
  reg [31:0] _RAND_221;
  reg [31:0] _RAND_222;
  reg [31:0] _RAND_223;
  reg [31:0] _RAND_224;
  reg [31:0] _RAND_225;
  reg [31:0] _RAND_226;
  reg [31:0] _RAND_227;
  reg [31:0] _RAND_228;
  reg [31:0] _RAND_229;
  reg [31:0] _RAND_230;
  reg [31:0] _RAND_231;
  reg [31:0] _RAND_232;
  reg [31:0] _RAND_233;
  reg [31:0] _RAND_234;
  reg [31:0] _RAND_235;
  reg [31:0] _RAND_236;
  reg [31:0] _RAND_237;
  reg [31:0] _RAND_238;
  reg [31:0] _RAND_239;
  reg [31:0] _RAND_240;
  reg [31:0] _RAND_241;
  reg [31:0] _RAND_242;
  reg [31:0] _RAND_243;
  reg [31:0] _RAND_244;
  reg [31:0] _RAND_245;
  reg [31:0] _RAND_246;
  reg [31:0] _RAND_247;
  reg [31:0] _RAND_248;
  reg [31:0] _RAND_249;
  reg [31:0] _RAND_250;
  reg [31:0] _RAND_251;
  reg [31:0] _RAND_252;
  reg [31:0] _RAND_253;
  reg [31:0] _RAND_254;
  reg [31:0] _RAND_255;
  reg [31:0] _RAND_256;
  reg [31:0] _RAND_257;
  reg [31:0] _RAND_258;
  reg [31:0] _RAND_259;
  reg [31:0] _RAND_260;
  reg [31:0] _RAND_261;
  reg [31:0] _RAND_262;
`endif // RANDOMIZE_REG_INIT
  wire [31:0] dec_io_instruction; // @[src/main/scala/SingleCycleCPU.scala 23:16]
  wire [5:0] dec_io_id; // @[src/main/scala/SingleCycleCPU.scala 23:16]
  wire [2:0] dec_io_format; // @[src/main/scala/SingleCycleCPU.scala 23:16]
  wire [3:0] dec_io_alu; // @[src/main/scala/SingleCycleCPU.scala 23:16]
  wire  dec_io_loadUnsigned; // @[src/main/scala/SingleCycleCPU.scala 23:16]
  wire [15:0] dec_io_control; // @[src/main/scala/SingleCycleCPU.scala 23:16]
  wire [4:0] dec_io_rd; // @[src/main/scala/SingleCycleCPU.scala 23:16]
  wire [4:0] dec_io_rs1; // @[src/main/scala/SingleCycleCPU.scala 23:16]
  wire [4:0] dec_io_rs2; // @[src/main/scala/SingleCycleCPU.scala 23:16]
  wire [31:0] dec_io_immediate; // @[src/main/scala/SingleCycleCPU.scala 23:16]
  wire  dec_io_valid; // @[src/main/scala/SingleCycleCPU.scala 23:16]
  wire  dec_io_effectiveRegWrite; // @[src/main/scala/SingleCycleCPU.scala 23:16]
  wire [2:0] dec_io_branchKind; // @[src/main/scala/SingleCycleCPU.scala 23:16]
  wire [1:0] dec_io_trapKind; // @[src/main/scala/SingleCycleCPU.scala 23:16]
  wire  rf_clock; // @[src/main/scala/SingleCycleCPU.scala 23:45]
  wire  rf_reset; // @[src/main/scala/SingleCycleCPU.scala 23:45]
  wire [4:0] rf_io_ra; // @[src/main/scala/SingleCycleCPU.scala 23:45]
  wire [4:0] rf_io_rb; // @[src/main/scala/SingleCycleCPU.scala 23:45]
  wire [4:0] rf_io_wa; // @[src/main/scala/SingleCycleCPU.scala 23:45]
  wire [31:0] rf_io_wd; // @[src/main/scala/SingleCycleCPU.scala 23:45]
  wire  rf_io_we; // @[src/main/scala/SingleCycleCPU.scala 23:45]
  wire  rf_io_clear; // @[src/main/scala/SingleCycleCPU.scala 23:45]
  wire [31:0] rf_io_rawA; // @[src/main/scala/SingleCycleCPU.scala 23:45]
  wire [31:0] rf_io_rawB; // @[src/main/scala/SingleCycleCPU.scala 23:45]
  wire [31:0] rf_io_saved_1; // @[src/main/scala/SingleCycleCPU.scala 23:45]
  wire [31:0] rf_io_saved_2; // @[src/main/scala/SingleCycleCPU.scala 23:45]
  wire [31:0] rf_io_saved_3; // @[src/main/scala/SingleCycleCPU.scala 23:45]
  wire [31:0] rf_io_saved_4; // @[src/main/scala/SingleCycleCPU.scala 23:45]
  wire [31:0] rf_io_saved_5; // @[src/main/scala/SingleCycleCPU.scala 23:45]
  wire [31:0] rf_io_saved_6; // @[src/main/scala/SingleCycleCPU.scala 23:45]
  wire [31:0] rf_io_saved_7; // @[src/main/scala/SingleCycleCPU.scala 23:45]
  wire [31:0] rf_io_saved_8; // @[src/main/scala/SingleCycleCPU.scala 23:45]
  wire [31:0] rf_io_saved_9; // @[src/main/scala/SingleCycleCPU.scala 23:45]
  wire [31:0] rf_io_saved_10; // @[src/main/scala/SingleCycleCPU.scala 23:45]
  wire [31:0] rf_io_saved_11; // @[src/main/scala/SingleCycleCPU.scala 23:45]
  wire [31:0] rf_io_saved_12; // @[src/main/scala/SingleCycleCPU.scala 23:45]
  wire [31:0] rf_io_saved_13; // @[src/main/scala/SingleCycleCPU.scala 23:45]
  wire [31:0] rf_io_saved_14; // @[src/main/scala/SingleCycleCPU.scala 23:45]
  wire [31:0] rf_io_saved_15; // @[src/main/scala/SingleCycleCPU.scala 23:45]
  wire [31:0] rf_io_saved_16; // @[src/main/scala/SingleCycleCPU.scala 23:45]
  wire [31:0] rf_io_saved_17; // @[src/main/scala/SingleCycleCPU.scala 23:45]
  wire [31:0] rf_io_saved_18; // @[src/main/scala/SingleCycleCPU.scala 23:45]
  wire [31:0] rf_io_saved_19; // @[src/main/scala/SingleCycleCPU.scala 23:45]
  wire [31:0] rf_io_saved_20; // @[src/main/scala/SingleCycleCPU.scala 23:45]
  wire [31:0] rf_io_saved_21; // @[src/main/scala/SingleCycleCPU.scala 23:45]
  wire [31:0] rf_io_saved_22; // @[src/main/scala/SingleCycleCPU.scala 23:45]
  wire [31:0] rf_io_saved_23; // @[src/main/scala/SingleCycleCPU.scala 23:45]
  wire [31:0] rf_io_saved_24; // @[src/main/scala/SingleCycleCPU.scala 23:45]
  wire [31:0] rf_io_saved_25; // @[src/main/scala/SingleCycleCPU.scala 23:45]
  wire [31:0] rf_io_saved_26; // @[src/main/scala/SingleCycleCPU.scala 23:45]
  wire [31:0] rf_io_saved_27; // @[src/main/scala/SingleCycleCPU.scala 23:45]
  wire [31:0] rf_io_saved_28; // @[src/main/scala/SingleCycleCPU.scala 23:45]
  wire [31:0] rf_io_saved_29; // @[src/main/scala/SingleCycleCPU.scala 23:45]
  wire [31:0] rf_io_saved_30; // @[src/main/scala/SingleCycleCPU.scala 23:45]
  wire [31:0] rf_io_saved_31; // @[src/main/scala/SingleCycleCPU.scala 23:45]
  wire [31:0] alu_io_a; // @[src/main/scala/SingleCycleCPU.scala 23:75]
  wire [31:0] alu_io_b; // @[src/main/scala/SingleCycleCPU.scala 23:75]
  wire [3:0] alu_io_op; // @[src/main/scala/SingleCycleCPU.scala 23:75]
  wire [31:0] alu_io_result; // @[src/main/scala/SingleCycleCPU.scala 23:75]
  reg [31:0] pc; // @[src/main/scala/SingleCycleCPU.scala 19:16]
  reg [31:0] retired; // @[src/main/scala/SingleCycleCPU.scala 19:47]
  reg  halted; // @[src/main/scala/SingleCycleCPU.scala 19:77]
  reg [3:0] reason; // @[src/main/scala/SingleCycleCPU.scala 20:20]
  reg [31:0] faultValue; // @[src/main/scala/SingleCycleCPU.scala 20:53]
  reg [7:0] memory_0; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_1; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_2; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_3; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_4; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_5; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_6; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_7; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_8; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_9; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_10; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_11; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_12; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_13; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_14; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_15; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_16; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_17; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_18; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_19; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_20; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_21; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_22; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_23; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_24; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_25; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_26; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_27; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_28; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_29; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_30; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_31; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_32; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_33; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_34; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_35; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_36; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_37; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_38; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_39; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_40; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_41; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_42; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_43; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_44; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_45; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_46; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_47; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_48; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_49; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_50; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_51; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_52; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_53; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_54; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_55; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_56; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_57; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_58; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_59; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_60; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_61; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_62; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_63; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_64; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_65; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_66; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_67; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_68; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_69; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_70; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_71; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_72; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_73; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_74; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_75; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_76; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_77; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_78; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_79; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_80; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_81; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_82; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_83; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_84; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_85; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_86; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_87; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_88; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_89; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_90; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_91; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_92; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_93; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_94; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_95; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_96; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_97; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_98; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_99; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_100; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_101; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_102; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_103; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_104; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_105; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_106; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_107; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_108; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_109; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_110; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_111; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_112; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_113; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_114; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_115; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_116; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_117; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_118; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_119; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_120; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_121; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_122; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_123; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_124; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_125; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_126; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_127; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_128; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_129; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_130; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_131; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_132; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_133; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_134; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_135; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_136; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_137; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_138; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_139; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_140; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_141; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_142; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_143; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_144; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_145; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_146; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_147; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_148; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_149; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_150; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_151; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_152; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_153; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_154; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_155; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_156; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_157; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_158; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_159; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_160; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_161; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_162; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_163; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_164; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_165; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_166; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_167; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_168; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_169; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_170; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_171; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_172; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_173; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_174; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_175; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_176; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_177; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_178; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_179; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_180; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_181; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_182; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_183; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_184; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_185; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_186; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_187; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_188; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_189; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_190; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_191; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_192; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_193; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_194; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_195; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_196; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_197; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_198; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_199; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_200; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_201; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_202; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_203; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_204; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_205; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_206; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_207; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_208; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_209; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_210; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_211; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_212; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_213; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_214; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_215; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_216; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_217; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_218; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_219; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_220; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_221; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_222; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_223; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_224; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_225; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_226; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_227; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_228; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_229; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_230; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_231; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_232; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_233; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_234; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_235; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_236; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_237; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_238; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_239; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_240; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_241; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_242; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_243; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_244; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_245; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_246; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_247; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_248; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_249; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_250; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_251; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_252; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_253; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_254; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [7:0] memory_255; // @[src/main/scala/SingleCycleCPU.scala 21:20]
  reg [15:0] led; // @[src/main/scala/SingleCycleCPU.scala 22:17]
  reg [31:0] display; // @[src/main/scala/SingleCycleCPU.scala 22:48]
  wire  _GEN_0 = 3'h7 == dec_io_branchKind & rf_io_rawA >= rf_io_rawB; // @[src/main/scala/SingleCycleCPU.scala 30:27 36:20 29:27]
  wire  _GEN_1 = 3'h6 == dec_io_branchKind ? rf_io_rawA < rf_io_rawB : _GEN_0; // @[src/main/scala/SingleCycleCPU.scala 30:27 35:20]
  wire  _GEN_2 = 3'h5 == dec_io_branchKind ? $signed(rf_io_rawA) >= $signed(rf_io_rawB) : _GEN_1; // @[src/main/scala/SingleCycleCPU.scala 30:27 34:20]
  wire  _GEN_3 = 3'h4 == dec_io_branchKind ? $signed(rf_io_rawA) < $signed(rf_io_rawB) : _GEN_2; // @[src/main/scala/SingleCycleCPU.scala 30:27 33:20]
  wire  _GEN_4 = 3'h1 == dec_io_branchKind ? rf_io_rawA != rf_io_rawB : _GEN_3; // @[src/main/scala/SingleCycleCPU.scala 30:27 32:20]
  wire  condition = 3'h0 == dec_io_branchKind ? rf_io_rawA == rf_io_rawB : _GEN_4; // @[src/main/scala/SingleCycleCPU.scala 30:27 31:20]
  wire  taken = dec_io_control[7] | dec_io_control[6] & condition; // @[src/main/scala/SingleCycleCPU.scala 38:29]
  wire [31:0] _target_T_1 = alu_io_result & 32'hfffffffe; // @[src/main/scala/SingleCycleCPU.scala 39:48]
  wire [31:0] _target_T_3 = pc + dec_io_immediate; // @[src/main/scala/SingleCycleCPU.scala 39:67]
  wire [31:0] target = dec_io_id == 6'h22 ? _target_T_1 : _target_T_3; // @[src/main/scala/SingleCycleCPU.scala 39:16]
  wire [31:0] _nextPC_T_1 = pc + 32'h4; // @[src/main/scala/SingleCycleCPU.scala 40:33]
  wire [31:0] nextPC = taken ? target : _nextPC_T_1; // @[src/main/scala/SingleCycleCPU.scala 40:16]
  wire [1:0] size = dec_io_control[15:14]; // @[src/main/scala/SingleCycleCPU.scala 41:51]
  wire  _bytes_T = size == 2'h0; // @[src/main/scala/SingleCycleCPU.scala 42:20]
  wire  _bytes_T_1 = size == 2'h1; // @[src/main/scala/SingleCycleCPU.scala 42:44]
  wire [2:0] _bytes_T_2 = size == 2'h1 ? 3'h2 : 3'h4; // @[src/main/scala/SingleCycleCPU.scala 42:39]
  wire [2:0] bytes = size == 2'h0 ? 3'h1 : _bytes_T_2; // @[src/main/scala/SingleCycleCPU.scala 42:15]
  wire [7:0] _inRAM_T_2 = _bytes_T_1 ? 8'hfe : 8'hfc; // @[src/main/scala/SingleCycleCPU.scala 43:45]
  wire [7:0] _inRAM_T_3 = _bytes_T ? 8'hff : _inRAM_T_2; // @[src/main/scala/SingleCycleCPU.scala 43:24]
  wire [31:0] _GEN_4401 = {{24'd0}, _inRAM_T_3}; // @[src/main/scala/SingleCycleCPU.scala 43:19]
  wire  inRAM = alu_io_result <= _GEN_4401; // @[src/main/scala/SingleCycleCPU.scala 43:19]
  wire  _mmio_T = alu_io_result == 32'hffff0000; // @[src/main/scala/SingleCycleCPU.scala 44:78]
  wire  _mmio_T_1 = alu_io_result == 32'hffff0004; // @[src/main/scala/SingleCycleCPU.scala 44:78]
  wire  _mmio_T_2 = alu_io_result == 32'hffff0008; // @[src/main/scala/SingleCycleCPU.scala 44:78]
  wire  _mmio_T_3 = alu_io_result == 32'hffff000c; // @[src/main/scala/SingleCycleCPU.scala 44:78]
  wire  mmio = alu_io_result == 32'hffff0000 | alu_io_result == 32'hffff0004 | alu_io_result == 32'hffff0008 |
    alu_io_result == 32'hffff000c; // @[src/main/scala/SingleCycleCPU.scala 44:94]
  wire  ioWritable = _mmio_T_1 | _mmio_T_2; // @[src/main/scala/SingleCycleCPU.scala 45:40]
  wire  ioAllowed = size == 2'h2 & mmio & (~dec_io_control[5] | ioWritable); // @[src/main/scala/SingleCycleCPU.scala 46:32]
  wire  memRequest = dec_io_control[4] | dec_io_control[5]; // @[src/main/scala/SingleCycleCPU.scala 47:34]
  wire  _misaligned_T_5 = _bytes_T_1 ? alu_io_result[0] : alu_io_result[1:0] != 2'h0; // @[src/main/scala/SingleCycleCPU.scala 48:43]
  wire  misaligned = _bytes_T ? 1'h0 : _misaligned_T_5; // @[src/main/scala/SingleCycleCPU.scala 48:20]
  wire [31:0] _ramWord_T_1 = alu_io_result + 32'h3; // @[src/main/scala/SingleCycleCPU.scala 49:60]
  wire [31:0] _ramWord_T_4 = alu_io_result + 32'h2; // @[src/main/scala/SingleCycleCPU.scala 49:60]
  wire [31:0] _ramWord_T_7 = alu_io_result + 32'h1; // @[src/main/scala/SingleCycleCPU.scala 49:60]
  wire [32:0] _ramWord_T_9 = {{1'd0}, alu_io_result}; // @[src/main/scala/SingleCycleCPU.scala 49:60]
  wire [7:0] _GEN_7 = 8'h1 == _ramWord_T_7[7:0] ? memory_1 : memory_0; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_8 = 8'h2 == _ramWord_T_7[7:0] ? memory_2 : _GEN_7; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_9 = 8'h3 == _ramWord_T_7[7:0] ? memory_3 : _GEN_8; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_10 = 8'h4 == _ramWord_T_7[7:0] ? memory_4 : _GEN_9; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_11 = 8'h5 == _ramWord_T_7[7:0] ? memory_5 : _GEN_10; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_12 = 8'h6 == _ramWord_T_7[7:0] ? memory_6 : _GEN_11; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_13 = 8'h7 == _ramWord_T_7[7:0] ? memory_7 : _GEN_12; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_14 = 8'h8 == _ramWord_T_7[7:0] ? memory_8 : _GEN_13; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_15 = 8'h9 == _ramWord_T_7[7:0] ? memory_9 : _GEN_14; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_16 = 8'ha == _ramWord_T_7[7:0] ? memory_10 : _GEN_15; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_17 = 8'hb == _ramWord_T_7[7:0] ? memory_11 : _GEN_16; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_18 = 8'hc == _ramWord_T_7[7:0] ? memory_12 : _GEN_17; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_19 = 8'hd == _ramWord_T_7[7:0] ? memory_13 : _GEN_18; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_20 = 8'he == _ramWord_T_7[7:0] ? memory_14 : _GEN_19; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_21 = 8'hf == _ramWord_T_7[7:0] ? memory_15 : _GEN_20; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_22 = 8'h10 == _ramWord_T_7[7:0] ? memory_16 : _GEN_21; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_23 = 8'h11 == _ramWord_T_7[7:0] ? memory_17 : _GEN_22; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_24 = 8'h12 == _ramWord_T_7[7:0] ? memory_18 : _GEN_23; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_25 = 8'h13 == _ramWord_T_7[7:0] ? memory_19 : _GEN_24; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_26 = 8'h14 == _ramWord_T_7[7:0] ? memory_20 : _GEN_25; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_27 = 8'h15 == _ramWord_T_7[7:0] ? memory_21 : _GEN_26; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_28 = 8'h16 == _ramWord_T_7[7:0] ? memory_22 : _GEN_27; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_29 = 8'h17 == _ramWord_T_7[7:0] ? memory_23 : _GEN_28; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_30 = 8'h18 == _ramWord_T_7[7:0] ? memory_24 : _GEN_29; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_31 = 8'h19 == _ramWord_T_7[7:0] ? memory_25 : _GEN_30; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_32 = 8'h1a == _ramWord_T_7[7:0] ? memory_26 : _GEN_31; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_33 = 8'h1b == _ramWord_T_7[7:0] ? memory_27 : _GEN_32; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_34 = 8'h1c == _ramWord_T_7[7:0] ? memory_28 : _GEN_33; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_35 = 8'h1d == _ramWord_T_7[7:0] ? memory_29 : _GEN_34; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_36 = 8'h1e == _ramWord_T_7[7:0] ? memory_30 : _GEN_35; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_37 = 8'h1f == _ramWord_T_7[7:0] ? memory_31 : _GEN_36; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_38 = 8'h20 == _ramWord_T_7[7:0] ? memory_32 : _GEN_37; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_39 = 8'h21 == _ramWord_T_7[7:0] ? memory_33 : _GEN_38; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_40 = 8'h22 == _ramWord_T_7[7:0] ? memory_34 : _GEN_39; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_41 = 8'h23 == _ramWord_T_7[7:0] ? memory_35 : _GEN_40; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_42 = 8'h24 == _ramWord_T_7[7:0] ? memory_36 : _GEN_41; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_43 = 8'h25 == _ramWord_T_7[7:0] ? memory_37 : _GEN_42; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_44 = 8'h26 == _ramWord_T_7[7:0] ? memory_38 : _GEN_43; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_45 = 8'h27 == _ramWord_T_7[7:0] ? memory_39 : _GEN_44; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_46 = 8'h28 == _ramWord_T_7[7:0] ? memory_40 : _GEN_45; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_47 = 8'h29 == _ramWord_T_7[7:0] ? memory_41 : _GEN_46; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_48 = 8'h2a == _ramWord_T_7[7:0] ? memory_42 : _GEN_47; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_49 = 8'h2b == _ramWord_T_7[7:0] ? memory_43 : _GEN_48; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_50 = 8'h2c == _ramWord_T_7[7:0] ? memory_44 : _GEN_49; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_51 = 8'h2d == _ramWord_T_7[7:0] ? memory_45 : _GEN_50; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_52 = 8'h2e == _ramWord_T_7[7:0] ? memory_46 : _GEN_51; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_53 = 8'h2f == _ramWord_T_7[7:0] ? memory_47 : _GEN_52; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_54 = 8'h30 == _ramWord_T_7[7:0] ? memory_48 : _GEN_53; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_55 = 8'h31 == _ramWord_T_7[7:0] ? memory_49 : _GEN_54; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_56 = 8'h32 == _ramWord_T_7[7:0] ? memory_50 : _GEN_55; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_57 = 8'h33 == _ramWord_T_7[7:0] ? memory_51 : _GEN_56; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_58 = 8'h34 == _ramWord_T_7[7:0] ? memory_52 : _GEN_57; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_59 = 8'h35 == _ramWord_T_7[7:0] ? memory_53 : _GEN_58; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_60 = 8'h36 == _ramWord_T_7[7:0] ? memory_54 : _GEN_59; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_61 = 8'h37 == _ramWord_T_7[7:0] ? memory_55 : _GEN_60; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_62 = 8'h38 == _ramWord_T_7[7:0] ? memory_56 : _GEN_61; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_63 = 8'h39 == _ramWord_T_7[7:0] ? memory_57 : _GEN_62; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_64 = 8'h3a == _ramWord_T_7[7:0] ? memory_58 : _GEN_63; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_65 = 8'h3b == _ramWord_T_7[7:0] ? memory_59 : _GEN_64; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_66 = 8'h3c == _ramWord_T_7[7:0] ? memory_60 : _GEN_65; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_67 = 8'h3d == _ramWord_T_7[7:0] ? memory_61 : _GEN_66; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_68 = 8'h3e == _ramWord_T_7[7:0] ? memory_62 : _GEN_67; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_69 = 8'h3f == _ramWord_T_7[7:0] ? memory_63 : _GEN_68; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_70 = 8'h40 == _ramWord_T_7[7:0] ? memory_64 : _GEN_69; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_71 = 8'h41 == _ramWord_T_7[7:0] ? memory_65 : _GEN_70; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_72 = 8'h42 == _ramWord_T_7[7:0] ? memory_66 : _GEN_71; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_73 = 8'h43 == _ramWord_T_7[7:0] ? memory_67 : _GEN_72; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_74 = 8'h44 == _ramWord_T_7[7:0] ? memory_68 : _GEN_73; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_75 = 8'h45 == _ramWord_T_7[7:0] ? memory_69 : _GEN_74; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_76 = 8'h46 == _ramWord_T_7[7:0] ? memory_70 : _GEN_75; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_77 = 8'h47 == _ramWord_T_7[7:0] ? memory_71 : _GEN_76; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_78 = 8'h48 == _ramWord_T_7[7:0] ? memory_72 : _GEN_77; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_79 = 8'h49 == _ramWord_T_7[7:0] ? memory_73 : _GEN_78; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_80 = 8'h4a == _ramWord_T_7[7:0] ? memory_74 : _GEN_79; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_81 = 8'h4b == _ramWord_T_7[7:0] ? memory_75 : _GEN_80; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_82 = 8'h4c == _ramWord_T_7[7:0] ? memory_76 : _GEN_81; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_83 = 8'h4d == _ramWord_T_7[7:0] ? memory_77 : _GEN_82; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_84 = 8'h4e == _ramWord_T_7[7:0] ? memory_78 : _GEN_83; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_85 = 8'h4f == _ramWord_T_7[7:0] ? memory_79 : _GEN_84; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_86 = 8'h50 == _ramWord_T_7[7:0] ? memory_80 : _GEN_85; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_87 = 8'h51 == _ramWord_T_7[7:0] ? memory_81 : _GEN_86; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_88 = 8'h52 == _ramWord_T_7[7:0] ? memory_82 : _GEN_87; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_89 = 8'h53 == _ramWord_T_7[7:0] ? memory_83 : _GEN_88; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_90 = 8'h54 == _ramWord_T_7[7:0] ? memory_84 : _GEN_89; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_91 = 8'h55 == _ramWord_T_7[7:0] ? memory_85 : _GEN_90; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_92 = 8'h56 == _ramWord_T_7[7:0] ? memory_86 : _GEN_91; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_93 = 8'h57 == _ramWord_T_7[7:0] ? memory_87 : _GEN_92; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_94 = 8'h58 == _ramWord_T_7[7:0] ? memory_88 : _GEN_93; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_95 = 8'h59 == _ramWord_T_7[7:0] ? memory_89 : _GEN_94; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_96 = 8'h5a == _ramWord_T_7[7:0] ? memory_90 : _GEN_95; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_97 = 8'h5b == _ramWord_T_7[7:0] ? memory_91 : _GEN_96; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_98 = 8'h5c == _ramWord_T_7[7:0] ? memory_92 : _GEN_97; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_99 = 8'h5d == _ramWord_T_7[7:0] ? memory_93 : _GEN_98; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_100 = 8'h5e == _ramWord_T_7[7:0] ? memory_94 : _GEN_99; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_101 = 8'h5f == _ramWord_T_7[7:0] ? memory_95 : _GEN_100; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_102 = 8'h60 == _ramWord_T_7[7:0] ? memory_96 : _GEN_101; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_103 = 8'h61 == _ramWord_T_7[7:0] ? memory_97 : _GEN_102; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_104 = 8'h62 == _ramWord_T_7[7:0] ? memory_98 : _GEN_103; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_105 = 8'h63 == _ramWord_T_7[7:0] ? memory_99 : _GEN_104; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_106 = 8'h64 == _ramWord_T_7[7:0] ? memory_100 : _GEN_105; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_107 = 8'h65 == _ramWord_T_7[7:0] ? memory_101 : _GEN_106; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_108 = 8'h66 == _ramWord_T_7[7:0] ? memory_102 : _GEN_107; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_109 = 8'h67 == _ramWord_T_7[7:0] ? memory_103 : _GEN_108; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_110 = 8'h68 == _ramWord_T_7[7:0] ? memory_104 : _GEN_109; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_111 = 8'h69 == _ramWord_T_7[7:0] ? memory_105 : _GEN_110; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_112 = 8'h6a == _ramWord_T_7[7:0] ? memory_106 : _GEN_111; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_113 = 8'h6b == _ramWord_T_7[7:0] ? memory_107 : _GEN_112; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_114 = 8'h6c == _ramWord_T_7[7:0] ? memory_108 : _GEN_113; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_115 = 8'h6d == _ramWord_T_7[7:0] ? memory_109 : _GEN_114; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_116 = 8'h6e == _ramWord_T_7[7:0] ? memory_110 : _GEN_115; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_117 = 8'h6f == _ramWord_T_7[7:0] ? memory_111 : _GEN_116; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_118 = 8'h70 == _ramWord_T_7[7:0] ? memory_112 : _GEN_117; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_119 = 8'h71 == _ramWord_T_7[7:0] ? memory_113 : _GEN_118; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_120 = 8'h72 == _ramWord_T_7[7:0] ? memory_114 : _GEN_119; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_121 = 8'h73 == _ramWord_T_7[7:0] ? memory_115 : _GEN_120; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_122 = 8'h74 == _ramWord_T_7[7:0] ? memory_116 : _GEN_121; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_123 = 8'h75 == _ramWord_T_7[7:0] ? memory_117 : _GEN_122; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_124 = 8'h76 == _ramWord_T_7[7:0] ? memory_118 : _GEN_123; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_125 = 8'h77 == _ramWord_T_7[7:0] ? memory_119 : _GEN_124; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_126 = 8'h78 == _ramWord_T_7[7:0] ? memory_120 : _GEN_125; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_127 = 8'h79 == _ramWord_T_7[7:0] ? memory_121 : _GEN_126; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_128 = 8'h7a == _ramWord_T_7[7:0] ? memory_122 : _GEN_127; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_129 = 8'h7b == _ramWord_T_7[7:0] ? memory_123 : _GEN_128; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_130 = 8'h7c == _ramWord_T_7[7:0] ? memory_124 : _GEN_129; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_131 = 8'h7d == _ramWord_T_7[7:0] ? memory_125 : _GEN_130; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_132 = 8'h7e == _ramWord_T_7[7:0] ? memory_126 : _GEN_131; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_133 = 8'h7f == _ramWord_T_7[7:0] ? memory_127 : _GEN_132; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_134 = 8'h80 == _ramWord_T_7[7:0] ? memory_128 : _GEN_133; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_135 = 8'h81 == _ramWord_T_7[7:0] ? memory_129 : _GEN_134; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_136 = 8'h82 == _ramWord_T_7[7:0] ? memory_130 : _GEN_135; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_137 = 8'h83 == _ramWord_T_7[7:0] ? memory_131 : _GEN_136; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_138 = 8'h84 == _ramWord_T_7[7:0] ? memory_132 : _GEN_137; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_139 = 8'h85 == _ramWord_T_7[7:0] ? memory_133 : _GEN_138; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_140 = 8'h86 == _ramWord_T_7[7:0] ? memory_134 : _GEN_139; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_141 = 8'h87 == _ramWord_T_7[7:0] ? memory_135 : _GEN_140; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_142 = 8'h88 == _ramWord_T_7[7:0] ? memory_136 : _GEN_141; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_143 = 8'h89 == _ramWord_T_7[7:0] ? memory_137 : _GEN_142; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_144 = 8'h8a == _ramWord_T_7[7:0] ? memory_138 : _GEN_143; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_145 = 8'h8b == _ramWord_T_7[7:0] ? memory_139 : _GEN_144; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_146 = 8'h8c == _ramWord_T_7[7:0] ? memory_140 : _GEN_145; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_147 = 8'h8d == _ramWord_T_7[7:0] ? memory_141 : _GEN_146; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_148 = 8'h8e == _ramWord_T_7[7:0] ? memory_142 : _GEN_147; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_149 = 8'h8f == _ramWord_T_7[7:0] ? memory_143 : _GEN_148; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_150 = 8'h90 == _ramWord_T_7[7:0] ? memory_144 : _GEN_149; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_151 = 8'h91 == _ramWord_T_7[7:0] ? memory_145 : _GEN_150; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_152 = 8'h92 == _ramWord_T_7[7:0] ? memory_146 : _GEN_151; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_153 = 8'h93 == _ramWord_T_7[7:0] ? memory_147 : _GEN_152; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_154 = 8'h94 == _ramWord_T_7[7:0] ? memory_148 : _GEN_153; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_155 = 8'h95 == _ramWord_T_7[7:0] ? memory_149 : _GEN_154; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_156 = 8'h96 == _ramWord_T_7[7:0] ? memory_150 : _GEN_155; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_157 = 8'h97 == _ramWord_T_7[7:0] ? memory_151 : _GEN_156; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_158 = 8'h98 == _ramWord_T_7[7:0] ? memory_152 : _GEN_157; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_159 = 8'h99 == _ramWord_T_7[7:0] ? memory_153 : _GEN_158; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_160 = 8'h9a == _ramWord_T_7[7:0] ? memory_154 : _GEN_159; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_161 = 8'h9b == _ramWord_T_7[7:0] ? memory_155 : _GEN_160; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_162 = 8'h9c == _ramWord_T_7[7:0] ? memory_156 : _GEN_161; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_163 = 8'h9d == _ramWord_T_7[7:0] ? memory_157 : _GEN_162; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_164 = 8'h9e == _ramWord_T_7[7:0] ? memory_158 : _GEN_163; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_165 = 8'h9f == _ramWord_T_7[7:0] ? memory_159 : _GEN_164; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_166 = 8'ha0 == _ramWord_T_7[7:0] ? memory_160 : _GEN_165; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_167 = 8'ha1 == _ramWord_T_7[7:0] ? memory_161 : _GEN_166; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_168 = 8'ha2 == _ramWord_T_7[7:0] ? memory_162 : _GEN_167; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_169 = 8'ha3 == _ramWord_T_7[7:0] ? memory_163 : _GEN_168; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_170 = 8'ha4 == _ramWord_T_7[7:0] ? memory_164 : _GEN_169; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_171 = 8'ha5 == _ramWord_T_7[7:0] ? memory_165 : _GEN_170; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_172 = 8'ha6 == _ramWord_T_7[7:0] ? memory_166 : _GEN_171; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_173 = 8'ha7 == _ramWord_T_7[7:0] ? memory_167 : _GEN_172; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_174 = 8'ha8 == _ramWord_T_7[7:0] ? memory_168 : _GEN_173; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_175 = 8'ha9 == _ramWord_T_7[7:0] ? memory_169 : _GEN_174; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_176 = 8'haa == _ramWord_T_7[7:0] ? memory_170 : _GEN_175; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_177 = 8'hab == _ramWord_T_7[7:0] ? memory_171 : _GEN_176; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_178 = 8'hac == _ramWord_T_7[7:0] ? memory_172 : _GEN_177; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_179 = 8'had == _ramWord_T_7[7:0] ? memory_173 : _GEN_178; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_180 = 8'hae == _ramWord_T_7[7:0] ? memory_174 : _GEN_179; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_181 = 8'haf == _ramWord_T_7[7:0] ? memory_175 : _GEN_180; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_182 = 8'hb0 == _ramWord_T_7[7:0] ? memory_176 : _GEN_181; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_183 = 8'hb1 == _ramWord_T_7[7:0] ? memory_177 : _GEN_182; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_184 = 8'hb2 == _ramWord_T_7[7:0] ? memory_178 : _GEN_183; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_185 = 8'hb3 == _ramWord_T_7[7:0] ? memory_179 : _GEN_184; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_186 = 8'hb4 == _ramWord_T_7[7:0] ? memory_180 : _GEN_185; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_187 = 8'hb5 == _ramWord_T_7[7:0] ? memory_181 : _GEN_186; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_188 = 8'hb6 == _ramWord_T_7[7:0] ? memory_182 : _GEN_187; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_189 = 8'hb7 == _ramWord_T_7[7:0] ? memory_183 : _GEN_188; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_190 = 8'hb8 == _ramWord_T_7[7:0] ? memory_184 : _GEN_189; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_191 = 8'hb9 == _ramWord_T_7[7:0] ? memory_185 : _GEN_190; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_192 = 8'hba == _ramWord_T_7[7:0] ? memory_186 : _GEN_191; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_193 = 8'hbb == _ramWord_T_7[7:0] ? memory_187 : _GEN_192; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_194 = 8'hbc == _ramWord_T_7[7:0] ? memory_188 : _GEN_193; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_195 = 8'hbd == _ramWord_T_7[7:0] ? memory_189 : _GEN_194; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_196 = 8'hbe == _ramWord_T_7[7:0] ? memory_190 : _GEN_195; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_197 = 8'hbf == _ramWord_T_7[7:0] ? memory_191 : _GEN_196; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_198 = 8'hc0 == _ramWord_T_7[7:0] ? memory_192 : _GEN_197; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_199 = 8'hc1 == _ramWord_T_7[7:0] ? memory_193 : _GEN_198; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_200 = 8'hc2 == _ramWord_T_7[7:0] ? memory_194 : _GEN_199; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_201 = 8'hc3 == _ramWord_T_7[7:0] ? memory_195 : _GEN_200; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_202 = 8'hc4 == _ramWord_T_7[7:0] ? memory_196 : _GEN_201; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_203 = 8'hc5 == _ramWord_T_7[7:0] ? memory_197 : _GEN_202; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_204 = 8'hc6 == _ramWord_T_7[7:0] ? memory_198 : _GEN_203; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_205 = 8'hc7 == _ramWord_T_7[7:0] ? memory_199 : _GEN_204; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_206 = 8'hc8 == _ramWord_T_7[7:0] ? memory_200 : _GEN_205; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_207 = 8'hc9 == _ramWord_T_7[7:0] ? memory_201 : _GEN_206; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_208 = 8'hca == _ramWord_T_7[7:0] ? memory_202 : _GEN_207; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_209 = 8'hcb == _ramWord_T_7[7:0] ? memory_203 : _GEN_208; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_210 = 8'hcc == _ramWord_T_7[7:0] ? memory_204 : _GEN_209; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_211 = 8'hcd == _ramWord_T_7[7:0] ? memory_205 : _GEN_210; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_212 = 8'hce == _ramWord_T_7[7:0] ? memory_206 : _GEN_211; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_213 = 8'hcf == _ramWord_T_7[7:0] ? memory_207 : _GEN_212; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_214 = 8'hd0 == _ramWord_T_7[7:0] ? memory_208 : _GEN_213; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_215 = 8'hd1 == _ramWord_T_7[7:0] ? memory_209 : _GEN_214; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_216 = 8'hd2 == _ramWord_T_7[7:0] ? memory_210 : _GEN_215; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_217 = 8'hd3 == _ramWord_T_7[7:0] ? memory_211 : _GEN_216; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_218 = 8'hd4 == _ramWord_T_7[7:0] ? memory_212 : _GEN_217; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_219 = 8'hd5 == _ramWord_T_7[7:0] ? memory_213 : _GEN_218; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_220 = 8'hd6 == _ramWord_T_7[7:0] ? memory_214 : _GEN_219; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_221 = 8'hd7 == _ramWord_T_7[7:0] ? memory_215 : _GEN_220; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_222 = 8'hd8 == _ramWord_T_7[7:0] ? memory_216 : _GEN_221; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_223 = 8'hd9 == _ramWord_T_7[7:0] ? memory_217 : _GEN_222; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_224 = 8'hda == _ramWord_T_7[7:0] ? memory_218 : _GEN_223; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_225 = 8'hdb == _ramWord_T_7[7:0] ? memory_219 : _GEN_224; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_226 = 8'hdc == _ramWord_T_7[7:0] ? memory_220 : _GEN_225; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_227 = 8'hdd == _ramWord_T_7[7:0] ? memory_221 : _GEN_226; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_228 = 8'hde == _ramWord_T_7[7:0] ? memory_222 : _GEN_227; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_229 = 8'hdf == _ramWord_T_7[7:0] ? memory_223 : _GEN_228; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_230 = 8'he0 == _ramWord_T_7[7:0] ? memory_224 : _GEN_229; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_231 = 8'he1 == _ramWord_T_7[7:0] ? memory_225 : _GEN_230; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_232 = 8'he2 == _ramWord_T_7[7:0] ? memory_226 : _GEN_231; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_233 = 8'he3 == _ramWord_T_7[7:0] ? memory_227 : _GEN_232; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_234 = 8'he4 == _ramWord_T_7[7:0] ? memory_228 : _GEN_233; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_235 = 8'he5 == _ramWord_T_7[7:0] ? memory_229 : _GEN_234; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_236 = 8'he6 == _ramWord_T_7[7:0] ? memory_230 : _GEN_235; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_237 = 8'he7 == _ramWord_T_7[7:0] ? memory_231 : _GEN_236; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_238 = 8'he8 == _ramWord_T_7[7:0] ? memory_232 : _GEN_237; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_239 = 8'he9 == _ramWord_T_7[7:0] ? memory_233 : _GEN_238; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_240 = 8'hea == _ramWord_T_7[7:0] ? memory_234 : _GEN_239; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_241 = 8'heb == _ramWord_T_7[7:0] ? memory_235 : _GEN_240; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_242 = 8'hec == _ramWord_T_7[7:0] ? memory_236 : _GEN_241; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_243 = 8'hed == _ramWord_T_7[7:0] ? memory_237 : _GEN_242; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_244 = 8'hee == _ramWord_T_7[7:0] ? memory_238 : _GEN_243; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_245 = 8'hef == _ramWord_T_7[7:0] ? memory_239 : _GEN_244; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_246 = 8'hf0 == _ramWord_T_7[7:0] ? memory_240 : _GEN_245; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_247 = 8'hf1 == _ramWord_T_7[7:0] ? memory_241 : _GEN_246; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_248 = 8'hf2 == _ramWord_T_7[7:0] ? memory_242 : _GEN_247; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_249 = 8'hf3 == _ramWord_T_7[7:0] ? memory_243 : _GEN_248; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_250 = 8'hf4 == _ramWord_T_7[7:0] ? memory_244 : _GEN_249; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_251 = 8'hf5 == _ramWord_T_7[7:0] ? memory_245 : _GEN_250; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_252 = 8'hf6 == _ramWord_T_7[7:0] ? memory_246 : _GEN_251; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_253 = 8'hf7 == _ramWord_T_7[7:0] ? memory_247 : _GEN_252; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_254 = 8'hf8 == _ramWord_T_7[7:0] ? memory_248 : _GEN_253; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_255 = 8'hf9 == _ramWord_T_7[7:0] ? memory_249 : _GEN_254; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_256 = 8'hfa == _ramWord_T_7[7:0] ? memory_250 : _GEN_255; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_257 = 8'hfb == _ramWord_T_7[7:0] ? memory_251 : _GEN_256; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_258 = 8'hfc == _ramWord_T_7[7:0] ? memory_252 : _GEN_257; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_259 = 8'hfd == _ramWord_T_7[7:0] ? memory_253 : _GEN_258; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_260 = 8'hfe == _ramWord_T_7[7:0] ? memory_254 : _GEN_259; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_261 = 8'hff == _ramWord_T_7[7:0] ? memory_255 : _GEN_260; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_263 = 8'h1 == _ramWord_T_9[7:0] ? memory_1 : memory_0; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_264 = 8'h2 == _ramWord_T_9[7:0] ? memory_2 : _GEN_263; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_265 = 8'h3 == _ramWord_T_9[7:0] ? memory_3 : _GEN_264; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_266 = 8'h4 == _ramWord_T_9[7:0] ? memory_4 : _GEN_265; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_267 = 8'h5 == _ramWord_T_9[7:0] ? memory_5 : _GEN_266; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_268 = 8'h6 == _ramWord_T_9[7:0] ? memory_6 : _GEN_267; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_269 = 8'h7 == _ramWord_T_9[7:0] ? memory_7 : _GEN_268; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_270 = 8'h8 == _ramWord_T_9[7:0] ? memory_8 : _GEN_269; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_271 = 8'h9 == _ramWord_T_9[7:0] ? memory_9 : _GEN_270; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_272 = 8'ha == _ramWord_T_9[7:0] ? memory_10 : _GEN_271; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_273 = 8'hb == _ramWord_T_9[7:0] ? memory_11 : _GEN_272; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_274 = 8'hc == _ramWord_T_9[7:0] ? memory_12 : _GEN_273; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_275 = 8'hd == _ramWord_T_9[7:0] ? memory_13 : _GEN_274; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_276 = 8'he == _ramWord_T_9[7:0] ? memory_14 : _GEN_275; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_277 = 8'hf == _ramWord_T_9[7:0] ? memory_15 : _GEN_276; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_278 = 8'h10 == _ramWord_T_9[7:0] ? memory_16 : _GEN_277; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_279 = 8'h11 == _ramWord_T_9[7:0] ? memory_17 : _GEN_278; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_280 = 8'h12 == _ramWord_T_9[7:0] ? memory_18 : _GEN_279; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_281 = 8'h13 == _ramWord_T_9[7:0] ? memory_19 : _GEN_280; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_282 = 8'h14 == _ramWord_T_9[7:0] ? memory_20 : _GEN_281; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_283 = 8'h15 == _ramWord_T_9[7:0] ? memory_21 : _GEN_282; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_284 = 8'h16 == _ramWord_T_9[7:0] ? memory_22 : _GEN_283; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_285 = 8'h17 == _ramWord_T_9[7:0] ? memory_23 : _GEN_284; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_286 = 8'h18 == _ramWord_T_9[7:0] ? memory_24 : _GEN_285; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_287 = 8'h19 == _ramWord_T_9[7:0] ? memory_25 : _GEN_286; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_288 = 8'h1a == _ramWord_T_9[7:0] ? memory_26 : _GEN_287; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_289 = 8'h1b == _ramWord_T_9[7:0] ? memory_27 : _GEN_288; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_290 = 8'h1c == _ramWord_T_9[7:0] ? memory_28 : _GEN_289; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_291 = 8'h1d == _ramWord_T_9[7:0] ? memory_29 : _GEN_290; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_292 = 8'h1e == _ramWord_T_9[7:0] ? memory_30 : _GEN_291; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_293 = 8'h1f == _ramWord_T_9[7:0] ? memory_31 : _GEN_292; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_294 = 8'h20 == _ramWord_T_9[7:0] ? memory_32 : _GEN_293; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_295 = 8'h21 == _ramWord_T_9[7:0] ? memory_33 : _GEN_294; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_296 = 8'h22 == _ramWord_T_9[7:0] ? memory_34 : _GEN_295; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_297 = 8'h23 == _ramWord_T_9[7:0] ? memory_35 : _GEN_296; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_298 = 8'h24 == _ramWord_T_9[7:0] ? memory_36 : _GEN_297; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_299 = 8'h25 == _ramWord_T_9[7:0] ? memory_37 : _GEN_298; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_300 = 8'h26 == _ramWord_T_9[7:0] ? memory_38 : _GEN_299; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_301 = 8'h27 == _ramWord_T_9[7:0] ? memory_39 : _GEN_300; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_302 = 8'h28 == _ramWord_T_9[7:0] ? memory_40 : _GEN_301; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_303 = 8'h29 == _ramWord_T_9[7:0] ? memory_41 : _GEN_302; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_304 = 8'h2a == _ramWord_T_9[7:0] ? memory_42 : _GEN_303; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_305 = 8'h2b == _ramWord_T_9[7:0] ? memory_43 : _GEN_304; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_306 = 8'h2c == _ramWord_T_9[7:0] ? memory_44 : _GEN_305; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_307 = 8'h2d == _ramWord_T_9[7:0] ? memory_45 : _GEN_306; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_308 = 8'h2e == _ramWord_T_9[7:0] ? memory_46 : _GEN_307; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_309 = 8'h2f == _ramWord_T_9[7:0] ? memory_47 : _GEN_308; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_310 = 8'h30 == _ramWord_T_9[7:0] ? memory_48 : _GEN_309; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_311 = 8'h31 == _ramWord_T_9[7:0] ? memory_49 : _GEN_310; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_312 = 8'h32 == _ramWord_T_9[7:0] ? memory_50 : _GEN_311; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_313 = 8'h33 == _ramWord_T_9[7:0] ? memory_51 : _GEN_312; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_314 = 8'h34 == _ramWord_T_9[7:0] ? memory_52 : _GEN_313; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_315 = 8'h35 == _ramWord_T_9[7:0] ? memory_53 : _GEN_314; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_316 = 8'h36 == _ramWord_T_9[7:0] ? memory_54 : _GEN_315; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_317 = 8'h37 == _ramWord_T_9[7:0] ? memory_55 : _GEN_316; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_318 = 8'h38 == _ramWord_T_9[7:0] ? memory_56 : _GEN_317; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_319 = 8'h39 == _ramWord_T_9[7:0] ? memory_57 : _GEN_318; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_320 = 8'h3a == _ramWord_T_9[7:0] ? memory_58 : _GEN_319; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_321 = 8'h3b == _ramWord_T_9[7:0] ? memory_59 : _GEN_320; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_322 = 8'h3c == _ramWord_T_9[7:0] ? memory_60 : _GEN_321; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_323 = 8'h3d == _ramWord_T_9[7:0] ? memory_61 : _GEN_322; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_324 = 8'h3e == _ramWord_T_9[7:0] ? memory_62 : _GEN_323; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_325 = 8'h3f == _ramWord_T_9[7:0] ? memory_63 : _GEN_324; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_326 = 8'h40 == _ramWord_T_9[7:0] ? memory_64 : _GEN_325; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_327 = 8'h41 == _ramWord_T_9[7:0] ? memory_65 : _GEN_326; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_328 = 8'h42 == _ramWord_T_9[7:0] ? memory_66 : _GEN_327; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_329 = 8'h43 == _ramWord_T_9[7:0] ? memory_67 : _GEN_328; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_330 = 8'h44 == _ramWord_T_9[7:0] ? memory_68 : _GEN_329; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_331 = 8'h45 == _ramWord_T_9[7:0] ? memory_69 : _GEN_330; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_332 = 8'h46 == _ramWord_T_9[7:0] ? memory_70 : _GEN_331; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_333 = 8'h47 == _ramWord_T_9[7:0] ? memory_71 : _GEN_332; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_334 = 8'h48 == _ramWord_T_9[7:0] ? memory_72 : _GEN_333; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_335 = 8'h49 == _ramWord_T_9[7:0] ? memory_73 : _GEN_334; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_336 = 8'h4a == _ramWord_T_9[7:0] ? memory_74 : _GEN_335; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_337 = 8'h4b == _ramWord_T_9[7:0] ? memory_75 : _GEN_336; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_338 = 8'h4c == _ramWord_T_9[7:0] ? memory_76 : _GEN_337; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_339 = 8'h4d == _ramWord_T_9[7:0] ? memory_77 : _GEN_338; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_340 = 8'h4e == _ramWord_T_9[7:0] ? memory_78 : _GEN_339; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_341 = 8'h4f == _ramWord_T_9[7:0] ? memory_79 : _GEN_340; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_342 = 8'h50 == _ramWord_T_9[7:0] ? memory_80 : _GEN_341; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_343 = 8'h51 == _ramWord_T_9[7:0] ? memory_81 : _GEN_342; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_344 = 8'h52 == _ramWord_T_9[7:0] ? memory_82 : _GEN_343; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_345 = 8'h53 == _ramWord_T_9[7:0] ? memory_83 : _GEN_344; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_346 = 8'h54 == _ramWord_T_9[7:0] ? memory_84 : _GEN_345; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_347 = 8'h55 == _ramWord_T_9[7:0] ? memory_85 : _GEN_346; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_348 = 8'h56 == _ramWord_T_9[7:0] ? memory_86 : _GEN_347; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_349 = 8'h57 == _ramWord_T_9[7:0] ? memory_87 : _GEN_348; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_350 = 8'h58 == _ramWord_T_9[7:0] ? memory_88 : _GEN_349; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_351 = 8'h59 == _ramWord_T_9[7:0] ? memory_89 : _GEN_350; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_352 = 8'h5a == _ramWord_T_9[7:0] ? memory_90 : _GEN_351; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_353 = 8'h5b == _ramWord_T_9[7:0] ? memory_91 : _GEN_352; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_354 = 8'h5c == _ramWord_T_9[7:0] ? memory_92 : _GEN_353; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_355 = 8'h5d == _ramWord_T_9[7:0] ? memory_93 : _GEN_354; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_356 = 8'h5e == _ramWord_T_9[7:0] ? memory_94 : _GEN_355; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_357 = 8'h5f == _ramWord_T_9[7:0] ? memory_95 : _GEN_356; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_358 = 8'h60 == _ramWord_T_9[7:0] ? memory_96 : _GEN_357; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_359 = 8'h61 == _ramWord_T_9[7:0] ? memory_97 : _GEN_358; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_360 = 8'h62 == _ramWord_T_9[7:0] ? memory_98 : _GEN_359; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_361 = 8'h63 == _ramWord_T_9[7:0] ? memory_99 : _GEN_360; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_362 = 8'h64 == _ramWord_T_9[7:0] ? memory_100 : _GEN_361; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_363 = 8'h65 == _ramWord_T_9[7:0] ? memory_101 : _GEN_362; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_364 = 8'h66 == _ramWord_T_9[7:0] ? memory_102 : _GEN_363; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_365 = 8'h67 == _ramWord_T_9[7:0] ? memory_103 : _GEN_364; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_366 = 8'h68 == _ramWord_T_9[7:0] ? memory_104 : _GEN_365; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_367 = 8'h69 == _ramWord_T_9[7:0] ? memory_105 : _GEN_366; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_368 = 8'h6a == _ramWord_T_9[7:0] ? memory_106 : _GEN_367; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_369 = 8'h6b == _ramWord_T_9[7:0] ? memory_107 : _GEN_368; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_370 = 8'h6c == _ramWord_T_9[7:0] ? memory_108 : _GEN_369; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_371 = 8'h6d == _ramWord_T_9[7:0] ? memory_109 : _GEN_370; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_372 = 8'h6e == _ramWord_T_9[7:0] ? memory_110 : _GEN_371; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_373 = 8'h6f == _ramWord_T_9[7:0] ? memory_111 : _GEN_372; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_374 = 8'h70 == _ramWord_T_9[7:0] ? memory_112 : _GEN_373; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_375 = 8'h71 == _ramWord_T_9[7:0] ? memory_113 : _GEN_374; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_376 = 8'h72 == _ramWord_T_9[7:0] ? memory_114 : _GEN_375; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_377 = 8'h73 == _ramWord_T_9[7:0] ? memory_115 : _GEN_376; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_378 = 8'h74 == _ramWord_T_9[7:0] ? memory_116 : _GEN_377; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_379 = 8'h75 == _ramWord_T_9[7:0] ? memory_117 : _GEN_378; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_380 = 8'h76 == _ramWord_T_9[7:0] ? memory_118 : _GEN_379; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_381 = 8'h77 == _ramWord_T_9[7:0] ? memory_119 : _GEN_380; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_382 = 8'h78 == _ramWord_T_9[7:0] ? memory_120 : _GEN_381; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_383 = 8'h79 == _ramWord_T_9[7:0] ? memory_121 : _GEN_382; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_384 = 8'h7a == _ramWord_T_9[7:0] ? memory_122 : _GEN_383; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_385 = 8'h7b == _ramWord_T_9[7:0] ? memory_123 : _GEN_384; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_386 = 8'h7c == _ramWord_T_9[7:0] ? memory_124 : _GEN_385; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_387 = 8'h7d == _ramWord_T_9[7:0] ? memory_125 : _GEN_386; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_388 = 8'h7e == _ramWord_T_9[7:0] ? memory_126 : _GEN_387; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_389 = 8'h7f == _ramWord_T_9[7:0] ? memory_127 : _GEN_388; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_390 = 8'h80 == _ramWord_T_9[7:0] ? memory_128 : _GEN_389; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_391 = 8'h81 == _ramWord_T_9[7:0] ? memory_129 : _GEN_390; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_392 = 8'h82 == _ramWord_T_9[7:0] ? memory_130 : _GEN_391; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_393 = 8'h83 == _ramWord_T_9[7:0] ? memory_131 : _GEN_392; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_394 = 8'h84 == _ramWord_T_9[7:0] ? memory_132 : _GEN_393; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_395 = 8'h85 == _ramWord_T_9[7:0] ? memory_133 : _GEN_394; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_396 = 8'h86 == _ramWord_T_9[7:0] ? memory_134 : _GEN_395; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_397 = 8'h87 == _ramWord_T_9[7:0] ? memory_135 : _GEN_396; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_398 = 8'h88 == _ramWord_T_9[7:0] ? memory_136 : _GEN_397; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_399 = 8'h89 == _ramWord_T_9[7:0] ? memory_137 : _GEN_398; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_400 = 8'h8a == _ramWord_T_9[7:0] ? memory_138 : _GEN_399; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_401 = 8'h8b == _ramWord_T_9[7:0] ? memory_139 : _GEN_400; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_402 = 8'h8c == _ramWord_T_9[7:0] ? memory_140 : _GEN_401; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_403 = 8'h8d == _ramWord_T_9[7:0] ? memory_141 : _GEN_402; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_404 = 8'h8e == _ramWord_T_9[7:0] ? memory_142 : _GEN_403; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_405 = 8'h8f == _ramWord_T_9[7:0] ? memory_143 : _GEN_404; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_406 = 8'h90 == _ramWord_T_9[7:0] ? memory_144 : _GEN_405; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_407 = 8'h91 == _ramWord_T_9[7:0] ? memory_145 : _GEN_406; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_408 = 8'h92 == _ramWord_T_9[7:0] ? memory_146 : _GEN_407; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_409 = 8'h93 == _ramWord_T_9[7:0] ? memory_147 : _GEN_408; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_410 = 8'h94 == _ramWord_T_9[7:0] ? memory_148 : _GEN_409; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_411 = 8'h95 == _ramWord_T_9[7:0] ? memory_149 : _GEN_410; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_412 = 8'h96 == _ramWord_T_9[7:0] ? memory_150 : _GEN_411; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_413 = 8'h97 == _ramWord_T_9[7:0] ? memory_151 : _GEN_412; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_414 = 8'h98 == _ramWord_T_9[7:0] ? memory_152 : _GEN_413; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_415 = 8'h99 == _ramWord_T_9[7:0] ? memory_153 : _GEN_414; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_416 = 8'h9a == _ramWord_T_9[7:0] ? memory_154 : _GEN_415; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_417 = 8'h9b == _ramWord_T_9[7:0] ? memory_155 : _GEN_416; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_418 = 8'h9c == _ramWord_T_9[7:0] ? memory_156 : _GEN_417; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_419 = 8'h9d == _ramWord_T_9[7:0] ? memory_157 : _GEN_418; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_420 = 8'h9e == _ramWord_T_9[7:0] ? memory_158 : _GEN_419; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_421 = 8'h9f == _ramWord_T_9[7:0] ? memory_159 : _GEN_420; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_422 = 8'ha0 == _ramWord_T_9[7:0] ? memory_160 : _GEN_421; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_423 = 8'ha1 == _ramWord_T_9[7:0] ? memory_161 : _GEN_422; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_424 = 8'ha2 == _ramWord_T_9[7:0] ? memory_162 : _GEN_423; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_425 = 8'ha3 == _ramWord_T_9[7:0] ? memory_163 : _GEN_424; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_426 = 8'ha4 == _ramWord_T_9[7:0] ? memory_164 : _GEN_425; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_427 = 8'ha5 == _ramWord_T_9[7:0] ? memory_165 : _GEN_426; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_428 = 8'ha6 == _ramWord_T_9[7:0] ? memory_166 : _GEN_427; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_429 = 8'ha7 == _ramWord_T_9[7:0] ? memory_167 : _GEN_428; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_430 = 8'ha8 == _ramWord_T_9[7:0] ? memory_168 : _GEN_429; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_431 = 8'ha9 == _ramWord_T_9[7:0] ? memory_169 : _GEN_430; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_432 = 8'haa == _ramWord_T_9[7:0] ? memory_170 : _GEN_431; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_433 = 8'hab == _ramWord_T_9[7:0] ? memory_171 : _GEN_432; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_434 = 8'hac == _ramWord_T_9[7:0] ? memory_172 : _GEN_433; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_435 = 8'had == _ramWord_T_9[7:0] ? memory_173 : _GEN_434; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_436 = 8'hae == _ramWord_T_9[7:0] ? memory_174 : _GEN_435; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_437 = 8'haf == _ramWord_T_9[7:0] ? memory_175 : _GEN_436; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_438 = 8'hb0 == _ramWord_T_9[7:0] ? memory_176 : _GEN_437; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_439 = 8'hb1 == _ramWord_T_9[7:0] ? memory_177 : _GEN_438; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_440 = 8'hb2 == _ramWord_T_9[7:0] ? memory_178 : _GEN_439; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_441 = 8'hb3 == _ramWord_T_9[7:0] ? memory_179 : _GEN_440; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_442 = 8'hb4 == _ramWord_T_9[7:0] ? memory_180 : _GEN_441; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_443 = 8'hb5 == _ramWord_T_9[7:0] ? memory_181 : _GEN_442; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_444 = 8'hb6 == _ramWord_T_9[7:0] ? memory_182 : _GEN_443; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_445 = 8'hb7 == _ramWord_T_9[7:0] ? memory_183 : _GEN_444; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_446 = 8'hb8 == _ramWord_T_9[7:0] ? memory_184 : _GEN_445; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_447 = 8'hb9 == _ramWord_T_9[7:0] ? memory_185 : _GEN_446; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_448 = 8'hba == _ramWord_T_9[7:0] ? memory_186 : _GEN_447; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_449 = 8'hbb == _ramWord_T_9[7:0] ? memory_187 : _GEN_448; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_450 = 8'hbc == _ramWord_T_9[7:0] ? memory_188 : _GEN_449; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_451 = 8'hbd == _ramWord_T_9[7:0] ? memory_189 : _GEN_450; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_452 = 8'hbe == _ramWord_T_9[7:0] ? memory_190 : _GEN_451; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_453 = 8'hbf == _ramWord_T_9[7:0] ? memory_191 : _GEN_452; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_454 = 8'hc0 == _ramWord_T_9[7:0] ? memory_192 : _GEN_453; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_455 = 8'hc1 == _ramWord_T_9[7:0] ? memory_193 : _GEN_454; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_456 = 8'hc2 == _ramWord_T_9[7:0] ? memory_194 : _GEN_455; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_457 = 8'hc3 == _ramWord_T_9[7:0] ? memory_195 : _GEN_456; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_458 = 8'hc4 == _ramWord_T_9[7:0] ? memory_196 : _GEN_457; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_459 = 8'hc5 == _ramWord_T_9[7:0] ? memory_197 : _GEN_458; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_460 = 8'hc6 == _ramWord_T_9[7:0] ? memory_198 : _GEN_459; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_461 = 8'hc7 == _ramWord_T_9[7:0] ? memory_199 : _GEN_460; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_462 = 8'hc8 == _ramWord_T_9[7:0] ? memory_200 : _GEN_461; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_463 = 8'hc9 == _ramWord_T_9[7:0] ? memory_201 : _GEN_462; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_464 = 8'hca == _ramWord_T_9[7:0] ? memory_202 : _GEN_463; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_465 = 8'hcb == _ramWord_T_9[7:0] ? memory_203 : _GEN_464; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_466 = 8'hcc == _ramWord_T_9[7:0] ? memory_204 : _GEN_465; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_467 = 8'hcd == _ramWord_T_9[7:0] ? memory_205 : _GEN_466; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_468 = 8'hce == _ramWord_T_9[7:0] ? memory_206 : _GEN_467; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_469 = 8'hcf == _ramWord_T_9[7:0] ? memory_207 : _GEN_468; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_470 = 8'hd0 == _ramWord_T_9[7:0] ? memory_208 : _GEN_469; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_471 = 8'hd1 == _ramWord_T_9[7:0] ? memory_209 : _GEN_470; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_472 = 8'hd2 == _ramWord_T_9[7:0] ? memory_210 : _GEN_471; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_473 = 8'hd3 == _ramWord_T_9[7:0] ? memory_211 : _GEN_472; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_474 = 8'hd4 == _ramWord_T_9[7:0] ? memory_212 : _GEN_473; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_475 = 8'hd5 == _ramWord_T_9[7:0] ? memory_213 : _GEN_474; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_476 = 8'hd6 == _ramWord_T_9[7:0] ? memory_214 : _GEN_475; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_477 = 8'hd7 == _ramWord_T_9[7:0] ? memory_215 : _GEN_476; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_478 = 8'hd8 == _ramWord_T_9[7:0] ? memory_216 : _GEN_477; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_479 = 8'hd9 == _ramWord_T_9[7:0] ? memory_217 : _GEN_478; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_480 = 8'hda == _ramWord_T_9[7:0] ? memory_218 : _GEN_479; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_481 = 8'hdb == _ramWord_T_9[7:0] ? memory_219 : _GEN_480; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_482 = 8'hdc == _ramWord_T_9[7:0] ? memory_220 : _GEN_481; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_483 = 8'hdd == _ramWord_T_9[7:0] ? memory_221 : _GEN_482; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_484 = 8'hde == _ramWord_T_9[7:0] ? memory_222 : _GEN_483; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_485 = 8'hdf == _ramWord_T_9[7:0] ? memory_223 : _GEN_484; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_486 = 8'he0 == _ramWord_T_9[7:0] ? memory_224 : _GEN_485; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_487 = 8'he1 == _ramWord_T_9[7:0] ? memory_225 : _GEN_486; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_488 = 8'he2 == _ramWord_T_9[7:0] ? memory_226 : _GEN_487; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_489 = 8'he3 == _ramWord_T_9[7:0] ? memory_227 : _GEN_488; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_490 = 8'he4 == _ramWord_T_9[7:0] ? memory_228 : _GEN_489; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_491 = 8'he5 == _ramWord_T_9[7:0] ? memory_229 : _GEN_490; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_492 = 8'he6 == _ramWord_T_9[7:0] ? memory_230 : _GEN_491; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_493 = 8'he7 == _ramWord_T_9[7:0] ? memory_231 : _GEN_492; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_494 = 8'he8 == _ramWord_T_9[7:0] ? memory_232 : _GEN_493; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_495 = 8'he9 == _ramWord_T_9[7:0] ? memory_233 : _GEN_494; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_496 = 8'hea == _ramWord_T_9[7:0] ? memory_234 : _GEN_495; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_497 = 8'heb == _ramWord_T_9[7:0] ? memory_235 : _GEN_496; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_498 = 8'hec == _ramWord_T_9[7:0] ? memory_236 : _GEN_497; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_499 = 8'hed == _ramWord_T_9[7:0] ? memory_237 : _GEN_498; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_500 = 8'hee == _ramWord_T_9[7:0] ? memory_238 : _GEN_499; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_501 = 8'hef == _ramWord_T_9[7:0] ? memory_239 : _GEN_500; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_502 = 8'hf0 == _ramWord_T_9[7:0] ? memory_240 : _GEN_501; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_503 = 8'hf1 == _ramWord_T_9[7:0] ? memory_241 : _GEN_502; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_504 = 8'hf2 == _ramWord_T_9[7:0] ? memory_242 : _GEN_503; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_505 = 8'hf3 == _ramWord_T_9[7:0] ? memory_243 : _GEN_504; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_506 = 8'hf4 == _ramWord_T_9[7:0] ? memory_244 : _GEN_505; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_507 = 8'hf5 == _ramWord_T_9[7:0] ? memory_245 : _GEN_506; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_508 = 8'hf6 == _ramWord_T_9[7:0] ? memory_246 : _GEN_507; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_509 = 8'hf7 == _ramWord_T_9[7:0] ? memory_247 : _GEN_508; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_510 = 8'hf8 == _ramWord_T_9[7:0] ? memory_248 : _GEN_509; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_511 = 8'hf9 == _ramWord_T_9[7:0] ? memory_249 : _GEN_510; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_512 = 8'hfa == _ramWord_T_9[7:0] ? memory_250 : _GEN_511; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_513 = 8'hfb == _ramWord_T_9[7:0] ? memory_251 : _GEN_512; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_514 = 8'hfc == _ramWord_T_9[7:0] ? memory_252 : _GEN_513; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_515 = 8'hfd == _ramWord_T_9[7:0] ? memory_253 : _GEN_514; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_516 = 8'hfe == _ramWord_T_9[7:0] ? memory_254 : _GEN_515; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_517 = 8'hff == _ramWord_T_9[7:0] ? memory_255 : _GEN_516; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_519 = 8'h1 == _ramWord_T_1[7:0] ? memory_1 : memory_0; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_520 = 8'h2 == _ramWord_T_1[7:0] ? memory_2 : _GEN_519; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_521 = 8'h3 == _ramWord_T_1[7:0] ? memory_3 : _GEN_520; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_522 = 8'h4 == _ramWord_T_1[7:0] ? memory_4 : _GEN_521; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_523 = 8'h5 == _ramWord_T_1[7:0] ? memory_5 : _GEN_522; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_524 = 8'h6 == _ramWord_T_1[7:0] ? memory_6 : _GEN_523; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_525 = 8'h7 == _ramWord_T_1[7:0] ? memory_7 : _GEN_524; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_526 = 8'h8 == _ramWord_T_1[7:0] ? memory_8 : _GEN_525; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_527 = 8'h9 == _ramWord_T_1[7:0] ? memory_9 : _GEN_526; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_528 = 8'ha == _ramWord_T_1[7:0] ? memory_10 : _GEN_527; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_529 = 8'hb == _ramWord_T_1[7:0] ? memory_11 : _GEN_528; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_530 = 8'hc == _ramWord_T_1[7:0] ? memory_12 : _GEN_529; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_531 = 8'hd == _ramWord_T_1[7:0] ? memory_13 : _GEN_530; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_532 = 8'he == _ramWord_T_1[7:0] ? memory_14 : _GEN_531; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_533 = 8'hf == _ramWord_T_1[7:0] ? memory_15 : _GEN_532; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_534 = 8'h10 == _ramWord_T_1[7:0] ? memory_16 : _GEN_533; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_535 = 8'h11 == _ramWord_T_1[7:0] ? memory_17 : _GEN_534; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_536 = 8'h12 == _ramWord_T_1[7:0] ? memory_18 : _GEN_535; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_537 = 8'h13 == _ramWord_T_1[7:0] ? memory_19 : _GEN_536; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_538 = 8'h14 == _ramWord_T_1[7:0] ? memory_20 : _GEN_537; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_539 = 8'h15 == _ramWord_T_1[7:0] ? memory_21 : _GEN_538; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_540 = 8'h16 == _ramWord_T_1[7:0] ? memory_22 : _GEN_539; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_541 = 8'h17 == _ramWord_T_1[7:0] ? memory_23 : _GEN_540; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_542 = 8'h18 == _ramWord_T_1[7:0] ? memory_24 : _GEN_541; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_543 = 8'h19 == _ramWord_T_1[7:0] ? memory_25 : _GEN_542; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_544 = 8'h1a == _ramWord_T_1[7:0] ? memory_26 : _GEN_543; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_545 = 8'h1b == _ramWord_T_1[7:0] ? memory_27 : _GEN_544; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_546 = 8'h1c == _ramWord_T_1[7:0] ? memory_28 : _GEN_545; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_547 = 8'h1d == _ramWord_T_1[7:0] ? memory_29 : _GEN_546; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_548 = 8'h1e == _ramWord_T_1[7:0] ? memory_30 : _GEN_547; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_549 = 8'h1f == _ramWord_T_1[7:0] ? memory_31 : _GEN_548; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_550 = 8'h20 == _ramWord_T_1[7:0] ? memory_32 : _GEN_549; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_551 = 8'h21 == _ramWord_T_1[7:0] ? memory_33 : _GEN_550; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_552 = 8'h22 == _ramWord_T_1[7:0] ? memory_34 : _GEN_551; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_553 = 8'h23 == _ramWord_T_1[7:0] ? memory_35 : _GEN_552; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_554 = 8'h24 == _ramWord_T_1[7:0] ? memory_36 : _GEN_553; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_555 = 8'h25 == _ramWord_T_1[7:0] ? memory_37 : _GEN_554; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_556 = 8'h26 == _ramWord_T_1[7:0] ? memory_38 : _GEN_555; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_557 = 8'h27 == _ramWord_T_1[7:0] ? memory_39 : _GEN_556; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_558 = 8'h28 == _ramWord_T_1[7:0] ? memory_40 : _GEN_557; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_559 = 8'h29 == _ramWord_T_1[7:0] ? memory_41 : _GEN_558; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_560 = 8'h2a == _ramWord_T_1[7:0] ? memory_42 : _GEN_559; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_561 = 8'h2b == _ramWord_T_1[7:0] ? memory_43 : _GEN_560; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_562 = 8'h2c == _ramWord_T_1[7:0] ? memory_44 : _GEN_561; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_563 = 8'h2d == _ramWord_T_1[7:0] ? memory_45 : _GEN_562; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_564 = 8'h2e == _ramWord_T_1[7:0] ? memory_46 : _GEN_563; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_565 = 8'h2f == _ramWord_T_1[7:0] ? memory_47 : _GEN_564; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_566 = 8'h30 == _ramWord_T_1[7:0] ? memory_48 : _GEN_565; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_567 = 8'h31 == _ramWord_T_1[7:0] ? memory_49 : _GEN_566; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_568 = 8'h32 == _ramWord_T_1[7:0] ? memory_50 : _GEN_567; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_569 = 8'h33 == _ramWord_T_1[7:0] ? memory_51 : _GEN_568; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_570 = 8'h34 == _ramWord_T_1[7:0] ? memory_52 : _GEN_569; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_571 = 8'h35 == _ramWord_T_1[7:0] ? memory_53 : _GEN_570; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_572 = 8'h36 == _ramWord_T_1[7:0] ? memory_54 : _GEN_571; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_573 = 8'h37 == _ramWord_T_1[7:0] ? memory_55 : _GEN_572; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_574 = 8'h38 == _ramWord_T_1[7:0] ? memory_56 : _GEN_573; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_575 = 8'h39 == _ramWord_T_1[7:0] ? memory_57 : _GEN_574; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_576 = 8'h3a == _ramWord_T_1[7:0] ? memory_58 : _GEN_575; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_577 = 8'h3b == _ramWord_T_1[7:0] ? memory_59 : _GEN_576; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_578 = 8'h3c == _ramWord_T_1[7:0] ? memory_60 : _GEN_577; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_579 = 8'h3d == _ramWord_T_1[7:0] ? memory_61 : _GEN_578; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_580 = 8'h3e == _ramWord_T_1[7:0] ? memory_62 : _GEN_579; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_581 = 8'h3f == _ramWord_T_1[7:0] ? memory_63 : _GEN_580; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_582 = 8'h40 == _ramWord_T_1[7:0] ? memory_64 : _GEN_581; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_583 = 8'h41 == _ramWord_T_1[7:0] ? memory_65 : _GEN_582; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_584 = 8'h42 == _ramWord_T_1[7:0] ? memory_66 : _GEN_583; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_585 = 8'h43 == _ramWord_T_1[7:0] ? memory_67 : _GEN_584; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_586 = 8'h44 == _ramWord_T_1[7:0] ? memory_68 : _GEN_585; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_587 = 8'h45 == _ramWord_T_1[7:0] ? memory_69 : _GEN_586; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_588 = 8'h46 == _ramWord_T_1[7:0] ? memory_70 : _GEN_587; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_589 = 8'h47 == _ramWord_T_1[7:0] ? memory_71 : _GEN_588; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_590 = 8'h48 == _ramWord_T_1[7:0] ? memory_72 : _GEN_589; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_591 = 8'h49 == _ramWord_T_1[7:0] ? memory_73 : _GEN_590; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_592 = 8'h4a == _ramWord_T_1[7:0] ? memory_74 : _GEN_591; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_593 = 8'h4b == _ramWord_T_1[7:0] ? memory_75 : _GEN_592; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_594 = 8'h4c == _ramWord_T_1[7:0] ? memory_76 : _GEN_593; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_595 = 8'h4d == _ramWord_T_1[7:0] ? memory_77 : _GEN_594; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_596 = 8'h4e == _ramWord_T_1[7:0] ? memory_78 : _GEN_595; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_597 = 8'h4f == _ramWord_T_1[7:0] ? memory_79 : _GEN_596; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_598 = 8'h50 == _ramWord_T_1[7:0] ? memory_80 : _GEN_597; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_599 = 8'h51 == _ramWord_T_1[7:0] ? memory_81 : _GEN_598; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_600 = 8'h52 == _ramWord_T_1[7:0] ? memory_82 : _GEN_599; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_601 = 8'h53 == _ramWord_T_1[7:0] ? memory_83 : _GEN_600; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_602 = 8'h54 == _ramWord_T_1[7:0] ? memory_84 : _GEN_601; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_603 = 8'h55 == _ramWord_T_1[7:0] ? memory_85 : _GEN_602; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_604 = 8'h56 == _ramWord_T_1[7:0] ? memory_86 : _GEN_603; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_605 = 8'h57 == _ramWord_T_1[7:0] ? memory_87 : _GEN_604; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_606 = 8'h58 == _ramWord_T_1[7:0] ? memory_88 : _GEN_605; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_607 = 8'h59 == _ramWord_T_1[7:0] ? memory_89 : _GEN_606; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_608 = 8'h5a == _ramWord_T_1[7:0] ? memory_90 : _GEN_607; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_609 = 8'h5b == _ramWord_T_1[7:0] ? memory_91 : _GEN_608; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_610 = 8'h5c == _ramWord_T_1[7:0] ? memory_92 : _GEN_609; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_611 = 8'h5d == _ramWord_T_1[7:0] ? memory_93 : _GEN_610; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_612 = 8'h5e == _ramWord_T_1[7:0] ? memory_94 : _GEN_611; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_613 = 8'h5f == _ramWord_T_1[7:0] ? memory_95 : _GEN_612; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_614 = 8'h60 == _ramWord_T_1[7:0] ? memory_96 : _GEN_613; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_615 = 8'h61 == _ramWord_T_1[7:0] ? memory_97 : _GEN_614; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_616 = 8'h62 == _ramWord_T_1[7:0] ? memory_98 : _GEN_615; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_617 = 8'h63 == _ramWord_T_1[7:0] ? memory_99 : _GEN_616; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_618 = 8'h64 == _ramWord_T_1[7:0] ? memory_100 : _GEN_617; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_619 = 8'h65 == _ramWord_T_1[7:0] ? memory_101 : _GEN_618; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_620 = 8'h66 == _ramWord_T_1[7:0] ? memory_102 : _GEN_619; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_621 = 8'h67 == _ramWord_T_1[7:0] ? memory_103 : _GEN_620; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_622 = 8'h68 == _ramWord_T_1[7:0] ? memory_104 : _GEN_621; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_623 = 8'h69 == _ramWord_T_1[7:0] ? memory_105 : _GEN_622; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_624 = 8'h6a == _ramWord_T_1[7:0] ? memory_106 : _GEN_623; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_625 = 8'h6b == _ramWord_T_1[7:0] ? memory_107 : _GEN_624; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_626 = 8'h6c == _ramWord_T_1[7:0] ? memory_108 : _GEN_625; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_627 = 8'h6d == _ramWord_T_1[7:0] ? memory_109 : _GEN_626; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_628 = 8'h6e == _ramWord_T_1[7:0] ? memory_110 : _GEN_627; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_629 = 8'h6f == _ramWord_T_1[7:0] ? memory_111 : _GEN_628; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_630 = 8'h70 == _ramWord_T_1[7:0] ? memory_112 : _GEN_629; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_631 = 8'h71 == _ramWord_T_1[7:0] ? memory_113 : _GEN_630; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_632 = 8'h72 == _ramWord_T_1[7:0] ? memory_114 : _GEN_631; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_633 = 8'h73 == _ramWord_T_1[7:0] ? memory_115 : _GEN_632; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_634 = 8'h74 == _ramWord_T_1[7:0] ? memory_116 : _GEN_633; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_635 = 8'h75 == _ramWord_T_1[7:0] ? memory_117 : _GEN_634; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_636 = 8'h76 == _ramWord_T_1[7:0] ? memory_118 : _GEN_635; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_637 = 8'h77 == _ramWord_T_1[7:0] ? memory_119 : _GEN_636; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_638 = 8'h78 == _ramWord_T_1[7:0] ? memory_120 : _GEN_637; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_639 = 8'h79 == _ramWord_T_1[7:0] ? memory_121 : _GEN_638; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_640 = 8'h7a == _ramWord_T_1[7:0] ? memory_122 : _GEN_639; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_641 = 8'h7b == _ramWord_T_1[7:0] ? memory_123 : _GEN_640; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_642 = 8'h7c == _ramWord_T_1[7:0] ? memory_124 : _GEN_641; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_643 = 8'h7d == _ramWord_T_1[7:0] ? memory_125 : _GEN_642; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_644 = 8'h7e == _ramWord_T_1[7:0] ? memory_126 : _GEN_643; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_645 = 8'h7f == _ramWord_T_1[7:0] ? memory_127 : _GEN_644; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_646 = 8'h80 == _ramWord_T_1[7:0] ? memory_128 : _GEN_645; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_647 = 8'h81 == _ramWord_T_1[7:0] ? memory_129 : _GEN_646; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_648 = 8'h82 == _ramWord_T_1[7:0] ? memory_130 : _GEN_647; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_649 = 8'h83 == _ramWord_T_1[7:0] ? memory_131 : _GEN_648; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_650 = 8'h84 == _ramWord_T_1[7:0] ? memory_132 : _GEN_649; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_651 = 8'h85 == _ramWord_T_1[7:0] ? memory_133 : _GEN_650; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_652 = 8'h86 == _ramWord_T_1[7:0] ? memory_134 : _GEN_651; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_653 = 8'h87 == _ramWord_T_1[7:0] ? memory_135 : _GEN_652; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_654 = 8'h88 == _ramWord_T_1[7:0] ? memory_136 : _GEN_653; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_655 = 8'h89 == _ramWord_T_1[7:0] ? memory_137 : _GEN_654; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_656 = 8'h8a == _ramWord_T_1[7:0] ? memory_138 : _GEN_655; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_657 = 8'h8b == _ramWord_T_1[7:0] ? memory_139 : _GEN_656; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_658 = 8'h8c == _ramWord_T_1[7:0] ? memory_140 : _GEN_657; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_659 = 8'h8d == _ramWord_T_1[7:0] ? memory_141 : _GEN_658; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_660 = 8'h8e == _ramWord_T_1[7:0] ? memory_142 : _GEN_659; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_661 = 8'h8f == _ramWord_T_1[7:0] ? memory_143 : _GEN_660; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_662 = 8'h90 == _ramWord_T_1[7:0] ? memory_144 : _GEN_661; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_663 = 8'h91 == _ramWord_T_1[7:0] ? memory_145 : _GEN_662; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_664 = 8'h92 == _ramWord_T_1[7:0] ? memory_146 : _GEN_663; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_665 = 8'h93 == _ramWord_T_1[7:0] ? memory_147 : _GEN_664; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_666 = 8'h94 == _ramWord_T_1[7:0] ? memory_148 : _GEN_665; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_667 = 8'h95 == _ramWord_T_1[7:0] ? memory_149 : _GEN_666; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_668 = 8'h96 == _ramWord_T_1[7:0] ? memory_150 : _GEN_667; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_669 = 8'h97 == _ramWord_T_1[7:0] ? memory_151 : _GEN_668; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_670 = 8'h98 == _ramWord_T_1[7:0] ? memory_152 : _GEN_669; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_671 = 8'h99 == _ramWord_T_1[7:0] ? memory_153 : _GEN_670; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_672 = 8'h9a == _ramWord_T_1[7:0] ? memory_154 : _GEN_671; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_673 = 8'h9b == _ramWord_T_1[7:0] ? memory_155 : _GEN_672; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_674 = 8'h9c == _ramWord_T_1[7:0] ? memory_156 : _GEN_673; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_675 = 8'h9d == _ramWord_T_1[7:0] ? memory_157 : _GEN_674; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_676 = 8'h9e == _ramWord_T_1[7:0] ? memory_158 : _GEN_675; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_677 = 8'h9f == _ramWord_T_1[7:0] ? memory_159 : _GEN_676; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_678 = 8'ha0 == _ramWord_T_1[7:0] ? memory_160 : _GEN_677; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_679 = 8'ha1 == _ramWord_T_1[7:0] ? memory_161 : _GEN_678; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_680 = 8'ha2 == _ramWord_T_1[7:0] ? memory_162 : _GEN_679; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_681 = 8'ha3 == _ramWord_T_1[7:0] ? memory_163 : _GEN_680; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_682 = 8'ha4 == _ramWord_T_1[7:0] ? memory_164 : _GEN_681; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_683 = 8'ha5 == _ramWord_T_1[7:0] ? memory_165 : _GEN_682; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_684 = 8'ha6 == _ramWord_T_1[7:0] ? memory_166 : _GEN_683; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_685 = 8'ha7 == _ramWord_T_1[7:0] ? memory_167 : _GEN_684; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_686 = 8'ha8 == _ramWord_T_1[7:0] ? memory_168 : _GEN_685; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_687 = 8'ha9 == _ramWord_T_1[7:0] ? memory_169 : _GEN_686; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_688 = 8'haa == _ramWord_T_1[7:0] ? memory_170 : _GEN_687; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_689 = 8'hab == _ramWord_T_1[7:0] ? memory_171 : _GEN_688; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_690 = 8'hac == _ramWord_T_1[7:0] ? memory_172 : _GEN_689; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_691 = 8'had == _ramWord_T_1[7:0] ? memory_173 : _GEN_690; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_692 = 8'hae == _ramWord_T_1[7:0] ? memory_174 : _GEN_691; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_693 = 8'haf == _ramWord_T_1[7:0] ? memory_175 : _GEN_692; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_694 = 8'hb0 == _ramWord_T_1[7:0] ? memory_176 : _GEN_693; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_695 = 8'hb1 == _ramWord_T_1[7:0] ? memory_177 : _GEN_694; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_696 = 8'hb2 == _ramWord_T_1[7:0] ? memory_178 : _GEN_695; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_697 = 8'hb3 == _ramWord_T_1[7:0] ? memory_179 : _GEN_696; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_698 = 8'hb4 == _ramWord_T_1[7:0] ? memory_180 : _GEN_697; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_699 = 8'hb5 == _ramWord_T_1[7:0] ? memory_181 : _GEN_698; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_700 = 8'hb6 == _ramWord_T_1[7:0] ? memory_182 : _GEN_699; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_701 = 8'hb7 == _ramWord_T_1[7:0] ? memory_183 : _GEN_700; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_702 = 8'hb8 == _ramWord_T_1[7:0] ? memory_184 : _GEN_701; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_703 = 8'hb9 == _ramWord_T_1[7:0] ? memory_185 : _GEN_702; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_704 = 8'hba == _ramWord_T_1[7:0] ? memory_186 : _GEN_703; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_705 = 8'hbb == _ramWord_T_1[7:0] ? memory_187 : _GEN_704; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_706 = 8'hbc == _ramWord_T_1[7:0] ? memory_188 : _GEN_705; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_707 = 8'hbd == _ramWord_T_1[7:0] ? memory_189 : _GEN_706; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_708 = 8'hbe == _ramWord_T_1[7:0] ? memory_190 : _GEN_707; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_709 = 8'hbf == _ramWord_T_1[7:0] ? memory_191 : _GEN_708; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_710 = 8'hc0 == _ramWord_T_1[7:0] ? memory_192 : _GEN_709; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_711 = 8'hc1 == _ramWord_T_1[7:0] ? memory_193 : _GEN_710; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_712 = 8'hc2 == _ramWord_T_1[7:0] ? memory_194 : _GEN_711; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_713 = 8'hc3 == _ramWord_T_1[7:0] ? memory_195 : _GEN_712; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_714 = 8'hc4 == _ramWord_T_1[7:0] ? memory_196 : _GEN_713; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_715 = 8'hc5 == _ramWord_T_1[7:0] ? memory_197 : _GEN_714; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_716 = 8'hc6 == _ramWord_T_1[7:0] ? memory_198 : _GEN_715; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_717 = 8'hc7 == _ramWord_T_1[7:0] ? memory_199 : _GEN_716; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_718 = 8'hc8 == _ramWord_T_1[7:0] ? memory_200 : _GEN_717; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_719 = 8'hc9 == _ramWord_T_1[7:0] ? memory_201 : _GEN_718; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_720 = 8'hca == _ramWord_T_1[7:0] ? memory_202 : _GEN_719; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_721 = 8'hcb == _ramWord_T_1[7:0] ? memory_203 : _GEN_720; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_722 = 8'hcc == _ramWord_T_1[7:0] ? memory_204 : _GEN_721; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_723 = 8'hcd == _ramWord_T_1[7:0] ? memory_205 : _GEN_722; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_724 = 8'hce == _ramWord_T_1[7:0] ? memory_206 : _GEN_723; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_725 = 8'hcf == _ramWord_T_1[7:0] ? memory_207 : _GEN_724; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_726 = 8'hd0 == _ramWord_T_1[7:0] ? memory_208 : _GEN_725; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_727 = 8'hd1 == _ramWord_T_1[7:0] ? memory_209 : _GEN_726; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_728 = 8'hd2 == _ramWord_T_1[7:0] ? memory_210 : _GEN_727; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_729 = 8'hd3 == _ramWord_T_1[7:0] ? memory_211 : _GEN_728; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_730 = 8'hd4 == _ramWord_T_1[7:0] ? memory_212 : _GEN_729; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_731 = 8'hd5 == _ramWord_T_1[7:0] ? memory_213 : _GEN_730; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_732 = 8'hd6 == _ramWord_T_1[7:0] ? memory_214 : _GEN_731; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_733 = 8'hd7 == _ramWord_T_1[7:0] ? memory_215 : _GEN_732; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_734 = 8'hd8 == _ramWord_T_1[7:0] ? memory_216 : _GEN_733; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_735 = 8'hd9 == _ramWord_T_1[7:0] ? memory_217 : _GEN_734; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_736 = 8'hda == _ramWord_T_1[7:0] ? memory_218 : _GEN_735; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_737 = 8'hdb == _ramWord_T_1[7:0] ? memory_219 : _GEN_736; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_738 = 8'hdc == _ramWord_T_1[7:0] ? memory_220 : _GEN_737; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_739 = 8'hdd == _ramWord_T_1[7:0] ? memory_221 : _GEN_738; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_740 = 8'hde == _ramWord_T_1[7:0] ? memory_222 : _GEN_739; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_741 = 8'hdf == _ramWord_T_1[7:0] ? memory_223 : _GEN_740; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_742 = 8'he0 == _ramWord_T_1[7:0] ? memory_224 : _GEN_741; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_743 = 8'he1 == _ramWord_T_1[7:0] ? memory_225 : _GEN_742; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_744 = 8'he2 == _ramWord_T_1[7:0] ? memory_226 : _GEN_743; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_745 = 8'he3 == _ramWord_T_1[7:0] ? memory_227 : _GEN_744; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_746 = 8'he4 == _ramWord_T_1[7:0] ? memory_228 : _GEN_745; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_747 = 8'he5 == _ramWord_T_1[7:0] ? memory_229 : _GEN_746; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_748 = 8'he6 == _ramWord_T_1[7:0] ? memory_230 : _GEN_747; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_749 = 8'he7 == _ramWord_T_1[7:0] ? memory_231 : _GEN_748; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_750 = 8'he8 == _ramWord_T_1[7:0] ? memory_232 : _GEN_749; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_751 = 8'he9 == _ramWord_T_1[7:0] ? memory_233 : _GEN_750; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_752 = 8'hea == _ramWord_T_1[7:0] ? memory_234 : _GEN_751; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_753 = 8'heb == _ramWord_T_1[7:0] ? memory_235 : _GEN_752; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_754 = 8'hec == _ramWord_T_1[7:0] ? memory_236 : _GEN_753; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_755 = 8'hed == _ramWord_T_1[7:0] ? memory_237 : _GEN_754; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_756 = 8'hee == _ramWord_T_1[7:0] ? memory_238 : _GEN_755; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_757 = 8'hef == _ramWord_T_1[7:0] ? memory_239 : _GEN_756; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_758 = 8'hf0 == _ramWord_T_1[7:0] ? memory_240 : _GEN_757; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_759 = 8'hf1 == _ramWord_T_1[7:0] ? memory_241 : _GEN_758; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_760 = 8'hf2 == _ramWord_T_1[7:0] ? memory_242 : _GEN_759; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_761 = 8'hf3 == _ramWord_T_1[7:0] ? memory_243 : _GEN_760; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_762 = 8'hf4 == _ramWord_T_1[7:0] ? memory_244 : _GEN_761; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_763 = 8'hf5 == _ramWord_T_1[7:0] ? memory_245 : _GEN_762; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_764 = 8'hf6 == _ramWord_T_1[7:0] ? memory_246 : _GEN_763; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_765 = 8'hf7 == _ramWord_T_1[7:0] ? memory_247 : _GEN_764; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_766 = 8'hf8 == _ramWord_T_1[7:0] ? memory_248 : _GEN_765; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_767 = 8'hf9 == _ramWord_T_1[7:0] ? memory_249 : _GEN_766; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_768 = 8'hfa == _ramWord_T_1[7:0] ? memory_250 : _GEN_767; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_769 = 8'hfb == _ramWord_T_1[7:0] ? memory_251 : _GEN_768; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_770 = 8'hfc == _ramWord_T_1[7:0] ? memory_252 : _GEN_769; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_771 = 8'hfd == _ramWord_T_1[7:0] ? memory_253 : _GEN_770; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_772 = 8'hfe == _ramWord_T_1[7:0] ? memory_254 : _GEN_771; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_773 = 8'hff == _ramWord_T_1[7:0] ? memory_255 : _GEN_772; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_775 = 8'h1 == _ramWord_T_4[7:0] ? memory_1 : memory_0; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_776 = 8'h2 == _ramWord_T_4[7:0] ? memory_2 : _GEN_775; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_777 = 8'h3 == _ramWord_T_4[7:0] ? memory_3 : _GEN_776; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_778 = 8'h4 == _ramWord_T_4[7:0] ? memory_4 : _GEN_777; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_779 = 8'h5 == _ramWord_T_4[7:0] ? memory_5 : _GEN_778; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_780 = 8'h6 == _ramWord_T_4[7:0] ? memory_6 : _GEN_779; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_781 = 8'h7 == _ramWord_T_4[7:0] ? memory_7 : _GEN_780; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_782 = 8'h8 == _ramWord_T_4[7:0] ? memory_8 : _GEN_781; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_783 = 8'h9 == _ramWord_T_4[7:0] ? memory_9 : _GEN_782; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_784 = 8'ha == _ramWord_T_4[7:0] ? memory_10 : _GEN_783; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_785 = 8'hb == _ramWord_T_4[7:0] ? memory_11 : _GEN_784; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_786 = 8'hc == _ramWord_T_4[7:0] ? memory_12 : _GEN_785; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_787 = 8'hd == _ramWord_T_4[7:0] ? memory_13 : _GEN_786; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_788 = 8'he == _ramWord_T_4[7:0] ? memory_14 : _GEN_787; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_789 = 8'hf == _ramWord_T_4[7:0] ? memory_15 : _GEN_788; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_790 = 8'h10 == _ramWord_T_4[7:0] ? memory_16 : _GEN_789; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_791 = 8'h11 == _ramWord_T_4[7:0] ? memory_17 : _GEN_790; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_792 = 8'h12 == _ramWord_T_4[7:0] ? memory_18 : _GEN_791; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_793 = 8'h13 == _ramWord_T_4[7:0] ? memory_19 : _GEN_792; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_794 = 8'h14 == _ramWord_T_4[7:0] ? memory_20 : _GEN_793; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_795 = 8'h15 == _ramWord_T_4[7:0] ? memory_21 : _GEN_794; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_796 = 8'h16 == _ramWord_T_4[7:0] ? memory_22 : _GEN_795; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_797 = 8'h17 == _ramWord_T_4[7:0] ? memory_23 : _GEN_796; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_798 = 8'h18 == _ramWord_T_4[7:0] ? memory_24 : _GEN_797; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_799 = 8'h19 == _ramWord_T_4[7:0] ? memory_25 : _GEN_798; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_800 = 8'h1a == _ramWord_T_4[7:0] ? memory_26 : _GEN_799; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_801 = 8'h1b == _ramWord_T_4[7:0] ? memory_27 : _GEN_800; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_802 = 8'h1c == _ramWord_T_4[7:0] ? memory_28 : _GEN_801; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_803 = 8'h1d == _ramWord_T_4[7:0] ? memory_29 : _GEN_802; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_804 = 8'h1e == _ramWord_T_4[7:0] ? memory_30 : _GEN_803; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_805 = 8'h1f == _ramWord_T_4[7:0] ? memory_31 : _GEN_804; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_806 = 8'h20 == _ramWord_T_4[7:0] ? memory_32 : _GEN_805; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_807 = 8'h21 == _ramWord_T_4[7:0] ? memory_33 : _GEN_806; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_808 = 8'h22 == _ramWord_T_4[7:0] ? memory_34 : _GEN_807; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_809 = 8'h23 == _ramWord_T_4[7:0] ? memory_35 : _GEN_808; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_810 = 8'h24 == _ramWord_T_4[7:0] ? memory_36 : _GEN_809; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_811 = 8'h25 == _ramWord_T_4[7:0] ? memory_37 : _GEN_810; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_812 = 8'h26 == _ramWord_T_4[7:0] ? memory_38 : _GEN_811; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_813 = 8'h27 == _ramWord_T_4[7:0] ? memory_39 : _GEN_812; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_814 = 8'h28 == _ramWord_T_4[7:0] ? memory_40 : _GEN_813; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_815 = 8'h29 == _ramWord_T_4[7:0] ? memory_41 : _GEN_814; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_816 = 8'h2a == _ramWord_T_4[7:0] ? memory_42 : _GEN_815; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_817 = 8'h2b == _ramWord_T_4[7:0] ? memory_43 : _GEN_816; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_818 = 8'h2c == _ramWord_T_4[7:0] ? memory_44 : _GEN_817; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_819 = 8'h2d == _ramWord_T_4[7:0] ? memory_45 : _GEN_818; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_820 = 8'h2e == _ramWord_T_4[7:0] ? memory_46 : _GEN_819; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_821 = 8'h2f == _ramWord_T_4[7:0] ? memory_47 : _GEN_820; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_822 = 8'h30 == _ramWord_T_4[7:0] ? memory_48 : _GEN_821; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_823 = 8'h31 == _ramWord_T_4[7:0] ? memory_49 : _GEN_822; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_824 = 8'h32 == _ramWord_T_4[7:0] ? memory_50 : _GEN_823; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_825 = 8'h33 == _ramWord_T_4[7:0] ? memory_51 : _GEN_824; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_826 = 8'h34 == _ramWord_T_4[7:0] ? memory_52 : _GEN_825; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_827 = 8'h35 == _ramWord_T_4[7:0] ? memory_53 : _GEN_826; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_828 = 8'h36 == _ramWord_T_4[7:0] ? memory_54 : _GEN_827; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_829 = 8'h37 == _ramWord_T_4[7:0] ? memory_55 : _GEN_828; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_830 = 8'h38 == _ramWord_T_4[7:0] ? memory_56 : _GEN_829; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_831 = 8'h39 == _ramWord_T_4[7:0] ? memory_57 : _GEN_830; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_832 = 8'h3a == _ramWord_T_4[7:0] ? memory_58 : _GEN_831; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_833 = 8'h3b == _ramWord_T_4[7:0] ? memory_59 : _GEN_832; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_834 = 8'h3c == _ramWord_T_4[7:0] ? memory_60 : _GEN_833; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_835 = 8'h3d == _ramWord_T_4[7:0] ? memory_61 : _GEN_834; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_836 = 8'h3e == _ramWord_T_4[7:0] ? memory_62 : _GEN_835; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_837 = 8'h3f == _ramWord_T_4[7:0] ? memory_63 : _GEN_836; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_838 = 8'h40 == _ramWord_T_4[7:0] ? memory_64 : _GEN_837; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_839 = 8'h41 == _ramWord_T_4[7:0] ? memory_65 : _GEN_838; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_840 = 8'h42 == _ramWord_T_4[7:0] ? memory_66 : _GEN_839; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_841 = 8'h43 == _ramWord_T_4[7:0] ? memory_67 : _GEN_840; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_842 = 8'h44 == _ramWord_T_4[7:0] ? memory_68 : _GEN_841; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_843 = 8'h45 == _ramWord_T_4[7:0] ? memory_69 : _GEN_842; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_844 = 8'h46 == _ramWord_T_4[7:0] ? memory_70 : _GEN_843; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_845 = 8'h47 == _ramWord_T_4[7:0] ? memory_71 : _GEN_844; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_846 = 8'h48 == _ramWord_T_4[7:0] ? memory_72 : _GEN_845; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_847 = 8'h49 == _ramWord_T_4[7:0] ? memory_73 : _GEN_846; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_848 = 8'h4a == _ramWord_T_4[7:0] ? memory_74 : _GEN_847; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_849 = 8'h4b == _ramWord_T_4[7:0] ? memory_75 : _GEN_848; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_850 = 8'h4c == _ramWord_T_4[7:0] ? memory_76 : _GEN_849; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_851 = 8'h4d == _ramWord_T_4[7:0] ? memory_77 : _GEN_850; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_852 = 8'h4e == _ramWord_T_4[7:0] ? memory_78 : _GEN_851; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_853 = 8'h4f == _ramWord_T_4[7:0] ? memory_79 : _GEN_852; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_854 = 8'h50 == _ramWord_T_4[7:0] ? memory_80 : _GEN_853; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_855 = 8'h51 == _ramWord_T_4[7:0] ? memory_81 : _GEN_854; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_856 = 8'h52 == _ramWord_T_4[7:0] ? memory_82 : _GEN_855; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_857 = 8'h53 == _ramWord_T_4[7:0] ? memory_83 : _GEN_856; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_858 = 8'h54 == _ramWord_T_4[7:0] ? memory_84 : _GEN_857; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_859 = 8'h55 == _ramWord_T_4[7:0] ? memory_85 : _GEN_858; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_860 = 8'h56 == _ramWord_T_4[7:0] ? memory_86 : _GEN_859; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_861 = 8'h57 == _ramWord_T_4[7:0] ? memory_87 : _GEN_860; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_862 = 8'h58 == _ramWord_T_4[7:0] ? memory_88 : _GEN_861; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_863 = 8'h59 == _ramWord_T_4[7:0] ? memory_89 : _GEN_862; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_864 = 8'h5a == _ramWord_T_4[7:0] ? memory_90 : _GEN_863; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_865 = 8'h5b == _ramWord_T_4[7:0] ? memory_91 : _GEN_864; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_866 = 8'h5c == _ramWord_T_4[7:0] ? memory_92 : _GEN_865; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_867 = 8'h5d == _ramWord_T_4[7:0] ? memory_93 : _GEN_866; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_868 = 8'h5e == _ramWord_T_4[7:0] ? memory_94 : _GEN_867; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_869 = 8'h5f == _ramWord_T_4[7:0] ? memory_95 : _GEN_868; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_870 = 8'h60 == _ramWord_T_4[7:0] ? memory_96 : _GEN_869; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_871 = 8'h61 == _ramWord_T_4[7:0] ? memory_97 : _GEN_870; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_872 = 8'h62 == _ramWord_T_4[7:0] ? memory_98 : _GEN_871; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_873 = 8'h63 == _ramWord_T_4[7:0] ? memory_99 : _GEN_872; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_874 = 8'h64 == _ramWord_T_4[7:0] ? memory_100 : _GEN_873; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_875 = 8'h65 == _ramWord_T_4[7:0] ? memory_101 : _GEN_874; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_876 = 8'h66 == _ramWord_T_4[7:0] ? memory_102 : _GEN_875; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_877 = 8'h67 == _ramWord_T_4[7:0] ? memory_103 : _GEN_876; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_878 = 8'h68 == _ramWord_T_4[7:0] ? memory_104 : _GEN_877; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_879 = 8'h69 == _ramWord_T_4[7:0] ? memory_105 : _GEN_878; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_880 = 8'h6a == _ramWord_T_4[7:0] ? memory_106 : _GEN_879; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_881 = 8'h6b == _ramWord_T_4[7:0] ? memory_107 : _GEN_880; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_882 = 8'h6c == _ramWord_T_4[7:0] ? memory_108 : _GEN_881; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_883 = 8'h6d == _ramWord_T_4[7:0] ? memory_109 : _GEN_882; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_884 = 8'h6e == _ramWord_T_4[7:0] ? memory_110 : _GEN_883; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_885 = 8'h6f == _ramWord_T_4[7:0] ? memory_111 : _GEN_884; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_886 = 8'h70 == _ramWord_T_4[7:0] ? memory_112 : _GEN_885; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_887 = 8'h71 == _ramWord_T_4[7:0] ? memory_113 : _GEN_886; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_888 = 8'h72 == _ramWord_T_4[7:0] ? memory_114 : _GEN_887; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_889 = 8'h73 == _ramWord_T_4[7:0] ? memory_115 : _GEN_888; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_890 = 8'h74 == _ramWord_T_4[7:0] ? memory_116 : _GEN_889; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_891 = 8'h75 == _ramWord_T_4[7:0] ? memory_117 : _GEN_890; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_892 = 8'h76 == _ramWord_T_4[7:0] ? memory_118 : _GEN_891; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_893 = 8'h77 == _ramWord_T_4[7:0] ? memory_119 : _GEN_892; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_894 = 8'h78 == _ramWord_T_4[7:0] ? memory_120 : _GEN_893; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_895 = 8'h79 == _ramWord_T_4[7:0] ? memory_121 : _GEN_894; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_896 = 8'h7a == _ramWord_T_4[7:0] ? memory_122 : _GEN_895; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_897 = 8'h7b == _ramWord_T_4[7:0] ? memory_123 : _GEN_896; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_898 = 8'h7c == _ramWord_T_4[7:0] ? memory_124 : _GEN_897; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_899 = 8'h7d == _ramWord_T_4[7:0] ? memory_125 : _GEN_898; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_900 = 8'h7e == _ramWord_T_4[7:0] ? memory_126 : _GEN_899; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_901 = 8'h7f == _ramWord_T_4[7:0] ? memory_127 : _GEN_900; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_902 = 8'h80 == _ramWord_T_4[7:0] ? memory_128 : _GEN_901; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_903 = 8'h81 == _ramWord_T_4[7:0] ? memory_129 : _GEN_902; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_904 = 8'h82 == _ramWord_T_4[7:0] ? memory_130 : _GEN_903; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_905 = 8'h83 == _ramWord_T_4[7:0] ? memory_131 : _GEN_904; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_906 = 8'h84 == _ramWord_T_4[7:0] ? memory_132 : _GEN_905; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_907 = 8'h85 == _ramWord_T_4[7:0] ? memory_133 : _GEN_906; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_908 = 8'h86 == _ramWord_T_4[7:0] ? memory_134 : _GEN_907; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_909 = 8'h87 == _ramWord_T_4[7:0] ? memory_135 : _GEN_908; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_910 = 8'h88 == _ramWord_T_4[7:0] ? memory_136 : _GEN_909; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_911 = 8'h89 == _ramWord_T_4[7:0] ? memory_137 : _GEN_910; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_912 = 8'h8a == _ramWord_T_4[7:0] ? memory_138 : _GEN_911; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_913 = 8'h8b == _ramWord_T_4[7:0] ? memory_139 : _GEN_912; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_914 = 8'h8c == _ramWord_T_4[7:0] ? memory_140 : _GEN_913; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_915 = 8'h8d == _ramWord_T_4[7:0] ? memory_141 : _GEN_914; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_916 = 8'h8e == _ramWord_T_4[7:0] ? memory_142 : _GEN_915; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_917 = 8'h8f == _ramWord_T_4[7:0] ? memory_143 : _GEN_916; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_918 = 8'h90 == _ramWord_T_4[7:0] ? memory_144 : _GEN_917; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_919 = 8'h91 == _ramWord_T_4[7:0] ? memory_145 : _GEN_918; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_920 = 8'h92 == _ramWord_T_4[7:0] ? memory_146 : _GEN_919; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_921 = 8'h93 == _ramWord_T_4[7:0] ? memory_147 : _GEN_920; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_922 = 8'h94 == _ramWord_T_4[7:0] ? memory_148 : _GEN_921; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_923 = 8'h95 == _ramWord_T_4[7:0] ? memory_149 : _GEN_922; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_924 = 8'h96 == _ramWord_T_4[7:0] ? memory_150 : _GEN_923; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_925 = 8'h97 == _ramWord_T_4[7:0] ? memory_151 : _GEN_924; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_926 = 8'h98 == _ramWord_T_4[7:0] ? memory_152 : _GEN_925; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_927 = 8'h99 == _ramWord_T_4[7:0] ? memory_153 : _GEN_926; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_928 = 8'h9a == _ramWord_T_4[7:0] ? memory_154 : _GEN_927; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_929 = 8'h9b == _ramWord_T_4[7:0] ? memory_155 : _GEN_928; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_930 = 8'h9c == _ramWord_T_4[7:0] ? memory_156 : _GEN_929; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_931 = 8'h9d == _ramWord_T_4[7:0] ? memory_157 : _GEN_930; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_932 = 8'h9e == _ramWord_T_4[7:0] ? memory_158 : _GEN_931; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_933 = 8'h9f == _ramWord_T_4[7:0] ? memory_159 : _GEN_932; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_934 = 8'ha0 == _ramWord_T_4[7:0] ? memory_160 : _GEN_933; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_935 = 8'ha1 == _ramWord_T_4[7:0] ? memory_161 : _GEN_934; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_936 = 8'ha2 == _ramWord_T_4[7:0] ? memory_162 : _GEN_935; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_937 = 8'ha3 == _ramWord_T_4[7:0] ? memory_163 : _GEN_936; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_938 = 8'ha4 == _ramWord_T_4[7:0] ? memory_164 : _GEN_937; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_939 = 8'ha5 == _ramWord_T_4[7:0] ? memory_165 : _GEN_938; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_940 = 8'ha6 == _ramWord_T_4[7:0] ? memory_166 : _GEN_939; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_941 = 8'ha7 == _ramWord_T_4[7:0] ? memory_167 : _GEN_940; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_942 = 8'ha8 == _ramWord_T_4[7:0] ? memory_168 : _GEN_941; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_943 = 8'ha9 == _ramWord_T_4[7:0] ? memory_169 : _GEN_942; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_944 = 8'haa == _ramWord_T_4[7:0] ? memory_170 : _GEN_943; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_945 = 8'hab == _ramWord_T_4[7:0] ? memory_171 : _GEN_944; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_946 = 8'hac == _ramWord_T_4[7:0] ? memory_172 : _GEN_945; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_947 = 8'had == _ramWord_T_4[7:0] ? memory_173 : _GEN_946; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_948 = 8'hae == _ramWord_T_4[7:0] ? memory_174 : _GEN_947; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_949 = 8'haf == _ramWord_T_4[7:0] ? memory_175 : _GEN_948; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_950 = 8'hb0 == _ramWord_T_4[7:0] ? memory_176 : _GEN_949; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_951 = 8'hb1 == _ramWord_T_4[7:0] ? memory_177 : _GEN_950; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_952 = 8'hb2 == _ramWord_T_4[7:0] ? memory_178 : _GEN_951; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_953 = 8'hb3 == _ramWord_T_4[7:0] ? memory_179 : _GEN_952; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_954 = 8'hb4 == _ramWord_T_4[7:0] ? memory_180 : _GEN_953; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_955 = 8'hb5 == _ramWord_T_4[7:0] ? memory_181 : _GEN_954; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_956 = 8'hb6 == _ramWord_T_4[7:0] ? memory_182 : _GEN_955; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_957 = 8'hb7 == _ramWord_T_4[7:0] ? memory_183 : _GEN_956; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_958 = 8'hb8 == _ramWord_T_4[7:0] ? memory_184 : _GEN_957; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_959 = 8'hb9 == _ramWord_T_4[7:0] ? memory_185 : _GEN_958; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_960 = 8'hba == _ramWord_T_4[7:0] ? memory_186 : _GEN_959; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_961 = 8'hbb == _ramWord_T_4[7:0] ? memory_187 : _GEN_960; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_962 = 8'hbc == _ramWord_T_4[7:0] ? memory_188 : _GEN_961; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_963 = 8'hbd == _ramWord_T_4[7:0] ? memory_189 : _GEN_962; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_964 = 8'hbe == _ramWord_T_4[7:0] ? memory_190 : _GEN_963; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_965 = 8'hbf == _ramWord_T_4[7:0] ? memory_191 : _GEN_964; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_966 = 8'hc0 == _ramWord_T_4[7:0] ? memory_192 : _GEN_965; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_967 = 8'hc1 == _ramWord_T_4[7:0] ? memory_193 : _GEN_966; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_968 = 8'hc2 == _ramWord_T_4[7:0] ? memory_194 : _GEN_967; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_969 = 8'hc3 == _ramWord_T_4[7:0] ? memory_195 : _GEN_968; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_970 = 8'hc4 == _ramWord_T_4[7:0] ? memory_196 : _GEN_969; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_971 = 8'hc5 == _ramWord_T_4[7:0] ? memory_197 : _GEN_970; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_972 = 8'hc6 == _ramWord_T_4[7:0] ? memory_198 : _GEN_971; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_973 = 8'hc7 == _ramWord_T_4[7:0] ? memory_199 : _GEN_972; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_974 = 8'hc8 == _ramWord_T_4[7:0] ? memory_200 : _GEN_973; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_975 = 8'hc9 == _ramWord_T_4[7:0] ? memory_201 : _GEN_974; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_976 = 8'hca == _ramWord_T_4[7:0] ? memory_202 : _GEN_975; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_977 = 8'hcb == _ramWord_T_4[7:0] ? memory_203 : _GEN_976; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_978 = 8'hcc == _ramWord_T_4[7:0] ? memory_204 : _GEN_977; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_979 = 8'hcd == _ramWord_T_4[7:0] ? memory_205 : _GEN_978; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_980 = 8'hce == _ramWord_T_4[7:0] ? memory_206 : _GEN_979; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_981 = 8'hcf == _ramWord_T_4[7:0] ? memory_207 : _GEN_980; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_982 = 8'hd0 == _ramWord_T_4[7:0] ? memory_208 : _GEN_981; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_983 = 8'hd1 == _ramWord_T_4[7:0] ? memory_209 : _GEN_982; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_984 = 8'hd2 == _ramWord_T_4[7:0] ? memory_210 : _GEN_983; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_985 = 8'hd3 == _ramWord_T_4[7:0] ? memory_211 : _GEN_984; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_986 = 8'hd4 == _ramWord_T_4[7:0] ? memory_212 : _GEN_985; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_987 = 8'hd5 == _ramWord_T_4[7:0] ? memory_213 : _GEN_986; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_988 = 8'hd6 == _ramWord_T_4[7:0] ? memory_214 : _GEN_987; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_989 = 8'hd7 == _ramWord_T_4[7:0] ? memory_215 : _GEN_988; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_990 = 8'hd8 == _ramWord_T_4[7:0] ? memory_216 : _GEN_989; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_991 = 8'hd9 == _ramWord_T_4[7:0] ? memory_217 : _GEN_990; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_992 = 8'hda == _ramWord_T_4[7:0] ? memory_218 : _GEN_991; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_993 = 8'hdb == _ramWord_T_4[7:0] ? memory_219 : _GEN_992; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_994 = 8'hdc == _ramWord_T_4[7:0] ? memory_220 : _GEN_993; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_995 = 8'hdd == _ramWord_T_4[7:0] ? memory_221 : _GEN_994; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_996 = 8'hde == _ramWord_T_4[7:0] ? memory_222 : _GEN_995; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_997 = 8'hdf == _ramWord_T_4[7:0] ? memory_223 : _GEN_996; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_998 = 8'he0 == _ramWord_T_4[7:0] ? memory_224 : _GEN_997; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_999 = 8'he1 == _ramWord_T_4[7:0] ? memory_225 : _GEN_998; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_1000 = 8'he2 == _ramWord_T_4[7:0] ? memory_226 : _GEN_999; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_1001 = 8'he3 == _ramWord_T_4[7:0] ? memory_227 : _GEN_1000; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_1002 = 8'he4 == _ramWord_T_4[7:0] ? memory_228 : _GEN_1001; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_1003 = 8'he5 == _ramWord_T_4[7:0] ? memory_229 : _GEN_1002; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_1004 = 8'he6 == _ramWord_T_4[7:0] ? memory_230 : _GEN_1003; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_1005 = 8'he7 == _ramWord_T_4[7:0] ? memory_231 : _GEN_1004; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_1006 = 8'he8 == _ramWord_T_4[7:0] ? memory_232 : _GEN_1005; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_1007 = 8'he9 == _ramWord_T_4[7:0] ? memory_233 : _GEN_1006; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_1008 = 8'hea == _ramWord_T_4[7:0] ? memory_234 : _GEN_1007; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_1009 = 8'heb == _ramWord_T_4[7:0] ? memory_235 : _GEN_1008; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_1010 = 8'hec == _ramWord_T_4[7:0] ? memory_236 : _GEN_1009; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_1011 = 8'hed == _ramWord_T_4[7:0] ? memory_237 : _GEN_1010; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_1012 = 8'hee == _ramWord_T_4[7:0] ? memory_238 : _GEN_1011; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_1013 = 8'hef == _ramWord_T_4[7:0] ? memory_239 : _GEN_1012; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_1014 = 8'hf0 == _ramWord_T_4[7:0] ? memory_240 : _GEN_1013; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_1015 = 8'hf1 == _ramWord_T_4[7:0] ? memory_241 : _GEN_1014; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_1016 = 8'hf2 == _ramWord_T_4[7:0] ? memory_242 : _GEN_1015; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_1017 = 8'hf3 == _ramWord_T_4[7:0] ? memory_243 : _GEN_1016; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_1018 = 8'hf4 == _ramWord_T_4[7:0] ? memory_244 : _GEN_1017; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_1019 = 8'hf5 == _ramWord_T_4[7:0] ? memory_245 : _GEN_1018; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_1020 = 8'hf6 == _ramWord_T_4[7:0] ? memory_246 : _GEN_1019; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_1021 = 8'hf7 == _ramWord_T_4[7:0] ? memory_247 : _GEN_1020; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_1022 = 8'hf8 == _ramWord_T_4[7:0] ? memory_248 : _GEN_1021; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_1023 = 8'hf9 == _ramWord_T_4[7:0] ? memory_249 : _GEN_1022; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_1024 = 8'hfa == _ramWord_T_4[7:0] ? memory_250 : _GEN_1023; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_1025 = 8'hfb == _ramWord_T_4[7:0] ? memory_251 : _GEN_1024; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_1026 = 8'hfc == _ramWord_T_4[7:0] ? memory_252 : _GEN_1025; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_1027 = 8'hfd == _ramWord_T_4[7:0] ? memory_253 : _GEN_1026; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_1028 = 8'hfe == _ramWord_T_4[7:0] ? memory_254 : _GEN_1027; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [7:0] _GEN_1029 = 8'hff == _ramWord_T_4[7:0] ? memory_255 : _GEN_1028; // @[src/main/scala/SingleCycleCPU.scala 49:{17,17}]
  wire [31:0] ramWord = {_GEN_773,_GEN_1029,_GEN_261,_GEN_517}; // @[src/main/scala/SingleCycleCPU.scala 49:17]
  wire [31:0] _byteValue_T_1 = {24'h0,ramWord[7:0]}; // @[src/main/scala/SingleCycleCPU.scala 50:43]
  wire [23:0] _byteValue_T_3 = ramWord[7] ? 24'hffffff : 24'h0; // @[src/main/scala/SingleCycleCPU.scala 50:76]
  wire [31:0] _byteValue_T_5 = {_byteValue_T_3,ramWord[7:0]}; // @[src/main/scala/SingleCycleCPU.scala 50:71]
  wire [31:0] byteValue = dec_io_loadUnsigned ? _byteValue_T_1 : _byteValue_T_5; // @[src/main/scala/SingleCycleCPU.scala 50:19]
  wire [31:0] _halfValue_T_1 = {16'h0,ramWord[15:0]}; // @[src/main/scala/SingleCycleCPU.scala 51:43]
  wire [15:0] _halfValue_T_3 = ramWord[15] ? 16'hffff : 16'h0; // @[src/main/scala/SingleCycleCPU.scala 51:77]
  wire [31:0] _halfValue_T_5 = {_halfValue_T_3,ramWord[15:0]}; // @[src/main/scala/SingleCycleCPU.scala 51:72]
  wire [31:0] halfValue = dec_io_loadUnsigned ? _halfValue_T_1 : _halfValue_T_5; // @[src/main/scala/SingleCycleCPU.scala 51:19]
  wire [31:0] _ramRead_T_2 = _bytes_T_1 ? halfValue : ramWord; // @[src/main/scala/SingleCycleCPU.scala 52:42]
  wire [31:0] ramRead = _bytes_T ? byteValue : _ramRead_T_2; // @[src/main/scala/SingleCycleCPU.scala 52:17]
  wire [31:0] _ioRead_T_3 = _mmio_T_1 ? {{16'd0}, led} : display; // @[src/main/scala/SingleCycleCPU.scala 53:95]
  wire [31:0] _ioRead_T_4 = _mmio_T_3 ? {{27'd0}, io_buttons} : _ioRead_T_3; // @[src/main/scala/SingleCycleCPU.scala 53:56]
  wire [31:0] ioRead = _mmio_T ? {{16'd0}, io_switches} : _ioRead_T_4; // @[src/main/scala/SingleCycleCPU.scala 53:16]
  wire [31:0] load = inRAM ? ramRead : ioRead; // @[src/main/scala/SingleCycleCPU.scala 54:14]
  wire [31:0] _GEN_1030 = 2'h3 == dec_io_control[13:12] ? dec_io_immediate : alu_io_result; // @[src/main/scala/SingleCycleCPU.scala 55:20 56:31 57:59]
  wire [31:0] _GEN_1031 = 2'h2 == dec_io_control[13:12] ? _nextPC_T_1 : _GEN_1030; // @[src/main/scala/SingleCycleCPU.scala 56:31 57:31]
  wire [2:0] _fault_T_1 = dec_io_control[5] ? 3'h6 : 3'h5; // @[src/main/scala/SingleCycleCPU.scala 64:46]
  wire [3:0] _fault_T_3 = dec_io_control[5] ? 4'h8 : 4'h7; // @[src/main/scala/SingleCycleCPU.scala 65:56]
  wire [3:0] _fault_T_5 = dec_io_trapKind == 2'h2 ? 4'h1 : 4'h9; // @[src/main/scala/SingleCycleCPU.scala 66:42]
  wire [3:0] _GEN_1033 = dec_io_control[10] ? _fault_T_5 : 4'h0; // @[src/main/scala/SingleCycleCPU.scala 59:23 66:{31,37}]
  wire [3:0] _GEN_1034 = memRequest & ~inRAM & ~ioAllowed ? _fault_T_3 : _GEN_1033; // @[src/main/scala/SingleCycleCPU.scala 65:{45,51}]
  wire [31:0] _GEN_1035 = memRequest & ~inRAM & ~ioAllowed ? alu_io_result : 32'h0; // @[src/main/scala/SingleCycleCPU.scala 65:45 59:55 65:89]
  wire [3:0] _GEN_1036 = memRequest & misaligned ? {{1'd0}, _fault_T_1} : _GEN_1034; // @[src/main/scala/SingleCycleCPU.scala 64:{35,41}]
  wire [31:0] _GEN_1037 = memRequest & misaligned ? alu_io_result : _GEN_1035; // @[src/main/scala/SingleCycleCPU.scala 64:{35,79}]
  wire [3:0] _GEN_1038 = taken & nextPC[1:0] != 2'h0 ? 4'h4 : _GEN_1036; // @[src/main/scala/SingleCycleCPU.scala 63:{37,43}]
  wire [31:0] _GEN_1039 = taken & nextPC[1:0] != 2'h0 ? nextPC : _GEN_1037; // @[src/main/scala/SingleCycleCPU.scala 63:{37,54}]
  wire [3:0] _GEN_1040 = ~dec_io_valid ? 4'h2 : _GEN_1038; // @[src/main/scala/SingleCycleCPU.scala 62:{26,32}]
  wire [31:0] _GEN_1041 = ~dec_io_valid ? io_instruction : _GEN_1039; // @[src/main/scala/SingleCycleCPU.scala 62:{26,43}]
  wire [3:0] _GEN_1042 = ~io_instructionValid ? 4'h3 : _GEN_1040; // @[src/main/scala/SingleCycleCPU.scala 61:{33,39}]
  wire [31:0] _GEN_1043 = ~io_instructionValid ? pc : _GEN_1041; // @[src/main/scala/SingleCycleCPU.scala 61:{33,50}]
  wire [3:0] fault = pc[1:0] != 2'h0 ? 4'h4 : _GEN_1042; // @[src/main/scala/SingleCycleCPU.scala 60:{21,27}]
  wire [31:0] value = pc[1:0] != 2'h0 ? pc : _GEN_1043; // @[src/main/scala/SingleCycleCPU.scala 60:{21,38}]
  wire  _commit_T_4 = ~halted; // @[src/main/scala/SingleCycleCPU.scala 67:51]
  wire  commit = io_step & ~io_clear & ~reset & ~halted & fault == 4'h0; // @[src/main/scala/SingleCycleCPU.scala 67:58]
  wire [31:0] _retired_T_1 = retired + 32'h1; // @[src/main/scala/SingleCycleCPU.scala 75:31]
  wire [7:0] _GEN_1046 = 8'h0 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_0; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1047 = 8'h1 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_1; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1048 = 8'h2 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_2; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1049 = 8'h3 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_3; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1050 = 8'h4 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_4; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1051 = 8'h5 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_5; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1052 = 8'h6 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_6; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1053 = 8'h7 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_7; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1054 = 8'h8 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_8; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1055 = 8'h9 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_9; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1056 = 8'ha == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_10; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1057 = 8'hb == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_11; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1058 = 8'hc == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_12; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1059 = 8'hd == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_13; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1060 = 8'he == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_14; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1061 = 8'hf == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_15; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1062 = 8'h10 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_16; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1063 = 8'h11 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_17; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1064 = 8'h12 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_18; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1065 = 8'h13 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_19; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1066 = 8'h14 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_20; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1067 = 8'h15 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_21; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1068 = 8'h16 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_22; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1069 = 8'h17 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_23; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1070 = 8'h18 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_24; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1071 = 8'h19 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_25; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1072 = 8'h1a == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_26; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1073 = 8'h1b == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_27; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1074 = 8'h1c == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_28; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1075 = 8'h1d == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_29; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1076 = 8'h1e == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_30; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1077 = 8'h1f == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_31; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1078 = 8'h20 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_32; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1079 = 8'h21 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_33; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1080 = 8'h22 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_34; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1081 = 8'h23 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_35; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1082 = 8'h24 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_36; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1083 = 8'h25 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_37; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1084 = 8'h26 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_38; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1085 = 8'h27 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_39; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1086 = 8'h28 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_40; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1087 = 8'h29 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_41; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1088 = 8'h2a == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_42; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1089 = 8'h2b == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_43; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1090 = 8'h2c == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_44; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1091 = 8'h2d == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_45; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1092 = 8'h2e == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_46; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1093 = 8'h2f == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_47; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1094 = 8'h30 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_48; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1095 = 8'h31 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_49; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1096 = 8'h32 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_50; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1097 = 8'h33 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_51; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1098 = 8'h34 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_52; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1099 = 8'h35 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_53; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1100 = 8'h36 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_54; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1101 = 8'h37 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_55; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1102 = 8'h38 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_56; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1103 = 8'h39 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_57; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1104 = 8'h3a == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_58; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1105 = 8'h3b == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_59; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1106 = 8'h3c == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_60; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1107 = 8'h3d == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_61; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1108 = 8'h3e == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_62; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1109 = 8'h3f == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_63; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1110 = 8'h40 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_64; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1111 = 8'h41 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_65; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1112 = 8'h42 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_66; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1113 = 8'h43 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_67; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1114 = 8'h44 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_68; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1115 = 8'h45 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_69; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1116 = 8'h46 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_70; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1117 = 8'h47 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_71; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1118 = 8'h48 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_72; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1119 = 8'h49 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_73; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1120 = 8'h4a == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_74; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1121 = 8'h4b == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_75; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1122 = 8'h4c == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_76; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1123 = 8'h4d == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_77; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1124 = 8'h4e == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_78; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1125 = 8'h4f == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_79; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1126 = 8'h50 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_80; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1127 = 8'h51 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_81; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1128 = 8'h52 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_82; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1129 = 8'h53 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_83; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1130 = 8'h54 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_84; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1131 = 8'h55 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_85; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1132 = 8'h56 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_86; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1133 = 8'h57 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_87; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1134 = 8'h58 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_88; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1135 = 8'h59 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_89; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1136 = 8'h5a == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_90; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1137 = 8'h5b == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_91; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1138 = 8'h5c == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_92; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1139 = 8'h5d == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_93; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1140 = 8'h5e == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_94; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1141 = 8'h5f == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_95; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1142 = 8'h60 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_96; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1143 = 8'h61 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_97; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1144 = 8'h62 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_98; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1145 = 8'h63 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_99; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1146 = 8'h64 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_100; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1147 = 8'h65 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_101; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1148 = 8'h66 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_102; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1149 = 8'h67 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_103; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1150 = 8'h68 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_104; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1151 = 8'h69 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_105; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1152 = 8'h6a == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_106; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1153 = 8'h6b == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_107; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1154 = 8'h6c == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_108; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1155 = 8'h6d == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_109; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1156 = 8'h6e == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_110; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1157 = 8'h6f == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_111; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1158 = 8'h70 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_112; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1159 = 8'h71 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_113; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1160 = 8'h72 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_114; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1161 = 8'h73 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_115; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1162 = 8'h74 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_116; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1163 = 8'h75 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_117; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1164 = 8'h76 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_118; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1165 = 8'h77 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_119; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1166 = 8'h78 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_120; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1167 = 8'h79 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_121; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1168 = 8'h7a == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_122; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1169 = 8'h7b == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_123; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1170 = 8'h7c == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_124; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1171 = 8'h7d == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_125; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1172 = 8'h7e == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_126; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1173 = 8'h7f == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_127; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1174 = 8'h80 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_128; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1175 = 8'h81 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_129; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1176 = 8'h82 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_130; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1177 = 8'h83 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_131; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1178 = 8'h84 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_132; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1179 = 8'h85 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_133; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1180 = 8'h86 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_134; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1181 = 8'h87 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_135; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1182 = 8'h88 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_136; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1183 = 8'h89 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_137; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1184 = 8'h8a == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_138; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1185 = 8'h8b == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_139; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1186 = 8'h8c == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_140; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1187 = 8'h8d == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_141; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1188 = 8'h8e == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_142; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1189 = 8'h8f == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_143; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1190 = 8'h90 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_144; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1191 = 8'h91 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_145; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1192 = 8'h92 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_146; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1193 = 8'h93 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_147; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1194 = 8'h94 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_148; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1195 = 8'h95 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_149; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1196 = 8'h96 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_150; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1197 = 8'h97 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_151; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1198 = 8'h98 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_152; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1199 = 8'h99 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_153; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1200 = 8'h9a == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_154; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1201 = 8'h9b == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_155; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1202 = 8'h9c == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_156; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1203 = 8'h9d == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_157; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1204 = 8'h9e == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_158; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1205 = 8'h9f == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_159; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1206 = 8'ha0 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_160; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1207 = 8'ha1 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_161; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1208 = 8'ha2 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_162; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1209 = 8'ha3 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_163; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1210 = 8'ha4 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_164; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1211 = 8'ha5 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_165; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1212 = 8'ha6 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_166; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1213 = 8'ha7 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_167; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1214 = 8'ha8 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_168; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1215 = 8'ha9 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_169; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1216 = 8'haa == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_170; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1217 = 8'hab == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_171; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1218 = 8'hac == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_172; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1219 = 8'had == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_173; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1220 = 8'hae == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_174; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1221 = 8'haf == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_175; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1222 = 8'hb0 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_176; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1223 = 8'hb1 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_177; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1224 = 8'hb2 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_178; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1225 = 8'hb3 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_179; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1226 = 8'hb4 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_180; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1227 = 8'hb5 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_181; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1228 = 8'hb6 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_182; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1229 = 8'hb7 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_183; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1230 = 8'hb8 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_184; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1231 = 8'hb9 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_185; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1232 = 8'hba == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_186; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1233 = 8'hbb == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_187; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1234 = 8'hbc == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_188; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1235 = 8'hbd == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_189; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1236 = 8'hbe == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_190; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1237 = 8'hbf == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_191; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1238 = 8'hc0 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_192; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1239 = 8'hc1 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_193; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1240 = 8'hc2 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_194; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1241 = 8'hc3 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_195; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1242 = 8'hc4 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_196; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1243 = 8'hc5 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_197; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1244 = 8'hc6 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_198; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1245 = 8'hc7 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_199; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1246 = 8'hc8 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_200; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1247 = 8'hc9 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_201; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1248 = 8'hca == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_202; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1249 = 8'hcb == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_203; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1250 = 8'hcc == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_204; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1251 = 8'hcd == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_205; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1252 = 8'hce == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_206; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1253 = 8'hcf == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_207; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1254 = 8'hd0 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_208; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1255 = 8'hd1 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_209; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1256 = 8'hd2 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_210; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1257 = 8'hd3 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_211; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1258 = 8'hd4 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_212; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1259 = 8'hd5 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_213; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1260 = 8'hd6 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_214; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1261 = 8'hd7 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_215; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1262 = 8'hd8 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_216; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1263 = 8'hd9 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_217; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1264 = 8'hda == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_218; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1265 = 8'hdb == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_219; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1266 = 8'hdc == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_220; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1267 = 8'hdd == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_221; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1268 = 8'hde == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_222; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1269 = 8'hdf == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_223; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1270 = 8'he0 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_224; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1271 = 8'he1 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_225; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1272 = 8'he2 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_226; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1273 = 8'he3 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_227; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1274 = 8'he4 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_228; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1275 = 8'he5 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_229; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1276 = 8'he6 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_230; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1277 = 8'he7 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_231; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1278 = 8'he8 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_232; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1279 = 8'he9 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_233; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1280 = 8'hea == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_234; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1281 = 8'heb == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_235; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1282 = 8'hec == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_236; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1283 = 8'hed == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_237; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1284 = 8'hee == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_238; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1285 = 8'hef == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_239; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1286 = 8'hf0 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_240; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1287 = 8'hf1 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_241; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1288 = 8'hf2 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_242; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1289 = 8'hf3 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_243; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1290 = 8'hf4 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_244; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1291 = 8'hf5 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_245; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1292 = 8'hf6 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_246; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1293 = 8'hf7 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_247; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1294 = 8'hf8 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_248; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1295 = 8'hf9 == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_249; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1296 = 8'hfa == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_250; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1297 = 8'hfb == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_251; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1298 = 8'hfc == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_252; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1299 = 8'hfd == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_253; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1300 = 8'hfe == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_254; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1301 = 8'hff == _ramWord_T_9[7:0] ? rf_io_rawB[7:0] : memory_255; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:{77,77}]
  wire [7:0] _GEN_1302 = 3'h0 < bytes ? _GEN_1046 : memory_0; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1303 = 3'h0 < bytes ? _GEN_1047 : memory_1; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1304 = 3'h0 < bytes ? _GEN_1048 : memory_2; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1305 = 3'h0 < bytes ? _GEN_1049 : memory_3; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1306 = 3'h0 < bytes ? _GEN_1050 : memory_4; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1307 = 3'h0 < bytes ? _GEN_1051 : memory_5; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1308 = 3'h0 < bytes ? _GEN_1052 : memory_6; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1309 = 3'h0 < bytes ? _GEN_1053 : memory_7; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1310 = 3'h0 < bytes ? _GEN_1054 : memory_8; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1311 = 3'h0 < bytes ? _GEN_1055 : memory_9; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1312 = 3'h0 < bytes ? _GEN_1056 : memory_10; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1313 = 3'h0 < bytes ? _GEN_1057 : memory_11; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1314 = 3'h0 < bytes ? _GEN_1058 : memory_12; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1315 = 3'h0 < bytes ? _GEN_1059 : memory_13; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1316 = 3'h0 < bytes ? _GEN_1060 : memory_14; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1317 = 3'h0 < bytes ? _GEN_1061 : memory_15; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1318 = 3'h0 < bytes ? _GEN_1062 : memory_16; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1319 = 3'h0 < bytes ? _GEN_1063 : memory_17; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1320 = 3'h0 < bytes ? _GEN_1064 : memory_18; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1321 = 3'h0 < bytes ? _GEN_1065 : memory_19; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1322 = 3'h0 < bytes ? _GEN_1066 : memory_20; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1323 = 3'h0 < bytes ? _GEN_1067 : memory_21; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1324 = 3'h0 < bytes ? _GEN_1068 : memory_22; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1325 = 3'h0 < bytes ? _GEN_1069 : memory_23; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1326 = 3'h0 < bytes ? _GEN_1070 : memory_24; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1327 = 3'h0 < bytes ? _GEN_1071 : memory_25; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1328 = 3'h0 < bytes ? _GEN_1072 : memory_26; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1329 = 3'h0 < bytes ? _GEN_1073 : memory_27; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1330 = 3'h0 < bytes ? _GEN_1074 : memory_28; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1331 = 3'h0 < bytes ? _GEN_1075 : memory_29; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1332 = 3'h0 < bytes ? _GEN_1076 : memory_30; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1333 = 3'h0 < bytes ? _GEN_1077 : memory_31; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1334 = 3'h0 < bytes ? _GEN_1078 : memory_32; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1335 = 3'h0 < bytes ? _GEN_1079 : memory_33; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1336 = 3'h0 < bytes ? _GEN_1080 : memory_34; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1337 = 3'h0 < bytes ? _GEN_1081 : memory_35; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1338 = 3'h0 < bytes ? _GEN_1082 : memory_36; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1339 = 3'h0 < bytes ? _GEN_1083 : memory_37; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1340 = 3'h0 < bytes ? _GEN_1084 : memory_38; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1341 = 3'h0 < bytes ? _GEN_1085 : memory_39; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1342 = 3'h0 < bytes ? _GEN_1086 : memory_40; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1343 = 3'h0 < bytes ? _GEN_1087 : memory_41; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1344 = 3'h0 < bytes ? _GEN_1088 : memory_42; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1345 = 3'h0 < bytes ? _GEN_1089 : memory_43; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1346 = 3'h0 < bytes ? _GEN_1090 : memory_44; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1347 = 3'h0 < bytes ? _GEN_1091 : memory_45; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1348 = 3'h0 < bytes ? _GEN_1092 : memory_46; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1349 = 3'h0 < bytes ? _GEN_1093 : memory_47; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1350 = 3'h0 < bytes ? _GEN_1094 : memory_48; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1351 = 3'h0 < bytes ? _GEN_1095 : memory_49; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1352 = 3'h0 < bytes ? _GEN_1096 : memory_50; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1353 = 3'h0 < bytes ? _GEN_1097 : memory_51; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1354 = 3'h0 < bytes ? _GEN_1098 : memory_52; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1355 = 3'h0 < bytes ? _GEN_1099 : memory_53; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1356 = 3'h0 < bytes ? _GEN_1100 : memory_54; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1357 = 3'h0 < bytes ? _GEN_1101 : memory_55; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1358 = 3'h0 < bytes ? _GEN_1102 : memory_56; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1359 = 3'h0 < bytes ? _GEN_1103 : memory_57; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1360 = 3'h0 < bytes ? _GEN_1104 : memory_58; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1361 = 3'h0 < bytes ? _GEN_1105 : memory_59; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1362 = 3'h0 < bytes ? _GEN_1106 : memory_60; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1363 = 3'h0 < bytes ? _GEN_1107 : memory_61; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1364 = 3'h0 < bytes ? _GEN_1108 : memory_62; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1365 = 3'h0 < bytes ? _GEN_1109 : memory_63; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1366 = 3'h0 < bytes ? _GEN_1110 : memory_64; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1367 = 3'h0 < bytes ? _GEN_1111 : memory_65; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1368 = 3'h0 < bytes ? _GEN_1112 : memory_66; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1369 = 3'h0 < bytes ? _GEN_1113 : memory_67; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1370 = 3'h0 < bytes ? _GEN_1114 : memory_68; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1371 = 3'h0 < bytes ? _GEN_1115 : memory_69; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1372 = 3'h0 < bytes ? _GEN_1116 : memory_70; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1373 = 3'h0 < bytes ? _GEN_1117 : memory_71; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1374 = 3'h0 < bytes ? _GEN_1118 : memory_72; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1375 = 3'h0 < bytes ? _GEN_1119 : memory_73; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1376 = 3'h0 < bytes ? _GEN_1120 : memory_74; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1377 = 3'h0 < bytes ? _GEN_1121 : memory_75; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1378 = 3'h0 < bytes ? _GEN_1122 : memory_76; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1379 = 3'h0 < bytes ? _GEN_1123 : memory_77; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1380 = 3'h0 < bytes ? _GEN_1124 : memory_78; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1381 = 3'h0 < bytes ? _GEN_1125 : memory_79; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1382 = 3'h0 < bytes ? _GEN_1126 : memory_80; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1383 = 3'h0 < bytes ? _GEN_1127 : memory_81; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1384 = 3'h0 < bytes ? _GEN_1128 : memory_82; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1385 = 3'h0 < bytes ? _GEN_1129 : memory_83; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1386 = 3'h0 < bytes ? _GEN_1130 : memory_84; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1387 = 3'h0 < bytes ? _GEN_1131 : memory_85; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1388 = 3'h0 < bytes ? _GEN_1132 : memory_86; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1389 = 3'h0 < bytes ? _GEN_1133 : memory_87; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1390 = 3'h0 < bytes ? _GEN_1134 : memory_88; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1391 = 3'h0 < bytes ? _GEN_1135 : memory_89; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1392 = 3'h0 < bytes ? _GEN_1136 : memory_90; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1393 = 3'h0 < bytes ? _GEN_1137 : memory_91; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1394 = 3'h0 < bytes ? _GEN_1138 : memory_92; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1395 = 3'h0 < bytes ? _GEN_1139 : memory_93; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1396 = 3'h0 < bytes ? _GEN_1140 : memory_94; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1397 = 3'h0 < bytes ? _GEN_1141 : memory_95; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1398 = 3'h0 < bytes ? _GEN_1142 : memory_96; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1399 = 3'h0 < bytes ? _GEN_1143 : memory_97; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1400 = 3'h0 < bytes ? _GEN_1144 : memory_98; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1401 = 3'h0 < bytes ? _GEN_1145 : memory_99; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1402 = 3'h0 < bytes ? _GEN_1146 : memory_100; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1403 = 3'h0 < bytes ? _GEN_1147 : memory_101; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1404 = 3'h0 < bytes ? _GEN_1148 : memory_102; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1405 = 3'h0 < bytes ? _GEN_1149 : memory_103; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1406 = 3'h0 < bytes ? _GEN_1150 : memory_104; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1407 = 3'h0 < bytes ? _GEN_1151 : memory_105; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1408 = 3'h0 < bytes ? _GEN_1152 : memory_106; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1409 = 3'h0 < bytes ? _GEN_1153 : memory_107; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1410 = 3'h0 < bytes ? _GEN_1154 : memory_108; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1411 = 3'h0 < bytes ? _GEN_1155 : memory_109; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1412 = 3'h0 < bytes ? _GEN_1156 : memory_110; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1413 = 3'h0 < bytes ? _GEN_1157 : memory_111; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1414 = 3'h0 < bytes ? _GEN_1158 : memory_112; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1415 = 3'h0 < bytes ? _GEN_1159 : memory_113; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1416 = 3'h0 < bytes ? _GEN_1160 : memory_114; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1417 = 3'h0 < bytes ? _GEN_1161 : memory_115; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1418 = 3'h0 < bytes ? _GEN_1162 : memory_116; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1419 = 3'h0 < bytes ? _GEN_1163 : memory_117; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1420 = 3'h0 < bytes ? _GEN_1164 : memory_118; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1421 = 3'h0 < bytes ? _GEN_1165 : memory_119; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1422 = 3'h0 < bytes ? _GEN_1166 : memory_120; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1423 = 3'h0 < bytes ? _GEN_1167 : memory_121; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1424 = 3'h0 < bytes ? _GEN_1168 : memory_122; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1425 = 3'h0 < bytes ? _GEN_1169 : memory_123; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1426 = 3'h0 < bytes ? _GEN_1170 : memory_124; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1427 = 3'h0 < bytes ? _GEN_1171 : memory_125; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1428 = 3'h0 < bytes ? _GEN_1172 : memory_126; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1429 = 3'h0 < bytes ? _GEN_1173 : memory_127; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1430 = 3'h0 < bytes ? _GEN_1174 : memory_128; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1431 = 3'h0 < bytes ? _GEN_1175 : memory_129; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1432 = 3'h0 < bytes ? _GEN_1176 : memory_130; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1433 = 3'h0 < bytes ? _GEN_1177 : memory_131; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1434 = 3'h0 < bytes ? _GEN_1178 : memory_132; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1435 = 3'h0 < bytes ? _GEN_1179 : memory_133; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1436 = 3'h0 < bytes ? _GEN_1180 : memory_134; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1437 = 3'h0 < bytes ? _GEN_1181 : memory_135; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1438 = 3'h0 < bytes ? _GEN_1182 : memory_136; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1439 = 3'h0 < bytes ? _GEN_1183 : memory_137; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1440 = 3'h0 < bytes ? _GEN_1184 : memory_138; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1441 = 3'h0 < bytes ? _GEN_1185 : memory_139; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1442 = 3'h0 < bytes ? _GEN_1186 : memory_140; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1443 = 3'h0 < bytes ? _GEN_1187 : memory_141; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1444 = 3'h0 < bytes ? _GEN_1188 : memory_142; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1445 = 3'h0 < bytes ? _GEN_1189 : memory_143; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1446 = 3'h0 < bytes ? _GEN_1190 : memory_144; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1447 = 3'h0 < bytes ? _GEN_1191 : memory_145; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1448 = 3'h0 < bytes ? _GEN_1192 : memory_146; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1449 = 3'h0 < bytes ? _GEN_1193 : memory_147; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1450 = 3'h0 < bytes ? _GEN_1194 : memory_148; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1451 = 3'h0 < bytes ? _GEN_1195 : memory_149; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1452 = 3'h0 < bytes ? _GEN_1196 : memory_150; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1453 = 3'h0 < bytes ? _GEN_1197 : memory_151; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1454 = 3'h0 < bytes ? _GEN_1198 : memory_152; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1455 = 3'h0 < bytes ? _GEN_1199 : memory_153; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1456 = 3'h0 < bytes ? _GEN_1200 : memory_154; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1457 = 3'h0 < bytes ? _GEN_1201 : memory_155; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1458 = 3'h0 < bytes ? _GEN_1202 : memory_156; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1459 = 3'h0 < bytes ? _GEN_1203 : memory_157; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1460 = 3'h0 < bytes ? _GEN_1204 : memory_158; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1461 = 3'h0 < bytes ? _GEN_1205 : memory_159; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1462 = 3'h0 < bytes ? _GEN_1206 : memory_160; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1463 = 3'h0 < bytes ? _GEN_1207 : memory_161; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1464 = 3'h0 < bytes ? _GEN_1208 : memory_162; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1465 = 3'h0 < bytes ? _GEN_1209 : memory_163; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1466 = 3'h0 < bytes ? _GEN_1210 : memory_164; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1467 = 3'h0 < bytes ? _GEN_1211 : memory_165; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1468 = 3'h0 < bytes ? _GEN_1212 : memory_166; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1469 = 3'h0 < bytes ? _GEN_1213 : memory_167; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1470 = 3'h0 < bytes ? _GEN_1214 : memory_168; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1471 = 3'h0 < bytes ? _GEN_1215 : memory_169; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1472 = 3'h0 < bytes ? _GEN_1216 : memory_170; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1473 = 3'h0 < bytes ? _GEN_1217 : memory_171; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1474 = 3'h0 < bytes ? _GEN_1218 : memory_172; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1475 = 3'h0 < bytes ? _GEN_1219 : memory_173; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1476 = 3'h0 < bytes ? _GEN_1220 : memory_174; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1477 = 3'h0 < bytes ? _GEN_1221 : memory_175; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1478 = 3'h0 < bytes ? _GEN_1222 : memory_176; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1479 = 3'h0 < bytes ? _GEN_1223 : memory_177; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1480 = 3'h0 < bytes ? _GEN_1224 : memory_178; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1481 = 3'h0 < bytes ? _GEN_1225 : memory_179; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1482 = 3'h0 < bytes ? _GEN_1226 : memory_180; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1483 = 3'h0 < bytes ? _GEN_1227 : memory_181; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1484 = 3'h0 < bytes ? _GEN_1228 : memory_182; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1485 = 3'h0 < bytes ? _GEN_1229 : memory_183; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1486 = 3'h0 < bytes ? _GEN_1230 : memory_184; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1487 = 3'h0 < bytes ? _GEN_1231 : memory_185; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1488 = 3'h0 < bytes ? _GEN_1232 : memory_186; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1489 = 3'h0 < bytes ? _GEN_1233 : memory_187; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1490 = 3'h0 < bytes ? _GEN_1234 : memory_188; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1491 = 3'h0 < bytes ? _GEN_1235 : memory_189; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1492 = 3'h0 < bytes ? _GEN_1236 : memory_190; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1493 = 3'h0 < bytes ? _GEN_1237 : memory_191; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1494 = 3'h0 < bytes ? _GEN_1238 : memory_192; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1495 = 3'h0 < bytes ? _GEN_1239 : memory_193; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1496 = 3'h0 < bytes ? _GEN_1240 : memory_194; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1497 = 3'h0 < bytes ? _GEN_1241 : memory_195; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1498 = 3'h0 < bytes ? _GEN_1242 : memory_196; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1499 = 3'h0 < bytes ? _GEN_1243 : memory_197; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1500 = 3'h0 < bytes ? _GEN_1244 : memory_198; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1501 = 3'h0 < bytes ? _GEN_1245 : memory_199; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1502 = 3'h0 < bytes ? _GEN_1246 : memory_200; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1503 = 3'h0 < bytes ? _GEN_1247 : memory_201; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1504 = 3'h0 < bytes ? _GEN_1248 : memory_202; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1505 = 3'h0 < bytes ? _GEN_1249 : memory_203; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1506 = 3'h0 < bytes ? _GEN_1250 : memory_204; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1507 = 3'h0 < bytes ? _GEN_1251 : memory_205; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1508 = 3'h0 < bytes ? _GEN_1252 : memory_206; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1509 = 3'h0 < bytes ? _GEN_1253 : memory_207; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1510 = 3'h0 < bytes ? _GEN_1254 : memory_208; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1511 = 3'h0 < bytes ? _GEN_1255 : memory_209; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1512 = 3'h0 < bytes ? _GEN_1256 : memory_210; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1513 = 3'h0 < bytes ? _GEN_1257 : memory_211; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1514 = 3'h0 < bytes ? _GEN_1258 : memory_212; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1515 = 3'h0 < bytes ? _GEN_1259 : memory_213; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1516 = 3'h0 < bytes ? _GEN_1260 : memory_214; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1517 = 3'h0 < bytes ? _GEN_1261 : memory_215; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1518 = 3'h0 < bytes ? _GEN_1262 : memory_216; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1519 = 3'h0 < bytes ? _GEN_1263 : memory_217; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1520 = 3'h0 < bytes ? _GEN_1264 : memory_218; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1521 = 3'h0 < bytes ? _GEN_1265 : memory_219; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1522 = 3'h0 < bytes ? _GEN_1266 : memory_220; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1523 = 3'h0 < bytes ? _GEN_1267 : memory_221; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1524 = 3'h0 < bytes ? _GEN_1268 : memory_222; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1525 = 3'h0 < bytes ? _GEN_1269 : memory_223; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1526 = 3'h0 < bytes ? _GEN_1270 : memory_224; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1527 = 3'h0 < bytes ? _GEN_1271 : memory_225; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1528 = 3'h0 < bytes ? _GEN_1272 : memory_226; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1529 = 3'h0 < bytes ? _GEN_1273 : memory_227; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1530 = 3'h0 < bytes ? _GEN_1274 : memory_228; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1531 = 3'h0 < bytes ? _GEN_1275 : memory_229; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1532 = 3'h0 < bytes ? _GEN_1276 : memory_230; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1533 = 3'h0 < bytes ? _GEN_1277 : memory_231; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1534 = 3'h0 < bytes ? _GEN_1278 : memory_232; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1535 = 3'h0 < bytes ? _GEN_1279 : memory_233; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1536 = 3'h0 < bytes ? _GEN_1280 : memory_234; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1537 = 3'h0 < bytes ? _GEN_1281 : memory_235; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1538 = 3'h0 < bytes ? _GEN_1282 : memory_236; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1539 = 3'h0 < bytes ? _GEN_1283 : memory_237; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1540 = 3'h0 < bytes ? _GEN_1284 : memory_238; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1541 = 3'h0 < bytes ? _GEN_1285 : memory_239; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1542 = 3'h0 < bytes ? _GEN_1286 : memory_240; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1543 = 3'h0 < bytes ? _GEN_1287 : memory_241; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1544 = 3'h0 < bytes ? _GEN_1288 : memory_242; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1545 = 3'h0 < bytes ? _GEN_1289 : memory_243; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1546 = 3'h0 < bytes ? _GEN_1290 : memory_244; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1547 = 3'h0 < bytes ? _GEN_1291 : memory_245; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1548 = 3'h0 < bytes ? _GEN_1292 : memory_246; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1549 = 3'h0 < bytes ? _GEN_1293 : memory_247; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1550 = 3'h0 < bytes ? _GEN_1294 : memory_248; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1551 = 3'h0 < bytes ? _GEN_1295 : memory_249; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1552 = 3'h0 < bytes ? _GEN_1296 : memory_250; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1553 = 3'h0 < bytes ? _GEN_1297 : memory_251; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1554 = 3'h0 < bytes ? _GEN_1298 : memory_252; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1555 = 3'h0 < bytes ? _GEN_1299 : memory_253; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1556 = 3'h0 < bytes ? _GEN_1300 : memory_254; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1557 = 3'h0 < bytes ? _GEN_1301 : memory_255; // @[src/main/scala/SingleCycleCPU.scala 21:20 77:50]
  wire [7:0] _GEN_1558 = 8'h0 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1302; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1559 = 8'h1 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1303; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1560 = 8'h2 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1304; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1561 = 8'h3 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1305; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1562 = 8'h4 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1306; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1563 = 8'h5 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1307; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1564 = 8'h6 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1308; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1565 = 8'h7 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1309; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1566 = 8'h8 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1310; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1567 = 8'h9 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1311; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1568 = 8'ha == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1312; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1569 = 8'hb == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1313; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1570 = 8'hc == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1314; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1571 = 8'hd == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1315; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1572 = 8'he == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1316; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1573 = 8'hf == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1317; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1574 = 8'h10 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1318; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1575 = 8'h11 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1319; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1576 = 8'h12 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1320; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1577 = 8'h13 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1321; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1578 = 8'h14 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1322; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1579 = 8'h15 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1323; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1580 = 8'h16 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1324; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1581 = 8'h17 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1325; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1582 = 8'h18 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1326; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1583 = 8'h19 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1327; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1584 = 8'h1a == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1328; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1585 = 8'h1b == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1329; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1586 = 8'h1c == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1330; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1587 = 8'h1d == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1331; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1588 = 8'h1e == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1332; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1589 = 8'h1f == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1333; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1590 = 8'h20 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1334; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1591 = 8'h21 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1335; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1592 = 8'h22 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1336; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1593 = 8'h23 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1337; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1594 = 8'h24 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1338; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1595 = 8'h25 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1339; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1596 = 8'h26 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1340; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1597 = 8'h27 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1341; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1598 = 8'h28 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1342; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1599 = 8'h29 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1343; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1600 = 8'h2a == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1344; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1601 = 8'h2b == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1345; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1602 = 8'h2c == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1346; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1603 = 8'h2d == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1347; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1604 = 8'h2e == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1348; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1605 = 8'h2f == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1349; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1606 = 8'h30 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1350; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1607 = 8'h31 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1351; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1608 = 8'h32 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1352; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1609 = 8'h33 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1353; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1610 = 8'h34 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1354; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1611 = 8'h35 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1355; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1612 = 8'h36 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1356; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1613 = 8'h37 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1357; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1614 = 8'h38 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1358; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1615 = 8'h39 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1359; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1616 = 8'h3a == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1360; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1617 = 8'h3b == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1361; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1618 = 8'h3c == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1362; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1619 = 8'h3d == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1363; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1620 = 8'h3e == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1364; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1621 = 8'h3f == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1365; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1622 = 8'h40 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1366; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1623 = 8'h41 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1367; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1624 = 8'h42 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1368; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1625 = 8'h43 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1369; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1626 = 8'h44 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1370; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1627 = 8'h45 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1371; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1628 = 8'h46 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1372; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1629 = 8'h47 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1373; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1630 = 8'h48 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1374; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1631 = 8'h49 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1375; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1632 = 8'h4a == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1376; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1633 = 8'h4b == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1377; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1634 = 8'h4c == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1378; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1635 = 8'h4d == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1379; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1636 = 8'h4e == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1380; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1637 = 8'h4f == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1381; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1638 = 8'h50 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1382; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1639 = 8'h51 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1383; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1640 = 8'h52 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1384; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1641 = 8'h53 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1385; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1642 = 8'h54 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1386; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1643 = 8'h55 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1387; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1644 = 8'h56 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1388; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1645 = 8'h57 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1389; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1646 = 8'h58 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1390; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1647 = 8'h59 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1391; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1648 = 8'h5a == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1392; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1649 = 8'h5b == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1393; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1650 = 8'h5c == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1394; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1651 = 8'h5d == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1395; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1652 = 8'h5e == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1396; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1653 = 8'h5f == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1397; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1654 = 8'h60 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1398; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1655 = 8'h61 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1399; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1656 = 8'h62 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1400; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1657 = 8'h63 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1401; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1658 = 8'h64 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1402; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1659 = 8'h65 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1403; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1660 = 8'h66 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1404; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1661 = 8'h67 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1405; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1662 = 8'h68 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1406; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1663 = 8'h69 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1407; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1664 = 8'h6a == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1408; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1665 = 8'h6b == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1409; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1666 = 8'h6c == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1410; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1667 = 8'h6d == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1411; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1668 = 8'h6e == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1412; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1669 = 8'h6f == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1413; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1670 = 8'h70 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1414; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1671 = 8'h71 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1415; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1672 = 8'h72 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1416; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1673 = 8'h73 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1417; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1674 = 8'h74 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1418; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1675 = 8'h75 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1419; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1676 = 8'h76 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1420; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1677 = 8'h77 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1421; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1678 = 8'h78 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1422; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1679 = 8'h79 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1423; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1680 = 8'h7a == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1424; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1681 = 8'h7b == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1425; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1682 = 8'h7c == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1426; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1683 = 8'h7d == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1427; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1684 = 8'h7e == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1428; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1685 = 8'h7f == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1429; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1686 = 8'h80 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1430; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1687 = 8'h81 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1431; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1688 = 8'h82 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1432; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1689 = 8'h83 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1433; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1690 = 8'h84 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1434; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1691 = 8'h85 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1435; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1692 = 8'h86 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1436; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1693 = 8'h87 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1437; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1694 = 8'h88 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1438; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1695 = 8'h89 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1439; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1696 = 8'h8a == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1440; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1697 = 8'h8b == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1441; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1698 = 8'h8c == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1442; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1699 = 8'h8d == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1443; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1700 = 8'h8e == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1444; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1701 = 8'h8f == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1445; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1702 = 8'h90 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1446; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1703 = 8'h91 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1447; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1704 = 8'h92 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1448; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1705 = 8'h93 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1449; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1706 = 8'h94 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1450; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1707 = 8'h95 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1451; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1708 = 8'h96 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1452; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1709 = 8'h97 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1453; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1710 = 8'h98 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1454; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1711 = 8'h99 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1455; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1712 = 8'h9a == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1456; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1713 = 8'h9b == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1457; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1714 = 8'h9c == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1458; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1715 = 8'h9d == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1459; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1716 = 8'h9e == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1460; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1717 = 8'h9f == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1461; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1718 = 8'ha0 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1462; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1719 = 8'ha1 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1463; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1720 = 8'ha2 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1464; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1721 = 8'ha3 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1465; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1722 = 8'ha4 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1466; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1723 = 8'ha5 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1467; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1724 = 8'ha6 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1468; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1725 = 8'ha7 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1469; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1726 = 8'ha8 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1470; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1727 = 8'ha9 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1471; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1728 = 8'haa == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1472; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1729 = 8'hab == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1473; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1730 = 8'hac == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1474; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1731 = 8'had == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1475; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1732 = 8'hae == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1476; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1733 = 8'haf == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1477; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1734 = 8'hb0 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1478; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1735 = 8'hb1 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1479; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1736 = 8'hb2 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1480; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1737 = 8'hb3 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1481; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1738 = 8'hb4 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1482; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1739 = 8'hb5 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1483; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1740 = 8'hb6 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1484; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1741 = 8'hb7 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1485; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1742 = 8'hb8 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1486; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1743 = 8'hb9 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1487; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1744 = 8'hba == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1488; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1745 = 8'hbb == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1489; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1746 = 8'hbc == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1490; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1747 = 8'hbd == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1491; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1748 = 8'hbe == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1492; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1749 = 8'hbf == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1493; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1750 = 8'hc0 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1494; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1751 = 8'hc1 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1495; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1752 = 8'hc2 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1496; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1753 = 8'hc3 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1497; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1754 = 8'hc4 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1498; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1755 = 8'hc5 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1499; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1756 = 8'hc6 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1500; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1757 = 8'hc7 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1501; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1758 = 8'hc8 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1502; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1759 = 8'hc9 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1503; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1760 = 8'hca == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1504; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1761 = 8'hcb == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1505; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1762 = 8'hcc == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1506; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1763 = 8'hcd == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1507; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1764 = 8'hce == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1508; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1765 = 8'hcf == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1509; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1766 = 8'hd0 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1510; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1767 = 8'hd1 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1511; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1768 = 8'hd2 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1512; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1769 = 8'hd3 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1513; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1770 = 8'hd4 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1514; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1771 = 8'hd5 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1515; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1772 = 8'hd6 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1516; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1773 = 8'hd7 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1517; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1774 = 8'hd8 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1518; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1775 = 8'hd9 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1519; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1776 = 8'hda == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1520; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1777 = 8'hdb == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1521; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1778 = 8'hdc == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1522; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1779 = 8'hdd == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1523; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1780 = 8'hde == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1524; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1781 = 8'hdf == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1525; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1782 = 8'he0 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1526; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1783 = 8'he1 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1527; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1784 = 8'he2 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1528; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1785 = 8'he3 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1529; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1786 = 8'he4 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1530; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1787 = 8'he5 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1531; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1788 = 8'he6 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1532; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1789 = 8'he7 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1533; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1790 = 8'he8 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1534; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1791 = 8'he9 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1535; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1792 = 8'hea == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1536; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1793 = 8'heb == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1537; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1794 = 8'hec == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1538; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1795 = 8'hed == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1539; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1796 = 8'hee == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1540; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1797 = 8'hef == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1541; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1798 = 8'hf0 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1542; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1799 = 8'hf1 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1543; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1800 = 8'hf2 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1544; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1801 = 8'hf3 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1545; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1802 = 8'hf4 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1546; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1803 = 8'hf5 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1547; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1804 = 8'hf6 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1548; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1805 = 8'hf7 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1549; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1806 = 8'hf8 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1550; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1807 = 8'hf9 == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1551; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1808 = 8'hfa == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1552; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1809 = 8'hfb == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1553; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1810 = 8'hfc == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1554; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1811 = 8'hfd == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1555; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1812 = 8'hfe == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1556; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1813 = 8'hff == _ramWord_T_7[7:0] ? rf_io_rawB[15:8] : _GEN_1557; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_1814 = 3'h1 < bytes ? _GEN_1558 : _GEN_1302; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1815 = 3'h1 < bytes ? _GEN_1559 : _GEN_1303; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1816 = 3'h1 < bytes ? _GEN_1560 : _GEN_1304; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1817 = 3'h1 < bytes ? _GEN_1561 : _GEN_1305; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1818 = 3'h1 < bytes ? _GEN_1562 : _GEN_1306; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1819 = 3'h1 < bytes ? _GEN_1563 : _GEN_1307; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1820 = 3'h1 < bytes ? _GEN_1564 : _GEN_1308; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1821 = 3'h1 < bytes ? _GEN_1565 : _GEN_1309; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1822 = 3'h1 < bytes ? _GEN_1566 : _GEN_1310; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1823 = 3'h1 < bytes ? _GEN_1567 : _GEN_1311; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1824 = 3'h1 < bytes ? _GEN_1568 : _GEN_1312; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1825 = 3'h1 < bytes ? _GEN_1569 : _GEN_1313; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1826 = 3'h1 < bytes ? _GEN_1570 : _GEN_1314; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1827 = 3'h1 < bytes ? _GEN_1571 : _GEN_1315; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1828 = 3'h1 < bytes ? _GEN_1572 : _GEN_1316; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1829 = 3'h1 < bytes ? _GEN_1573 : _GEN_1317; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1830 = 3'h1 < bytes ? _GEN_1574 : _GEN_1318; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1831 = 3'h1 < bytes ? _GEN_1575 : _GEN_1319; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1832 = 3'h1 < bytes ? _GEN_1576 : _GEN_1320; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1833 = 3'h1 < bytes ? _GEN_1577 : _GEN_1321; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1834 = 3'h1 < bytes ? _GEN_1578 : _GEN_1322; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1835 = 3'h1 < bytes ? _GEN_1579 : _GEN_1323; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1836 = 3'h1 < bytes ? _GEN_1580 : _GEN_1324; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1837 = 3'h1 < bytes ? _GEN_1581 : _GEN_1325; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1838 = 3'h1 < bytes ? _GEN_1582 : _GEN_1326; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1839 = 3'h1 < bytes ? _GEN_1583 : _GEN_1327; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1840 = 3'h1 < bytes ? _GEN_1584 : _GEN_1328; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1841 = 3'h1 < bytes ? _GEN_1585 : _GEN_1329; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1842 = 3'h1 < bytes ? _GEN_1586 : _GEN_1330; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1843 = 3'h1 < bytes ? _GEN_1587 : _GEN_1331; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1844 = 3'h1 < bytes ? _GEN_1588 : _GEN_1332; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1845 = 3'h1 < bytes ? _GEN_1589 : _GEN_1333; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1846 = 3'h1 < bytes ? _GEN_1590 : _GEN_1334; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1847 = 3'h1 < bytes ? _GEN_1591 : _GEN_1335; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1848 = 3'h1 < bytes ? _GEN_1592 : _GEN_1336; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1849 = 3'h1 < bytes ? _GEN_1593 : _GEN_1337; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1850 = 3'h1 < bytes ? _GEN_1594 : _GEN_1338; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1851 = 3'h1 < bytes ? _GEN_1595 : _GEN_1339; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1852 = 3'h1 < bytes ? _GEN_1596 : _GEN_1340; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1853 = 3'h1 < bytes ? _GEN_1597 : _GEN_1341; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1854 = 3'h1 < bytes ? _GEN_1598 : _GEN_1342; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1855 = 3'h1 < bytes ? _GEN_1599 : _GEN_1343; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1856 = 3'h1 < bytes ? _GEN_1600 : _GEN_1344; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1857 = 3'h1 < bytes ? _GEN_1601 : _GEN_1345; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1858 = 3'h1 < bytes ? _GEN_1602 : _GEN_1346; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1859 = 3'h1 < bytes ? _GEN_1603 : _GEN_1347; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1860 = 3'h1 < bytes ? _GEN_1604 : _GEN_1348; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1861 = 3'h1 < bytes ? _GEN_1605 : _GEN_1349; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1862 = 3'h1 < bytes ? _GEN_1606 : _GEN_1350; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1863 = 3'h1 < bytes ? _GEN_1607 : _GEN_1351; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1864 = 3'h1 < bytes ? _GEN_1608 : _GEN_1352; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1865 = 3'h1 < bytes ? _GEN_1609 : _GEN_1353; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1866 = 3'h1 < bytes ? _GEN_1610 : _GEN_1354; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1867 = 3'h1 < bytes ? _GEN_1611 : _GEN_1355; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1868 = 3'h1 < bytes ? _GEN_1612 : _GEN_1356; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1869 = 3'h1 < bytes ? _GEN_1613 : _GEN_1357; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1870 = 3'h1 < bytes ? _GEN_1614 : _GEN_1358; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1871 = 3'h1 < bytes ? _GEN_1615 : _GEN_1359; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1872 = 3'h1 < bytes ? _GEN_1616 : _GEN_1360; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1873 = 3'h1 < bytes ? _GEN_1617 : _GEN_1361; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1874 = 3'h1 < bytes ? _GEN_1618 : _GEN_1362; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1875 = 3'h1 < bytes ? _GEN_1619 : _GEN_1363; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1876 = 3'h1 < bytes ? _GEN_1620 : _GEN_1364; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1877 = 3'h1 < bytes ? _GEN_1621 : _GEN_1365; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1878 = 3'h1 < bytes ? _GEN_1622 : _GEN_1366; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1879 = 3'h1 < bytes ? _GEN_1623 : _GEN_1367; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1880 = 3'h1 < bytes ? _GEN_1624 : _GEN_1368; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1881 = 3'h1 < bytes ? _GEN_1625 : _GEN_1369; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1882 = 3'h1 < bytes ? _GEN_1626 : _GEN_1370; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1883 = 3'h1 < bytes ? _GEN_1627 : _GEN_1371; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1884 = 3'h1 < bytes ? _GEN_1628 : _GEN_1372; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1885 = 3'h1 < bytes ? _GEN_1629 : _GEN_1373; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1886 = 3'h1 < bytes ? _GEN_1630 : _GEN_1374; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1887 = 3'h1 < bytes ? _GEN_1631 : _GEN_1375; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1888 = 3'h1 < bytes ? _GEN_1632 : _GEN_1376; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1889 = 3'h1 < bytes ? _GEN_1633 : _GEN_1377; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1890 = 3'h1 < bytes ? _GEN_1634 : _GEN_1378; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1891 = 3'h1 < bytes ? _GEN_1635 : _GEN_1379; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1892 = 3'h1 < bytes ? _GEN_1636 : _GEN_1380; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1893 = 3'h1 < bytes ? _GEN_1637 : _GEN_1381; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1894 = 3'h1 < bytes ? _GEN_1638 : _GEN_1382; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1895 = 3'h1 < bytes ? _GEN_1639 : _GEN_1383; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1896 = 3'h1 < bytes ? _GEN_1640 : _GEN_1384; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1897 = 3'h1 < bytes ? _GEN_1641 : _GEN_1385; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1898 = 3'h1 < bytes ? _GEN_1642 : _GEN_1386; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1899 = 3'h1 < bytes ? _GEN_1643 : _GEN_1387; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1900 = 3'h1 < bytes ? _GEN_1644 : _GEN_1388; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1901 = 3'h1 < bytes ? _GEN_1645 : _GEN_1389; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1902 = 3'h1 < bytes ? _GEN_1646 : _GEN_1390; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1903 = 3'h1 < bytes ? _GEN_1647 : _GEN_1391; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1904 = 3'h1 < bytes ? _GEN_1648 : _GEN_1392; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1905 = 3'h1 < bytes ? _GEN_1649 : _GEN_1393; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1906 = 3'h1 < bytes ? _GEN_1650 : _GEN_1394; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1907 = 3'h1 < bytes ? _GEN_1651 : _GEN_1395; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1908 = 3'h1 < bytes ? _GEN_1652 : _GEN_1396; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1909 = 3'h1 < bytes ? _GEN_1653 : _GEN_1397; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1910 = 3'h1 < bytes ? _GEN_1654 : _GEN_1398; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1911 = 3'h1 < bytes ? _GEN_1655 : _GEN_1399; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1912 = 3'h1 < bytes ? _GEN_1656 : _GEN_1400; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1913 = 3'h1 < bytes ? _GEN_1657 : _GEN_1401; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1914 = 3'h1 < bytes ? _GEN_1658 : _GEN_1402; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1915 = 3'h1 < bytes ? _GEN_1659 : _GEN_1403; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1916 = 3'h1 < bytes ? _GEN_1660 : _GEN_1404; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1917 = 3'h1 < bytes ? _GEN_1661 : _GEN_1405; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1918 = 3'h1 < bytes ? _GEN_1662 : _GEN_1406; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1919 = 3'h1 < bytes ? _GEN_1663 : _GEN_1407; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1920 = 3'h1 < bytes ? _GEN_1664 : _GEN_1408; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1921 = 3'h1 < bytes ? _GEN_1665 : _GEN_1409; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1922 = 3'h1 < bytes ? _GEN_1666 : _GEN_1410; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1923 = 3'h1 < bytes ? _GEN_1667 : _GEN_1411; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1924 = 3'h1 < bytes ? _GEN_1668 : _GEN_1412; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1925 = 3'h1 < bytes ? _GEN_1669 : _GEN_1413; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1926 = 3'h1 < bytes ? _GEN_1670 : _GEN_1414; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1927 = 3'h1 < bytes ? _GEN_1671 : _GEN_1415; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1928 = 3'h1 < bytes ? _GEN_1672 : _GEN_1416; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1929 = 3'h1 < bytes ? _GEN_1673 : _GEN_1417; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1930 = 3'h1 < bytes ? _GEN_1674 : _GEN_1418; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1931 = 3'h1 < bytes ? _GEN_1675 : _GEN_1419; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1932 = 3'h1 < bytes ? _GEN_1676 : _GEN_1420; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1933 = 3'h1 < bytes ? _GEN_1677 : _GEN_1421; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1934 = 3'h1 < bytes ? _GEN_1678 : _GEN_1422; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1935 = 3'h1 < bytes ? _GEN_1679 : _GEN_1423; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1936 = 3'h1 < bytes ? _GEN_1680 : _GEN_1424; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1937 = 3'h1 < bytes ? _GEN_1681 : _GEN_1425; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1938 = 3'h1 < bytes ? _GEN_1682 : _GEN_1426; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1939 = 3'h1 < bytes ? _GEN_1683 : _GEN_1427; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1940 = 3'h1 < bytes ? _GEN_1684 : _GEN_1428; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1941 = 3'h1 < bytes ? _GEN_1685 : _GEN_1429; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1942 = 3'h1 < bytes ? _GEN_1686 : _GEN_1430; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1943 = 3'h1 < bytes ? _GEN_1687 : _GEN_1431; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1944 = 3'h1 < bytes ? _GEN_1688 : _GEN_1432; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1945 = 3'h1 < bytes ? _GEN_1689 : _GEN_1433; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1946 = 3'h1 < bytes ? _GEN_1690 : _GEN_1434; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1947 = 3'h1 < bytes ? _GEN_1691 : _GEN_1435; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1948 = 3'h1 < bytes ? _GEN_1692 : _GEN_1436; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1949 = 3'h1 < bytes ? _GEN_1693 : _GEN_1437; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1950 = 3'h1 < bytes ? _GEN_1694 : _GEN_1438; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1951 = 3'h1 < bytes ? _GEN_1695 : _GEN_1439; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1952 = 3'h1 < bytes ? _GEN_1696 : _GEN_1440; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1953 = 3'h1 < bytes ? _GEN_1697 : _GEN_1441; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1954 = 3'h1 < bytes ? _GEN_1698 : _GEN_1442; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1955 = 3'h1 < bytes ? _GEN_1699 : _GEN_1443; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1956 = 3'h1 < bytes ? _GEN_1700 : _GEN_1444; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1957 = 3'h1 < bytes ? _GEN_1701 : _GEN_1445; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1958 = 3'h1 < bytes ? _GEN_1702 : _GEN_1446; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1959 = 3'h1 < bytes ? _GEN_1703 : _GEN_1447; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1960 = 3'h1 < bytes ? _GEN_1704 : _GEN_1448; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1961 = 3'h1 < bytes ? _GEN_1705 : _GEN_1449; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1962 = 3'h1 < bytes ? _GEN_1706 : _GEN_1450; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1963 = 3'h1 < bytes ? _GEN_1707 : _GEN_1451; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1964 = 3'h1 < bytes ? _GEN_1708 : _GEN_1452; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1965 = 3'h1 < bytes ? _GEN_1709 : _GEN_1453; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1966 = 3'h1 < bytes ? _GEN_1710 : _GEN_1454; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1967 = 3'h1 < bytes ? _GEN_1711 : _GEN_1455; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1968 = 3'h1 < bytes ? _GEN_1712 : _GEN_1456; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1969 = 3'h1 < bytes ? _GEN_1713 : _GEN_1457; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1970 = 3'h1 < bytes ? _GEN_1714 : _GEN_1458; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1971 = 3'h1 < bytes ? _GEN_1715 : _GEN_1459; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1972 = 3'h1 < bytes ? _GEN_1716 : _GEN_1460; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1973 = 3'h1 < bytes ? _GEN_1717 : _GEN_1461; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1974 = 3'h1 < bytes ? _GEN_1718 : _GEN_1462; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1975 = 3'h1 < bytes ? _GEN_1719 : _GEN_1463; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1976 = 3'h1 < bytes ? _GEN_1720 : _GEN_1464; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1977 = 3'h1 < bytes ? _GEN_1721 : _GEN_1465; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1978 = 3'h1 < bytes ? _GEN_1722 : _GEN_1466; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1979 = 3'h1 < bytes ? _GEN_1723 : _GEN_1467; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1980 = 3'h1 < bytes ? _GEN_1724 : _GEN_1468; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1981 = 3'h1 < bytes ? _GEN_1725 : _GEN_1469; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1982 = 3'h1 < bytes ? _GEN_1726 : _GEN_1470; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1983 = 3'h1 < bytes ? _GEN_1727 : _GEN_1471; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1984 = 3'h1 < bytes ? _GEN_1728 : _GEN_1472; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1985 = 3'h1 < bytes ? _GEN_1729 : _GEN_1473; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1986 = 3'h1 < bytes ? _GEN_1730 : _GEN_1474; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1987 = 3'h1 < bytes ? _GEN_1731 : _GEN_1475; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1988 = 3'h1 < bytes ? _GEN_1732 : _GEN_1476; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1989 = 3'h1 < bytes ? _GEN_1733 : _GEN_1477; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1990 = 3'h1 < bytes ? _GEN_1734 : _GEN_1478; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1991 = 3'h1 < bytes ? _GEN_1735 : _GEN_1479; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1992 = 3'h1 < bytes ? _GEN_1736 : _GEN_1480; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1993 = 3'h1 < bytes ? _GEN_1737 : _GEN_1481; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1994 = 3'h1 < bytes ? _GEN_1738 : _GEN_1482; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1995 = 3'h1 < bytes ? _GEN_1739 : _GEN_1483; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1996 = 3'h1 < bytes ? _GEN_1740 : _GEN_1484; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1997 = 3'h1 < bytes ? _GEN_1741 : _GEN_1485; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1998 = 3'h1 < bytes ? _GEN_1742 : _GEN_1486; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_1999 = 3'h1 < bytes ? _GEN_1743 : _GEN_1487; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2000 = 3'h1 < bytes ? _GEN_1744 : _GEN_1488; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2001 = 3'h1 < bytes ? _GEN_1745 : _GEN_1489; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2002 = 3'h1 < bytes ? _GEN_1746 : _GEN_1490; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2003 = 3'h1 < bytes ? _GEN_1747 : _GEN_1491; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2004 = 3'h1 < bytes ? _GEN_1748 : _GEN_1492; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2005 = 3'h1 < bytes ? _GEN_1749 : _GEN_1493; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2006 = 3'h1 < bytes ? _GEN_1750 : _GEN_1494; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2007 = 3'h1 < bytes ? _GEN_1751 : _GEN_1495; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2008 = 3'h1 < bytes ? _GEN_1752 : _GEN_1496; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2009 = 3'h1 < bytes ? _GEN_1753 : _GEN_1497; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2010 = 3'h1 < bytes ? _GEN_1754 : _GEN_1498; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2011 = 3'h1 < bytes ? _GEN_1755 : _GEN_1499; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2012 = 3'h1 < bytes ? _GEN_1756 : _GEN_1500; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2013 = 3'h1 < bytes ? _GEN_1757 : _GEN_1501; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2014 = 3'h1 < bytes ? _GEN_1758 : _GEN_1502; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2015 = 3'h1 < bytes ? _GEN_1759 : _GEN_1503; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2016 = 3'h1 < bytes ? _GEN_1760 : _GEN_1504; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2017 = 3'h1 < bytes ? _GEN_1761 : _GEN_1505; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2018 = 3'h1 < bytes ? _GEN_1762 : _GEN_1506; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2019 = 3'h1 < bytes ? _GEN_1763 : _GEN_1507; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2020 = 3'h1 < bytes ? _GEN_1764 : _GEN_1508; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2021 = 3'h1 < bytes ? _GEN_1765 : _GEN_1509; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2022 = 3'h1 < bytes ? _GEN_1766 : _GEN_1510; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2023 = 3'h1 < bytes ? _GEN_1767 : _GEN_1511; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2024 = 3'h1 < bytes ? _GEN_1768 : _GEN_1512; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2025 = 3'h1 < bytes ? _GEN_1769 : _GEN_1513; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2026 = 3'h1 < bytes ? _GEN_1770 : _GEN_1514; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2027 = 3'h1 < bytes ? _GEN_1771 : _GEN_1515; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2028 = 3'h1 < bytes ? _GEN_1772 : _GEN_1516; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2029 = 3'h1 < bytes ? _GEN_1773 : _GEN_1517; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2030 = 3'h1 < bytes ? _GEN_1774 : _GEN_1518; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2031 = 3'h1 < bytes ? _GEN_1775 : _GEN_1519; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2032 = 3'h1 < bytes ? _GEN_1776 : _GEN_1520; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2033 = 3'h1 < bytes ? _GEN_1777 : _GEN_1521; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2034 = 3'h1 < bytes ? _GEN_1778 : _GEN_1522; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2035 = 3'h1 < bytes ? _GEN_1779 : _GEN_1523; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2036 = 3'h1 < bytes ? _GEN_1780 : _GEN_1524; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2037 = 3'h1 < bytes ? _GEN_1781 : _GEN_1525; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2038 = 3'h1 < bytes ? _GEN_1782 : _GEN_1526; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2039 = 3'h1 < bytes ? _GEN_1783 : _GEN_1527; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2040 = 3'h1 < bytes ? _GEN_1784 : _GEN_1528; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2041 = 3'h1 < bytes ? _GEN_1785 : _GEN_1529; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2042 = 3'h1 < bytes ? _GEN_1786 : _GEN_1530; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2043 = 3'h1 < bytes ? _GEN_1787 : _GEN_1531; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2044 = 3'h1 < bytes ? _GEN_1788 : _GEN_1532; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2045 = 3'h1 < bytes ? _GEN_1789 : _GEN_1533; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2046 = 3'h1 < bytes ? _GEN_1790 : _GEN_1534; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2047 = 3'h1 < bytes ? _GEN_1791 : _GEN_1535; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2048 = 3'h1 < bytes ? _GEN_1792 : _GEN_1536; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2049 = 3'h1 < bytes ? _GEN_1793 : _GEN_1537; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2050 = 3'h1 < bytes ? _GEN_1794 : _GEN_1538; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2051 = 3'h1 < bytes ? _GEN_1795 : _GEN_1539; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2052 = 3'h1 < bytes ? _GEN_1796 : _GEN_1540; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2053 = 3'h1 < bytes ? _GEN_1797 : _GEN_1541; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2054 = 3'h1 < bytes ? _GEN_1798 : _GEN_1542; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2055 = 3'h1 < bytes ? _GEN_1799 : _GEN_1543; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2056 = 3'h1 < bytes ? _GEN_1800 : _GEN_1544; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2057 = 3'h1 < bytes ? _GEN_1801 : _GEN_1545; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2058 = 3'h1 < bytes ? _GEN_1802 : _GEN_1546; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2059 = 3'h1 < bytes ? _GEN_1803 : _GEN_1547; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2060 = 3'h1 < bytes ? _GEN_1804 : _GEN_1548; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2061 = 3'h1 < bytes ? _GEN_1805 : _GEN_1549; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2062 = 3'h1 < bytes ? _GEN_1806 : _GEN_1550; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2063 = 3'h1 < bytes ? _GEN_1807 : _GEN_1551; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2064 = 3'h1 < bytes ? _GEN_1808 : _GEN_1552; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2065 = 3'h1 < bytes ? _GEN_1809 : _GEN_1553; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2066 = 3'h1 < bytes ? _GEN_1810 : _GEN_1554; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2067 = 3'h1 < bytes ? _GEN_1811 : _GEN_1555; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2068 = 3'h1 < bytes ? _GEN_1812 : _GEN_1556; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2069 = 3'h1 < bytes ? _GEN_1813 : _GEN_1557; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2070 = 8'h0 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1814; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2071 = 8'h1 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1815; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2072 = 8'h2 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1816; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2073 = 8'h3 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1817; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2074 = 8'h4 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1818; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2075 = 8'h5 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1819; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2076 = 8'h6 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1820; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2077 = 8'h7 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1821; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2078 = 8'h8 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1822; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2079 = 8'h9 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1823; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2080 = 8'ha == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1824; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2081 = 8'hb == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1825; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2082 = 8'hc == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1826; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2083 = 8'hd == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1827; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2084 = 8'he == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1828; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2085 = 8'hf == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1829; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2086 = 8'h10 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1830; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2087 = 8'h11 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1831; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2088 = 8'h12 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1832; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2089 = 8'h13 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1833; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2090 = 8'h14 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1834; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2091 = 8'h15 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1835; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2092 = 8'h16 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1836; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2093 = 8'h17 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1837; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2094 = 8'h18 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1838; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2095 = 8'h19 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1839; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2096 = 8'h1a == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1840; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2097 = 8'h1b == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1841; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2098 = 8'h1c == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1842; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2099 = 8'h1d == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1843; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2100 = 8'h1e == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1844; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2101 = 8'h1f == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1845; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2102 = 8'h20 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1846; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2103 = 8'h21 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1847; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2104 = 8'h22 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1848; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2105 = 8'h23 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1849; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2106 = 8'h24 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1850; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2107 = 8'h25 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1851; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2108 = 8'h26 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1852; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2109 = 8'h27 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1853; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2110 = 8'h28 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1854; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2111 = 8'h29 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1855; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2112 = 8'h2a == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1856; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2113 = 8'h2b == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1857; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2114 = 8'h2c == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1858; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2115 = 8'h2d == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1859; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2116 = 8'h2e == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1860; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2117 = 8'h2f == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1861; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2118 = 8'h30 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1862; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2119 = 8'h31 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1863; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2120 = 8'h32 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1864; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2121 = 8'h33 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1865; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2122 = 8'h34 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1866; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2123 = 8'h35 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1867; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2124 = 8'h36 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1868; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2125 = 8'h37 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1869; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2126 = 8'h38 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1870; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2127 = 8'h39 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1871; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2128 = 8'h3a == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1872; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2129 = 8'h3b == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1873; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2130 = 8'h3c == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1874; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2131 = 8'h3d == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1875; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2132 = 8'h3e == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1876; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2133 = 8'h3f == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1877; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2134 = 8'h40 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1878; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2135 = 8'h41 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1879; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2136 = 8'h42 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1880; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2137 = 8'h43 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1881; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2138 = 8'h44 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1882; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2139 = 8'h45 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1883; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2140 = 8'h46 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1884; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2141 = 8'h47 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1885; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2142 = 8'h48 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1886; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2143 = 8'h49 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1887; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2144 = 8'h4a == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1888; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2145 = 8'h4b == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1889; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2146 = 8'h4c == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1890; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2147 = 8'h4d == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1891; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2148 = 8'h4e == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1892; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2149 = 8'h4f == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1893; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2150 = 8'h50 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1894; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2151 = 8'h51 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1895; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2152 = 8'h52 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1896; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2153 = 8'h53 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1897; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2154 = 8'h54 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1898; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2155 = 8'h55 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1899; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2156 = 8'h56 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1900; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2157 = 8'h57 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1901; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2158 = 8'h58 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1902; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2159 = 8'h59 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1903; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2160 = 8'h5a == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1904; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2161 = 8'h5b == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1905; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2162 = 8'h5c == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1906; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2163 = 8'h5d == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1907; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2164 = 8'h5e == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1908; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2165 = 8'h5f == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1909; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2166 = 8'h60 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1910; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2167 = 8'h61 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1911; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2168 = 8'h62 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1912; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2169 = 8'h63 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1913; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2170 = 8'h64 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1914; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2171 = 8'h65 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1915; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2172 = 8'h66 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1916; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2173 = 8'h67 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1917; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2174 = 8'h68 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1918; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2175 = 8'h69 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1919; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2176 = 8'h6a == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1920; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2177 = 8'h6b == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1921; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2178 = 8'h6c == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1922; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2179 = 8'h6d == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1923; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2180 = 8'h6e == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1924; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2181 = 8'h6f == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1925; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2182 = 8'h70 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1926; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2183 = 8'h71 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1927; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2184 = 8'h72 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1928; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2185 = 8'h73 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1929; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2186 = 8'h74 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1930; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2187 = 8'h75 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1931; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2188 = 8'h76 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1932; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2189 = 8'h77 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1933; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2190 = 8'h78 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1934; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2191 = 8'h79 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1935; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2192 = 8'h7a == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1936; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2193 = 8'h7b == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1937; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2194 = 8'h7c == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1938; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2195 = 8'h7d == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1939; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2196 = 8'h7e == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1940; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2197 = 8'h7f == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1941; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2198 = 8'h80 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1942; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2199 = 8'h81 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1943; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2200 = 8'h82 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1944; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2201 = 8'h83 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1945; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2202 = 8'h84 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1946; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2203 = 8'h85 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1947; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2204 = 8'h86 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1948; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2205 = 8'h87 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1949; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2206 = 8'h88 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1950; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2207 = 8'h89 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1951; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2208 = 8'h8a == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1952; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2209 = 8'h8b == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1953; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2210 = 8'h8c == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1954; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2211 = 8'h8d == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1955; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2212 = 8'h8e == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1956; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2213 = 8'h8f == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1957; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2214 = 8'h90 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1958; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2215 = 8'h91 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1959; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2216 = 8'h92 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1960; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2217 = 8'h93 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1961; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2218 = 8'h94 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1962; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2219 = 8'h95 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1963; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2220 = 8'h96 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1964; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2221 = 8'h97 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1965; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2222 = 8'h98 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1966; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2223 = 8'h99 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1967; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2224 = 8'h9a == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1968; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2225 = 8'h9b == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1969; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2226 = 8'h9c == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1970; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2227 = 8'h9d == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1971; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2228 = 8'h9e == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1972; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2229 = 8'h9f == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1973; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2230 = 8'ha0 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1974; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2231 = 8'ha1 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1975; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2232 = 8'ha2 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1976; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2233 = 8'ha3 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1977; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2234 = 8'ha4 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1978; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2235 = 8'ha5 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1979; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2236 = 8'ha6 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1980; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2237 = 8'ha7 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1981; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2238 = 8'ha8 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1982; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2239 = 8'ha9 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1983; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2240 = 8'haa == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1984; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2241 = 8'hab == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1985; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2242 = 8'hac == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1986; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2243 = 8'had == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1987; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2244 = 8'hae == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1988; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2245 = 8'haf == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1989; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2246 = 8'hb0 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1990; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2247 = 8'hb1 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1991; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2248 = 8'hb2 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1992; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2249 = 8'hb3 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1993; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2250 = 8'hb4 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1994; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2251 = 8'hb5 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1995; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2252 = 8'hb6 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1996; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2253 = 8'hb7 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1997; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2254 = 8'hb8 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1998; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2255 = 8'hb9 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_1999; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2256 = 8'hba == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2000; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2257 = 8'hbb == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2001; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2258 = 8'hbc == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2002; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2259 = 8'hbd == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2003; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2260 = 8'hbe == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2004; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2261 = 8'hbf == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2005; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2262 = 8'hc0 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2006; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2263 = 8'hc1 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2007; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2264 = 8'hc2 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2008; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2265 = 8'hc3 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2009; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2266 = 8'hc4 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2010; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2267 = 8'hc5 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2011; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2268 = 8'hc6 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2012; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2269 = 8'hc7 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2013; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2270 = 8'hc8 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2014; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2271 = 8'hc9 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2015; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2272 = 8'hca == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2016; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2273 = 8'hcb == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2017; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2274 = 8'hcc == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2018; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2275 = 8'hcd == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2019; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2276 = 8'hce == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2020; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2277 = 8'hcf == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2021; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2278 = 8'hd0 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2022; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2279 = 8'hd1 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2023; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2280 = 8'hd2 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2024; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2281 = 8'hd3 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2025; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2282 = 8'hd4 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2026; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2283 = 8'hd5 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2027; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2284 = 8'hd6 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2028; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2285 = 8'hd7 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2029; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2286 = 8'hd8 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2030; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2287 = 8'hd9 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2031; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2288 = 8'hda == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2032; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2289 = 8'hdb == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2033; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2290 = 8'hdc == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2034; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2291 = 8'hdd == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2035; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2292 = 8'hde == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2036; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2293 = 8'hdf == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2037; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2294 = 8'he0 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2038; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2295 = 8'he1 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2039; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2296 = 8'he2 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2040; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2297 = 8'he3 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2041; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2298 = 8'he4 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2042; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2299 = 8'he5 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2043; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2300 = 8'he6 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2044; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2301 = 8'he7 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2045; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2302 = 8'he8 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2046; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2303 = 8'he9 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2047; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2304 = 8'hea == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2048; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2305 = 8'heb == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2049; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2306 = 8'hec == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2050; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2307 = 8'hed == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2051; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2308 = 8'hee == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2052; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2309 = 8'hef == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2053; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2310 = 8'hf0 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2054; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2311 = 8'hf1 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2055; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2312 = 8'hf2 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2056; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2313 = 8'hf3 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2057; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2314 = 8'hf4 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2058; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2315 = 8'hf5 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2059; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2316 = 8'hf6 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2060; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2317 = 8'hf7 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2061; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2318 = 8'hf8 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2062; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2319 = 8'hf9 == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2063; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2320 = 8'hfa == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2064; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2321 = 8'hfb == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2065; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2322 = 8'hfc == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2066; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2323 = 8'hfd == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2067; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2324 = 8'hfe == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2068; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2325 = 8'hff == _ramWord_T_4[7:0] ? rf_io_rawB[23:16] : _GEN_2069; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2326 = 3'h2 < bytes ? _GEN_2070 : _GEN_1814; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2327 = 3'h2 < bytes ? _GEN_2071 : _GEN_1815; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2328 = 3'h2 < bytes ? _GEN_2072 : _GEN_1816; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2329 = 3'h2 < bytes ? _GEN_2073 : _GEN_1817; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2330 = 3'h2 < bytes ? _GEN_2074 : _GEN_1818; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2331 = 3'h2 < bytes ? _GEN_2075 : _GEN_1819; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2332 = 3'h2 < bytes ? _GEN_2076 : _GEN_1820; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2333 = 3'h2 < bytes ? _GEN_2077 : _GEN_1821; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2334 = 3'h2 < bytes ? _GEN_2078 : _GEN_1822; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2335 = 3'h2 < bytes ? _GEN_2079 : _GEN_1823; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2336 = 3'h2 < bytes ? _GEN_2080 : _GEN_1824; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2337 = 3'h2 < bytes ? _GEN_2081 : _GEN_1825; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2338 = 3'h2 < bytes ? _GEN_2082 : _GEN_1826; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2339 = 3'h2 < bytes ? _GEN_2083 : _GEN_1827; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2340 = 3'h2 < bytes ? _GEN_2084 : _GEN_1828; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2341 = 3'h2 < bytes ? _GEN_2085 : _GEN_1829; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2342 = 3'h2 < bytes ? _GEN_2086 : _GEN_1830; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2343 = 3'h2 < bytes ? _GEN_2087 : _GEN_1831; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2344 = 3'h2 < bytes ? _GEN_2088 : _GEN_1832; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2345 = 3'h2 < bytes ? _GEN_2089 : _GEN_1833; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2346 = 3'h2 < bytes ? _GEN_2090 : _GEN_1834; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2347 = 3'h2 < bytes ? _GEN_2091 : _GEN_1835; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2348 = 3'h2 < bytes ? _GEN_2092 : _GEN_1836; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2349 = 3'h2 < bytes ? _GEN_2093 : _GEN_1837; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2350 = 3'h2 < bytes ? _GEN_2094 : _GEN_1838; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2351 = 3'h2 < bytes ? _GEN_2095 : _GEN_1839; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2352 = 3'h2 < bytes ? _GEN_2096 : _GEN_1840; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2353 = 3'h2 < bytes ? _GEN_2097 : _GEN_1841; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2354 = 3'h2 < bytes ? _GEN_2098 : _GEN_1842; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2355 = 3'h2 < bytes ? _GEN_2099 : _GEN_1843; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2356 = 3'h2 < bytes ? _GEN_2100 : _GEN_1844; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2357 = 3'h2 < bytes ? _GEN_2101 : _GEN_1845; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2358 = 3'h2 < bytes ? _GEN_2102 : _GEN_1846; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2359 = 3'h2 < bytes ? _GEN_2103 : _GEN_1847; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2360 = 3'h2 < bytes ? _GEN_2104 : _GEN_1848; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2361 = 3'h2 < bytes ? _GEN_2105 : _GEN_1849; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2362 = 3'h2 < bytes ? _GEN_2106 : _GEN_1850; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2363 = 3'h2 < bytes ? _GEN_2107 : _GEN_1851; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2364 = 3'h2 < bytes ? _GEN_2108 : _GEN_1852; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2365 = 3'h2 < bytes ? _GEN_2109 : _GEN_1853; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2366 = 3'h2 < bytes ? _GEN_2110 : _GEN_1854; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2367 = 3'h2 < bytes ? _GEN_2111 : _GEN_1855; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2368 = 3'h2 < bytes ? _GEN_2112 : _GEN_1856; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2369 = 3'h2 < bytes ? _GEN_2113 : _GEN_1857; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2370 = 3'h2 < bytes ? _GEN_2114 : _GEN_1858; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2371 = 3'h2 < bytes ? _GEN_2115 : _GEN_1859; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2372 = 3'h2 < bytes ? _GEN_2116 : _GEN_1860; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2373 = 3'h2 < bytes ? _GEN_2117 : _GEN_1861; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2374 = 3'h2 < bytes ? _GEN_2118 : _GEN_1862; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2375 = 3'h2 < bytes ? _GEN_2119 : _GEN_1863; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2376 = 3'h2 < bytes ? _GEN_2120 : _GEN_1864; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2377 = 3'h2 < bytes ? _GEN_2121 : _GEN_1865; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2378 = 3'h2 < bytes ? _GEN_2122 : _GEN_1866; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2379 = 3'h2 < bytes ? _GEN_2123 : _GEN_1867; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2380 = 3'h2 < bytes ? _GEN_2124 : _GEN_1868; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2381 = 3'h2 < bytes ? _GEN_2125 : _GEN_1869; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2382 = 3'h2 < bytes ? _GEN_2126 : _GEN_1870; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2383 = 3'h2 < bytes ? _GEN_2127 : _GEN_1871; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2384 = 3'h2 < bytes ? _GEN_2128 : _GEN_1872; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2385 = 3'h2 < bytes ? _GEN_2129 : _GEN_1873; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2386 = 3'h2 < bytes ? _GEN_2130 : _GEN_1874; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2387 = 3'h2 < bytes ? _GEN_2131 : _GEN_1875; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2388 = 3'h2 < bytes ? _GEN_2132 : _GEN_1876; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2389 = 3'h2 < bytes ? _GEN_2133 : _GEN_1877; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2390 = 3'h2 < bytes ? _GEN_2134 : _GEN_1878; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2391 = 3'h2 < bytes ? _GEN_2135 : _GEN_1879; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2392 = 3'h2 < bytes ? _GEN_2136 : _GEN_1880; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2393 = 3'h2 < bytes ? _GEN_2137 : _GEN_1881; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2394 = 3'h2 < bytes ? _GEN_2138 : _GEN_1882; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2395 = 3'h2 < bytes ? _GEN_2139 : _GEN_1883; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2396 = 3'h2 < bytes ? _GEN_2140 : _GEN_1884; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2397 = 3'h2 < bytes ? _GEN_2141 : _GEN_1885; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2398 = 3'h2 < bytes ? _GEN_2142 : _GEN_1886; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2399 = 3'h2 < bytes ? _GEN_2143 : _GEN_1887; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2400 = 3'h2 < bytes ? _GEN_2144 : _GEN_1888; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2401 = 3'h2 < bytes ? _GEN_2145 : _GEN_1889; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2402 = 3'h2 < bytes ? _GEN_2146 : _GEN_1890; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2403 = 3'h2 < bytes ? _GEN_2147 : _GEN_1891; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2404 = 3'h2 < bytes ? _GEN_2148 : _GEN_1892; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2405 = 3'h2 < bytes ? _GEN_2149 : _GEN_1893; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2406 = 3'h2 < bytes ? _GEN_2150 : _GEN_1894; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2407 = 3'h2 < bytes ? _GEN_2151 : _GEN_1895; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2408 = 3'h2 < bytes ? _GEN_2152 : _GEN_1896; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2409 = 3'h2 < bytes ? _GEN_2153 : _GEN_1897; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2410 = 3'h2 < bytes ? _GEN_2154 : _GEN_1898; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2411 = 3'h2 < bytes ? _GEN_2155 : _GEN_1899; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2412 = 3'h2 < bytes ? _GEN_2156 : _GEN_1900; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2413 = 3'h2 < bytes ? _GEN_2157 : _GEN_1901; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2414 = 3'h2 < bytes ? _GEN_2158 : _GEN_1902; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2415 = 3'h2 < bytes ? _GEN_2159 : _GEN_1903; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2416 = 3'h2 < bytes ? _GEN_2160 : _GEN_1904; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2417 = 3'h2 < bytes ? _GEN_2161 : _GEN_1905; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2418 = 3'h2 < bytes ? _GEN_2162 : _GEN_1906; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2419 = 3'h2 < bytes ? _GEN_2163 : _GEN_1907; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2420 = 3'h2 < bytes ? _GEN_2164 : _GEN_1908; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2421 = 3'h2 < bytes ? _GEN_2165 : _GEN_1909; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2422 = 3'h2 < bytes ? _GEN_2166 : _GEN_1910; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2423 = 3'h2 < bytes ? _GEN_2167 : _GEN_1911; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2424 = 3'h2 < bytes ? _GEN_2168 : _GEN_1912; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2425 = 3'h2 < bytes ? _GEN_2169 : _GEN_1913; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2426 = 3'h2 < bytes ? _GEN_2170 : _GEN_1914; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2427 = 3'h2 < bytes ? _GEN_2171 : _GEN_1915; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2428 = 3'h2 < bytes ? _GEN_2172 : _GEN_1916; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2429 = 3'h2 < bytes ? _GEN_2173 : _GEN_1917; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2430 = 3'h2 < bytes ? _GEN_2174 : _GEN_1918; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2431 = 3'h2 < bytes ? _GEN_2175 : _GEN_1919; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2432 = 3'h2 < bytes ? _GEN_2176 : _GEN_1920; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2433 = 3'h2 < bytes ? _GEN_2177 : _GEN_1921; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2434 = 3'h2 < bytes ? _GEN_2178 : _GEN_1922; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2435 = 3'h2 < bytes ? _GEN_2179 : _GEN_1923; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2436 = 3'h2 < bytes ? _GEN_2180 : _GEN_1924; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2437 = 3'h2 < bytes ? _GEN_2181 : _GEN_1925; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2438 = 3'h2 < bytes ? _GEN_2182 : _GEN_1926; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2439 = 3'h2 < bytes ? _GEN_2183 : _GEN_1927; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2440 = 3'h2 < bytes ? _GEN_2184 : _GEN_1928; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2441 = 3'h2 < bytes ? _GEN_2185 : _GEN_1929; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2442 = 3'h2 < bytes ? _GEN_2186 : _GEN_1930; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2443 = 3'h2 < bytes ? _GEN_2187 : _GEN_1931; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2444 = 3'h2 < bytes ? _GEN_2188 : _GEN_1932; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2445 = 3'h2 < bytes ? _GEN_2189 : _GEN_1933; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2446 = 3'h2 < bytes ? _GEN_2190 : _GEN_1934; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2447 = 3'h2 < bytes ? _GEN_2191 : _GEN_1935; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2448 = 3'h2 < bytes ? _GEN_2192 : _GEN_1936; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2449 = 3'h2 < bytes ? _GEN_2193 : _GEN_1937; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2450 = 3'h2 < bytes ? _GEN_2194 : _GEN_1938; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2451 = 3'h2 < bytes ? _GEN_2195 : _GEN_1939; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2452 = 3'h2 < bytes ? _GEN_2196 : _GEN_1940; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2453 = 3'h2 < bytes ? _GEN_2197 : _GEN_1941; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2454 = 3'h2 < bytes ? _GEN_2198 : _GEN_1942; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2455 = 3'h2 < bytes ? _GEN_2199 : _GEN_1943; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2456 = 3'h2 < bytes ? _GEN_2200 : _GEN_1944; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2457 = 3'h2 < bytes ? _GEN_2201 : _GEN_1945; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2458 = 3'h2 < bytes ? _GEN_2202 : _GEN_1946; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2459 = 3'h2 < bytes ? _GEN_2203 : _GEN_1947; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2460 = 3'h2 < bytes ? _GEN_2204 : _GEN_1948; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2461 = 3'h2 < bytes ? _GEN_2205 : _GEN_1949; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2462 = 3'h2 < bytes ? _GEN_2206 : _GEN_1950; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2463 = 3'h2 < bytes ? _GEN_2207 : _GEN_1951; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2464 = 3'h2 < bytes ? _GEN_2208 : _GEN_1952; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2465 = 3'h2 < bytes ? _GEN_2209 : _GEN_1953; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2466 = 3'h2 < bytes ? _GEN_2210 : _GEN_1954; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2467 = 3'h2 < bytes ? _GEN_2211 : _GEN_1955; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2468 = 3'h2 < bytes ? _GEN_2212 : _GEN_1956; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2469 = 3'h2 < bytes ? _GEN_2213 : _GEN_1957; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2470 = 3'h2 < bytes ? _GEN_2214 : _GEN_1958; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2471 = 3'h2 < bytes ? _GEN_2215 : _GEN_1959; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2472 = 3'h2 < bytes ? _GEN_2216 : _GEN_1960; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2473 = 3'h2 < bytes ? _GEN_2217 : _GEN_1961; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2474 = 3'h2 < bytes ? _GEN_2218 : _GEN_1962; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2475 = 3'h2 < bytes ? _GEN_2219 : _GEN_1963; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2476 = 3'h2 < bytes ? _GEN_2220 : _GEN_1964; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2477 = 3'h2 < bytes ? _GEN_2221 : _GEN_1965; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2478 = 3'h2 < bytes ? _GEN_2222 : _GEN_1966; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2479 = 3'h2 < bytes ? _GEN_2223 : _GEN_1967; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2480 = 3'h2 < bytes ? _GEN_2224 : _GEN_1968; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2481 = 3'h2 < bytes ? _GEN_2225 : _GEN_1969; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2482 = 3'h2 < bytes ? _GEN_2226 : _GEN_1970; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2483 = 3'h2 < bytes ? _GEN_2227 : _GEN_1971; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2484 = 3'h2 < bytes ? _GEN_2228 : _GEN_1972; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2485 = 3'h2 < bytes ? _GEN_2229 : _GEN_1973; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2486 = 3'h2 < bytes ? _GEN_2230 : _GEN_1974; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2487 = 3'h2 < bytes ? _GEN_2231 : _GEN_1975; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2488 = 3'h2 < bytes ? _GEN_2232 : _GEN_1976; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2489 = 3'h2 < bytes ? _GEN_2233 : _GEN_1977; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2490 = 3'h2 < bytes ? _GEN_2234 : _GEN_1978; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2491 = 3'h2 < bytes ? _GEN_2235 : _GEN_1979; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2492 = 3'h2 < bytes ? _GEN_2236 : _GEN_1980; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2493 = 3'h2 < bytes ? _GEN_2237 : _GEN_1981; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2494 = 3'h2 < bytes ? _GEN_2238 : _GEN_1982; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2495 = 3'h2 < bytes ? _GEN_2239 : _GEN_1983; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2496 = 3'h2 < bytes ? _GEN_2240 : _GEN_1984; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2497 = 3'h2 < bytes ? _GEN_2241 : _GEN_1985; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2498 = 3'h2 < bytes ? _GEN_2242 : _GEN_1986; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2499 = 3'h2 < bytes ? _GEN_2243 : _GEN_1987; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2500 = 3'h2 < bytes ? _GEN_2244 : _GEN_1988; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2501 = 3'h2 < bytes ? _GEN_2245 : _GEN_1989; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2502 = 3'h2 < bytes ? _GEN_2246 : _GEN_1990; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2503 = 3'h2 < bytes ? _GEN_2247 : _GEN_1991; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2504 = 3'h2 < bytes ? _GEN_2248 : _GEN_1992; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2505 = 3'h2 < bytes ? _GEN_2249 : _GEN_1993; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2506 = 3'h2 < bytes ? _GEN_2250 : _GEN_1994; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2507 = 3'h2 < bytes ? _GEN_2251 : _GEN_1995; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2508 = 3'h2 < bytes ? _GEN_2252 : _GEN_1996; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2509 = 3'h2 < bytes ? _GEN_2253 : _GEN_1997; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2510 = 3'h2 < bytes ? _GEN_2254 : _GEN_1998; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2511 = 3'h2 < bytes ? _GEN_2255 : _GEN_1999; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2512 = 3'h2 < bytes ? _GEN_2256 : _GEN_2000; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2513 = 3'h2 < bytes ? _GEN_2257 : _GEN_2001; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2514 = 3'h2 < bytes ? _GEN_2258 : _GEN_2002; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2515 = 3'h2 < bytes ? _GEN_2259 : _GEN_2003; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2516 = 3'h2 < bytes ? _GEN_2260 : _GEN_2004; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2517 = 3'h2 < bytes ? _GEN_2261 : _GEN_2005; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2518 = 3'h2 < bytes ? _GEN_2262 : _GEN_2006; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2519 = 3'h2 < bytes ? _GEN_2263 : _GEN_2007; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2520 = 3'h2 < bytes ? _GEN_2264 : _GEN_2008; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2521 = 3'h2 < bytes ? _GEN_2265 : _GEN_2009; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2522 = 3'h2 < bytes ? _GEN_2266 : _GEN_2010; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2523 = 3'h2 < bytes ? _GEN_2267 : _GEN_2011; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2524 = 3'h2 < bytes ? _GEN_2268 : _GEN_2012; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2525 = 3'h2 < bytes ? _GEN_2269 : _GEN_2013; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2526 = 3'h2 < bytes ? _GEN_2270 : _GEN_2014; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2527 = 3'h2 < bytes ? _GEN_2271 : _GEN_2015; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2528 = 3'h2 < bytes ? _GEN_2272 : _GEN_2016; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2529 = 3'h2 < bytes ? _GEN_2273 : _GEN_2017; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2530 = 3'h2 < bytes ? _GEN_2274 : _GEN_2018; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2531 = 3'h2 < bytes ? _GEN_2275 : _GEN_2019; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2532 = 3'h2 < bytes ? _GEN_2276 : _GEN_2020; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2533 = 3'h2 < bytes ? _GEN_2277 : _GEN_2021; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2534 = 3'h2 < bytes ? _GEN_2278 : _GEN_2022; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2535 = 3'h2 < bytes ? _GEN_2279 : _GEN_2023; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2536 = 3'h2 < bytes ? _GEN_2280 : _GEN_2024; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2537 = 3'h2 < bytes ? _GEN_2281 : _GEN_2025; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2538 = 3'h2 < bytes ? _GEN_2282 : _GEN_2026; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2539 = 3'h2 < bytes ? _GEN_2283 : _GEN_2027; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2540 = 3'h2 < bytes ? _GEN_2284 : _GEN_2028; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2541 = 3'h2 < bytes ? _GEN_2285 : _GEN_2029; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2542 = 3'h2 < bytes ? _GEN_2286 : _GEN_2030; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2543 = 3'h2 < bytes ? _GEN_2287 : _GEN_2031; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2544 = 3'h2 < bytes ? _GEN_2288 : _GEN_2032; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2545 = 3'h2 < bytes ? _GEN_2289 : _GEN_2033; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2546 = 3'h2 < bytes ? _GEN_2290 : _GEN_2034; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2547 = 3'h2 < bytes ? _GEN_2291 : _GEN_2035; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2548 = 3'h2 < bytes ? _GEN_2292 : _GEN_2036; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2549 = 3'h2 < bytes ? _GEN_2293 : _GEN_2037; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2550 = 3'h2 < bytes ? _GEN_2294 : _GEN_2038; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2551 = 3'h2 < bytes ? _GEN_2295 : _GEN_2039; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2552 = 3'h2 < bytes ? _GEN_2296 : _GEN_2040; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2553 = 3'h2 < bytes ? _GEN_2297 : _GEN_2041; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2554 = 3'h2 < bytes ? _GEN_2298 : _GEN_2042; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2555 = 3'h2 < bytes ? _GEN_2299 : _GEN_2043; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2556 = 3'h2 < bytes ? _GEN_2300 : _GEN_2044; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2557 = 3'h2 < bytes ? _GEN_2301 : _GEN_2045; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2558 = 3'h2 < bytes ? _GEN_2302 : _GEN_2046; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2559 = 3'h2 < bytes ? _GEN_2303 : _GEN_2047; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2560 = 3'h2 < bytes ? _GEN_2304 : _GEN_2048; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2561 = 3'h2 < bytes ? _GEN_2305 : _GEN_2049; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2562 = 3'h2 < bytes ? _GEN_2306 : _GEN_2050; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2563 = 3'h2 < bytes ? _GEN_2307 : _GEN_2051; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2564 = 3'h2 < bytes ? _GEN_2308 : _GEN_2052; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2565 = 3'h2 < bytes ? _GEN_2309 : _GEN_2053; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2566 = 3'h2 < bytes ? _GEN_2310 : _GEN_2054; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2567 = 3'h2 < bytes ? _GEN_2311 : _GEN_2055; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2568 = 3'h2 < bytes ? _GEN_2312 : _GEN_2056; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2569 = 3'h2 < bytes ? _GEN_2313 : _GEN_2057; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2570 = 3'h2 < bytes ? _GEN_2314 : _GEN_2058; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2571 = 3'h2 < bytes ? _GEN_2315 : _GEN_2059; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2572 = 3'h2 < bytes ? _GEN_2316 : _GEN_2060; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2573 = 3'h2 < bytes ? _GEN_2317 : _GEN_2061; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2574 = 3'h2 < bytes ? _GEN_2318 : _GEN_2062; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2575 = 3'h2 < bytes ? _GEN_2319 : _GEN_2063; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2576 = 3'h2 < bytes ? _GEN_2320 : _GEN_2064; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2577 = 3'h2 < bytes ? _GEN_2321 : _GEN_2065; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2578 = 3'h2 < bytes ? _GEN_2322 : _GEN_2066; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2579 = 3'h2 < bytes ? _GEN_2323 : _GEN_2067; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2580 = 3'h2 < bytes ? _GEN_2324 : _GEN_2068; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2581 = 3'h2 < bytes ? _GEN_2325 : _GEN_2069; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2582 = 8'h0 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2326; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2583 = 8'h1 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2327; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2584 = 8'h2 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2328; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2585 = 8'h3 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2329; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2586 = 8'h4 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2330; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2587 = 8'h5 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2331; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2588 = 8'h6 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2332; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2589 = 8'h7 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2333; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2590 = 8'h8 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2334; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2591 = 8'h9 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2335; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2592 = 8'ha == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2336; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2593 = 8'hb == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2337; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2594 = 8'hc == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2338; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2595 = 8'hd == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2339; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2596 = 8'he == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2340; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2597 = 8'hf == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2341; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2598 = 8'h10 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2342; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2599 = 8'h11 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2343; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2600 = 8'h12 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2344; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2601 = 8'h13 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2345; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2602 = 8'h14 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2346; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2603 = 8'h15 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2347; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2604 = 8'h16 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2348; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2605 = 8'h17 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2349; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2606 = 8'h18 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2350; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2607 = 8'h19 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2351; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2608 = 8'h1a == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2352; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2609 = 8'h1b == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2353; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2610 = 8'h1c == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2354; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2611 = 8'h1d == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2355; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2612 = 8'h1e == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2356; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2613 = 8'h1f == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2357; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2614 = 8'h20 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2358; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2615 = 8'h21 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2359; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2616 = 8'h22 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2360; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2617 = 8'h23 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2361; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2618 = 8'h24 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2362; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2619 = 8'h25 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2363; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2620 = 8'h26 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2364; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2621 = 8'h27 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2365; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2622 = 8'h28 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2366; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2623 = 8'h29 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2367; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2624 = 8'h2a == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2368; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2625 = 8'h2b == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2369; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2626 = 8'h2c == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2370; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2627 = 8'h2d == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2371; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2628 = 8'h2e == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2372; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2629 = 8'h2f == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2373; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2630 = 8'h30 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2374; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2631 = 8'h31 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2375; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2632 = 8'h32 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2376; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2633 = 8'h33 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2377; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2634 = 8'h34 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2378; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2635 = 8'h35 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2379; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2636 = 8'h36 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2380; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2637 = 8'h37 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2381; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2638 = 8'h38 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2382; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2639 = 8'h39 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2383; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2640 = 8'h3a == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2384; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2641 = 8'h3b == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2385; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2642 = 8'h3c == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2386; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2643 = 8'h3d == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2387; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2644 = 8'h3e == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2388; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2645 = 8'h3f == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2389; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2646 = 8'h40 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2390; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2647 = 8'h41 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2391; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2648 = 8'h42 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2392; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2649 = 8'h43 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2393; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2650 = 8'h44 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2394; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2651 = 8'h45 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2395; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2652 = 8'h46 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2396; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2653 = 8'h47 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2397; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2654 = 8'h48 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2398; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2655 = 8'h49 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2399; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2656 = 8'h4a == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2400; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2657 = 8'h4b == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2401; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2658 = 8'h4c == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2402; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2659 = 8'h4d == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2403; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2660 = 8'h4e == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2404; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2661 = 8'h4f == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2405; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2662 = 8'h50 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2406; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2663 = 8'h51 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2407; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2664 = 8'h52 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2408; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2665 = 8'h53 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2409; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2666 = 8'h54 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2410; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2667 = 8'h55 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2411; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2668 = 8'h56 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2412; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2669 = 8'h57 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2413; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2670 = 8'h58 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2414; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2671 = 8'h59 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2415; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2672 = 8'h5a == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2416; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2673 = 8'h5b == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2417; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2674 = 8'h5c == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2418; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2675 = 8'h5d == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2419; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2676 = 8'h5e == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2420; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2677 = 8'h5f == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2421; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2678 = 8'h60 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2422; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2679 = 8'h61 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2423; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2680 = 8'h62 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2424; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2681 = 8'h63 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2425; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2682 = 8'h64 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2426; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2683 = 8'h65 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2427; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2684 = 8'h66 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2428; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2685 = 8'h67 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2429; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2686 = 8'h68 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2430; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2687 = 8'h69 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2431; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2688 = 8'h6a == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2432; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2689 = 8'h6b == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2433; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2690 = 8'h6c == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2434; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2691 = 8'h6d == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2435; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2692 = 8'h6e == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2436; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2693 = 8'h6f == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2437; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2694 = 8'h70 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2438; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2695 = 8'h71 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2439; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2696 = 8'h72 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2440; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2697 = 8'h73 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2441; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2698 = 8'h74 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2442; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2699 = 8'h75 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2443; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2700 = 8'h76 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2444; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2701 = 8'h77 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2445; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2702 = 8'h78 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2446; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2703 = 8'h79 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2447; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2704 = 8'h7a == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2448; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2705 = 8'h7b == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2449; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2706 = 8'h7c == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2450; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2707 = 8'h7d == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2451; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2708 = 8'h7e == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2452; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2709 = 8'h7f == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2453; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2710 = 8'h80 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2454; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2711 = 8'h81 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2455; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2712 = 8'h82 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2456; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2713 = 8'h83 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2457; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2714 = 8'h84 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2458; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2715 = 8'h85 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2459; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2716 = 8'h86 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2460; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2717 = 8'h87 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2461; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2718 = 8'h88 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2462; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2719 = 8'h89 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2463; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2720 = 8'h8a == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2464; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2721 = 8'h8b == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2465; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2722 = 8'h8c == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2466; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2723 = 8'h8d == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2467; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2724 = 8'h8e == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2468; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2725 = 8'h8f == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2469; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2726 = 8'h90 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2470; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2727 = 8'h91 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2471; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2728 = 8'h92 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2472; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2729 = 8'h93 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2473; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2730 = 8'h94 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2474; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2731 = 8'h95 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2475; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2732 = 8'h96 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2476; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2733 = 8'h97 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2477; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2734 = 8'h98 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2478; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2735 = 8'h99 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2479; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2736 = 8'h9a == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2480; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2737 = 8'h9b == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2481; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2738 = 8'h9c == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2482; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2739 = 8'h9d == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2483; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2740 = 8'h9e == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2484; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2741 = 8'h9f == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2485; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2742 = 8'ha0 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2486; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2743 = 8'ha1 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2487; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2744 = 8'ha2 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2488; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2745 = 8'ha3 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2489; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2746 = 8'ha4 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2490; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2747 = 8'ha5 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2491; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2748 = 8'ha6 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2492; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2749 = 8'ha7 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2493; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2750 = 8'ha8 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2494; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2751 = 8'ha9 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2495; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2752 = 8'haa == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2496; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2753 = 8'hab == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2497; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2754 = 8'hac == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2498; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2755 = 8'had == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2499; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2756 = 8'hae == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2500; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2757 = 8'haf == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2501; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2758 = 8'hb0 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2502; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2759 = 8'hb1 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2503; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2760 = 8'hb2 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2504; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2761 = 8'hb3 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2505; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2762 = 8'hb4 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2506; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2763 = 8'hb5 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2507; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2764 = 8'hb6 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2508; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2765 = 8'hb7 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2509; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2766 = 8'hb8 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2510; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2767 = 8'hb9 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2511; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2768 = 8'hba == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2512; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2769 = 8'hbb == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2513; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2770 = 8'hbc == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2514; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2771 = 8'hbd == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2515; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2772 = 8'hbe == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2516; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2773 = 8'hbf == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2517; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2774 = 8'hc0 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2518; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2775 = 8'hc1 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2519; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2776 = 8'hc2 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2520; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2777 = 8'hc3 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2521; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2778 = 8'hc4 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2522; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2779 = 8'hc5 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2523; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2780 = 8'hc6 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2524; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2781 = 8'hc7 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2525; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2782 = 8'hc8 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2526; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2783 = 8'hc9 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2527; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2784 = 8'hca == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2528; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2785 = 8'hcb == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2529; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2786 = 8'hcc == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2530; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2787 = 8'hcd == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2531; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2788 = 8'hce == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2532; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2789 = 8'hcf == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2533; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2790 = 8'hd0 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2534; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2791 = 8'hd1 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2535; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2792 = 8'hd2 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2536; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2793 = 8'hd3 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2537; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2794 = 8'hd4 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2538; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2795 = 8'hd5 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2539; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2796 = 8'hd6 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2540; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2797 = 8'hd7 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2541; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2798 = 8'hd8 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2542; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2799 = 8'hd9 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2543; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2800 = 8'hda == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2544; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2801 = 8'hdb == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2545; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2802 = 8'hdc == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2546; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2803 = 8'hdd == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2547; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2804 = 8'hde == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2548; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2805 = 8'hdf == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2549; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2806 = 8'he0 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2550; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2807 = 8'he1 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2551; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2808 = 8'he2 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2552; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2809 = 8'he3 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2553; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2810 = 8'he4 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2554; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2811 = 8'he5 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2555; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2812 = 8'he6 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2556; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2813 = 8'he7 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2557; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2814 = 8'he8 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2558; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2815 = 8'he9 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2559; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2816 = 8'hea == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2560; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2817 = 8'heb == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2561; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2818 = 8'hec == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2562; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2819 = 8'hed == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2563; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2820 = 8'hee == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2564; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2821 = 8'hef == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2565; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2822 = 8'hf0 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2566; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2823 = 8'hf1 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2567; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2824 = 8'hf2 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2568; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2825 = 8'hf3 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2569; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2826 = 8'hf4 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2570; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2827 = 8'hf5 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2571; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2828 = 8'hf6 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2572; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2829 = 8'hf7 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2573; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2830 = 8'hf8 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2574; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2831 = 8'hf9 == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2575; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2832 = 8'hfa == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2576; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2833 = 8'hfb == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2577; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2834 = 8'hfc == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2578; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2835 = 8'hfd == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2579; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2836 = 8'hfe == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2580; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2837 = 8'hff == _ramWord_T_1[7:0] ? rf_io_rawB[31:24] : _GEN_2581; // @[src/main/scala/SingleCycleCPU.scala 77:{77,77}]
  wire [7:0] _GEN_2838 = 3'h3 < bytes ? _GEN_2582 : _GEN_2326; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2839 = 3'h3 < bytes ? _GEN_2583 : _GEN_2327; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2840 = 3'h3 < bytes ? _GEN_2584 : _GEN_2328; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2841 = 3'h3 < bytes ? _GEN_2585 : _GEN_2329; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2842 = 3'h3 < bytes ? _GEN_2586 : _GEN_2330; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2843 = 3'h3 < bytes ? _GEN_2587 : _GEN_2331; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2844 = 3'h3 < bytes ? _GEN_2588 : _GEN_2332; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2845 = 3'h3 < bytes ? _GEN_2589 : _GEN_2333; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2846 = 3'h3 < bytes ? _GEN_2590 : _GEN_2334; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2847 = 3'h3 < bytes ? _GEN_2591 : _GEN_2335; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2848 = 3'h3 < bytes ? _GEN_2592 : _GEN_2336; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2849 = 3'h3 < bytes ? _GEN_2593 : _GEN_2337; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2850 = 3'h3 < bytes ? _GEN_2594 : _GEN_2338; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2851 = 3'h3 < bytes ? _GEN_2595 : _GEN_2339; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2852 = 3'h3 < bytes ? _GEN_2596 : _GEN_2340; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2853 = 3'h3 < bytes ? _GEN_2597 : _GEN_2341; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2854 = 3'h3 < bytes ? _GEN_2598 : _GEN_2342; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2855 = 3'h3 < bytes ? _GEN_2599 : _GEN_2343; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2856 = 3'h3 < bytes ? _GEN_2600 : _GEN_2344; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2857 = 3'h3 < bytes ? _GEN_2601 : _GEN_2345; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2858 = 3'h3 < bytes ? _GEN_2602 : _GEN_2346; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2859 = 3'h3 < bytes ? _GEN_2603 : _GEN_2347; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2860 = 3'h3 < bytes ? _GEN_2604 : _GEN_2348; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2861 = 3'h3 < bytes ? _GEN_2605 : _GEN_2349; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2862 = 3'h3 < bytes ? _GEN_2606 : _GEN_2350; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2863 = 3'h3 < bytes ? _GEN_2607 : _GEN_2351; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2864 = 3'h3 < bytes ? _GEN_2608 : _GEN_2352; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2865 = 3'h3 < bytes ? _GEN_2609 : _GEN_2353; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2866 = 3'h3 < bytes ? _GEN_2610 : _GEN_2354; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2867 = 3'h3 < bytes ? _GEN_2611 : _GEN_2355; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2868 = 3'h3 < bytes ? _GEN_2612 : _GEN_2356; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2869 = 3'h3 < bytes ? _GEN_2613 : _GEN_2357; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2870 = 3'h3 < bytes ? _GEN_2614 : _GEN_2358; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2871 = 3'h3 < bytes ? _GEN_2615 : _GEN_2359; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2872 = 3'h3 < bytes ? _GEN_2616 : _GEN_2360; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2873 = 3'h3 < bytes ? _GEN_2617 : _GEN_2361; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2874 = 3'h3 < bytes ? _GEN_2618 : _GEN_2362; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2875 = 3'h3 < bytes ? _GEN_2619 : _GEN_2363; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2876 = 3'h3 < bytes ? _GEN_2620 : _GEN_2364; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2877 = 3'h3 < bytes ? _GEN_2621 : _GEN_2365; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2878 = 3'h3 < bytes ? _GEN_2622 : _GEN_2366; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2879 = 3'h3 < bytes ? _GEN_2623 : _GEN_2367; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2880 = 3'h3 < bytes ? _GEN_2624 : _GEN_2368; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2881 = 3'h3 < bytes ? _GEN_2625 : _GEN_2369; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2882 = 3'h3 < bytes ? _GEN_2626 : _GEN_2370; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2883 = 3'h3 < bytes ? _GEN_2627 : _GEN_2371; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2884 = 3'h3 < bytes ? _GEN_2628 : _GEN_2372; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2885 = 3'h3 < bytes ? _GEN_2629 : _GEN_2373; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2886 = 3'h3 < bytes ? _GEN_2630 : _GEN_2374; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2887 = 3'h3 < bytes ? _GEN_2631 : _GEN_2375; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2888 = 3'h3 < bytes ? _GEN_2632 : _GEN_2376; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2889 = 3'h3 < bytes ? _GEN_2633 : _GEN_2377; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2890 = 3'h3 < bytes ? _GEN_2634 : _GEN_2378; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2891 = 3'h3 < bytes ? _GEN_2635 : _GEN_2379; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2892 = 3'h3 < bytes ? _GEN_2636 : _GEN_2380; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2893 = 3'h3 < bytes ? _GEN_2637 : _GEN_2381; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2894 = 3'h3 < bytes ? _GEN_2638 : _GEN_2382; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2895 = 3'h3 < bytes ? _GEN_2639 : _GEN_2383; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2896 = 3'h3 < bytes ? _GEN_2640 : _GEN_2384; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2897 = 3'h3 < bytes ? _GEN_2641 : _GEN_2385; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2898 = 3'h3 < bytes ? _GEN_2642 : _GEN_2386; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2899 = 3'h3 < bytes ? _GEN_2643 : _GEN_2387; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2900 = 3'h3 < bytes ? _GEN_2644 : _GEN_2388; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2901 = 3'h3 < bytes ? _GEN_2645 : _GEN_2389; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2902 = 3'h3 < bytes ? _GEN_2646 : _GEN_2390; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2903 = 3'h3 < bytes ? _GEN_2647 : _GEN_2391; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2904 = 3'h3 < bytes ? _GEN_2648 : _GEN_2392; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2905 = 3'h3 < bytes ? _GEN_2649 : _GEN_2393; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2906 = 3'h3 < bytes ? _GEN_2650 : _GEN_2394; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2907 = 3'h3 < bytes ? _GEN_2651 : _GEN_2395; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2908 = 3'h3 < bytes ? _GEN_2652 : _GEN_2396; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2909 = 3'h3 < bytes ? _GEN_2653 : _GEN_2397; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2910 = 3'h3 < bytes ? _GEN_2654 : _GEN_2398; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2911 = 3'h3 < bytes ? _GEN_2655 : _GEN_2399; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2912 = 3'h3 < bytes ? _GEN_2656 : _GEN_2400; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2913 = 3'h3 < bytes ? _GEN_2657 : _GEN_2401; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2914 = 3'h3 < bytes ? _GEN_2658 : _GEN_2402; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2915 = 3'h3 < bytes ? _GEN_2659 : _GEN_2403; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2916 = 3'h3 < bytes ? _GEN_2660 : _GEN_2404; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2917 = 3'h3 < bytes ? _GEN_2661 : _GEN_2405; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2918 = 3'h3 < bytes ? _GEN_2662 : _GEN_2406; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2919 = 3'h3 < bytes ? _GEN_2663 : _GEN_2407; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2920 = 3'h3 < bytes ? _GEN_2664 : _GEN_2408; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2921 = 3'h3 < bytes ? _GEN_2665 : _GEN_2409; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2922 = 3'h3 < bytes ? _GEN_2666 : _GEN_2410; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2923 = 3'h3 < bytes ? _GEN_2667 : _GEN_2411; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2924 = 3'h3 < bytes ? _GEN_2668 : _GEN_2412; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2925 = 3'h3 < bytes ? _GEN_2669 : _GEN_2413; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2926 = 3'h3 < bytes ? _GEN_2670 : _GEN_2414; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2927 = 3'h3 < bytes ? _GEN_2671 : _GEN_2415; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2928 = 3'h3 < bytes ? _GEN_2672 : _GEN_2416; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2929 = 3'h3 < bytes ? _GEN_2673 : _GEN_2417; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2930 = 3'h3 < bytes ? _GEN_2674 : _GEN_2418; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2931 = 3'h3 < bytes ? _GEN_2675 : _GEN_2419; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2932 = 3'h3 < bytes ? _GEN_2676 : _GEN_2420; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2933 = 3'h3 < bytes ? _GEN_2677 : _GEN_2421; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2934 = 3'h3 < bytes ? _GEN_2678 : _GEN_2422; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2935 = 3'h3 < bytes ? _GEN_2679 : _GEN_2423; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2936 = 3'h3 < bytes ? _GEN_2680 : _GEN_2424; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2937 = 3'h3 < bytes ? _GEN_2681 : _GEN_2425; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2938 = 3'h3 < bytes ? _GEN_2682 : _GEN_2426; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2939 = 3'h3 < bytes ? _GEN_2683 : _GEN_2427; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2940 = 3'h3 < bytes ? _GEN_2684 : _GEN_2428; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2941 = 3'h3 < bytes ? _GEN_2685 : _GEN_2429; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2942 = 3'h3 < bytes ? _GEN_2686 : _GEN_2430; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2943 = 3'h3 < bytes ? _GEN_2687 : _GEN_2431; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2944 = 3'h3 < bytes ? _GEN_2688 : _GEN_2432; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2945 = 3'h3 < bytes ? _GEN_2689 : _GEN_2433; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2946 = 3'h3 < bytes ? _GEN_2690 : _GEN_2434; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2947 = 3'h3 < bytes ? _GEN_2691 : _GEN_2435; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2948 = 3'h3 < bytes ? _GEN_2692 : _GEN_2436; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2949 = 3'h3 < bytes ? _GEN_2693 : _GEN_2437; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2950 = 3'h3 < bytes ? _GEN_2694 : _GEN_2438; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2951 = 3'h3 < bytes ? _GEN_2695 : _GEN_2439; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2952 = 3'h3 < bytes ? _GEN_2696 : _GEN_2440; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2953 = 3'h3 < bytes ? _GEN_2697 : _GEN_2441; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2954 = 3'h3 < bytes ? _GEN_2698 : _GEN_2442; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2955 = 3'h3 < bytes ? _GEN_2699 : _GEN_2443; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2956 = 3'h3 < bytes ? _GEN_2700 : _GEN_2444; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2957 = 3'h3 < bytes ? _GEN_2701 : _GEN_2445; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2958 = 3'h3 < bytes ? _GEN_2702 : _GEN_2446; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2959 = 3'h3 < bytes ? _GEN_2703 : _GEN_2447; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2960 = 3'h3 < bytes ? _GEN_2704 : _GEN_2448; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2961 = 3'h3 < bytes ? _GEN_2705 : _GEN_2449; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2962 = 3'h3 < bytes ? _GEN_2706 : _GEN_2450; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2963 = 3'h3 < bytes ? _GEN_2707 : _GEN_2451; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2964 = 3'h3 < bytes ? _GEN_2708 : _GEN_2452; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2965 = 3'h3 < bytes ? _GEN_2709 : _GEN_2453; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2966 = 3'h3 < bytes ? _GEN_2710 : _GEN_2454; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2967 = 3'h3 < bytes ? _GEN_2711 : _GEN_2455; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2968 = 3'h3 < bytes ? _GEN_2712 : _GEN_2456; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2969 = 3'h3 < bytes ? _GEN_2713 : _GEN_2457; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2970 = 3'h3 < bytes ? _GEN_2714 : _GEN_2458; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2971 = 3'h3 < bytes ? _GEN_2715 : _GEN_2459; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2972 = 3'h3 < bytes ? _GEN_2716 : _GEN_2460; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2973 = 3'h3 < bytes ? _GEN_2717 : _GEN_2461; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2974 = 3'h3 < bytes ? _GEN_2718 : _GEN_2462; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2975 = 3'h3 < bytes ? _GEN_2719 : _GEN_2463; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2976 = 3'h3 < bytes ? _GEN_2720 : _GEN_2464; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2977 = 3'h3 < bytes ? _GEN_2721 : _GEN_2465; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2978 = 3'h3 < bytes ? _GEN_2722 : _GEN_2466; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2979 = 3'h3 < bytes ? _GEN_2723 : _GEN_2467; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2980 = 3'h3 < bytes ? _GEN_2724 : _GEN_2468; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2981 = 3'h3 < bytes ? _GEN_2725 : _GEN_2469; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2982 = 3'h3 < bytes ? _GEN_2726 : _GEN_2470; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2983 = 3'h3 < bytes ? _GEN_2727 : _GEN_2471; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2984 = 3'h3 < bytes ? _GEN_2728 : _GEN_2472; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2985 = 3'h3 < bytes ? _GEN_2729 : _GEN_2473; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2986 = 3'h3 < bytes ? _GEN_2730 : _GEN_2474; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2987 = 3'h3 < bytes ? _GEN_2731 : _GEN_2475; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2988 = 3'h3 < bytes ? _GEN_2732 : _GEN_2476; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2989 = 3'h3 < bytes ? _GEN_2733 : _GEN_2477; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2990 = 3'h3 < bytes ? _GEN_2734 : _GEN_2478; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2991 = 3'h3 < bytes ? _GEN_2735 : _GEN_2479; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2992 = 3'h3 < bytes ? _GEN_2736 : _GEN_2480; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2993 = 3'h3 < bytes ? _GEN_2737 : _GEN_2481; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2994 = 3'h3 < bytes ? _GEN_2738 : _GEN_2482; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2995 = 3'h3 < bytes ? _GEN_2739 : _GEN_2483; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2996 = 3'h3 < bytes ? _GEN_2740 : _GEN_2484; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2997 = 3'h3 < bytes ? _GEN_2741 : _GEN_2485; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2998 = 3'h3 < bytes ? _GEN_2742 : _GEN_2486; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_2999 = 3'h3 < bytes ? _GEN_2743 : _GEN_2487; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3000 = 3'h3 < bytes ? _GEN_2744 : _GEN_2488; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3001 = 3'h3 < bytes ? _GEN_2745 : _GEN_2489; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3002 = 3'h3 < bytes ? _GEN_2746 : _GEN_2490; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3003 = 3'h3 < bytes ? _GEN_2747 : _GEN_2491; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3004 = 3'h3 < bytes ? _GEN_2748 : _GEN_2492; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3005 = 3'h3 < bytes ? _GEN_2749 : _GEN_2493; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3006 = 3'h3 < bytes ? _GEN_2750 : _GEN_2494; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3007 = 3'h3 < bytes ? _GEN_2751 : _GEN_2495; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3008 = 3'h3 < bytes ? _GEN_2752 : _GEN_2496; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3009 = 3'h3 < bytes ? _GEN_2753 : _GEN_2497; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3010 = 3'h3 < bytes ? _GEN_2754 : _GEN_2498; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3011 = 3'h3 < bytes ? _GEN_2755 : _GEN_2499; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3012 = 3'h3 < bytes ? _GEN_2756 : _GEN_2500; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3013 = 3'h3 < bytes ? _GEN_2757 : _GEN_2501; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3014 = 3'h3 < bytes ? _GEN_2758 : _GEN_2502; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3015 = 3'h3 < bytes ? _GEN_2759 : _GEN_2503; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3016 = 3'h3 < bytes ? _GEN_2760 : _GEN_2504; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3017 = 3'h3 < bytes ? _GEN_2761 : _GEN_2505; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3018 = 3'h3 < bytes ? _GEN_2762 : _GEN_2506; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3019 = 3'h3 < bytes ? _GEN_2763 : _GEN_2507; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3020 = 3'h3 < bytes ? _GEN_2764 : _GEN_2508; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3021 = 3'h3 < bytes ? _GEN_2765 : _GEN_2509; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3022 = 3'h3 < bytes ? _GEN_2766 : _GEN_2510; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3023 = 3'h3 < bytes ? _GEN_2767 : _GEN_2511; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3024 = 3'h3 < bytes ? _GEN_2768 : _GEN_2512; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3025 = 3'h3 < bytes ? _GEN_2769 : _GEN_2513; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3026 = 3'h3 < bytes ? _GEN_2770 : _GEN_2514; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3027 = 3'h3 < bytes ? _GEN_2771 : _GEN_2515; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3028 = 3'h3 < bytes ? _GEN_2772 : _GEN_2516; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3029 = 3'h3 < bytes ? _GEN_2773 : _GEN_2517; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3030 = 3'h3 < bytes ? _GEN_2774 : _GEN_2518; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3031 = 3'h3 < bytes ? _GEN_2775 : _GEN_2519; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3032 = 3'h3 < bytes ? _GEN_2776 : _GEN_2520; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3033 = 3'h3 < bytes ? _GEN_2777 : _GEN_2521; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3034 = 3'h3 < bytes ? _GEN_2778 : _GEN_2522; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3035 = 3'h3 < bytes ? _GEN_2779 : _GEN_2523; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3036 = 3'h3 < bytes ? _GEN_2780 : _GEN_2524; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3037 = 3'h3 < bytes ? _GEN_2781 : _GEN_2525; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3038 = 3'h3 < bytes ? _GEN_2782 : _GEN_2526; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3039 = 3'h3 < bytes ? _GEN_2783 : _GEN_2527; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3040 = 3'h3 < bytes ? _GEN_2784 : _GEN_2528; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3041 = 3'h3 < bytes ? _GEN_2785 : _GEN_2529; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3042 = 3'h3 < bytes ? _GEN_2786 : _GEN_2530; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3043 = 3'h3 < bytes ? _GEN_2787 : _GEN_2531; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3044 = 3'h3 < bytes ? _GEN_2788 : _GEN_2532; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3045 = 3'h3 < bytes ? _GEN_2789 : _GEN_2533; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3046 = 3'h3 < bytes ? _GEN_2790 : _GEN_2534; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3047 = 3'h3 < bytes ? _GEN_2791 : _GEN_2535; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3048 = 3'h3 < bytes ? _GEN_2792 : _GEN_2536; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3049 = 3'h3 < bytes ? _GEN_2793 : _GEN_2537; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3050 = 3'h3 < bytes ? _GEN_2794 : _GEN_2538; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3051 = 3'h3 < bytes ? _GEN_2795 : _GEN_2539; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3052 = 3'h3 < bytes ? _GEN_2796 : _GEN_2540; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3053 = 3'h3 < bytes ? _GEN_2797 : _GEN_2541; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3054 = 3'h3 < bytes ? _GEN_2798 : _GEN_2542; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3055 = 3'h3 < bytes ? _GEN_2799 : _GEN_2543; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3056 = 3'h3 < bytes ? _GEN_2800 : _GEN_2544; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3057 = 3'h3 < bytes ? _GEN_2801 : _GEN_2545; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3058 = 3'h3 < bytes ? _GEN_2802 : _GEN_2546; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3059 = 3'h3 < bytes ? _GEN_2803 : _GEN_2547; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3060 = 3'h3 < bytes ? _GEN_2804 : _GEN_2548; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3061 = 3'h3 < bytes ? _GEN_2805 : _GEN_2549; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3062 = 3'h3 < bytes ? _GEN_2806 : _GEN_2550; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3063 = 3'h3 < bytes ? _GEN_2807 : _GEN_2551; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3064 = 3'h3 < bytes ? _GEN_2808 : _GEN_2552; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3065 = 3'h3 < bytes ? _GEN_2809 : _GEN_2553; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3066 = 3'h3 < bytes ? _GEN_2810 : _GEN_2554; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3067 = 3'h3 < bytes ? _GEN_2811 : _GEN_2555; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3068 = 3'h3 < bytes ? _GEN_2812 : _GEN_2556; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3069 = 3'h3 < bytes ? _GEN_2813 : _GEN_2557; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3070 = 3'h3 < bytes ? _GEN_2814 : _GEN_2558; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3071 = 3'h3 < bytes ? _GEN_2815 : _GEN_2559; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3072 = 3'h3 < bytes ? _GEN_2816 : _GEN_2560; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3073 = 3'h3 < bytes ? _GEN_2817 : _GEN_2561; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3074 = 3'h3 < bytes ? _GEN_2818 : _GEN_2562; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3075 = 3'h3 < bytes ? _GEN_2819 : _GEN_2563; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3076 = 3'h3 < bytes ? _GEN_2820 : _GEN_2564; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3077 = 3'h3 < bytes ? _GEN_2821 : _GEN_2565; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3078 = 3'h3 < bytes ? _GEN_2822 : _GEN_2566; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3079 = 3'h3 < bytes ? _GEN_2823 : _GEN_2567; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3080 = 3'h3 < bytes ? _GEN_2824 : _GEN_2568; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3081 = 3'h3 < bytes ? _GEN_2825 : _GEN_2569; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3082 = 3'h3 < bytes ? _GEN_2826 : _GEN_2570; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3083 = 3'h3 < bytes ? _GEN_2827 : _GEN_2571; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3084 = 3'h3 < bytes ? _GEN_2828 : _GEN_2572; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3085 = 3'h3 < bytes ? _GEN_2829 : _GEN_2573; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3086 = 3'h3 < bytes ? _GEN_2830 : _GEN_2574; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3087 = 3'h3 < bytes ? _GEN_2831 : _GEN_2575; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3088 = 3'h3 < bytes ? _GEN_2832 : _GEN_2576; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3089 = 3'h3 < bytes ? _GEN_2833 : _GEN_2577; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3090 = 3'h3 < bytes ? _GEN_2834 : _GEN_2578; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3091 = 3'h3 < bytes ? _GEN_2835 : _GEN_2579; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3092 = 3'h3 < bytes ? _GEN_2836 : _GEN_2580; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [7:0] _GEN_3093 = 3'h3 < bytes ? _GEN_2837 : _GEN_2581; // @[src/main/scala/SingleCycleCPU.scala 77:50]
  wire [15:0] _GEN_3094 = _mmio_T_1 ? rf_io_rawB[15:0] : led; // @[src/main/scala/SingleCycleCPU.scala 22:17 78:{45,49}]
  wire [31:0] _GEN_3095 = _mmio_T_1 ? display : rf_io_rawB; // @[src/main/scala/SingleCycleCPU.scala 78:45 22:48 78:86]
  wire [7:0] _GEN_3096 = inRAM ? _GEN_2838 : memory_0; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3097 = inRAM ? _GEN_2839 : memory_1; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3098 = inRAM ? _GEN_2840 : memory_2; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3099 = inRAM ? _GEN_2841 : memory_3; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3100 = inRAM ? _GEN_2842 : memory_4; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3101 = inRAM ? _GEN_2843 : memory_5; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3102 = inRAM ? _GEN_2844 : memory_6; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3103 = inRAM ? _GEN_2845 : memory_7; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3104 = inRAM ? _GEN_2846 : memory_8; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3105 = inRAM ? _GEN_2847 : memory_9; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3106 = inRAM ? _GEN_2848 : memory_10; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3107 = inRAM ? _GEN_2849 : memory_11; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3108 = inRAM ? _GEN_2850 : memory_12; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3109 = inRAM ? _GEN_2851 : memory_13; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3110 = inRAM ? _GEN_2852 : memory_14; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3111 = inRAM ? _GEN_2853 : memory_15; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3112 = inRAM ? _GEN_2854 : memory_16; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3113 = inRAM ? _GEN_2855 : memory_17; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3114 = inRAM ? _GEN_2856 : memory_18; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3115 = inRAM ? _GEN_2857 : memory_19; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3116 = inRAM ? _GEN_2858 : memory_20; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3117 = inRAM ? _GEN_2859 : memory_21; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3118 = inRAM ? _GEN_2860 : memory_22; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3119 = inRAM ? _GEN_2861 : memory_23; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3120 = inRAM ? _GEN_2862 : memory_24; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3121 = inRAM ? _GEN_2863 : memory_25; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3122 = inRAM ? _GEN_2864 : memory_26; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3123 = inRAM ? _GEN_2865 : memory_27; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3124 = inRAM ? _GEN_2866 : memory_28; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3125 = inRAM ? _GEN_2867 : memory_29; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3126 = inRAM ? _GEN_2868 : memory_30; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3127 = inRAM ? _GEN_2869 : memory_31; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3128 = inRAM ? _GEN_2870 : memory_32; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3129 = inRAM ? _GEN_2871 : memory_33; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3130 = inRAM ? _GEN_2872 : memory_34; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3131 = inRAM ? _GEN_2873 : memory_35; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3132 = inRAM ? _GEN_2874 : memory_36; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3133 = inRAM ? _GEN_2875 : memory_37; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3134 = inRAM ? _GEN_2876 : memory_38; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3135 = inRAM ? _GEN_2877 : memory_39; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3136 = inRAM ? _GEN_2878 : memory_40; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3137 = inRAM ? _GEN_2879 : memory_41; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3138 = inRAM ? _GEN_2880 : memory_42; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3139 = inRAM ? _GEN_2881 : memory_43; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3140 = inRAM ? _GEN_2882 : memory_44; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3141 = inRAM ? _GEN_2883 : memory_45; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3142 = inRAM ? _GEN_2884 : memory_46; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3143 = inRAM ? _GEN_2885 : memory_47; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3144 = inRAM ? _GEN_2886 : memory_48; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3145 = inRAM ? _GEN_2887 : memory_49; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3146 = inRAM ? _GEN_2888 : memory_50; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3147 = inRAM ? _GEN_2889 : memory_51; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3148 = inRAM ? _GEN_2890 : memory_52; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3149 = inRAM ? _GEN_2891 : memory_53; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3150 = inRAM ? _GEN_2892 : memory_54; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3151 = inRAM ? _GEN_2893 : memory_55; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3152 = inRAM ? _GEN_2894 : memory_56; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3153 = inRAM ? _GEN_2895 : memory_57; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3154 = inRAM ? _GEN_2896 : memory_58; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3155 = inRAM ? _GEN_2897 : memory_59; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3156 = inRAM ? _GEN_2898 : memory_60; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3157 = inRAM ? _GEN_2899 : memory_61; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3158 = inRAM ? _GEN_2900 : memory_62; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3159 = inRAM ? _GEN_2901 : memory_63; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3160 = inRAM ? _GEN_2902 : memory_64; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3161 = inRAM ? _GEN_2903 : memory_65; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3162 = inRAM ? _GEN_2904 : memory_66; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3163 = inRAM ? _GEN_2905 : memory_67; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3164 = inRAM ? _GEN_2906 : memory_68; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3165 = inRAM ? _GEN_2907 : memory_69; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3166 = inRAM ? _GEN_2908 : memory_70; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3167 = inRAM ? _GEN_2909 : memory_71; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3168 = inRAM ? _GEN_2910 : memory_72; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3169 = inRAM ? _GEN_2911 : memory_73; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3170 = inRAM ? _GEN_2912 : memory_74; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3171 = inRAM ? _GEN_2913 : memory_75; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3172 = inRAM ? _GEN_2914 : memory_76; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3173 = inRAM ? _GEN_2915 : memory_77; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3174 = inRAM ? _GEN_2916 : memory_78; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3175 = inRAM ? _GEN_2917 : memory_79; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3176 = inRAM ? _GEN_2918 : memory_80; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3177 = inRAM ? _GEN_2919 : memory_81; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3178 = inRAM ? _GEN_2920 : memory_82; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3179 = inRAM ? _GEN_2921 : memory_83; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3180 = inRAM ? _GEN_2922 : memory_84; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3181 = inRAM ? _GEN_2923 : memory_85; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3182 = inRAM ? _GEN_2924 : memory_86; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3183 = inRAM ? _GEN_2925 : memory_87; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3184 = inRAM ? _GEN_2926 : memory_88; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3185 = inRAM ? _GEN_2927 : memory_89; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3186 = inRAM ? _GEN_2928 : memory_90; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3187 = inRAM ? _GEN_2929 : memory_91; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3188 = inRAM ? _GEN_2930 : memory_92; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3189 = inRAM ? _GEN_2931 : memory_93; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3190 = inRAM ? _GEN_2932 : memory_94; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3191 = inRAM ? _GEN_2933 : memory_95; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3192 = inRAM ? _GEN_2934 : memory_96; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3193 = inRAM ? _GEN_2935 : memory_97; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3194 = inRAM ? _GEN_2936 : memory_98; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3195 = inRAM ? _GEN_2937 : memory_99; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3196 = inRAM ? _GEN_2938 : memory_100; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3197 = inRAM ? _GEN_2939 : memory_101; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3198 = inRAM ? _GEN_2940 : memory_102; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3199 = inRAM ? _GEN_2941 : memory_103; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3200 = inRAM ? _GEN_2942 : memory_104; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3201 = inRAM ? _GEN_2943 : memory_105; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3202 = inRAM ? _GEN_2944 : memory_106; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3203 = inRAM ? _GEN_2945 : memory_107; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3204 = inRAM ? _GEN_2946 : memory_108; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3205 = inRAM ? _GEN_2947 : memory_109; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3206 = inRAM ? _GEN_2948 : memory_110; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3207 = inRAM ? _GEN_2949 : memory_111; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3208 = inRAM ? _GEN_2950 : memory_112; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3209 = inRAM ? _GEN_2951 : memory_113; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3210 = inRAM ? _GEN_2952 : memory_114; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3211 = inRAM ? _GEN_2953 : memory_115; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3212 = inRAM ? _GEN_2954 : memory_116; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3213 = inRAM ? _GEN_2955 : memory_117; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3214 = inRAM ? _GEN_2956 : memory_118; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3215 = inRAM ? _GEN_2957 : memory_119; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3216 = inRAM ? _GEN_2958 : memory_120; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3217 = inRAM ? _GEN_2959 : memory_121; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3218 = inRAM ? _GEN_2960 : memory_122; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3219 = inRAM ? _GEN_2961 : memory_123; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3220 = inRAM ? _GEN_2962 : memory_124; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3221 = inRAM ? _GEN_2963 : memory_125; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3222 = inRAM ? _GEN_2964 : memory_126; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3223 = inRAM ? _GEN_2965 : memory_127; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3224 = inRAM ? _GEN_2966 : memory_128; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3225 = inRAM ? _GEN_2967 : memory_129; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3226 = inRAM ? _GEN_2968 : memory_130; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3227 = inRAM ? _GEN_2969 : memory_131; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3228 = inRAM ? _GEN_2970 : memory_132; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3229 = inRAM ? _GEN_2971 : memory_133; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3230 = inRAM ? _GEN_2972 : memory_134; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3231 = inRAM ? _GEN_2973 : memory_135; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3232 = inRAM ? _GEN_2974 : memory_136; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3233 = inRAM ? _GEN_2975 : memory_137; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3234 = inRAM ? _GEN_2976 : memory_138; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3235 = inRAM ? _GEN_2977 : memory_139; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3236 = inRAM ? _GEN_2978 : memory_140; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3237 = inRAM ? _GEN_2979 : memory_141; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3238 = inRAM ? _GEN_2980 : memory_142; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3239 = inRAM ? _GEN_2981 : memory_143; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3240 = inRAM ? _GEN_2982 : memory_144; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3241 = inRAM ? _GEN_2983 : memory_145; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3242 = inRAM ? _GEN_2984 : memory_146; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3243 = inRAM ? _GEN_2985 : memory_147; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3244 = inRAM ? _GEN_2986 : memory_148; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3245 = inRAM ? _GEN_2987 : memory_149; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3246 = inRAM ? _GEN_2988 : memory_150; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3247 = inRAM ? _GEN_2989 : memory_151; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3248 = inRAM ? _GEN_2990 : memory_152; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3249 = inRAM ? _GEN_2991 : memory_153; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3250 = inRAM ? _GEN_2992 : memory_154; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3251 = inRAM ? _GEN_2993 : memory_155; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3252 = inRAM ? _GEN_2994 : memory_156; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3253 = inRAM ? _GEN_2995 : memory_157; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3254 = inRAM ? _GEN_2996 : memory_158; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3255 = inRAM ? _GEN_2997 : memory_159; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3256 = inRAM ? _GEN_2998 : memory_160; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3257 = inRAM ? _GEN_2999 : memory_161; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3258 = inRAM ? _GEN_3000 : memory_162; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3259 = inRAM ? _GEN_3001 : memory_163; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3260 = inRAM ? _GEN_3002 : memory_164; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3261 = inRAM ? _GEN_3003 : memory_165; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3262 = inRAM ? _GEN_3004 : memory_166; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3263 = inRAM ? _GEN_3005 : memory_167; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3264 = inRAM ? _GEN_3006 : memory_168; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3265 = inRAM ? _GEN_3007 : memory_169; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3266 = inRAM ? _GEN_3008 : memory_170; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3267 = inRAM ? _GEN_3009 : memory_171; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3268 = inRAM ? _GEN_3010 : memory_172; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3269 = inRAM ? _GEN_3011 : memory_173; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3270 = inRAM ? _GEN_3012 : memory_174; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3271 = inRAM ? _GEN_3013 : memory_175; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3272 = inRAM ? _GEN_3014 : memory_176; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3273 = inRAM ? _GEN_3015 : memory_177; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3274 = inRAM ? _GEN_3016 : memory_178; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3275 = inRAM ? _GEN_3017 : memory_179; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3276 = inRAM ? _GEN_3018 : memory_180; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3277 = inRAM ? _GEN_3019 : memory_181; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3278 = inRAM ? _GEN_3020 : memory_182; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3279 = inRAM ? _GEN_3021 : memory_183; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3280 = inRAM ? _GEN_3022 : memory_184; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3281 = inRAM ? _GEN_3023 : memory_185; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3282 = inRAM ? _GEN_3024 : memory_186; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3283 = inRAM ? _GEN_3025 : memory_187; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3284 = inRAM ? _GEN_3026 : memory_188; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3285 = inRAM ? _GEN_3027 : memory_189; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3286 = inRAM ? _GEN_3028 : memory_190; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3287 = inRAM ? _GEN_3029 : memory_191; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3288 = inRAM ? _GEN_3030 : memory_192; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3289 = inRAM ? _GEN_3031 : memory_193; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3290 = inRAM ? _GEN_3032 : memory_194; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3291 = inRAM ? _GEN_3033 : memory_195; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3292 = inRAM ? _GEN_3034 : memory_196; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3293 = inRAM ? _GEN_3035 : memory_197; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3294 = inRAM ? _GEN_3036 : memory_198; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3295 = inRAM ? _GEN_3037 : memory_199; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3296 = inRAM ? _GEN_3038 : memory_200; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3297 = inRAM ? _GEN_3039 : memory_201; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3298 = inRAM ? _GEN_3040 : memory_202; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3299 = inRAM ? _GEN_3041 : memory_203; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3300 = inRAM ? _GEN_3042 : memory_204; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3301 = inRAM ? _GEN_3043 : memory_205; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3302 = inRAM ? _GEN_3044 : memory_206; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3303 = inRAM ? _GEN_3045 : memory_207; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3304 = inRAM ? _GEN_3046 : memory_208; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3305 = inRAM ? _GEN_3047 : memory_209; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3306 = inRAM ? _GEN_3048 : memory_210; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3307 = inRAM ? _GEN_3049 : memory_211; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3308 = inRAM ? _GEN_3050 : memory_212; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3309 = inRAM ? _GEN_3051 : memory_213; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3310 = inRAM ? _GEN_3052 : memory_214; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3311 = inRAM ? _GEN_3053 : memory_215; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3312 = inRAM ? _GEN_3054 : memory_216; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3313 = inRAM ? _GEN_3055 : memory_217; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3314 = inRAM ? _GEN_3056 : memory_218; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3315 = inRAM ? _GEN_3057 : memory_219; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3316 = inRAM ? _GEN_3058 : memory_220; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3317 = inRAM ? _GEN_3059 : memory_221; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3318 = inRAM ? _GEN_3060 : memory_222; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3319 = inRAM ? _GEN_3061 : memory_223; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3320 = inRAM ? _GEN_3062 : memory_224; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3321 = inRAM ? _GEN_3063 : memory_225; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3322 = inRAM ? _GEN_3064 : memory_226; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3323 = inRAM ? _GEN_3065 : memory_227; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3324 = inRAM ? _GEN_3066 : memory_228; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3325 = inRAM ? _GEN_3067 : memory_229; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3326 = inRAM ? _GEN_3068 : memory_230; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3327 = inRAM ? _GEN_3069 : memory_231; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3328 = inRAM ? _GEN_3070 : memory_232; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3329 = inRAM ? _GEN_3071 : memory_233; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3330 = inRAM ? _GEN_3072 : memory_234; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3331 = inRAM ? _GEN_3073 : memory_235; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3332 = inRAM ? _GEN_3074 : memory_236; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3333 = inRAM ? _GEN_3075 : memory_237; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3334 = inRAM ? _GEN_3076 : memory_238; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3335 = inRAM ? _GEN_3077 : memory_239; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3336 = inRAM ? _GEN_3078 : memory_240; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3337 = inRAM ? _GEN_3079 : memory_241; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3338 = inRAM ? _GEN_3080 : memory_242; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3339 = inRAM ? _GEN_3081 : memory_243; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3340 = inRAM ? _GEN_3082 : memory_244; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3341 = inRAM ? _GEN_3083 : memory_245; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3342 = inRAM ? _GEN_3084 : memory_246; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3343 = inRAM ? _GEN_3085 : memory_247; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3344 = inRAM ? _GEN_3086 : memory_248; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3345 = inRAM ? _GEN_3087 : memory_249; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3346 = inRAM ? _GEN_3088 : memory_250; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3347 = inRAM ? _GEN_3089 : memory_251; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3348 = inRAM ? _GEN_3090 : memory_252; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3349 = inRAM ? _GEN_3091 : memory_253; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3350 = inRAM ? _GEN_3092 : memory_254; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [7:0] _GEN_3351 = inRAM ? _GEN_3093 : memory_255; // @[src/main/scala/SingleCycleCPU.scala 77:16 21:20]
  wire [15:0] _GEN_3352 = inRAM ? led : _GEN_3094; // @[src/main/scala/SingleCycleCPU.scala 77:16 22:17]
  wire [31:0] _GEN_3353 = inRAM ? display : _GEN_3095; // @[src/main/scala/SingleCycleCPU.scala 77:16 22:48]
  wire [7:0] _GEN_3354 = dec_io_control[5] ? _GEN_3096 : memory_0; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3355 = dec_io_control[5] ? _GEN_3097 : memory_1; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3356 = dec_io_control[5] ? _GEN_3098 : memory_2; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3357 = dec_io_control[5] ? _GEN_3099 : memory_3; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3358 = dec_io_control[5] ? _GEN_3100 : memory_4; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3359 = dec_io_control[5] ? _GEN_3101 : memory_5; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3360 = dec_io_control[5] ? _GEN_3102 : memory_6; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3361 = dec_io_control[5] ? _GEN_3103 : memory_7; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3362 = dec_io_control[5] ? _GEN_3104 : memory_8; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3363 = dec_io_control[5] ? _GEN_3105 : memory_9; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3364 = dec_io_control[5] ? _GEN_3106 : memory_10; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3365 = dec_io_control[5] ? _GEN_3107 : memory_11; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3366 = dec_io_control[5] ? _GEN_3108 : memory_12; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3367 = dec_io_control[5] ? _GEN_3109 : memory_13; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3368 = dec_io_control[5] ? _GEN_3110 : memory_14; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3369 = dec_io_control[5] ? _GEN_3111 : memory_15; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3370 = dec_io_control[5] ? _GEN_3112 : memory_16; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3371 = dec_io_control[5] ? _GEN_3113 : memory_17; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3372 = dec_io_control[5] ? _GEN_3114 : memory_18; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3373 = dec_io_control[5] ? _GEN_3115 : memory_19; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3374 = dec_io_control[5] ? _GEN_3116 : memory_20; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3375 = dec_io_control[5] ? _GEN_3117 : memory_21; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3376 = dec_io_control[5] ? _GEN_3118 : memory_22; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3377 = dec_io_control[5] ? _GEN_3119 : memory_23; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3378 = dec_io_control[5] ? _GEN_3120 : memory_24; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3379 = dec_io_control[5] ? _GEN_3121 : memory_25; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3380 = dec_io_control[5] ? _GEN_3122 : memory_26; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3381 = dec_io_control[5] ? _GEN_3123 : memory_27; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3382 = dec_io_control[5] ? _GEN_3124 : memory_28; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3383 = dec_io_control[5] ? _GEN_3125 : memory_29; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3384 = dec_io_control[5] ? _GEN_3126 : memory_30; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3385 = dec_io_control[5] ? _GEN_3127 : memory_31; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3386 = dec_io_control[5] ? _GEN_3128 : memory_32; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3387 = dec_io_control[5] ? _GEN_3129 : memory_33; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3388 = dec_io_control[5] ? _GEN_3130 : memory_34; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3389 = dec_io_control[5] ? _GEN_3131 : memory_35; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3390 = dec_io_control[5] ? _GEN_3132 : memory_36; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3391 = dec_io_control[5] ? _GEN_3133 : memory_37; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3392 = dec_io_control[5] ? _GEN_3134 : memory_38; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3393 = dec_io_control[5] ? _GEN_3135 : memory_39; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3394 = dec_io_control[5] ? _GEN_3136 : memory_40; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3395 = dec_io_control[5] ? _GEN_3137 : memory_41; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3396 = dec_io_control[5] ? _GEN_3138 : memory_42; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3397 = dec_io_control[5] ? _GEN_3139 : memory_43; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3398 = dec_io_control[5] ? _GEN_3140 : memory_44; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3399 = dec_io_control[5] ? _GEN_3141 : memory_45; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3400 = dec_io_control[5] ? _GEN_3142 : memory_46; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3401 = dec_io_control[5] ? _GEN_3143 : memory_47; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3402 = dec_io_control[5] ? _GEN_3144 : memory_48; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3403 = dec_io_control[5] ? _GEN_3145 : memory_49; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3404 = dec_io_control[5] ? _GEN_3146 : memory_50; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3405 = dec_io_control[5] ? _GEN_3147 : memory_51; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3406 = dec_io_control[5] ? _GEN_3148 : memory_52; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3407 = dec_io_control[5] ? _GEN_3149 : memory_53; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3408 = dec_io_control[5] ? _GEN_3150 : memory_54; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3409 = dec_io_control[5] ? _GEN_3151 : memory_55; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3410 = dec_io_control[5] ? _GEN_3152 : memory_56; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3411 = dec_io_control[5] ? _GEN_3153 : memory_57; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3412 = dec_io_control[5] ? _GEN_3154 : memory_58; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3413 = dec_io_control[5] ? _GEN_3155 : memory_59; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3414 = dec_io_control[5] ? _GEN_3156 : memory_60; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3415 = dec_io_control[5] ? _GEN_3157 : memory_61; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3416 = dec_io_control[5] ? _GEN_3158 : memory_62; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3417 = dec_io_control[5] ? _GEN_3159 : memory_63; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3418 = dec_io_control[5] ? _GEN_3160 : memory_64; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3419 = dec_io_control[5] ? _GEN_3161 : memory_65; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3420 = dec_io_control[5] ? _GEN_3162 : memory_66; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3421 = dec_io_control[5] ? _GEN_3163 : memory_67; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3422 = dec_io_control[5] ? _GEN_3164 : memory_68; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3423 = dec_io_control[5] ? _GEN_3165 : memory_69; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3424 = dec_io_control[5] ? _GEN_3166 : memory_70; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3425 = dec_io_control[5] ? _GEN_3167 : memory_71; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3426 = dec_io_control[5] ? _GEN_3168 : memory_72; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3427 = dec_io_control[5] ? _GEN_3169 : memory_73; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3428 = dec_io_control[5] ? _GEN_3170 : memory_74; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3429 = dec_io_control[5] ? _GEN_3171 : memory_75; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3430 = dec_io_control[5] ? _GEN_3172 : memory_76; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3431 = dec_io_control[5] ? _GEN_3173 : memory_77; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3432 = dec_io_control[5] ? _GEN_3174 : memory_78; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3433 = dec_io_control[5] ? _GEN_3175 : memory_79; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3434 = dec_io_control[5] ? _GEN_3176 : memory_80; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3435 = dec_io_control[5] ? _GEN_3177 : memory_81; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3436 = dec_io_control[5] ? _GEN_3178 : memory_82; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3437 = dec_io_control[5] ? _GEN_3179 : memory_83; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3438 = dec_io_control[5] ? _GEN_3180 : memory_84; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3439 = dec_io_control[5] ? _GEN_3181 : memory_85; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3440 = dec_io_control[5] ? _GEN_3182 : memory_86; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3441 = dec_io_control[5] ? _GEN_3183 : memory_87; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3442 = dec_io_control[5] ? _GEN_3184 : memory_88; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3443 = dec_io_control[5] ? _GEN_3185 : memory_89; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3444 = dec_io_control[5] ? _GEN_3186 : memory_90; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3445 = dec_io_control[5] ? _GEN_3187 : memory_91; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3446 = dec_io_control[5] ? _GEN_3188 : memory_92; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3447 = dec_io_control[5] ? _GEN_3189 : memory_93; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3448 = dec_io_control[5] ? _GEN_3190 : memory_94; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3449 = dec_io_control[5] ? _GEN_3191 : memory_95; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3450 = dec_io_control[5] ? _GEN_3192 : memory_96; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3451 = dec_io_control[5] ? _GEN_3193 : memory_97; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3452 = dec_io_control[5] ? _GEN_3194 : memory_98; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3453 = dec_io_control[5] ? _GEN_3195 : memory_99; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3454 = dec_io_control[5] ? _GEN_3196 : memory_100; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3455 = dec_io_control[5] ? _GEN_3197 : memory_101; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3456 = dec_io_control[5] ? _GEN_3198 : memory_102; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3457 = dec_io_control[5] ? _GEN_3199 : memory_103; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3458 = dec_io_control[5] ? _GEN_3200 : memory_104; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3459 = dec_io_control[5] ? _GEN_3201 : memory_105; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3460 = dec_io_control[5] ? _GEN_3202 : memory_106; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3461 = dec_io_control[5] ? _GEN_3203 : memory_107; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3462 = dec_io_control[5] ? _GEN_3204 : memory_108; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3463 = dec_io_control[5] ? _GEN_3205 : memory_109; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3464 = dec_io_control[5] ? _GEN_3206 : memory_110; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3465 = dec_io_control[5] ? _GEN_3207 : memory_111; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3466 = dec_io_control[5] ? _GEN_3208 : memory_112; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3467 = dec_io_control[5] ? _GEN_3209 : memory_113; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3468 = dec_io_control[5] ? _GEN_3210 : memory_114; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3469 = dec_io_control[5] ? _GEN_3211 : memory_115; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3470 = dec_io_control[5] ? _GEN_3212 : memory_116; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3471 = dec_io_control[5] ? _GEN_3213 : memory_117; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3472 = dec_io_control[5] ? _GEN_3214 : memory_118; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3473 = dec_io_control[5] ? _GEN_3215 : memory_119; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3474 = dec_io_control[5] ? _GEN_3216 : memory_120; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3475 = dec_io_control[5] ? _GEN_3217 : memory_121; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3476 = dec_io_control[5] ? _GEN_3218 : memory_122; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3477 = dec_io_control[5] ? _GEN_3219 : memory_123; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3478 = dec_io_control[5] ? _GEN_3220 : memory_124; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3479 = dec_io_control[5] ? _GEN_3221 : memory_125; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3480 = dec_io_control[5] ? _GEN_3222 : memory_126; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3481 = dec_io_control[5] ? _GEN_3223 : memory_127; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3482 = dec_io_control[5] ? _GEN_3224 : memory_128; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3483 = dec_io_control[5] ? _GEN_3225 : memory_129; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3484 = dec_io_control[5] ? _GEN_3226 : memory_130; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3485 = dec_io_control[5] ? _GEN_3227 : memory_131; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3486 = dec_io_control[5] ? _GEN_3228 : memory_132; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3487 = dec_io_control[5] ? _GEN_3229 : memory_133; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3488 = dec_io_control[5] ? _GEN_3230 : memory_134; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3489 = dec_io_control[5] ? _GEN_3231 : memory_135; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3490 = dec_io_control[5] ? _GEN_3232 : memory_136; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3491 = dec_io_control[5] ? _GEN_3233 : memory_137; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3492 = dec_io_control[5] ? _GEN_3234 : memory_138; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3493 = dec_io_control[5] ? _GEN_3235 : memory_139; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3494 = dec_io_control[5] ? _GEN_3236 : memory_140; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3495 = dec_io_control[5] ? _GEN_3237 : memory_141; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3496 = dec_io_control[5] ? _GEN_3238 : memory_142; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3497 = dec_io_control[5] ? _GEN_3239 : memory_143; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3498 = dec_io_control[5] ? _GEN_3240 : memory_144; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3499 = dec_io_control[5] ? _GEN_3241 : memory_145; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3500 = dec_io_control[5] ? _GEN_3242 : memory_146; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3501 = dec_io_control[5] ? _GEN_3243 : memory_147; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3502 = dec_io_control[5] ? _GEN_3244 : memory_148; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3503 = dec_io_control[5] ? _GEN_3245 : memory_149; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3504 = dec_io_control[5] ? _GEN_3246 : memory_150; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3505 = dec_io_control[5] ? _GEN_3247 : memory_151; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3506 = dec_io_control[5] ? _GEN_3248 : memory_152; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3507 = dec_io_control[5] ? _GEN_3249 : memory_153; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3508 = dec_io_control[5] ? _GEN_3250 : memory_154; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3509 = dec_io_control[5] ? _GEN_3251 : memory_155; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3510 = dec_io_control[5] ? _GEN_3252 : memory_156; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3511 = dec_io_control[5] ? _GEN_3253 : memory_157; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3512 = dec_io_control[5] ? _GEN_3254 : memory_158; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3513 = dec_io_control[5] ? _GEN_3255 : memory_159; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3514 = dec_io_control[5] ? _GEN_3256 : memory_160; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3515 = dec_io_control[5] ? _GEN_3257 : memory_161; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3516 = dec_io_control[5] ? _GEN_3258 : memory_162; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3517 = dec_io_control[5] ? _GEN_3259 : memory_163; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3518 = dec_io_control[5] ? _GEN_3260 : memory_164; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3519 = dec_io_control[5] ? _GEN_3261 : memory_165; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3520 = dec_io_control[5] ? _GEN_3262 : memory_166; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3521 = dec_io_control[5] ? _GEN_3263 : memory_167; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3522 = dec_io_control[5] ? _GEN_3264 : memory_168; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3523 = dec_io_control[5] ? _GEN_3265 : memory_169; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3524 = dec_io_control[5] ? _GEN_3266 : memory_170; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3525 = dec_io_control[5] ? _GEN_3267 : memory_171; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3526 = dec_io_control[5] ? _GEN_3268 : memory_172; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3527 = dec_io_control[5] ? _GEN_3269 : memory_173; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3528 = dec_io_control[5] ? _GEN_3270 : memory_174; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3529 = dec_io_control[5] ? _GEN_3271 : memory_175; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3530 = dec_io_control[5] ? _GEN_3272 : memory_176; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3531 = dec_io_control[5] ? _GEN_3273 : memory_177; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3532 = dec_io_control[5] ? _GEN_3274 : memory_178; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3533 = dec_io_control[5] ? _GEN_3275 : memory_179; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3534 = dec_io_control[5] ? _GEN_3276 : memory_180; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3535 = dec_io_control[5] ? _GEN_3277 : memory_181; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3536 = dec_io_control[5] ? _GEN_3278 : memory_182; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3537 = dec_io_control[5] ? _GEN_3279 : memory_183; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3538 = dec_io_control[5] ? _GEN_3280 : memory_184; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3539 = dec_io_control[5] ? _GEN_3281 : memory_185; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3540 = dec_io_control[5] ? _GEN_3282 : memory_186; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3541 = dec_io_control[5] ? _GEN_3283 : memory_187; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3542 = dec_io_control[5] ? _GEN_3284 : memory_188; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3543 = dec_io_control[5] ? _GEN_3285 : memory_189; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3544 = dec_io_control[5] ? _GEN_3286 : memory_190; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3545 = dec_io_control[5] ? _GEN_3287 : memory_191; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3546 = dec_io_control[5] ? _GEN_3288 : memory_192; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3547 = dec_io_control[5] ? _GEN_3289 : memory_193; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3548 = dec_io_control[5] ? _GEN_3290 : memory_194; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3549 = dec_io_control[5] ? _GEN_3291 : memory_195; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3550 = dec_io_control[5] ? _GEN_3292 : memory_196; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3551 = dec_io_control[5] ? _GEN_3293 : memory_197; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3552 = dec_io_control[5] ? _GEN_3294 : memory_198; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3553 = dec_io_control[5] ? _GEN_3295 : memory_199; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3554 = dec_io_control[5] ? _GEN_3296 : memory_200; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3555 = dec_io_control[5] ? _GEN_3297 : memory_201; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3556 = dec_io_control[5] ? _GEN_3298 : memory_202; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3557 = dec_io_control[5] ? _GEN_3299 : memory_203; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3558 = dec_io_control[5] ? _GEN_3300 : memory_204; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3559 = dec_io_control[5] ? _GEN_3301 : memory_205; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3560 = dec_io_control[5] ? _GEN_3302 : memory_206; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3561 = dec_io_control[5] ? _GEN_3303 : memory_207; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3562 = dec_io_control[5] ? _GEN_3304 : memory_208; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3563 = dec_io_control[5] ? _GEN_3305 : memory_209; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3564 = dec_io_control[5] ? _GEN_3306 : memory_210; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3565 = dec_io_control[5] ? _GEN_3307 : memory_211; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3566 = dec_io_control[5] ? _GEN_3308 : memory_212; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3567 = dec_io_control[5] ? _GEN_3309 : memory_213; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3568 = dec_io_control[5] ? _GEN_3310 : memory_214; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3569 = dec_io_control[5] ? _GEN_3311 : memory_215; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3570 = dec_io_control[5] ? _GEN_3312 : memory_216; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3571 = dec_io_control[5] ? _GEN_3313 : memory_217; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3572 = dec_io_control[5] ? _GEN_3314 : memory_218; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3573 = dec_io_control[5] ? _GEN_3315 : memory_219; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3574 = dec_io_control[5] ? _GEN_3316 : memory_220; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3575 = dec_io_control[5] ? _GEN_3317 : memory_221; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3576 = dec_io_control[5] ? _GEN_3318 : memory_222; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3577 = dec_io_control[5] ? _GEN_3319 : memory_223; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3578 = dec_io_control[5] ? _GEN_3320 : memory_224; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3579 = dec_io_control[5] ? _GEN_3321 : memory_225; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3580 = dec_io_control[5] ? _GEN_3322 : memory_226; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3581 = dec_io_control[5] ? _GEN_3323 : memory_227; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3582 = dec_io_control[5] ? _GEN_3324 : memory_228; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3583 = dec_io_control[5] ? _GEN_3325 : memory_229; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3584 = dec_io_control[5] ? _GEN_3326 : memory_230; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3585 = dec_io_control[5] ? _GEN_3327 : memory_231; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3586 = dec_io_control[5] ? _GEN_3328 : memory_232; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3587 = dec_io_control[5] ? _GEN_3329 : memory_233; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3588 = dec_io_control[5] ? _GEN_3330 : memory_234; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3589 = dec_io_control[5] ? _GEN_3331 : memory_235; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3590 = dec_io_control[5] ? _GEN_3332 : memory_236; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3591 = dec_io_control[5] ? _GEN_3333 : memory_237; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3592 = dec_io_control[5] ? _GEN_3334 : memory_238; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3593 = dec_io_control[5] ? _GEN_3335 : memory_239; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3594 = dec_io_control[5] ? _GEN_3336 : memory_240; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3595 = dec_io_control[5] ? _GEN_3337 : memory_241; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3596 = dec_io_control[5] ? _GEN_3338 : memory_242; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3597 = dec_io_control[5] ? _GEN_3339 : memory_243; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3598 = dec_io_control[5] ? _GEN_3340 : memory_244; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3599 = dec_io_control[5] ? _GEN_3341 : memory_245; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3600 = dec_io_control[5] ? _GEN_3342 : memory_246; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3601 = dec_io_control[5] ? _GEN_3343 : memory_247; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3602 = dec_io_control[5] ? _GEN_3344 : memory_248; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3603 = dec_io_control[5] ? _GEN_3345 : memory_249; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3604 = dec_io_control[5] ? _GEN_3346 : memory_250; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3605 = dec_io_control[5] ? _GEN_3347 : memory_251; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3606 = dec_io_control[5] ? _GEN_3348 : memory_252; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3607 = dec_io_control[5] ? _GEN_3349 : memory_253; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3608 = dec_io_control[5] ? _GEN_3350 : memory_254; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [7:0] _GEN_3609 = dec_io_control[5] ? _GEN_3351 : memory_255; // @[src/main/scala/SingleCycleCPU.scala 21:20 76:27]
  wire [15:0] _GEN_3610 = dec_io_control[5] ? _GEN_3352 : led; // @[src/main/scala/SingleCycleCPU.scala 22:17 76:27]
  wire [31:0] _GEN_3611 = dec_io_control[5] ? _GEN_3353 : display; // @[src/main/scala/SingleCycleCPU.scala 76:27 22:48]
  wire  _GEN_3612 = fault != 4'h0 | halted; // @[src/main/scala/SingleCycleCPU.scala 73:{20,27} 19:77]
  Decoder32 dec ( // @[src/main/scala/SingleCycleCPU.scala 23:16]
    .io_instruction(dec_io_instruction),
    .io_id(dec_io_id),
    .io_format(dec_io_format),
    .io_alu(dec_io_alu),
    .io_loadUnsigned(dec_io_loadUnsigned),
    .io_control(dec_io_control),
    .io_rd(dec_io_rd),
    .io_rs1(dec_io_rs1),
    .io_rs2(dec_io_rs2),
    .io_immediate(dec_io_immediate),
    .io_valid(dec_io_valid),
    .io_effectiveRegWrite(dec_io_effectiveRegWrite),
    .io_branchKind(dec_io_branchKind),
    .io_trapKind(dec_io_trapKind)
  );
  RegFile32 rf ( // @[src/main/scala/SingleCycleCPU.scala 23:45]
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
  ALU32 alu ( // @[src/main/scala/SingleCycleCPU.scala 23:75]
    .io_a(alu_io_a),
    .io_b(alu_io_b),
    .io_op(alu_io_op),
    .io_result(alu_io_result)
  );
  assign io_pc = pc; // @[src/main/scala/SingleCycleCPU.scala 82:7]
  assign io_retired = retired; // @[src/main/scala/SingleCycleCPU.scala 82:22]
  assign io_halted = halted; // @[src/main/scala/SingleCycleCPU.scala 82:41]
  assign io_reason = reason; // @[src/main/scala/SingleCycleCPU.scala 82:59]
  assign io_faultValue = faultValue; // @[src/main/scala/SingleCycleCPU.scala 82:81]
  assign io_registers_0 = 32'h0; // @[src/main/scala/SingleCycleCPU.scala 83:14]
  assign io_registers_1 = rf_io_saved_1; // @[src/main/scala/SingleCycleCPU.scala 83:14]
  assign io_registers_2 = rf_io_saved_2; // @[src/main/scala/SingleCycleCPU.scala 83:14]
  assign io_registers_3 = rf_io_saved_3; // @[src/main/scala/SingleCycleCPU.scala 83:14]
  assign io_registers_4 = rf_io_saved_4; // @[src/main/scala/SingleCycleCPU.scala 83:14]
  assign io_registers_5 = rf_io_saved_5; // @[src/main/scala/SingleCycleCPU.scala 83:14]
  assign io_registers_6 = rf_io_saved_6; // @[src/main/scala/SingleCycleCPU.scala 83:14]
  assign io_registers_7 = rf_io_saved_7; // @[src/main/scala/SingleCycleCPU.scala 83:14]
  assign io_registers_8 = rf_io_saved_8; // @[src/main/scala/SingleCycleCPU.scala 83:14]
  assign io_registers_9 = rf_io_saved_9; // @[src/main/scala/SingleCycleCPU.scala 83:14]
  assign io_registers_10 = rf_io_saved_10; // @[src/main/scala/SingleCycleCPU.scala 83:14]
  assign io_registers_11 = rf_io_saved_11; // @[src/main/scala/SingleCycleCPU.scala 83:14]
  assign io_registers_12 = rf_io_saved_12; // @[src/main/scala/SingleCycleCPU.scala 83:14]
  assign io_registers_13 = rf_io_saved_13; // @[src/main/scala/SingleCycleCPU.scala 83:14]
  assign io_registers_14 = rf_io_saved_14; // @[src/main/scala/SingleCycleCPU.scala 83:14]
  assign io_registers_15 = rf_io_saved_15; // @[src/main/scala/SingleCycleCPU.scala 83:14]
  assign io_registers_16 = rf_io_saved_16; // @[src/main/scala/SingleCycleCPU.scala 83:14]
  assign io_registers_17 = rf_io_saved_17; // @[src/main/scala/SingleCycleCPU.scala 83:14]
  assign io_registers_18 = rf_io_saved_18; // @[src/main/scala/SingleCycleCPU.scala 83:14]
  assign io_registers_19 = rf_io_saved_19; // @[src/main/scala/SingleCycleCPU.scala 83:14]
  assign io_registers_20 = rf_io_saved_20; // @[src/main/scala/SingleCycleCPU.scala 83:14]
  assign io_registers_21 = rf_io_saved_21; // @[src/main/scala/SingleCycleCPU.scala 83:14]
  assign io_registers_22 = rf_io_saved_22; // @[src/main/scala/SingleCycleCPU.scala 83:14]
  assign io_registers_23 = rf_io_saved_23; // @[src/main/scala/SingleCycleCPU.scala 83:14]
  assign io_registers_24 = rf_io_saved_24; // @[src/main/scala/SingleCycleCPU.scala 83:14]
  assign io_registers_25 = rf_io_saved_25; // @[src/main/scala/SingleCycleCPU.scala 83:14]
  assign io_registers_26 = rf_io_saved_26; // @[src/main/scala/SingleCycleCPU.scala 83:14]
  assign io_registers_27 = rf_io_saved_27; // @[src/main/scala/SingleCycleCPU.scala 83:14]
  assign io_registers_28 = rf_io_saved_28; // @[src/main/scala/SingleCycleCPU.scala 83:14]
  assign io_registers_29 = rf_io_saved_29; // @[src/main/scala/SingleCycleCPU.scala 83:14]
  assign io_registers_30 = rf_io_saved_30; // @[src/main/scala/SingleCycleCPU.scala 83:14]
  assign io_registers_31 = rf_io_saved_31; // @[src/main/scala/SingleCycleCPU.scala 83:14]
  assign io_memory_0 = memory_0; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_1 = memory_1; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_2 = memory_2; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_3 = memory_3; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_4 = memory_4; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_5 = memory_5; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_6 = memory_6; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_7 = memory_7; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_8 = memory_8; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_9 = memory_9; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_10 = memory_10; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_11 = memory_11; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_12 = memory_12; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_13 = memory_13; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_14 = memory_14; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_15 = memory_15; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_16 = memory_16; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_17 = memory_17; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_18 = memory_18; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_19 = memory_19; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_20 = memory_20; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_21 = memory_21; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_22 = memory_22; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_23 = memory_23; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_24 = memory_24; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_25 = memory_25; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_26 = memory_26; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_27 = memory_27; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_28 = memory_28; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_29 = memory_29; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_30 = memory_30; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_31 = memory_31; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_32 = memory_32; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_33 = memory_33; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_34 = memory_34; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_35 = memory_35; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_36 = memory_36; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_37 = memory_37; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_38 = memory_38; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_39 = memory_39; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_40 = memory_40; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_41 = memory_41; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_42 = memory_42; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_43 = memory_43; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_44 = memory_44; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_45 = memory_45; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_46 = memory_46; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_47 = memory_47; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_48 = memory_48; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_49 = memory_49; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_50 = memory_50; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_51 = memory_51; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_52 = memory_52; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_53 = memory_53; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_54 = memory_54; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_55 = memory_55; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_56 = memory_56; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_57 = memory_57; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_58 = memory_58; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_59 = memory_59; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_60 = memory_60; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_61 = memory_61; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_62 = memory_62; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_63 = memory_63; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_64 = memory_64; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_65 = memory_65; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_66 = memory_66; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_67 = memory_67; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_68 = memory_68; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_69 = memory_69; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_70 = memory_70; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_71 = memory_71; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_72 = memory_72; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_73 = memory_73; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_74 = memory_74; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_75 = memory_75; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_76 = memory_76; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_77 = memory_77; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_78 = memory_78; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_79 = memory_79; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_80 = memory_80; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_81 = memory_81; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_82 = memory_82; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_83 = memory_83; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_84 = memory_84; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_85 = memory_85; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_86 = memory_86; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_87 = memory_87; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_88 = memory_88; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_89 = memory_89; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_90 = memory_90; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_91 = memory_91; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_92 = memory_92; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_93 = memory_93; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_94 = memory_94; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_95 = memory_95; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_96 = memory_96; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_97 = memory_97; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_98 = memory_98; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_99 = memory_99; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_100 = memory_100; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_101 = memory_101; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_102 = memory_102; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_103 = memory_103; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_104 = memory_104; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_105 = memory_105; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_106 = memory_106; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_107 = memory_107; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_108 = memory_108; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_109 = memory_109; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_110 = memory_110; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_111 = memory_111; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_112 = memory_112; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_113 = memory_113; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_114 = memory_114; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_115 = memory_115; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_116 = memory_116; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_117 = memory_117; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_118 = memory_118; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_119 = memory_119; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_120 = memory_120; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_121 = memory_121; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_122 = memory_122; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_123 = memory_123; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_124 = memory_124; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_125 = memory_125; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_126 = memory_126; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_127 = memory_127; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_128 = memory_128; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_129 = memory_129; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_130 = memory_130; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_131 = memory_131; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_132 = memory_132; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_133 = memory_133; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_134 = memory_134; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_135 = memory_135; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_136 = memory_136; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_137 = memory_137; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_138 = memory_138; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_139 = memory_139; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_140 = memory_140; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_141 = memory_141; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_142 = memory_142; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_143 = memory_143; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_144 = memory_144; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_145 = memory_145; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_146 = memory_146; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_147 = memory_147; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_148 = memory_148; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_149 = memory_149; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_150 = memory_150; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_151 = memory_151; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_152 = memory_152; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_153 = memory_153; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_154 = memory_154; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_155 = memory_155; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_156 = memory_156; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_157 = memory_157; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_158 = memory_158; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_159 = memory_159; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_160 = memory_160; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_161 = memory_161; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_162 = memory_162; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_163 = memory_163; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_164 = memory_164; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_165 = memory_165; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_166 = memory_166; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_167 = memory_167; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_168 = memory_168; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_169 = memory_169; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_170 = memory_170; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_171 = memory_171; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_172 = memory_172; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_173 = memory_173; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_174 = memory_174; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_175 = memory_175; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_176 = memory_176; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_177 = memory_177; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_178 = memory_178; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_179 = memory_179; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_180 = memory_180; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_181 = memory_181; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_182 = memory_182; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_183 = memory_183; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_184 = memory_184; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_185 = memory_185; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_186 = memory_186; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_187 = memory_187; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_188 = memory_188; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_189 = memory_189; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_190 = memory_190; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_191 = memory_191; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_192 = memory_192; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_193 = memory_193; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_194 = memory_194; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_195 = memory_195; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_196 = memory_196; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_197 = memory_197; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_198 = memory_198; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_199 = memory_199; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_200 = memory_200; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_201 = memory_201; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_202 = memory_202; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_203 = memory_203; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_204 = memory_204; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_205 = memory_205; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_206 = memory_206; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_207 = memory_207; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_208 = memory_208; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_209 = memory_209; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_210 = memory_210; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_211 = memory_211; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_212 = memory_212; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_213 = memory_213; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_214 = memory_214; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_215 = memory_215; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_216 = memory_216; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_217 = memory_217; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_218 = memory_218; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_219 = memory_219; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_220 = memory_220; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_221 = memory_221; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_222 = memory_222; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_223 = memory_223; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_224 = memory_224; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_225 = memory_225; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_226 = memory_226; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_227 = memory_227; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_228 = memory_228; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_229 = memory_229; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_230 = memory_230; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_231 = memory_231; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_232 = memory_232; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_233 = memory_233; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_234 = memory_234; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_235 = memory_235; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_236 = memory_236; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_237 = memory_237; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_238 = memory_238; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_239 = memory_239; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_240 = memory_240; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_241 = memory_241; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_242 = memory_242; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_243 = memory_243; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_244 = memory_244; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_245 = memory_245; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_246 = memory_246; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_247 = memory_247; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_248 = memory_248; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_249 = memory_249; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_250 = memory_250; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_251 = memory_251; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_252 = memory_252; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_253 = memory_253; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_254 = memory_254; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_memory_255 = memory_255; // @[src/main/scala/SingleCycleCPU.scala 83:37]
  assign io_led = led; // @[src/main/scala/SingleCycleCPU.scala 83:52]
  assign io_display = display; // @[src/main/scala/SingleCycleCPU.scala 83:68]
  assign io_candidate = 2'h1 == dec_io_control[13:12] ? load : _GEN_1031; // @[src/main/scala/SingleCycleCPU.scala 56:31 57:13]
  assign io_nextPC = taken ? target : _nextPC_T_1; // @[src/main/scala/SingleCycleCPU.scala 40:16]
  assign io_commit = io_step & ~io_clear & ~reset & ~halted & fault == 4'h0; // @[src/main/scala/SingleCycleCPU.scala 67:58]
  assign dec_io_instruction = io_instruction; // @[src/main/scala/SingleCycleCPU.scala 24:20]
  assign rf_clock = clock;
  assign rf_reset = reset;
  assign rf_io_ra = dec_io_control[1] ? dec_io_rs1 : 5'h0; // @[src/main/scala/SingleCycleCPU.scala 25:15]
  assign rf_io_rb = dec_io_control[2] ? dec_io_rs2 : 5'h0; // @[src/main/scala/SingleCycleCPU.scala 25:63]
  assign rf_io_wa = dec_io_rd; // @[src/main/scala/SingleCycleCPU.scala 26:10]
  assign rf_io_wd = 2'h1 == dec_io_control[13:12] ? load : _GEN_1031; // @[src/main/scala/SingleCycleCPU.scala 56:31 57:13]
  assign rf_io_we = commit & dec_io_effectiveRegWrite; // @[src/main/scala/SingleCycleCPU.scala 68:18]
  assign rf_io_clear = io_clear; // @[src/main/scala/SingleCycleCPU.scala 26:33]
  assign alu_io_a = dec_io_control[9] ? pc : rf_io_rawA; // @[src/main/scala/SingleCycleCPU.scala 27:15]
  assign alu_io_b = dec_io_control[8] ? dec_io_immediate : rf_io_rawB; // @[src/main/scala/SingleCycleCPU.scala 28:15]
  assign alu_io_op = dec_io_alu; // @[src/main/scala/SingleCycleCPU.scala 28:72]
  always @(posedge clock) begin
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 19:{16,16}]
      pc <= 32'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 70:5]
      pc <= 32'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 19:16 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 19:16]
        pc <= nextPC; // @[src/main/scala/SingleCycleCPU.scala 75:6]
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 19:{47,47}]
      retired <= 32'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 70:18]
      retired <= 32'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 72:31 19:47]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 73:20]
        retired <= _retired_T_1; // @[src/main/scala/SingleCycleCPU.scala 75:22]
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 19:{77,77}]
      halted <= 1'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 70:30]
      halted <= 1'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 72:31 19:77]
      halted <= _GEN_3612;
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 20:{20,20}]
      reason <= 4'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 70:46]
      reason <= 4'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 20:20 72:31]
      if (fault != 4'h0) begin // @[src/main/scala/SingleCycleCPU.scala 20:20]
        reason <= fault; // @[src/main/scala/SingleCycleCPU.scala 73:20]
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 20:{53,53}]
      faultValue <= 32'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 70:62]
      faultValue <= 32'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 72:31 20:53]
      if (fault != 4'h0) begin // @[src/main/scala/SingleCycleCPU.scala 73:20]
        faultValue <= value; // @[src/main/scala/SingleCycleCPU.scala 20:53]
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_0 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_0 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_0 <= _GEN_3354;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_1 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_1 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_1 <= _GEN_3355;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_2 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_2 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_2 <= _GEN_3356;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_3 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_3 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_3 <= _GEN_3357;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_4 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_4 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_4 <= _GEN_3358;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_5 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_5 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_5 <= _GEN_3359;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_6 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_6 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_6 <= _GEN_3360;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_7 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_7 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_7 <= _GEN_3361;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_8 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_8 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_8 <= _GEN_3362;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_9 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_9 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_9 <= _GEN_3363;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_10 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_10 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_10 <= _GEN_3364;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_11 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_11 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_11 <= _GEN_3365;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_12 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_12 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_12 <= _GEN_3366;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_13 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_13 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_13 <= _GEN_3367;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_14 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_14 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_14 <= _GEN_3368;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_15 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_15 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_15 <= _GEN_3369;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_16 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_16 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_16 <= _GEN_3370;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_17 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_17 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_17 <= _GEN_3371;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_18 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_18 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_18 <= _GEN_3372;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_19 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_19 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_19 <= _GEN_3373;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_20 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_20 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_20 <= _GEN_3374;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_21 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_21 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_21 <= _GEN_3375;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_22 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_22 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_22 <= _GEN_3376;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_23 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_23 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_23 <= _GEN_3377;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_24 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_24 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_24 <= _GEN_3378;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_25 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_25 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_25 <= _GEN_3379;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_26 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_26 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_26 <= _GEN_3380;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_27 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_27 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_27 <= _GEN_3381;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_28 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_28 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_28 <= _GEN_3382;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_29 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_29 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_29 <= _GEN_3383;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_30 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_30 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_30 <= _GEN_3384;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_31 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_31 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_31 <= _GEN_3385;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_32 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_32 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_32 <= _GEN_3386;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_33 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_33 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_33 <= _GEN_3387;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_34 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_34 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_34 <= _GEN_3388;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_35 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_35 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_35 <= _GEN_3389;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_36 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_36 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_36 <= _GEN_3390;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_37 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_37 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_37 <= _GEN_3391;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_38 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_38 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_38 <= _GEN_3392;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_39 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_39 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_39 <= _GEN_3393;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_40 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_40 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_40 <= _GEN_3394;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_41 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_41 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_41 <= _GEN_3395;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_42 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_42 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_42 <= _GEN_3396;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_43 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_43 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_43 <= _GEN_3397;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_44 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_44 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_44 <= _GEN_3398;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_45 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_45 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_45 <= _GEN_3399;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_46 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_46 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_46 <= _GEN_3400;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_47 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_47 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_47 <= _GEN_3401;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_48 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_48 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_48 <= _GEN_3402;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_49 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_49 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_49 <= _GEN_3403;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_50 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_50 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_50 <= _GEN_3404;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_51 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_51 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_51 <= _GEN_3405;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_52 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_52 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_52 <= _GEN_3406;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_53 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_53 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_53 <= _GEN_3407;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_54 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_54 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_54 <= _GEN_3408;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_55 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_55 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_55 <= _GEN_3409;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_56 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_56 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_56 <= _GEN_3410;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_57 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_57 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_57 <= _GEN_3411;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_58 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_58 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_58 <= _GEN_3412;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_59 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_59 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_59 <= _GEN_3413;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_60 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_60 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_60 <= _GEN_3414;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_61 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_61 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_61 <= _GEN_3415;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_62 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_62 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_62 <= _GEN_3416;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_63 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_63 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_63 <= _GEN_3417;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_64 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_64 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_64 <= _GEN_3418;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_65 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_65 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_65 <= _GEN_3419;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_66 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_66 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_66 <= _GEN_3420;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_67 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_67 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_67 <= _GEN_3421;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_68 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_68 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_68 <= _GEN_3422;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_69 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_69 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_69 <= _GEN_3423;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_70 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_70 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_70 <= _GEN_3424;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_71 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_71 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_71 <= _GEN_3425;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_72 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_72 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_72 <= _GEN_3426;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_73 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_73 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_73 <= _GEN_3427;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_74 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_74 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_74 <= _GEN_3428;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_75 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_75 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_75 <= _GEN_3429;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_76 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_76 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_76 <= _GEN_3430;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_77 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_77 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_77 <= _GEN_3431;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_78 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_78 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_78 <= _GEN_3432;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_79 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_79 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_79 <= _GEN_3433;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_80 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_80 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_80 <= _GEN_3434;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_81 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_81 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_81 <= _GEN_3435;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_82 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_82 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_82 <= _GEN_3436;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_83 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_83 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_83 <= _GEN_3437;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_84 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_84 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_84 <= _GEN_3438;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_85 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_85 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_85 <= _GEN_3439;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_86 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_86 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_86 <= _GEN_3440;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_87 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_87 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_87 <= _GEN_3441;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_88 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_88 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_88 <= _GEN_3442;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_89 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_89 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_89 <= _GEN_3443;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_90 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_90 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_90 <= _GEN_3444;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_91 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_91 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_91 <= _GEN_3445;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_92 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_92 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_92 <= _GEN_3446;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_93 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_93 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_93 <= _GEN_3447;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_94 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_94 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_94 <= _GEN_3448;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_95 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_95 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_95 <= _GEN_3449;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_96 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_96 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_96 <= _GEN_3450;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_97 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_97 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_97 <= _GEN_3451;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_98 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_98 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_98 <= _GEN_3452;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_99 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_99 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_99 <= _GEN_3453;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_100 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_100 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_100 <= _GEN_3454;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_101 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_101 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_101 <= _GEN_3455;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_102 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_102 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_102 <= _GEN_3456;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_103 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_103 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_103 <= _GEN_3457;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_104 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_104 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_104 <= _GEN_3458;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_105 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_105 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_105 <= _GEN_3459;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_106 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_106 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_106 <= _GEN_3460;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_107 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_107 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_107 <= _GEN_3461;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_108 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_108 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_108 <= _GEN_3462;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_109 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_109 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_109 <= _GEN_3463;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_110 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_110 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_110 <= _GEN_3464;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_111 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_111 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_111 <= _GEN_3465;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_112 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_112 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_112 <= _GEN_3466;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_113 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_113 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_113 <= _GEN_3467;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_114 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_114 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_114 <= _GEN_3468;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_115 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_115 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_115 <= _GEN_3469;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_116 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_116 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_116 <= _GEN_3470;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_117 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_117 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_117 <= _GEN_3471;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_118 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_118 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_118 <= _GEN_3472;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_119 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_119 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_119 <= _GEN_3473;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_120 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_120 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_120 <= _GEN_3474;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_121 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_121 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_121 <= _GEN_3475;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_122 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_122 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_122 <= _GEN_3476;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_123 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_123 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_123 <= _GEN_3477;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_124 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_124 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_124 <= _GEN_3478;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_125 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_125 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_125 <= _GEN_3479;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_126 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_126 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_126 <= _GEN_3480;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_127 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_127 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_127 <= _GEN_3481;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_128 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_128 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_128 <= _GEN_3482;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_129 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_129 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_129 <= _GEN_3483;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_130 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_130 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_130 <= _GEN_3484;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_131 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_131 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_131 <= _GEN_3485;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_132 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_132 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_132 <= _GEN_3486;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_133 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_133 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_133 <= _GEN_3487;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_134 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_134 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_134 <= _GEN_3488;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_135 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_135 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_135 <= _GEN_3489;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_136 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_136 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_136 <= _GEN_3490;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_137 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_137 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_137 <= _GEN_3491;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_138 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_138 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_138 <= _GEN_3492;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_139 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_139 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_139 <= _GEN_3493;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_140 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_140 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_140 <= _GEN_3494;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_141 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_141 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_141 <= _GEN_3495;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_142 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_142 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_142 <= _GEN_3496;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_143 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_143 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_143 <= _GEN_3497;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_144 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_144 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_144 <= _GEN_3498;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_145 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_145 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_145 <= _GEN_3499;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_146 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_146 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_146 <= _GEN_3500;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_147 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_147 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_147 <= _GEN_3501;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_148 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_148 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_148 <= _GEN_3502;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_149 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_149 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_149 <= _GEN_3503;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_150 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_150 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_150 <= _GEN_3504;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_151 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_151 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_151 <= _GEN_3505;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_152 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_152 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_152 <= _GEN_3506;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_153 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_153 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_153 <= _GEN_3507;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_154 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_154 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_154 <= _GEN_3508;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_155 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_155 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_155 <= _GEN_3509;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_156 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_156 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_156 <= _GEN_3510;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_157 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_157 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_157 <= _GEN_3511;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_158 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_158 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_158 <= _GEN_3512;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_159 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_159 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_159 <= _GEN_3513;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_160 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_160 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_160 <= _GEN_3514;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_161 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_161 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_161 <= _GEN_3515;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_162 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_162 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_162 <= _GEN_3516;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_163 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_163 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_163 <= _GEN_3517;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_164 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_164 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_164 <= _GEN_3518;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_165 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_165 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_165 <= _GEN_3519;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_166 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_166 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_166 <= _GEN_3520;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_167 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_167 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_167 <= _GEN_3521;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_168 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_168 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_168 <= _GEN_3522;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_169 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_169 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_169 <= _GEN_3523;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_170 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_170 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_170 <= _GEN_3524;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_171 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_171 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_171 <= _GEN_3525;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_172 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_172 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_172 <= _GEN_3526;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_173 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_173 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_173 <= _GEN_3527;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_174 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_174 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_174 <= _GEN_3528;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_175 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_175 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_175 <= _GEN_3529;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_176 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_176 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_176 <= _GEN_3530;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_177 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_177 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_177 <= _GEN_3531;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_178 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_178 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_178 <= _GEN_3532;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_179 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_179 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_179 <= _GEN_3533;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_180 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_180 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_180 <= _GEN_3534;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_181 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_181 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_181 <= _GEN_3535;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_182 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_182 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_182 <= _GEN_3536;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_183 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_183 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_183 <= _GEN_3537;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_184 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_184 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_184 <= _GEN_3538;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_185 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_185 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_185 <= _GEN_3539;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_186 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_186 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_186 <= _GEN_3540;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_187 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_187 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_187 <= _GEN_3541;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_188 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_188 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_188 <= _GEN_3542;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_189 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_189 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_189 <= _GEN_3543;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_190 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_190 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_190 <= _GEN_3544;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_191 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_191 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_191 <= _GEN_3545;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_192 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_192 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_192 <= _GEN_3546;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_193 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_193 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_193 <= _GEN_3547;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_194 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_194 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_194 <= _GEN_3548;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_195 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_195 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_195 <= _GEN_3549;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_196 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_196 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_196 <= _GEN_3550;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_197 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_197 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_197 <= _GEN_3551;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_198 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_198 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_198 <= _GEN_3552;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_199 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_199 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_199 <= _GEN_3553;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_200 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_200 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_200 <= _GEN_3554;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_201 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_201 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_201 <= _GEN_3555;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_202 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_202 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_202 <= _GEN_3556;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_203 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_203 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_203 <= _GEN_3557;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_204 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_204 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_204 <= _GEN_3558;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_205 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_205 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_205 <= _GEN_3559;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_206 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_206 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_206 <= _GEN_3560;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_207 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_207 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_207 <= _GEN_3561;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_208 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_208 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_208 <= _GEN_3562;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_209 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_209 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_209 <= _GEN_3563;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_210 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_210 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_210 <= _GEN_3564;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_211 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_211 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_211 <= _GEN_3565;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_212 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_212 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_212 <= _GEN_3566;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_213 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_213 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_213 <= _GEN_3567;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_214 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_214 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_214 <= _GEN_3568;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_215 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_215 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_215 <= _GEN_3569;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_216 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_216 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_216 <= _GEN_3570;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_217 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_217 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_217 <= _GEN_3571;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_218 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_218 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_218 <= _GEN_3572;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_219 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_219 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_219 <= _GEN_3573;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_220 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_220 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_220 <= _GEN_3574;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_221 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_221 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_221 <= _GEN_3575;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_222 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_222 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_222 <= _GEN_3576;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_223 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_223 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_223 <= _GEN_3577;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_224 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_224 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_224 <= _GEN_3578;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_225 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_225 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_225 <= _GEN_3579;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_226 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_226 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_226 <= _GEN_3580;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_227 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_227 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_227 <= _GEN_3581;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_228 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_228 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_228 <= _GEN_3582;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_229 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_229 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_229 <= _GEN_3583;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_230 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_230 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_230 <= _GEN_3584;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_231 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_231 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_231 <= _GEN_3585;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_232 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_232 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_232 <= _GEN_3586;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_233 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_233 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_233 <= _GEN_3587;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_234 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_234 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_234 <= _GEN_3588;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_235 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_235 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_235 <= _GEN_3589;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_236 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_236 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_236 <= _GEN_3590;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_237 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_237 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_237 <= _GEN_3591;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_238 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_238 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_238 <= _GEN_3592;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_239 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_239 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_239 <= _GEN_3593;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_240 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_240 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_240 <= _GEN_3594;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_241 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_241 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_241 <= _GEN_3595;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_242 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_242 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_242 <= _GEN_3596;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_243 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_243 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_243 <= _GEN_3597;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_244 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_244 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_244 <= _GEN_3598;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_245 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_245 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_245 <= _GEN_3599;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_246 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_246 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_246 <= _GEN_3600;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_247 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_247 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_247 <= _GEN_3601;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_248 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_248 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_248 <= _GEN_3602;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_249 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_249 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_249 <= _GEN_3603;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_250 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_250 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_250 <= _GEN_3604;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_251 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_251 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_251 <= _GEN_3605;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_252 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_252 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_252 <= _GEN_3606;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_253 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_253 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_253 <= _GEN_3607;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_254 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_254 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_254 <= _GEN_3608;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 21:{20,20}]
      memory_255 <= 8'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 71:19]
      memory_255 <= 8'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 21:20 73:20]
        memory_255 <= _GEN_3609;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 22:{17,17}]
      led <= 16'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 70:71]
      led <= 16'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 22:17 72:31]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 22:17 73:20]
        led <= _GEN_3610;
      end
    end
    if (reset) begin // @[src/main/scala/SingleCycleCPU.scala 22:{48,48}]
      display <= 32'h0;
    end else if (io_clear) begin // @[src/main/scala/SingleCycleCPU.scala 69:16 70:84]
      display <= 32'h0;
    end else if (io_step & _commit_T_4) begin // @[src/main/scala/SingleCycleCPU.scala 72:31 22:48]
      if (!(fault != 4'h0)) begin // @[src/main/scala/SingleCycleCPU.scala 73:20 22:48]
        display <= _GEN_3611;
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
  reason = _RAND_3[3:0];
  _RAND_4 = {1{`RANDOM}};
  faultValue = _RAND_4[31:0];
  _RAND_5 = {1{`RANDOM}};
  memory_0 = _RAND_5[7:0];
  _RAND_6 = {1{`RANDOM}};
  memory_1 = _RAND_6[7:0];
  _RAND_7 = {1{`RANDOM}};
  memory_2 = _RAND_7[7:0];
  _RAND_8 = {1{`RANDOM}};
  memory_3 = _RAND_8[7:0];
  _RAND_9 = {1{`RANDOM}};
  memory_4 = _RAND_9[7:0];
  _RAND_10 = {1{`RANDOM}};
  memory_5 = _RAND_10[7:0];
  _RAND_11 = {1{`RANDOM}};
  memory_6 = _RAND_11[7:0];
  _RAND_12 = {1{`RANDOM}};
  memory_7 = _RAND_12[7:0];
  _RAND_13 = {1{`RANDOM}};
  memory_8 = _RAND_13[7:0];
  _RAND_14 = {1{`RANDOM}};
  memory_9 = _RAND_14[7:0];
  _RAND_15 = {1{`RANDOM}};
  memory_10 = _RAND_15[7:0];
  _RAND_16 = {1{`RANDOM}};
  memory_11 = _RAND_16[7:0];
  _RAND_17 = {1{`RANDOM}};
  memory_12 = _RAND_17[7:0];
  _RAND_18 = {1{`RANDOM}};
  memory_13 = _RAND_18[7:0];
  _RAND_19 = {1{`RANDOM}};
  memory_14 = _RAND_19[7:0];
  _RAND_20 = {1{`RANDOM}};
  memory_15 = _RAND_20[7:0];
  _RAND_21 = {1{`RANDOM}};
  memory_16 = _RAND_21[7:0];
  _RAND_22 = {1{`RANDOM}};
  memory_17 = _RAND_22[7:0];
  _RAND_23 = {1{`RANDOM}};
  memory_18 = _RAND_23[7:0];
  _RAND_24 = {1{`RANDOM}};
  memory_19 = _RAND_24[7:0];
  _RAND_25 = {1{`RANDOM}};
  memory_20 = _RAND_25[7:0];
  _RAND_26 = {1{`RANDOM}};
  memory_21 = _RAND_26[7:0];
  _RAND_27 = {1{`RANDOM}};
  memory_22 = _RAND_27[7:0];
  _RAND_28 = {1{`RANDOM}};
  memory_23 = _RAND_28[7:0];
  _RAND_29 = {1{`RANDOM}};
  memory_24 = _RAND_29[7:0];
  _RAND_30 = {1{`RANDOM}};
  memory_25 = _RAND_30[7:0];
  _RAND_31 = {1{`RANDOM}};
  memory_26 = _RAND_31[7:0];
  _RAND_32 = {1{`RANDOM}};
  memory_27 = _RAND_32[7:0];
  _RAND_33 = {1{`RANDOM}};
  memory_28 = _RAND_33[7:0];
  _RAND_34 = {1{`RANDOM}};
  memory_29 = _RAND_34[7:0];
  _RAND_35 = {1{`RANDOM}};
  memory_30 = _RAND_35[7:0];
  _RAND_36 = {1{`RANDOM}};
  memory_31 = _RAND_36[7:0];
  _RAND_37 = {1{`RANDOM}};
  memory_32 = _RAND_37[7:0];
  _RAND_38 = {1{`RANDOM}};
  memory_33 = _RAND_38[7:0];
  _RAND_39 = {1{`RANDOM}};
  memory_34 = _RAND_39[7:0];
  _RAND_40 = {1{`RANDOM}};
  memory_35 = _RAND_40[7:0];
  _RAND_41 = {1{`RANDOM}};
  memory_36 = _RAND_41[7:0];
  _RAND_42 = {1{`RANDOM}};
  memory_37 = _RAND_42[7:0];
  _RAND_43 = {1{`RANDOM}};
  memory_38 = _RAND_43[7:0];
  _RAND_44 = {1{`RANDOM}};
  memory_39 = _RAND_44[7:0];
  _RAND_45 = {1{`RANDOM}};
  memory_40 = _RAND_45[7:0];
  _RAND_46 = {1{`RANDOM}};
  memory_41 = _RAND_46[7:0];
  _RAND_47 = {1{`RANDOM}};
  memory_42 = _RAND_47[7:0];
  _RAND_48 = {1{`RANDOM}};
  memory_43 = _RAND_48[7:0];
  _RAND_49 = {1{`RANDOM}};
  memory_44 = _RAND_49[7:0];
  _RAND_50 = {1{`RANDOM}};
  memory_45 = _RAND_50[7:0];
  _RAND_51 = {1{`RANDOM}};
  memory_46 = _RAND_51[7:0];
  _RAND_52 = {1{`RANDOM}};
  memory_47 = _RAND_52[7:0];
  _RAND_53 = {1{`RANDOM}};
  memory_48 = _RAND_53[7:0];
  _RAND_54 = {1{`RANDOM}};
  memory_49 = _RAND_54[7:0];
  _RAND_55 = {1{`RANDOM}};
  memory_50 = _RAND_55[7:0];
  _RAND_56 = {1{`RANDOM}};
  memory_51 = _RAND_56[7:0];
  _RAND_57 = {1{`RANDOM}};
  memory_52 = _RAND_57[7:0];
  _RAND_58 = {1{`RANDOM}};
  memory_53 = _RAND_58[7:0];
  _RAND_59 = {1{`RANDOM}};
  memory_54 = _RAND_59[7:0];
  _RAND_60 = {1{`RANDOM}};
  memory_55 = _RAND_60[7:0];
  _RAND_61 = {1{`RANDOM}};
  memory_56 = _RAND_61[7:0];
  _RAND_62 = {1{`RANDOM}};
  memory_57 = _RAND_62[7:0];
  _RAND_63 = {1{`RANDOM}};
  memory_58 = _RAND_63[7:0];
  _RAND_64 = {1{`RANDOM}};
  memory_59 = _RAND_64[7:0];
  _RAND_65 = {1{`RANDOM}};
  memory_60 = _RAND_65[7:0];
  _RAND_66 = {1{`RANDOM}};
  memory_61 = _RAND_66[7:0];
  _RAND_67 = {1{`RANDOM}};
  memory_62 = _RAND_67[7:0];
  _RAND_68 = {1{`RANDOM}};
  memory_63 = _RAND_68[7:0];
  _RAND_69 = {1{`RANDOM}};
  memory_64 = _RAND_69[7:0];
  _RAND_70 = {1{`RANDOM}};
  memory_65 = _RAND_70[7:0];
  _RAND_71 = {1{`RANDOM}};
  memory_66 = _RAND_71[7:0];
  _RAND_72 = {1{`RANDOM}};
  memory_67 = _RAND_72[7:0];
  _RAND_73 = {1{`RANDOM}};
  memory_68 = _RAND_73[7:0];
  _RAND_74 = {1{`RANDOM}};
  memory_69 = _RAND_74[7:0];
  _RAND_75 = {1{`RANDOM}};
  memory_70 = _RAND_75[7:0];
  _RAND_76 = {1{`RANDOM}};
  memory_71 = _RAND_76[7:0];
  _RAND_77 = {1{`RANDOM}};
  memory_72 = _RAND_77[7:0];
  _RAND_78 = {1{`RANDOM}};
  memory_73 = _RAND_78[7:0];
  _RAND_79 = {1{`RANDOM}};
  memory_74 = _RAND_79[7:0];
  _RAND_80 = {1{`RANDOM}};
  memory_75 = _RAND_80[7:0];
  _RAND_81 = {1{`RANDOM}};
  memory_76 = _RAND_81[7:0];
  _RAND_82 = {1{`RANDOM}};
  memory_77 = _RAND_82[7:0];
  _RAND_83 = {1{`RANDOM}};
  memory_78 = _RAND_83[7:0];
  _RAND_84 = {1{`RANDOM}};
  memory_79 = _RAND_84[7:0];
  _RAND_85 = {1{`RANDOM}};
  memory_80 = _RAND_85[7:0];
  _RAND_86 = {1{`RANDOM}};
  memory_81 = _RAND_86[7:0];
  _RAND_87 = {1{`RANDOM}};
  memory_82 = _RAND_87[7:0];
  _RAND_88 = {1{`RANDOM}};
  memory_83 = _RAND_88[7:0];
  _RAND_89 = {1{`RANDOM}};
  memory_84 = _RAND_89[7:0];
  _RAND_90 = {1{`RANDOM}};
  memory_85 = _RAND_90[7:0];
  _RAND_91 = {1{`RANDOM}};
  memory_86 = _RAND_91[7:0];
  _RAND_92 = {1{`RANDOM}};
  memory_87 = _RAND_92[7:0];
  _RAND_93 = {1{`RANDOM}};
  memory_88 = _RAND_93[7:0];
  _RAND_94 = {1{`RANDOM}};
  memory_89 = _RAND_94[7:0];
  _RAND_95 = {1{`RANDOM}};
  memory_90 = _RAND_95[7:0];
  _RAND_96 = {1{`RANDOM}};
  memory_91 = _RAND_96[7:0];
  _RAND_97 = {1{`RANDOM}};
  memory_92 = _RAND_97[7:0];
  _RAND_98 = {1{`RANDOM}};
  memory_93 = _RAND_98[7:0];
  _RAND_99 = {1{`RANDOM}};
  memory_94 = _RAND_99[7:0];
  _RAND_100 = {1{`RANDOM}};
  memory_95 = _RAND_100[7:0];
  _RAND_101 = {1{`RANDOM}};
  memory_96 = _RAND_101[7:0];
  _RAND_102 = {1{`RANDOM}};
  memory_97 = _RAND_102[7:0];
  _RAND_103 = {1{`RANDOM}};
  memory_98 = _RAND_103[7:0];
  _RAND_104 = {1{`RANDOM}};
  memory_99 = _RAND_104[7:0];
  _RAND_105 = {1{`RANDOM}};
  memory_100 = _RAND_105[7:0];
  _RAND_106 = {1{`RANDOM}};
  memory_101 = _RAND_106[7:0];
  _RAND_107 = {1{`RANDOM}};
  memory_102 = _RAND_107[7:0];
  _RAND_108 = {1{`RANDOM}};
  memory_103 = _RAND_108[7:0];
  _RAND_109 = {1{`RANDOM}};
  memory_104 = _RAND_109[7:0];
  _RAND_110 = {1{`RANDOM}};
  memory_105 = _RAND_110[7:0];
  _RAND_111 = {1{`RANDOM}};
  memory_106 = _RAND_111[7:0];
  _RAND_112 = {1{`RANDOM}};
  memory_107 = _RAND_112[7:0];
  _RAND_113 = {1{`RANDOM}};
  memory_108 = _RAND_113[7:0];
  _RAND_114 = {1{`RANDOM}};
  memory_109 = _RAND_114[7:0];
  _RAND_115 = {1{`RANDOM}};
  memory_110 = _RAND_115[7:0];
  _RAND_116 = {1{`RANDOM}};
  memory_111 = _RAND_116[7:0];
  _RAND_117 = {1{`RANDOM}};
  memory_112 = _RAND_117[7:0];
  _RAND_118 = {1{`RANDOM}};
  memory_113 = _RAND_118[7:0];
  _RAND_119 = {1{`RANDOM}};
  memory_114 = _RAND_119[7:0];
  _RAND_120 = {1{`RANDOM}};
  memory_115 = _RAND_120[7:0];
  _RAND_121 = {1{`RANDOM}};
  memory_116 = _RAND_121[7:0];
  _RAND_122 = {1{`RANDOM}};
  memory_117 = _RAND_122[7:0];
  _RAND_123 = {1{`RANDOM}};
  memory_118 = _RAND_123[7:0];
  _RAND_124 = {1{`RANDOM}};
  memory_119 = _RAND_124[7:0];
  _RAND_125 = {1{`RANDOM}};
  memory_120 = _RAND_125[7:0];
  _RAND_126 = {1{`RANDOM}};
  memory_121 = _RAND_126[7:0];
  _RAND_127 = {1{`RANDOM}};
  memory_122 = _RAND_127[7:0];
  _RAND_128 = {1{`RANDOM}};
  memory_123 = _RAND_128[7:0];
  _RAND_129 = {1{`RANDOM}};
  memory_124 = _RAND_129[7:0];
  _RAND_130 = {1{`RANDOM}};
  memory_125 = _RAND_130[7:0];
  _RAND_131 = {1{`RANDOM}};
  memory_126 = _RAND_131[7:0];
  _RAND_132 = {1{`RANDOM}};
  memory_127 = _RAND_132[7:0];
  _RAND_133 = {1{`RANDOM}};
  memory_128 = _RAND_133[7:0];
  _RAND_134 = {1{`RANDOM}};
  memory_129 = _RAND_134[7:0];
  _RAND_135 = {1{`RANDOM}};
  memory_130 = _RAND_135[7:0];
  _RAND_136 = {1{`RANDOM}};
  memory_131 = _RAND_136[7:0];
  _RAND_137 = {1{`RANDOM}};
  memory_132 = _RAND_137[7:0];
  _RAND_138 = {1{`RANDOM}};
  memory_133 = _RAND_138[7:0];
  _RAND_139 = {1{`RANDOM}};
  memory_134 = _RAND_139[7:0];
  _RAND_140 = {1{`RANDOM}};
  memory_135 = _RAND_140[7:0];
  _RAND_141 = {1{`RANDOM}};
  memory_136 = _RAND_141[7:0];
  _RAND_142 = {1{`RANDOM}};
  memory_137 = _RAND_142[7:0];
  _RAND_143 = {1{`RANDOM}};
  memory_138 = _RAND_143[7:0];
  _RAND_144 = {1{`RANDOM}};
  memory_139 = _RAND_144[7:0];
  _RAND_145 = {1{`RANDOM}};
  memory_140 = _RAND_145[7:0];
  _RAND_146 = {1{`RANDOM}};
  memory_141 = _RAND_146[7:0];
  _RAND_147 = {1{`RANDOM}};
  memory_142 = _RAND_147[7:0];
  _RAND_148 = {1{`RANDOM}};
  memory_143 = _RAND_148[7:0];
  _RAND_149 = {1{`RANDOM}};
  memory_144 = _RAND_149[7:0];
  _RAND_150 = {1{`RANDOM}};
  memory_145 = _RAND_150[7:0];
  _RAND_151 = {1{`RANDOM}};
  memory_146 = _RAND_151[7:0];
  _RAND_152 = {1{`RANDOM}};
  memory_147 = _RAND_152[7:0];
  _RAND_153 = {1{`RANDOM}};
  memory_148 = _RAND_153[7:0];
  _RAND_154 = {1{`RANDOM}};
  memory_149 = _RAND_154[7:0];
  _RAND_155 = {1{`RANDOM}};
  memory_150 = _RAND_155[7:0];
  _RAND_156 = {1{`RANDOM}};
  memory_151 = _RAND_156[7:0];
  _RAND_157 = {1{`RANDOM}};
  memory_152 = _RAND_157[7:0];
  _RAND_158 = {1{`RANDOM}};
  memory_153 = _RAND_158[7:0];
  _RAND_159 = {1{`RANDOM}};
  memory_154 = _RAND_159[7:0];
  _RAND_160 = {1{`RANDOM}};
  memory_155 = _RAND_160[7:0];
  _RAND_161 = {1{`RANDOM}};
  memory_156 = _RAND_161[7:0];
  _RAND_162 = {1{`RANDOM}};
  memory_157 = _RAND_162[7:0];
  _RAND_163 = {1{`RANDOM}};
  memory_158 = _RAND_163[7:0];
  _RAND_164 = {1{`RANDOM}};
  memory_159 = _RAND_164[7:0];
  _RAND_165 = {1{`RANDOM}};
  memory_160 = _RAND_165[7:0];
  _RAND_166 = {1{`RANDOM}};
  memory_161 = _RAND_166[7:0];
  _RAND_167 = {1{`RANDOM}};
  memory_162 = _RAND_167[7:0];
  _RAND_168 = {1{`RANDOM}};
  memory_163 = _RAND_168[7:0];
  _RAND_169 = {1{`RANDOM}};
  memory_164 = _RAND_169[7:0];
  _RAND_170 = {1{`RANDOM}};
  memory_165 = _RAND_170[7:0];
  _RAND_171 = {1{`RANDOM}};
  memory_166 = _RAND_171[7:0];
  _RAND_172 = {1{`RANDOM}};
  memory_167 = _RAND_172[7:0];
  _RAND_173 = {1{`RANDOM}};
  memory_168 = _RAND_173[7:0];
  _RAND_174 = {1{`RANDOM}};
  memory_169 = _RAND_174[7:0];
  _RAND_175 = {1{`RANDOM}};
  memory_170 = _RAND_175[7:0];
  _RAND_176 = {1{`RANDOM}};
  memory_171 = _RAND_176[7:0];
  _RAND_177 = {1{`RANDOM}};
  memory_172 = _RAND_177[7:0];
  _RAND_178 = {1{`RANDOM}};
  memory_173 = _RAND_178[7:0];
  _RAND_179 = {1{`RANDOM}};
  memory_174 = _RAND_179[7:0];
  _RAND_180 = {1{`RANDOM}};
  memory_175 = _RAND_180[7:0];
  _RAND_181 = {1{`RANDOM}};
  memory_176 = _RAND_181[7:0];
  _RAND_182 = {1{`RANDOM}};
  memory_177 = _RAND_182[7:0];
  _RAND_183 = {1{`RANDOM}};
  memory_178 = _RAND_183[7:0];
  _RAND_184 = {1{`RANDOM}};
  memory_179 = _RAND_184[7:0];
  _RAND_185 = {1{`RANDOM}};
  memory_180 = _RAND_185[7:0];
  _RAND_186 = {1{`RANDOM}};
  memory_181 = _RAND_186[7:0];
  _RAND_187 = {1{`RANDOM}};
  memory_182 = _RAND_187[7:0];
  _RAND_188 = {1{`RANDOM}};
  memory_183 = _RAND_188[7:0];
  _RAND_189 = {1{`RANDOM}};
  memory_184 = _RAND_189[7:0];
  _RAND_190 = {1{`RANDOM}};
  memory_185 = _RAND_190[7:0];
  _RAND_191 = {1{`RANDOM}};
  memory_186 = _RAND_191[7:0];
  _RAND_192 = {1{`RANDOM}};
  memory_187 = _RAND_192[7:0];
  _RAND_193 = {1{`RANDOM}};
  memory_188 = _RAND_193[7:0];
  _RAND_194 = {1{`RANDOM}};
  memory_189 = _RAND_194[7:0];
  _RAND_195 = {1{`RANDOM}};
  memory_190 = _RAND_195[7:0];
  _RAND_196 = {1{`RANDOM}};
  memory_191 = _RAND_196[7:0];
  _RAND_197 = {1{`RANDOM}};
  memory_192 = _RAND_197[7:0];
  _RAND_198 = {1{`RANDOM}};
  memory_193 = _RAND_198[7:0];
  _RAND_199 = {1{`RANDOM}};
  memory_194 = _RAND_199[7:0];
  _RAND_200 = {1{`RANDOM}};
  memory_195 = _RAND_200[7:0];
  _RAND_201 = {1{`RANDOM}};
  memory_196 = _RAND_201[7:0];
  _RAND_202 = {1{`RANDOM}};
  memory_197 = _RAND_202[7:0];
  _RAND_203 = {1{`RANDOM}};
  memory_198 = _RAND_203[7:0];
  _RAND_204 = {1{`RANDOM}};
  memory_199 = _RAND_204[7:0];
  _RAND_205 = {1{`RANDOM}};
  memory_200 = _RAND_205[7:0];
  _RAND_206 = {1{`RANDOM}};
  memory_201 = _RAND_206[7:0];
  _RAND_207 = {1{`RANDOM}};
  memory_202 = _RAND_207[7:0];
  _RAND_208 = {1{`RANDOM}};
  memory_203 = _RAND_208[7:0];
  _RAND_209 = {1{`RANDOM}};
  memory_204 = _RAND_209[7:0];
  _RAND_210 = {1{`RANDOM}};
  memory_205 = _RAND_210[7:0];
  _RAND_211 = {1{`RANDOM}};
  memory_206 = _RAND_211[7:0];
  _RAND_212 = {1{`RANDOM}};
  memory_207 = _RAND_212[7:0];
  _RAND_213 = {1{`RANDOM}};
  memory_208 = _RAND_213[7:0];
  _RAND_214 = {1{`RANDOM}};
  memory_209 = _RAND_214[7:0];
  _RAND_215 = {1{`RANDOM}};
  memory_210 = _RAND_215[7:0];
  _RAND_216 = {1{`RANDOM}};
  memory_211 = _RAND_216[7:0];
  _RAND_217 = {1{`RANDOM}};
  memory_212 = _RAND_217[7:0];
  _RAND_218 = {1{`RANDOM}};
  memory_213 = _RAND_218[7:0];
  _RAND_219 = {1{`RANDOM}};
  memory_214 = _RAND_219[7:0];
  _RAND_220 = {1{`RANDOM}};
  memory_215 = _RAND_220[7:0];
  _RAND_221 = {1{`RANDOM}};
  memory_216 = _RAND_221[7:0];
  _RAND_222 = {1{`RANDOM}};
  memory_217 = _RAND_222[7:0];
  _RAND_223 = {1{`RANDOM}};
  memory_218 = _RAND_223[7:0];
  _RAND_224 = {1{`RANDOM}};
  memory_219 = _RAND_224[7:0];
  _RAND_225 = {1{`RANDOM}};
  memory_220 = _RAND_225[7:0];
  _RAND_226 = {1{`RANDOM}};
  memory_221 = _RAND_226[7:0];
  _RAND_227 = {1{`RANDOM}};
  memory_222 = _RAND_227[7:0];
  _RAND_228 = {1{`RANDOM}};
  memory_223 = _RAND_228[7:0];
  _RAND_229 = {1{`RANDOM}};
  memory_224 = _RAND_229[7:0];
  _RAND_230 = {1{`RANDOM}};
  memory_225 = _RAND_230[7:0];
  _RAND_231 = {1{`RANDOM}};
  memory_226 = _RAND_231[7:0];
  _RAND_232 = {1{`RANDOM}};
  memory_227 = _RAND_232[7:0];
  _RAND_233 = {1{`RANDOM}};
  memory_228 = _RAND_233[7:0];
  _RAND_234 = {1{`RANDOM}};
  memory_229 = _RAND_234[7:0];
  _RAND_235 = {1{`RANDOM}};
  memory_230 = _RAND_235[7:0];
  _RAND_236 = {1{`RANDOM}};
  memory_231 = _RAND_236[7:0];
  _RAND_237 = {1{`RANDOM}};
  memory_232 = _RAND_237[7:0];
  _RAND_238 = {1{`RANDOM}};
  memory_233 = _RAND_238[7:0];
  _RAND_239 = {1{`RANDOM}};
  memory_234 = _RAND_239[7:0];
  _RAND_240 = {1{`RANDOM}};
  memory_235 = _RAND_240[7:0];
  _RAND_241 = {1{`RANDOM}};
  memory_236 = _RAND_241[7:0];
  _RAND_242 = {1{`RANDOM}};
  memory_237 = _RAND_242[7:0];
  _RAND_243 = {1{`RANDOM}};
  memory_238 = _RAND_243[7:0];
  _RAND_244 = {1{`RANDOM}};
  memory_239 = _RAND_244[7:0];
  _RAND_245 = {1{`RANDOM}};
  memory_240 = _RAND_245[7:0];
  _RAND_246 = {1{`RANDOM}};
  memory_241 = _RAND_246[7:0];
  _RAND_247 = {1{`RANDOM}};
  memory_242 = _RAND_247[7:0];
  _RAND_248 = {1{`RANDOM}};
  memory_243 = _RAND_248[7:0];
  _RAND_249 = {1{`RANDOM}};
  memory_244 = _RAND_249[7:0];
  _RAND_250 = {1{`RANDOM}};
  memory_245 = _RAND_250[7:0];
  _RAND_251 = {1{`RANDOM}};
  memory_246 = _RAND_251[7:0];
  _RAND_252 = {1{`RANDOM}};
  memory_247 = _RAND_252[7:0];
  _RAND_253 = {1{`RANDOM}};
  memory_248 = _RAND_253[7:0];
  _RAND_254 = {1{`RANDOM}};
  memory_249 = _RAND_254[7:0];
  _RAND_255 = {1{`RANDOM}};
  memory_250 = _RAND_255[7:0];
  _RAND_256 = {1{`RANDOM}};
  memory_251 = _RAND_256[7:0];
  _RAND_257 = {1{`RANDOM}};
  memory_252 = _RAND_257[7:0];
  _RAND_258 = {1{`RANDOM}};
  memory_253 = _RAND_258[7:0];
  _RAND_259 = {1{`RANDOM}};
  memory_254 = _RAND_259[7:0];
  _RAND_260 = {1{`RANDOM}};
  memory_255 = _RAND_260[7:0];
  _RAND_261 = {1{`RANDOM}};
  led = _RAND_261[15:0];
  _RAND_262 = {1{`RANDOM}};
  display = _RAND_262[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
