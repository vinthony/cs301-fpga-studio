#!/usr/bin/env python3
from pathlib import Path
import subprocess,shutil,json,random,sys
ROOT=Path(__file__).resolve().parents[1];OUT=ROOT/'out';OUT.mkdir(exist_ok=True);(ROOT/'evidence').mkdir(exist_ok=True)
# Refuse stale generated RTL after editing source or build settings.
import hashlib
manifest=ROOT/'generated/source-manifest.sha256'
if not manifest.is_file():raise SystemExit('Missing source manifest; run ./run.sh test "Test / runMain cs301.EmitPipeline"')
for line in manifest.read_text().splitlines():
 expected,relative=line.split('  ',1);file=ROOT/relative
 if not file.is_file() or hashlib.sha256(file.read_bytes()).hexdigest()!=expected:raise SystemExit('Stale generated artifact: '+relative+'; rerun test and EmitPipeline')
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
# Pipeline-specific dependencies and precise younger-side-effect suppression.
case('newest EX MEM forwarding priority',[I(0x13,0,1,0,1),I(0x13,0,1,1,2),R(0,0,2,1,1),0x100073])
case('load to store data',LI(1,0x12345678)+[S(2,0,1,0),I(3,2,2,0,0),S(2,0,2,4),I(3,2,3,0,4),0x100073])
case('load to store base',[I(0x13,0,1,0,8),S(2,0,1,0),I(3,2,2,0,0),S(2,2,1,0),I(3,2,3,0,8),0x100073])
case('load to branch and flush illegal',[S(2,0,0,0),I(3,2,1,0,0),B(0,1,0,8),0,0x100073])
case('older load fault suppress younger store',[I(0x13,0,1,0,7),I(3,2,2,0,1),S(2,0,1,0),I(0x13,0,3,0,99),0x100073])
case('break drains older store but kills younger store',[I(0x13,0,1,0,7),S(2,0,1,0),0x100073,S(2,0,1,4)])
traces=json.loads(subprocess.run([sys.executable,str(ROOT/'verification/reference/rv32_interpreter.py')],input=json.dumps(cases),text=True,capture_output=True,check=True).stdout)
REASONS={None:0,'EBREAK':1,'ILLEGAL_INSTRUCTION':2,'INSTRUCTION_ACCESS_FAULT':3,'INSTRUCTION_ADDRESS_MISALIGNED':4,'LOAD_ADDRESS_MISALIGNED':5,'STORE_ADDRESS_MISALIGNED':6,'LOAD_ACCESS_FAULT':7,'STORE_ACCESS_FAULT':8,'ECALL':9}
WIDTH=32+32+1+4+32+16+32+32*32+256*8
ARCH=32+32+32*32
DEBUG=32*4+1+4+32*4

def pack(s):
 value=s['pc'];value=(value<<32)|s['retired'];value=(value<<1)|int(s['halted']);value=(value<<4)|REASONS[s['fault']];value=(value<<32)|s['faultValue'];value=(value<<16)|s['led'];value=(value<<32)|s['display']
 for v in s['regs']:value=(value<<32)|v
 for v in s['memory']:value=(value<<8)|v
 return value

def architectural(s):
 value=(s['pc']<<32)|s['retired']
 for v in s['regs']:value=(value<<32)|v
 return value
words=[];metadata=[];retire=[];final=[]
for item,trace in zip(cases,traces):
 if not trace or not trace[-1]['halted']:raise RuntimeError('Reference did not stop: '+item['name'])
 rows=[row for row in trace if not row['halted']]
 metadata.append((len(words),len(item['words']),len(retire)))
 words+=item['words'];retire += [architectural(row) for row in rows];final.append(pack(trace[-1]))
for name,values,width in [('programs.hex',words,32),('retire.hex',retire,ARCH),('final.hex',final,WIDTH)]:
 (OUT/name).write_text('\n'.join(f'{v:0{(width+3)//4}x}' for v in values)+'\n')
(OUT/'cases.json').write_text(json.dumps(cases))
reg_ports=','.join(f'.io_registers_{i}(r{i})' for i in range(32));mem_ports=','.join(f'.io_memory_{i}(m{i})' for i in range(256))
regs=''.join(f'wire [31:0] r{i};\n' for i in range(32));mem=''.join(f'wire [7:0] m{i};\n' for i in range(256))
stage_ports=','.join(f'.io_stageValid_{i}(sv{i}),.io_stagePC_{i}(sp{i})' for i in range(4))
stages=''.join(f'wire sv{i};wire [31:0] sp{i};\n' for i in range(4))
snapshot=','.join(['pc','retired','halted','reason','faultValue','led','display']+[f'r{i}' for i in range(32)]+[f'm{i}' for i in range(256)])
arch=','.join(['pc','retired']+[f'r{i}' for i in range(32)])
debug=','.join(['fetchPC','cycles','stalls','redirects','pendingTrap']+[f'sv{i}' for i in range(4)]+[f'sp{i}' for i in range(4)])
initialization='\n'.join(f'base[{i}]={base};length[{i}]={length};traceBase[{i}]={offset};' for i,(base,length,offset) in enumerate(metadata))
tb=f'''module tb;
reg clock=0,reset=0,step=0,clear=0,instructionValid=0;reg [1:0] mode=0;reg [31:0] instruction=0;
wire [31:0] fetchPC,pc,retired,faultValue,display,cycles,stalls,redirects;wire halted,stall,redirect,pendingTrap;wire [1:0] forwardA,forwardB;wire [3:0] reason;wire [15:0] led;
{regs}{mem}{stages}
PipelineCPU dut(.clock(clock),.reset(reset),.io_step(step),.io_clear(clear),.io_mode(mode),.io_instruction(instruction),.io_instructionValid(instructionValid),.io_switches(16'h0035),.io_buttons(5'd21),.io_fetchPC(fetchPC),.io_pc(pc),.io_retired(retired),.io_halted(halted),.io_reason(reason),.io_faultValue(faultValue),.io_led(led),.io_display(display),.io_cycles(cycles),.io_stall(stall),.io_redirect(redirect),.io_forwardA(forwardA),.io_forwardB(forwardB),.io_stalls(stalls),.io_redirects(redirects),.io_pendingTrap(pendingTrap),{stage_ports},{reg_ports},{mem_ports});
wire [{WIDTH-1}:0] actual={{{snapshot}}};wire [{ARCH-1}:0] architectural={{{arch}}};wire [{DEBUG-1}:0] debug={{{debug}}};
reg [{WIDTH+DEBUG-1}:0] holdSnapshot;reg [31:0] programs[0:{len(words)-1}];reg [{ARCH-1}:0] expectedRetire[0:{len(retire)-1}];reg [{WIDTH-1}:0] expectedFinal[0:{len(cases)-1}];
integer base[0:{len(cases)-1}],length[0:{len(cases)-1}],traceBase[0:{len(cases)-1}];integer c,strategy,attempts,previousRetired,checked=0,checkedHold=0,checkedRetired=0,traceFile,preForwardA,preForwardB;
initial begin
 traceFile=$fopen("pipeline-cycles.txt","w");
 $readmemh("programs.hex",programs);$readmemh("retire.hex",expectedRetire);$readmemh("final.hex",expectedFinal);
 {initialization}
 for(strategy=1;strategy<=2;strategy=strategy+1)for(c=0;c<{len(cases)};c=c+1)begin
  mode=strategy;reset=1;clear=0;step=0;instructionValid=0;instruction=0;#5;clock=1;#1;clock=0;#4;reset=0;
  attempts=0;
  while(!halted&&attempts<5000)begin
   instructionValid=(fetchPC[1:0]==0&&fetchPC/4<length[c]);instruction=instructionValid?programs[base[c]+fetchPC/4]:0;
   step=0;#5;holdSnapshot={{debug,actual}};clock=1;#1;
   if({{debug,actual}}!==holdSnapshot)begin $display("FAIL HOLD case=%0d mode=%0d cycle=%0d",c,strategy,attempts);$fatal;end
   checkedHold=checkedHold+1;clock=0;#4;step=1;previousRetired=retired;#5;preForwardA=forwardA;preForwardB=forwardB;clock=1;#1;
   $fdisplay(traceFile,"%0d %0d %0d %h %h %0d %0d",c,strategy,cycles,actual,debug,preForwardA,preForwardB);
   if(retired>previousRetired)begin
    if(architectural!==expectedRetire[traceBase[c]+retired-1])begin $display("FAIL RETIRE case=%0d mode=%0d cycle=%0d retired=%0d pc=%h",c,strategy,attempts,retired,pc);$display("actual=%h expected=%h",architectural,expectedRetire[traceBase[c]+retired-1]);$fatal;end
    checkedRetired=checkedRetired+1;
   end
   clock=0;#4;attempts=attempts+1;checked=checked+1;
  end
  if(!halted)begin $display("FAIL TIMEOUT case=%0d mode=%0d fetch=%h",c,strategy,fetchPC);$fatal;end
  if(actual!==expectedFinal[c])begin $display("FAIL FINAL case=%0d mode=%0d pc=%h retired=%0d reason=%0d fault=%h",c,strategy,pc,retired,reason,faultValue);$display("actual=%h expected=%h",actual,expectedFinal[c]);$fatal;end
  holdSnapshot={{debug,actual}};instruction=32'h7ff00193;instructionValid=1;#5;clock=1;#1;
  if({{debug,actual}}!==holdSnapshot)begin $display("FAIL HALTED case=%0d",c);$fatal;end
  clock=0;#4;step=0;clear=1;#5;clock=1;#1;
  if(actual!==0||debug!==0)begin $display("FAIL CLEAR case=%0d",c);$fatal;end
  clock=0;#4;clear=0;
 end
 $fclose(traceFile);
 $display("PASS programs=%0d modes=2 activeEdges=%0d holdEdges=%0d retiredChecks=%0d",{len(cases)},checked,checkedHold,checkedRetired);$finish;
end
endmodule
'''
(OUT/'tb.v').write_text(tb)
iverilog=shutil.which('iverilog');vvp=shutil.which('vvp')
if not iverilog or not vvp:raise SystemExit('Requires iverilog/vvp')
subprocess.run([iverilog,'-g2012','-s','tb','-o','sim',str(ROOT/'generated/PipelineCPU.v'),'tb.v'],cwd=OUT,check=True)
run=subprocess.run([vvp,'sim'],cwd=OUT,text=True,capture_output=True)
(OUT/'rtl-result.log').write_text(run.stdout+run.stderr)
if run.returncode:raise RuntimeError(run.stdout+run.stderr)
if f'PASS programs={len(cases)} modes=2' not in run.stdout:raise RuntimeError(run.stdout+run.stderr)
report={'status':'passed','reference':'independent Python RV32I interpreter, no app imports','programs':len(cases),'hazardModes':['stall','forward'],'instructionKinds':40,'architecturalRegisterSnapshotsPerMode':len(retire),'fullRegisters':32,'fullRAMBytes':256,'finalSnapshotBits':WIDTH,'retirementSnapshotBits':ARCH,'faultReasonsCovered':sorted({REASONS[row['fault']] for trace in traces for row in trace}),'scope':'each retired register/PC state and final full RAM/MMIO/fault state; explicit step holds and clear; not pipeline-cycle equivalence or physical timing','stdout':run.stdout.strip()}
(ROOT/'evidence/generated-rtl-check.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n');print(json.dumps(report,ensure_ascii=False))
