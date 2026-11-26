async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++};document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('sram');await new Promise(r=>setTimeout(r,80));const d=document.querySelector('.anatomy-dialog[open]'),expected=Array(8).fill(0),field=(key,value)=>{const input=d.querySelector('[data-field="'+key+'"]');input.value=value;input.dispatchEvent(new Event('change',{bubbles:true}))},read=row=>Array.from({length:8},(_,i)=>Number(d.querySelector('[data-memory-cell="'+row+'"][data-memory-cell-bit="'+i+'"]').textContent)*2**i).reduce((a,b)=>a+b,0),setWE=value=>{const b=d.querySelector('[data-toggle="we"]');if(Number(b.getAttribute('aria-pressed')==='true')!==value)b.click()};
 setWE(1);for(let i=0;i<8;i++){field('addr',i);field('data',i*17);d.querySelector('[data-tick]').click();expected[i]=i*17;}
 for(let row=0;row<8;row++)for(const we of [0,1]){
  d.querySelector('[data-memory-address="'+row+'"][data-memory-port="A"]').click();setWE(we);field('data',255-row);ok(d.querySelector('[data-memory-wordline-summary]').textContent.includes((2**row).toString(2).padStart(8,'0')),'actual one-hot mask');
  for(let i=0;i<8;i++){ok(Number(d.querySelector('[data-memory-wl="'+i+'"]').dataset.value)===Number(i===row),'selected row independent of WE');ok(read(i)===expected[i],'input changes do not write');}
  d.querySelector('[data-tick]').click();if(we)expected[row]=255-row;for(let i=0;i<8;i++)ok(read(i)===expected[i],'only enabled selected row updates');ok(d.querySelector('[data-memory-read="A"]').textContent===expected[row].toString(2).padStart(8,'0'),'read selected row with either WE');
 }
 return {status:'passed',rows:8,writeConditions:16,checks};
}
