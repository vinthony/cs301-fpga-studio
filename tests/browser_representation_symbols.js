async()=>{
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('repr4');await new Promise(r=>setTimeout(r,120));let checks=0;
 for(let word=0;word<16;word++){
  const input=document.querySelector('[data-field="reprWord"]');input.value=word;input.dispatchEvent(new Event('change',{bubbles:true}));const r=anatomyRepresent4(word);
  for(const [id,key]of [['U','unsigned'],['SM','signMagnitude'],['OC','onesComplement'],['TC','twosComplement']]){
   const g=document.querySelector('.an-scene [data-diagram-part="'+id+'"]');if(g._reprResult.textContent!=='解释值：'+r[key])throw Error('value');
   const bits=[...g.querySelectorAll('[data-repr-input-bit]')].map(n=>n.querySelectorAll('text')[1].textContent).join('');if(bits!==word.toString(2).padStart(4,'0'))throw Error('bits');checks+=2;
  }
 }
 for(let bit=0;bit<4;bit++){
  const old=Number(document.querySelector('[data-field="reprWord"]').value),node=document.querySelector('.an-scene [data-diagram-part="TC"] [data-repr-input-bit="'+bit+'"]');node.dispatchEvent(new KeyboardEvent('keydown',{key:'Enter',bubbles:true}));
  if(Number(document.querySelector('[data-field="reprWord"]').value)!==(old^(1<<bit)))throw Error('keyboard bit');checks++;
 }
 return{status:'passed',checks};
}
