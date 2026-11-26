async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++};document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('compare');await new Promise(r=>setTimeout(r,80));const d=document.querySelector('.anatomy-dialog[open]');
 for(const [a,b]of [[0,0],[15,15],[5,10],[8,0],[7,15]]){
  const values={av:a,bv:b};for(const [key,value]of Object.entries(values)){const input=d.querySelector('[data-field="'+key+'"]');input.value=value;input.dispatchEvent(new Event('change',{bubbles:true}))}
  for(const key of ['av','bv'])for(let bit=0;bit<4;bit++)for(let repeat=0;repeat<2;repeat++){
   d.querySelector('[data-compare-bit="'+key+':'+bit+'"]').click();values[key]^=1<<bit;
   ok(Number(d.querySelector('[data-field="'+key+'"]').value)===values[key],'bit changes actual input');ok(d.querySelector('[data-compare-summary]').textContent.includes('EQ='+Number(values.av===values.bv)),'actual equality');
   for(let i=0;i<4;i++)ok(Number(d.querySelector('[data-compare-focus="X'+i+'"]').textContent)===(((values.av>>>i)&1)!==((values.bv>>>i)&1)?1:0),'actual per bit difference');
   ok(document.activeElement===d.querySelector('[data-compare-bit="'+key+':'+bit+'"]'),'focus preserved');
  }
 }
 const records=d.querySelector('[data-observation-range]').max;for(const button of d.querySelectorAll('[data-control-stage]')){button.click();ok(d.querySelector('.an-walk-caption').textContent.includes(button.textContent),'walk matches main caption')}
 ok(d.querySelector('[data-observation-range]').max===records,'walk no model update');return {status:'passed',bitFlips:80,checks};
}
