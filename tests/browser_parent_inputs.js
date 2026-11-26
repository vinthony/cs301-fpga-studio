async()=>{
 const wait=()=>new Promise(r=>setTimeout(r,180));let checks=0;
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('adder');await wait();
 for(const [k,v]of [['av',7],['bv',1]]){const e=document.querySelector('[data-field="'+k+'"]');e.value=v;e.dispatchEvent(new Event('change',{bubbles:true}))}
 document.querySelector('[data-part="FA2"]').dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await wait();
 const values=()=>['a','b','cin'].map(k=>document.querySelector('[data-toggle="'+k+'"]').getAttribute('aria-pressed')==='true'?1:0);
 if(values().join()!=='1,0,1')throw Error('carry import');checks++;
 document.querySelector('[data-toggle="cin"]').click();document.querySelector('[data-toggle="a"]').click();
 if(values().join()!=='0,0,0')throw Error('local edit');checks++;
 document.querySelector('[data-reread-parent]').click();await wait();
 if(values().join()!=='1,0,1')throw Error('restore');checks++;
 document.querySelector('[data-part="X2"]').dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await wait();
 if(!document.querySelector('[data-reread-parent]')||!document.querySelector('.an-transfer-note').textContent.includes('X2'))throw Error('nested import');checks++;
 return{status:'passed',checks};
}
