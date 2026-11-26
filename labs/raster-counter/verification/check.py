#!/usr/bin/env python3
"""Independent integer reference; temporary vectors are not part of the ZIP."""
import argparse, hashlib, itertools, json, pathlib, random, shutil, subprocess, tempfile

ROOT = pathlib.Path(__file__).resolve().parents[1]

def row(mode, q, limit, enable, reset):
    increment = q + 1
    terminal = int(q == limit)
    candidate = 0 if terminal else increment % 1024
    result = 0 if reset else candidate if enable else q
    return f'{mode} {q} {limit} {enable} {reset} {increment} {terminal} {candidate} {result}\n', result

def trajectory():
    q = 0
    yield row(0, q, 799, 1, 1)[0]
    for limit in [799, 520, 0, 1023, 255, 17]:
        for i in range(2200):
            line, q = row(1, q, limit, int(i % 19 != 0), int(i % 1101 == 0))
            yield line
    rng = random.Random(301)
    for _ in range(20000):
        line, q = row(1, q, rng.randrange(1024), rng.randrange(2), int(rng.randrange(97) == 0))
        yield line

def main():
    parser=argparse.ArgumentParser();parser.add_argument('--web-root',type=pathlib.Path);args=parser.parse_args()
    (ROOT/'evidence').mkdir(exist_ok=True)
    for name in ['verification.json','rtl.log','sample.vcd','waveform.log']:(ROOT/'evidence'/name).unlink(missing_ok=True)
    with tempfile.TemporaryDirectory(prefix='cs301-raster-') as temp:
        temp = pathlib.Path(temp)
        vectors = temp/'vectors.txt'
        count = 0
        with vectors.open('w') as out:
            for q, limit, enable, reset in itertools.product(range(1024), range(1024), range(2), range(2)):
                out.write(row(0, q, limit, enable, reset)[0]); count += 1
            for line in trajectory():
                out.write(line); count += 1
        simulator = temp/'sim'
        subprocess.run(['iverilog','-g2012','-s','tb','-o',str(simulator),str(ROOT/'rtl/RasterCounter.v'),str(ROOT/'verification/tb.sv')],check=True)
        result = subprocess.run(['vvp',str(simulator),f'+vectors={vectors}'],text=True,capture_output=True,check=True)
        (ROOT/'evidence/rtl.log').write_text(result.stdout)
        sample=temp/'sample-vectors.txt'
        sample.write_text(''.join(itertools.islice(trajectory(),1500)))
        waveform=subprocess.run(['vvp',str(simulator),f'+vectors={sample}',f'+wave={temp / "sample.vcd"}'],text=True,capture_output=True,check=True)
        (ROOT/'evidence/waveform.log').write_text(waveform.stdout)
        shutil.copyfile(sample,ROOT/'evidence/sample-vectors.txt')
        shutil.copyfile(temp/'sample.vcd',ROOT/'evidence/sample.vcd')
        if args.web_root:
            web=subprocess.run(['node',str(ROOT/'verification/compare_web.cjs'),str(args.web_root.resolve()),str(vectors)],text=True,capture_output=True,check=True)
            (ROOT/'evidence/web.json').write_text(web.stdout)
            hashes={name:hashlib.sha256((args.web_root/name).read_bytes()).hexdigest() for name in ['architecture.js','anatomy-catalog.js','anatomy-model.js','anatomy-experiments.js']}
            (ROOT/'evidence/web-source-sha256.json').write_text(json.dumps(hashes,indent=2)+'\n')
        with vectors.open('rb') as stream: reference = hashlib.file_digest(stream,'sha256').hexdigest()
        report = {'status':'passed','exhaustiveTransitions':4194304,'trajectoryEdges':33201,'totalEdges':count,'preEdgeChecksPerVector':5,'postEdgeChecksPerVector':1,'vectorSHA256':reference,'rtlSHA256':hashlib.sha256((ROOT/'rtl/RasterCounter.v').read_bytes()).hexdigest(),'boundary':'Exhaustive cases use testbench state deposits; trajectory edges use previous captured q. Functional simulation only; no FPGA mapping or timing proof.'}
        (ROOT/'evidence/verification.json').write_text(json.dumps(report,indent=2)+'\n')
        print(json.dumps(report))

if __name__ == '__main__': main()
