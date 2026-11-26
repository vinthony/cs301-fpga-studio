async()=>{
let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},wait=ms=>new Promise(r=>setTimeout(r,ms)),d=()=>document.querySelector('.anatomy-dialog[open]');
d()?.querySelector('[data-an-close]').click();openArchitecture('fulladder',{focus:true});await wait(250);
for(let k=0;k<8;k++){
 d().querySelector(`[data-truth-row="${k}"]`).click();
 const a=k>>2,b=(k>>1)&1,c=k&1,total=a+b+c,box=d().querySelector('.an-add-regroup'),row=d().querySelector('.an-truth-table tr.selected');
 ok(box.querySelectorAll('.an-add-input-tokens .one').length===total,'input units '+k);
 ok(box.querySelectorAll('.an-add-pair .one').length===2*Math.floor(total/2),'pair units '+k);
 ok(box.querySelectorAll('.an-add-output-tokens>div:last-child .one').length===total%2,'remainder '+k);
 const inputs=[...d().querySelectorAll('[data-toggle]')].map(n=>n.getAttribute('aria-pressed')==='true'?1:0);
 ok(inputs.join('')===[a,b,c].join(''),'actual inputs '+k);
 const expected=a&&b?'A、B产生':total>=2?'Cin传播':'无进位';ok(row.querySelector('.an-carry-origin').textContent===expected,'carry origin '+k);
 ok(d().querySelector('[data-control-progress]').textContent==='尚未播放','fresh animation '+k);
 ok(d().querySelector('.an-fulladder-walk').textContent.includes(`S=${total%2}，Cout=${Math.floor(total/2)}`),'live outputs '+k);
 ok(document.activeElement.dataset.truthRow===String(k),'keyboard focus '+k);
}
d().querySelector('[data-control-play]').click();d().querySelector('[data-truth-row="0"]').click();await wait(1150);ok(d().querySelector('[data-control-progress]').textContent==='尚未播放','table change stops old timer');
return {status:'passed',cases:8,checks};
}
