async()=>{
 let checks=0;const ok=(v,m)=>{if(!v)throw Error(m);checks++};
 for(const bad of [false,true])for(let byte=0;byte<256;byte++){
  const s={byte};anatomyUARTLoopStart(s,bad);s.byte=255-byte;
  for(let i=0;i<10;i++){anatomyUARTLoopStep(s);ok(s.uartLoop.rx.rxValid===(i===9&&!bad?1:0),'valid only after stop '+byte+' '+i)}
  ok(s.uartLoop.rx.rxData===byte,'received byte '+byte);ok(s.uartLoop.rx.rxError===+bad,'stop error '+byte);ok(!anatomyUARTLoopStep(s),'finished holds');
 }
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('tx');await new Promise(r=>setTimeout(r,180));
 const before=document.querySelector('.an-watch').textContent;
 document.querySelector('[data-uart-loop-start="normal"]').click();for(let i=0;i<10;i++)document.querySelector('[data-uart-loop-step]').click();
 ok(document.querySelector('[data-uart-loop-status]').textContent.includes('接收累积 65 · valid=1 · 帧错误=0'),'UI good frame');ok(document.querySelector('[data-uart-loop-step]').disabled,'UI stops after frame');ok(document.querySelector('.an-watch').textContent===before,'separate sender preserved');
 document.querySelector('[data-uart-loop-start="bad"]').click();for(let i=0;i<10;i++)document.querySelector('[data-uart-loop-step]').click();ok(document.querySelector('[data-uart-loop-status]').textContent.includes('valid=0 · 帧错误=1'),'UI framing error');
 document.querySelector('.an-uart-loop').scrollIntoView({block:'center'});return {status:'passed',checks,frames:512};
}
