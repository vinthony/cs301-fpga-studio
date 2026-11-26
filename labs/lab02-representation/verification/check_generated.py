from pathlib import Path
import subprocess,shutil,json
root=Path(__file__).resolve().parents[1];out=root/'verification'/'out';out.mkdir(exist_ok=True)
sm=[0,1,2,3,4,5,6,7,0,-1,-2,-3,-4,-5,-6,-7]
oc=[0,1,2,3,4,5,6,7,-7,-6,-5,-4,-3,-2,-1,0]
tc=[0,1,2,3,4,5,6,7,-8,-7,-6,-5,-4,-3,-2,-1]
expect=[(w<<16)|((sm[w]&31)<<11)|(int(w==8)<<10)|((oc[w]&31)<<5)|(int(w==15)<<4)|(tc[w]&15) for w in range(16)]
(out/'expected.hex').write_text('\n'.join(f'{v:05x}' for v in expect)+'\n')
(out/'tb.sv').write_text('''module tb;
reg clock=0,reset=0;reg [3:0] io_bits=0;
wire [3:0] io_unsigned;wire signed [4:0] io_signMagnitude,io_onesComplement;
wire io_signMagnitudeNegativeZero,io_onesComplementNegativeZero;
wire signed [3:0] io_twosComplement;
Representation4 dut(.*);
reg [19:0] expected[0:15];integer i;
initial begin
$readmemh("expected.hex",expected);
for(i=0;i<16;i=i+1)begin
io_bits=i;#1;
if({io_unsigned,io_signMagnitude,io_signMagnitudeNegativeZero,io_onesComplement,io_onesComplementNegativeZero,io_twosComplement} !== expected[i])$fatal(1,"mismatch at %d",i);
end
$display("PASS 16 patterns, 6 outputs each, no clock edges");$finish;
end
endmodule
''')
subprocess.run([shutil.which('iverilog') or '/opt/homebrew/bin/iverilog','-g2012','-s','tb','-o',str(out/'sim'),str(root/'generated/Representation4.v'),str(out/'tb.sv')],check=True)
r=subprocess.run([shutil.which('vvp') or '/opt/homebrew/bin/vvp',str(out/'sim')],cwd=out,check=True,capture_output=True,text=True)
report={'status':'passed','patterns':16,'outputs_per_pattern':6,'clock_edges':0,'rtl':'generated/Representation4.v','simulator':'Icarus Verilog','reference':'explicit independently enumerated interpretation/negative-zero arrays','output':r.stdout}
(root/'evidence/generated-rtl-check.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report))
