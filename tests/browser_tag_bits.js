async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},d=()=>document.querySelector('.anatomy-dialog[open]');d()?.querySelector('[data-an-close]').click();
 for(const id of ['tageq5','cachecheck']){
  openArchitecture(id);await new Promise(r=>setTimeout(r,100));
  const field=(key,value)=>{const f=d().querySelector('[data-field="'+key+'"]');f.value=value;f.dispatchEvent(new Event('change',{bubbles:true}))};
  for(const value of [0,1,15,16,30,31])for(const key of ['av','bv'])for(let bit=0;bit<5;bit++){
   field('av',value);field('bv',value);d().querySelector('[data-tag-input-bit="'+key+':'+bit+'"]').click();
   ok(+d().querySelector('[data-field="'+key+'"]').value===(value^(1<<bit)),'bit flips correct full-width value');
   ok([...d().querySelectorAll('[data-tag-equal-bit]')].every(n=>(n.getAttribute('data-equal')==='true')===(+n.dataset.tagEqualBit!==bit)),'only changed bit differs');
   ok(+d().querySelector('[data-coach-delta] b').textContent===0&&d().querySelector('[data-tag-bit-summary]').textContent.includes('EQ=0'),'numeric result and bit explanation sync');
   ok(document.activeElement===d().querySelector('[data-tag-input-bit="'+key+':'+bit+'"]'),'bit focus preserved');
  }
  if(id==='cachecheck')d().querySelector('[data-toggle="enable"]').click();d().querySelector('[data-tag-copy-request]').click();ok([...d().querySelectorAll('[data-tag-equal-bit]')].every(n=>n.getAttribute('data-equal')==='true'),'copy request makes all bits equal');
  ok(+d().querySelector('[data-coach-delta] b').textContent===(id==='cachecheck'?0:1),'copy does not set valid');
  const range=d().querySelector('[data-observation-range]');range.value=0;range.dispatchEvent(new Event('input',{bubbles:true}));const before=d().querySelector('[data-field="av"]').value;d().querySelector('[data-tag-input-bit="av:4"]').click();d().querySelector('[data-tag-copy-request]').click();ok(d().querySelector('[data-field="av"]').value===before,'history locks tag inputs');d().querySelector('[data-observation-live]').click();d().querySelector('[data-an-close]').click();
 }
 return {status:'passed',checks,transitions:120};
}
