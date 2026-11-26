async()=>{
 let checks=0;const ok=(v,m)=>{if(!v)throw Error(m);checks++};
 const s=anatomyState();for(const v of [65,85,255]){s.data=v;anatomyAdvance('fifo',s)}const encoded=[];
 for(let i=0;i<33;i++){const before=s.fifoCount;anatomyFIFOTransmitStep(s);const row=s.fifoTX.trace.at(-1);if(row.index>=0)encoded.push(row.level);ok(s.fifoCount===before-(row.taken!==null?1:0),'only dequeue on start '+i)}
 ok(JSON.stringify(s.fifoTX.completed)==='[65,85,255]','completed in FIFO order');
 const expected=[65,85,255].flatMap(v=>[0,...Array.from({length:8},(_,i)=>(v>>>i)&1),1]);ok(JSON.stringify(encoded)===JSON.stringify(expected),'actual emitted frames');ok(s.fifoCount===0&&s.fifoTX.tx.uartIndex===-1,'queue and transmitter done');ok(!anatomyFIFOTransmitStep(s),'empty idle holds');
 s.uartLoop={samples:[1]};s.dramTrace=[{action:'wait'}];s.flashLast={kind:'erase'};s.memoryAccess={kind:'read'};anatomyAdvance('fifo',s,'reset');ok(s.fifoTX===null&&s.uartLoop===null&&s.flashLast===null&&s.memoryAccess===null&&s.dramTrace.length===0,'reset clears supplemental experiments');
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('fifo');await new Promise(r=>setTimeout(r,180));
 const data=v=>{const n=document.querySelector('[data-field="data"]');n.value=String(v);n.dispatchEvent(new Event('change',{bubbles:true}))};
 for(const v of [65,85]){data(v);document.querySelector('[data-experiment-action="tick"]').click()}
 document.querySelector('[data-fifo-tx-step]').click();ok(document.querySelector('.an-fifo-lens').textContent.includes('占用 1 / 4'),'same queue consumed');ok(document.querySelector('.an-fifo-tx').textContent.includes('字节65，START'),'start captures oldest');
 data(99);for(let i=0;i<10;i++)document.querySelector('[data-fifo-tx-step]').click();ok(document.querySelector('[data-fifo-tx-status]').textContent.includes('已完成字节：65'),'first frame completed');ok(document.querySelector('.an-fifo-lens').textContent.includes('占用 1 / 4'),'busy did not consume or push draft');
 for(let i=0;i<11;i++)document.querySelector('[data-fifo-tx-step]').click();ok(document.querySelector('[data-fifo-tx-status]').textContent.includes('65 → 85'),'second frame');ok(document.querySelector('[data-fifo-tx-step]').disabled,'nothing left');
 document.querySelector('[data-lab-reset]').click();ok(document.querySelector('[data-fifo-tx-status]').textContent.includes('已完成字节：无'),'UI reset');
 document.querySelector('.an-fifo-tx').scrollIntoView({block:'center'});return {status:'passed',checks};
}
