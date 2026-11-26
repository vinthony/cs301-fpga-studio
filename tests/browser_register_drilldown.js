async()=>{
 let checks=0;const wait=()=>new Promise(r=>setTimeout(r,60)),click=s=>document.querySelector(s).dispatchEvent(new MouseEvent('click',{bubbles:true}));
 for(let en=0;en<2;en++)for(let rst=0;rst<2;rst++)for(let bit=0;bit<4;bit++){
  document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('register');await wait();click('[data-tick]');
  const input=document.querySelector('[data-field="av"]');input.value=10;input.dispatchEvent(new Event('change',{bubbles:true}));
  if(!en)click('[data-toggle="enable"]');if(rst)click('[data-toggle="reset"]');click('[data-register-cell="'+bit+'"]');await wait();
  const expected=((rst?0:en?10:5)>>>bit)&1,raw=+(document.querySelector('[data-toggle="a"]').getAttribute('aria-pressed')==='true');
  if(raw!==expected)throw Error('controlled input '+[en,rst,bit]);
  if(document.querySelector('[data-tick]').disabled)throw Error('stale clock');
  if(!document.querySelector('[data-reread-parent]'))throw Error('missing reread');
  click('[data-tick]');if(!document.querySelector('.an-watch').textContent.includes('当前输出'+expected))throw Error('saved');checks+=4;
 }
 return {status:'passed',cases:16,checks};
}
