async()=>{
let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},wait=ms=>new Promise(r=>setTimeout(r,ms));ok(innerWidth<=850,'requires actual narrow viewport');
for(const id of Object.keys(ANATOMY)){
 document.querySelector('[data-an-close]')?.click();openArchitecture(id);await wait(25);const d=document.querySelector('.anatomy-dialog[open]'),context=d.querySelector('.an-main>.an-context'),content=d.querySelector('.anatomy-content');
 ok(!!context,'visible location parent '+id);ok(context.getBoundingClientRect().height>0,'location rendered '+id);ok(context.getBoundingClientRect().bottom<=content.getBoundingClientRect().bottom,'location in initial viewport '+id);
 for(const selector of ['.anatomy-content','.an-sidebar','.an-main','.an-lab-controls']){const n=d.querySelector(selector);ok(n.scrollWidth<=n.clientWidth+3,'no horizontal overflow '+id+selector)}
}
document.querySelector('[data-an-close]').click();openArchitecture('fulladder');await wait(150);document.querySelector('[data-header-context]').click();ok(!!document.querySelector('.an-context-zoom[open]'),'full position still opens');document.querySelector('[data-close-context]').click();
return {status:'passed',width:innerWidth,views:Object.keys(ANATOMY).length,checks};
}
