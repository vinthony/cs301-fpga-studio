async()=>{
 const checks=[],ok=(v,n)=>{if(!v)throw Error(n);checks.push(n)},wait=ms=>new Promise(r=>setTimeout(r,ms));
 for(const id of Object.keys(ANATOMY)){
  const chain=anatomyContextPath(id,[id]),html=anatomyContextMarkup(id,[id]),doc=new DOMParser().parseFromString(html,'text/html');
  ok(doc.querySelectorAll('[data-context-symbol]').length===chain.reduce((n,key)=>n+ANATOMY[key].parts.length,0),id+' 每个器件有独立符号');
  ok(!doc.querySelector('parsererror'),id+' 符号可解析');
  ok(doc.querySelectorAll('[data-context-lens]').length===chain.length,id+' 每层都有透视结构');
  ok(doc.querySelector('[data-context-lens][aria-current]')?.dataset.contextLens===id,id+' 当前层唯一定位');
  ok(doc.querySelector('.an-context-location').textContent.includes('第 '+chain.length+' 层'),id+' 当前深度标签');
  ok(!/NaN|Infinity|undefined/.test(html),id+' 坐标和标签有效');
  ok(doc.querySelector('[data-context-lens]:last-of-type')?.dataset.contextLens===id,id+' 末层为当前位置');
 }
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('fulladder');await wait(250);
 let d=document.querySelector('.anatomy-dialog[open]'),v=d.querySelector('.an-context-cutaway');
 ok(v.clientHeight<=361&&v.scrollHeight>v.clientHeight,'深层图不撑高侧栏');ok(v.scrollTop>0,'初始滚动到当前层');
 const current=d.querySelector('[data-context-lens="fulladder"]'),r=current.getBoundingClientRect(),vr=v.getBoundingClientRect();ok(r.bottom<=vr.bottom+2&&r.bottom>vr.top,'当前层可见');
 d.querySelector('[data-context-expand]').click();const zoom=document.querySelector('.an-context-zoom[open]');ok(zoom.querySelectorAll('[data-context-lens]').length===6,'放大图保留完整链');
 const lenses=[...zoom.querySelectorAll('[data-context-lens]')],press=key=>document.activeElement.dispatchEvent(new KeyboardEvent('keydown',{key,bubbles:true,cancelable:true}));
 ok(document.activeElement===lenses.at(-1),'放大后焦点位于当前层');
 press('Home');ok(document.activeElement===lenses[0],'Home 聚焦整板');
 press('ArrowDown');ok(document.activeElement===lenses[1],'下箭头聚焦下一层');
 press('End');ok(document.activeElement===lenses.at(-1),'End 聚焦当前层');
 press('ArrowUp');ok(document.activeElement===lenses.at(-2),'上箭头聚焦上一级');
 ok(zoom.querySelector('[data-context-current]').dataset.contextCurrent==='fulladder','焦点移动不导航');
 const pane=zoom.querySelector('.an-context-cutaway');pane.scrollTop=0;zoom.querySelector('[data-context-locate]').click();
 ok(document.activeElement===lenses.at(-1),'定位按钮聚焦当前层');ok(pane.scrollTop>0,'定位按钮滚动回当前层');
 const lr=lenses.at(-1).getBoundingClientRect(),pr=pane.getBoundingClientRect();ok(lr.bottom<=pr.bottom+2&&lr.top>=pr.top,'定位后完整当前层可见');
 zoom.querySelector('[data-context-lens="board"]').dispatchEvent(new KeyboardEvent('keydown',{key:'Enter',bubbles:true}));await wait(150);
 ok(document.querySelector('.anatomy-dialog[open] [data-context-current]').dataset.contextCurrent==='board','放大图键盘返回整板');ok(!document.querySelector('.an-context-zoom[open]'),'导航关闭放大图');
 return {status:'passed',views:Object.keys(ANATOMY).length,checks:checks.length};
}
