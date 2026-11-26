async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},masks=[63,6,91,79,102,109,125,7,127,111,119,124,57,94,121,113];
 for(const id of ['scan','sevenseg'])for(let digit=0;digit<4;digit++)for(let phase=0;phase<3;phase++)for(let value=0;value<16;value++){
  const s=anatomyState();s.word=value*0x1111;s.digit=digit;s.scanPhase=phase;const doc=new DOMParser().parseFromString(anatomyScanLens(ANATOMY[id],s),'text/html'),an=phase===2?15^(1<<digit):15;
  ok(doc.querySelector('[data-scan-an]').textContent===an.toString(2).padStart(4,'0'),'low active an');ok(doc.querySelector('[data-scan-seg]').textContent===((~masks[value])&127).toString(2).padStart(7,'0'),'independent hex segment table');
  for(const node of doc.querySelectorAll('[data-scan-digit]')){const index=+node.dataset.scanDigit,lit=phase===2&&index===digit;ok(node.dataset.lit===String(lit),'single selected digit');ok(node.querySelectorAll('polygon[fill="#ff665c"]').length===(lit?masks[value].toString(2).split('1').length-1:0),'actual lit segments')}
  anatomyAdvance(id,s,'tick');ok(s.ticks===1,'actual teaching step counted');ok(s.scanPhase===(phase+1)%3&&s.digit===(phase===2?(digit+1)%4:digit),'phase transition');
 }
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('scan');await new Promise(r=>setTimeout(r,100));const h=document.querySelector('.anatomy-dialog[open] .an-prediction');h.querySelector('details').open=true;h.querySelector('[data-predict="1"]').click();h.querySelector('[data-predict-start]').click();for(let i=0;i<3;i++)h.querySelector('[data-predict-next]').click();ok(h.dataset.predictionVerified==='true','actual three phase exercise');return {status:'passed',states:384,checks};
}
