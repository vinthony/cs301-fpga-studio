async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},wait=ms=>new Promise(r=>setTimeout(r,ms));document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('debounce');await wait(80);const d=document.querySelector('.anatomy-dialog[open]');let count=0,candidate=0,stable=0,ticks=0;
 for(const same of [false,true,true,true,false,true,false,true,true]){
  const raw=same?candidate:1-candidate;d.querySelector('[data-count-condition="'+(same?'same':'different')+'"]').click();ok(Number(d.querySelector('[data-debounce-count]').textContent)===count,'prepare leaves saved count');
  const range=d.querySelector('[data-observation-range]'),records=range.max;
  for(const unit of d.querySelectorAll('[data-count-unit]')){unit.dispatchEvent(new MouseEvent('click',{bubbles:true}));ok(unit.getAttribute('aria-pressed')==='true','clicked unit selected');ok(d.querySelectorAll('[data-count-unit][aria-pressed="true"]').length===1,'one selected internal unit');ok(d.querySelector('[data-count-unit-detail]').textContent===d.querySelector('[data-count-unit-description="'+unit.dataset.countUnit+'"]').textContent,'actual current input output explanation');unit.dispatchEvent(new KeyboardEvent('keydown',{key:'Enter',bubbles:true}));ok(unit.getAttribute('aria-pressed')==='true','keyboard inspection');}
  ok(range.max===records,'inspection adds no sample or input record');
  const next=same?count+1:1,svg=d.querySelector('.an-debounce-count-detail svg');ok(svg.getAttribute('aria-label').includes('下一次数'+next),'actual candidate before edge');ok(svg.getAttribute('aria-label').includes('阈值条件'+Number(next>=3)),'threshold from candidate');
  d.querySelector('[data-count-sample]').click();ticks++;count=next;candidate=raw;if(count>=3)stable=raw;
  ok(Number(d.querySelector('[data-debounce-count]').textContent)===count,'single actual sample saves count');ok(Number(d.querySelector('[data-debounce-stable]').textContent)===stable,'same parent stable result');ok(d.querySelector('.an-debounce-count-detail').open,'detail stays open');
 }
 ok(ticks===9,'nine explicit samples');return {status:'passed',samples:ticks,checks};
}
