from pathlib import Path
import subprocess,shutil,json
root=Path(__file__).resolve().parents[1];out=root/'verification/out';out.mkdir(exist_ok=True);vectors=[]
for a in range(16):
 for b in range(16):
  for sel in range(2):
   x=a%2;y=b%2
   gates=(x*y)|((int(x+y>0))<<1)|((1-x)<<2)|((int(x!=y))<<3)|((1-x*y)<<4)|((int(x+y==0))<<5)
   expected=(gates<<4)|(((b if sel else a)%2)<<3)|(int(a<b)<<2)|(int(a==b)<<1)|int(a>b)
   vectors.append((((a<<5)|(b<<1)|sel)<<10)|expected)
(out/'vectors.hex').write_text('\n'.join(f'{v:05x}' for v in vectors)+'\n')
(out/'tb.sv').write_text('''module tb;
reg clock=0,reset=0;reg [3:0] io_a=0,io_b=0;reg io_select=0;
wire [5:0] io_gates;wire io_selected,io_lt,io_eq,io_gt;
LogicTop dut(.*);reg [18:0] vectors[0:511];integer i;
initial begin
$readmemh("vectors.hex",vectors);
for(i=0;i<512;i=i+1)begin
{io_a,io_b,io_select}=vectors[i][18:10];#1;
if({io_gates,io_selected,io_lt,io_eq,io_gt} !== vectors[i][9:0])$fatal(1,"mismatch at %d",i);
end
$display("PASS 512 vectors: six gates, MUX, three comparison flags, no clocks");$finish;
end
endmodule
''')
subprocess.run([shutil.which('iverilog') or '/opt/homebrew/bin/iverilog','-g2012','-s','tb','-o',str(out/'sim'),str(root/'generated/LogicTop.v'),str(out/'tb.sv')],check=True)
r=subprocess.run([shutil.which('vvp') or '/opt/homebrew/bin/vvp',str(out/'sim')],cwd=out,check=True,capture_output=True,text=True)
report={'status':'passed','vectors':512,'clock_edges':0,'simulator':'Icarus Verilog','oracle':'independent Python Boolean/arithmetic relationships','outputs':'6 gates + MUX + lt/eq/gt','output':r.stdout};(root/'evidence/generated-rtl-check.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report))
