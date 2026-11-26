from pathlib import Path
import subprocess,shutil,json,random
root=Path(__file__).resolve().parents[1];out=root/'verification/out';out.mkdir(exist_ok=True);rng=random.Random(301);vectors=[];q=count=phase=led=0
for i in range(2049):
 data=rng.randrange(16);reset=int(i==0 or i%97==0);clear=int(i%29==0);enable=1 if i<40 else rng.randrange(2)
 if clear and i>=40:enable=0
 if reset or clear:q=count=phase=led=0
 elif enable:
  q=data;count=(count+1)%16
  if phase==2:phase=0;led^=1
  else:phase+=1
 packed=(q<<11)|(q<<7)|(count<<3)|(led<<2)|phase
 control=(reset<<6)|(clear<<5)|(enable<<4)|data
 vectors.append((control<<15)|packed)
(out/'vectors.hex').write_text('\n'.join(f'{v:06x}' for v in vectors)+'\n')
(out/'tb.sv').write_text('''`timescale 1ns/1ps
module tb;
reg clock=0,reset=0;reg [3:0] io_data=0;reg io_enable=0,io_clear=0;
wire [3:0] io_qInit,io_qEnable,io_count;wire io_blink;wire [1:0] io_phase;
StateDemoTop dut(.*);reg [21:0] vectors[0:2048];reg [14:0] previous;integer i;
wire [14:0] observed={io_qInit,io_qEnable,io_count,io_blink,io_phase};
initial begin
$readmemh("vectors.hex",vectors);
for(i=0;i<2049;i=i+1)begin
clock=0;{reset,io_clear,io_enable,io_data}=vectors[i][21:15];#4;
if(i>0 && observed !== previous)$fatal(1,"changed before edge %d",i);
clock=1;#1;
if(observed !== vectors[i][14:0])$fatal(1,"after edge %d",i);
previous=vectors[i][14:0];#5;
end
$display("PASS 2049 edges and 2048 before-edge holds: register/counter/divider/reset/enable");$finish;
end
endmodule
''')
subprocess.run([shutil.which('iverilog') or '/opt/homebrew/bin/iverilog','-g2012','-s','tb','-o',str(out/'sim'),str(root/'generated/StateDemoTop.v'),str(out/'tb.sv')],check=True)
r=subprocess.run([shutil.which('vvp') or '/opt/homebrew/bin/vvp',str(out/'sim')],cwd=out,check=True,capture_output=True,text=True)
report={'status':'passed','edges':2049,'pre_edge_holds':2048,'simulator':'Icarus Verilog','oracle':'independent Python state transitions with reset/clear priority and disabled holds','output':r.stdout};(root/'evidence/generated-rtl-check.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report))
