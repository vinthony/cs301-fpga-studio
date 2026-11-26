async()=>{
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('sramcell');await new Promise(r=>setTimeout(r,100));
 const click=s=>document.querySelector(s).dispatchEvent(new MouseEvent('click',{bubbles:true})),q=()=>[...document.querySelectorAll('.an-watch tr')].find(x=>x.querySelector('th').textContent==='Q / QB').querySelector('td b').textContent;let checks=0;
 click('[data-cell-prepare="1"]');if(q()!=='0 / 1'||document.querySelector('[data-cell-next]').textContent!=='1 / 0')throw Error('prepare');checks+=2;
 click('[data-toggle="enable"]');if(document.querySelector('[data-cell-next]').textContent!=='0 / 1')throw Error('hold candidate');click('[data-tick]');if(q()!=='0 / 1')throw Error('hold');checks+=2;
 click('[data-toggle="enable"]');click('[data-tick]');if(q()!=='1 / 0')throw Error('write');checks++;
 for(const id of ['I0','I1']){
  click('[data-cell-inverter="'+id+'"]');await new Promise(r=>setTimeout(r,80));const expected=id==='I0'?1:0;
  if(+(document.querySelector('[data-toggle="a"]').getAttribute('aria-pressed')==='true')!==expected)throw Error('inverter input');
  if(!document.querySelector('.an-transfer-note').textContent.includes('反相输出为 '+(1-expected)))throw Error('note');checks+=2;
  click('[data-return-parent]');await new Promise(r=>setTimeout(r,80));
 }
 return{status:'passed',checks};
}
