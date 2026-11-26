async () => {
 const checks=[],ok=(v,n)=>{if(!v)throw Error(n);checks.push(n)},rows=[];
 const ready=async id=>{for(let i=0;i<150;i++){const d=document.querySelector('.anatomy-dialog[open]'),h=d?.querySelector('.an-scene');if(d?.dataset.view===id&&h?.dataset.render==='ready')return d;if(h?.dataset.render==='fallback')throw Error('绘图回退 '+id);await new Promise(r=>setTimeout(r,10))}throw Error('超时 '+id)};
 for(const id of Object.keys(ANATOMY)){
  openArchitecture(id);const d=await ready(id),before=d.querySelector('.an-watch').textContent;let edits=0;
  ok(d.querySelector('.an-context')?.dataset.contextCurrent===id,'位置小窗 '+id);ok(d.querySelector('[aria-current="location"]')?.dataset.contextId===id,'位置路径 '+id);
  ok(d.querySelector('.an-live-io strong')?.textContent!=='—','本层有输出 '+id);
  const keys=[...d.querySelectorAll('.an-lab-controls [data-field]')].map(e=>e.dataset.field);
  for(const key of keys){const input=d.querySelector('[data-field="'+key+'"]');if(input.tagName==='SELECT'){input.selectedIndex=(input.selectedIndex+1)%input.options.length}else{const min=Number(input.min||0),max=Number(input.max||65535),v=Number(input.value);input.value=String(v<max?v+1:min)}input.dispatchEvent(new Event('change',{bubbles:true}));edits++}
  const bits=[...d.querySelectorAll('.an-lab-controls [data-toggle]')].map(e=>e.dataset.toggle);for(const key of bits){d.querySelector('[data-toggle="'+key+'"]').click();edits++}
  const sw=d.querySelector('[data-sw-bit]');if(sw){sw.click();edits++}
  const actions=[...d.querySelectorAll('[data-experiment-action]')].map(e=>e.dataset.experimentAction);for(const action of actions){d.querySelector('[data-experiment-action="'+action+'"]').click();edits++}
  if(d.querySelector('[data-tick]:not(:disabled)')){d.querySelector('[data-tick]').click();edits++}
  if(!edits){const input=d.querySelector('[data-power-toggle]');input?.click();if(input)edits++}
  ok(edits>0,'有实际实验操作 '+id);ok(!d.querySelector('.an-lab-error')?.textContent,'输入有效 '+id);ok(d.querySelector('.an-watch').textContent!==before||d.querySelectorAll('.an-observation-log li').length>1,'观察状态变化 '+id);
  rows.push({id,edits,signals:ANATOMY[id].nets.length,context:true});
 }
 // Verify actual graph gestures and held state, beyond merely finding a control.
 openArchitecture('nmos');let d=await ready('nmos'),channel=d.querySelector('.an-scene .sc-material-channel'),value=channel.dataset.conducting;d.querySelector('.an-scene [data-diagram-part="GATE"]').dispatchEvent(new MouseEvent('click',{bubbles:true}));ok(channel.dataset.conducting!==value,'材料层图内栅极直接切换通路');
 openArchitecture('lut');d=await ready('lut');let cell=d.querySelector('.an-scene [data-lut-cell="1"]'),old=cell.getAttribute('fill');cell.dispatchEvent(new MouseEvent('click',{bubbles:true}));ok(cell.getAttribute('fill')!==old,'图内配置单元可编辑');
 openArchitecture('pc');d=await ready('pc');d.querySelector('[data-experiment-action="tick"]').click();ok(d.querySelector('.an-live-io strong').textContent==='4','PC边沿实时输出4');ok(d.querySelector('.an-scene [data-diagram-part="Q"]').dataset.value==='4','PC图内值联动');
 d.querySelector('[data-context-expand]').click();ok(!!d.querySelector('.an-context-zoom[open] svg'),'整体位置图可放大');d.querySelector('[data-close-context]').click();await new Promise(r=>setTimeout(r,10));d.querySelector('[data-context-id="cpu"]').dispatchEvent(new MouseEvent('click',{bubbles:true}));await ready('cpu');ok(document.querySelector('.anatomy-dialog[open]').dataset.view==='cpu','位置路径可返回关联上级');
 return {passed:checks.length,views:rows.length,rows};
}
