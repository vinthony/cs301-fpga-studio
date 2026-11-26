async()=>{
let checks=0,cases=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},wait=ms=>new Promise(r=>setTimeout(r,ms)),d=()=>document.querySelector('.anatomy-dialog[open]');
for(const id of ['nand','nor','not','cmos']){
 d()?.querySelector('[data-an-close]').click();openArchitecture(id);await wait(100);const two=['nand','nor'].includes(id),parts=two?['P0','P1','N0','N1']:['P','N'];
 for(let k=0;k<(two?4:2);k++)for(const part of parts){
  cases++;d().querySelector(`[data-truth-row="${k}"]`).click();const before={a:two?k>>1:k,b:k&1},key=part.endsWith('1')?'b':'a',after={...before,[key]:1-before[key]},node=()=>d().querySelector(`[data-cmos-switch="${part}"]`),input=x=>d().querySelector(`[data-toggle="${x}"]`).getAttribute('aria-pressed')==='true'?1:0;
  node().dispatchEvent(new MouseEvent('click',{bubbles:true}));ok(input(key)===after[key],'actual input '+id+k+part);if(two)ok(input(key==='a'?'b':'a')===before[key==='a'?'b':'a'],'other input unchanged');
  ok(document.activeElement===node(),'focus retained');const y=id==='nand'?+(after.a+after.b<2):id==='nor'?+(after.a+after.b===0):1-after.a;ok(Number(d().querySelector('[data-cmos-verdict]').dataset.output)===y,'whole network updates');
  for(const sibling of d().querySelectorAll(`[data-cmos-input="${key}"]`))ok(sibling.getAttribute('aria-label').includes(key.toUpperCase()+'='+after[key]),'shared gate updated');
  node().dispatchEvent(new KeyboardEvent('keydown',{key:'Enter',bubbles:true}));ok(input(key)===before[key],'enter toggles');node().dispatchEvent(new KeyboardEvent('keydown',{key:' ',bubbles:true}));ok(input(key)===after[key],'space toggles');
  d().querySelector('[data-observation-prev]').click();ok(node().getAttribute('aria-disabled')==='true','historical disabled');const text=d().querySelector('.an-cmos-lens').textContent;node().dispatchEvent(new MouseEvent('click',{bubbles:true}));node().dispatchEvent(new KeyboardEvent('keydown',{key:'Enter',bubbles:true}));ok(d().querySelector('.an-cmos-lens').textContent===text,'historical readonly');d().querySelector('[data-observation-live]').click();ok(input(key)===after[key],'live preserved');
 }
}
d().querySelector('[data-control-play]').click();d().querySelector('[data-cmos-switch]').dispatchEvent(new MouseEvent('click',{bubbles:true}));await wait(1150);ok(d().querySelector('[data-control-progress]').textContent==='尚未播放','direct toggle stops animation');
return {status:'passed',views:4,cases,checks};
}
