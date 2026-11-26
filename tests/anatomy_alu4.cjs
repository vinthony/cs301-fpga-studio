const fs=require('fs'),vm=require('vm'),path=require('path'),base=path.resolve(__dirname,'..'),ctx=vm.createContext({});for(const f of ['architecture.js','anatomy-catalog.js','anatomy-model.js','anatomy-experiments.js','anatomy-context.js','anatomy-learning.js','anatomy-rv32.js','anatomy-regfile32.js','anatomy-immediate32.js','anatomy-decoder32.js','anatomy-cpu32.js','anatomy-board-cpu.js','anatomy-sequence.js','anatomy-float.js','anatomy-representation.js','anatomy-board-buttons.js','anatomy-alu4.js'])vm.runInContext(fs.readFileSync(path.join(base,f),'utf8'),ctx);
const {execFileSync}=require('child_process');const vectors=JSON.parse(execFileSync('python3',['-c',`import json
out=[]
for a in range(16):
 for b in range(16):
  sa=a if a<8 else a-16;sb=b if b<8 else b-16;k=b%4
  vals=[a+b,a-b,a&b,a|b,a^b,a*2**k,a//2**k,sa//2**k,int(sa<sb),int(a<b)]
  for op,n in zip(['ADD','SUB','AND','OR','XOR','SHL','SHR','SRA','SLT','SLTU'],vals):
   v=n%16;arith=op in ['ADD','SUB'];carry=int(a+b>=16) if op=='ADD' else int(a>=b) if op=='SUB' else None
   exact=sa+sb if op=='ADD' else sa-sb;overflow=int(not(-8<=exact<=7)) if arith else None
   out.append([a,b,op,v,int(v==0),v//8,carry,overflow])
print(json.dumps(out))`],{maxBuffer:2000000}).toString());let checks=0;for(const [a,b,op,...expected]of vectors){const r=vm.runInContext('anatomyALU4('+a+','+b+','+JSON.stringify(op)+')',ctx);const values=[r.value,r.zero,r.sign,r.carry,r.overflow];if(JSON.stringify(values)!==JSON.stringify(expected))throw Error('ALU '+a+'/'+b+'/'+op);checks+=5;}console.log(JSON.stringify({status:'passed',vectors:vectors.length,checks,oracle:'independent Python 4-bit arithmetic'}));
