async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++};
 for(let source=0;source<16;source++)for(let request=0;request<16;request++){
  const state=anatomyState();state.mainMem=Array.from({length:16},(_,i)=>i*13);state.addr=source;anatomyAdvance('memorySystem',state,'access');state.addr=request;
  const row={state,evaluation:anatomyEvaluate('memorySystem',state)},channels=anatomyWaveChannels(ANATOMY.memorySystem,[row]),value=kind=>anatomyWaveValue(row,channels.find(c=>c.kind===kind));
  ok(value('memory-read-address')===source&&value('memory-read-value')===source*13,'source survives all request changes');
  ok(value('memory-read-hit')===0&&value('memory-candidate-hit')===+(Math.floor(source/2)===Math.floor(request/2)),'recorded miss and current candidate separate');
 }
 const b=ANATOMY.memorySystem,s=anatomyState(),trace=[],capture=()=>trace.push({serial:trace.length,state:anLearningClone(s),evaluation:anLearningClone(anatomyEvaluate(b.id,s))});capture();
 s.data=42;anatomyAdvance(b.id,s,'write');capture();anatomyAdvance(b.id,s,'access');capture();s.addr=1;capture();anatomyAdvance(b.id,s,'access');capture();s.data=99;anatomyAdvance(b.id,s,'write');capture();anatomyAdvance(b.id,s,'access');capture();
 const channels=anatomyWaveChannels(b,trace),values=kind=>trace.map(row=>anatomyWaveValue(row,channels.find(c=>c.kind===kind)));
 for(const [kind,expected]of [['memory-operation',['未操作','写','读','读','读','写','读']],['memory-read-address',['尚未读','尚未读',0,0,1,1,1]],['memory-read-value',['尚未读','尚未读',42,42,0,0,99]],['memory-read-hit',['尚未读','尚未读',0,0,1,1,0]],['memory-candidate-hit',[0,0,1,1,1,0,1]]])ok(JSON.stringify(values(kind))===JSON.stringify(expected),'historical '+kind);
 ok(anatomyObservationCSV(b,trace).includes('上次读取来源地址')&&anatomyObservationCSV(b,trace).includes('非每行事件'),'CSV source columns');
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('memorySystem');await new Promise(r=>setTimeout(r,100));const d=document.querySelector('.anatomy-dialog[open]');d.querySelector('[data-experiment-action="access"]').click();d.querySelector('[data-hierarchy-bit="0"]').click();
 ok(d.querySelectorAll('.an-wave-svg [data-wave-channel]').length===6,'six actual channels');ok(d.querySelector('.an-wave-svg [data-wave-channel="上次读取来源地址"]'),'source address waveform exists');
 const original=URL.createObjectURL,click=HTMLAnchorElement.prototype.click;let blob;try{URL.createObjectURL=b=>{blob=b;return original(b)};HTMLAnchorElement.prototype.click=function(){};d.querySelector('[data-observation-export]').click();const csv=await blob.text();ok(csv.includes('上次实际读取字节')&&csv.includes('上次读取是否命中')&&csv.includes('当前候选是否命中'),'actual CSV source and candidate separated');}finally{URL.createObjectURL=original;HTMLAnchorElement.prototype.click=click}
 return {status:'passed',checks,observations:trace.length};
}
