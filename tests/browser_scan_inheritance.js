async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},wait=()=>new Promise(r=>setTimeout(r,35)),d=()=>document.querySelector('.anatomy-dialog[open]'),enter=async id=>{d().querySelector('[data-part="'+id+'"]').dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await wait()};
 for(let digit=0;digit<4;digit++)for(let phase=0;phase<3;phase++){
  d()?.querySelector('[data-an-close]').click();openArchitecture('sevenseg');await wait();const input=d().querySelector('[data-word]');input.value='1234';d().querySelector('[data-word-set]').click();const steps=(digit*3+phase-2+12)%12;for(let i=0;i<steps;i++)d().querySelector('[data-tick]').click();
  const before=d().querySelector('[data-scan-an]').textContent;await enter('DRV');ok(d().dataset.view==='scan','actual child');ok(d().querySelector('[data-scan-an]').textContent===before,'phase/digit carried');ok(d().querySelector('[data-word]').value==='1234','word carried');
  await enter('DEC');const expected=4-digit;ok(+d().querySelector('[data-field="av"]').value===expected,'current nibble carried');const inputChild=d().querySelector('[data-field="av"]');inputChild.value=8;inputChild.dispatchEvent(new Event('change',{bubbles:true}));d().querySelector('[data-reread-parent]').click();await wait();ok(+d().querySelector('[data-field="av"]').value===expected,'reread current parent nibble');
  await enter('L');ok(d().dataset.view==='lut','a output LUT child');ok(+d().querySelector('[data-field="lutAddr"]').value===expected,'LUT address');ok(d().querySelector('.an-transfer-note').textContent.includes('只展开a段'),'single output scope explicit');
 }
 const masks=[63,6,91,79,102,109,125,7,127,111,119,124,57,94,121,113];
 for(let addr=0;addr<64;addr++){const input=d().querySelector('[data-field="lutAddr"]');input.value=addr;input.dispatchEvent(new Event('change',{bubbles:true}));ok(+d().querySelector('[data-coach-delta] b').textContent===((~masks[addr&15])&1),'configured a segment LUT truth table '+addr)}
 return {status:'passed',parentStates:12,lutAddresses:64,checks};
}
