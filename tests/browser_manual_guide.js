async()=>{
 const wait=ms=>new Promise(r=>setTimeout(r,ms)),checks=[],ok=(v,n)=>{if(!v)throw Error(n);checks.push(n)};
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('fulladder');await wait(180);
 const d=document.querySelector('.anatomy-dialog[open]'),button=d.querySelector('[data-change-step]');ok(button.disabled,'没有变化时禁用');
 const input=d.querySelector('[data-toggle="a"]');input.click();await wait(60);
 ok(!button.disabled,'有变化后可逐组查看');const count=d.querySelector('[data-observation-range]').max;
 button.click();const first=d.querySelector('[data-guide-detail]').textContent;
 ok(first.includes('→')&&first.includes('不代表实际传播时间'),'显示真实前后值并说明范围');ok(d.dataset.observationMode==='manual','进入手动讲解');
 const status=d.querySelector('[data-observation-status]').textContent;await wait(1150);ok(d.querySelector('[data-observation-status]').textContent===status,'手动讲解不会自动推进');
 for(let i=0;i<9;i++)button.click();ok(d.querySelector('[data-observation-range]').max===count,'逐组查看不增加仿真记录');
 d.querySelector('[data-observation-live]').click();ok(d.dataset.observationMode==='live','可以回到实时实验');ok(!d.querySelector('[data-guide-detail]').textContent,'清除过时讲解');
 return {status:'passed',checks:checks.length};
}
