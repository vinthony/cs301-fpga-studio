async()=>{
 const wait=()=>new Promise(r=>setTimeout(r,200));let checks=0;
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('adder');await wait();
 for(let bit=0;bit<4;bit++){
  document.querySelector('.anatomy-dialog[open] [data-part="FA'+bit+'"]').dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await wait();
  const c=document.querySelector('.anatomy-dialog[open] .an-context'),highlight=c.querySelectorAll('[data-context-lens="adder"] [data-context-highlight]');
  if(highlight.length!==1||highlight[0].dataset.contextUnit!=='FA'+bit)throw Error('wrong highlight '+bit);
  if(c.querySelector('.an-context-parent').dataset.contextPart!=='FA'+bit)throw Error('wrong parent '+bit);
  if(!c.querySelector('.an-context-location').textContent.includes('FA'+bit))throw Error('label '+bit);
  checks+=3;document.querySelector('[data-return-parent]').click();await wait();
 }
 return {checks,status:'passed'};
}
