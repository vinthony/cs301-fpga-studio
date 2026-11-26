const fs=require('fs'),vm=require('vm'),path=require('path'),base=path.resolve(__dirname,'..'),c=vm.createContext({});
for(const f of ['architecture.js','anatomy-catalog.js','anatomy-model.js','anatomy-experiments.js'])vm.runInContext(fs.readFileSync(path.join(base,f),'utf8'),c);
c.groups=JSON.parse(fs.readFileSync(path.join(base,'labs/uart-clocked-tx/out/web-cases.json'),'utf8'));
console.log(JSON.stringify(vm.runInContext(`(()=>{
 let checks=0;const mask=0x7fffff8;
 for(const group of groups){
  const s=anatomyState();s.baud=115200;s.byte=group.byte;anatomyAdvance('baud',s,'prepare');
  const packed=()=>{const tx=s.baudTX.tx,phase=tx.uartIndex<0?15:tx.uartIndex,level=tx.uartIndex<0?1:anatomyUARTFrame(tx)[tx.uartIndex];return ((s.ticks%868)<<17)|(tx.uartByte<<9)|(phase<<5)|(level<<4)|((tx.uartIndex>=0?1:0)<<3)};
  for(const [i,row]of group.vectors.entries()){
   const control=parseInt(row.slice(0,4),16),before=parseInt(row.slice(4,11),16)&mask,after=parseInt(row.slice(11),16)&mask;
   if(packed()!==before)throw Error('clocked web pre '+group.byte+' '+i);checks++;
   s.byte=control>>>4;if(control&4)anatomyAdvance('baud',s,'tick');
   if(packed()!==after)throw Error('clocked web post '+group.byte+' '+i);checks++;
  }
 }
 return {status:'passed',groups:groups.length,checks,scope:'7 stable request frames: counter/captured/phase/TX/busy only; disabled primary clocks map to no web advance, not elapsed-time alignment; hardware accepted/done/tick excluded'};
})()`,c)));
