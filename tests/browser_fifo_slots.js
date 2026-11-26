async()=>{
let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},wait=()=>new Promise(r=>setTimeout(r,180)),d=()=>document.querySelector('.anatomy-dialog[open]');d()?.querySelector('[data-an-close]').click();openArchitecture('fifo');await wait();
d().querySelector('[data-fifo-example="3"]').click();
for(let i=0;i<4;i++){
 const parentOrder=d().querySelector('[data-fifo-order]').textContent;
 const button=d().querySelector('[data-fifo-queue="MEM"][data-fifo-slot="'+i+'"]');ok(button?.tagName==='BUTTON','native accessible slot');button.click();await wait();
 ok(d().querySelector('[data-field="addr"]').value===String(i),'exact storage address');
 ok(d().querySelector('[data-context-current]').dataset.contextCurrent==='sram','storage child');
 ok(d().textContent.includes(i===0||i===3?'当前属于有效队列':'当前无效：旧值不代表'),'validity explanation');
 ok(d().querySelector('[data-toggle="we"]').getAttribute('aria-pressed')==='false','no accidental write');
 d().querySelector('[data-return-parent]').click();await wait();ok(d().querySelector('[data-fifo-order]').textContent===parentOrder,'parent unchanged');
}
const rx=d().querySelectorAll('[data-fifo-queue="RXQ"]');ok(rx.length===4,'receive four physical slots');
d().querySelector('[data-observation-prev]').click();ok([...d().querySelectorAll('[data-fifo-slot]')].every(n=>n.disabled),'history slots read only');d().querySelector('[data-observation-live]').click();
return {status:'passed',checks};
}
