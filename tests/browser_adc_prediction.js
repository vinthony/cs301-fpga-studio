async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},wait=ms=>new Promise(r=>setTimeout(r,ms)),d=()=>document.querySelector('.anatomy-dialog[open]');
 ok(anatomyPredictionValueMatches([4,0,15,0],[4,0,15,0]),'array value equality');ok(!anatomyPredictionValueMatches([4,0,15,0],[4,15,0,0]),'order matters');ok(!anatomyPredictionValueMatches([4,0],[4,0,0]),'length matters');ok(!anatomyPredictionValueMatches(['4'],[4]),'type matters');
 for(const id of ['adccore','xadc']){
  d()?.querySelector('[data-an-close]').click();openArchitecture(id);await wait(60);const h=d().querySelector('.an-prediction');h.querySelector('[data-predict="1"]').click();h.querySelector('[data-predict-start]').click();const outputs=[0,3,3,3,3,4],windows=[[0,0,0,0],[15,0,0,0],[0,15,0,0],[0,15,0,0],[0,15,0,0],[4,0,15,0]];
  for(let i=0;i<6;i++){h.querySelector('[data-predict-next]').click();ok(Number(d().querySelector('[data-coach-delta] b').textContent)===outputs[i],'actual output '+i);ok(d().querySelector('[data-adc-window]').textContent.includes(windows[i].join('、')),'independent old window '+i);}
  const r=h.predictionReport();ok(r.verification&&r.predictionCorrect,'exercise verified');ok(r.rows.map(x=>x.ticks).join(',')==='0,1,2,3,4,5,6','six real edges');ok(r.rows.map(x=>x.observed.match(/已接收数=(\d+)/)[1]).join(',')==='0,0,1,2,2,2,3','no duplicate on invalid');ok(r.rows.at(-1).observed.includes('滤波窗口=4,0,15,0'),'actual array recorded');ok(anatomyPredictionReportMarkup(r).includes('滤波窗口=4,0,15,0'),'array kept in report');
 }
 const original=AN_PREDICTIONS.adccore.steps[0].expect.state.adcSamples;
 try{AN_PREDICTIONS.adccore.steps[0].expect.state.adcSamples=[1,0,0,0];d().querySelector('[data-an-close]').click();openArchitecture('adccore');await wait(60);const h=d().querySelector('.an-prediction');h.querySelector('[data-predict="1"]').click();h.querySelector('[data-predict-start]').click();h.querySelector('[data-predict-next]').click();ok(Number(d().querySelector('[data-coach-delta] b').textContent)===0,'output alone still looks correct');ok(h.dataset.predictionVerified==='false'&&h.querySelector('[data-predict-next]').disabled,'state mismatch caught immediately');}
 finally{AN_PREDICTIONS.adccore.steps[0].expect.state.adcSamples=original;}
 return {status:'passed',cases:2,checks};
}
