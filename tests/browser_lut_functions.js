async()=>{
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('lut');await new Promise(r=>setTimeout(r,120));let checks=0;
 for(const [name]of AN_LUT_PRESETS){
  document.querySelector('[data-lut-function="'+name+'"]').click();
  for(let address=0;address<64;address++){
   const input=document.querySelector('[data-field="lutAddr"]');input.value=address;input.dispatchEvent(new Event('change',{bubbles:true}));
   const bits=address.toString(2).padStart(6,'0').split('').map(Number),a=bits[5],b=bits[4],sel=bits[3],expected=name==='and2'?a*b:name==='or2'?+(a+b>0):name==='xor2'?(a+b)%2:name==='and6'?+bits.every(Boolean):name==='parity6'?bits.reduce((x,y)=>x+y,0)%2:sel?b:a;
   if(document.querySelector('[data-lut-output]').textContent!=='O6='+expected)throw Error(name+' '+address);checks++;
  }
 }
 for(let i=0;i<6;i++){
  const before=Number(document.querySelector('[data-lut-address]').textContent);document.querySelector('[data-lut-address-bit="'+i+'"]').click();
  if(Number(document.querySelector('[data-lut-address]').textContent)!==(before^(1<<i)))throw Error('input');checks++;
 }
 const before=document.querySelector('[data-lut-output]').textContent;document.querySelector('[data-lut-selected-toggle]').click();if(document.querySelector('[data-lut-output]').textContent===before)throw Error('edit');checks++;
 document.querySelector('[data-lut-open-cell]').click();await new Promise(r=>setTimeout(r,100));if(!document.querySelector('.an-transfer-note').textContent.includes('INIT['))throw Error('cell');checks++;
 return{status:'passed',checks};
}
