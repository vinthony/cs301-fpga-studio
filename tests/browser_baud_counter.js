async()=>{
 let checks=0;const ok=(v,m)=>{if(!v)throw Error(m);checks++};
 for(const baud of [9600,115200]){
  const divisor=Math.round(1e8/baud);
  for(const start of [0,1,divisor-2,divisor-1,divisor*3+13])for(const action of ['terminal','batch32','period']){
   const fast=anatomyState(),slow=anatomyState();fast.baud=slow.baud=baud;fast.ticks=slow.ticks=start;
   const distance=action==='batch32'?32:action==='period'?divisor:((divisor-1-start%divisor)||divisor);
   anatomyAdvance('baud',fast,action);for(let i=0;i<distance;i++)anatomyAdvance('baud',slow);
   ok(fast.ticks===slow.ticks,'fast exact clocks '+baud+' '+start+' '+action);ok(anatomyEvaluate('baud',fast).result===anatomyEvaluate('baud',slow).result,'fast terminal candidate');
  }
 }
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('baud');await new Promise(r=>setTimeout(r,180));
 const action=k=>document.querySelector('[data-experiment-action="'+k+'"]').click(),progress=()=>document.querySelector('[role="progressbar"]'),decision=()=>document.querySelector('[data-baud-decision]').textContent;
 ok(progress().getAttribute('aria-valuenow')==='0','initial counter');action('terminal');ok(progress().getAttribute('aria-valuenow')==='867','115200 terminal');ok(decision().includes('下一主时钟边沿可消费使能'),'candidate semantics');action('tick');ok(progress().getAttribute('aria-valuenow')==='0','wrap to zero');action('batch32');ok(progress().getAttribute('aria-valuenow')==='32','batch32');
 const select=document.querySelector('[data-field="baud"]');select.value='9600';select.dispatchEvent(new Event('change',{bubbles:true}));ok(progress().getAttribute('aria-valuenow')==='0','retarget resets');action('terminal');ok(progress().getAttribute('aria-valuenow')==='10416','9600 terminal');
 const count=progress().getAttribute('aria-valuenow');action('period');ok(progress().getAttribute('aria-valuenow')===count,'one whole period same phase');
 document.querySelector('.an-baud-lens').scrollIntoView({block:'center'});return {status:'passed',checks};
}
