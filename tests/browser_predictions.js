async()=>{
 const checks=[],ok=(v,n)=>{if(!v)throw Error(n);checks.push(n)},wait=ms=>new Promise(r=>setTimeout(r,ms));
 for(const id of Object.keys(AN_PREDICTIONS)){
  openArchitecture(id);await wait(80);const d=document.querySelector('.anatomy-dialog'),h=d.querySelector('.an-prediction'),c=AN_PREDICTIONS[id];
  if(id==='cpu32')for(const [key,value]of [['cpuSwitches','0xA55A'],['cpuButtons','17']]){const input=d.querySelector('[data-field="'+key+'"]');input.value=value;input.dispatchEvent(new Event('change',{bubbles:true}))}
  h.querySelector('details').open=true;ok(h.querySelector('[data-predict-start]').disabled,id+' 先预测后开始');
  h.querySelectorAll('[data-predict]')[(c.answer+1)%c.choices.length].click();h.querySelector('[data-predict-start]').click();
  if(id==='cpu32'){ok(Number(d.querySelector('[data-field="cpuSwitches"]').value)===0xA55A&&Number(d.querySelector('[data-field="cpuButtons"]').value)===17,'CPU练习保留外部输入');ok(h.textContent.includes('整板 CPU 视图也会同步更新'),'CPU练习说明共享状态');}
  for(let i=0;i<c.steps.length;i++){h.querySelector('[data-predict-next]').click();if(i<c.steps.length-1)ok(!h.querySelector('[data-predict-status]').textContent.includes(c.explanation),id+' 不提前揭晓');}
  ok(h.dataset.predictionVerified==='true',id+' 实际模型吻合题目');ok(h.querySelector('[data-predict-status]').textContent.includes('与实际结果不同'),id+' 错答提供反馈');
  ok(Number(d.querySelector('[data-observation-range]').max)>=c.steps.length,id+' 操作进入真实观察记录');
  h.querySelector('[data-predict-start]').click();ok(!h.dataset.predictionVerified,id+' 重试清除旧结论');
  d.querySelector('[data-observation-prev]').click();h.querySelector('[data-predict-next]').click();ok(h.querySelector('[data-predict-status]').textContent.includes('正在查看历史'),id+' 历史模式禁止推进');d.querySelector('[data-observation-live]').click();
 }
 openArchitecture('adder');await wait(80);const d=document.querySelector('.anatomy-dialog'),h=d.querySelector('.an-prediction');h.querySelector('[data-predict]').click();h.querySelector('[data-predict-start]').click();const input=d.querySelector('[data-field="av"]');input.value='2';input.dispatchEvent(new Event('change',{bubbles:true}));h.querySelector('[data-predict-next]').click();ok(h.querySelector('[data-predict-status]').textContent.includes('手动修改'),'手改输入阻止条件混用');
 return {checks:checks.length,cases:Object.keys(AN_PREDICTIONS).length,status:'passed'};
}
