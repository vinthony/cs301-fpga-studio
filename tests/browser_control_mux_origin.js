async()=>{
let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},wait=ms=>new Promise(r=>setTimeout(r,ms)),d=()=>document.querySelector('.anatomy-dialog[open]'),click=s=>d().querySelector(s).click();d()?.querySelector('[data-an-close]').click();openArchitecture('registerControl');await wait(100);
for(let k=0;k<16;k++){
 click(`[data-control-case="${k}"]`);const reset=k>>3,enable=(k>>2)&1,a=(k>>1)&1,q=k&1,before=[...d().querySelectorAll('[data-toggle]')].map(n=>n.getAttribute('aria-pressed')).join();
 for(const part of ['EN','RESET']){
  d().querySelector(`[data-part="${part}"]`).dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await wait(50);const expected=part==='EN'?{a:q,b:a,cin:enable}:{a:enable?a:q,b:0,cin:reset};
  for(const [key,value]of Object.entries(expected)){const row=d().querySelector(`[data-control-origin="${key}"]`);ok(Number(row.dataset.originValue)===value,'parent source '+k+part+key);ok(Number(row.dataset.localValue)===value,'local mapped '+k+part+key);ok(ANATOMY.registerControl.nets.some(n=>n.name===row.querySelector('[data-trace-parent-net]').dataset.traceParentNet),'actual named source')}
  click('[data-mux-toggle="a"]');click('[data-reread-parent]');await wait(50);ok(Number(d().querySelector('[data-control-origin="a"]').dataset.localValue)===expected.a,'reread');const button=d().querySelector('[data-control-origin="a"] [data-trace-parent-net]'),net=button.dataset.traceParentNet;button.click();await wait(50);ok(d().dataset.view==='registerControl','back to actual parent');ok(d().querySelector('.an-inspector h3').textContent===net,'specific net selected');ok([...d().querySelectorAll('[data-toggle]')].map(n=>n.getAttribute('aria-pressed')).join()===before,'parent conditions preserved');
 }
}
return {status:'passed',conditions:16,cases:32,checks};
}
