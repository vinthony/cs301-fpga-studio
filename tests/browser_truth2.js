async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},d=()=>document.querySelector('.anatomy-dialog[open]');d()?.querySelector('[data-an-close]').click();openArchitecture('truth2');
 for(let mask=0;mask<16;mask++){
  const field=d().querySelector('[data-field="truthMask"]')||d().querySelector('[name="truthMask"]');
  if(!field)throw Error('missing numeric input');field.value=mask;field.dispatchEvent(new Event('change',{bubbles:true}));
  for(let row=0;row<4;row++){
   d().querySelector('[data-truth-case="'+row+'"]').click();const s=Object.assign(anatomyState(),{truthMask:mask,a:row>>>1,b:row&1}),p=anatomyTruth2Plan(s),e=anatomyEvaluate('truth2',s),expected=(mask>>>row)&1;
   ok(e.result===expected&&p.output===expected,'output '+mask+'/'+row);
   ok(d().querySelector('[data-truth-result]').textContent.endsWith('Y='+expected),'UI output');
   const simplified=p.groups.some(g=>(g.a==='-'||Number(g.a)===s.a)&&(g.b==='-'||Number(g.b)===s.b));ok(+simplified===expected,'simplification');
   for(let i=0;i<4;i++){ok(e.nets['最小项'+i]===+(row===i),'one hot');ok(e.nets['配置位'+i]===((mask>>>i)&1),'config');ok(e.nets['启用支路'+i]===+(row===i&&!!(mask&(1<<i))),'gated term')}
  }
 }
 d().querySelector('[data-truth-preset="6"]').click();d().querySelector('[data-truth-bit="0"]').click();ok(d().querySelector('[data-truth-bit="0"]').textContent==='1','edit truth row');
 d().querySelector('[data-observation-prev]').click();const before=d().querySelector('[data-truth-result]').textContent;d().querySelector('[data-truth-preset="0"]').click();ok(d().querySelector('[data-truth-result]').textContent===before,'history protects');d().querySelector('[data-observation-live]').click();
 return {status:'passed',checks,functions:16,inputCases:64};
}
