async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++};
 for(const before of [0,0xfff,0xa5c])for(const input of [0,0xfff,0x369])for(const enable of [0,1]){
  const s=anatomyState();s.pixelQ=before;s.pixelD=input;s.pixelWE=enable;anatomyAdvance('pixelword',s);
  const host=document.createElement('div');host.innerHTML=anatomyPixelWordEdge(s);
  ok(host.querySelectorAll('[data-pixelword-edge-bit]').length===12,'twelve bits');
  for(const cell of host.querySelectorAll('[data-pixelword-edge-bit]')){const bit=+cell.dataset.pixelwordEdgeBit,old=(before>>>bit)&1,next=((enable?input:before)>>>bit)&1;ok(cell.querySelector('b').textContent===String(next),'actual next');ok(cell.dataset.edgeKind===(!enable?'hold':old!==next?'changed':'same'),'classification')}
 }
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('pixelword');await new Promise(r=>setTimeout(r,300));
 const d=()=>document.querySelector('.anatomy-dialog[open]');d().querySelector('[data-experiment-action="tick"]').click();
 const cells=d().querySelectorAll('[data-pixelword-edge-bit]');ok(cells.length===12,'actual mounted edge');
 const serial=()=>d().querySelector('[data-observation-status]').textContent,prior=serial(),value=d().querySelector('[data-coach-delta] b').textContent;
 const replay=d().querySelector('[data-pixelword-replay]');replay.click();replay.click();ok(serial()===prior&&d().querySelector('[data-coach-delta] b').textContent===value,'replay changes no saved value or observation');
 if(!matchMedia('(prefers-reduced-motion: reduce)').matches){ok([...cells].every(c=>c.getAnimations().length===1),'repeat cancels previous animation');await new Promise(r=>setTimeout(r,1200));ok([...cells].every(c=>c.getAnimations().length===0),'animations finish without persistent effects')}
 return {status:'passed',checks};
}
