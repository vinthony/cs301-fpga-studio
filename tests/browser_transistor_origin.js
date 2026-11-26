async()=>{
let checks=0,cases=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},wait=()=>new Promise(r=>setTimeout(r,25)),d=()=>document.querySelector('.anatomy-dialog[open]');
for(const id of ['nand','nor','not','cmos']){
 d()?.querySelector('[data-an-close]').click();openArchitecture(id);await wait();const two=['nand','nor'].includes(id),parts=two?['P0','P1','N0','N1']:['P','N'];
 for(let k=0;k<(two?4:2);k++){
  const a=two?k>>1:k,b=k&1;d().querySelector(`[data-truth-row="${k}"]`).click();
  for(const part of parts){
   const expected=part.endsWith('1')?b:a,pmos=part.startsWith('P');d().querySelector(`[data-part="${part}"]`).dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await wait();cases++;
   const row=()=>d().querySelector('[data-origin-input="a"]'),explain=()=>d().querySelector('[data-origin-conduction]').textContent;
   ok(Number(row().dataset.originValue)===expected,'source '+id+part+k);ok(Number(row().dataset.localValue)===expected,'inherited '+id+part+k);ok(row().querySelector('th').textContent.includes('栅极'),'gate label');
   ok(explain().includes('理想通路'+((pmos?!expected:expected)?'导通':'断开')),'initial conduction');
   d().querySelector('[data-toggle="a"]').click();ok(Number(row().dataset.localValue)===1-expected,'local change');ok(Number(row().dataset.originValue)===expected,'parent preserved');ok(explain().includes('理想通路'+((pmos?expected:!expected)?'导通':'断开')),'changed conduction');
   d().querySelector('[data-reread-parent]').click();await wait();ok(Number(row().dataset.localValue)===expected,'reread gate');d().querySelector('[data-return-parent]').click();await wait();ok(d().querySelector(`[data-truth-row="${k}"]`).getAttribute('aria-pressed')==='true','return unchanged');
  }
 }
}
return {status:'passed',parents:4,cases,checks};
}
