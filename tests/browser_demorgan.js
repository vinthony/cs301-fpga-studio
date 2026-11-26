async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},d=()=>document.querySelector('.anatomy-dialog[open]'),wait=()=>new Promise(r=>setTimeout(r,50));d()?.querySelector('[data-an-close]').click();
 for(const [id,expected]of [['demorganNand',[1,1,1,0]],['demorganNor',[1,0,0,0]]]){
  openArchitecture(id);await wait();
  for(let input=0;input<4;input++){
   d().querySelector('[data-demorgan-case="'+input+'"]').click();const s=Object.assign(anatomyState(),{a:input>>>1,b:input&1}),e=anatomyEvaluate(id,s);
   ok(e.result===expected[input]&&e.nets['原式结果']===expected[input]&&e.nets['变换式结果']===expected[input],'independent full truth table');
   ok(d().querySelector('[data-demorgan-truth="'+input+'"]').getAttribute('aria-current')==='true'&&+d().querySelector('[data-coach-delta] b').textContent===expected[input],'selected truth row updates actual model');
   for(const part of ANATOMY[id].parts.filter(p=>p.ref)){
    const net=ANATOMY[id].nets.find(n=>n.from.startsWith(part.id+'.'));d().querySelector('[data-part="'+part.id+'"]').dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await wait();ok(+d().querySelector('[data-coach-delta] b').textContent===e.nets[net.name],'corresponding gate source '+part.id);d().querySelector('.an-context-path [data-context-id="'+id+'"]').click();await wait();
   }
  }
  d().querySelector('[data-observation-prev]').click();const before=d().querySelector('[data-coach-delta] b').textContent;d().querySelector('[data-demorgan-case="0"]').click();ok(d().querySelector('[data-coach-delta] b').textContent===before,'history protects truth case');d().querySelector('[data-observation-live]').click();d().querySelector('[data-an-close]').click();
 }
 const map=await (await fetch('course-map.json')).json();ok(['demorganNand','demorganNor'].every(id=>map.weeks[2].views.includes(id)&&ANATOMY[id]),'course week3 entries exist');return {status:'passed',checks,laws:2,gateDrilldowns:32};
}
