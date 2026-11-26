async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++};
 for(let addr=0;addr<16;addr++){
  const s=anatomyState();s.addr=addr;s.mainMem=Array.from({length:16},(_,i)=>i*13+5);
  ok(s.memoryLastRead===null,'no fabricated read');anatomyAdvance('memorySystem',s,'access');
  ok(s.memoryLastRead.address===addr&&s.memoryLastRead.value===addr*13+5&&!s.memoryLastRead.hit,'cold read source');
  anatomyAdvance('memorySystem',s,'access');ok(s.memoryLastRead.hit,'subsequent hit recorded');const read=JSON.stringify(s.memoryLastRead);
  s.addr=addr^1;s.data=255;anatomyAdvance('memorySystem',s,'write');ok(JSON.stringify(s.memoryLastRead)===read&&s.lastRead===addr*13+5,'write preserves previous read source');
  anatomyAdvance('memorySystem',s,'access');ok(s.memoryLastRead.address===(addr^1)&&s.memoryLastRead.value===255,'explicit access changes result source');
 }
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('memorySystem');await new Promise(r=>setTimeout(r,100));const d=document.querySelector('.anatomy-dialog[open]'),result=()=>d.querySelector('[data-memory-read-result]').textContent,field=(key,value)=>{const f=d.querySelector('[data-field="'+key+'"]');f.value=value;f.dispatchEvent(new Event('change',{bubbles:true}))};
 ok(result().includes('尚未产生读取结果'),'initial UI explicit');field('data',99);d.querySelector('[data-experiment-action="write"]').click();ok(result().includes('尚未产生读取结果'),'write does not fabricate read');d.querySelector('[data-experiment-action="access"]').click();ok(result().includes('地址 0 → 99'),'UI read has source');
 field('addr',1);field('data',42);d.querySelector('[data-experiment-action="write"]').click();ok(result().includes('地址 0 → 99')&&result().includes('当前请求地址 1'),'write and request separate');
 d.querySelector('[data-experiment-action="access"]').click();ok(result().includes('地址 1 → 42'),'new explicit read');d.querySelector('[data-observation-prev]').click();ok(result().includes('地址 0 → 99'),'history source restored');d.querySelector('[data-observation-live]').click();ok(result().includes('地址 1 → 42'),'live source preserved');
 return {status:'passed',checks,addresses:16};
}
