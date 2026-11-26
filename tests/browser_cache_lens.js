async()=>{
 let checks=0;const ok=(v,m)=>{if(!v)throw Error(m);checks++},wait=()=>new Promise(r=>setTimeout(r,160));
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('cache');await wait();
 const text=()=>document.querySelector('.an-cache-lens').textContent,addr=a=>document.querySelector('[data-cache-address="'+a+'"]').click();
 ok(text().includes('冷缺失'),'cold miss');document.querySelector('[data-tick]').click();ok(text().includes('命中：'),'refill hit');
 addr(1);ok(text().includes('命中：'),'offset same block');ok(document.querySelector('.an-cache-fields').textContent.includes('OFFSET 1'),'offset bit');
 addr(8);ok(text().includes('冲突缺失'),'same index other tag');ok(text().includes('旧tag=0，请求tag=1'),'old new tags');
 document.querySelector('[data-tick]').click();addr(0);ok(text().includes('冲突缺失'),'replacement evicts old tag');
 addr(2);ok(text().includes('冷缺失'),'other line still invalid');ok(document.querySelector('[data-cache-line][aria-current]').dataset.cacheLine==='1','line selection');
 const data=document.querySelector('[data-field="data"]');data.value='99';data.dispatchEvent(new Event('change',{bubbles:true}));document.querySelector('[data-tick]').click();ok(document.querySelector('[data-cache-line="1"]').textContent.includes('样本=99'),'refill sample editable');
 document.querySelector('[data-cache-address-bit="7"]').click();ok(text().includes('TAG 16'),'bit changes tag');ok(document.querySelector('[data-cache-line][aria-current]').dataset.cacheLine==='1','tag bit keeps index');
 for(let a=0;a<256;a++){
  const s=anatomyState();s.addr=a;const html=anatomyCacheLens(ANATOMY.cache,s),d=new DOMParser().parseFromString(html,'text/html');
  ok(d.querySelector('.an-cache-fields').textContent==='TAG '+(a>>>3)+'INDEX '+((a>>>1)&3)+'OFFSET '+(a&1),'address split '+a);
 }
 document.querySelector('.an-cache-lens').scrollIntoView({block:'center'});
 return {status:'passed',checks};
}
