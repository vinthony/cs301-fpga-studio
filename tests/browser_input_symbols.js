async()=>{
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('input');await new Promise(r=>setTimeout(r,150));let checks=0;
 const expected=[[0,0,0,0,0,0,0],[1,0,0,1,0,0,0],[1,1,0,2,0,0,0],[1,1,1,1,0,0,0],[1,1,1,2,0,0,0],[1,1,1,3,1,0,1],[1,1,1,4,1,1,0]];
 for(let i=0;i<expected.length;i++){
  const refs=id=>document.querySelector('.an-scene [data-diagram-part="'+id+'"]')._inputRuntime,sync=refs('SYNC'),db=refs('DB'),ev=refs('EV'),x=expected[i];
  if(sync.ff.map(n=>n.textContent).join()!==x.slice(0,2).join())throw Error('sync '+i);checks++;
  if(db.candidate.textContent!==String(x[2])||db.count.textContent!==String(x[3])||db.stable.textContent!=='已保存稳定值 = '+x[4])throw Error('debounce '+i);checks+=3;
  if(ev.previous.textContent!==String(x[5])||ev.event.textContent!==x[4]+' AND NOT '+x[5]+' = '+x[6])throw Error('event '+i);checks+=2;
  if(i<expected.length-1)document.querySelector('[data-experiment-action="tick"]').click();
 }
 return{status:'passed',checks};
}
