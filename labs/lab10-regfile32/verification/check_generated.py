from pathlib import Path
import subprocess,shutil,json,random
root=Path(__file__).resolve().parents[1];out=root/'verification/out';out.mkdir(exist_ok=True);rng=random.Random(301);mask=(1<<32)-1;bank=[0]*32;vectors=[]
def read(ra,rb,wa,wd,we,bypass,clear,reset):
 fa=int(ra!=0 and ra==wa and we and bypass and not(clear or reset));fb=int(rb!=0 and rb==wa and we and bypass and not(clear or reset))
 rawA=bank[ra] if ra else 0;rawB=bank[rb] if rb else 0
 packed=0
 for v in [wd if fa else rawA,wd if fb else rawB,rawA,rawB]:packed=(packed<<32)|v
 return (packed<<2)|(fa<<1)|fb
requests=[]
for i in range(4097):
 reset=int(i==0 or i%271==0);clear=int(i>0 and i%127==0);bypass=rng.randrange(2);we=1 if 1<=i<=32 else rng.randrange(2)
 wa=i-1 if 1<=i<=32 else 0 if i%11==0 else rng.randrange(32)
 ra=wa if i%3==0 or i<=32 else rng.randrange(32);rb=wa if i%5==0 else rng.randrange(32)
 wd=((i*0x1020304)^0x55555555)&mask if i<=32 else rng.getrandbits(32)
 requests.append((ra,rb,wa,wd,we,bypass,clear,reset))
requests.extend((a,b,0,mask,0,0,0,0) for a in range(32) for b in range(32))
for ra,rb,wa,wd,we,bypass,clear,reset in requests:
 before=read(ra,rb,wa,wd,we,bypass,clear,reset)
 if clear or reset:bank=[0]*32
 elif we and wa:bank[wa]=wd
 after=read(ra,rb,wa,wd,we,bypass,clear,reset)
 control=(reset<<50)|(clear<<49)|(bypass<<48)|(we<<47)|(ra<<42)|(rb<<37)|(wa<<32)|wd
 vectors.append((control<<260)|(before<<130)|after)
(out/'vectors.hex').write_text('\n'.join(f'{v:078x}' for v in vectors)+'\n')
(out/'tb.sv').write_text('''`timescale 1ns/1ps
module tb;
reg clock=0,reset=0;reg [4:0] io_ra=0,io_rb=0,io_wa=0;reg [31:0] io_wd=0;
reg io_we=0,io_bypass=0,io_clear=0;
wire [31:0] io_qa,io_qb,io_rawA,io_rawB;wire io_forwardA,io_forwardB;
RegFile32 dut(.*);reg [310:0] vectors[0:N-1];integer i;
wire [129:0] observed={io_qa,io_qb,io_rawA,io_rawB,io_forwardA,io_forwardB};
initial begin
$readmemh("vectors.hex",vectors);
for(i=0;i<N;i=i+1)begin
clock=0;{reset,io_clear,io_bypass,io_we,io_ra,io_rb,io_wa,io_wd}=vectors[i][310:260];#4;
if(i>0 && observed !== vectors[i][259:130])$fatal(1,"before edge %d",i);
clock=1;#1;
if(observed !== vectors[i][129:0])$fatal(1,"after edge %d",i);
#5;
end
$display("PASS N edges with pre/post raw, bypass and two reads");$finish;
end
endmodule
'''.replace('N',str(len(vectors))))
subprocess.run([shutil.which('iverilog') or '/opt/homebrew/bin/iverilog','-g2012','-s','tb','-o',str(out/'sim'),str(root/'generated/RegFile32.v'),str(out/'tb.sv')],check=True)
r=subprocess.run([shutil.which('vvp') or '/opt/homebrew/bin/vvp',str(out/'sim')],cwd=out,check=True,capture_output=True,text=True)
report={'status':'passed','edges':len(vectors),'before_snapshots':len(vectors)-1,'after_snapshots':len(vectors),'final_read_pairs':1024,'simulator':'Icarus Verilog','oracle':'independent Python saved-bank and bypass state model','output':r.stdout};(root/'evidence/generated-rtl-check.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report))
