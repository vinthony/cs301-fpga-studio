async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},d=()=>document.querySelector('.anatomy-dialog[open]'),wait=()=>new Promise(r=>setTimeout(r,60)),out=()=>+d().querySelector('[data-coach-delta] b').textContent;
 for(let a=0;a<32;a++)for(let b=0;b<32;b++)for(const valid of [0,1]){const s=Object.assign(anatomyState(),{av:a,bv:b,enable:valid}),e=anatomyEvaluate('cachecheck',s);ok(e.result===+(a===b&&valid===1)&&e.nets['标签相等']===+(a===b)&&e.nets['行有效']===valid,'all five-bit comparisons and valid');}
 d()?.querySelector('[data-an-close]').click();
 for(const address of [0,8,127,128,248,255]){
  openArchitecture('cache');await wait();const f=d().querySelector('[data-field="addr"]');f.value=address;f.dispatchEvent(new Event('change',{bubbles:true}));
  d().querySelector('[data-part="CHECK"]').dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await wait();ok(d().dataset.view==='cachecheck'&&+d().querySelector('[data-field="av"]').value===(address>>>3)&&out()===0,'unfilled cache source and valid');
  d().querySelector('.an-context-path [data-context-id="cache"]').click();await wait();d().querySelector('[data-tick]').click();
  d().querySelector('[data-part="CHECK"]').dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await wait();ok(out()===1&&+d().querySelector('[data-field="bv"]').value===(address>>>3),'filled full tag source');
  d().querySelector('[data-part="AND"]').dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await wait();ok(out()===1,'AND receives equality and valid');d().querySelector('.an-context-path [data-context-id="cachecheck"]').click();await wait();
  d().querySelector('[data-part="EQ"]').dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await wait();ok(d().dataset.view==='tageq5'&&+d().querySelector('[data-field="av"]').value===(address>>>3)&&out()===1&&d().querySelector('.an-transfer-note').textContent.includes('VALID仍由上级'),'exact five-bit gate equality output');d().querySelector('[data-an-close]').click();
 }
 openArchitecture('cache');await wait();let field=d().querySelector('[data-field="addr"]');field.value=0;field.dispatchEvent(new Event('change',{bubbles:true}));d().querySelector('[data-tick]').click();field=d().querySelector('[data-field="addr"]');field.value=128;field.dispatchEvent(new Event('change',{bubbles:true}));d().querySelector('[data-part="CHECK"]').dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await wait();ok(out()===0&&+d().querySelector('[data-field="av"]').value===16&&+d().querySelector('[data-field="bv"]').value===0,'bit4 difference not truncated');
 return {status:'passed',checks,pairsWithValid:2048};
}
