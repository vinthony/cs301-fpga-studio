async()=>{
let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},wait=ms=>new Promise(r=>setTimeout(r,ms)),d=()=>document.querySelector('.anatomy-dialog[open]'),click=s=>d().querySelector(s).click(),toggle=(key,value)=>{const n=d().querySelector(`[data-toggle="${key}"]`);if((n.getAttribute('aria-pressed')==='true'?1:0)!==value)n.click()};
d()?.querySelector('[data-an-close]').click();openArchitecture('register8');await wait(120);click('[data-reg8-scenario="capture"]');click('[data-experiment-action="tick"]');const field=d().querySelector('[data-field="av"]');field.value='90';field.dispatchEvent(new Event('change',{bubbles:true}));
for(let reset=0;reset<2;reset++)for(let enable=0;enable<2;enable++){
 toggle('reset',reset);toggle('enable',enable);
 for(let bit=0;bit<8;bit++)for(const kind of ['C','F']){
  const part=kind+bit,raw=(90>>>bit)&1,saved=(165>>>bit)&1,candidate=reset?0:enable?raw:saved;d().querySelector(`[data-part="${part}"]`).dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await wait(35);
  ok(d().querySelectorAll('.an-origin-byte [aria-current="true"]').length===2,'both words locate bit');ok([...d().querySelectorAll('.an-origin-byte [aria-current="true"]')].every(n=>Number(n.dataset.regbitIndex)===bit),'correct bit index');
  const expected=kind==='C'?{a:raw,b:saved,enable,reset}:{a:candidate,q:saved};for(const [key,value]of Object.entries(expected)){const row=d().querySelector(`[data-regbit-origin="${key}"]`);ok(Number(row.dataset.originValue)===value,'actual parent source '+part+key);ok(Number(row.dataset.localValue)===value,'copied child '+part+key)}
  click('[data-toggle="a"]');click('[data-reread-parent]');await wait(35);ok(Number(d().querySelector('[data-regbit-origin="a"]').dataset.localValue)===expected.a,'reread '+part);
  const source=d().querySelector('[data-regbit-origin="a"] [data-trace-parent-net]');source.click();await wait(35);ok(d().dataset.view==='register8','source returns byte');ok(d().querySelector('.an-inspector h3').textContent===(kind==='C'?'D':'候选')+bit,'specific source net');ok(d().querySelector('[data-register-q]').textContent==='10100101','byte not modified');
 }
}
return {status:'passed',bits:8,cases:64,checks};
}
