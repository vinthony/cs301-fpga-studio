const fs=require('fs'),vm=require('vm'),path=require('path'),base=path.resolve(__dirname,'..'),context=vm.createContext({});
for(const f of ['architecture.js','anatomy-catalog.js','anatomy-model.js','anatomy-experiments.js'])vm.runInContext(fs.readFileSync(path.join(base,f),'utf8'),context);
context.cases=JSON.parse(fs.readFileSync(path.join(base,'labs/fifo-buffer/out/cases.json'),'utf8'));
const result=vm.runInContext(`(()=>{
 const s=anatomyState();let checks=0;
 function packed(item){const allow=item.step&&!item.clear&&!item.reset,plan=anatomyFIFOPlan({...s,fifoPush:allow&&item.push,fifoPop:allow&&item.pop});let v=s.fifoMem.reduce((n,b,i)=>n|(BigInt(b)<<BigInt(8*i)),0n);const head=s.fifoCount?anatomyEvaluate('fifo',s).nets['队首']:0;for(const [value,bits]of [[s.fifoRead,2],[s.fifoWrite,2],[s.fifoCount,3],[head,8],[+(s.fifoCount>0),1],[+(s.fifoCount===0),1],[+(s.fifoCount===4),1],[+plan.push,1],[+plan.pop,1]])v=(v<<BigInt(bits))|BigInt(value);return v.toString(16).padStart(13,'0')}
 for(const [i,item]of cases.entries()){
  if(packed(item)!==item.before)throw Error('web pre '+i);checks++;
  s.fifoPush=item.push;s.fifoPop=item.pop;s.data=item.data;
  if(item.clear||item.reset)anatomyAdvance('fifo',s,'reset');else if(item.step)anatomyAdvance('fifo',s);
  if(packed(item)!==item.after)throw Error('web post '+i);checks++;
 }
 return {status:'passed',cases:cases.length,checks,scope:'same independent Python vectors as generated RTL; step=0 holds by not issuing a web edge, clear/reset mapped to reset'};
})()`,context);console.log(JSON.stringify(result));
