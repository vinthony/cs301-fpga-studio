async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},d=()=>document.querySelector('.anatomy-dialog[open]'),wait=()=>new Promise(r=>setTimeout(r,100));
 d()?.querySelector('[data-an-close]').click();
 for(const raw of [0,1]){
  openArchitecture('rx');await wait();d().querySelector('[data-rx-drive-sample="0"]').click();d().querySelector('[data-rx-drive-sample="1"]').click();
  const toggle=d().querySelector('[data-toggle="a"]');if((toggle.getAttribute('aria-pressed')==='true')!==!!raw)toggle.click();
  const before=d().querySelector('[data-rx-accepted]').textContent;
  ok(ANATOMY.rx.parts.find(p=>p.id==='SYNC').type==='buffer','ideal sample not drawn as saved DFF');
  d().querySelector('[data-part="SYNC"]').dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await wait();
  ok(d().dataset.view==='asyncrx'&&(d().querySelector('[data-toggle="a"]').getAttribute('aria-pressed')==='true')===!!raw,'raw source copied');
  ok(d().querySelector('.an-watch').textContent.includes('第一级 / 第二级1 / 1')&&d().querySelector('.an-transfer-note').textContent.includes('不复制理想接收'),'fresh synchronizer boundary explicit');
  d().querySelector('[data-experiment-action="tick"]').click();ok(d().querySelector('.an-watch').textContent.includes('第一级 / 第二级'+raw+' / 1'),'first edge only FF1 samples raw');
  d().querySelector('[data-experiment-action="tick"]').click();ok(d().querySelector('.an-watch').textContent.includes('第一级 / 第二级'+raw+' / '+raw),'second edge FF2 samples old FF1');
  d().querySelector('[data-reread-parent]').click();await wait();ok(d().querySelector('.an-watch').textContent.includes('第一级 / 第二级1 / 1'),'reread creates fresh sampler');
  d().querySelector('.an-context-path [data-context-id="rx"]').click();await wait();ok(d().querySelector('[data-rx-accepted]').textContent===before,'sampler does not mutate ideal receiver');d().querySelector('[data-an-close]').click();
 }
 return {status:'passed',checks};
}
