async()=>{
 let checks=0;const ok=(v,m)=>{if(!v)throw Error(m);checks++},wait=()=>new Promise(r=>setTimeout(r,180)),open=async key=>{document.querySelector('.anatomy-dialog[open] [data-part="'+key+'"]').dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await wait()},back=async()=>{document.querySelector('[data-return-parent]').click();await wait()},field=(key,value)=>{const n=document.querySelector('[data-field="'+key+'"]');n.value=String(value);n.dispatchEvent(new Event('change',{bubbles:true}))};
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('memorySystem');await wait();
 document.querySelector('[data-hierarchy-address="10"]').click();field('data',55);document.querySelector('[data-experiment-action="write"]').click();document.querySelector('[data-experiment-action="access"]').click();
 const before=document.querySelector('.an-watch').textContent;
 await open('CACHE');ok(document.querySelector('[data-field="addr"]').value==='10','cache address inherited');ok(document.querySelector('[data-cache-line="1"]').textContent.includes('样本=55'),'cache sample inherited');ok(document.querySelector('.an-cache-result').textContent.includes('命中'),'cache valid tag inherited');
 field('addr',8);document.querySelector('[data-reread-parent]').click();await wait();ok(document.querySelector('[data-field="addr"]').value==='10','reread restores parent snapshot');
 await open('TAG');ok(document.querySelector('[data-field="addr"]').value==='10','tag address');ok(document.querySelector('.an-cache-result').textContent.includes('命中'),'tag valid copied');await back();await back();
 ok(document.querySelector('.an-watch').textContent===before,'parent preserved');
 await open('RAM');ok(document.querySelector('[data-field="addr"]').value==='2','BRAM local offset');ok(document.querySelector('.an-transfer-note').textContent.includes('8…15'),'window mapping stated');
 ok(document.querySelector('[data-toggle="we"]').textContent.includes('0'),'write disabled');
 document.querySelector('[data-experiment-action="tick"]').click();ok(document.querySelector('.an-watch').textContent.includes('55'),'BRAM reads copied data');await back();ok(document.querySelector('.an-watch').textContent===before,'BRAM independent');
 return {status:'passed',checks};
}
