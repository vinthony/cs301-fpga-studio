async()=>{
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('cpu32');await new Promise(r=>setTimeout(r,120));let checks=0;
 const source='li x1,0x89abcdef\nsw x1,0(x0)\nlb x2,0(x0)\nlbu x3,0(x0)\nlh x4,0(x0)\nlhu x5,0(x0)\nlw x6,0(x0)\nsb x1,4(x0)\nsh x1,6(x0)\nlw x7,1(x0)\nebreak',text=document.querySelector('[data-cpu32-source]');
 text.value=source;text.dispatchEvent(new Event('input',{bubbles:true}));document.querySelector('[data-cpu32-load]').click();
 const tick=()=>document.querySelector('[data-experiment-action="tick"]').click(),lens=()=>document.querySelector('.cpu32-byte-lens'),bytes=()=>[...document.querySelectorAll('[data-access-byte]')].map(n=>n.textContent).join(' ');
 tick();tick();if(bytes()!=='EF CD AB 89')throw Error('store lanes');checks++;
 document.querySelector('[data-cpu32-locate-access]').click();if(document.querySelectorAll('.cpu32-access-byte').length!==4||!document.querySelector('.cpu32-memory').open)throw Error('RAM locate');checks+=2;
 tick();for(const [name,value]of [['LB','FFFFFFEF'],['LBU','000000EF'],['LH','FFFFCDEF'],['LHU','0000CDEF'],['LW','89ABCDEF'],['SB','000000EF'],['SH','0000CDEF']]){
  if(!lens().querySelector('h4').textContent.includes(name)||!lens().querySelector('.cpu32-byte-result small').textContent.includes(value))throw Error('result '+name);checks+=2;tick();
 }
 if(!document.querySelector('[data-access-fault]')||document.querySelectorAll('[data-access-byte]').length||document.querySelectorAll('.cpu32-access-byte').length)throw Error('fault bytes');checks+=3;
 return{status:'passed',checks};
}
