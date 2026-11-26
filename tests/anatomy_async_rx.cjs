const fs=require('fs'),vm=require('vm'),path=require('path'),base=path.resolve(__dirname,'..'),c=vm.createContext({});
for(const f of ['architecture.js','anatomy-catalog.js','anatomy-model.js','anatomy-experiments.js','anatomy-view-tools.js'])vm.runInContext(fs.readFileSync(path.join(base,f),'utf8'),c);
console.log(JSON.stringify(vm.runInContext(`(()=>{
 let checks=0;const ok=(v,m)=>{if(!v)throw Error(m);checks++};
 for(const kind of ['good','bad'])for(let byte=0;byte<256;byte++)for(let offset=0;offset<8;offset++){
  const s=anatomyState();s.byte=byte;anatomyAsyncRXLoad(s,kind);s.uartAsync.stimulus='1'.repeat(offset)+s.uartAsync.stimulus;s.uartAsync.txStart+=offset;anatomyAdvance('asyncrx',s,'finish');const r=s.uartAsync,frame=r.received[0];
  ok(frame?.data===byte,'assembled byte '+kind+' '+byte+' '+offset);ok(frame.valid===+(kind==='good')&&frame.error===+(kind==='bad'),'stop flags');ok(frame.sample===87+offset,'stop center time');
  const data=r.trace.filter(row=>/^d[0-7]$/.test(row.sampled));ok(data.length===8,'eight data centers');for(let bit=0;bit<8;bit++){ok(data[bit].sample===23+offset+8*bit,'center schedule');ok(data[bit].observed===((byte>>>bit)&1),'independent bit value');ok(data[bit].observedSource===20+offset+8*bit,'source sample identity');ok(anatomyAsyncSourceField(r,data[bit].observedSource)==='d'+bit,'source transmitted field')}
  for(let i=0;i<r.trace.length;i++){const row=r.trace[i];if(row.first!==row.raw||row.second!==(i?r.trace[i-1].raw:1)||row.observed!==(i>1?r.trace[i-2].raw:1))throw Error('synchronizer sample age')};checks++;
  ok(s.ticks===r.samples,'physical sampling count');
 }
 for(let width=1;width<=4;width++){const s=anatomyState();s.uartAsync.stimulus='1'.repeat(8)+'0'.repeat(width)+'1'.repeat(100);anatomyAdvance('asyncrx',s,'finish');ok(s.uartAsync.received.length===0&&s.uartAsync.falseStarts===1,'short pulse rejection '+width)}
 const fast=anatomyState();fast.byte=65;anatomyAsyncRXLoad(fast,'fast');anatomyAdvance('asyncrx',fast,'finish');ok(fast.uartAsync.received[0].data===161&&fast.uartAsync.received[0].valid===1,'framing-valid can contain wrong data under mismatch');
 return {status:'passed',checks,frames:4096,scope:'closed-form bit-center times and encoded byte values, all bytes/stops/eight phase offsets; not analog metastability or timing margins'};
})()`,c)));
