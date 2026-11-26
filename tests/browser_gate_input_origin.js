async()=>{
let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},wait=()=>new Promise(r=>setTimeout(r,160)),d=()=>document.querySelector('.anatomy-dialog[open]');
for(let k=0;k<8;k++){
 const a=k>>2,b=(k>>1)&1,c=k&1,s=Object.assign(anatomyState(),{a,b,cin:c}),expected={X1:[a,b],X2:[a^b,c],G1:[a,b],G2:[a^b,c],O:[a&b,(a^b)&c]};
 for(const [part,values]of Object.entries(expected)){
  const doc=new DOMParser().parseFromString(anatomyGateInputOrigin(ANATOMY.fulladder,part,s,{a:values[0],b:values[1]}),'text/html');
  for(let i=0;i<2;i++)ok(Number(doc.querySelector(`[data-origin-input="${i?'b':'a'}"]`).dataset.originValue)===values[i],'parent input '+k+part+i);
 }
}
d()?.querySelector('[data-an-close]').click();openArchitecture('fulladder');await wait();d().querySelector('[data-truth-row="7"]').click();
for(const part of ['X1','X2','G1','G2','O']){
 d().querySelector(`[data-part="${part}"]`).dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await wait();
 const row=()=>d().querySelector('[data-origin-input="a"]'),v=Number(row().dataset.originValue);
 ok(Number(row().dataset.localValue)===v,'copied '+part);
 d().querySelector('[data-toggle="a"]').click();ok(Number(row().dataset.localValue)===1-v,'local change '+part);ok(Number(row().dataset.originValue)===v,'parent remains '+part);
 ok(row().textContent.includes('本层已改变'),'difference explicit '+part);
 d().querySelector('[data-reread-parent]').click();await wait();ok(Number(row().dataset.localValue)===v,'reread restores '+part);
 d().querySelector('[data-return-parent]').click();await wait();ok(d().querySelector('[data-truth-row="7"]').getAttribute('aria-pressed')==='true','parent preserved '+part);
}
return {status:'passed',cases:40,checks};
}
