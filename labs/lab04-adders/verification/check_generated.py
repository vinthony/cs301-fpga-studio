from pathlib import Path
import subprocess,shutil,json
root=Path(__file__).resolve().parents[1];out=root/'verification/out';out.mkdir(exist_ok=True);vectors=[]
for a in range(16):
 for b in range(16):
  for cin in range(2):
   total=a+b+cin;carry=cin
   for k in range(1,5):
    if ((a&((1<<k)-1))+(b&((1<<k)-1))+cin)>=(1<<k):carry|=1<<k
   expected=(1<<20)|(total<<15)|(total<<10)|(carry<<5)|carry
   vectors.append((((a<<5)|(b<<1)|cin)<<21)|expected)
(out/'vectors.hex').write_text('\n'.join(f'{v:08x}' for v in vectors)+'\n')
(out/'tb.sv').write_text('''module tb;
reg clock=0,reset=0;reg [3:0] io_a=0,io_b=0;reg io_cin=0;
wire [4:0] io_ripple,io_lookahead,io_rippleCarries,io_lookaheadCarries;wire io_equal;
CompareAdders4 dut(.*);reg [29:0] vectors[0:511];integer i;
initial begin
$readmemh("vectors.hex",vectors);
for(i=0;i<512;i=i+1)begin
{io_a,io_b,io_cin}=vectors[i][29:21];#1;
if({io_equal,io_ripple,io_lookahead,io_rippleCarries,io_lookaheadCarries} !== vectors[i][20:0])$fatal(1,"mismatch at %d",i);
end
$display("PASS 512 combinations, RCA/CLA sums and all carries, no clock edges");$finish;
end
endmodule
''')
subprocess.run([shutil.which('iverilog') or '/opt/homebrew/bin/iverilog','-g2012','-s','tb','-o',str(out/'sim'),str(root/'generated/CompareAdders4.v'),str(out/'tb.sv')],check=True)
r=subprocess.run([shutil.which('vvp') or '/opt/homebrew/bin/vvp',str(out/'sim')],cwd=out,check=True,capture_output=True,text=True)
report={'status':'passed','combinations':512,'clock_edges':0,'checks':'both full sums, both five-bit carry chains, equality flag','oracle':'Python arithmetic and independently computed lower-prefix carries','simulator':'Icarus Verilog','output':r.stdout};(root/'evidence/generated-rtl-check.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report))
