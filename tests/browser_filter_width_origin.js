async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},wait=ms=>new Promise(r=>setTimeout(r,ms)),d=()=>document.querySelector('.anatomy-dialog[open]'),field=(key,value)=>{const input=d().querySelector('[data-field="'+key+'"]');input.value=value;input.dispatchEvent(new Event('change',{bubbles:true}))};
 for(const sequence of [[0,0,0,0],[255,255,255,255],[255,128,64,32],[15,16,127,128]]){
  d()?.querySelector('[data-an-close]').click();openArchitecture('filter');await wait(40);for(const data of sequence){field('data',data);d().querySelector('[data-tick]').click()}const samples=sequence.slice().reverse(),sum=samples.reduce((a,b)=>a+b,0);field('data',85);ok(Number(d().querySelector('[data-filter-sum]').textContent)===sum,'full sum without overflow');ok(Number(d().querySelector('[data-filter-mean]').textContent)===Math.floor(sum/4),'truncated mean');
  const expected={...Object.fromEntries(samples.map((q,i)=>['D'+i,{av:i?samples[i-1]:85,reg8Q:q,enable:1}])),A01:{av:samples[0],bv:samples[1]},A23:{av:samples[2],bv:samples[3]},A:{av:samples[0]+samples[1],bv:samples[2]+samples[3]},S:{av:sum,bv:2}};
  for(const [part,values]of Object.entries(expected)){
   d().querySelector('[data-part="'+part+'"]').dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await wait(30);for(const [key,value]of Object.entries(values)){const row=d().querySelector('[data-filter-origin="'+key+'"]');ok(Number(row.dataset.originValue)===value,'source full width');ok(Number(row.dataset.localValue)===value,'copied full width');}
   if(part[0]==='D'){d().querySelector('[data-experiment-action="tick"]').click();ok(Number(d().querySelector('[data-filter-origin="reg8Q"]').dataset.localValue)===values.av,'byte capture no truncation');}else{const result=part==='S'?Math.floor(sum/4):values.av+values.bv;ok(Number(d().querySelector('[data-coach-delta] b').textContent)===result,'independent ALU result');field('av','0xFF');ok(Number(d().querySelector('[data-filter-origin="av"]').dataset.localValue)===255,'local source panel follows manual edit');}
   d().querySelector('[data-reread-parent]').click();await wait(20);ok(Number(d().querySelector('[data-filter-origin="av"]').dataset.localValue)===values.av,'reread operand');d().querySelector('[data-filter-origin="av"] [data-trace-parent-net]').click();await wait(20);ok(d().dataset.view==='filter','trace parent');ok(d().querySelector('[data-filter-window]').textContent.includes(samples.join('、')),'parent window unchanged');
  }
 }
 return {status:'passed',windows:4,expansions:32,checks};
}
