async()=>{
let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},wait=ms=>new Promise(r=>setTimeout(r,ms)),d=()=>document.querySelector('.anatomy-dialog[open]'),click=s=>d().querySelector(s).click(),enter=part=>d().querySelector(`[data-part="${part}"]`).dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));
for(let a=0;a<2;a++)for(let q=0;q<2;q++)for(let enable=0;enable<2;enable++){
 const s=Object.assign(anatomyState(),{a,q,enable}),current=enable?a:q,child={a:current,b:a,cin:enable},doc=new DOMParser().parseFromString(anatomyStorageInputOrigin(ANATOMY.latch,'M',s,child),'text/html');
 for(const [key,value]of Object.entries(child)){const row=doc.querySelector(`[data-storage-origin="${key}"]`);ok(Number(row.dataset.originValue)===value,'latch actual source '+key);ok(Number(row.dataset.localValue)===value,'latch local '+key)}
}
d()?.querySelector('[data-an-close]').click();openArchitecture('latch');await wait(100);enter('M');await wait(100);
const row=key=>d().querySelector(`[data-storage-origin="${key}"]`);ok(Number(row('a').dataset.localValue)===1,'transparent feedback copies current Q, not stale raw q=0');ok(Number(row('a').dataset.originValue)===1,'feedback source current');click('[data-mux-toggle="a"]');ok(Number(row('a').dataset.localValue)===0,'local feedback input editable');click('[data-reread-parent]');await wait(80);ok(Number(row('a').dataset.localValue)===1,'reread actual feedback');click('[data-return-parent]');await wait(80);ok(d().querySelector('.an-watch').textContent.includes('Q1'),'parent output stays one');
for(const high of [false,true]){
 click('[data-an-close]');openArchitecture('dff');await wait(80);if(high){click('[data-tick]');click('[data-toggle="a"]')}
 for(const part of ['M','SL']){
  enter(part);await wait(80);const expected=high?part==='M'?[0,0,1]:[1,1,1]:part==='M'?[1,1,1]:[1,0,0];
  ['a','enable','q'].forEach((key,i)=>{ok(Number(row(key).dataset.originValue)===expected[i],'dff source '+high+part+key);ok(Number(row(key).dataset.localValue)===expected[i],'dff inherited '+high+part+key)});
  click('[data-toggle="a"]');click('[data-reread-parent]');await wait(80);ok(Number(row('a').dataset.localValue)===expected[0],'dff reread');click('[data-return-parent]');await wait(80);ok(Number(d().querySelector('[data-dff-saved]').textContent)===(high?1:0),'parent saved value preserved');
 }
}
return {status:'passed',checks};
}
