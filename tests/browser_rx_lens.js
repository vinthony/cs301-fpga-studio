async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++};
 for(let byte=0;byte<256;byte++)for(const stop of [0,1]){
  const s=anatomyState();s.a=0;anatomyAdvance('rx',s,'tick');
  for(let count=0;count<=8;count++){
   const doc=new DOMParser().parseFromString(anatomyIdealRXLens(s),'text/html');
   ok(doc.querySelectorAll('[data-known="true"]').length===count,'only sampled bits marked known');
   ok([...doc.querySelectorAll('[data-rx-received-bit]')].every(n=>{const bit=+n.dataset.rxReceivedBit;return n.textContent.endsWith(bit<count?String((byte>>>bit)&1):'·')}),'received bit values');
   ok(!s.rxValid&&!s.rxError,'no valid before stop');
   if(count<8){s.a=(byte>>>count)&1;anatomyAdvance('rx',s,'tick')}
  }
  s.a=stop;anatomyAdvance('rx',s,'tick');ok(s.rxData===byte&&s.rxValid===stop&&s.rxError===1-stop,'stop controls validity');
  let e=anatomyEvaluate('rx',s);ok(e.nets['组装字节']===byte&&e.nets['接收有效']===stop&&e.nets['帧错误']===1-stop,'separate data and status wires');
  s.a=1;anatomyAdvance('rx',s,'tick');e=anatomyEvaluate('rx',s);ok(e.result===byte&&e.nets['接收有效']===0&&e.nets['帧错误']===0,'event clears but data remains');
 }
 const d=()=>document.querySelector('.anatomy-dialog[open]');d()?.querySelector('[data-an-close]').click();openArchitecture('rx');await new Promise(r=>setTimeout(r,100));
 for(const byte of [0,65,128,255])for(const stop of [0,1]){
  d().querySelector('[data-lab-reset]').click();d().querySelector('[data-rx-drive-sample="0"]').click();
  for(let bit=0;bit<8;bit++)d().querySelector('[data-rx-drive-sample="'+((byte>>>bit)&1)+'"]').click();
  ok(d().querySelector('.an-rx-verdict').textContent.includes('还不是有效帧'),'eight bits not sufficient');
  d().querySelector('[data-rx-drive-sample="'+stop+'"]').click();ok(+d().querySelector('[data-coach-delta] b').textContent===byte&&d().querySelector('[data-rx-accepted]').textContent.includes('VALID='+stop+'，ERROR='+(1-stop)),'actual UI receives frame');
 }
 const range=d().querySelector('[data-observation-range]');range.value=0;range.dispatchEvent(new Event('input',{bubbles:true}));const before=d().querySelector('[data-rx-accepted]').textContent;d().querySelector('[data-rx-drive-sample="0"]').click();ok(d().querySelector('[data-rx-accepted]').textContent===before,'history cannot sample');d().querySelector('[data-observation-live]').click();
 return {status:'passed',checks,modelFrames:512,uiFrames:8};
}
