() => {
 document.querySelectorAll('.architecture-dialog').forEach(d=>{d.close();d.remove()});const checks=[],check=(v,n)=>{if(!v)throw Error(n);checks.push(n)},body=()=>document.querySelector('.architecture-dialog');
 check(Object.values(ARCH).every(u=>u.children.every(c=>ARCH[c])),'所有层级引用有效');
 for(const id of Object.keys(ARCH)){
  openArchitecture(id);check(body().open&&body().querySelector('.arch-layout h2').textContent===ARCH[id].name,'渲染 '+id);
  if(ARCH[id].children.length){let c=ARCH[id].children[0];body().querySelector('[data-unit]').click();check(body().querySelector('#archInspector h3').textContent===ARCH[c].name,'选择 '+id);body().querySelector('#archEnter').click();check(body().querySelector('.arch-layout h2').textContent===ARCH[c].name,'展开 '+id);body().querySelector('#archBack').click();check(body().querySelector('.arch-layout h2').textContent===ARCH[id].name,'返回 '+id)}
  body().querySelector('#archClose').click();body()?.remove();
 }
 for(const id of ['and','or','xor','nand','nor','not','mux','halfadder','fulladder','nmos','pmos','cmos']){
  openArchitecture(id);let before=body().querySelector('#archA').textContent;body().querySelector('#archA').click();check(body().querySelector('#archA').textContent!==before,'输入可改变 '+id);body().close();body()?.remove();
 }
 openArchitecture('dff');let old=body().querySelector('#archResult').textContent;body().querySelector('#archA').click();check(body().querySelector('#archResult').textContent.includes('Q=0'),'D 变化不直接改 Q');body().querySelector('#archTick').click();check(body().querySelector('#archResult').textContent.includes('边沿次数 1'),'触发器边沿');body().close();body()?.remove();
 openArchitecture('adder');let a=body().querySelector('#archA');body().querySelector('#archAdd').click();check(body().querySelectorAll('[data-fa]').length===4,'四个全加器可展开');let inputs=body().querySelectorAll('input');body().querySelector('#archNumA').value=15;body().querySelector('#archNumB').value=1;body().querySelector('#archAdd').click();check(body().querySelector('#archResult').textContent.includes('最终进位 1'),'加法溢出进位');body().querySelector('[data-fa]').click();check(body().querySelector('.arch-layout h2').textContent===ARCH.fulladder.name,'进位链下钻');body().close();body()?.remove();
 for(const t of TOPICS){openTopic(t.id,'',true);setTab('deep');document.querySelector('.architecture-launch').click();check(body().querySelector('.arch-layout h2').textContent===ARCH[ARCH_ENTRY[t.id]].name,'组件入口 '+t.id);body().close();body()?.remove()}
 openTopic('fpga','',true);setTab('deep');openArchitecture('system');return {passed:checks.length,units:Object.keys(ARCH).length};
}
