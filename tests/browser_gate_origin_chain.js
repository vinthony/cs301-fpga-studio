async()=>{
let checks=0,cases=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},wait=()=>new Promise(r=>setTimeout(r,25)),d=()=>document.querySelector('.anatomy-dialog[open]');
const expected=(id,a,b,c)=>id==='halfadder'?{X:[a,b],G:[a,b]}:id==='and'?{G:[a,b],I:[1-(a&b)]}:id==='or'?{G:[a,b],I:[1-(a|b)]}:id==='xor'?{IA:[a],IB:[b],G0:[1-a,b],G1:[a,1-b],O:[(1-a)&b,a&(1-b)]}:{I:[c],G0:[a,1-c],G1:[b,c],O:[a&(1-c),b&c]};
for(const id of ['halfadder','and','or','xor','mux']){
 d()?.querySelector('[data-an-close]').click();openArchitecture(id);await wait();
 for(let k=0;k<(id==='mux'?8:4);k++){
  const a=id==='mux'?k>>2:k>>1,b=id==='mux'?(k>>1)&1:k&1,c=k&1;
  d().querySelector(`[data-truth-row="${k}"]`).click();
  for(const [part,values]of Object.entries(expected(id,a,b,c))){
   d().querySelector(`[data-part="${part}"]`).dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await wait();cases++;
   const rows=()=>[...d().querySelectorAll('[data-origin-input]')];ok(rows().length===values.length,'port count '+id+part);
   rows().forEach((n,i)=>{ok(Number(n.dataset.originValue)===values[i],'upstream '+id+part+i);ok(Number(n.dataset.localValue)===values[i],'inherited '+id+part+i)});
   d().querySelector('[data-toggle="a"]').click();ok(Number(rows()[0].dataset.localValue)!==values[0],'independent '+id+part);
   d().querySelector('[data-reread-parent]').click();await wait();ok(Number(rows()[0].dataset.localValue)===values[0],'reread '+id+part);
   d().querySelector('[data-return-parent]').click();await wait();ok(d().querySelector(`[data-truth-row="${k}"]`).getAttribute('aria-pressed')==='true','parent stable '+id+part);
  }
 }
}
return {status:'passed',parents:5,cases,checks};
}
