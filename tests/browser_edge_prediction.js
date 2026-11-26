async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},wait=ms=>new Promise(r=>setTimeout(r,ms));
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('edge');await wait(120);
 const d=document.querySelector('.anatomy-dialog[open]'),h=d.querySelector('.an-prediction');
 h.querySelector('[data-predict="1"]').click();h.querySelector('[data-predict-start]').click();
 for(const expected of [0,1,0,0,0,0,0,0,0,1]){h.querySelector('[data-predict-next]').click();ok(Number(d.querySelector('[data-edge-event]').textContent)===expected,'actual event '+checks)}
 const r=h.predictionReport();ok(r.verification&&r.predictionCorrect,'correct prediction verified');
 ok(r.rows.map(x=>x.result).join(',')==='0,0,1,0,0,0,0,0,0,0,1','actual initial and step outputs');
 ok(r.rows.map(x=>x.ticks).join(',')==='0,0,1,2,2,2,3,3,4,4,5','input changes add no sampling edges');
 ok(r.rows.map(x=>x.observed.match(/本次保存=(\d+)/)[1]).join(',')==='0,0,1,1,1,1,1,1,0,0,1','current sampled values');
 ok(r.rows.map(x=>x.observed.match(/上次保存=(\d+)/)[1]).join(',')==='0,0,0,1,1,1,1,1,1,1,0','previous receives old current');
 const html=anatomyPredictionReportMarkup(r);ok(html.includes('本次保存=1')&&html.includes('上次保存=0'),'saved source values in report');
 return {status:'passed',steps:10,samplingEdges:5,checks};
}
