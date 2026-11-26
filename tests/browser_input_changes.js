async()=>{
 const wait=ms=>new Promise(r=>setTimeout(r,ms)),checks=[],ok=(v,n)=>{if(!v)throw Error(n);checks.push(n)};
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('fulladder');await wait(150);
 const d=document.querySelector('.anatomy-dialog[open]');ok(!d.querySelector('.an-input-changes'),'初始记录没有伪造变化');
 d.querySelector('[data-toggle="a"]').click();const panel=d.querySelector('[data-coach-inputs]');ok(panel.querySelector('dt').textContent==='A','输入名称正确');const spans=panel.querySelectorAll('dd span');ok(spans[0].textContent==='1 / 0x1'&&spans[1].textContent==='0 / 0x0','准确显示前后值');
 d.querySelector('[data-observation-prev]').click();ok(!d.querySelector('.an-input-changes'),'回看初始记录清除后来变化');d.querySelector('[data-observation-live]').click();ok(d.querySelector('.an-input-changes'),'回到当前恢复变化说明');
 const b=ANATOMY.fulladder,previous={state:{a:0,b:0,cin:0,ticks:0},evaluation:{nets:{},result:0}},current={state:{a:'<img src=x onerror=alert(1)>',b:0,cin:0,ticks:0},evaluation:{nets:{},result:0}};
 const doc=new DOMParser().parseFromString(anatomyInputChangeMarkup(b,previous,current),'text/html');ok(!doc.querySelector('img'),'输入说明转义外来文本');
 return {status:'passed',checks:checks.length};
}
