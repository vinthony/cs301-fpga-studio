async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},d=()=>document.querySelector('.anatomy-dialog[open]'),wait=()=>new Promise(r=>setTimeout(r,100)),out=()=>+d().querySelector('[data-coach-delta] b').textContent;
 for(let duty=0;duty<=16;duty++)for(let phase=0;phase<16;phase++){
  const state=anatomyState();Object.assign(state,{duty,phase});const e=anatomyEvaluate('leddriver',state);
  ok(e.nets['阴极接地']===0&&e.partValues.GND===0,'ground stays zero');
  ok(e.nets['LED支路']===+(phase<duty)&&e.partValues.LED===+(phase<duty),'LED active level independent of grounded cathode');
 }
 d()?.querySelector('[data-an-close]').click();openArchitecture('leddriver');await wait();
 for(const [duty,phase] of [[0,0],[1,0],[1,1],[15,15],[16,15]]){
  d().querySelector('[data-lab-reset]').click();
  const input=d().querySelector('[data-field="duty"]');input.value=duty;input.dispatchEvent(new Event('change',{bubbles:true}));
  for(let i=0;i<phase;i++)d().querySelector('[data-tick]').click();
  const expected=+(phase<duty),symbol=d().querySelector('.an-scene [data-diagram-part="LED"]');
  ok(ANATOMY.leddriver.parts.find(p=>p.id==='LED').type==='diode'&&symbol.querySelectorAll('circle').length===2&&[...symbol.querySelectorAll('path')].some(p=>p.getAttribute('fill')===(expected?'#e88775':'#fff')),'single diode rather than indicator bank');
  ok(out()===expected,'parent PWM level');
  d().querySelector('[data-part="LED"]').dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await wait();
  ok(d().dataset.view==='ledjunction'&&out()===expected,'junction inherits current comparator output');
  d().querySelector('[data-toggle="a"]').click();ok(out()===1-expected,'junction independently interactive');
  d().querySelector('[data-reread-parent]').click();await wait();ok(out()===expected,'reread current PWM level');
  d().querySelector('.an-context-path [data-context-id="leddriver"]').click();await wait();ok(out()===expected&&+d().querySelector('[data-field="duty"]').value===duty,'child never changes parent');
 }
 return {status:'passed',checks};
}
