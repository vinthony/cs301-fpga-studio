async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},d=()=>document.querySelector('.anatomy-dialog[open]');
 for(let value=0;value<1024;value++){
  const s=anatomyState();s.timingX=value;s.timingY=1023-value;const doc=new DOMParser().parseFromString(anatomyTimingBitInputs(ANATOMY.visiblearea,s),'text/html');
  for(const [axis,n]of [['X',value],['Y',1023-value]]){const group=doc.querySelector('[data-timing-bit-axis="'+axis+'"]'),buttons=[...group.querySelectorAll('[data-timing-bit]')];ok(buttons.length===10,'ten real inputs');let sum=0;for(let i=0;i<10;i++){const bit=9-i,node=buttons[i],one=(n>>>bit)&1;ok(node.getAttribute('aria-pressed')===String(!!one)&&node.querySelector('b').textContent===String(one),'state and accessibility agree');ok(node.querySelector('small:last-child').textContent===String(2**bit),'weight');sum+=one*2**bit}ok(sum===n&&group.querySelector('[data-timing-weight-sum]').textContent.endsWith('= '+n),'weight sum')}
 }
 for(const id of ['hsync','vsync','visiblearea']){
  d()?.querySelector('[data-an-close]').click();openArchitecture(id);await new Promise(r=>setTimeout(r,200));const axes=id==='visiblearea'?['X','Y']:id==='vsync'?['Y']:['X'];
  for(const axis of axes){const key='timing'+axis,initial=+d().querySelector('[data-field="'+key+'"]').value;let expected=initial;for(let bit=0;bit<10;bit++){
   d().querySelector('[data-timing-bit="'+key+':'+bit+'"]').click();expected^=1<<bit;ok(+d().querySelector('[data-field="'+key+'"]').value===expected,'real bit updates numeric input');ok(document.activeElement.dataset.timingBit===key+':'+bit,'focus retained after redraw');const x=+d().querySelector('[data-field="timingX"]')?.value||0,y=+d().querySelector('[data-field="timingY"]')?.value||0,result=id==='hsync'?+(x<656||x>=752):id==='vsync'?+(y<490||y>=492):+(x<640&&y<480);ok(+d().querySelector('[data-timing-result] b').textContent===result,'output updates from bit input');}
   const active=document.activeElement;active.dispatchEvent(new KeyboardEvent('keydown',{key:'Home',bubbles:true,cancelable:true}));ok(document.activeElement.dataset.timingBit===key+':9','Home high bit');document.activeElement.dispatchEvent(new KeyboardEvent('keydown',{key:'ArrowRight',bubbles:true,cancelable:true}));ok(document.activeElement.dataset.timingBit===key+':8','right follows drawing order');ok(+d().querySelector('[data-field="'+key+'"]').value===expected,'focus movement preserves input');
  }
  d().querySelector('[data-observation-prev]').click();ok([...d().querySelectorAll('[data-timing-bit]')].every(b=>b.disabled),'history bits readonly');d().querySelector('[data-observation-live]').click();ok(d().querySelector('.an-timing-lens').scrollWidth<=d().querySelector('.an-timing-lens').clientWidth,'no bit panel overflow');
 }
 return {status:'passed',checks,allWords:1024};
}
