async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},d=()=>document.querySelector('.anatomy-dialog[open]'),wait=()=>new Promise(r=>setTimeout(r,70));
 // A received byte must never be replaced by the unrelated transmit candidate.
 for(let byte=0;byte<256;byte++)for(const tx of [0,65,255]){
  const s=anatomyState();Object.assign(s,{byte:tx,rxData:byte,rxPhase:4,a:byte&1});const e=anatomyEvaluate('rx',s);
  ok(e.result===byte&&e.nets['组装字节']===byte,'receive register source');
  ok(e.nets['起始检测']===0&&e.nets['采样使能']===1,'receiver phase not overwritten');
 }
 d()?.querySelector('[data-an-close]').click();
 for(const raw of [0,1]){
  openArchitecture('uartcore');await wait();if((d().querySelector('[data-toggle="a"]').getAttribute('aria-pressed')==='true')!==!!raw)d().querySelector('[data-toggle="a"]').click();
  d().querySelector('[data-field="byte"]').value=165;d().querySelector('[data-field="byte"]').dispatchEvent(new Event('change',{bubbles:true}));d().querySelector('[data-tick]').click();
  d().querySelector('[data-part="RX"]').dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await wait();
  ok(d().dataset.view==='rx'&&(d().querySelector('[data-toggle="a"]').getAttribute('aria-pressed')==='true')===!!raw,'raw RX transferred independently');
  ok(+d().querySelector('[data-coach-delta] b').textContent===0&&d().querySelector('.an-transfer-note').textContent.includes('待发字节不是已收字节'),'receive starts empty');
  d().querySelector('[data-toggle="a"]').click();d().querySelector('[data-reread-parent]').click();await wait();ok((d().querySelector('[data-toggle="a"]').getAttribute('aria-pressed')==='true')===!!raw,'reread source');
  d().querySelector('[data-an-close]').click();
 }
 return {status:'passed',checks};
}
