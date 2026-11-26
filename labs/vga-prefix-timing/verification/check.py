#!/usr/bin/env python3
"""Reference uses one flat scan index, independently of the two RTL counters."""
import argparse,hashlib,itertools,json,pathlib,random,shutil,subprocess,tempfile
ROOT=pathlib.Path(__file__).resolve().parents[1]
TOTAL=800*521

def row(mode,index,enable,reset,color):
    y,x=divmod(index,800)
    active=int(x in range(640) and y in range(480))
    hs=int(x not in range(656,752));vs=int(y not in range(490,492))
    address=y*640+x if active else 0
    next_index=0 if reset else (index+enable)%TOTAL
    ny,nx=divmod(next_index,800)
    values=[mode,x,y,enable,reset,color,active,hs,vs,address,color if active else 0,int(enable and x==799),nx,ny,int(x<640),int(y<480),int(x<656),int(x<752),int(y<490),int(y<492)]
    return ' '.join(map(str,values))+'\n',next_index

def trajectory():
    index=0
    yield row(0,index,0,1,0)[0]
    for i in range(TOTAL*2):
        line,index=row(1,index,1,0,(i*37)&4095);yield line
    rng=random.Random(301521)
    for _ in range(20000):
        line,index=row(1,index,rng.randrange(2),int(rng.randrange(137)==0),rng.randrange(4096));yield line

def sample():
    # Start close to line-end and vertical sync. Deposit only the initial state.
    index=489*800+638
    line,index=row(0,index,1,0,0xabc);yield line
    for i in range(2500):
        line,index=row(1,index,int(i%89!=0),0,(i*37)&4095);yield line

def main():
    parser=argparse.ArgumentParser();parser.add_argument('--web-root',type=pathlib.Path);args=parser.parse_args()
    evidence=ROOT/'evidence';evidence.mkdir(exist_ok=True)
    for name in ['verification.json','rtl.log','sample.vcd','waveform.log']:(evidence/name).unlink(missing_ok=True)
    with tempfile.TemporaryDirectory(prefix='cs301-vga-') as folder:
        folder=pathlib.Path(folder);vectors=folder/'vectors.txt';count=0
        with vectors.open('w') as out:
            for index,enable,reset in itertools.product(range(TOTAL),range(2),range(2)):
                out.write(row(0,index,enable,reset,(index*37)&4095)[0]);count+=1
            for index,color in itertools.product([0,479*800+639,640,480*800],range(4096)):
                out.write(row(0,index,1,0,color)[0]);count+=1
            for line in trajectory():out.write(line);count+=1
        sim=folder/'sim'
        subprocess.run(['iverilog','-g2012','-s','tb','-o',str(sim),str(ROOT/'rtl/RasterCounter.v'),str(ROOT/'rtl/Compare10.v'),str(ROOT/'rtl/VGAPrefixTiming.v'),str(ROOT/'verification/tb.sv')],check=True)
        result=subprocess.run(['vvp',str(sim),f'+vectors={vectors}'],text=True,capture_output=True,check=True)
        (evidence/'rtl.log').write_text(result.stdout)
        sample_path=folder/'sample-vectors.txt';sample_path.write_text(''.join(sample()))
        wave=subprocess.run(['vvp',str(sim),f'+vectors={sample_path}',f'+wave={folder / "sample.vcd"}'],text=True,capture_output=True,check=True)
        (evidence/'waveform.log').write_text(wave.stdout)
        for name in ['sample-vectors.txt','sample.vcd']:shutil.copyfile(folder/name,evidence/name)
        if args.web_root:
            result=subprocess.run(['node',str(ROOT/'verification/compare_web.cjs'),str(args.web_root.resolve()),str(vectors)],text=True,capture_output=True,check=True)
            (evidence/'web.json').write_text(result.stdout)
            hashes={name:hashlib.sha256((args.web_root/name).read_bytes()).hexdigest() for name in ['architecture.js','anatomy-catalog.js','anatomy-model.js','anatomy-experiments.js']}
            (evidence/'web-source-sha256.json').write_text(json.dumps(hashes,indent=2)+'\n')
        with vectors.open('rb') as stream:vector_hash=hashlib.file_digest(stream,'sha256').hexdigest()
        report={'status':'passed','coordinateControlCases':TOTAL*4,'colorCases':16384,'trajectoryEdges':TOTAL*2+20001,'totalEdges':count,'preChecksPerVector':17,'postChecksPerVector':2,'sampleEdges':2501,'vectorSHA256':vector_hash,'rtlSHA256':{p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in (ROOT/'rtl').glob('*.v')},'mode':{'visible':[640,480],'total':[800,521],'hsLow':[656,752],'vsLow':[490,492]},'boundary':'Exhaustive phase injects valid initial coordinates. Continuous phase uses prior state. Uniform combinational RGB only; no framebuffer/PLL/XDC/STA/physical monitor verification.'}
        (evidence/'verification.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report))
if __name__=='__main__':main()
