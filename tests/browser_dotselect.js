async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},d=()=>document.querySelector('.anatomy-dialog[open]'),wait=()=>new Promise(r=>setTimeout(r,25)),out=()=>+d().querySelector('[data-coach-delta] b').textContent;
 d()?.querySelector('[data-an-close]').click();openArchitecture('dotselect');await wait();
 for(let mask=0;mask<16;mask++)for(let digit=0;digit<4;digit++){
  for(const [key,value] of [['av',mask],['bv',digit]]){const f=d().querySelector('[data-field="'+key+'"]');f.value=value;f.dispatchEvent(new Event('change',{bubbles:true}))}
  ok(out()===1-((mask>>>digit)&1),'actual four to one output');
  for(const part of ['M0','M1','M2','INV']){
   d().querySelector('[data-part="'+part+'"]').dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await wait();
   const expected=part==='M0'?(mask>>>(digit&1))&1:part==='M1'?(mask>>>(2+(digit&1)))&1:part==='M2'?(mask>>>digit)&1:1-((mask>>>digit)&1);
   ok(out()===expected,'child source '+part);
   d().querySelector('.an-context-path [data-context-id="dotselect"]').click();await wait();
  }
 }
 return {status:'passed',checks,cases:64};
}
