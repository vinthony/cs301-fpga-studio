async()=>{
let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},wait=()=>new Promise(r=>setTimeout(r,200)),d=()=>document.querySelector('.anatomy-dialog[open]');d()?.querySelector('[data-an-close]').click();openArchitecture('fifo');await wait();
const cases=[{pop:false,push:true,read:null,order:[99],r:0,w:1},{pop:false,push:false,read:null,order:[10,20,30,40],r:0,w:0},{pop:true,push:true,read:10,order:[20,30,40,99],r:1,w:1},{pop:true,push:true,read:10,order:[20,99],r:0,w:2}];
for(let i=0;i<4;i++){
const p=AN_FIFO_SCENARIOS[i],s=Object.assign(anatomyState(),{fifoMem:[...p.mem],fifoRead:p.read,fifoWrite:p.write,fifoCount:p.count,fifoPush:p.push,fifoPop:p.pop,data:p.data});anatomyAdvance('fifo',s);const e=cases[i];ok(s.fifoLast.pop===e.pop&&s.fifoLast.push===e.push,'accepted '+i);ok(s.fifoLast.value===e.read,'old head '+i);ok(s.fifoRead===e.r&&s.fifoWrite===e.w,'pointers '+i);ok(String(Array.from({length:s.fifoCount},(_,j)=>s.fifoMem[(s.fifoRead+j)%4]))===String(e.order),'order '+i);ok(String(s.fifoLast.before.mem)===String(p.mem),'before snapshot '+i);
d().querySelector('[data-fifo-example="'+i+'"]').click();ok(!d().querySelector('[data-fifo-edge-comparison]'),'prepare no edge '+i);d().querySelector('[data-experiment-action="tick"]').click();ok(d().querySelector('[data-fifo-edge-comparison]').textContent.includes('边沿后保存状态'),'render edge '+i);
const before=d().querySelector('[data-fifo-edge-comparison]').textContent,input=d().querySelector('[data-field="data"]');input.value='77';input.dispatchEvent(new Event('change',{bubbles:true}));ok(d().querySelector('[data-fifo-edge-comparison]').textContent===before,'input preserves old event '+i);
}
return {status:'passed',checks};
}
