async()=>{
let checks=0,steps=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},d=()=>document.querySelector('.anatomy-dialog[open]'),ready=async id=>{for(let n=0;n<120;n++){if(d()?.dataset.view===id&&d().querySelector('.an-scene')?.dataset.render==='ready')return;await new Promise(r=>setTimeout(r,10))}throw Error('not ready '+id)};
for(let index=0;index<ANATOMY_ROUTES.length;index++){
 d()?.querySelector('[data-an-close]').click();openArchitecture('board');await ready('board');d().querySelector('.an-route-menu').open=true;d().querySelector('[data-route="'+index+'"]').click();
 const route=ANATOMY_ROUTES[index];for(let i=0;i<route.ids.length;i++){
  await ready(route.ids[i]);const box=d().querySelector('.an-route-now');ok(box.textContent.includes('第 '+(i+1)+' / '+route.ids.length+' 步'),'step '+route.name+'/'+i);ok(!!box.querySelector('.an-route-task'),'real input and observation prompts '+route.ids[i]);ok(!box.textContent.includes('undefined'),'no missing hint');steps++;
  if(i<route.ids.length-1){const options=box.querySelector('[data-route-instance]');if(options)ok(options.options.length>1,'specific instance choice');box.querySelector('[data-route-next]').click()}else ok(!box.querySelector('[data-route-next]'),'no false next after end');
 }
}
return {status:'passed',routes:ANATOMY_ROUTES.length,steps,checks};
}
