async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++};
 for(let count=0;count<20;count++)for(let a=0;a<2;a++)for(let candidate=0;candidate<2;candidate++){
  const s=anatomyState();Object.assign(s,{a,candidate,consecutive:count});const next=a===candidate?count+1:1,doc=new DOMParser().parseFromString(anatomyDebounceCountReport(s),'text/html');
  ok(doc.querySelector('svg').getAttribute('aria-label').includes('下一次数'+next),'candidate from snapshot');ok(!doc.querySelector('button,script,[tabindex],[role="button"],[data-count-unit]'),'readonly diagram');ok(doc.querySelectorAll('tbody tr').length===5,'all five units');ok(doc.body.textContent.includes('当前输出='+count),'saved count distinct');
 }
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('debounce');await new Promise(r=>setTimeout(r,100));const d=document.querySelector('.anatomy-dialog[open]');
 for(let i=0;i<3;i++){d.querySelector('[data-count-condition="same"]').click();d.querySelector('[data-count-sample]').click()}
 const original=URL.createObjectURL,click=HTMLAnchorElement.prototype.click;let blob;URL.createObjectURL=b=>{blob=b;return original(b)};HTMLAnchorElement.prototype.click=function(){};
 try{
  for(const historical of [false,true]){
   if(historical)d.querySelector('[data-observation-prev]').click();d.querySelector('[data-export-report]').click();const doc=new DOMParser().parseFromString(await blob.text(),'text/html'),data=JSON.parse(doc.querySelector('pre').textContent),count=data.state.consecutive;
   ok(data.historical===historical,'correct snapshot origin');ok(count===(historical?2:3),'actual exported count');ok(doc.querySelector('[data-report-count] svg').getAttribute('aria-label').includes('保存次数'+count),'internal diagram matches exported state');ok(doc.querySelector('[data-report-count]').textContent.includes('当前输出='+count),'unit table matches snapshot');
  }
  d.querySelector('[data-observation-live]').click();ok(Number(d.querySelector('[data-debounce-count]').textContent)===3,'history export leaves live state');
 }finally{URL.createObjectURL=original;HTMLAnchorElement.prototype.click=click}
 return {status:'passed',states:80,exports:2,checks};
}
