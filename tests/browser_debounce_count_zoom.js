async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},wait=ms=>new Promise(r=>setTimeout(r,ms));
 document.querySelector('.an-count-zoom[open]')?.close();document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('debounce');await wait(80);const d=document.querySelector('.anatomy-dialog[open]');
 for(let sample=0;sample<4;sample++){
  d.querySelector('[data-count-condition="same"]').click();d.querySelector('[data-count-sample]').click();const panel=d.querySelector('.an-debounce-count-detail'),before=panel.querySelector('svg').getAttribute('aria-label'),records=d.querySelector('[data-observation-range]').max;
  panel.querySelector('[data-count-zoom]').click();const z=d.querySelector('.an-count-zoom');ok(z.open,'modal opened');ok(z.querySelector('svg').getAttribute('aria-label')===before,'same actual values');ok(z.textContent.includes('打开时现场快照'),'snapshot explicit');ok(!z.querySelector('[data-count-sample],[data-count-condition]'),'no inert simulation controls');
  ok(z.querySelector('#debounce-count-zoom-arrow')&&!z.querySelector('#debounce-count-arrow'),'unique arrow resource');
  for(const unit of z.querySelectorAll('[data-count-unit]')){unit.dispatchEvent(new KeyboardEvent('keydown',{key:' ',bubbles:true}));ok(z.querySelector('[data-count-unit-detail]').textContent===z.querySelector('[data-count-unit-description="'+unit.dataset.countUnit+'"]').textContent,'actual zoom unit source');}
  z.querySelector('[data-count-zoom-close]').click();await wait(10);ok(!z.isConnected,'removed on close');ok(document.activeElement===panel.querySelector('[data-count-zoom]'),'focus returns');ok(d.querySelector('[data-observation-range]').max===records,'inspection leaves model unchanged');
 }
 return {status:'passed',snapshots:4,checks};
}
