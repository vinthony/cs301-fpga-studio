async()=>{
 const checks=[],ok=(v,n)=>{if(!v)throw Error(n);checks.push(n)};openArchitecture('alu32');await new Promise(r=>setTimeout(r,500));const d=document.querySelector('.anatomy-dialog'),out=()=>d.querySelector('.an-live-io strong').textContent,set=(k,v)=>{const x=d.querySelector('[data-field="'+k+'"]');x.value=v;x.dispatchEvent(new Event('change',{bubbles:true}))};
 ok(d.querySelector('.an-scene').dataset.render==='ready','32 位结构成功绘制');ok(d.querySelector('.an-scene').dataset.routeFallbacks==='[]','连线无回退');
 set('av','0xFFFFFFFF');set('bv','0b1');set('op','SLT');ok(out()==='1','SLT 按 −1 与 1 比较');ok(d.querySelector('[data-coach-body]').textContent.includes('−1')||d.querySelector('[data-coach-body]').textContent.includes('-1'),'讲解给出有符号解释');set('op','SLTU');ok(out()==='0','SLTU 按 4294967295 与 1 比较');
 set('op','ADD');ok(out()==='0','全一加一归零');ok(d.querySelector('.an-wave-svg').outerHTML.includes('0xFFFFFFFF'),'32 位观察波形保留完整十六进制');
 for(const invalid of ['4294967296','-1','not-a-number','1.5',' ']){set('av',invalid);ok(!!d.querySelector('.an-lab-error').textContent,'拒绝输入 '+invalid);ok(out()==='0','非法输入不改输出')}
 for(const [i,expected] of [0,2147483648,1,1073741824,1].entries()){d.querySelector('[data-rv32-preset="'+i+'"]').click();ok(out()===String(expected),'边界快捷实验 '+i);ok(!d.querySelector('.an-lab-error').textContent,'预设清除错误提示')}
 d.querySelector('[data-observation-prev]').click();ok([...d.querySelectorAll('[data-rv32-preset]')].every(x=>x.disabled),'历史回看锁定预设');d.querySelector('[data-observation-live]').click();ok(out()==='1','回看不改当前电路');
 const before=out();d.querySelector('[data-observation-prev]').click();d.querySelector('[data-rv32-preset="0"]').dispatchEvent(new MouseEvent('click',{bubbles:true}));d.querySelector('[data-observation-live]').click();ok(out()===before,'历史合成点击也不改状态');
 return {checks:checks.length,status:'passed'};
}
