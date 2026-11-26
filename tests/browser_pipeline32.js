async()=>{
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('pipeline32');await new Promise(r=>setTimeout(r,180));let checks=0;const results=[];
 for(const mode of ['none','forward','stall']){
  const select=document.querySelector('[data-field="pipeMode"]');select.value=mode;select.dispatchEvent(new Event('change',{bubbles:true}));document.querySelector('[data-experiment-action="restart"]').click();let count=0;
  while(!document.querySelector('[data-experiment-action="tick"]').disabled&&count<80){document.querySelector('[data-experiment-action="tick"]').click();count++}
  if(count>=80)throw Error('did not stop');const watch=document.querySelector('.an-watch').textContent,result=mode==='none'?0:30;
  if(!watch.includes('x5 / RAM[0]'+result+' / '+(mode==='none'?0:15)))throw Error('result '+mode);
  if(document.querySelector('[data-context-current]').dataset.contextCurrent!=='pipeline32'||document.querySelector('.an-scene').dataset.render!=='ready')throw Error('view');results.push({mode,cycles:count,result});checks+=3;
 }
 return{status:'passed',checks,results};
}
