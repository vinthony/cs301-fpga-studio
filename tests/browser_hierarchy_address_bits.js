async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},d=()=>document.querySelector('.anatomy-dialog[open]');d()?.querySelector('[data-an-close]').click();openArchitecture('memorySystem');await new Promise(r=>setTimeout(r,100));
 d().querySelector('[data-experiment-action="access"]').click();
 const cache=[...d().querySelectorAll('[data-hierarchy-line]')].map(n=>n.textContent).join('|');
 for(let address=0;address<16;address++)for(let bit=0;bit<4;bit++){
  const input=d().querySelector('[data-field="addr"]');input.value=address;input.dispatchEvent(new Event('change',{bubbles:true}));d().querySelector('[data-hierarchy-bit="'+bit+'"]').click();const expected=address^(1<<bit);
  ok(+d().querySelector('[data-field="addr"]').value===expected,'bit changes request address');
  ok([...d().querySelectorAll('[data-hierarchy-bit]')].every(n=>+n.querySelector('b').textContent===((expected>>>+n.dataset.hierarchyBit)&1)),'all four bits match');
  ok(d().querySelector('[data-hierarchy-address-explain]').textContent.includes('TAG '+(expected>>>3)+' × 8 + INDEX '+((expected>>>1)&3)+' × 2 + OFFSET '+(expected&1)),'field decomposition');
  ok([...d().querySelectorAll('[data-hierarchy-line]')].map(n=>n.textContent).join('|')===cache&&d().querySelector('[data-memory-read-result]').textContent.includes('地址 0 → 0'),'no implicit refill or read');
  ok(document.activeElement===d().querySelector('[data-hierarchy-bit="'+bit+'"]'),'focus stays on bit');
 }
 const range=d().querySelector('[data-observation-range]');range.value=0;range.dispatchEvent(new Event('input',{bubbles:true}));const before=d().querySelector('[data-field="addr"]').value;d().querySelector('[data-hierarchy-bit="0"]').click();ok(d().querySelector('[data-field="addr"]').value===before,'history protects request');d().querySelector('[data-observation-live]').click();
 return {status:'passed',checks,bitTransitions:64};
}
