async()=>{
 let checks=0;const ok=(v,m)=>{if(!v)throw Error(m);checks++};
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('pipeline32');await new Promise(r=>setTimeout(r,180));
 for(let i=0;i<4;i++)document.querySelector('[data-experiment-action="tick"]').click();
 const before=document.querySelector('.an-watch').textContent;
 document.querySelector('[data-pipe32-compare]').click();
 const cards=[...document.querySelectorAll('[data-pipe32-comparison-mode]')];ok(cards.length===3,'all three policies');
 ok(cards[0].textContent.includes('11 / 6'),'none cycles');ok(cards[1].textContent.includes('12 / 6'),'forward cycles');ok(cards[2].textContent.includes('19 / 6'),'stall cycles');
 ok(cards[0].textContent.includes('x2：0；前递策略为 10'),'register discrepancy');
 ok(cards[2].textContent.includes('终态一致'),'stall agreement');
 ok(document.querySelector('.an-watch').textContent===before,'live state preserved');
 const p=anatomyAssembleCPU32('loop: jal x0,loop'),snapshot=JSON.stringify(p),bounded=anatomyPipeline32Compare(p,{},12);
 ok(bounded.results.every(r=>r.cycles===12&&!r.complete&&!r.comparable),'infinite program bounded');
 ok(JSON.stringify(p)===snapshot,'program input unchanged');ok(anatomyPipeline32ComparisonMarkup(bounded).includes('暂不判定终态一致性'),'no premature equivalence');
 let threw=false;try{anatomyPipeline32Compare(p,{},0)}catch(e){threw=true}ok(threw,'invalid limit rejected');
 return {status:'passed',checks};
}
