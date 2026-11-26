from pathlib import Path
import subprocess,shutil,json,random
root=Path(__file__).resolve().parents[1];out=root/'verification/out';out.mkdir(exist_ok=True);r=random.Random(301)
(root/'evidence').mkdir(exist_ok=True)
rows=json.loads((root/'decoder-table.json').read_text())
words=[row['match']|((~row['mask']&0xffffffff)&r.getrandbits(32)) for row in rows]+[0,0xffffffff]+[1<<i for i in range(32)]
for opcode in range(128):
 for f3 in range(8):
  for f7 in range(128):words.append((f7<<25)|(r.randrange(32)<<20)|(r.randrange(32)<<15)|(f3<<12)|(r.randrange(32)<<7)|opcode)
words += [r.getrandbits(32) for _ in range(8192)]
(out/'words.hex').write_text('\n'.join(f'{w:08x}' for w in words)+'\n')
(out/'tb.sv').write_text('''module tb;
reg clock=0,reset=0;reg [31:0] io_instruction=0;
wire [5:0] io_id;wire [2:0] io_format;wire [3:0] io_alu;wire io_loadUnsigned,io_shiftImmediate;wire [15:0] io_control;
wire [6:0] io_opcode,io_funct7;wire [4:0] io_rd,io_rs1,io_rs2;wire [2:0] io_funct3;wire [31:0] io_immediate;
wire io_valid,io_effectiveRegWrite;wire [2:0] io_branchKind;wire [1:0] io_trapKind;
Decoder32 dut(.*);
wire [5:0] rid;wire [2:0] rfmt;wire [3:0] ralu;wire rlu,rshift;wire [15:0] rcontrol;
rv32_decoder referenceDecoder(.inst(io_instruction),.id(rid),.fmt(rfmt),.alu(ralu),.load_unsigned(rlu),.shift_imm(rshift),.control(rcontrol));
wire [2:0] rf=(rfmt>=1&&rfmt<=5)?rfmt-1:7;wire [31:0] rimm;
rv32_immgen referenceImmediate(.inst(io_instruction),.fmt(rf),.imm(rimm));
reg [2:0] manualFormat=0;wire [31:0] manualResult,manualExpected;
Immediate32 manualDut(.io_instruction(io_instruction),.io_format(manualFormat),.io_immediate(manualResult));
rv32_immgen manualRef(.inst(io_instruction),.fmt(manualFormat),.imm(manualExpected));
reg [31:0] words[0:N-1];reg [39:0] seen=0;integer i,f;
initial begin
$readmemh("words.hex",words);
for(i=0;i<N;i=i+1)begin
io_instruction=words[i];#1;
if({io_id,io_format,io_alu,io_loadUnsigned,io_shiftImmediate,io_control,io_immediate} !== {rid,rfmt,ralu,rlu,rshift,rcontrol,rimm})$fatal(1,"decoder mismatch %d %h",i,io_instruction);
if({io_opcode,io_rd,io_funct3,io_rs1,io_rs2,io_funct7} !== {io_instruction[6:0],io_instruction[11:7],io_instruction[14:12],io_instruction[19:15],io_instruction[24:20],io_instruction[31:25]})$fatal(1,"raw slices %d",i);
if(io_valid !== rcontrol[0] || io_effectiveRegWrite !== (rcontrol[3] && io_instruction[11:7]!=0))$fatal(1,"write gating %d",i);
if(io_branchKind !== (rcontrol[6]?io_instruction[14:12]:3'b0) || io_trapKind !== (rid==38?2'd1:rid==39?2'd2:2'd0))$fatal(1,"kind %d",i);
if(rid<40)seen[rid]=1;
for(f=0;f<8;f=f+1)begin manualFormat=f;#1;if(manualResult !== manualExpected)$fatal(1,"immediate mismatch %d/%d",i,f);end
end
if(seen !== 40'hffffffffff)$fatal(1,"missing supported cases %h",seen);
$display("PASS N decoder words, all 40 IDs, all eight manual immediate formats per word, no clocks");$finish;
end
endmodule
'''.replace('N',str(len(words))))
subprocess.run([shutil.which('iverilog') or '/opt/homebrew/bin/iverilog','-g2012','-s','tb','-o',str(out/'sim'),str(root/'generated/Decoder32.v'),str(root/'verification/reference/rv32_decoder.v'),str(root/'verification/reference/rv32_immgen.v'),str(out/'tb.sv')],check=True)
res=subprocess.run([shutil.which('vvp') or '/opt/homebrew/bin/vvp',str(out/'sim')],cwd=out,check=True,capture_output=True,text=True)
report={'status':'passed','decoder_words':len(words),'supported_ids_seen':40,'opcode_funct3_funct7_grid':131072,'manual_immediate_cases':len(words)*8,'clock_edges':0,'simulator':'Icarus Verilog','oracle':'separate handwritten Verilog decoder and immediate generator; raw slices checked directly','table_origin':'Chisel implementation rows reuse web declarative spec; independent reference RTL does not consume that table','output':res.stdout};(root/'evidence/generated-rtl-check.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report))
