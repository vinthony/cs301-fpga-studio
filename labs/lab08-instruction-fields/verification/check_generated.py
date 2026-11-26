from pathlib import Path
import subprocess,shutil,json,random
root=Path(__file__).resolve().parents[1];out=root/'verification/out';out.mkdir(exist_ok=True);r=random.Random(301)
words=[0x002081b3,0xffc10093,0x00812083,0x00112623,0x00208463,0x00c000ef,0x123451b7,0,0xffffffff]+[1<<i for i in range(32)]+[(r.getrandbits(32)&~127)|op for op in range(128)]+[r.getrandbits(32) for _ in range(8192)]
formats={0x33:1,0x13:2,0x03:2,0x67:2,0x23:3,0x63:4,0x37:5,0x17:5,0x6f:6};vectors=[]
for word in words:
 bits=f'{word:032b}';fields=[int(bits[a:b],2) for a,b in [(25,32),(20,25),(17,20),(12,17),(7,12),(0,7)]]
 expected=0
 for value,width in zip(fields+[formats.get(fields[0],0)],[7,5,3,5,5,7,3]):expected=(expected<<width)|value
 vectors.append((word<<35)|expected)
(out/'vectors.hex').write_text('\n'.join(f'{v:017x}' for v in vectors)+'\n')
(out/'tb.sv').write_text('''module tb;
reg clock=0,reset=0;reg [31:0] io_instruction=0;
wire [6:0] io_opcode,io_funct7Slice;wire [4:0] io_rdSlice,io_rs1Slice,io_rs2Slice;
wire [2:0] io_funct3Slice,io_format;
InstructionFields dut(.*);reg [66:0] vectors[0:N-1];integer i;
initial begin
$readmemh("vectors.hex",vectors);
for(i=0;i<N;i=i+1)begin
io_instruction=vectors[i][66:35];#1;
if({io_opcode,io_rdSlice,io_funct3Slice,io_rs1Slice,io_rs2Slice,io_funct7Slice,io_format} !== vectors[i][34:0])$fatal(1,"mismatch %d",i);
end
$display("PASS N raw-field vectors, no clocks");$finish;
end
endmodule
'''.replace('N',str(len(vectors))))
subprocess.run([shutil.which('iverilog') or '/opt/homebrew/bin/iverilog','-g2012','-s','tb','-o',str(out/'sim'),str(root/'generated/InstructionFields.v'),str(out/'tb.sv')],check=True)
res=subprocess.run([shutil.which('vvp') or '/opt/homebrew/bin/vvp',str(out/'sim')],cwd=out,check=True,capture_output=True,text=True)
report={'status':'passed','vectors':len(vectors),'opcode_patterns':128,'clock_edges':0,'simulator':'Icarus Verilog','oracle':'independent Python 32-character binary string slicing','scope':'raw slices and classroom opcode-format map, not instruction legality','output':res.stdout};(root/'evidence/generated-rtl-check.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report))
