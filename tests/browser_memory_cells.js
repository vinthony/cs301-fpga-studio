async()=>{
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('sram');await new Promise(r=>setTimeout(r,120));
 const wait=()=>new Promise(r=>setTimeout(r,25)),set=(k,v)=>{const e=document.querySelector('[data-field="'+k+'"]');e.value=v;e.dispatchEvent(new Event('change',{bubbles:true}))};
 for(let row=0;row<8;row++){set('addr',row);set('data',(row*37+5)&255);document.querySelector('[data-tick]').click()}
 let checks=0;
 for(let row=0;row<8;row++)for(let bit=0;bit<8;bit++){
  document.querySelector('[data-memory-cell="'+row+'"][data-memory-cell-bit="'+bit+'"]').click();await wait();
  const expected=(((row*37+5)&255)>>>bit)&1,note=document.querySelector('.an-transfer-note').textContent,tr=[...document.querySelectorAll('.an-watch tr')].find(x=>x.querySelector('th').textContent==='Q / QB');
  if(!note.includes('地址 '+row+' · bit'+bit)||tr.querySelector('td b').textContent!==expected+' / '+(1-expected))throw Error('cell '+row+':'+bit);
  if(!document.querySelector('[data-reread-parent]'))throw Error('reread');checks+=3;
  document.querySelector('[data-return-parent]').click();await wait();
 }
 return{status:'passed',cells:64,checks};
}
