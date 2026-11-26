async()=>{
let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},wait=ms=>new Promise(r=>setTimeout(r,ms)),d=()=>document.querySelector('.anatomy-dialog[open]'),click=s=>d().querySelector(s).click();
d()?.querySelector('[data-an-close]').click();openArchitecture('registerControl');await wait(200);
const initial=[...d().querySelectorAll('[data-toggle]')].map(n=>n.getAttribute('aria-pressed')).join();
click('[data-control-next]');ok(d().querySelector('[aria-current="step"]').dataset.controlStage==='EN','first stage');
click('[data-control-next]');ok(d().querySelector('[aria-current="step"]').dataset.controlStage==='RESET','second stage');
click('[data-control-rewind]');ok(!d().querySelector('[aria-current="step"]'),'rewind');
click('[data-control-play]');await wait(1150);click('[data-control-play]');const progress=d().querySelector('[data-control-progress]').textContent;
await wait(1100);ok(d().querySelector('[data-control-progress]').textContent===progress,'pause stable');
click('[data-control-play]');await wait(1200);ok(d().querySelector('[aria-current="step"]').dataset.controlStage==='OUT','play finishes');ok(d().querySelector('[data-control-play]').getAttribute('aria-pressed')==='false','automatic stop');
ok([...d().querySelectorAll('[data-toggle]')].map(n=>n.getAttribute('aria-pressed')).join()===initial,'inputs remain unchanged');
click('[data-control-play]');click('[data-control-case="15"]');ok(d().querySelector('[data-control-progress]').textContent==='尚未播放','new conditions reset explanation');await wait(1200);ok(d().querySelector('[data-control-progress]').textContent==='尚未播放','old timer disposed');
const old=d().querySelector('.an-control-lens');click('[data-control-play]');click('[data-an-close]');await wait(1200);ok(!old.isConnected,'close disposes playback');
openArchitecture('registerControl');await wait(200);return {status:'passed',checks};
}
