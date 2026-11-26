async()=>{
let checks=0,traces=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},wait=ms=>new Promise(r=>setTimeout(r,ms)),d=()=>document.querySelector('.anatomy-dialog[open]'),input=()=>[...d().querySelectorAll('[data-toggle]')].map(n=>n.dataset.toggle+':'+n.getAttribute('aria-pressed')).join();
for(const id of ['fulladder','halfadder','xor','and','or','mux','nand','nor','not','cmos','dff','latch']){
 d()?.querySelector('[data-an-close]').click();openArchitecture(id);await wait(50);d().querySelector('[data-toggle="a"]').click();const parentInputs=input();
 const parts=ANATOMY[id].parts.filter(p=>anatomyGateInputPorts(ANATOMY[id],p.id).length||anatomyStorageOriginSupported(ANATOMY[id],p.id));
 for(const part of parts){
  const enter=()=>d().querySelector(`[data-part="${part.id}"]`).dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));enter();await wait(50);const names=[...d().querySelectorAll('[data-trace-parent-net]')].map(n=>n.dataset.traceParentNet);
  for(let i=0;i<names.length;i++){
   if(i){enter();await wait(50)}const name=names[i];ok(ANATOMY[id].nets.some(n=>n.name===name),'real source net');d().querySelector('[data-toggle="a"]').click();const button=[...d().querySelectorAll('[data-trace-parent-net]')].find(n=>n.dataset.traceParentNet===name);button.click();await wait(70);traces++;
   ok(d().dataset.view===id,'correct parent '+id+part.id+name);ok(input()===parentInputs,'parent values unchanged');ok(d().querySelector('.an-inspector h3').textContent===name,'inspector names net');ok(document.activeElement===d().querySelector('.an-scene'),'focus returns diagram');
   let net;for(let poll=0;poll<100;poll++){net=[...d().querySelectorAll('.an-scene [data-diagram-net]')].find(n=>n.dataset.diagramNet===name);if(net?.querySelector('path[stroke="#ce842b"]'))break;await wait(10)}ok(!!net?.querySelector('path[stroke="#ce842b"]'),'actual wire highlighted '+id+part.id+name);
  }
 }
}
return {status:'passed',parents:12,traces,checks};
}
