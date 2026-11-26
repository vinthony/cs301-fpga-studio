async()=>{
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('cpu32');await new Promise(r=>setTimeout(r,120));let checks=0;
 document.querySelector('[data-cpu32-demo]').value=String(AN_CPU32_DEMOS.length-1);document.querySelector('[data-cpu32-demo-copy]').click();document.querySelector('[data-cpu32-load]').click();
 const tick=()=>document.querySelector('[data-experiment-action="tick"]').click();tick();tick();
 if(!document.querySelector('[data-control-condition]').textContent.includes('BLT = 成立'))throw Error('signed');
 const row=[...document.querySelectorAll('.cpu32-control-lens tbody tr')].find(n=>n.querySelector('th').textContent==='BLTU');if(row.lastElementChild.textContent!=='0')throw Error('unsigned compare');checks+=2;
 document.querySelector('[data-cpu32-flow="4"]').click();document.querySelector('[data-cpu32-show-control]').click();tick();if(!document.querySelector('[data-control-condition]').textContent.includes('BLTU = 不成立'))throw Error('unsigned actual');checks++;
 const load=source=>{const e=document.querySelector('[data-cpu32-source]');e.value=source;e.dispatchEvent(new Event('input',{bubbles:true}));document.querySelector('[data-cpu32-load]').click()};
 load('bne x0,x0,2\nebreak');if(document.querySelector('.cpu32-control-fault')||!document.querySelector('.cpu32-control-lens').textContent.includes('未选中的目标'))throw Error('unselected align');checks+=2;
 load('beq x0,x0,2');if(!document.querySelector('.cpu32-control-fault')||document.querySelector('[data-control-next]').textContent!=='0x00000000')throw Error('blocked target');checks+=2;
 load('addi x1,x0,7\njalr x1,0(x1)');tick();if(!document.querySelector('[data-control-link]').textContent.includes('不会写入 x1')||!document.querySelector('.cpu32-control-lens').textContent.includes('0x00000006'))throw Error('JALR fault link');checks+=2;
 tick();if(!document.querySelector('[data-cpu32-probe="1"]').textContent.includes('00000007'))throw Error('fault changed link');checks++;
 return{status:'passed',checks};
}
