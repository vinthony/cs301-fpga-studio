async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},wait=ms=>new Promise(r=>setTimeout(r,ms)),dialog=()=>document.querySelector('.anatomy-dialog[open]'),click=s=>dialog().querySelector(s).click();
 for(let k=0;k<8;k++){
  const s=Object.assign(anatomyState(),{a:k>>2,b:(k>>1)&1,cin:k&1}),e=anatomyEvaluate('fulladder',s),doc=new DOMParser().parseFromString(anatomyFullAdderWalk(s),'text/html');
  const expected={X1:s.a^s.b,X2:(k.toString(2).split('1').length-1)%2,G1:s.a&s.b,G2:(s.a^s.b)&s.cin,O:+(s.a+s.b+s.cin>=2)},nets={X1:'P',X2:'S',G1:'G',G2:'H',O:'Cout'};
  for(const [part,value]of Object.entries(expected)){ok(doc.querySelector(`[data-control-stage="${part}"]`).textContent.endsWith('= '+value),'expression '+k+part);ok(e.nets[nets[part]]===value,'actual net '+k+part)}
 }
 dialog()?.querySelector('[data-an-close]').click();openArchitecture('fulladder');await wait(250);
 const input=()=>[...dialog().querySelectorAll('[data-toggle]')].map(n=>n.getAttribute('aria-pressed')).join();const initial=input();
 for(const part of ['X1','X2','G1','G2','O']){click('[data-control-next]');ok(dialog().querySelector('[aria-current="step"]').dataset.controlStage===part,'step '+part);ok(dialog().querySelector('.an-inspector').textContent.includes(part),'inspector '+part)}
 ok(input()===initial,'no input mutation');ok(dialog().querySelector('[data-control-next]').disabled,'end disabled');
 click('[data-control-rewind]');ok(!dialog().querySelector('[aria-current="step"]'),'rewind');click('[data-control-play]');await wait(1100);click('[data-control-play]');const progress=dialog().querySelector('[data-control-progress]').textContent;await wait(1100);ok(dialog().querySelector('[data-control-progress]').textContent===progress,'pause stable');
 click('[data-control-play]');click('[data-toggle="a"]');ok(dialog().querySelector('[data-control-progress]').textContent==='尚未播放','input resets');await wait(1100);ok(dialog().querySelector('[data-control-progress]').textContent==='尚未播放','old timer stopped');
 return {status:'passed',cases:8,checks};
}
