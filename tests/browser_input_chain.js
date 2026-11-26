async()=>{
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('input');await new Promise(r=>setTimeout(r,120));let checks=0;
 const result=()=>document.querySelector('.an-live-io strong').textContent;
 for(let i=1;i<=5;i++){document.querySelector('[data-experiment-action="tick"]').click();if(result()!==(i===5?'1':'0'))throw Error('event '+i);checks++}
 for(const [part,view]of [['SYNC','synchronizer'],['DB','debounce'],['EV','edge']]){
  document.querySelector('[data-input-stage="'+part+'"]').click();await new Promise(r=>setTimeout(r,70));
  if(document.querySelector('[data-context-current]').dataset.contextCurrent!==view||!document.querySelector('[data-reread-parent]'))throw Error('transfer '+part);
  if(result()!=='1')throw Error('state '+part);checks+=3;document.querySelector('[data-return-parent]').click();await new Promise(r=>setTimeout(r,70));
 }
 document.querySelector('[data-experiment-action="tick"]').click();if(result()!=='0')throw Error('repeated press');checks++;
 return{status:'passed',checks};
}
