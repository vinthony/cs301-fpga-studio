async()=>{
let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},wait=()=>new Promise(r=>setTimeout(r,180)),d=()=>document.querySelector('.anatomy-dialog[open]');
d()?.querySelector('[data-an-close]').click();openArchitecture('registerControl');await wait();
for(let k=0;k<16;k++){
 d().querySelector('[data-control-case="'+k+'"]').click();
 const rst=k>>3,en=(k>>2)&1,a=(k>>1)&1,b=k&1,out=rst?0:en?a:b;
 ok(d().querySelectorAll('[data-control-case][aria-pressed="true"]').length===1,'unique current row');
 ok(d().querySelector('[data-control-case][aria-pressed="true"]').dataset.controlCase===String(k),'exact current condition');
 for(const [field,value] of [['a',a],['b',b],['enable',en],['reset',rst]])ok(d().querySelector('[data-toggle="'+field+'"]').getAttribute('aria-pressed')===String(!!value),'linked control '+field);
 ok(d().querySelector('[data-control-stage="OUT"]').textContent.includes('待采样D='+out),'linked result');
 ok(d().querySelector('.an-live-output')?.textContent.includes(String(out))||d().querySelector('.an-control-lens>p[role="status"]').textContent.includes('候选 '+out),'result text');
}
for(const part of ['EN','RESET','OUT']){d().querySelector('[data-control-stage="'+part+'"]').click();ok(d().querySelector('[data-diagram-part="'+part+'"]').classList.contains('selected')||d().querySelector('.an-inspector').textContent.includes(part),'stage inspection '+part);}
return {status:'passed',checks};
}
