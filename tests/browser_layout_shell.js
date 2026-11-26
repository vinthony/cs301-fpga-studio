async()=>{
 const ok=(v,n)=>{if(!v)throw Error(n)},wait=ms=>new Promise(r=>setTimeout(r,ms));let checks=0;
 const sheet=[...document.styleSheets].find(s=>s.href?.endsWith('/anatomy.css'));ok(sheet&&sheet.cssRules.length>0,'解剖样式表没有可用规则');checks++;
 for(const id of ['board','dff','alu32','regfile32','immgen32','decoder32','cpu32']){openArchitecture(id);await wait(250);const d=document.querySelector('.anatomy-dialog'),rect=d.getBoundingClientRect(),header=d.querySelector('.anatomy-header');ok(rect.width>=Math.min(innerWidth,2200)*.9,'弹窗宽度错误 '+id);ok(rect.height>=innerHeight*.8,'弹窗高度错误 '+id);ok(getComputedStyle(d).overflow==='hidden','外层滚动错误 '+id);ok(header.getBoundingClientRect().width>rect.width*.9,'标题栏宽度错误 '+id);ok(d.querySelector('.an-scene').dataset.render==='ready','结构图未就绪 '+id);checks+=5}
 return {checks,status:'passed'};
}
