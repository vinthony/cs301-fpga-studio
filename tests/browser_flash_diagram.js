async()=>{
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('flash');await new Promise(r=>setTimeout(r,180));
 document.querySelector('[data-flash-address="1"]').click();document.querySelector('[data-flash-data="15"]').click();document.querySelector('[data-experiment-action="program"]').click();await new Promise(r=>setTimeout(r,200));
 const cmd=document.querySelector('.an-scene [data-diagram-part="CMD"]'),mem=document.querySelector('.an-scene [data-diagram-part="MEM"]');
 if(!cmd.textContent.includes('实际保存 → 0x0F'))throw Error('operation result');if(mem.querySelectorAll('rect[fill="#4e9b87"]').length!==60)throw Error('actual bits');
 document.querySelector('[data-flash-address="2"]').click();await new Promise(r=>setTimeout(r,200));if(!document.querySelector('.an-scene [data-diagram-part="CMD"]').textContent.includes('最近编程 @1'))throw Error('operation snapshot');return {status:'passed',checks:3};
}
