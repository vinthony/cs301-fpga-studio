async()=>{
 let checks=0;const ok=(v,m)=>{if(!v)throw Error(m);checks++},wait=()=>new Promise(r=>setTimeout(r,180));
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('baud');await wait();ok(document.querySelector('.an-baud-wave').hidden,'not prepared hides trace');
 const act=k=>document.querySelector('[data-experiment-action="'+k+'"]').click();act('prepare');ok(!document.querySelector('.an-baud-wave').hidden,'prepare shows trace');ok(document.querySelectorAll('[data-baud-wave-event]').length===0,'no invented future events');act('terminal');ok(document.querySelectorAll('[data-baud-wave-event]').length===0,'terminal candidate not recorded as consumed');act('tick');ok(document.querySelectorAll('[data-baud-wave-event]').length===1,'first actual enable');
 for(let i=0;i<10;i++)act('period');ok(document.querySelectorAll('[data-baud-wave-event]').length===11,'whole frame actual records');
 const before=document.querySelector('.an-watch').textContent,max=document.querySelector('[data-observation-range]').max;
 document.querySelector('[data-baud-wave-event="0"]').dispatchEvent(new KeyboardEvent('keydown',{key:'Enter',bubbles:true}));ok(document.querySelector('[data-baud-wave-detail]').textContent.includes('868 · 虚拟 8.680 μs → START，TX=0'),'keyboard details exact time');ok(document.querySelector('.an-watch').textContent===before&&document.querySelector('[data-observation-range]').max===max,'inspection readonly');
 document.querySelector('[data-observation-prev]').click();ok(document.querySelectorAll('[data-baud-wave-event]').length===10,'history does not borrow future events');document.querySelector('[data-observation-live]').click();ok(document.querySelectorAll('[data-baud-wave-event]').length===11,'current restored');
 const svg=document.querySelector('.an-baud-wave svg');ok(svg.getAttribute('width')==='720'&&svg.getAttribute('preserveAspectRatio')==='xMidYMid meet','fixed geometry no text stretching');ok(!/NaN|Infinity|undefined/.test(svg.outerHTML),'valid path coordinates');
 document.querySelector('.an-baud-wave').scrollIntoView({block:'center'});return {status:'passed',checks};
}
