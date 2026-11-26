#!/usr/bin/env python3
"""Closed-form integer prefixes, independently of gate recurrence."""
import argparse,hashlib,itertools,json,pathlib,shutil,subprocess,tempfile
ROOT=pathlib.Path(__file__).resolve().parents[1]
def vector(a,b):
    emask=1<<10;lmask=0
    for bit in range(10):
        high_a=a//(2**bit);high_b=b//(2**bit)
        emask|=int(high_a==high_b)<<bit
        lmask|=int(high_a<high_b)<<bit
    return f'{a} {b} {int(a==b)} {int(a<b)} {emask} {lmask}\n'
def run(args):
    result=subprocess.run(args,text=True,capture_output=True)
    if result.returncode:raise RuntimeError(result.stdout+'\n'+result.stderr)
    return result.stdout

def main():
    parser=argparse.ArgumentParser();parser.add_argument('--web-root',type=pathlib.Path);args=parser.parse_args()
    evidence=ROOT/'evidence';evidence.mkdir(exist_ok=True)
    for name in ['verification.json','rtl.log','sample.vcd']:(evidence/name).unlink(missing_ok=True)
    with tempfile.TemporaryDirectory(prefix='cs301-compare10-') as folder:
        folder=pathlib.Path(folder);vectors=folder/'vectors.txt';bit_vectors=folder/'bit-vectors.txt'
        with vectors.open('w') as out:
            for a,b in itertools.product(range(1024),repeat=2):out.write(vector(a,b))
        # Truth table enumeration in terms of semantic cases, not copied gates.
        with bit_vectors.open('w') as out:
            for a,b,e,l in itertools.product(range(2),repeat=4):
                out.write(f'{a} {b} {e} {l} {int(bool(e) and a==b)} {int(bool(l) or bool(e) and a<b)}\n')
        rtl=ROOT/'rtl/Compare10.v';tb=ROOT/'verification/tb.sv'
        logs=[]
        for top,file in [('tb',vectors),('tb_bit',bit_vectors)]:
            sim=folder/top;run(['iverilog','-g2012','-s',top,'-o',str(sim),str(rtl),str(tb)])
            logs.append(run(['vvp',str(sim),f'+vectors={file}']))
        (evidence/'rtl.log').write_text('\n'.join(logs))
        sample=folder/'sample-vectors.txt';pairs=[(0,0),(0,1),(1,0),(511,512),(512,511),(655,656),(656,656),(657,656),(1023,1023),(1023,0),(0,1023),(513,514),(514,513),(640,640),(639,640),(480,480)]
        sample.write_text(''.join(vector(a,b) for a,b in pairs))
        log=run(['vvp',str(folder/'tb'),f'+vectors={sample}',f'+wave={folder/"sample.vcd"}']);(evidence/'waveform.log').write_text(log)
        for name in ['sample-vectors.txt','sample.vcd']:shutil.copyfile(folder/name,evidence/name)
        shutil.copyfile(bit_vectors,evidence/'bit-vectors.txt')
        if args.web_root:
            log=run(['node',str(ROOT/'verification/compare_web.cjs'),str(args.web_root.resolve()),str(vectors),str(bit_vectors)]);(evidence/'web.json').write_text(log)
            names=['architecture.js','anatomy-catalog.js','anatomy-model.js','anatomy-experiments.js']
            (evidence/'web-source-sha256.json').write_text(json.dumps({name:hashlib.sha256((args.web_root/name).read_bytes()).hexdigest() for name in names},indent=2)+'\n')
        with vectors.open('rb') as stream:sha=hashlib.file_digest(stream,'sha256').hexdigest()
        report={'status':'passed','allWordPairs':1048576,'singleBitTruthCases':16,'comparedBitsPerWordPair':24,'prefixBitsPerWordPair':22,'samplePairs':len(pairs),'rtlSHA256':hashlib.sha256(rtl.read_bytes()).hexdigest(),'vectorSHA256':sha,'reference':'Integer division compares every high prefix directly; no EQ/LT recurrence in Python oracle.','boundary':'Combinational functional simulation only. No clock, state, mapping, vendor netlist, propagation-delay or physical-board proof.'}
        (evidence/'verification.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report))
if __name__=='__main__':main()
