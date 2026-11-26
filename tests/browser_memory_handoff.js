async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},d=()=>document.querySelector('.anatomy-dialog[open]'),wait=()=>new Promise(r=>setTimeout(r,80));
 d()?.querySelector('[data-an-close]').click();
 for(let address=0;address<8;address++){
  openTopic('memory');const field=(id,value)=>{const f=document.querySelector('#'+id);f.value=value;f.dispatchEvent(new Event('change',{bubbles:true}))};
  for(let i=0;i<8;i++){field('ramAddress',i);field('ramData',i*31+7);document.querySelector('#ramTick').click()}
  field('ramAddress',address);document.querySelector('#ramEnable').click();field('ramData',255);document.querySelector('#ramTick').click();
  const source=snapshotLearningBoard();ok(source.memoryDemo.bytes[address]===address*31+7&&!source.memoryDemo.enabled,'disabled source does not write');
  source.memoryDemo.bytes[0]=999;ok(snapshotLearningBoard().memoryDemo.bytes[0]===7,'snapshot has independent bytes');
  document.querySelector('[data-topic-tab="deep"]').click();document.querySelector('#topic-deep .architecture-launch').click();await wait();
  ok(d().dataset.view==='memorySystem'&&+d().querySelector('[data-field="addr"]').value===address&&+d().querySelector('[data-field="data"]').value===255,'request inherited');
  ok(d().querySelector('.an-transfer-note').textContent.includes('源页写使能为0')&&d().querySelector('.an-transfer-note').textContent.includes('尚未执行缓存访问'),'mapping explicit');
  d().querySelector('[data-experiment-action="access"]').click();ok(+d().querySelector('[data-coach-delta] b').textContent===address*31+7,'access reads saved byte rather than pending');
  d().querySelector('[data-experiment-action="write"]').click();d().querySelector('[data-experiment-action="access"]').click();ok(+d().querySelector('[data-coach-delta] b').textContent===255,'explicit write then read');
  d().querySelector('[data-an-close]').click();ok(snapshotLearningBoard().memoryDemo.bytes[address]===address*31+7,'internal writes never mutate source');
 }
 return {status:'passed',checks,addresses:8};
}
