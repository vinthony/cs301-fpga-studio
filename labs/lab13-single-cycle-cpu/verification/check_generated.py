#!/usr/bin/env python3
from pathlib import Path
import subprocess,shutil,json,random,sys
ROOT=Path(__file__).resolve().parents[1];OUT=ROOT/'out';OUT.mkdir(exist_ok=True);(ROOT/'evidence').mkdir(exist_ok=True)
MASK=0xffffffff
# Encoders only; the reference executes and decodes independently.
def I(op,f,rd,a,v):return ((v&4095)<<20)|(a<<15)|(f<<12)|(rd<<7)|op
def R(f,f7,rd,a,b):return (f7<<25)|(b<<20)|(a<<15)|(f<<12)|(rd<<7)|0x33
def S(f,a,b,v):return ((v&0xfe0)<<20)|(b<<20)|(a<<15)|(f<<12)|((v&31)<<7)|0x23
def B(f,a,b,v):return ((v&0x1000)<<19)|((v&0x7e0)<<20)|(b<<20)|(a<<15)|(f<<12)|((v&0x1e)<<7)|((v&0x800)>>4)|0x63
def J(rd,v):return ((v&0x100000)<<11)|((v&0x7fe)<<20)|((v&0x800)<<9)|(v&0xff000)|(rd<<7)|0x6f
def LI(rd,value):
 value&=MASK;v=value if value<0x80000000 else value-(1<<32)
 if -2048<=v<=2047:return [I(0x13,0,rd,0,v)]
 hi=(v+2048)//4096;lo=v-hi*4096
 return [((hi&0xfffff)<<12)|(rd<<7)|0x37,I(0x13,0,rd,rd,lo)]
cases=[]
def case(name,words,**extra):cases.append(dict(name=name,words=words,steps=500,switches=0x35,buttons=21,**extra))
case('sum loop',[0x00500093,0x00000193,0x001181b3,0xfff08093,0xfe009ce3,0x00302023,0x00002203,0x00100073])
for seed in range(4):
 rng=random.Random(301+seed);words=sum((LI(i,rng.getrandbits(32)) for i in range(1,32)),[])
 ops=[(0,0),(0,32),(1,0),(2,0),(3,0),(4,0),(5,0),(5,32),(6,0),(7,0)]
 for index in range(190):
  kind=index%19;rd=rng.randrange(32);a=rng.randrange(32);b=rng.randrange(32)
  if kind<10:f,f7=ops[kind];word=R(f,f7,rd,a,b)
  elif kind<16:word=I(0x13,[0,2,3,4,6,7][kind-10],rd,a,rng.randrange(-2048,2048))
  else:word=I(0x13,1 if kind==16 else 5,rd,a,(0x400 if kind==18 else 0)|rng.randrange(32))
  words.append(word)
 case('random arithmetic '+str(seed),words+[0x100073])
# Bounds, granularity, sign extension, and little-endian backing bytes.
for f in [0,1,2,4,5]:
 for address in [0,1,2,3,252,253,254,255,256,0xffffffff,0xffff0000,0xffff0004,0xffff0008,0xffff000c,0xffff0001]:
  setup=LI(2,0x89abcdef)+[S(2,0,2,0),S(2,0,2,4),S(2,0,2,252)]+LI(1,address)
  case(f'load f{f} @{address:08x}',setup+[I(3,f,3,1,0),0x100073])
for f in [0,1,2]:
 for address in [0,1,2,3,252,253,254,255,256,0xffffffff,0xffff0000,0xffff0004,0xffff0008,0xffff000c,0xffff0001]:
  case(f'store f{f} @{address:08x}',LI(1,address)+LI(2,0x12345678)+[S(f,1,2,0),0x100073])
for f in [0,1,4,5,6,7]:
 for a,b in [(0,0),(1,0),(0,1),(0xffffffff,0),(0x80000000,0x7fffffff)]:
  setup=LI(1,a)+LI(2,b)
  case(f'branch f{f} {a} {b}',setup+[B(f,1,2,8),I(0x13,0,3,0,99),0x100073])
  case(f'branch misaligned f{f} {a} {b}',setup+[B(f,1,2,2),0x100073])
case('jal skip illegal',[J(1,8),0,0x100073])
case('jal target misaligned',[J(1,2)])
case('jal target out of fetch ROM',[J(1,4096)])
case('jalr same source and destination',[I(0x13,0,1,0,13),I(0x67,0,1,1,0),0,0x100073])
case('jalr target misaligned',[I(0x13,0,1,0,7),I(0x67,0,1,1,0)])
case('upper immediate and pc-relative',[0x800000b7,0x00001117,0x100073])
case('fence',[0x0330000f,0x100073]);case('ecall',[0x73]);case('illegal M extension',[0x022081b3]);case('illegal encoding',[0]);case('fall off ROM',[I(0x13,0,1,0,7)])
case('x0 write still retires',[I(0x13,0,0,0,7),0x100073]);case('faulting load to x0',[I(3,2,0,0,256)])
case('MMIO roundtrip',LI(1,0xffff0000)+[I(3,2,2,1,0),S(2,1,2,4),I(3,2,3,1,12),S(2,1,3,8),I(3,2,4,1,4),I(3,2,5,1,8),0x100073])
traces=json.loads(subprocess.run([sys.executable,str(ROOT/'verification/reference/rv32_interpreter.py')],input=json.dumps(cases),text=True,capture_output=True,check=True).stdout)
REASONS={None:0,'EBREAK':1,'ILLEGAL_INSTRUCTION':2,'INSTRUCTION_ACCESS_FAULT':3,'INSTRUCTION_ADDRESS_MISALIGNED':4,'LOAD_ADDRESS_MISALIGNED':5,'STORE_ADDRESS_MISALIGNED':6,'LOAD_ACCESS_FAULT':7,'STORE_ACCESS_FAULT':8,'ECALL':9}
def zero():return dict(pc=0,retired=0,halted=False,fault=None,faultValue=0,led=0,display=0,regs=[0]*32,memory=[0]*256)
WIDTH=32+32+1+4+32+16+32+32*32+256*8
CONTROL=57;TOTAL=CONTROL+2*WIDTH
current=zero();vectors=[]
def pack(s):
 value=s['pc'];value=(value<<32)|s['retired'];value=(value<<1)|int(s['halted']);value=(value<<4)|REASONS[s['fault']];value=(value<<32)|s['faultValue'];value=(value<<16)|s['led'];value=(value<<32)|s['display']
 for v in s['regs']:value=(value<<32)|v
 for v in s['memory']:value=(value<<8)|v
 return value
def append(word,valid,step,clear,reset,after,pins):
 global current
 control=(reset<<56)|(clear<<55)|(step<<54)|(valid<<53)|(pins['switches']<<37)|(pins['buttons']<<32)|word
 vectors.append((control<<(2*WIDTH))|(pack(current)<<WIDTH)|pack(after));current=after
for item,trace in zip(cases,traces):
 append(0,0,0,0,1,zero(),item)
 for index,row in enumerate(trace):
  pc=current['pc'];valid=int(pc%4==0 and pc//4<len(item['words']));word=item['words'][pc//4] if valid else 0
  if index%4==0:append(word,valid,0,0,0,current,item)
  append(word,valid,1,0,0,row,item)
 for _ in range(2):append(0x7ff00193,1,1,0,0,current,item)
 append(0xffffffff,1,1,1,0,zero(),item)
(OUT/'vectors.hex').write_text('\n'.join(f'{v:0{(TOTAL+3)//4}x}' for v in vectors)+'\n')
reg_ports=','.join(f'.io_registers_{i}(r{i})' for i in range(32));mem_ports=','.join(f'.io_memory_{i}(m{i})' for i in range(256))
regs=''.join(f'wire [31:0] r{i};\n' for i in range(32));mem=''.join(f'wire [7:0] m{i};\n' for i in range(256))
snapshot=','.join(['pc','retired','halted','reason','faultValue','led','display']+[f'r{i}' for i in range(32)]+[f'm{i}' for i in range(256)])
tb=f'''module tb;
reg clock=0,reset=0,step=0,clear=0,valid=0;reg [31:0] instruction=0;reg [15:0] switches=0;reg [4:0] buttons=0;
wire [31:0] pc,retired,faultValue,display,candidate,nextPC;wire halted,commit;wire [3:0] reason;wire [15:0] led;
{regs}{mem}
SingleCycleCPU dut(.clock(clock),.reset(reset),.io_step(step),.io_clear(clear),.io_instruction(instruction),.io_instructionValid(valid),.io_switches(switches),.io_buttons(buttons),.io_pc(pc),.io_retired(retired),.io_halted(halted),.io_reason(reason),.io_faultValue(faultValue),.io_led(led),.io_display(display),.io_candidate(candidate),.io_nextPC(nextPC),.io_commit(commit),{reg_ports},{mem_ports});
wire [{WIDTH-1}:0] actual={{{snapshot}}};reg [{TOTAL-1}:0] vectors[0:{len(vectors)-1}];integer i;
initial begin
 $readmemh("vectors.hex",vectors);
 for(i=0;i<{len(vectors)};i=i+1)begin
  {{reset,clear,step,valid,switches,buttons,instruction}}=vectors[i][{TOTAL-1}:{2*WIDTH}];#5;
  if(i>0 && actual!==vectors[i][{2*WIDTH-1}:{WIDTH}])begin $display("FAIL PRE %0d pc=%h retired=%d reason=%d",i,pc,retired,reason);$fatal;end
  clock=1;#1;
  if(actual!==vectors[i][{WIDTH-1}:0])begin $display("FAIL POST %0d pc=%h retired=%d reason=%d fault=%h",i,pc,retired,reason,faultValue);$display("actual=%h expected=%h",actual,vectors[i][{WIDTH-1}:0]);$fatal;end
  #4;clock=0;
 end
 $display("PASS %0d edges",{len(vectors)});$finish;
end
endmodule
'''
(OUT/'tb.v').write_text(tb)
iverilog=shutil.which('iverilog');vvp=shutil.which('vvp')
if not iverilog or not vvp:raise SystemExit('Requires iverilog/vvp')
subprocess.run([iverilog,'-g2012','-s','tb','-o','sim',str(ROOT/'generated/SingleCycleCPU.v'),'tb.v'],cwd=OUT,check=True)
run=subprocess.run([vvp,'sim'],cwd=OUT,text=True,capture_output=True,check=True)
if f'PASS {len(vectors)} edges' not in run.stdout:raise RuntimeError(run.stdout+run.stderr)
report={'status':'passed','reference':'independent Python RV32I interpreter with precise teaching EEI','programs':len(cases),'postEdgeSnapshots':len(vectors),'preEdgeHoldSnapshots':len(vectors)-1,'snapshotBits':WIDTH,'fullRegisters':32,'fullRAMBytes':256,'faultReasonsCovered':sorted({REASONS[row['fault']] for trace in traces for row in trace}),'stdout':run.stdout.strip()}
(ROOT/'evidence/generated-rtl-check.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n');(OUT/'cases.json').write_text(json.dumps(cases));print(json.dumps(report,ensure_ascii=False))
