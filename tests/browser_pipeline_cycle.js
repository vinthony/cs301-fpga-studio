async()=>{
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('pipeline32');await new Promise(r=>setTimeout(r,220));
 let checks=0;const ok=(x,msg)=>{if(!x)throw Error(msg);checks++};
 for(let i=0;i<8;i++)document.querySelector('[data-experiment-action="tick"]').click();
 const panel=document.querySelector('[data-pipe32-cycle-detail]').closest('details');panel.open=true;
 const before=document.querySelector('.an-watch').textContent;
 document.querySelector('[data-pipe32-cycle="4"]').click();
 let detail=document.querySelector('[data-pipe32-cycle-detail]').textContent;
 ok(detail.includes('EX操作数来源：A=EX/MEM'),'EX/MEM forwarding source');
 ok(detail.includes('实例 #0'),'instruction instance');
 document.querySelector('[data-pipe32-cycle="5"]').click();detail=document.querySelector('[data-pipe32-cycle-detail]').textContent;
 ok(detail.includes('x1 ← 5'),'actual WB write');ok(detail.includes('A=EX/MEM，B=MEM/WB'),'two forwarding sources');
 document.querySelector('[data-pipe32-cycle="7"]').click();detail=document.querySelector('[data-pipe32-cycle-detail]').textContent;
 ok(detail.includes('load-use'),'load-use cause');ok(detail.includes('store 地址 0，值 15，4 字节'),'actual MEM store');
 ok(document.querySelector('.an-watch').textContent===before,'inspection keeps current state');
 ok(document.querySelectorAll('[data-pipe32-cycle][aria-pressed="true"]').length===1,'one selected cycle');
 ok(!detail.includes('undefined'),'no missing rendered value');
 return {status:'passed',checks};
}
