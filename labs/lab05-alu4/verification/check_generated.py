from pathlib import Path
import subprocess,shutil,json
root=Path(__file__).resolve().parents[1];out=root/'verification/out';out.mkdir(exist_ok=True);vectors=[]
for a in range(16):
 for b in range(16):
  sa=a if a<8 else a-16;sb=b if b<8 else b-16;k=b%4
  values=[a+b,a-b,a&b,a|b,a^b,a*2**k,a//2**k,sa//2**k,int(sa<sb),int(a<b)]+[0]*6
  for op,value in enumerate(values):
   v=value%16;arith=op<2;carry=int(a+b>=16) if op==0 else int(a>=b) if op==1 else 0
   exact=sa+sb if op==0 else sa-sb;overflow=int(arith and not(-8<=exact<=7))
   expected=(v<<6)|(int(v==0)<<5)|((v//8)<<4)|(carry<<3)|(overflow<<2)|(int(arith)<<1)|int(op<10)
   vectors.append((((a<<8)|(b<<4)|op)<<10)|expected)
(out/'vectors.hex').write_text('\n'.join(f'{v:06x}' for v in vectors)+'\n')
(out/'tb.sv').write_text('''module tb;
reg clock=0,reset=0;reg [3:0] io_a=0,io_b=0,io_op=0;
wire [3:0] io_result;wire io_zero,io_sign,io_carry,io_overflow,io_flagsValid,io_operationValid;
ALU4 dut(.*);reg [21:0] vectors[0:4095];integer i;
initial begin
$readmemh("vectors.hex",vectors);
for(i=0;i<4096;i=i+1)begin
{io_a,io_b,io_op}=vectors[i][21:10];#1;
if({io_result,io_zero,io_sign,io_carry,io_overflow,io_flagsValid,io_operationValid} !== vectors[i][9:0])$fatal(1,"mismatch %d",i);
end
$display("PASS 4096 vectors: all four-bit operands and opcodes, result and flags, no clocks");$finish;
end
endmodule
''')
subprocess.run([shutil.which('iverilog') or '/opt/homebrew/bin/iverilog','-g2012','-s','tb','-o',str(out/'sim'),str(root/'generated/ALU4.v'),str(out/'tb.sv')],check=True)
r=subprocess.run([shutil.which('vvp') or '/opt/homebrew/bin/vvp',str(out/'sim')],cwd=out,check=True,capture_output=True,text=True)
report={'status':'passed','vectors':4096,'supported_operations':10,'invalid_opcodes':6,'clock_edges':0,'simulator':'Icarus Verilog','oracle':'independent Python integer and signed arithmetic','output':r.stdout};(root/'evidence/generated-rtl-check.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report))
