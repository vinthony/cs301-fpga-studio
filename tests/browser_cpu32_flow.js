async()=>{
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('cpu32');await new Promise(r=>setTimeout(r,120));
 const old=document.querySelector('.cpu32-program-status').textContent;let checks=0;
 for(let i=0;i<6;i++){
  document.querySelector('[data-cpu32-flow="'+i+'"]').click();
  if(document.querySelector('[data-cpu32-flow][aria-current="step"]').dataset.cpu32Flow!==String(i))throw Error('stage');
  if(document.querySelector('.cpu32-program-status').textContent!==old)throw Error('mutated');checks+=2;
 }
 document.querySelector('[data-experiment-action="tick"]').click();if(document.querySelector('[data-cpu32-flow][aria-current="step"]').dataset.cpu32Flow!=='0')throw Error('reset');checks++;
 document.querySelector('[data-observation-prev]').click();document.querySelector('[data-cpu32-flow="5"]').click();document.querySelector('[data-observation-live]').click();
 if(!document.querySelector('.cpu32-program-status').textContent.includes('退休 1 条'))throw Error('history mutated');checks++;
 return{status:'passed',checks};
}
