from pathlib import Path
import subprocess,shutil,json,random
root=Path(__file__).resolve().parents[1];out=root/'verification/out';out.mkdir(exist_ok=True);rng=random.Random(301);mask=(1<<32)-1
edges=[0,1,2,31,32,33,0x7fffffff,0x80000000,mask,0xaaaaaaaa,0x55555555]
pairs=[(a,b) for a in edges for b in edges]+[(rng.getrandbits(32),rng.getrandbits(32)) for _ in range(4096)];vectors=[]
for a,b in pairs:
 sa=a if a<(1<<31) else a-(1<<32);sb=b if b<(1<<31) else b-(1<<32);k=b%32
 values=[a+b,a-b,a&b,a|b,a^b,a*2**k,a//2**k,sa//2**k,int(sa<sb),int(a<b)]+[0]*6
 for op,value in enumerate(values):
  v=value&mask;arith=op<2;c=int(a+b>mask) if op==0 else int(a>=b) if op==1 else 0
  exact=sa+sb if op==0 else sa-sb;overflow=int(arith and not(-(1<<31)<=exact<(1<<31)))
  expected=(v<<6)|(int(v==0)<<5)|((v>>31)<<4)|(c<<3)|(overflow<<2)|(int(arith)<<1)|int(op<10)
  vectors.append((((a<<36)|(b<<4)|op)<<38)|expected)
(out/'vectors.hex').write_text('\n'.join(f'{v:027x}' for v in vectors)+'\n')
(out/'tb.sv').write_text('''module tb;
reg clock=0,reset=0;reg [31:0] io_a=0,io_b=0;reg [3:0] io_op=0;
wire [31:0] io_result;wire io_zero,io_sign,io_carry,io_overflow,io_flagsValid,io_operationValid;
ALU32 dut(.*);reg [105:0] vectors[0:N-1];integer i;
initial begin
$readmemh("vectors.hex",vectors);
for(i=0;i<N;i=i+1)begin
{io_a,io_b,io_op}=vectors[i][105:38];#1;
if({io_result,io_zero,io_sign,io_carry,io_overflow,io_flagsValid,io_operationValid} !== vectors[i][37:0])$fatal(1,"mismatch %d",i);
end
$display("PASS N vectors: 32-bit result and flags, no clocks");$finish;
end
endmodule
'''.replace('N',str(len(vectors))))
subprocess.run([shutil.which('iverilog') or '/opt/homebrew/bin/iverilog','-g2012','-s','tb','-o',str(out/'sim'),str(root/'generated/ALU32.v'),str(out/'tb.sv')],check=True)
r=subprocess.run([shutil.which('vvp') or '/opt/homebrew/bin/vvp',str(out/'sim')],cwd=out,check=True,capture_output=True,text=True)
report={'status':'passed','vectors':len(vectors),'operand_pairs':len(pairs),'supported_operations':10,'invalid_opcodes':6,'clock_edges':0,'simulator':'Icarus Verilog','oracle':'independent Python arbitrary-precision arithmetic','output':r.stdout};(root/'evidence/generated-rtl-check.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report))
