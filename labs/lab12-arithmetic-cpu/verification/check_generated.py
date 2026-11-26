from pathlib import Path
import subprocess,shutil,json,random,sys
root=Path(__file__).resolve().parents[1];out=root/'verification/out';out.mkdir(exist_ok=True);(root/'evidence').mkdir(exist_ok=True)
MASK=(1<<32)-1
def r(f,f7,rd,a,b):return (f7<<25)|(b<<20)|(a<<15)|(f<<12)|(rd<<7)|0x33
def imm(f,rd,a,v):return ((v&4095)<<20)|(a<<15)|(f<<12)|(rd<<7)|0x13
programs=[[0x00500093,0x00700113,0x002081b3,0x40118233,0x00100073],[imm(0,0,0,-1),imm(0,1,0,-1),imm(1,2,1,31),r(2,0,3,2,0),r(3,0,4,2,0),0x00100073],[imm(0,1,0,7)],[0x022081b3]]
for seed in range(8):
 rng=random.Random(301+seed);words=[imm(0,d,0,rng.randrange(-2048,2048)) for d in range(1,32)]
 opsR=[(0,0),(0,32),(1,0),(2,0),(3,0),(4,0),(5,0),(5,32),(6,0),(7,0)];opsI=[0,2,3,4,6,7]
 for index in range(256):
  kind=index%19;rd=rng.randrange(32);a=rng.randrange(32);b=rng.randrange(32)
  if kind<10:f,f7=opsR[kind];word=r(f,f7,rd,a,b)
  elif kind<16:word=imm(opsI[kind-10],rd,a,rng.randrange(-2048,2048))
  else:word=imm(1 if kind==16 else 5,rd,a,(0x400 if kind==18 else 0)|rng.randrange(32))
  words.append(word)
 programs.append(words+[0x00100073])
cases=[{'words':p,'steps':len(p)+2} for p in programs]
traces=json.loads(subprocess.run([sys.executable,str(root/'verification/reference/rv32_interpreter.py')],input=json.dumps(cases),capture_output=True,text=True,check=True).stdout)
def zero():return {'pc':0,'retired':0,'halted':False,'reason':0,'regs':[0]*32}
def state(row):return {**row,'reason':{None:0,'EBREAK':1,'ILLEGAL_INSTRUCTION':2,'INSTRUCTION_ACCESS_FAULT':3,'INSTRUCTION_ADDRESS_MISALIGNED':4}[row['fault']]}
def pack(s):
 value=(((s['pc']<<32)|s['retired'])<<4)|(int(s['halted'])<<3)|s['reason']
 for reg in s['regs']:value=(value<<32)|reg
 return value
vectors=[];current=zero();retired=0
# Packed architectural snapshot: PC32 + retired32 + halted1 + reason3 + 32*32 registers = 1092 bits.
def append(word,valid,step,clear,reset,after):
 global current
 control=(reset<<35)|(clear<<34)|(step<<33)|(valid<<32)|word
 vectors.append((control<<2184)|(pack(current)<<1092)|pack(after));current=after
for program,trace in zip(programs,traces):
 append(0,0,0,0,1,zero())
 for index,row in enumerate(trace):
  pc=current['pc'];valid=int(pc//4<len(program));word=program[pc//4] if valid else 0
  if index%3==0:append(word,valid,0,0,0,current)
  after=state(row);append(word,valid,1,0,0,after);retired+=int(after['retired']>0 and after['retired']> (trace[index-1]['retired'] if index else 0))
 for _ in range(3):append(0x7ff00093,1,1,0,0,current)
 append(0x7ff00093,1,1,1,0,zero())
# Lab12 deliberately rejects a valid LW without any state write; the broader oracle supports it.
append(0x00002083,1,1,0,0,{**zero(),'halted':True,'reason':2})
(out/'vectors.hex').write_text('\n'.join(f'{v:0555x}' for v in vectors)+'\n')
registers=','.join('io_registers_'+str(i) for i in range(32));declarations='\n'.join('wire [31:0] io_registers_'+str(i)+';' for i in range(32))
(out/'tb.sv').write_text('''`timescale 1ns/1ps
module tb;
reg clock=0,reset=0;reg io_step=0,io_clear=0,io_instructionValid=0;reg [31:0] io_instruction=0;
wire [31:0] io_pc,io_retired,io_candidate;wire io_halted,io_commit;wire [2:0] io_reason;wire [4:0] io_candidateRd;
DECL
ArithmeticCPU dut(.*);reg [2219:0] vectors[0:COUNT-1];integer i;
wire [1091:0] observed={io_pc,io_retired,io_halted,io_reason,REGS};
initial begin
$readmemh("vectors.hex",vectors);
for(i=0;i<COUNT;i=i+1)begin
clock=0;{reset,io_clear,io_step,io_instructionValid,io_instruction}=vectors[i][2219:2184];#4;
if(i>0 && observed !== vectors[i][2183:1092])$fatal(1,"before edge %d PC=%h",i,io_pc);
clock=1;#1;
if(observed !== vectors[i][1091:0])$fatal(1,"after edge %d PC=%h",i,io_pc);
#5;
end
$display("PASS COUNT edges: PC, retired, stop reason and all 32 saved registers, pre/post");$finish;
end
endmodule
'''.replace('DECL',declarations).replace('REGS',registers).replace('COUNT',str(len(vectors))))
subprocess.run([shutil.which('iverilog') or '/opt/homebrew/bin/iverilog','-g2012','-s','tb','-o',str(out/'sim'),str(root/'generated/ArithmeticCPU.v'),str(out/'tb.sv')],check=True)
result=subprocess.run([shutil.which('vvp') or '/opt/homebrew/bin/vvp',str(out/'sim')],cwd=out,check=True,capture_output=True,text=True)
report={'status':'passed','programs':len(programs),'edges':len(vectors),'architectural_snapshots':2*len(vectors)-1,'random_programs':8,'random_arithmetic_instructions_per_program':256,'oracle':'independent Python RV32 instruction interpreter plus explicit Lab12 unsupported-load policy','output':result.stdout};(root/'evidence/generated-rtl-check.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report))
