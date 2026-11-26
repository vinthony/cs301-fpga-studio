async()=>{
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('input');await new Promise(r=>setTimeout(r,100));let checks=0;
 const expected=[1,1,0,2];
 for(let i=0;i<4;i++){
  document.querySelector('.an-input-stimulus').open=true;document.querySelector('[data-input-pattern-example="'+i+'"]').click();document.querySelector('[data-input-pattern-load]').click();const pattern=AN_INPUT_SCENARIOS[i][1];
  for(let j=0;j<pattern.length;j++)document.querySelector('[data-input-pattern-next]').click();
  if(Number(document.querySelector('[data-input-pattern-events]').textContent)!==expected[i])throw Error('events '+i);
  if(document.querySelector('[data-input-pattern-progress]').textContent!==pattern.length+'/'+pattern.length||!document.querySelector('[data-input-pattern-next]').disabled)throw Error('completion');
  if(!document.querySelector('.an-input-stimulus').open)throw Error('closed');checks+=3;
 }
 const before=document.querySelector('[data-input-pattern-progress]').textContent;document.querySelector('[data-input-pattern-draft]').value='0102';document.querySelector('[data-input-pattern-load]').click();
 if(!document.querySelector('[data-input-pattern-error]').textContent||document.querySelector('[data-input-pattern-progress]').textContent!==before)throw Error('invalid reset');checks+=2;
 document.querySelector('[data-observation-prev]').click();document.querySelector('[data-input-pattern-next]').dispatchEvent(new MouseEvent('click',{bubbles:true}));document.querySelector('[data-observation-live]').click();
 if(document.querySelector('[data-input-pattern-progress]').textContent!==before)throw Error('history progressed');checks++;
 return{status:'passed',checks};
}
