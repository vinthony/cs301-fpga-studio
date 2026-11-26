from pathlib import Path
import subprocess,shutil,json
root=Path(__file__).resolve().parents[1];out=root/'verification/out';out.mkdir(exist_ok=True);vectors=[]
for mask in range(32):
 for sw in [0,0x35,0xffff]:
  expected=((mask&15)<<12)|0xfff
  vectors.append((((mask<<16)|sw)<<28)|expected)
(out/'vectors.hex').write_text('\n'.join(f'{v:013x}' for v in vectors)+'\n')
(out/'tb.sv').write_text('''module tb;
reg clock=0,reset=0;reg [4:0] io_buttons=0;reg [15:0] io_switches=0;
wire [15:0] io_leds;wire [6:0] io_seg;wire [3:0] io_an;wire io_dp;
TeachingButtonTop dut(.*);reg [48:0] vectors[0:95];integer i;
initial begin
$readmemh("vectors.hex",vectors);
for(i=0;i<96;i=i+1)begin
{io_buttons,io_switches}=vectors[i][48:28];#1;
if({io_leds,io_seg,io_an,io_dp} !== vectors[i][27:0])$fatal(1,"mismatch at %d",i);
end
$display("PASS 96 vectors: four LED map, unused D/SW, upper LEDs and display blank, no clocks");$finish;
end
endmodule
''')
subprocess.run([shutil.which('iverilog') or '/opt/homebrew/bin/iverilog','-g2012','-s','tb','-o',str(out/'sim'),str(root/'generated/TeachingButtonTop.v'),str(out/'tb.sv')],check=True)
r=subprocess.run([shutil.which('vvp') or '/opt/homebrew/bin/vvp',str(out/'sim')],cwd=out,check=True,capture_output=True,text=True)
report={'status':'passed','vectors':96,'button_patterns':32,'switch_patterns':[0,53,65535],'clock_edges':0,'simulator':'Icarus Verilog','oracle':'independent bit mapping and constant inactive display codes','output':r.stdout};(root/'evidence/generated-rtl-check.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report))
