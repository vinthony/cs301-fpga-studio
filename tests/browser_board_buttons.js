async()=>{
 const checks=[],ok=(v,n)=>{if(!v)throw Error(n);checks.push(n)},wait=ms=>new Promise(r=>setTimeout(r,ms)),d=()=>document.querySelector('.anatomy-dialog[open]');
 d()?.querySelector('[data-an-close]').click();openArchitecture('board',{boardSource:'buttons'});await wait(250);
 const frame=()=>d().querySelector('.an-flat-board'),setMode=mode=>{const sel=d().querySelector('[data-board-source]');sel.value=mode;sel.dispatchEvent(new Event('change',{bubbles:true}))};
 ok(frame().dataset.signalSource==='buttons','直达按键模式');ok(frame().dataset.ledValue==='0','初始无按键无灯');
 for(let i=0;i<4;i++){d().querySelector('[data-board-btn="'+i+'"]').click();ok(Number(frame().dataset.ledValue)===(1<<(i+1))-1,'每个按键驱动对应灯 '+i);}
 ok(frame().querySelectorAll('[data-board-original="leds"] .led.on').length===4,'实际四灯亮');ok(frame().querySelectorAll('[data-board-original="sevenseg"] .lit').length===0,'实际数码管关闭');d().querySelector('[data-board-btn="4"]').click();ok(frame().dataset.ledValue==='15','D不改变输出');d().querySelector('[data-sw]').value='00FF';d().querySelector('[data-set-sw]').click();ok(frame().dataset.ledValue==='15','SW不参与');
 setMode('adder');await wait(180);ok(frame().dataset.ledValue==='30','相同输入切换加法设计');ok(frame().dataset.buttonValue==='31','保持物理按键');setMode('cpu32');await wait(220);ok(frame().dataset.ledValue==='0','CPU不冒充直接映射');ok(frame().dataset.buttonValue==='31','CPU得到相同输入');setMode('buttons');await wait(180);ok(frame().dataset.ledValue==='15','切回直连');ok(d().querySelectorAll('[data-live-net]').length===2,'来源切换不混用网表');d().querySelector('[data-board-btn="0"]').click();d().querySelector('[data-observation-prev]').click();const led=frame().dataset.ledValue;d().querySelector('[data-board-btn="0"]').click();ok(frame().dataset.ledValue===led,'历史只读');
 return {status:'passed',checks:checks.length,sourceModes:3};
}
