async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++};document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('sram');await new Promise(r=>setTimeout(r,80));const d=document.querySelector('.anatomy-dialog[open]');d.querySelector('[data-part="WR"]').dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));ok(d.querySelector('.an-sram-driver').open,'driver expands from schematic');
 for(const data of [0,1,85,170,255])for(const we of [0,1]){
  const input=d.querySelector('[data-field="data"]');input.value=data;input.dispatchEvent(new Event('change',{bubbles:true}));if(Number(d.querySelector('[data-toggle="we"]').getAttribute('aria-pressed')==='true')!==we)d.querySelector('[data-driver-we]').click();
  for(let bit=0;bit<8;bit++){
   const value=Math.floor(data/2**bit)%2;ok(d.querySelector('[data-driver-bl="'+bit+'"]').textContent===String(we?value:'Z'),'BL drive');ok(d.querySelector('[data-driver-blb="'+bit+'"]').textContent===String(we?1-value:'Z'),'complement drive');d.querySelector('[data-driver-probe="'+bit+'"]').click();ok(d.querySelector('[data-driver-bit-view] svg').getAttribute('aria-label').includes('bit'+bit),'actual bit detail');
   d.querySelector('.an-sram-driver [data-memory-bit="'+bit+'"]').click();ok(d.querySelector('[data-driver-bit-view] svg').getAttribute('aria-label').includes('bit'+bit),'probe survives input change');d.querySelector('.an-sram-driver [data-memory-bit="'+bit+'"]').click();
  }
  ok(d.querySelector('[data-memory-read="A"]').textContent==='00000000','driver changes do not write');ok(d.querySelector('.an-sram-driver').open,'detail stays expanded');
 }
 d.querySelector('[data-tick]').click();ok(d.querySelector('[data-memory-read="A"]').textContent==='11111111','actual enabled edge writes final data');return {status:'passed',conditions:10,bitConditions:80,checks};
}
