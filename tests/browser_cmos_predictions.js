()=>{
let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++};const expected={nand:[1,0],nor:[0,1],not:[0],cmos:[1],nmos:[1],pmos:[0]};
for(const [id,outputs]of Object.entries(expected)){
 const c=AN_PREDICTIONS[id],s=Object.assign(anatomyState(),c.initial);c.steps.forEach((step,i)=>{Object.assign(s,step.set);const e=anatomyEvaluate(id,s);ok(e.result===outputs[i],'independent sequence '+id+i);ok(step.expect.result===outputs[i],'declared sequence '+id+i);ok(anatomyPredictionStepMatches(e,step.expect),'actual switch conditions '+id+i)});
}
const c=AN_PREDICTIONS.nand;let s=anatomyState(),host=document.createElement('section');mountAnatomyPrediction({host,id:'nand',state:()=>s,blocked:()=>false,commit:()=>{}});host.querySelector('[data-predict="1"]').click();host.querySelector('[data-predict-start]').click();const original=anatomyEvaluate;
try{
 anatomyEvaluate=(id,state)=>{const e=original(id,state);if(id==='nand'&&state.a===1&&state.b===0)e.switches.P1=0;return e};host.querySelector('[data-predict-next]').click();ok(host.dataset.predictionVerified==='false','wrong intermediate switch rejected despite correct output');ok(host.querySelector('[data-predict-next]').disabled,'failed step cannot continue');ok(host.querySelector('[data-predict-status]').textContent.includes('第 1 步'),'failure identifies step');
}finally{anatomyEvaluate=original}
host.querySelector('[data-predict-start]').click();host.querySelector('[data-predict-next]').click();ok(!host.querySelector('[data-predict-next]').disabled,'retry restores progression');ok(host.querySelector('[data-predict-status]').textContent.includes('本步实际输出：1'),'intermediate actual output shown');host.querySelector('[data-predict-next]').click();ok(host.dataset.predictionVerified==='true','retry real model passes');
return {status:'passed',cases:6,checks};
}
