async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++};
 for(let a=0;a<32;a++)for(let b=0;b<32;b++){
  const s=Object.assign(anatomyState(),{av:a,bv:b}),e=anatomyEvaluate('tageq5',s);ok(e.result===+(a===b),'full equality');
  for(let i=0;i<5;i++){const av=Math.floor(a/(2**i))%2,bv=Math.floor(b/(2**i))%2;ok(e.nets['请求位'+i]===av&&e.nets['保存位'+i]===bv&&e.nets['不同位'+i]===+(av!==bv)&&e.nets['相同位'+i]===+(av===bv),'per-bit XOR and NOT');}
  ok(e.nets['低两位相等']===+(a%4===b%4)&&e.nets['中两位相等']===+(Math.floor(a/4)%4===Math.floor(b/4)%4)&&e.nets['低四位相等']===+(a%16===b%16),'AND tree');
 }
 const d=()=>document.querySelector('.anatomy-dialog[open]'),wait=()=>new Promise(r=>setTimeout(r,40)),out=()=>+d().querySelector('[data-coach-delta] b').textContent;d()?.querySelector('[data-an-close]').click();
 for(const [a,b]of [[0,16],[31,31],[15,31],[10,5]]){
  openArchitecture('tageq5');await wait();for(const [key,value]of [['av',a],['bv',b]]){const f=d().querySelector('[data-field="'+key+'"]');f.value=value;f.dispatchEvent(new Event('change',{bubbles:true}))}
  const state=Object.assign(anatomyState(),{av:a,bv:b}),e=anatomyEvaluate('tageq5',state);
  for(const part of ANATOMY.tageq5.parts.filter(p=>p.ref)){
   const net=ANATOMY.tageq5.nets.find(n=>n.from.startsWith(part.id+'.'));
   d().querySelector('[data-part="'+part.id+'"]').dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await wait();ok(out()===e.nets[net.name],'gate source/output '+part.id);d().querySelector('.an-context-path [data-context-id="tageq5"]').click();await wait();
  }
  d().querySelector('[data-an-close]').click();
 }
 return {status:'passed',checks,pairs:1024,gateDrilldowns:56};
}
