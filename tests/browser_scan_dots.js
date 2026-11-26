async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++};
 for(const id of ['sevenseg','scan'])for(let dots=0;dots<16;dots++)for(let digit=0;digit<4;digit++)for(let scanPhase=0;scanPhase<3;scanPhase++){
  const s=Object.assign(anatomyState(),{scanDots:dots,digit,scanPhase}),e=anatomyEvaluate(id,s);
  ok(e.digits.every((mask,i)=>!!(mask&128)===(i===digit&&scanPhase===2&&!!(dots&(1<<digit)))),'dot requires requested digit and active phase');
  const doc=new DOMParser().parseFromString(anatomyScanLens(ANATOMY[id],s),'text/html');
  ok(+doc.querySelector('[data-scan-dp]').textContent===1-((dots>>>digit)&1),'shared dp follows selected bit');
  ok([...doc.querySelectorAll('[data-scan-dot]')].every(n=>(n.getAttribute('fill')==='#ff665c')===(+n.dataset.scanDot===digit&&scanPhase===2&&!!(dots&(1<<digit)))),'visual matches model');
 }
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openTopic('sevenseg');document.querySelector('#dotToggle').click();
 document.querySelector('[data-topic-tab="deep"]').click();document.querySelector('#topic-deep .architecture-launch').click();await new Promise(r=>setTimeout(r,100));
 const d=()=>document.querySelector('.anatomy-dialog[open]');ok(d().querySelector('[data-scan-dp]').textContent==='0','source dot inherited');
 d().querySelector('[data-part="DRV"]').dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await new Promise(r=>setTimeout(r,100));ok(d().querySelector('[data-scan-dp]').textContent==='0','dot follows drill down');
 d().querySelector('[data-scan-dot-toggle="0"]').click();ok(d().querySelector('[data-scan-dp]').textContent==='1','dot independently toggled');
 d().querySelector('[data-reread-parent]').click();await new Promise(r=>setTimeout(r,100));ok(d().querySelector('[data-scan-dp]').textContent==='0','reread restores dot');
 d().querySelector('[data-tick]').click();ok([...d().querySelectorAll('[data-scan-dot]')].every(n=>n.getAttribute('fill')!=='#ff665c'),'blank phase suppresses dots');
 return {status:'passed',checks,states:384};
}
