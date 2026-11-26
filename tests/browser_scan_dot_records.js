async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++};
 for(const id of ['scan','sevenseg'])for(let mask=0;mask<16;mask++)for(let digit=0;digit<4;digit++)for(let phase=0;phase<3;phase++){
  const b=ANATOMY[id],state=Object.assign(anatomyState(),{scanDots:mask,digit,scanPhase:phase}),evaluation=anatomyEvaluate(id,state),row={serial:0,state,evaluation};
  const channels=anatomyWaveChannels(b,[row]),dp=1-((mask>>>digit)&1);
  ok(anatomyWaveValue(row,channels.find(c=>c.kind==='scan-dp'))===dp,'record dp');
  ok(anatomyWaveValue(row,channels.find(c=>c.kind==='scan-lit-dots'))===(phase===2?mask&(1<<digit):0),'record actual dot mask');
  ok(anatomyWaveValue(row,channels.find(c=>c.kind==='scan-seg'))===((~AN_SEG[(state.word>>>(digit*4))&15])&127).toString(2).padStart(7,'0'),'seven segments stay seven bits');
  ok(id==='scan'?evaluation.nets['小数点线']===dp:evaluation.nets['共享段支路'].endsWith('dp='+dp),'diagram signal includes independent dp');
  const csv=anatomyObservationCSV(b,[row]);ok(csv.includes('逐位小数点请求[3:0]')&&csv.includes('实际亮起小数点位掩码'),'CSV includes dot inputs and output');
 }
 return {status:'passed',checks};
}
