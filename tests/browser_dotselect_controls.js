async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},d=()=>document.querySelector('.anatomy-dialog[open]');
 d()?.querySelector('[data-an-close]').click();openArchitecture('dotselect');await new Promise(r=>setTimeout(r,100));
 for(let mask=0;mask<16;mask++)for(let digit=0;digit<4;digit++){
  for(let bit=0;bit<4;bit++){const button=d().querySelector('[data-dotselect-bit="'+bit+'"]');if((button.getAttribute('aria-pressed')==='true')!==!!(mask&(1<<bit)))button.click()}
  d().querySelector('[data-dotselect-digit="'+digit+'"]').click();
  ok(+d().querySelector('[data-field="av"]').value===mask&&+d().querySelector('[data-field="bv"]').value===digit,'visual controls update model');
  ok(+d().querySelector('[data-coach-delta] b').textContent===1-((mask>>>digit)&1),'visual controls recompute output');
  ok(d().querySelector('[data-dotselect-route]').textContent.includes('M'+(digit>>>1))&&d().querySelector('[data-dotselect-explanation]').textContent.includes('AN'+digit+' 请求='+((mask>>>digit)&1)),'selected route and explanation');
  ok(document.activeElement===d().querySelector('[data-dotselect-digit="'+digit+'"]'),'focus preserved after render');
 }
 const range=d().querySelector('[data-observation-range]');range.value=0;range.dispatchEvent(new Event('input',{bubbles:true}));
 const before=d().querySelector('[data-dotselect-explanation]').textContent;d().querySelector('[data-dotselect-bit="0"]').click();ok(d().querySelector('[data-dotselect-explanation]').textContent===before,'history blocks input');
 d().querySelector('[data-observation-live]').click();
 return {status:'passed',checks,cases:64};
}
