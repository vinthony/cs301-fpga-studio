async()=>{
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('lut');await new Promise(r=>setTimeout(r,100));let checks=0;
 for(let level=0;level<6;level++){
  document.querySelector('[data-lut-stage="'+level+'"]').click();await new Promise(r=>setTimeout(r,60));
  const note=document.querySelector('.an-transfer-note').textContent;if(!note.includes('第 '+(level+1)+' 级')||!document.querySelector('[data-reread-parent]'))throw Error('stage');checks+=2;
  const data=['a','b','cin'].map(k=>+(document.querySelector('[data-toggle="'+k+'"]').getAttribute('aria-pressed')==='true'));if((data[2]?data[1]:data[0])!==1)throw Error('value');checks++;
  document.querySelector('[data-return-parent]').click();await new Promise(r=>setTimeout(r,60));
 }
 document.querySelector('.an-lut-tree-lens').open=true;document.querySelector('[data-lut-address-bit="0"]').click();if(!document.querySelector('.an-lut-tree-lens').open)throw Error('open state');checks++;
 return{status:'passed',checks};
}
