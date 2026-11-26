async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},wait=()=>new Promise(r=>setTimeout(r,40)),masks=[63,6,91,79,102,109,125,7,127,111,119,124,57,94,121,113],d=()=>document.querySelector('.anatomy-dialog[open]');
 for(let bit=0;bit<7;bit++){
  d()?.querySelector('[data-an-close]').click();openArchitecture('segmentdecode');await wait();const input=d().querySelector('[data-field="av"]');input.value=9;input.dispatchEvent(new Event('change',{bubbles:true}));const before=d().querySelector('[data-observation-range]').max;d().querySelector('.an-segment-list [data-segment-inspect="'+bit+'"]').click();ok(d().querySelector('[data-observation-range]').max===before,'probe read only');d().querySelector('[data-segment-expand]').click();await wait();ok(d().dataset.view==='lut','actual LUT view');ok(d().querySelector('.an-transfer-note').textContent.includes('只展开'+'abcdefg'[bit]+'段即seg['+bit+']'),'correct output scope');ok(+d().querySelector('[data-field="lutAddr"]').value===9,'parent digit carried');
  for(let address=0;address<64;address++){const field=d().querySelector('[data-field="lutAddr"]');field.value=address;field.dispatchEvent(new Event('change',{bubbles:true}));ok(+d().querySelector('[data-coach-delta] b').textContent===(((~masks[address&15])>>>bit)&1),'independent truth table '+bit+' '+address)}
  d().querySelector('[data-reread-parent]').click();await wait();ok(+d().querySelector('[data-field="lutAddr"]').value===9,'reread parent digit');ok(d().querySelector('.an-transfer-note').textContent.includes('只展开'+'abcdefg'[bit]+'段'),'reread keeps chosen output bit');ok(+d().querySelector('[data-coach-delta] b').textContent===(((~masks[9])>>>bit)&1),'reread output');
 }
 return {status:'passed',segmentFunctions:7,addressesPerFunction:64,checks};
}
