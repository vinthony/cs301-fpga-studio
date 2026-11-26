#!/usr/bin/env python3
"""Independent frame-list transmitter reference against generated Verilog."""
from pathlib import Path
import random,json,subprocess
BASE=Path(__file__).resolve().parents[1];OUT=BASE/'out';OUT.mkdir(exist_ok=True)
frame=[];position=-1;captured=0;done=0;vectors=[];cases=[]
def packed(data,send,step,clear,reset):
    busy=int(bool(frame));tx=frame[position] if frame else 1;phase=position if frame else 15
    accepted=int(step and not(clear or reset) and send and not busy)
    return (captured<<8)|(phase<<4)|(tx<<3)|(busy<<2)|(done<<1)|accepted

def add(data=0,send=0,step=1,clear=0,reset=0):
    global frame,position,captured,done
    before=packed(data,send,step,clear,reset)
    if clear or reset:frame=[];position=-1;captured=0;done=0
    elif step:
        done=0
        if not frame:
            if send:frame=[0]+[(data//(2**i))%2 for i in range(8)]+[1];captured=data;position=0
        elif position==9:frame=[];position=-1;done=1
        else:position+=1
    after=packed(data,send,step,clear,reset)
    control=(data<<4)|(send<<3)|(step<<2)|(clear<<1)|reset
    vectors.append(f'{control:04x}{before:04x}{after:04x}')
    cases.append(dict(data=data,send=send,step=step,clear=clear,reset=reset,before=f'{before:04x}',after=f'{after:04x}'))
add(reset=1)
for phase in [-1]+list(range(10)):
    for control in range(16):
        add(clear=1)
        if phase>=0:
            add(165,send=1)
            for _ in range(phase):add(90,send=1)
        add(37,send=(control>>3)&1,step=(control>>2)&1,clear=(control>>1)&1,reset=control&1)
for byte in range(256):
    add(clear=1);add(byte,send=1)
    for i in range(9):add(255-byte,send=1)
    add(255-byte,step=0);add(255-byte,send=1);add(step=0)
rng=random.Random(301)
for i in range(10000):add(rng.randrange(256),rng.randrange(2),int(i%5!=0),int(i%113==0),int(i%271==0))
(OUT/'vectors.hex').write_text('\n'.join(vectors)+'\n');(OUT/'cases.json').write_text(json.dumps(cases))
tb='''module tb;
reg clock=0,reset=0,step=0,clear=0,send=0;reg[7:0]data=0;
wire tx,busy,done,accepted;wire[3:0]phase;wire[7:0]captured;
wire[15:0]actual={captured,phase,tx,busy,done,accepted};
UARTBitTX dut(.clock(clock),.reset(reset),.io_step(step),.io_clear(clear),.io_send(send),.io_data(data),.io_tx(tx),.io_busy(busy),.io_done(done),.io_accepted(accepted),.io_phase(phase),.io_captured(captured));
reg[47:0]vectors[0:VECTOR_COUNT-1];integer i;
initial begin
 $readmemh("vectors.hex",vectors);
 for(i=0;i<VECTOR_COUNT;i=i+1)begin
  {data,send,step,clear,reset}=vectors[i][43:32];#5;
  if(i>0 && actual!==vectors[i][31:16])begin $display("FAIL PRE %0d %h %h",i,actual,vectors[i][31:16]);$fatal;end
  clock=1;#1;
  if(actual!==vectors[i][15:0])begin $display("FAIL POST %0d %h %h",i,actual,vectors[i][15:0]);$fatal;end
  #4;clock=0;
 end
 $display("PASS VECTOR_COUNT edges");$finish;
end
endmodule
'''.replace('VECTOR_COUNT',str(len(vectors)))
(OUT/'tb.v').write_text(tb);subprocess.run(['iverilog','-g2012','-s','tb','-o','sim',str(BASE/'generated/UARTBitTX.v'),'tb.v'],cwd=OUT,check=True)
run=subprocess.run(['vvp','sim'],cwd=OUT,text=True,capture_output=True,check=True)
report=dict(status='passed',postEdgeSnapshots=len(vectors),preEdgeSnapshots=len(vectors)-1,packedBits=16,coverage='11 phases x 16 control combinations, all 256 bytes, 10000 random controls',reference='independent Python encoded frame list',stdout=run.stdout.strip())
(BASE/'evidence/generated-rtl-check.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report))
