async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++};
 for(let byte=0;byte<256;byte++)for(const stop of [0,1]){
  const s=anatomyState(),trace=[],capture=()=>trace.push({serial:trace.length,state:anLearningClone(s),evaluation:anLearningClone(anatomyEvaluate('rx',s))});capture();
  for(const bit of [0,...Array.from({length:8},(_,i)=>(byte>>>i)&1),stop,1]){s.a=bit;anatomyAdvance('rx',s,'tick');capture()}
  const channels=anatomyWaveChannels(ANATOMY.rx,trace),phase=channels.find(c=>c.kind==='rx-phase');ok(channels.length===6,'six receive channels');
  const labels=trace.map(row=>anatomyWaveValue(row,phase));ok(JSON.stringify(labels)===JSON.stringify(['IDLE',...Array.from({length:8},(_,i)=>'d'+i),'STOP','IDLE','IDLE']),'phase history');
  const valid=channels.find(c=>c.key==='接收有效'),error=channels.find(c=>c.key==='帧错误');ok(anatomyWaveValue(trace[10],valid)===stop&&anatomyWaveValue(trace[10],error)===1-stop,'stop pulse in historical row');
  ok(anatomyWaveValue(trace[11],valid)===0&&anatomyWaveValue(trace[11],error)===0&&trace[11].evaluation.result===byte,'event clears and data holds');
  const csv=anatomyObservationCSV(ANATOMY.rx,trace);ok(csv.includes('接收阶段（下一采样）')&&csv.includes('VALID接收有效')&&csv.includes('ERROR停止位错误')&&csv.includes('"STOP"'),'CSV receive columns');
 }
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('rx');await new Promise(r=>setTimeout(r,100));const d=document.querySelector('.anatomy-dialog[open]');
 for(const bit of [0,1,0,1,0,1,0,1,0,0])d.querySelector('[data-rx-drive-sample="'+bit+'"]').click();
 ok(d.querySelectorAll('.an-wave-svg [data-wave-channel]').length===6,'actual waveform has receive channels');
 const rows=d.querySelector('.an-wave-svg [data-wave-channel="接收阶段（下一采样）"]');ok(rows.textContent.includes('STOP'),'actual waveform shows stop phase');
 const original=URL.createObjectURL,click=HTMLAnchorElement.prototype.click;let blob;try{URL.createObjectURL=b=>{blob=b;return original(b)};HTMLAnchorElement.prototype.click=function(){};d.querySelector('[data-observation-export]').click();const text=await blob.text();ok(text.includes('ERROR停止位错误')&&text.includes('"STOP"'),'actual exported CSV');}finally{URL.createObjectURL=original;HTMLAnchorElement.prototype.click=click}
 return {status:'passed',checks,frames:512};
}
