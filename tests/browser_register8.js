async()=>{
const wait=()=>new Promise(r=>setTimeout(r,180)),d=()=>document.querySelector('.anatomy-dialog[open]');let checks=0;
function ok(v,n){if(!v)throw Error(n);checks++}
function click(s){d().querySelector(s).dispatchEvent(new MouseEvent('click',{bubbles:true}))}
d()?.querySelector('[data-an-close]').click();openArchitecture('register8');await wait();
ok(d().querySelectorAll('[data-register-cell]').length===8,'8 cells');
for(const [id,expected] of [['capture','10100101'],['hold','10100101'],['clear','00000000']]){
const before=d().querySelector('[data-register-q]').textContent;
click('[data-reg8-scenario="'+id+'"]');ok(d().querySelector('[data-register-q]').textContent===before,'scenario must not clock');
click('[data-experiment-action="tick"]');ok(d().querySelector('[data-register-q]').textContent===expected,id+' result');
ok(d().querySelectorAll('.an-reg8-transition span').length===8,'all transitions');
}
click('[data-reg8-scenario="capture"]');click('[data-experiment-action="tick"]');
for(let i=0;i<8;i++){
click('[data-register-cell="'+i+'"]');await wait();ok(d().querySelector('.an-context-parent').dataset.contextPart==='F'+i,'exact bit '+i);
ok(d().querySelector('[data-toggle="a"]').textContent.includes(String((165>>>i)&1)),'effective D bit '+i);
click('[data-return-parent]');await wait();ok(d().querySelector('[data-register-q]').textContent==='10100101','parent remains');
}
return {status:'passed',checks};
}
