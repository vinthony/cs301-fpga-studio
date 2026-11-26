async()=>{
 let checks=0;const ok=(v,m)=>{if(!v)throw Error(m);checks++};
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('memorySystem');await new Promise(r=>setTimeout(r,180));
 const select=a=>document.querySelector('[data-hierarchy-address="'+a+'"]').click(),action=a=>document.querySelector('[data-experiment-action="'+a+'"]').click(),data=v=>{const n=document.querySelector('[data-field="data"]');n.value=String(v);n.dispatchEvent(new Event('change',{bubbles:true}))},text=()=>document.querySelector('.an-memory-hierarchy').textContent;
 ok(text().includes('尚未执行读写'),'no fabricated last access');data(42);action('write');select(1);data(99);action('write');select(0);action('access');
 ok(text().includes('回填两个字节 [42, 99]'),'full block refill');ok(text().includes('→ 返回 42'),'offset zero value');
 select(1);ok(text().includes('缓存字节[1] = 99'),'candidate offset one');ok(text().includes('最近读取地址 0'),'selection does not fake read');action('access');ok(text().includes('命中，从缓存取字节 → 返回 99'),'offset one hit');
 data(7);action('write');ok(text().includes('缓存行0失效'),'write invalidates');ok(text().includes('上次读取的返回值未被这次写入覆盖'),'write vs read explicit');
 action('access');ok(text().includes('[42, 7]'),'refill updated bytes');ok(text().includes('→ 返回 7'),'updated value');select(8);ok(text().includes('最近读取地址 1'),'recent access retains actual address');
 const s=anatomyState();s.addr=0;s.data=31;anatomyAdvance('memorySystem',s,'write');anatomyAdvance('memorySystem',s,'access');s.mainMem[0]=77;ok(s.memoryAccess.bytes[0]===31,'record has copied block');
 document.querySelector('.an-memory-hierarchy').scrollIntoView({block:'center'});return {status:'passed',checks};
}
