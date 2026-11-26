async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},wait=ms=>new Promise(r=>setTimeout(r,ms)),d=()=>document.querySelector('.anatomy-dialog[open]');
 for(let candidate=0;candidate<2;candidate++)for(let raw=0;raw<2;raw++){
  d()?.querySelector('[data-an-close]').click();openArchitecture('debounce');await wait(40);const set=v=>{const b=d().querySelector('[data-toggle="a"]');if(Number(b.getAttribute('aria-pressed')==='true')!==v)b.click()};set(candidate);d().querySelector('[data-tick]').click();set(raw);
  d().querySelector('[data-part="CMP"]').dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await wait(40);
  for(const [key,value]of [['av',raw],['bv',candidate]]){const row=d().querySelector('[data-debounce-compare="'+key+'"]');ok(Number(row.dataset.originValue)===value,'source');ok(Number(row.dataset.localValue)===value,'copy');}
  const input=d().querySelector('[data-field="av"]');input.value=15;input.dispatchEvent(new Event('change',{bubbles:true}));d().querySelector('[data-reread-parent]').click();await wait(40);ok(Number(d().querySelector('[data-field="av"]').value)===raw,'reread');
  d().querySelector('[data-trace-parent-net="候选"]').click();await wait(40);ok(d().dataset.view==='debounce','trace actual parent');ok(Number(d().querySelector('[data-debounce-count]').textContent)===1,'parent count unchanged');
 }
 return {status:'passed',cases:4,checks};
}
