async()=>{
 let checks=0;const ok=(v,m)=>{if(!v)throw Error(m);checks++};
 for(let byte=0;byte<256;byte++){
  const s=anatomyState();s.byte=byte;const expected=[0,...Array.from({length:8},(_,i)=>(byte>>>i)&1),1];
  for(let i=0;i<10;i++){anatomyAdvance('tx',s);if(i===1)s.byte=255-byte;ok(anatomyEvaluate('tx',s).result===expected[i],'frame byte '+byte+' bit '+i)}
  anatomyAdvance('tx',s);ok(anatomyEvaluate('tx',s).result===1&&s.uartIndex===-1,'idle '+byte);
 }
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('tx');await new Promise(r=>setTimeout(r,180));
 const status=()=>document.querySelector('[data-uart-frame-status]').textContent;
 document.querySelector('[data-uart-pending-byte="85"]').click();ok(status().includes('空闲 TX=1'),'pending is not send');document.querySelector('[data-tick]').click();ok(status().includes('START，TX=0'),'start');
 document.querySelector('[data-uart-pending-byte="0"]').click();document.querySelector('[data-tick]').click();ok(status().includes('d0，TX=1'),'captured byte stable despite draft');ok(document.querySelector('.an-uart-lens').textContent.includes('当前帧已捕获 85'),'captured visible');
 for(let i=0;i<8;i++)document.querySelector('[data-tick]').click();ok(status().includes('STOP，TX=1'),'stop full step');document.querySelector('[data-tick]').click();ok(status().includes('空闲 TX=1'),'return idle');
 document.querySelector('[data-tick]').click();document.querySelector('[data-tick]').click();ok(status().includes('d0，TX=0'),'next frame uses new byte');
 document.querySelector('.an-uart-lens').scrollIntoView({block:'center'});return {status:'passed',checks,bytes:256};
}
