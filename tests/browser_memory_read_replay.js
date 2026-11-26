async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++};
 for(let address=0;address<16;address++){
  const s=anatomyState();s.mainMem=Array.from({length:16},(_,i)=>i*11+3);s.addr=address;
  for(const hit of [false,true]){anatomyAdvance('memorySystem',s,'access');const record=anLearningClone(s.memoryAccess);s.addr=address^3;const doc=new DOMParser().parseFromString(anatomyMemoryReadReplay(s),'text/html');ok(doc.querySelectorAll('[data-memory-read-stage]').length===4,'four explanation stages');ok(doc.querySelector('[data-memory-read-byte="'+(address&1)+'"]').getAttribute('data-chosen')==='true','selected original offset');ok(doc.body.textContent.includes('地址'+address+'读取')&&doc.body.textContent.includes('返回 '+record.value),'recorded address and result');ok(doc.body.textContent.includes(hit?'跳过后备读取':'从后备地址'),'hit controls backing read explanation');s.addr=address;}
  s.addr=address^8;anatomyAdvance('memorySystem',s,'access');ok(anatomyMemoryReadReplay(s).includes('冲突缺失'),'conflict explains replaced tag');
 }
 const d=()=>document.querySelector('.anatomy-dialog[open]');d()?.querySelector('[data-an-close]').click();openArchitecture('memorySystem');await new Promise(r=>setTimeout(r,100));d().querySelector('[data-experiment-action="access"]').click();
 const fingerprint=()=>JSON.stringify({range:d().querySelector('[data-observation-range]').max,result:d().querySelector('[data-coach-delta] b').textContent,cache:[...d().querySelectorAll('[data-hierarchy-line]')].map(n=>n.textContent)}),before=fingerprint(),panel=d().querySelector('.an-memory-read-replay');
 panel.querySelector('[data-memory-read-replay]').click();ok(panel.getAnimations({subtree:true}).length===4,'animation starts four groups');await new Promise(r=>setTimeout(r,2100));ok(fingerprint()===before&&panel.querySelector('[role="status"]').textContent.includes('回放结束'),'replay finishes without model operations');
 const original=window.matchMedia;try{window.matchMedia=q=>q==='(prefers-reduced-motion: reduce)'?{matches:true}:original(q);panel.querySelector('[data-memory-read-replay]').click();ok(panel.getAnimations({subtree:true}).length===0&&panel.querySelector('[role="status"]').textContent.includes('减少动态'),'reduced motion static');}finally{window.matchMedia=original}
 d().querySelector('[data-hierarchy-bit="0"]').click();ok(d().querySelector('.an-memory-read-replay h5').textContent.includes('地址0读取'),'request change keeps original replay');
 return {status:'passed',checks,addresses:16};
}
