async()=>{
 const checks=[],ok=(v,n)=>{if(!v)throw Error(n);checks.push(n)},wait=ms=>new Promise(r=>setTimeout(r,ms));
 for(const id of ['fulladder','dff','bram','regfile32','decoder32','cpu32']){
  document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture(id);await wait(220);const d=document.querySelector('.anatomy-dialog[open]'),b=ANATOMY[id],n=b.nets[0],history=d.querySelector('[data-observation-range]').max;
  const pick=()=>[...d.querySelectorAll('[data-net]')].find(x=>x.dataset.net===n.name).click();
  for(const endpoint of [n.from,n.to]){pick();const part=endpoint.split('.')[0],button=[...d.querySelectorAll('[data-follow-part]')].find(x=>x.dataset.followPart===part);ok(!!button,id+' 端点可追踪 '+part);button.click();ok(d.querySelector('.an-inspector .an-tag').textContent.startsWith(part+' ·'),id+' 定位正确器件 '+part);ok(d.querySelector('.an-scene [data-diagram-part="'+part+'"]').classList.contains('selected'),id+' 主图选中 '+part);}
  ok(d.querySelector('[data-observation-range]').max===history,id+' 追踪不改变状态');
 }
 return {status:'passed',views:6,checks:checks.length};
}
