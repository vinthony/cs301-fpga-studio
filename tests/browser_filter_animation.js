async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++};
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('filter');await new Promise(r=>setTimeout(r,100));const d=document.querySelector('.anatomy-dialog[open]');
 for(const [value,valid]of [[17,1],[34,1],[51,1],[68,1],[255,0]]){
  const input=d.querySelector('[data-field="data"]');input.value=value;input.dispatchEvent(new Event('change',{bubbles:true}));const t=d.querySelector('[data-toggle="enable"]');if((t.getAttribute('aria-pressed')==='true')!==!!valid)t.click();d.querySelector('[data-tick]').click();
  const rows=[...d.querySelectorAll('[data-filter-motion]')];ok(rows.length===4,'four simultaneous paths');for(const row of rows){ok(row.dataset.source===row.dataset.target,'old source equals captured/held target');ok(!!row.querySelector('path.hold')===!valid,'valid selects capture or hold')}
 }
 const box=d.querySelector('.an-filter-edge-animation'),watch=d.querySelector('.an-watch').textContent,range=d.querySelector('[data-observation-range]').max;box.querySelector('button').click();await new Promise(r=>setTimeout(r,1400));ok(watch===d.querySelector('.an-watch').textContent,'replay no circuit mutation');ok(range===d.querySelector('[data-observation-range]').max,'replay no new observation');ok(box.querySelector('[role=status]').textContent.includes('回放结束')||matchMedia('(prefers-reduced-motion: reduce)').matches,'animation ends');ok(box.scrollWidth<=box.clientWidth,'no horizontal overflow');
 return {status:'passed',checks};
}
