async()=>{
let checks=0,cases=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},wait=ms=>new Promise(r=>setTimeout(r,ms)),d=()=>document.querySelector('.anatomy-dialog[open]');
for(const id of ['nand','nor','not','cmos']){
 d()?.querySelector('[data-an-close]').click();openArchitecture(id);await wait(100);const two=['nand','nor'].includes(id);
 for(let k=0;k<(two?4:2);k++){
  cases++;d().querySelector(`[data-truth-row="${k}"]`).click();const a=two?k>>1:k,b=k&1,y=id==='nand'?+(a+b<2):id==='nor'?+(a+b===0):1-a;
  const lens=d().querySelector('.an-cmos-lens'),up=lens.querySelector('[data-cmos-network="up"]'),down=lens.querySelector('[data-cmos-network="down"]');
  ok(Number(up.dataset.connected)===y,'up '+id+k);ok(Number(down.dataset.connected)===1-y,'down '+id+k);ok(Number(lens.querySelector('[data-cmos-verdict]').dataset.output)===y,'output '+id+k);
  ok(up.querySelectorAll('[data-cmos-path]').length===(id==='nand'?2:1),'pullup topology');ok(down.querySelectorAll('[data-cmos-path]').length===(id==='nor'?2:1),'pulldown topology');
  const range=d().querySelector('[data-observation-range]').max;
  for(const btn of lens.querySelectorAll('[data-control-stage]')){btn.click();ok(d().querySelector('.an-inspector .an-tag').textContent.startsWith(btn.dataset.controlStage+' ·'),'actual part selected')}
  ok(d().querySelector('[data-observation-range]').max===range,'explanation no model edge');
 }
}
d().querySelector('[data-control-rewind]').click();d().querySelector('[data-control-play]').click();await wait(1100);d().querySelector('[data-control-play]').click();const stage=d().querySelector('[data-control-progress]').textContent;await wait(1100);ok(d().querySelector('[data-control-progress]').textContent===stage,'pause');
d().querySelector('[data-control-play]').click();d().querySelector('[data-toggle="a"]').click();await wait(1100);ok(d().querySelector('[data-control-progress]').textContent==='尚未播放','input stops old timer');
return {status:'passed',views:4,cases,checks};
}
