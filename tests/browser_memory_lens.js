async()=>{
 const wait=()=>new Promise(r=>setTimeout(r,150));document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('bram');await wait();
 let checks=0;const click=s=>document.querySelector(s).click(),word=()=>document.querySelector('.an-memory-lens tr.selected-a .an-memory-word').textContent,read=p=>document.querySelector('[data-memory-read="'+p+'"]').textContent;
 click('[data-memory-address="3"][data-memory-port="A"]');click('[data-memory-data="A"][data-memory-bit="7"]');
 if(word()!=='00000000'||document.querySelector('[data-memory-next-saved="A"]').textContent!=='10101010')throw Error('pending');checks+=2;
 click('[data-experiment-action="tick"]');if(word()!=='10101010'||read('A')!=='00000000')throw Error('read old');checks+=2;
 click('[data-experiment-action="tick"]');if(read('A')!=='10101010')throw Error('read new');checks++;
 click('[data-memory-address="3"][data-memory-port="B"]');click('[data-toggle="weB"]');
 if(!document.querySelector('[data-memory-policy]').textContent.includes('同址写不同'))throw Error('conflict preview');
 click('[data-experiment-action="tick"]');if(word()!=='10101010'||read('A')!=='X'||read('B')!=='X')throw Error('conflict state');checks+=4;
 document.querySelector('[data-an-close]').click();openArchitecture('sram');await wait();click('[data-memory-address="2"][data-memory-port="A"]');
 if(read('A')!=='00000000')throw Error('sram initial');click('[data-tick]');if(read('A')!=='00101010'||word()!=='00101010')throw Error('sram write');checks+=3;
 return{status:'passed',checks};
}
