async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},wait=ms=>new Promise(r=>setTimeout(r,ms)),d=()=>document.querySelector('.anatomy-dialog[open]');
 for(let address=0;address<8;address++){
  d()?.querySelector('[data-an-close]').click();openArchitecture('sram');await wait(30);const input=d().querySelector('[data-field="addr"]');input.value=address;input.dispatchEvent(new Event('change',{bubbles:true}));d().querySelector('[data-part="DEC"]').dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await wait(30);
  ok(d().dataset.view==='decoder3','three bit row decoder');ok(Number(d().querySelector('[data-decoder-origin]').dataset.localValue)===address,'actual SRAM address');
  const s=anatomyState();s.av=address;const e=anatomyEvaluate('decoder3',s);let ones=0;for(let i=0;i<8;i++){const v=e.nets['字线'+i];ones+=v;ok(v===Number(i===address),'actual selected wordline');ok(e.partValues['H'+i]===v,'gate output not input')}ok(ones===1,'one wordline');
  d().querySelector('[data-part="DEC2"]').dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await wait(30);ok(Number(d().querySelector('[data-decoder-origin]').dataset.localValue)===(address%4),'lower address copied');d().querySelector('[data-reread-parent]').click();await wait(20);ok(Number(d().querySelector('[data-field="av"]').value)===(address%4),'reread lower');d().querySelector('[data-trace-parent-net="低两位地址"]').click();await wait(20);
  for(let i=0;i<8;i++){
   d().querySelector('[data-part="H'+i+'"]').dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await wait(20);for(const [key,value]of [['a',Number(address%4===i%4)],['b',Number(Math.floor(address/4)===Math.floor(i/4))]]){const row=d().querySelector('[data-origin-input="'+key+'"]');ok(Number(row.dataset.originValue)===value,'source gate input');ok(Number(row.dataset.localValue)===value,'copied gate input')}
   d().querySelector('[data-origin-input="a"] [data-trace-parent-net]').click();await wait(20);
  }
  d().querySelector('[data-trace-parent-net="地址"]').click();await wait(20);ok(d().dataset.view==='sram','trace SRAM');ok(Number(d().querySelector('[data-field="addr"]').value)===address,'original address preserved');
 }
 return {status:'passed',addresses:8,gateExpansions:64,checks};
}
