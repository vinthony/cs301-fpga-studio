async () => {
 const checks=[],check=(ok,name)=>{if(!ok)throw Error(name);checks.push(name)},originalProgress=[...completed];
 completed.clear();saveProgress();
 let reachable=new Set([...document.querySelectorAll('.hotspot')].map(b=>b.dataset.topic));reachable.add('switches');reachable.add('buttons');
 check(TOPICS.every(t=>reachable.has(t.id)),'14 个学习模块均有板面入口');
 check(document.querySelectorAll('[data-learn-bit]').length===16&&document.querySelectorAll('.board-key').length===5,'16 个开关与 5 个按键均可点击学习');
 document.querySelector('[data-learn-bit="5"]').click();check(activeTopic.id==='switches'&&byId('lessonContent').textContent.includes('SW5'),'开关进入对应说明');
 document.querySelector('.board-key.k4').click();check(activeTopic.id==='buttons'&&selectedPart==='BTND','按键进入对应说明');
 for(let t of TOPICS){
  openTopic(t.id,'',true);check(!!byId('demoRoot').children.length&&!!byId('practiceLink'),'原理、演示、实验入口 '+t.id);
  let wrong=(t.answer+1)%t.options.length;byId('lessonContent').querySelector(`[data-answer="${wrong}"]`).click();check(byId('markComplete').disabled&&!completed.has(t.id),'错误答案不完成 '+t.id);
  byId('lessonContent').querySelector(`[data-answer="${t.answer}"]`).click();byId('markComplete').click();check(completed.has(t.id),'正确作答可记录 '+t.id);
 }
 check(JSON.parse(localStorage.getItem('cs301-component-progress')).length===14,'学习进度持久化');
 openTopic('switches','',true);let b=byId('demoRoot').querySelector('[data-bit="0"]');let previous=byId('demoRoot').textContent;b.click();check(byId('demoRoot').textContent!==previous,'二进制位演示更新');
 openTopic('fpga','',true);byId('lutA').click();byId('lutB').click();check(byId('demoRoot').querySelector('.demo-readout').textContent.includes('Y = 1'),'LUT 与函数');byId('lutOp').value='XOR';byId('lutOp').onchange({target:byId('lutOp')});check(byId('demoRoot').querySelector('.demo-readout').textContent.includes('Y = 0'),'LUT 异或真值');
 openTopic('clock','',true);byId('demoTick').click();byId('clockEnable').checked=false;byId('clockEnable').onchange({target:byId('clockEnable')});byId('demoTick').click();check(byId('demoRoot').querySelector('.demo-readout b').textContent==='1','时钟使能保持');byId('demoReset').click();check(byId('demoRoot').querySelector('.demo-readout b').textContent==='0','同步复位优先');
 openTopic('sevenseg','',true);check(byId('demoRoot').querySelector('.demo-readout').textContent.includes('1110'),'数码管默认选通 AN0');byId('nextDigit').click();check(byId('demoRoot').querySelector('.demo-readout').textContent.includes('1101'),'数码管扫描 AN1');byId('dotToggle').checked=true;byId('dotToggle').onchange({target:byId('dotToggle')});check(byId('demoRoot').querySelectorAll('circle.lit').length===1,'低有效小数点');
 openTopic('memory','',true);byId('ramAddress').value=3;byId('ramData').value=42;byId('ramTick').click();check(byId('ramReadout').textContent.includes('42'),'同步写数据 42');byId('ramEnable').checked=false;byId('ramEnable').onchange({target:byId('ramEnable')});byId('ramData').value=99;byId('ramTick').click();check(byId('ramReadout').textContent.includes('42'),'写使能关闭保持存储');
 openTopic('programming','',true);byId('configure').click();check(byId('demoRoot').querySelectorAll('.demo-led.on').length===2,'配置完成状态');byId('powerToggle').click();byId('powerToggle').click();check(byId('demoRoot').querySelectorAll('.demo-led.on').length===1,'易失配置掉电丢失');byId('flashWrite').click();byId('powerToggle').click();byId('powerToggle').click();check(byId('demoRoot').querySelectorAll('.demo-led.on').length===2,'Flash 配置上电加载');
 openTopic('uart','',true);check(byId('demoRoot').querySelector('.demo-readout').textContent.includes('1 0 0 0 0 0 1 0'),'UART 0x41 低位先发');
 openTopic('usbhost','',true);byId('hidPress').click();check(byId('demoRoot').querySelector('.demo-readout').textContent.includes('00 00 04 00'),'HID A 使用码');byId('hidShift').checked=true;byId('hidShift').onchange({target:byId('hidShift')});check(byId('demoRoot').querySelector('.demo-readout').textContent.includes('02 00 04 00'),'HID Shift 修饰位');byId('hidRelease').click();check(byId('demoRoot').querySelector('.demo-readout').textContent.includes('无按键'),'HID 释放');
 openTopic('vga','',true);byId('demoRoot').querySelector('[data-pixel="2"]').click();let paint=byId('demoRoot').querySelector('[data-pixel="2"]').style.background;byId('pixelStep').click();check(paint==='rgb(255, 85, 34)'&&byId('demoRoot').querySelector('[data-pixel="1"]').classList.contains('scanning'),'像素绘制与扫描坐标');
 openTopic('xadc','',true);byId('analogLevel').value=100;byId('analogLevel').oninput({target:byId('analogLevel')});check(byId('demoRoot').querySelector('.demo-readout b').textContent==='1111','归一化端点量化');
 byId('componentSearch').value='uart';renderNav();check(byId('componentList').querySelectorAll('button').length===1,'组件检索');byId('componentSearch').value='';
 let unrelated=localStorage.getItem('fpga-studio-v2');byId('resetLearning').click();byId('confirmReset').click();check(completed.size===0&&localStorage.getItem('fpga-studio-v2')===unrelated,'重置学习进度不动 RTL 工程');
 completed=new Set(originalProgress);saveProgress();openTopic('switches','',true);setTab('concept');history.replaceState(null,'','#switches');
 return {passed:checks.length,checks};
}
