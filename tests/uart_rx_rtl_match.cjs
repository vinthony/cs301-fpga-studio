const fs=require('fs'),vm=require('vm'),path=require('path'),base=path.resolve(__dirname,'..'),c=vm.createContext({});
for(const f of ['architecture.js','anatomy-catalog.js','anatomy-model.js','anatomy-experiments.js'])vm.runInContext(fs.readFileSync(path.join(base,f),'utf8'),c);
c.cases=JSON.parse(fs.readFileSync(path.join(base,'labs/uart-bit-rx/out/cases.json'),'utf8'));
console.log(JSON.stringify(vm.runInContext(`(()=>{
 const s=anatomyState();let checks=0;const packed=()=>((s.rxData<<7)|((s.rxPhase<0?15:s.rxPhase)<<3)|((s.rxPhase>=0?1:0)<<2)|(s.rxValid<<1)|s.rxError);
 for(const [i,item]of cases.entries()){
  if(packed()!==parseInt(item.before,16))throw Error('RX web pre '+i);checks++;
  s.a=item.rx;if(item.clear||item.reset)anatomyAdvance('rx',s,'reset');else if(item.step)anatomyAdvance('rx',s);
  if(packed()!==parseInt(item.after,16))throw Error('RX web post '+i);checks++;
 }
 return {status:'passed',cases:cases.length,checks,scope:'data, phase, busy, valid and framing error; step=0 no sample, clear/reset web reset'};
})()`,c)));
