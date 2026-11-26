async () => {
 let checks=0;const rows=[],ok=(value,name)=>{if(!value)throw Error(name);checks++};
 const ready=async id=>{for(let i=0;i<100;i++){const d=document.querySelector('.anatomy-dialog[open]');if(d?.dataset.view===id&&d.querySelector('.an-scene')?.dataset.render==='ready')return d;await new Promise(r=>setTimeout(r,10))}throw Error('未就绪 '+id)};
 for(const id of Object.keys(ANATOMY)){
  openArchitecture(id);const d=await ready(id),toggle=d.querySelector('.an-lab-controls [data-toggle]'),field=d.querySelector('.an-lab-controls [data-field]');
  if(toggle)toggle.click();else if(field){if(field.tagName==='SELECT')field.selectedIndex=(field.selectedIndex+1)%field.options.length;else field.value=String(Number(field.value)<Number(field.max||65535)?Number(field.value)+1:Number(field.min||0));field.dispatchEvent(new Event('change',{bubbles:true}))}else{const action=d.querySelector('[data-sw-bit],[data-power-toggle],[data-tick]:not(:disabled),[data-experiment-action]:not(:disabled)');if(action)action.click()}
  ok(Number(d.querySelector('[data-observation-range]').max)>0,'产生真实新记录 '+id);const expected=d.querySelector('.an-watch').textContent,netValues=d.querySelector('.an-live-nets')?.textContent;
  d.querySelector('[data-observation-prev]').click();ok(d.dataset.observationMode==='paused','每层均可回看 '+id);ok([...d.querySelectorAll('.an-lab-controls input,.an-lab-controls select,.an-lab-controls button:not([data-observe-section])')].every(x=>x.disabled),'每层历史均只读 '+id);
  d.querySelector('[data-observation-live]').click();ok(d.querySelector('.an-watch').textContent===expected,'每层回到相同现场 '+id);ok(d.querySelector('.an-live-nets')?.textContent===netValues,'每层信号现场未被重放改写 '+id);
  const wave=d.querySelector('.an-wave-svg');ok(!!wave&&Number(wave.getAttribute('width'))===(['alu32','regfile32','immgen32','cpu32'].includes(id)?88:44)*(Number(d.querySelector('[data-observation-range]').max)+1),'每层观察列保持固定比例 '+id);rows.push({id,replay:true,readOnly:true,liveUnchanged:true});
 }
 return {passed:checks,views:rows.length,rows};
}
