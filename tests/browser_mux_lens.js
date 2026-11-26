async()=>{
let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},wait=ms=>new Promise(r=>setTimeout(r,ms)),d=()=>document.querySelector('.anatomy-dialog[open]'),click=s=>d().querySelector(s).click(),out=()=>Number(d().querySelector('[data-mux-output]').dataset.muxOutput);
d()?.querySelector('[data-an-close]').click();openArchitecture('mux',{focus:true});await wait(150);
for(let k=0;k<8;k++){
 click(`[data-truth-row="${k}"]`);const a=k>>2,b=(k>>1)&1,c=k&1,y=c?b:a,selected=c?'b':'a',unselected=c?'a':'b';
 ok(out()===y,'output '+k);ok(d().querySelector('.an-mux-route.chosen').dataset.muxRoute===selected,'selected source '+k);ok(d().querySelectorAll('.an-mux-route.chosen').length===1,'unique path '+k);
 click(`[data-mux-toggle="${unselected}"]`);ok(out()===y,'unselected input has no effect '+k);ok(document.activeElement.dataset.muxToggle===unselected,'data focus '+k);
 click(`[data-mux-toggle="${selected}"]`);ok(out()===1-y,'selected input changes output '+k);
 click(`[data-mux-select="${1-c}"]`);ok(out()===(c?1-a:1-b),'selection changes source '+k);ok(document.activeElement.dataset.muxSelect===String(1-c),'selection focus '+k);
 click(`[data-truth-row="${k}"]`);for(const part of ['I','G0','G1','O']){click('[data-control-next]');ok(d().querySelector('[aria-current="step"]').dataset.controlStage===part,'stage '+part+k);ok(d().querySelector('.an-inspector .an-tag').textContent.startsWith(part+' ·'),'actual part '+part+k)}
}
click('[data-truth-row="0"]');click('[data-mux-select="1"]');ok(out()===0,'selected path can carry zero');click('[data-control-play]');click('[data-mux-toggle="b"]');await wait(1150);ok(d().querySelector('[data-control-progress]').textContent==='尚未播放','input cancels animation');
const live=out();click('[data-observation-prev]');ok(d().querySelector('[data-mux-toggle="a"]').disabled,'historical control disabled');const old=out();click('[data-mux-toggle="a"]');ok(out()===old,'history readonly');click('[data-observation-live]');ok(out()===live,'live preserved');
return {status:'passed',cases:8,checks};
}
