#!/usr/bin/env python3
"""Independent primary-clock counter plus encoded-frame reference."""
from pathlib import Path
import json,random,subprocess
BASE=Path(__file__).resolve().parents[1];OUT=BASE/'out';OUT.mkdir(exist_ok=True)
DIVISOR=868
count=0;frame=[];position=-1;captured=done=0;vectors=[];web_groups=[]
def packed(data,send,enable,clear,reset):
    tick=int(enable and not(clear or reset) and count==DIVISOR-1)
    busy=int(bool(frame));tx=frame[position] if frame else 1;phase=position if frame else 15
    accepted=int(tick and send and not busy)
    return (count<<17)|(captured<<9)|(phase<<5)|(tx<<4)|(busy<<3)|(done<<2)|(accepted<<1)|tick

def add(data=0,send=0,enable=1,clear=0,reset=0):
    global count,frame,position,captured,done
    before=packed(data,send,enable,clear,reset)
    tick=enable and count==DIVISOR-1
    if clear or reset:count=0;frame=[];position=-1;captured=done=0
    else:
        if enable:count=(count+1)%DIVISOR
        if tick:
            done=0
            if not frame:
                if send:captured=data;frame=[0]+[(data//2**i)%2 for i in range(8)]+[1];position=0
            elif position==9:frame=[];position=-1;done=1
            else:position+=1
    after=packed(data,send,enable,clear,reset)
    control=(data<<4)|(send<<3)|(enable<<2)|(clear<<1)|reset
    vectors.append(f'{control:04x}{before:07x}{after:07x}')
add(reset=1)
for byte in [0,1,65,85,128,254,255]:
    add(clear=1);group_start=len(vectors)
    for cycle in range(11*DIVISOR):
        add(byte if cycle<DIVISOR else 255-byte,send=int(cycle<DIVISOR))
        if cycle%868==217:
            for _ in range(3):add(123,send=1,enable=0)
    for _ in range(3):add(enable=0)
    web_groups.append({'byte':byte,'vectors':vectors[group_start:]})
# Held send requests are accepted again only after returning to idle.
add(clear=1)
for cycle in range(23*DIVISOR):add(65 if cycle<12*DIVISOR-1 else 90,send=1)
# Deliberate clear and reset while the terminal comparison is active, including disabled clock enables.
for control in range(16):
    add(clear=1)
    for _ in range(DIVISOR-1):add(33,send=1)
    add(211,send=(control>>3)&1,enable=(control>>2)&1,clear=(control>>1)&1,reset=control&1)
rng=random.Random(301)
for i in range(10000):add(rng.randrange(256),rng.randrange(2),int(i%5!=0),int(i%113==0),int(i%271==0))
(OUT/'vectors.hex').write_text('\n'.join(vectors)+'\n');(OUT/'web-cases.json').write_text(json.dumps(web_groups))
tb='''module tb;
reg clock=0,reset=0,enable=0,clear=0,send=0;reg[7:0]data=0;
wire[9:0]count;wire tick,tx,busy,done,accepted;wire[3:0]phase;wire[7:0]captured;
wire[27:0]actual={1'b0,count,captured,phase,tx,busy,done,accepted,tick};
BaudUARTTX dut(.clock(clock),.reset(reset),.io_enable(enable),.io_clear(clear),.io_send(send),.io_data(data),.io_count(count),.io_tick(tick),.io_tx(tx),.io_busy(busy),.io_done(done),.io_accepted(accepted),.io_phase(phase),.io_captured(captured));
reg[71:0]vectors[0:VECTOR_COUNT-1];integer i;
initial begin
 $readmemh("vectors.hex",vectors);
 for(i=0;i<VECTOR_COUNT;i=i+1)begin
  {data,send,enable,clear,reset}=vectors[i][67:56];#5;
  if(i>0 && actual!==vectors[i][55:28])begin $display("FAIL PRE %0d %h %h",i,actual,vectors[i][55:28]);$fatal;end
  clock=1;#1;
  if(actual!==vectors[i][27:0])begin $display("FAIL POST %0d %h %h",i,actual,vectors[i][27:0]);$fatal;end
  #4;clock=0;
 end
 $display("PASS VECTOR_COUNT primary clock edges");$finish;
end
endmodule
'''.replace('VECTOR_COUNT',str(len(vectors)))
(OUT/'tb.v').write_text(tb);subprocess.run(['iverilog','-g2012','-s','tb','-o','sim',str(BASE/'generated/BaudUARTTX.v'),'tb.v'],cwd=OUT,check=True)
run=subprocess.run(['vvp','sim'],cwd=OUT,text=True,capture_output=True,check=True)
report=dict(status='passed',postEdgeSnapshots=len(vectors),preEdgeSnapshots=len(vectors)-1,packedBits=27,divisor=DIVISOR,coverage='7 directed byte frames, held requests over multiple frames, all 16 terminal-control combinations, pauses and 10000 random clocks',reference='independent Python count and encoded-frame list',stdout=run.stdout.strip())
(BASE/'evidence/generated-rtl-check.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report))
