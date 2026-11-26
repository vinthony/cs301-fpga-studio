async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},d=()=>document.querySelector('.anatomy-dialog[open]'),wait=()=>new Promise(r=>setTimeout(r,60));
 const launch=async()=>{document.querySelector('[data-topic-tab="deep"]').click();document.querySelector('#topic-deep .architecture-launch').click();await wait()};
 d()?.querySelector('[data-an-close]').click();
 for(let digit=0;digit<4;digit++)for(let nib=0;nib<16;nib++){
  openTopic('sevenseg');const word=(0x3210&~(15<<(digit*4)))|(nib<<(digit*4));
  document.querySelector('#segmentWord').value=word.toString(16);document.querySelector('#setSegmentWord').click();
  const select=document.querySelector('#digitSelect');select.value=digit;select.dispatchEvent(new Event('change',{bubbles:true}));
  const before=snapshotLearningBoard();ok(before.word===word&&before.digit===digit&&before.segmentCode===((~AN_SEG[nib])&127),'source snapshot');
  await launch();ok(d().dataset.view==='sevenseg'&&parseInt(d().querySelector('[data-word]').value,16)===word,'display word inherited');
  ok(+d().querySelector('[data-coach-delta] b').textContent===(15^(1<<digit)),'selected active-low an inherited');
  d().querySelector('[data-part="DRV"]').dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await wait();
  ok(d().dataset.view==='scan'&&parseInt(d().querySelector('[data-word]').value,16)===word&&+d().querySelector('[data-coach-delta] b').textContent===(15^(1<<digit)),'scan inherits same word and phase');
  d().querySelector('[data-tick]').click();d().querySelector('[data-an-close]').click();
  ok(snapshotLearningBoard().word===word&&snapshotLearningBoard().digit===digit,'independent source');
 }
 openTopic('sevenseg');document.querySelector('[data-segment="0"]').click();document.querySelector('#dotToggle').click();await launch();
 const note=d().querySelector('.an-transfer-note').textContent;ok(note.includes('不复制任意段覆盖')&&note.includes('小数点请求dp=0'),'manual segment and dot differences explicit');
 d().querySelector('[data-an-close]').click();return {status:'passed',cases:64,checks};
}
