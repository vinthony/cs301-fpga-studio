async () => {
 const {mountSchematic}=await import('./anatomy-schematic.js');
 const rows=[],issues=[];
 for(const [id,b]of Object.entries(ANATOMY)){
  if(id==='board')continue;
  const host=document.createElement('div');host.style.cssText='position:absolute;left:-10000px;width:1500px';document.body.append(host);
  const drawing=mountSchematic(host,b,()=>{},()=>{}),state=anatomyState();drawing.update(state,anatomyEvaluate(id,state));
  const svg=host.querySelector('svg'),vb=svg.viewBox.baseVal,ts=[...svg.querySelectorAll('text')];
  const fallback=JSON.parse(host.dataset.routeFallbacks);if(fallback.length)issues.push({id,fallback});
  for(const t of ts){const a=t.getBBox();if(a.x<0||a.y<0||a.x+a.width>vb.width+1||a.y+a.height>vb.height+1)issues.push({id,clipped:t.textContent})}
  for(let i=0;i<ts.length;i++)for(let j=i+1;j<ts.length;j++){
   const a=ts[i].getBBox(),z=ts[j].getBBox();
   if(Math.min(a.x+a.width,z.x+z.width)-Math.max(a.x,z.x)>2&&Math.min(a.y+a.height,z.y+z.height)-Math.max(a.y,z.y)>2)issues.push({id,overlap:[ts[i].textContent,ts[j].textContent]});
  }
  if(b.parts.length!==svg.querySelectorAll('[data-diagram-part]').length||b.nets.length!==svg.querySelectorAll('[data-diagram-net]').length)issues.push({id,missing:true});
  rows.push({id,parts:b.parts.length,nets:b.nets.length,texts:ts.length});drawing.dispose();host.remove();
 }
 if(issues.length)throw Error(JSON.stringify(issues));
 return {views:rows.length,issues,rows};
}
