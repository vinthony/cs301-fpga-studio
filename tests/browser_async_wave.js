async()=>{
 let checks=0;const ok=(v,m)=>{if(!v)throw Error(m);checks++};
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('asyncrx');await new Promise(r=>setTimeout(r,180));
 ok(document.querySelector('.an-async-wave').hidden,'no unexecuted trace');
 const load=k=>document.querySelector('[data-async-example="'+k+'"]').click(),finish=()=>document.querySelector('[data-experiment-action="finish"]').click();
 load('good');finish();ok(document.querySelectorAll('[data-async-wave-center]').length===10,'START eight data STOP centers');
 document.querySelector('[data-async-wave-center][aria-label*="d5"]').dispatchEvent(new MouseEvent('click',{bubbles:true}));ok(document.querySelector('[data-async-wave-detail]').textContent.includes('发送激励的 d5'),'aligned receiver d5 reads transmitter d5');
 load('fast');finish();const before=document.querySelector('.an-watch').textContent,max=document.querySelector('[data-observation-range]').max;
 const center=document.querySelector('[data-async-wave-center][aria-label*="d5"]');center.dispatchEvent(new KeyboardEvent('keydown',{key:'Enter',bubbles:true}));
 const detail=document.querySelector('[data-async-wave-detail]').textContent;ok(detail.includes('采样 63')&&detail.includes('d5=1')&&detail.includes('发送激励的 d6'),'mismatch explained by true source provenance');
 ok(document.querySelector('.an-watch').textContent===before&&document.querySelector('[data-observation-range]').max===max,'inspection no mutation');
 ok(document.querySelectorAll('[data-async-wave-center][aria-pressed="true"]').length===1,'single selected center');
 const svg=document.querySelector('.an-async-wave svg');ok(svg.getAttribute('preserveAspectRatio')==='xMidYMid meet'&&Number(svg.getAttribute('width'))>600,'fixed sampling geometry');ok(!/NaN|Infinity|undefined/.test(svg.outerHTML),'valid waveform');
 document.querySelector('[data-observation-prev]').click();ok(document.querySelector('.an-async-wave').hidden&&document.querySelectorAll('[data-async-wave-center]').length===0,'history removes future trace');document.querySelector('[data-observation-live]').click();ok(document.querySelectorAll('[data-async-wave-center]').length===10,'live trace restored');
 load('glitch');finish();ok(document.querySelector('[data-async-wave-center][aria-label*="REJECT"]'),'short pulse rejection center visible');
 document.querySelector('.an-async-wave').scrollIntoView({block:'center'});return {status:'passed',checks};
}
