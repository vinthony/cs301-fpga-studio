#!/usr/bin/env python3
"""Independent received-bit list specification against actual generated RTL."""
from pathlib import Path
import json,random,subprocess
BASE=Path(__file__).resolve().parents[1];OUT=BASE/'out';OUT.mkdir(exist_ok=True)
bits=None;data=valid=error=0;vectors=[];cases=[]
def packed():
    phase=15 if bits is None else len(bits)
    return (data<<7)|(phase<<3)|(int(bits is not None)<<2)|(valid<<1)|error

def add(rx=1,step=1,clear=0,reset=0):
    global bits,data,valid,error
    before=packed()
    if clear or reset:bits=None;data=valid=error=0
    elif step:
        valid=error=0
        if bits is None:
            if rx==0:bits=[];data=0
        elif len(bits)<8:
            bits.append(rx);data=sum(v*(2**i) for i,v in enumerate(bits))
        else:valid=rx;error=1-rx;bits=None
    after=packed();control=(rx<<3)|(step<<2)|(clear<<1)|reset
    vectors.append(f'{control:01x}{before:04x}{after:04x}');cases.append(dict(rx=rx,step=step,clear=clear,reset=reset,before=f'{before:04x}',after=f'{after:04x}'))
add(reset=1)
for phase in [-1]+list(range(9)):
    for control in range(16):
        add(clear=1)
        if phase>=0:
            add(rx=0)
            for i in range(phase):add(rx=i%2)
        add(rx=(control>>3)&1,step=(control>>2)&1,clear=(control>>1)&1,reset=control&1)
for stop in [0,1]:
    for byte in range(256):
        add(clear=1);add(rx=0)
        for bit in range(8):
            add(rx=(byte//(2**bit))%2)
            if bit==3:add(rx=1-((byte//(2**bit))%2),step=0)
        add(rx=stop);add(rx=1-stop,step=0);add(rx=1)
rng=random.Random(301)
for i in range(10000):add(rng.randrange(2),int(i%5!=0),int(i%113==0),int(i%271==0))
(OUT/'vectors.hex').write_text('\n'.join(vectors)+'\n');(OUT/'cases.json').write_text(json.dumps(cases))
tb='''module tb;
reg clock=0,reset=0,step=0,clear=0,rx=1;
wire[7:0]data;wire[3:0]phase;wire busy,valid,error;
wire[15:0]actual={1'b0,data,phase,busy,valid,error};
UARTBitRX dut(.clock(clock),.reset(reset),.io_step(step),.io_clear(clear),.io_rx(rx),.io_data(data),.io_phase(phase),.io_busy(busy),.io_valid(valid),.io_error(error));
reg[35:0]vectors[0:VECTOR_COUNT-1];integer i;
initial begin
 $readmemh("vectors.hex",vectors);
 for(i=0;i<VECTOR_COUNT;i=i+1)begin
  {rx,step,clear,reset}=vectors[i][35:32];#5;
  if(i>0 && actual!==vectors[i][31:16])begin $display("FAIL PRE %0d %h %h",i,actual,vectors[i][31:16]);$fatal;end
  clock=1;#1;
  if(actual!==vectors[i][15:0])begin $display("FAIL POST %0d %h %h",i,actual,vectors[i][15:0]);$fatal;end
  #4;clock=0;
 end
 $display("PASS VECTOR_COUNT edges");$finish;
end
endmodule
'''.replace('VECTOR_COUNT',str(len(vectors)))
(OUT/'tb.v').write_text(tb);subprocess.run(['iverilog','-g2012','-s','tb','-o','sim',str(BASE/'generated/UARTBitRX.v'),'tb.v'],cwd=OUT,check=True)
run=subprocess.run(['vvp','sim'],cwd=OUT,text=True,capture_output=True,check=True)
report=dict(status='passed',postEdgeSnapshots=len(vectors),preEdgeSnapshots=len(vectors)-1,packedBits=15,coverage='10 phases x 16 controls, all 256 bytes with both stop levels, 10000 random controls',reference='independent Python sampled-bit list',stdout=run.stdout.strip())
(BASE/'evidence/generated-rtl-check.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report))
