const fs=require('fs'),vm=require('vm'),base=__dirname+'/../',ctx=vm.createContext({});for(const file of ['architecture.js','anatomy-catalog.js','anatomy-model.js','anatomy-experiments.js','anatomy-context.js','anatomy-learning.js','anatomy-rv32.js','anatomy-regfile32.js','anatomy-immediate32.js','anatomy-decoder32.js','anatomy-cpu32.js','anatomy-board-cpu.js','anatomy-sequence.js','anatomy-float.js','anatomy-representation.js','anatomy-alu4.js','anatomy-pipeline32.js','anatomy-pipeline32-view.js'])vm.runInContext(fs.readFileSync(base+file,'utf8'),ctx);
const result=vm.runInContext(`(()=>{
let checks=0;const eq=(a,b,n)=>{if(JSON.stringify(a)!==JSON.stringify(b))throw Error(n);checks++};
for(const id of ['adccore','xadc'])for(let seq=0;seq<1024;seq++){
 const s=anatomyState();let q=0,valid=0,window=[0,0,0,0],received=0;
 for(let step=0;step<5;step++){
  const choice=(seq>>>(2*step))&3;s.pct=(choice&1)?100:0;s.adcValid=choice>>>1;
  const oldMean=Math.floor(window.reduce((a,b)=>a+b,0)/4);eq(anatomyEvaluate(id,s).result,oldMean,'input does not bypass storage');
  if(valid){window=[q,...window.slice(0,3)];received++}if(s.adcValid)q=s.pct===100?15:0;valid=s.adcValid;
  anatomyAdvance(id,s);const e=anatomyEvaluate(id,s);eq(s.adcSample,q,'capture only valid candidate');eq(s.adcSampleValid,valid,'valid pipeline');eq(s.adcSamples,window,'old register enters window');eq(s.adcFilterCount,received,'valid samples counted');eq(e.result,Math.floor(window.reduce((a,b)=>a+b,0)/4),'independent average');eq(e.nets['样本'],q,'named saved sample');eq(e.nets['样本有效'],valid,'named valid');eq(s.ticks,step+1,'one actual edge');
 }
}
return {status:'passed',sequences:2048,samples:10240,checks};
})()`,ctx);console.log(JSON.stringify(result));
