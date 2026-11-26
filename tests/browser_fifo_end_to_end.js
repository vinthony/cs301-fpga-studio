async()=>{
 let checks=0;const ok=(v,m)=>{if(!v)throw Error(m);checks++};
 const s=anatomyState(),send=v=>{s.data=v;anatomyAdvance('fifo',s);for(let i=0;i<11;i++)anatomyFIFOTransmitStep(s)},order=()=>{const q=s.fifoTX.rxFIFO;return Array.from({length:q.fifoCount},(_,i)=>q.fifoMem[(q.fifoRead+i)%4])};
 for(const v of [1,2,3,4,5,6])send(v);ok(JSON.stringify(order())==='[1,2,3,4]','full receiver preserves queued data');ok(s.fifoTX.rxOverflow===2,'two dropped new bytes');
 const before=JSON.stringify(s.fifoTX.tx);anatomyFIFOReceiveRead(s);ok(s.fifoTX.consumed[0]===1,'consumer gets oldest');ok(JSON.stringify(s.fifoTX.tx)===before,'consume does not advance TX');send(7);ok(JSON.stringify(order())==='[2,3,4,7]','space reused without loss');
 while(anatomyFIFOReceiveRead(s)){}ok(JSON.stringify(s.fifoTX.consumed)==='[1,2,3,4,7]','consumer order');ok(!anatomyFIFOReceiveRead(s),'empty consumer holds');
 const bitlink={};for(const v of [0,...Array(8).fill(1),0])anatomyFIFOReceiveWire(bitlink,v);ok(bitlink.rx.rxError===1&&bitlink.rxFIFO.fifoCount===0,'bad stop never enters receive FIFO');
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('fifo');await new Promise(r=>setTimeout(r,180));
 for(const v of [10,20,30,40,50]){const n=document.querySelector('[data-field="data"]');n.value=String(v);n.dispatchEvent(new Event('change',{bubbles:true}));document.querySelector('[data-experiment-action="tick"]').click();for(let i=0;i<11;i++)document.querySelector('[data-fifo-tx-step]').click()}
 ok(document.querySelector('[data-fifo-rx-order]').textContent.includes('10 → 20 → 30 → 40'),'UI receive order');ok(document.querySelector('[data-fifo-rx-overflow]').textContent.includes('次数：1'),'UI overflow');
 const watch=document.querySelector('.an-watch').textContent;document.querySelector('[data-fifo-rx-read]').click();ok(document.querySelector('[data-fifo-rx-consumed]').textContent.includes('应用已取：10'),'UI consumer');ok(document.querySelector('.an-watch').textContent===watch,'reading RX does not change TX queue');
 document.querySelector('.an-fifo-rx').scrollIntoView({block:'center'});return {status:'passed',checks};
}
