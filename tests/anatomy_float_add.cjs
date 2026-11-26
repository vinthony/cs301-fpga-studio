const fs=require('fs'),vm=require('vm'),path=require('path'),base=path.resolve(__dirname,'..'),ctx=vm.createContext({});for(const f of ['architecture.js','anatomy-catalog.js','anatomy-model.js','anatomy-experiments.js','anatomy-context.js','anatomy-learning.js','anatomy-rv32.js','anatomy-regfile32.js','anatomy-immediate32.js','anatomy-decoder32.js','anatomy-cpu32.js','anatomy-board-cpu.js','anatomy-sequence.js','anatomy-float.js'])vm.runInContext(fs.readFileSync(path.join(base,f),'utf8'),ctx);
const {execFileSync}=require('child_process');const vectors=JSON.parse(execFileSync('python3',['-c',`import struct,random,math,json
r=random.Random(301);edge=[0,0x80000000,1,0x80000001,0x7fffff,0x800000,0x3f800000,0x3f800001,0x33800000,0x7f7fffff,0xff7fffff,0x7f800000,0xff800000,0x7fc00001]
pairs=[(a,b) for a in edge for b in edge]+[(r.getrandbits(32),r.getrandbits(32)) for _ in range(20000)];out=[]
for a,b in pairs:
 x=struct.unpack('>f',struct.pack('>I',a))[0];y=struct.unpack('>f',struct.pack('>I',b))[0];v=x+y
 if math.isnan(v):w=0x7fc00000
 else:
  try:w=struct.unpack('>I',struct.pack('>f',v))[0]
  except OverflowError:w=0xff800000 if v<0 else 0x7f800000
 out.append([a,b,w])
print(json.dumps(out))`],{maxBuffer:6000000}).toString());let checks=0;for(const [a,b,w]of vectors){const t=vm.runInContext('anatomyFloatAddTrace('+a+','+b+')',ctx);if(t.word!==w)throw Error('addition mismatch '+a.toString(16)+' '+b.toString(16)+' '+t.word.toString(16)+' != '+w.toString(16));checks++}for(const [a,w,up]of [[0x3f800000,0x3f800000,false],[0x3f800001,0x3f800002,true]]){const t=vm.runInContext('anatomyFloatAddTrace('+a+',0x33800000)',ctx);if(!t.tie||t.word!==w||t.roundedUp!==up)throw Error('ties-to-even trace');checks++}console.log(JSON.stringify({status:'passed',vectors:vectors.length,checks,oracle:'Python struct binary32 rounded addition'}));
