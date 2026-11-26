async()=>{
let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},wait=ms=>new Promise(r=>setTimeout(r,ms)),d=()=>document.querySelector('.anatomy-dialog[open]'),click=s=>d().querySelector(s).click();
for(const b of Object.values(ANATOMY)){
 const e=anatomyEvaluate(b.id,anatomyState());for(const n of b.nets){const doc=new DOMParser().parseFromString(anatomySelectionSummary(b,e,{net:n.name}),'text/html');ok(doc.querySelector('b').textContent===n.name+' = '+(e.nets[n.name]??'本层未计算'),'net summary '+b.id+n.name);ok(doc.querySelectorAll('[data-summary-part]').length===2,'endpoints '+b.id+n.name)}
 for(const p of b.parts){const doc=new DOMParser().parseFromString(anatomySelectionSummary(b,e,{part:p.id}),'text/html');ok(doc.querySelector('b').textContent===p.id+' · '+p.label,'part summary '+b.id+p.id)}
}
ok(anatomyPartCurrentValue({parts:[{id:'G',type:'and'}],nets:[]},{result:1,nets:{}},'G')==='本层未单独计算','unknown part not replaced with module output');
d()?.querySelector('[data-an-close]').click();openArchitecture('fulladder');await wait(160);
for(let k=0;k<8;k++){
 click(`[data-truth-row="${k}"]`);const a=k>>2,b=(k>>1)&1,c=k&1,expected={A:a,B:b,C:c,X1:a^b,X2:(a+b+c)%2,G1:a&b,G2:(a^b)&c,O:+(a+b+c>=2),Y:(a+b+c)%2,CO:+(a+b+c>=2)};
 for(const [part,value]of Object.entries(expected)){click(`[data-part="${part}"]`);ok(d().querySelector('.an-selection-summary span').textContent==='当前值：'+value,'actual component value '+k+part)}
}
click('[data-net="P"]');ok(!d().querySelector('.an-selection-summary').hidden,'net summary visible');click('[data-summary-part="X1"]');ok(d().querySelector('.an-selection-summary b').textContent.startsWith('X1 ·'),'source locate');click('[data-summary-enter]');await wait(120);ok(d().dataset.view==='xor','enter actual component');click('[data-part="G0"]');click('[data-summary-detail]');ok(document.activeElement===d().querySelector('.an-inspector'),'detail focus');click('[data-summary-clear]');ok(d().querySelector('.an-selection-summary').hidden,'clear summary');
click('[data-an-close]');openArchitecture('dff');await wait(120);click('[data-part="Q"]');click('[data-tick]');ok(d().querySelector('.an-selection-summary span').textContent==='当前值：1','live update');click('[data-observation-prev]');ok(d().querySelector('.an-selection-summary small').textContent==='历史快照','historical label');ok(d().querySelector('.an-selection-summary span').textContent==='当前值：0','historical actual value');click('[data-observation-live]');ok(d().querySelector('.an-selection-summary span').textContent==='当前值：1','live preserved');
return {status:'passed',views:Object.keys(ANATOMY).length,checks};
}
