#!/usr/bin/env python3
"""Independent finite-state reference against the actual Chisel-generated RTL."""
from pathlib import Path
import json, random, shutil, subprocess
BASE=Path(__file__).resolve().parents[1]
OUT=BASE/'out'/'input';OUT.mkdir(parents=True,exist_ok=True)
class Reference:
    def __init__(self):self.first=self.second=self.candidate=self.count=self.stable=self.previous=self.event=0
    def packed(self):return (self.first<<37)|(self.second<<36)|(self.candidate<<35)|(self.count<<3)|(self.stable<<2)|(self.previous<<1)|self.event
    def edge(self,raw,sample,clear,reset):
        if clear or reset:self.__init__();return
        if not sample:return
        # A list of prior samples specifies the synchronous pipeline semantics.
        observed=self.second;old=self.stable
        self.second,self.first=self.first,raw
        if observed!=self.candidate:self.candidate,self.count=observed,1
        else:self.count=min(0xffffffff,self.count+1)
        if self.count>=3:self.stable=self.candidate
        self.previous=old;self.event=int(self.stable==1 and old==0)
r=Reference();vectors=[]
def add(raw,sample,clear=0,reset=0):
    before=r.packed();r.edge(raw,sample,clear,reset);control=(raw<<3)|(sample<<2)|(clear<<1)|reset
    vectors.append(f'{control:01x}{before:010x}{r.packed():010x}')
add(0,0,reset=1)
for word in range(4096):
    add(word&1,0,clear=1)
    for i in range(12):
        raw=(word>>(11-i))&1;add(raw,1)
        if i%3==2:add(1-raw,0)
rng=random.Random(301)
for i in range(4096):add(rng.randrange(2),int(i%5!=0),int(i%31==0),int(i%113==0))
(OUT/'vectors.hex').write_text('\n'.join(vectors)+'\n')
tb=f'''module tb;
reg clock=0,reset=0,raw=0,sample=0,clear=0;
wire s1,s2,candidate,stable,previous,event_out;wire [31:0] count;
wire [39:0] actual={{2'b0,s1,s2,candidate,count,stable,previous,event_out}};
InputConditioner dut(.clock(clock),.reset(reset),.io_raw(raw),.io_sample(sample),.io_clear(clear),.io_sync1(s1),.io_sync2(s2),.io_candidate(candidate),.io_consecutive(count),.io_stable(stable),.io_previous(previous),.io_event(event_out));
reg [83:0] vectors[0:{len(vectors)-1}];integer i;
initial begin
 $readmemh("vectors.hex",vectors);
 for(i=0;i<{len(vectors)};i=i+1)begin
  {{raw,sample,clear,reset}}=vectors[i][83:80];#5;
  if(i>0 && actual!==vectors[i][79:40])begin $display("FAIL PRE %0d actual=%h expected=%h",i,actual,vectors[i][79:40]);$fatal;end
  clock=1;#1;
  if(actual!==vectors[i][39:0])begin $display("FAIL POST %0d actual=%h expected=%h",i,actual,vectors[i][39:0]);$fatal;end
  #4;clock=0;
 end
 $display("PASS %0d edges %0d held-before-edge",{len(vectors)},{len(vectors)-1});$finish;
end
endmodule
'''
(OUT/'tb.v').write_text(tb)
iverilog=shutil.which('iverilog');vvp=shutil.which('vvp')
if not iverilog or not vvp:raise SystemExit('Install Icarus Verilog (iverilog/vvp) to run this check.')
subprocess.run([iverilog,'-g2012','-s','tb','-o','sim',str(BASE/'generated'/'InputConditioner.v'),'tb.v'],cwd=OUT,check=True)
run=subprocess.run([vvp,'sim'],cwd=OUT,text=True,capture_output=True,check=True)
if f'PASS {len(vectors)} edges' not in run.stdout:raise RuntimeError(run.stdout+run.stderr)
report={'status':'passed','reference':'independent Python finite-state sampler','exhaustiveRawPatterns':4096,'bitsPerPattern':12,'randomControls':4096,'postEdgeSnapshots':len(vectors),'preEdgeHoldSnapshots':len(vectors)-1,'outputsComparedPerSnapshot':7,'rtl':'generated/InputConditioner.v','counter':'32-bit saturating; near-maximum counter boundary tested in Chisel with 2-bit parameter','stdout':run.stdout.strip()}
(BASE/'evidence').mkdir(exist_ok=True)
(BASE/'evidence'/'generated-input-rtl-check.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n')
print(json.dumps(report,ensure_ascii=False))
