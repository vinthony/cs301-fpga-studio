async()=>{
let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},wait=ms=>new Promise(r=>setTimeout(r,ms)),d=()=>document.querySelector('.anatomy-dialog[open]'),click=s=>d().querySelector(s).click();
for(let clk=0;clk<2;clk++)for(let a=0;a<2;a++)for(let q=0;q<2;q++)for(let master=0;master<2;master++){
 const s=Object.assign(anatomyState(),{clk,a,q,master}),doc=new DOMParser().parseFromString(anatomyDFFPhases(s),'text/html');ok(Number(doc.querySelector('[data-dff-phase="M"]').dataset.value)===(clk?master:a),'master actual');ok(Number(doc.querySelector('[data-dff-phase="SL"]').dataset.value)===q,'slave actual');ok(Number(doc.querySelector('[data-dff-phase="M"]').dataset.transparent)===1-clk,'master enable');ok(Number(doc.querySelector('[data-dff-phase="SL"]').dataset.transparent)===clk,'slave enable');
}
d()?.querySelector('[data-an-close]').click();openArchitecture('dff',{focus:true});await wait(150);
const saved=()=>Number(d().querySelector('[data-dff-saved]').textContent),master=()=>Number(d().querySelector('[data-dff-phase="M"]').dataset.value);
ok(saved()===0&&master()===1,'initial low master follows D');click('[data-tick]');ok(saved()===1,'rising captures D');ok(d().querySelector('[data-tick]').disabled,'already high no second edge');click('[data-toggle="a"]');ok(saved()===1&&master()===1,'D changed while high master and Q hold');ok(d().querySelector('[data-dff-next]').textContent==='0','next candidate distinct');click('[data-clock-low]');ok(master()===0&&saved()===1,'low master follows, Q holds');click('[data-tick]');ok(saved()===0,'next rising captures zero');
for(const part of ['M','SL']){click(`[data-storage-stage="${part}"]`);ok(d().querySelector('.an-inspector .an-tag').textContent.startsWith(part+' ·'),'actual stage '+part)}
click('[data-observation-prev]');ok(d().querySelector('[data-tick]').disabled,'history readonly');ok(saved()===1,'previous snapshot actual Q');click('[data-observation-live]');ok(saved()===0,'return live Q unchanged');return {status:'passed',states:16,checks};
}
