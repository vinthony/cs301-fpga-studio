async () => {
 const checks=[];const check=(ok,name)=>{if(!ok)throw Error(name);checks.push(name)};
 loadLesson(LESSONS.find(l=>l.id==='led'));await queue;
 let b=$('key4');b.onkeydown({key:'Enter',repeat:false,preventDefault(){}});await queue;check(btn===16&&$('l4').classList.contains('on'),'第五按键键盘按下');b.onkeyup({key:'Enter',preventDefault(){}});await queue;check(btn===0&&!$('l4').classList.contains('on'),'按键释放');
 $('keyMode').value='latch';b.onkeydown({key:' ',repeat:false,preventDefault(){}});b.onkeyup({key:' ',preventDefault(){}});await queue;check(btn===16,'锁定按键保持');b.onkeydown({key:' ',repeat:false,preventDefault(){}});await queue;check(btn===0,'锁定按键再次释放');$('keyMode').value='hold';
 $('batch').value='10';$('batch').onchange();check($('step').textContent==='时钟 +10','批量时钟标签与行为一致');$('batch').value='1';$('batch').onchange();
 loadLesson(LESSONS.find(l=>l.id==='cpu'));await queue;await instructionStep();let count=events.length;window.onWaveCursor(18);check(retirement()===1&&executionClocks(18)===1&&$('cycle').textContent.includes('观察时钟 2'),'边沿后采样前的历史计数精确');returnLive();
 let file=new File(['00100193\n00100073\n'],'custom.hex',{type:'text/plain'});await $('programFile').onchange({target:{files:[file],value:''}});check(ensureLive()===false&&events.length===count,'程序修改阻止旧镜像继续');await compileDesign();await continuous(true);check(bitsNumber(debugValue(currentSnapshot().state,'dbg_x3'))===1n&&retirement()===2,'自定义HEX镜像实际执行');
 let project=projectData();project.name='导入往返验证';await $('projectFile').onchange({target:{files:[new File([JSON.stringify(project)],'project.json')],value:''}});await queue;check($('projectName').value==='导入往返验证'&&ready&&activeProgram==='00100193\n00100073','工程文件实际导入');
 $('code').value='module bad(\n!\nendmodule';await compileDesign().catch(()=>{});check($('historyRows').children.length===0&&!ready,'编译失败清理旧历史');
 loadLesson(LESSONS.find(l=>l.id==='counter'));await queue;await new Promise(r=>setTimeout(r,250));let saved=JSON.parse(localStorage.getItem('fpga-studio-v2'));check(saved.code===$('code').value&&saved.lessonId==='counter','工程自动保存');switchTab('wave');return {passed:checks.length,checks};
}
