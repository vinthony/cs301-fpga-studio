const fs=require('fs'),vm=require('vm'),base=__dirname+'/../',ctx=vm.createContext({});for(const file of ['architecture.js','anatomy-catalog.js','anatomy-model.js','anatomy-experiments.js','anatomy-context.js','anatomy-learning.js','anatomy-rv32.js','anatomy-regfile32.js','anatomy-immediate32.js','anatomy-decoder32.js','anatomy-cpu32.js','anatomy-board-cpu.js','anatomy-sequence.js','anatomy-float.js','anatomy-representation.js','anatomy-alu4.js','anatomy-pipeline32.js','anatomy-pipeline32-view.js'])vm.runInContext(fs.readFileSync(base+file,'utf8'),ctx);
const result=vm.runInContext(`(()=>{
let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},snap=(id,s)=>({state:anLearningClone(s),evaluation:anLearningClone(anatomyEvaluate(id,s))});
for(let bits=0;bits<256;bits++){
 let s=anatomyState();Object.assign(s,{a:0,candidate:0,consecutive:0,stable:0,ticks:0});let last=0,count=0,accepted=0;
 for(let i=0;i<8;i++){
  const bit=(bits>>i)&1,before=snap('debounce',s);s.a=bit;
  const inputWhy=anatomyExplainObservation(ANATOMY.debounce,before,snap('debounce',s));ok(inputWhy.title.includes('次数还不变'),'input-only caption');ok(s.consecutive===count,'input-only count stays');
  const p=snap('debounce',s),oldAccepted=accepted,restart=bit!==last;count=restart?1:count+1;last=bit;if(count>=3)accepted=bit;
  anatomyAdvance('debounce',s);const why=anatomyExplainObservation(ANATOMY.debounce,p,snap('debounce',s));
  ok(s.stable===accepted&&s.consecutive===count,'independent run length');ok(why.body.includes('连续次数='+count),'actual count in explanation');ok(why.body.includes('当前稳定输出='+accepted),'actual output in explanation');
  ok(accepted!==oldAccepted?why.title.includes('提交新稳定值'):count>=3?why.title.includes('原来相同'):restart?why.title.includes('从1开始'):why.title.includes('尚未达到'),'correct cause');
 }
}
for(let a=0;a<2;a++)for(let s1=0;s1<2;s1++)for(let s2=0;s2<2;s2++){
 const s=anatomyState();Object.assign(s,{a,s1,s2,ticks:0});const p=snap('synchronizer',s);anatomyAdvance('synchronizer',s);const x=anatomyExplainObservation(ANATOMY.synchronizer,p,snap('synchronizer',s));ok(s.s1===a&&s.s2===s1,'old stage sampled');ok(x.body.includes('边沿前SYNC1='+s1),'actual old stage explained');ok(x.title.includes(s2===s1?'数值保持':'前一拍'),'unchanged not mistaken for no edge');
}
return {status:'passed',sequences:256,samples:2048,checks};
})()`,ctx);console.log(JSON.stringify(result));
