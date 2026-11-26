async()=>{
 let checks=0;const ok=(v,m)=>{if(!v)throw Error(m);checks++};
 const s=anatomyState(),queue=[];let random=20261124;const rng=()=>{random=(Math.imul(random,1664525)+1013904223)>>>0;return random};
 for(let i=0;i<12000;i++){
  s.fifoPush=!!(rng()&0x100);s.fifoPop=!!(rng()&0x100);s.data=rng()&255;
  const before=JSON.stringify(s),plan=anatomyFIFOPlan(s);ok(JSON.stringify(s)===before,'preview pure '+i);
  const pop=!!s.fifoPop&&queue.length>0,push=!!s.fifoPush&&(queue.length<4||pop),value=pop?queue.shift():null;if(push)queue.push(s.data);
  anatomyAdvance('fifo',s);ok(s.fifoLast.pop===pop&&s.fifoLast.push===push&&s.fifoLast.value===value,'accepted IO '+i);ok(s.fifoCount===queue.length,'count '+i);ok(JSON.stringify(queue)===JSON.stringify(Array.from({length:s.fifoCount},(_,j)=>s.fifoMem[(s.fifoRead+j)%4])),'ordering '+i);
 }
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('fifo');await new Promise(r=>setTimeout(r,180));
 const data=v=>{const n=document.querySelector('[data-field="data"]');n.value=String(v);n.dispatchEvent(new Event('change',{bubbles:true}))},tick=()=>document.querySelector('[data-experiment-action="tick"]').click(),toggle=k=>document.querySelector('[data-toggle="'+k+'"]').click(),text=()=>document.querySelector('.an-fifo-lens').textContent;
 for(const v of [10,20,30,40]){data(v);tick()}ok(text().includes('FULL'),'full UI');data(99);tick();ok(text().includes('10 → 20 → 30 → 40'),'full rejects write');
 toggle('fifoPop');tick();ok(text().includes('20 → 30 → 40 → 99'),'full simultaneous replacement');ok(text().includes('读出 10；写入 99'),'read old not new');
 toggle('fifoPush');for(let i=0;i<4;i++)tick();ok(text().includes('EMPTY'),'empty UI');tick();ok(text().includes('拒绝读（空）'),'empty no stale output');toggle('fifoPush');data(77);tick();ok(text().includes('未读出；写入 77'),'empty simultaneous only pushes');
 document.querySelector('[data-part="MEM"]').dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await new Promise(r=>setTimeout(r,180));ok(document.querySelector('.an-transfer-note').textContent.includes('有效性和指针'),'SRAM scope');
 document.querySelector('[data-return-parent]').click();await new Promise(r=>setTimeout(r,180));document.querySelector('.an-fifo-lens').scrollIntoView({block:'center'});
 return {status:'passed',checks,steps:12000};
}
