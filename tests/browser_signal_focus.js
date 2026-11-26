async()=>{
let checks=0,nets=0,views=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},wait=ms=>new Promise(r=>setTimeout(r,ms)),d=()=>document.querySelector('.anatomy-dialog[open]');
for(const id of Object.keys(ANATOMY).filter(id=>id!=='board')){
 d()?.querySelector('[data-an-close]').click();openArchitecture(id);for(let poll=0;poll<100&&d().querySelector('.an-scene').dataset.render!=='ready';poll++)await wait(10);views++;
 const nodes=[...d().querySelectorAll('.an-scene [data-diagram-net]')];
 for(const node of nodes){
  nets++;node.dispatchEvent(new KeyboardEvent('keydown',{key:'Enter',bubbles:true}));ok(node.getAttribute('aria-pressed')==='true','selected aria '+id+node.dataset.diagramNet);ok(nodes.filter(n=>n.getAttribute('aria-pressed')==='true').length===1,'unique selection '+id);
  for(const other of nodes.filter(n=>n!==node))ok(!other.querySelector('path[stroke="#ce842b"]'),'other step wires suppressed '+id+other.dataset.diagramNet);
  ok(!!node.querySelector('path[stroke="#ce842b"],text[fill="#ce842b"]'),'selected wire or offsheet label highlighted '+id+node.dataset.diagramNet);
 }
 if(nodes.length){d().querySelector('[data-clear-selection]').click();ok(!nodes.some(n=>n.getAttribute('aria-pressed')==='true'),'clear selection '+id);nodes[0].dispatchEvent(new MouseEvent('click',{bubbles:true}));d().querySelector('[data-step="0"]').click();ok(!nodes.some(n=>n.getAttribute('aria-pressed')==='true'),'step resumes guide '+id)}
}
return {status:'passed',views,nets,checks};
}
