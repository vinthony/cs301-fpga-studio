async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},parse=html=>new DOMParser().parseFromString(html,'text/html');
 for(const id of ['pixelword','rastercounter'])for(const enable of [0,1])for(const reset of [0,1]){
  const s=anatomyState();Object.assign(s,{pixelQ:0xa5c,pixelD:0x369,pixelWE:enable,rasterQ:255,rasterEnable:enable,rasterReset:reset});anatomyAdvance(id,s);
  const record=JSON.parse(JSON.stringify(id==='pixelword'?s.pixelLast:s.rasterLast));s.pixelD=0xfff;s.pixelWE=1-enable;s.rasterReset=1-reset;s.rasterEnable=1-enable;
  const report=anatomyExperimentReport({blueprint:ANATOMY[id],state:s,evaluation:anatomyEvaluate(id,s),path:[id]}),doc=parse(report),section=doc.querySelector('[data-report-saved-edge]');
  ok(!!section,'edge exists');ok(!section.querySelector('button,script,animate,input'),'static observation');
  const rows=section.querySelectorAll('table:last-of-type tbody tr'),width=id==='pixelword'?12:10;ok(rows.length===width,'all saved bits');
  for(let i=0;i<width;i++){const cells=rows[i].querySelectorAll('td'),bit=width-1-i;ok(cells[1].textContent===String((record.before>>>bit)&1),'recorded old');ok(cells[2].textContent===String(((id==='pixelword'?record.input:record.d)>>>bit)&1),'recorded D not current');ok(cells[3].textContent===String((record.after>>>bit)&1),'recorded next')}
 }
 const d=()=>document.querySelector('.anatomy-dialog[open]');d()?.querySelector('[data-an-close]').click();openArchitecture('pixelword');await new Promise(r=>setTimeout(r,300));
 const originalURL=URL.createObjectURL,oldClick=HTMLAnchorElement.prototype.click;let blob;URL.createObjectURL=b=>{blob=b;return originalURL(b)};HTMLAnchorElement.prototype.click=function(){};
 try{
  d().querySelector('[data-export-report]').click();ok(!parse(await blob.text()).querySelector('[data-report-saved-edge]'),'no invented edge before first tick');
  d().querySelector('[data-experiment-action="tick"]').click();d().querySelector('[data-pixelword-candidate="0"]').click();
  d().querySelector('[data-export-report]').click();let doc=parse(await blob.text()),data=JSON.parse(doc.querySelector('pre').textContent);ok(data.state.pixelD===0xf01&&data.state.pixelLast.input===0xf00,'export preserves current vs captured D');ok(doc.querySelector('[data-report-saved-edge] table tbody tr td:nth-child(2)').textContent==='0xf00','actual exported visible captured D');
  d().querySelector('[data-observation-prev]').click();d().querySelector('[data-export-report]').click();doc=parse(await blob.text());data=JSON.parse(doc.querySelector('pre').textContent);ok(data.historical&&data.state.pixelD===0xf00,'history exports selected state');ok(doc.querySelectorAll('[data-report-saved-edge] table:last-of-type tbody tr').length===12,'history edge complete');
 }finally{URL.createObjectURL=originalURL;HTMLAnchorElement.prototype.click=oldClick;d().querySelector('[data-observation-live]')?.click()}
 return {status:'passed',checks};
}
