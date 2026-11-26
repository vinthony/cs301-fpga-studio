async()=>{
let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},wait=ms=>new Promise(r=>setTimeout(r,ms)),d=()=>document.querySelector('.anatomy-dialog[open]'),click=s=>d().querySelector(s).click();
for(let k=0;k<8;k++){
 const s=Object.assign(anatomyState(),{a:k>>2,s1:(k>>1)&1,s2:k&1});for(const part of ['F1','F2']){const first=part==='F1',child={a:first?s.a:s.s1,q:first?s.s1:s.s2},doc=new DOMParser().parseFromString(anatomySynchronizerOrigin(ANATOMY.synchronizer,part,s,child),'text/html');ok(doc.querySelector('[data-sync-stage][aria-current]').dataset.syncStage===part,'exact stage');for(const key of ['a','q']){const row=doc.querySelector(`[data-sync-origin="${key}"]`);ok(Number(row.dataset.originValue)===child[key],'independent source '+k+part+key)}}
}
d()?.querySelector('[data-an-close]').click();openArchitecture('synchronizer');await wait(100);const frame=()=>[...d().querySelectorAll('.an-sync-lens [data-sync-stage] b')].map(n=>Number(n.textContent));
const states=[[1,0,0],[1,1,0],[0,1,0],[0,0,1],[0,0,0]];
for(let stage=0;stage<states.length;stage++){
 if(stage===1||stage===3||stage===4)click('[data-tick]');if(stage===2)click('[data-toggle="a"]');const [raw,s1,s2]=states[stage];ok(frame().join()===states[stage].join(),'actual pipeline values '+stage);
 for(const part of ['F1','F2']){
  click(`[data-sync-focus="${part}"]`);ok(d().querySelector('.an-selection-summary b').textContent.startsWith(part+' ·'),'locate actual flipflop');click('[data-summary-enter]');await wait(60);const a=part==='F1'?raw:s1,q=part==='F1'?s1:s2;ok(Number(d().querySelector('[data-sync-origin="a"]').dataset.localValue)===a,'copied sampling source');ok(Number(d().querySelector('[data-sync-origin="q"]').dataset.localValue)===q,'copied saved state');click('[data-tick]');ok(d().querySelector('[data-dff-saved]').textContent===String(a),'local edge captures copied source');click('[data-reread-parent]');await wait(60);ok(d().querySelector('[data-dff-saved]').textContent===String(q),'reread returns saved source');click('[data-return-parent]');await wait(60);ok(frame().join()===states[stage].join(),'local edge never advances parent');
 }
}
return {status:'passed',inputStates:8,realStages:5,checks};
}
