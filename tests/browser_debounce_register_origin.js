async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},wait=ms=>new Promise(r=>setTimeout(r,ms)),d=()=>document.querySelector('.anatomy-dialog[open]'),click=s=>d().querySelector(s).click(),set=bit=>{const b=d().querySelector('[data-toggle="a"]');if(Number(b.getAttribute('aria-pressed')==='true')!==bit)b.click()};
 for(let bits=0;bits<16;bits++){
  d()?.querySelector('[data-an-close]').click();openArchitecture('debounce');await wait(30);let candidate=0,count=0,stable=0;
  for(let i=0;i<4;i++){const bit=(bits>>i)&1;count=bit===candidate?count+1:1;candidate=bit;if(count>=3)stable=bit;set(bit);click('[data-tick]')}
  for(const raw of [0,1]){set(raw);const ready=Number((raw===candidate?count+1:1)>=3);
  for(const part of ['ST','OLD']){
   d().querySelector('[data-part="'+part+'"]').dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await wait(30);
   const expected={D:raw,Q:part==='ST'?stable:candidate,CE:part==='ST'?ready:1,RESET:0};
   for(const [key,value]of Object.entries(expected)){const row=d().querySelector('[data-debounce-register="'+key+'"]');ok(Number(row.dataset.originValue)===value,'source '+bits+part+key);ok(Number(row.dataset.localValue)===value,'copied '+bits+part+key)}
   click('[data-tick]');const q=d().querySelector('[data-debounce-register="Q"]');ok(Number(q.dataset.localValue)===(expected.CE?raw:expected.Q),'local edge obeys CE');click('[data-reread-parent]');await wait(30);ok(Number(d().querySelector('[data-debounce-register="Q"]').dataset.localValue)===expected.Q,'reread restores saved Q');
   click('[data-trace-parent-net="'+(part==='ST'?'提交值':'更新候选')+'"]');await wait(30);ok(d().dataset.view==='debounce','trace actual parent');ok(Number(d().querySelector('[data-debounce-stable]').textContent)===stable,'parent stable unchanged');ok(Number(d().querySelector('[data-debounce-count]').textContent)===count,'parent count unchanged');
  }
  }
 }
 return {status:'passed',sequences:16,expansions:64,checks};
}
