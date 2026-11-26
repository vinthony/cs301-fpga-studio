from pathlib import Path
import shutil,subprocess,json
root=Path(__file__).resolve().parents[1];out=root/'verification'/'out';out.mkdir(exist_ok=True)
vectors=[]
for word in range(4096):
 vectors.append(1<<9);history='';count=0
 for bit in f'{word:012b}':
  history+=bit;hit=int(history.endswith('1011'));count+=hit
  state=max(k for k in range(4) if history.endswith('1011'[:k]))
  vectors.append((1<<8)|(int(bit)<<7)|(state<<5)|(hit<<4)|count)
(out/'vectors.hex').write_text('\n'.join(f'{v:03x}' for v in vectors)+'\n')
tb='''module tb;
reg clock=0, reset=0, io_enable=0, io_bitIn=0;
wire [1:0] io_state,io_nextState;wire io_candidate,io_hit;wire [31:0] io_count;
Sequence1011 dut(.*);
reg [9:0] vectors[0:N-1];integer i;
initial begin
 $readmemh("vectors.hex",vectors);
 for(i=0;i<N;i=i+1)begin
 clock=0;{reset,io_enable,io_bitIn}=vectors[i][9:7];#4;
 if(io_candidate !== (reset?1'b0:vectors[i][4]))$fatal(1,"candidate %d",i);
 clock=1;#1;
 if(io_state !== vectors[i][6:5] || io_hit !== vectors[i][4] || io_count !== {28'b0,vectors[i][3:0]})$fatal(1,"saved state %d",i);
 #5;
 end
 $display("PASS %d sampled vectors",N);$finish;
end
endmodule
'''.replace('N',str(len(vectors)))
(out/'tb.sv').write_text(tb)
compiler=shutil.which('iverilog') or '/opt/homebrew/bin/iverilog';runner=shutil.which('vvp') or '/opt/homebrew/bin/vvp'
subprocess.run([compiler,'-g2012','-s','tb','-o',str(out/'sim'),str(root/'generated'/'Sequence1011.v'),str(out/'tb.sv')],check=True)
r=subprocess.run([runner,str(out/'sim')],cwd=out,check=True,capture_output=True,text=True)
report={'status':'passed','streams':4096,'sampled_vectors':len(vectors),'rtl':'generated/Sequence1011.v','reference':'independent Python string suffix and longest-prefix oracle','simulator':'Icarus Verilog','output':r.stdout.strip()}
(root/'evidence'/'generated-rtl-check.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report))
