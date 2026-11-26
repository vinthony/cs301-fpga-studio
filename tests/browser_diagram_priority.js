async()=>{
 const checks=[],ok=(v,n)=>{if(!v)throw Error(n);checks.push(n)},wait=ms=>new Promise(r=>setTimeout(r,ms));
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('dff');await wait(400);const d=document.querySelector('.anatomy-dialog[open]'),scene=d.querySelector('.an-scene'),svg=scene.querySelector(':scope>svg');
 ok(!!(scene.compareDocumentPosition(d.querySelector('.an-learning'))&Node.DOCUMENT_POSITION_FOLLOWING),'电路图先于讲解');ok(!!(scene.compareDocumentPosition(d.querySelector('.an-prediction'))&Node.DOCUMENT_POSITION_FOLLOWING),'电路图先于练习');ok(svg.style.width==='100%'&&svg.style.minWidth==='0px','默认显示完整结构');
 ok(svg.getBoundingClientRect().width<=scene.clientWidth+2,'适应当前可用宽度');d.querySelector('[data-zoom-native]').click();ok(svg.style.width!=='100%','仍可恢复原始细节');d.querySelector('[data-zoom-fit]').click();
 if(innerWidth<=850){d.querySelector('[data-jump-input]').click();ok(d.querySelector('.an-sidebar').getBoundingClientRect().top<innerHeight,'直接到达动手输入');d.querySelector('[data-jump-diagram]').click();ok(d.querySelector('.an-title').getBoundingClientRect().top<innerHeight,'返回电路图');}
 return {status:'passed',checks:checks.length,width:innerWidth};
}
