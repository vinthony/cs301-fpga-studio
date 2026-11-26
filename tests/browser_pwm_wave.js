async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++};
 for(let duty=0;duty<=16;duty++)for(let phase=0;phase<16;phase++){
  const doc=new DOMParser().parseFromString(anatomyPWMLens(ANATOMY.leddriver,{phase,duty}),'text/html');
  const path=doc.querySelector('[data-pwm-wave-path]').getAttribute('d'),segments=[...path.matchAll(/[ML](\d+) (\d+)H(\d+)/g)];
  ok(segments.length===16,'sixteen phase intervals');
  ok(segments.every((m,i)=>+m[1]===32+i*24&&+m[2]===(i<duty?24:70)&&+m[3]===32+(i+1)*24),'all wave levels match comparison');
  const cursor=doc.querySelector('[data-pwm-wave-cursor]');ok(+cursor.getAttribute('cx')===44+phase*24&&+cursor.getAttribute('cy')===(phase<duty?24:70),'cursor current position');
  const text=doc.querySelector('[data-pwm-comparison]').textContent;
  ok(text.includes(phase.toString(2).padStart(4,'0'))&&text.includes(duty.toString(2).padStart(5,'0'))&&text.includes('输出将为'+(+(((phase+1)&15)<duty))),'binary widths and next edge');
 }
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('leddriver');
 await new Promise(r=>setTimeout(r,200));const dialog=document.querySelector('.anatomy-dialog[open]');
 dialog.querySelector('[data-pwm-duty="15"]').click();
 for(let i=0;i<16;i++){ok(dialog.querySelector('[data-pwm-phase="'+i+'"]').hasAttribute('aria-current'),'actual advancing phase '+i);dialog.querySelector('[data-tick]').click()}
 ok(dialog.querySelector('[data-pwm-phase="0"]').hasAttribute('aria-current'),'actual counter wraps');
 return {status:'passed',combinations:272,checks};
}
