async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},wait=ms=>new Promise(r=>setTimeout(r,ms)),d=()=>document.querySelector('.anatomy-dialog[open]');d()?.querySelector('[data-an-close]').click();openArchitecture('decoder');await wait(50);
 for(let address=0;address<4;address++){
  d().querySelector('[data-decoder-address="'+address+'"]').click();let ones=0;
  for(let i=0;i<4;i++){const bit=Number(d().querySelector('[data-decoder-output="'+i+'"]').textContent);ones+=bit;ok(bit===Number(i===address),'one hot actual output');}
  ok(ones===1,'exactly one selected');ok(d().querySelector('[data-decoder-summary]').textContent.includes((2**address).toString(2).padStart(4,'0')),'output bit order');
  const expected={I0:{a:address&1},I1:{a:address>>>1},...Object.fromEntries(Array.from({length:4},(_,i)=>['G'+i,{a:i&1?address&1:1-(address&1),b:i&2?address>>>1:1-(address>>>1)}]))};
  for(const [part,inputs]of Object.entries(expected)){
   d().querySelector('[data-part="'+part+'"]').dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await wait(30);
   for(const [key,value]of Object.entries(inputs)){const row=d().querySelector('[data-origin-input="'+key+'"]');ok(Number(row.dataset.originValue)===value,'source matches actual wire');ok(Number(row.dataset.localValue)===value,'gate receives source');}
   d().querySelector('[data-toggle="a"]').click();d().querySelector('[data-reread-parent]').click();await wait(30);ok(Number(d().querySelector('[data-origin-input="a"]').dataset.localValue)===inputs.a,'reread');d().querySelector('[data-origin-input="a"] [data-trace-parent-net]').click();await wait(30);ok(d().dataset.view==='decoder','trace correct parent');
  }
 }
 d().querySelector('[data-decoder-address="0"]').click();d().querySelector('[data-decoder-bit="1"]').click();ok(Number(d().querySelector('[data-field="av"]').value)===2,'high address bit');d().querySelector('[data-decoder-bit="0"]').click();ok(Number(d().querySelector('[data-field="av"]').value)===3,'low address bit');
 return {status:'passed',addresses:4,expansions:24,checks};
}
