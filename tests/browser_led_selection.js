async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++};
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();
 for(const bit of [3,15,0,7]){
  openTopic('leds');const before=snapshotLearningBoard().led;
  const select=document.querySelector('#observeLEDBit');select.value=String(bit);select.dispatchEvent(new Event('change',{bubbles:true}));
  const source=snapshotLearningBoard();ok(source.led===before&&source.outputBit===bit,'select observation without changing output '+bit);
  document.querySelector('[data-topic-tab="deep"]').click();document.querySelector('#topic-deep .architecture-launch').click();
  for(let i=0;i<100;i++){await new Promise(r=>setTimeout(r,20));if(document.querySelector('.anatomy-dialog[open] .an-scene')?.dataset.render==='ready')break}
  ok(+document.querySelector('.anatomy-dialog[open] [data-coach-delta] b').textContent===((before>>>bit)&1),'selected output reaches anatomy '+bit);
  document.querySelector('.anatomy-dialog[open] [data-an-close]').click();
 }
 return {status:'passed',checks};
}
