async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},wait=ms=>new Promise(r=>setTimeout(r,ms)),d=()=>document.querySelector('.anatomy-dialog[open]');
 for(const [a,b]of [[0,0],[15,15],[0,15],[15,0],[5,3],[8,0],[4,0],[2,0],[1,0]]){
  d()?.querySelector('[data-an-close]').click();openArchitecture('compare');await wait(30);for(const [key,value]of [['av',a],['bv',b]]){const input=d().querySelector('[data-field="'+key+'"]');input.value=value;input.dispatchEvent(new Event('change',{bubbles:true}))}
  const diff=a^b,expected={...Object.fromEntries(Array.from({length:4},(_,i)=>['X'+i,{a:(a>>>i)&1,b:(b>>>i)&1}])),R01:{a:diff&1,b:(diff>>>1)&1},R23:{a:(diff>>>2)&1,b:(diff>>>3)&1},R:{a:+!!(diff&3),b:+!!(diff&12)},I:{a:+!!diff}};
  for(const [part,inputs]of Object.entries(expected)){
   d().querySelector('[data-part="'+part+'"]').dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await wait(25);
   for(const [key,value]of Object.entries(inputs)){const row=d().querySelector('[data-origin-input="'+key+'"]');ok(Number(row.dataset.originValue)===value,'actual source');ok(Number(row.dataset.localValue)===value,'copied gate input');}
   d().querySelector('[data-toggle="a"]').click();d().querySelector('[data-reread-parent]').click();await wait(25);ok(Number(d().querySelector('[data-origin-input="a"]').dataset.localValue)===inputs.a,'reread');d().querySelector('[data-origin-input="a"] [data-trace-parent-net]').click();await wait(25);ok(d().dataset.view==='compare','trace parent');
  }
 }
 return {status:'passed',pairs:9,expansions:72,checks};
}
