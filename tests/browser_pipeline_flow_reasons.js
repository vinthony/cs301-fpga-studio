async()=>{
 await anatomyLoadPipelineRTL();let checks=0;const kinds=new Set(),ok=(v,n)=>{if(!v)throw Error(n);checks++};
 for(const p of AN_PIPE32_RTL_DATA.programs)for(const mode of ['stall','forward'])for(let cycle=2;cycle<=p.traces[mode].length;cycle++){
  const flow=anatomyPipelineRTLFlow(p,mode,cycle),doc=new DOMParser().parseFromString(anatomyPipelineRTLFlowMarkup(p,mode,cycle),'text/html');
  ok(doc.querySelectorAll('[data-rtl-flow-arrival]').length===flow.arrivals.length,'all arrivals drawn');
  for(const e of flow.edges){kinds.add(e.reason);if(e.kind!=='advance')ok(doc.querySelector('[data-rtl-flow-reason="'+e.id+'"]').textContent.includes(e.reason),'reason visible');}
 }
 for(const reason of ['正常退休','跳转冲刷','异常清除年轻指令','异常/断点在WB停止','保持'])ok(kinds.has(reason),'covered '+reason);
 const panel=document.querySelector('.anatomy-dialog[open] .pipe32-rtl'),flow=panel.querySelector('.pipe32-rtl-flow');panel.open=true;flow.open=true;
 const before=document.querySelector('.an-watch').textContent;flow.querySelector('[data-rtl-flow-play]').click();await new Promise(r=>setTimeout(r,1400));
 ok(before===document.querySelector('.an-watch').textContent,'playback read only');ok(flow.querySelector('[role=status]').textContent.includes('回放结束')||matchMedia('(prefers-reduced-motion: reduce)').matches,'completion status');
 return {status:'passed',checks,reasons:[...kinds]};
}
