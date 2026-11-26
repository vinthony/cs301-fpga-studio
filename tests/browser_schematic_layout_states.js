async () => {
 const {mountSchematic}=await import('./anatomy-schematic.js');
 const rows=[],issues=[];
 const bounds=n=>{const a=n.getBBox(),m=n.ownerSVGElement.getCTM().inverse().multiply(n.getCTM()),points=[[a.x,a.y],[a.x+a.width,a.y],[a.x,a.y+a.height],[a.x+a.width,a.y+a.height]].map(([x,y])=>new DOMPoint(x,y).matrixTransform(m));const x=Math.min(...points.map(p=>p.x)),y=Math.min(...points.map(p=>p.y));return{x,y,width:Math.max(...points.map(p=>p.x))-x,height:Math.max(...points.map(p=>p.y))-y}};
 for(const [id,b]of Object.entries(ANATOMY)){
  if(id==='board')continue;
  const host=document.createElement('div');host.style.cssText='position:absolute;left:-10000px;width:1500px';document.body.append(host);
  const drawing=mountSchematic(host,b,()=>{},()=>{});
  for(const mode of ['default','min','max']){const state=anatomyState();if(mode!=='default')for(const f of AN_EXPERIMENTS[id]?.fields||[]){if(f.type==='number')state[f.key]=mode==='min'?f.min:f.max;if(f.type==='toggle')state[f.key]=+(mode==='max')};drawing.update(state,anatomyEvaluate(id,state));
  const svg=host.querySelector('svg'),vb=svg.viewBox.baseVal,ts=[...svg.querySelectorAll('text')];
  const fallback=JSON.parse(host.dataset.routeFallbacks);if(fallback.length)issues.push({id,fallback});
  for(const t of ts){const a=bounds(t);if(a.x<0||a.y<0||a.x+a.width>vb.width+1||a.y+a.height>vb.height+1)issues.push({id,clipped:t.textContent})}
  for(let i=0;i<ts.length;i++)for(let j=i+1;j<ts.length;j++){
   const a=bounds(ts[i]),z=bounds(ts[j]);
   if(Math.min(a.x+a.width,z.x+z.width)-Math.max(a.x,z.x)>2&&Math.min(a.y+a.height,z.y+z.height)-Math.max(a.y,z.y)>2)issues.push({id,overlap:[ts[i].textContent,ts[j].textContent]});
  }
  if(b.parts.length!==svg.querySelectorAll('[data-diagram-part]').length||b.nets.length!==svg.querySelectorAll('[data-diagram-net]').length)issues.push({id,missing:true});
  rows.push({id,mode,parts:b.parts.length,nets:b.nets.length,texts:ts.length});}drawing.dispose();host.remove();
 }
 
 return {states:rows.length,issues};
}
