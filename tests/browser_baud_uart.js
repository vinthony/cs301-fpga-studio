async()=>{
 let checks=0;const ok=(v,m)=>{if(!v)throw Error(m);checks++};
 for(const baud of [9600,115200])for(const byte of [0,65,85,255]){
  const fast=anatomyState(),slow=anatomyState(),div=Math.round(1e8/baud);fast.baud=slow.baud=baud;fast.byte=slow.byte=byte;anatomyAdvance('baud',fast,'prepare');anatomyAdvance('baud',slow,'prepare');fast.byte=slow.byte=255-byte;
  for(let i=0;i<11;i++)anatomyAdvance('baud',fast,'period');for(let i=0;i<11*div;i++)anatomyAdvance('baud',slow,'tick');
  ok(JSON.stringify(fast.baudTX)===JSON.stringify(slow.baudTX),'fast equals master-clock execution '+baud+' '+byte);ok(fast.baudTX.done&&fast.baudTX.tx.uartByte===byte,'captured and done');
  const records=fast.baudTX.records;ok(records.every((r,i)=>r.clock===(i+1)*div),'exact enable edge positions');ok(JSON.stringify(records.slice(0,10).map(r=>r.level))===JSON.stringify([0,...Array.from({length:8},(_,i)=>(byte>>>i)&1),1]),'encoded frame');ok(records[10].clock-records[0].clock===div*10,'full frame has ten bit periods');
 }
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('baud');await new Promise(r=>setTimeout(r,200));const act=k=>document.querySelector('[data-experiment-action="'+k+'"]').click(),text=()=>document.querySelector('[data-baud-tx-status]').textContent;
 act('prepare');act('terminal');ok(text().includes('等待首次使能'),'terminal not consumed early');act('tick');ok(text().includes('START · TX=0'),'edge consumes enable');act('batch32');ok(text().includes('START · TX=0'),'ordinary clocks hold TX');act('period');ok(text().includes('d0 · TX=1'),'next enable sends d0');
 await new Promise(r=>setTimeout(r,180));ok(document.querySelector('.an-scene').dataset.render==='ready','new diagram ready');ok(document.querySelector('.an-scene [data-diagram-part="TXBAUD"]').textContent.includes('d0'),'diagram transmitter linked');
 const select=document.querySelector('[data-field="baud"]');select.value='9600';select.dispatchEvent(new Event('change',{bubbles:true}));ok(text().includes('先点击'),'retarget aborts prepared frame');
 document.querySelector('.an-baud-tx').scrollIntoView({block:'center'});return {status:'passed',checks};
}
