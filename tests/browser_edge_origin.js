async()=>{
let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},wait=ms=>new Promise(r=>setTimeout(r,ms)),d=()=>document.querySelector('.anatomy-dialog[open]'),click=s=>d().querySelector(s).click(),set=bit=>{const b=d().querySelector('[data-toggle="a"]');if((b.getAttribute('aria-pressed')==='true'?1:0)!==bit)b.click()};
for(let k=0;k<8;k++){
 d()?.querySelector('[data-an-close]').click();openArchitecture('edge');await wait(50);const raw=k>>2,current=(k>>1)&1,previous=k&1;set(previous);click('[data-tick]');set(current);click('[data-tick]');set(raw);
 const expected={S:{a:raw,q:current},D:{a:current,q:previous},I:{a:previous},G:{a:current,b:1-previous}};
 for(const [part,values]of Object.entries(expected)){
  d().querySelector(`[data-part="${part}"]`).dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await wait(50);
  for(const [key,value]of Object.entries(values)){const row=d().querySelector(`[data-edge-origin="${key}"],[data-origin-input="${key}"]`);ok(Number(row.dataset.originValue)===value,'correct captured source '+k+part+key);ok(Number(row.dataset.localValue)===value,'correct copied value '+k+part+key)}
  click('[data-toggle="a"]');click('[data-reread-parent]');await wait(50);const row=d().querySelector('[data-edge-origin="a"],[data-origin-input="a"]');ok(Number(row.dataset.localValue)===values.a,'reread restores');const button=row.querySelector('[data-trace-parent-net]'),net=button.dataset.traceParentNet;button.click();await wait(50);ok(d().dataset.view==='edge','trace returns actual parent');ok(d().querySelector('.an-selection-summary b').textContent.startsWith(net+' = '),'selected actual source');ok(Number(d().querySelector('[data-edge-event]').textContent)===(current&(1-previous)),'parent event preserved');
 }
}
return {status:'passed',states:8,cases:32,checks};
}
