const fs=require('fs'),vm=require('vm'),path=require('path'),base=path.resolve(__dirname,'..'),c=vm.createContext({});
for(const f of ['architecture.js','anatomy-catalog.js','anatomy-model.js','anatomy-experiments.js'])vm.runInContext(fs.readFileSync(path.join(base,f),'utf8'),c);
c.cases=JSON.parse(fs.readFileSync(path.join(base,'labs/uart-bit-tx/out/cases.json'),'utf8'));
console.log(JSON.stringify(vm.runInContext(`(()=>{
 const s=anatomyState();s.uartByte=0;let checks=0;
 const actual=()=>((s.uartByte<<8)|((s.uartIndex<0?15:s.uartIndex)<<4)|(anatomyEvaluate('tx',s).result<<3)|((s.uartIndex>=0?1:0)<<2));
 for(const [i,item]of cases.entries()){
  if(actual()!==(parseInt(item.before,16)&0xfffc))throw Error('TX web pre '+i);checks++;
  s.byte=item.data;
  if(item.clear||item.reset){anatomyAdvance('tx',s,'reset');s.uartByte=0}
  else if(item.step&&(s.uartIndex>=0||item.send))anatomyAdvance('tx',s);
  if(actual()!==(parseInt(item.after,16)&0xfffc))throw Error('TX web post '+i);checks++;
 }
 return {status:'passed',cases:cases.length,checks,scope:'captured byte, phase, TX and busy only; hardware accepted/done not present in web UI; external send/step/clear adapted explicitly'};
})()`,c)));
