async()=>{
let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++};
for(const b of Object.values(ANATOMY)){const s=anatomyState(),e=anatomyEvaluate(b.id,s),doc=new DOMParser().parseFromString(anatomyExperimentReport({blueprint:b,state:s,evaluation:e,path:[b.id]}),'text/html');ok(doc.body.textContent.includes(b.title),'title '+b.id);ok(!doc.querySelector('script,link[rel="stylesheet"],img,iframe'),'no external runtime '+b.id);ok(JSON.parse(doc.querySelector('pre').textContent).view===b.id,'state attachment '+b.id)}
const d=()=>document.querySelector('.anatomy-dialog[open]');d()?.querySelector('[data-an-close]').click();openArchitecture('register8');await new Promise(r=>setTimeout(r,200));d().querySelector('[data-reg8-scenario="capture"]').click();d().querySelector('[data-experiment-action="tick"]').click();
const original=URL.createObjectURL,click=HTMLAnchorElement.prototype.click;let blob;URL.createObjectURL=b=>{blob=b;return original(b)};HTMLAnchorElement.prototype.click=function(){};
try{
 d().querySelector('[data-export-report]').click();let doc=new DOMParser().parseFromString(await blob.text(),'text/html'),data=JSON.parse(doc.querySelector('pre').textContent);ok(data.state.reg8Q===165&&!data.historical,'live state');ok(doc.querySelectorAll('svg').length===2,'embedded diagram and position');ok(doc.querySelector('svg rect')?.getAttribute('style').includes('fill:'),'embedded computed styles');
 d().querySelector('[data-observation-prev]').click();d().querySelector('[data-export-report]').click();doc=new DOMParser().parseFromString(await blob.text(),'text/html');data=JSON.parse(doc.querySelector('pre').textContent);ok(data.historical&&data.state.reg8Q===0,'historical saved value excludes future');d().querySelector('[data-observation-live]').click();ok(d().querySelector('[data-register-q]').textContent==='10100101','export leaves live model unchanged');
 const s=anatomyState();s.fifoText.draft='</pre><script>danger()</script>';doc=new DOMParser().parseFromString(anatomyExperimentReport({blueprint:ANATOMY.fifo,state:s,evaluation:anatomyEvaluate('fifo',s),path:['fifo']}),'text/html');ok(!doc.querySelector('script')&&doc.querySelector('pre').textContent.includes('<script>'),'text remains escaped');
}finally{URL.createObjectURL=original;HTMLAnchorElement.prototype.click=click}
return {status:'passed',views:Object.keys(ANATOMY).length,checks};
}
