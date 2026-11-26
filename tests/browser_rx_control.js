async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++};const {mountSchematic}=await import('./anatomy-schematic.js');
 const host=document.createElement('div');host.style.cssText='position:absolute;left:-10000px;width:1500px';document.body.append(host);const drawing=mountSchematic(host,ANATOMY.rx,()=>{},()=>{});
 try{for(let phase=-1;phase<=8;phase++)for(const raw of [0,1]){
  const s=Object.assign(anatomyState(),{rxPhase:phase,a:raw}),e=anatomyEvaluate('rx',s);drawing.update(s,e);const current=phase<0?0:phase<8?1:2,group=host.querySelector('[data-diagram-part="FSM"]');
  ok(group.querySelectorAll('[data-rx-control-state][aria-current="true"]').length===1&&group.querySelector('[data-rx-control-state="'+current+'"]').getAttribute('aria-current')==='true','exact active state');
  const text=group.querySelector('[data-rx-control-next]').textContent;
  ok(phase<0?text.includes(raw?'保持等待':'进入d0'):phase<7?text.includes('保存d'+phase+'，进入d'+(phase+1)):phase===7?text.includes('进入停止检查'):text.includes(raw?'VALID=1':'ERROR=1'),'next sample explanation');
 }}finally{drawing.dispose();host.remove()}
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('rx');await new Promise(r=>setTimeout(r,100));const d=document.querySelector('.anatomy-dialog[open]'),sample=v=>d.querySelector('[data-rx-drive-sample="'+v+'"]').click(),active=()=>+d.querySelector('.an-scene [data-rx-control-state][aria-current="true"]').dataset.rxControlState;
 ok(active()===0,'UI initial wait');sample(0);ok(active()===1,'UI start enters data');for(let i=0;i<8;i++)sample(i&1);ok(active()===2,'UI eight data enters stop');sample(0);ok(active()===0&&d.querySelector('.an-scene [data-diagram-part="ERROR"]').textContent.includes('ERROR 1'),'bad stop returns wait with error');
 d.querySelector('[data-observation-prev]').click();ok(active()===2,'history restores stop state');d.querySelector('[data-observation-live]').click();ok(active()===0,'live state preserved');
 return {status:'passed',checks,controlInputs:20};
}
