#!/usr/bin/env python3
"""Independent deque specification; compares actual generated Verilog, never imports JS/Scala."""
from pathlib import Path
from collections import deque
import random,json,subprocess
BASE=Path(__file__).resolve().parents[1];OUT=BASE/'out';OUT.mkdir(exist_ok=True)
queue=deque();memory=[0]*4;rp=wp=0;vectors=[];cases=[]
def packed(data,push,pop,step,clear,reset):
    read=bool(step and not(clear or reset) and pop and queue)
    write=bool(step and not(clear or reset) and push and (len(queue)<4 or read))
    state=sum(v<<(8*i) for i,v in enumerate(memory))
    for value,width in [(rp,2),(wp,2),(len(queue),3),(queue[0] if queue else 0,8),(int(bool(queue)),1),(int(not queue),1),(int(len(queue)==4),1),(int(write),1),(int(read),1)]:state=(state<<width)|value
    return state,read,write

def add(data=0,push=0,pop=0,step=1,clear=0,reset=0):
    global rp,wp
    before,read,write=packed(data,push,pop,step,clear,reset)
    if clear or reset:queue.clear();memory[:]=[0]*4;rp=wp=0
    else:
        if read:queue.popleft();rp=(rp+1)%4
        if write:queue.append(data);memory[wp]=data;wp=(wp+1)%4
    after=packed(data,push,pop,step,clear,reset)[0]
    control=(data<<5)|(push<<4)|(pop<<3)|(step<<2)|(clear<<1)|reset
    vectors.append(f'{control:04x}{before:013x}{after:013x}')
    cases.append({'data':data,'push':push,'pop':pop,'step':step,'clear':clear,'reset':reset,'before':f'{before:013x}','after':f'{after:013x}'})
add(reset=1)
for count in range(5):
    for controls in range(32):
        add(clear=1)
        for i in range(count):add(17+i,push=1)
        add(231,push=(controls>>4)&1,pop=(controls>>3)&1,step=(controls>>2)&1,clear=(controls>>1)&1,reset=controls&1)
rng=random.Random(301)
for i in range(20000):add(rng.randrange(256),rng.randrange(2),rng.randrange(2),int(i%5!=0),int(i%113==0),int(i%271==0))
(OUT/'vectors.hex').write_text('\n'.join(vectors)+'\n');(OUT/'cases.json').write_text(json.dumps(cases))
tb='''module tb;
reg clock=0,reset=0,step=0,clear=0,push=0,pop=0;reg [7:0] data=0;
wire [7:0] head,m0,m1,m2,m3;wire [1:0] rp,wp;wire [2:0] count;wire valid,empty,full,wa,ra;
wire [51:0] actual={m3,m2,m1,m0,rp,wp,count,head,valid,empty,full,wa,ra};
TeachingFIFO dut(.clock(clock),.reset(reset),.io_step(step),.io_clear(clear),.io_push(push),.io_pop(pop),.io_data(data),.io_head(head),.io_valid(valid),.io_empty(empty),.io_full(full),.io_pushAccepted(wa),.io_popAccepted(ra),.io_readPointer(rp),.io_writePointer(wp),.io_count(count),.io_saved_0(m0),.io_saved_1(m1),.io_saved_2(m2),.io_saved_3(m3));
reg [119:0] vectors[0:N-1];integer i;
initial begin
 $readmemh("vectors.hex",vectors);
 for(i=0;i<N;i=i+1)begin
  {data,push,pop,step,clear,reset}=vectors[i][116:104];#5;
  if(i>0 && actual!==vectors[i][103:52])begin $display("FAIL PRE %0d %h %h",i,actual,vectors[i][103:52]);$fatal;end
  clock=1;#1;
  if(actual!==vectors[i][51:0])begin $display("FAIL POST %0d %h %h",i,actual,vectors[i][51:0]);$fatal;end
  #4;clock=0;
 end
 $display("PASS N edges");$finish;
end
endmodule
'''.replace('N',str(len(vectors)))
(OUT/'tb.v').write_text(tb)
subprocess.run(['iverilog','-g2012','-s','tb','-o','sim',str(BASE/'generated/TeachingFIFO.v'),'tb.v'],cwd=OUT,check=True)
run=subprocess.run(['vvp','sim'],cwd=OUT,text=True,capture_output=True,check=True)
report={'status':'passed','postEdgeSnapshots':len(vectors),'preEdgeSnapshots':len(vectors)-1,'packedBits':52,'coverage':'all 5 occupancies x 32 push/pop/step/clear/reset combinations plus 20000 deterministic random edges','reference':'independent Python deque plus physical-slot bookkeeping','stdout':run.stdout.strip()}
(BASE/'evidence/generated-rtl-check.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report))
