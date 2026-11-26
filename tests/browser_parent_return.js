async()=>{
 const wait=ms=>new Promise(r=>setTimeout(r,ms)),checks=[],ok=(v,n)=>{if(!v)throw Error(n);checks.push(n)},dialog=()=>document.querySelector('.anatomy-dialog[open]');
 dialog()?.querySelector('[data-an-close]').click();openArchitecture('fulladder');await wait(150);ok(!dialog().querySelector('[data-return-parent]'),'直接入口不伪造访问来源');
 dialog().querySelector('[data-toggle="a"]').click();const input=dialog().querySelector('[data-toggle="a"]').textContent,records=dialog().querySelector('[data-observation-range]').max;
 dialog().querySelector('[data-part="X1"]').dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await wait(150);ok(dialog().querySelector('[data-return-parent]').textContent.includes('一位全加器'),'显示真实来源');ok(dialog().querySelector('.an-parent-return').textContent.includes('X1'),'显示进入的实例');
 dialog().querySelector('[data-part="IA"]').dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await wait(150);dialog().querySelector('[data-return-parent]').click();await wait(150);ok(dialog().querySelector('.an-inspector .an-tag').textContent.startsWith('IA'),'返回中间层定位原实例');
 dialog().querySelector('[data-return-parent]').click();await wait(150);ok(dialog().querySelector('.an-inspector .an-tag').textContent.startsWith('X1'),'返回顶层定位原实例');ok(dialog().querySelector('[data-toggle="a"]').textContent===input,'父层输入未被子层覆盖');ok(dialog().querySelector('[data-observation-range]').max===records,'父层观察记录保留');
 return {status:'passed',checks:checks.length};
}
