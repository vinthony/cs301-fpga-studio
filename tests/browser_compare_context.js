async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},wait=ms=>new Promise(r=>setTimeout(r,ms)),d=()=>document.querySelector('.anatomy-dialog[open]');
 const chain=anatomyContextPath('compare');ok(chain.at(-2)==='logic','standalone comparator belongs to general logic');ok(!chain.includes('regulator'),'not arbitrary first reuse');ok(anatomyContextPath('decoder').at(-2)==='logic','generic decoder not arbitrarily SRAM');ok(anatomyContextPath('decoder',['sram','decoder']).slice(-2).join('/')==='sram/decoder','explicit SRAM decoder context retained');
 d()?.querySelector('[data-an-close]').click();openArchitecture('compare');await wait(60);ok(d().querySelector('.an-context-location').textContent.includes('关联')||d().querySelector('.an-context-preview-label').textContent.includes('关联'),'functional relation explicit');
 d().querySelector('[data-an-close]').click();openArchitecture('debounce');await wait(60);d().querySelector('[data-part="CMP"]').dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await wait(60);
 ok(d().querySelector('.an-context-parent').dataset.contextParent==='debounce','actual entered parent');ok(d().querySelector('.an-context-parent').dataset.contextPart==='CMP','exact reused comparator');ok(d().querySelector('[data-context-lens="debounce"] [data-context-highlight]').dataset.contextUnit==='CMP','parent preview marks comparator');
 for(let bit=0;bit<4;bit++){
  d().querySelector('[data-part="X'+bit+'"]').dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await wait(60);
  const c=d().querySelector('.an-context'),marked=c.querySelectorAll('[data-context-lens="compare"] [data-context-highlight]');ok(marked.length===1&&marked[0].dataset.contextUnit==='X'+bit,'exact bit XOR instance');ok(c.querySelector('.an-context-parent').dataset.contextPart==='X'+bit,'actual parent origin');ok(c.querySelector('[data-context-lens="debounce"] [data-context-highlight]').dataset.contextUnit==='CMP','grandparent origin retained');
  d().querySelector('[data-return-parent]').click();await wait(60);ok(d().dataset.view==='compare','return preserves comparator context');
 }
 return {status:'passed',bits:4,checks};
}
