const fs=require('fs'),vm=require('vm'),path=require('path'),base=path.resolve(__dirname,'..'),ctx=vm.createContext({});for(const f of ['architecture.js','anatomy-catalog.js','anatomy-model.js','anatomy-experiments.js','anatomy-context.js','anatomy-learning.js','anatomy-rv32.js','anatomy-regfile32.js','anatomy-immediate32.js','anatomy-decoder32.js','anatomy-cpu32.js','anatomy-board-cpu.js','anatomy-sequence.js','anatomy-float.js'])vm.runInContext(fs.readFileSync(path.join(base,f),'utf8'),ctx);
const {execFileSync}=require('child_process');const vectors=JSON.parse(execFileSync('python3',['-c',`import struct,random,json,math
r=random.Random(301);words=[0,0x80000000,1,0x7fffff,0x800000,0x7f7fffff,0x7f800000,0xff800000,0x7fc00001,0x7f800001,0x3dcccccd]+[r.getrandbits(32) for _ in range(10000)]
out=[]
for w in words:
 v=struct.unpack('>f',struct.pack('>I',w))[0]
 if math.isnan(v):v='NaN'
 elif math.isinf(v):v='-Infinity' if v<0 else '+Infinity'
 elif v==0 and w>>31:v='-0'
 out.append([w,v])
print(json.dumps(out))`],{maxBuffer:4000000}).toString());let checks=0;for(const [word,value]of vectors){const decoded=vm.runInContext('anatomyDecodeFloat32('+word+')',ctx);if(decoded.value!==value)throw Error('float mismatch '+word);checks++}console.log(JSON.stringify({status:'passed',vectors:vectors.length,checks,oracle:'Python struct.unpack IEEE binary32'}));
