async()=>{
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('adder');await new Promise(r=>setTimeout(r,200));let checks=0;
 const check=(a,b)=>{
  for(const key of ['av','bv'])if(Number(document.querySelector('[data-field="'+key+'"]').value)!==(key==='av'?a:b))throw Error('field');
  if(Number(document.querySelector('[data-adder-total]').textContent)!==a+b)throw Error('total');
  const bits=[...document.querySelectorAll('[data-adder-sum-bit]')].map(x=>x.textContent).join('');if(bits!==(a+b).toString(2).padStart(5,'0'))throw Error('bits');checks+=4;
 };
 for(let i=0;i<AN_ADDER_SCENARIOS.length;i++){document.querySelector('[data-adder-scenario="'+i+'"]').click();check(AN_ADDER_SCENARIOS[i][0],AN_ADDER_SCENARIOS[i][1])}
 for(const k of ['av','bv'])for(let bit=0;bit<4;bit++){
  const a=Number(document.querySelector('[data-field="av"]').value),b=Number(document.querySelector('[data-field="bv"]').value);
  document.querySelector('[data-adder-operand="'+k+'"][data-adder-bit="'+bit+'"]').click();check(k==='av'?a^(1<<bit):a,k==='bv'?b^(1<<bit):b);
 }
 return {status:'passed',checks};
}
