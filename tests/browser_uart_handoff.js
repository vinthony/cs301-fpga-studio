async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},d=()=>document.querySelector('.anatomy-dialog[open]'),wait=()=>new Promise(r=>setTimeout(r,70)),out=()=>+d().querySelector('[data-coach-delta] b').textContent;
 d()?.querySelector('[data-an-close]').click();
 for(const byte of [0,1,65,85,128,170,254,255])for(const baud of [9600,115200]){
  openTopic('uart');document.querySelector('#uartByte').value=byte.toString(16);document.querySelector('#uartBaud').value=baud;document.querySelector('#uartApply').click();
  ok(snapshotLearningBoard().uartByte===byte&&snapshotLearningBoard().uartBaud===baud,'source byte and baud');
  document.querySelector('[data-topic-tab="deep"]').click();document.querySelector('#topic-deep .architecture-launch').click();await wait();
  ok(d().dataset.view==='uartcore'&&+d().querySelector('[data-field="byte"]').value===byte&&+d().querySelector('[data-field="baud"]').value===baud&&out()===1,'idle handoff');
  d().querySelector('[data-tick]').click();ok(out()===0,'start bit');
  d().querySelector('[data-part="TX"]').dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await wait();ok(out()===0&&+d().querySelector('[data-field="byte"]').value===byte,'TX captured start inherited');
  for(let bit=0;bit<8;bit++){d().querySelector('[data-tick]').click();ok(out()===((byte>>>bit)&1),'data low bit first')}
  d().querySelector('[data-tick]').click();ok(out()===1,'stop bit');
  d().querySelector('.an-context-path [data-context-id="uartcore"]').click();await wait();ok(out()===0,'child does not advance parent');
  d().querySelector('[data-part="BAUD"]').dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await wait();ok(+d().querySelector('[data-field="byte"]').value===byte&&+d().querySelector('[data-field="baud"]').value===baud&&d().querySelector('.an-transfer-note').textContent.includes('从0开始'),'baud separate time base');
  d().querySelector('[data-an-close]').click();ok(snapshotLearningBoard().uartByte===byte&&snapshotLearningBoard().uartBaud===baud,'source unchanged');
 }
 return {status:'passed',checks,cases:16};
}
