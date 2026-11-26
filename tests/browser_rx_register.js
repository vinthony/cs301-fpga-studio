async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},d=()=>document.querySelector('.anatomy-dialog[open]'),wait=()=>new Promise(r=>setTimeout(r,70)),sample=v=>d().querySelector('[data-rx-drive-sample="'+v+'"]').click();
 d()?.querySelector('[data-an-close]').click();
 for(let count=0;count<=8;count++)for(const raw of [0,1]){
  openArchitecture('rx');await wait();sample(0);for(let i=0;i<count;i++)sample((165>>>i)&1);
  const saved=165&((1<<count)-1),toggle=d().querySelector('[data-toggle="a"]');if((toggle.getAttribute('aria-pressed')==='true')!==!!raw)toggle.click();
  const cells=[...d().querySelectorAll('.an-scene [data-diagram-part="SR"] [data-storage-value]')];ok(cells.length===8&&cells.every(n=>+n.textContent===((saved>>>+n.dataset.storageValue)&1)),'all eight bits display saved byte');
  d().querySelector('[data-part="SR"]').dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await wait();
  const next=count<8?saved|(raw<<count):saved;
  ok(d().dataset.view==='register8'&&+d().querySelector('[data-coach-delta] b').textContent===saved,'whole saved byte inherited');
  ok(+d().querySelector('[data-field="av"]').value===next,'next sampling candidate');
  (d().querySelector('[data-experiment-action="tick"]')||d().querySelector('[data-tick]')).click();ok(+d().querySelector('[data-coach-delta] b').textContent===next,'independent register edge');
  d().querySelector('.an-context-path [data-context-id="rx"]').click();await wait();ok(+d().querySelector('[data-coach-delta] b').textContent===saved,'parent not advanced');d().querySelector('[data-an-close]').click();
 }
 return {status:'passed',checks,cases:18};
}
