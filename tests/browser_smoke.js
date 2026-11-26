async () => {
 const passed=[];const check=(ok,name)=>{if(!ok)throw Error('FAIL: '+name);passed.push(name)};
 await queue;let initial=projectData();
 loadLesson(LESSONS.find(l=>l.id==='counter'));await queue;
 check(ready&&fpgaEditor.session.getMode().$id==='ace/mode/board_verilog','IDE 与仿真启动');
 check($('leds').children.length===16&&$('switches').children.length===16&&$('boardKeys').children.length===5,'板卡器件数量');
 let rects=[...$('switches').children].map(e=>e.getBoundingClientRect());check(rects[0].x<rects[15].x&&Math.abs(rects[0].y-rects[15].y)<2,'开关横向排列');
 document.querySelector('[data-signal="sw"]').click();check($('switches').classList.contains('signal-focus')&&window.waveHighlight==='tb.sw'&&fpgaEditor.getSelectedText()==='sw','代码板卡波形三方联动');
 $('s0').click();await queue;await advance(2);check($('display').textContent==='0x00000002','计数器操作');
 check(Object.keys(samples.at(-1).state).some(k=>k.endsWith('.count')),'内部状态采集');
 check($('stateRows').textContent.includes('count')&&$('stateRows').textContent.includes('0x00000002'),'状态旧值新值');
 let total=events.length;observeSample(2);check(events.length===total&&observedTime!==null,'历史观察不改变运行记录');
 let before=samples.at(-1).time;window.onWaveCursor(samples[2].time+.5);check(events.length===total&&currentSnapshot().time===samples[2].time+.5,'波形游标历史观察');
 await restoreHistory();check(events.length===3&&$('display').textContent==='0x00000000','恢复重放截断后续');await advance(1);check($('display').textContent==='0x00000001','恢复后继续执行');
 before=currentSnapshot().time;await runTests();check(lastTestReport.cases.every(c=>c.pass)&&currentSnapshot().time===before,'测试断言与隔离');
 for(let id of ['fault-width','fault-reset','fault-sign','fault-hazard']){
  loadLesson(LESSONS.find(l=>l.id===id));await queue;await runTests();check(!lastTestReport.cases[0].pass,id+' 产生真实失败');
  $('testResults').querySelector('[data-replay]').click();await queue;check(observedTime!==null,'失败重放 '+id);
  $('code').value=lesson.solution;await compileDesign();await runTests();check(lastTestReport.cases[0].pass,id+' 修复通过');
 }
 loadLesson(LESSONS.find(l=>l.id==='cpu'));await queue;
 check(retirement()===0,'CPU复位');await instructionStep();check(retirement()===1&&bitsNumber(debugValue(currentSnapshot().state,'dbg_x1'))===5n,'按指令单步');
 $('breakpoints').value='8';await continuous(true);check(bitsNumber(debugValue(currentSnapshot().state,'dbg_pc'))===8n&&retirement()===2,'PC断点在执行前停住');
 $('breakpoints').value='';await continuous(true);check(retirement()===21&&cpuHalted(),'程序退休与停机');
 check(bitsNumber(debugValue(currentSnapshot().state,'dbg_x3'))===15n&&bitsNumber(debugValue(currentSnapshot().state,'dbg_m0'))===15n,'寄存器内存实际结果');
 check($('registerGrid').children.length===32&&$('memoryRows').children.length===64&&$('programRows').textContent.includes('bne'),'CPU寄存器内存反汇编');
 await runTests();check(lastTestReport.cases[0].pass,'CPU程序级断言');
 loadLesson(LESSONS.find(l=>l.id==='pipeline'));await queue;sw=1;await advance(9);check(retirement()===3&&cycles>retirement()&&document.querySelectorAll('.stage').length===5,'流水线阶段与独立退休计数');
 loadLesson(LESSONS.find(l=>l.id==='basys'));await queue;sw=0xabcd;await sample(0);check(currentSnapshot().an==='1110'&&currentSnapshot().seg==='0100001','真实共阳极段选接口');await advance(1);check(currentSnapshot().an==='1101','四位扫描');await runTests();check(lastTestReport.cases[0].pass,'板级接口测试');
 let saved=projectData();applyProject(JSON.parse(JSON.stringify(saved)));check($('code').value===saved.code&&$('testsCode').value===saved.tests&&$('profile').value==='basys3','工程序列化往返');
 $('layout').value='classroom';applyLayout();check($('workspace').classList.contains('classroom'),'课堂布局');$('layout').value='student';applyLayout();check($('workspace').classList.contains('student'),'学生布局');
 let code=$('code').value;$('code').value='module broken(\n bad!\nendmodule';await compileDesign().catch(()=>{});check(fpgaEditor.session.getAnnotations().length>0&&!ready,'编译错误行与运行门禁');$('code').value=code;await compileDesign();check(ready,'错误恢复');
 let n=events.length;window.onWaveCursor(0);check(observedIndex===-1&&$('restore').disabled&&events.length===n,'起始之前无伪造恢复点');returnLive();
 loadLesson(LESSONS.find(l=>l.id==='counter'));await queue;switchTab('wave');
 return {passed:passed.length,checks:passed};
}
