async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},wait=ms=>new Promise(r=>setTimeout(r,ms)),d=()=>document.querySelector('.anatomy-dialog[open]');
 d()?.querySelector('[data-an-close]').click();openArchitecture('transmission');await wait(50);
 for(let i=0;i<4;i++){
  d().querySelector('[data-transmission-case="'+i+'"]').click();const data=i&1,en=i>>>1,s=anatomyState();Object.assign(s,{a:data,enable:en});const e=anatomyEvaluate('transmission',s);ok(e.result===(en?data:'Z'),'ideal output');ok(e.switches.N===en&&e.switches.P===en,'complementary gates same conduction');ok(d().querySelector('[data-transmission-result]').textContent.includes('Y='+(en?data:'Z')),'actual display');
  for(const [part,value]of [['I',en],['N',en],['P',1-en]]){
   d().querySelector('[data-part="'+part+'"]').dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await wait(30);const row=d().querySelector('[data-origin-input="a"]');ok(Number(row.dataset.originValue)===value,'gate source');ok(Number(row.dataset.localValue)===value,'copied control');d().querySelector('[data-toggle="a"]').click();d().querySelector('[data-reread-parent]').click();await wait(20);ok(Number(d().querySelector('[data-origin-input="a"]').dataset.localValue)===value,'reread gate');d().querySelector('[data-origin-input="a"] [data-trace-parent-net]').click();await wait(20);ok(d().dataset.view==='transmission','trace transmission');
  }
 }
 for(const byte of [0,1,254,255])for(const we of [0,1]){
  d().querySelector('[data-an-close]').click();openArchitecture('sram');await wait(30);const input=d().querySelector('[data-field="data"]');input.value=byte;input.dispatchEvent(new Event('change',{bubbles:true}));if(Number(d().querySelector('[data-toggle="we"]').getAttribute('aria-pressed')==='true')!==we)d().querySelector('[data-toggle="we"]').click();d().querySelector('[data-driver-enter]').click();await wait(30);
  for(const [key,value]of [['a',byte%2],['enable',we]]){const row=d().querySelector('[data-transmission-origin="'+key+'"]');ok(Number(row.dataset.originValue)===value,'SRAM source');ok(Number(row.dataset.localValue)===value,'SRAM copy');}
  d().querySelector('[data-toggle="a"]').click();d().querySelector('[data-reread-parent]').click();await wait(20);ok(Number(d().querySelector('[data-transmission-origin="a"]').dataset.localValue)===byte%2,'restore bit zero');d().querySelector('[data-trace-parent-net="待写字节"]').click();await wait(20);ok(d().dataset.view==='sram','back actual source');ok(d().querySelector('[data-memory-read="A"]').textContent==='00000000','no SRAM write');
 }
 return {status:'passed',truthCases:4,gateExpansions:12,byteSources:8,checks};
}
