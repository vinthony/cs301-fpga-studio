async () => {
 document.querySelectorAll('.architecture-dialog').forEach(d=>{d.close();d.remove()});
 const checks=[],check=(v,n)=>{if(!v)throw Error(n);checks.push(n)};
 const ready=async()=>{for(let i=0;i<80&&!document.querySelector('[data-webgl="ready"]');i++)await new Promise(r=>setTimeout(r,25));check(!!document.querySelector('[data-webgl="ready"]'),'WebGL 场景就绪');};
 for(const id of [...new Set(['cpu',...Object.values(ARCH_ENTRY),'fulladder','and','dff','nmos','pmos'])]){
  openArchitecture(id);await ready();let host=document.querySelector('[data-webgl]');check(host.dataset.level===id,'3D 层级 '+id);check(Number(host.dataset.unitCount)===(ARCH[id].children.length||1),'3D 子单元 '+id);check(document.querySelectorAll('.arch-3d-host canvas').length===1,'单一画布 '+id);
  const range=document.querySelector('[data-explode]');range.value=100;range.dispatchEvent(new Event('input'));check(host.dataset.explode==='1','拆解 '+id);
  document.querySelector('[data-auto]').click();document.querySelector('[data-view-reset]').click();document.querySelector('.architecture-dialog').close();await new Promise(r=>setTimeout(r,30));check(!document.querySelector('.arch-3d-host canvas'),'关闭释放 '+id);
 }
 openArchitecture('not');await ready();let before=document.querySelector('[data-webgl]').dataset.output;document.querySelector('#archA').click();await ready();check(document.querySelector('[data-webgl]').dataset.output!==before,'三维状态随逻辑输入变化');
 document.querySelector('.architecture-dialog').close();await new Promise(r=>setTimeout(r,30));openArchitecture('cpu');await ready();
 return {passed:checks.length};
}
