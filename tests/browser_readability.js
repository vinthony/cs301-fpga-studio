async()=>{
 let checks=0;const issues=[],views=[],wait=()=>new Promise(r=>setTimeout(r,30));
 for(const id of Object.keys(ANATOMY)){
  document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture(id);await wait();for(let attempt=0;attempt<60&&document.querySelector('.anatomy-dialog[open] .an-scene')?.dataset.render!=='ready';attempt++)await wait();
  const d=document.querySelector('.anatomy-dialog[open]'),scene=d.querySelector('.an-scene'),svg=scene.querySelector(':scope>svg');
  if(scene.dataset.render!=='ready'){issues.push({id,render:scene.dataset.render});continue}
  for(const sel of ['.anatomy-content','.an-main','.an-sidebar','.an-lab-controls','.anatomy-header']){const n=d.querySelector(sel);if(n){checks++;if(n.scrollWidth>n.clientWidth+3)issues.push({id,overflow:sel,extra:n.scrollWidth-n.clientWidth})}}
  if(svg){checks++;if(Math.abs(svg.getBoundingClientRect().width-svg.viewBox.baseVal.width)>2)issues.push({id,defaultNotNative:true});d.querySelector('[data-zoom-readable]').click();const sizes=[...svg.querySelectorAll('text')].filter(n=>n.textContent.trim()&&n.getBBox().width>0).map(n=>parseFloat(getComputedStyle(n).fontSize)*Math.hypot(n.getScreenCTM().a,n.getScreenCTM().b));const min=Math.min(...sizes);checks++;if(min<15.8)issues.push({id,tiny:min});
   const ratio=svg.getBoundingClientRect().width/svg.getBoundingClientRect().height;checks++;if(Math.abs(ratio-svg.viewBox.baseVal.width/svg.viewBox.baseVal.height)>.01)issues.push({id,distorted:true});
   d.querySelector('[data-zoom-fit]').click();checks++;if(svg.getBoundingClientRect().width>scene.clientWidth+2)issues.push({id,overviewOverflow:true});d.querySelector('[data-zoom-readable]').click();
  }
  views.push(id)
 }
 return {views:views.length,checks,width:innerWidth,issues};
}
