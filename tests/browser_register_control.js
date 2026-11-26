async()=>{
let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},wait=()=>new Promise(r=>setTimeout(r,150)),dialog=()=>document.querySelector('.anatomy-dialog[open]');
for(let a=0;a<2;a++)for(let b=0;b<2;b++)for(let enable=0;enable<2;enable++)for(let reset=0;reset<2;reset++){
 const s=Object.assign(anatomyState(),{a,b,enable,reset}),e=anatomyEvaluate('registerControl',s),expected=reset?0:enable?a:b;
 ok(e.result===expected,'truth result');ok(e.nets['CE后候选']===(enable?a:b),'CE candidate');ok(e.nets['最终候选']===expected,'final net');
}
dialog()?.querySelector('[data-an-close]').click();openArchitecture('register8');await wait();
for(let bit=0;bit<8;bit++){
 dialog().querySelector('[data-part="C'+bit+'"]').dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await wait();
 ok(dialog().querySelector('.an-context-parent').dataset.contextPart==='C'+bit,'specific control bit');
 for(const part of ['EN','RESET']){
 dialog().querySelector('[data-part="'+part+'"]').dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await wait();
 ok(dialog().querySelector('[data-context-current]').dataset.contextCurrent==='mux','enter mux');
 ok(dialog().querySelector('.an-context-parent').dataset.contextPart===part,'specific selection stage');
 dialog().querySelector('[data-return-parent]').click();await wait();
 }
 dialog().querySelector('[data-return-parent]').click();await wait();
}
return {status:'passed',checks};
}
