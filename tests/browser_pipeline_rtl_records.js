async()=>{
 const wait=ms=>new Promise(r=>setTimeout(r,ms));let checks=0;
 const ok=(v,n)=>{if(!v)throw Error(n);checks++};
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('pipeline32');await wait(180);
 await anatomyLoadPipelineRTL();
 // Rerender through a normal model action after preparing the cached records.
 document.querySelector('[data-experiment-action="restart"]').click();
 const panel=()=>document.querySelector('.anatomy-dialog[open] .pipe32-rtl');
 const field=(key,value)=>{const e=panel().querySelector('[data-rtl-'+key+']');e.value=value;e.dispatchEvent(new Event('change',{bubbles:true}));};
 const match=()=>panel().querySelector('[data-rtl-match]').dataset.rtlMatch==='true';
 for(const p of AN_PIPE32_RTL_DATA.programs)for(const mode of ['stall','forward']){
  for(const cycle of [...new Set([1,Math.ceil(p.traces[mode].length/2),p.traces[mode].length])]){
   field('case',p.id);field('mode',mode);field('cycle',cycle);panel().querySelector('[data-rtl-align]').click();ok(match(),p.id+mode+cycle+' exact match');
   const f=p.traces[mode][cycle-1];for(const row of panel().querySelectorAll('[data-rtl-stage]')){const i=+row.dataset.rtlStage;ok(row.dataset.valid===String(f.stageValid[i])&&+row.dataset.pc===f.stagePC[i],p.id+' stage '+i)}
  }
 }
 field('case','load-store-data');field('mode','forward');field('cycle',5);panel().querySelector('[data-rtl-align]').click();
 panel().querySelector('[data-rtl-next]').click();ok(+panel().querySelector('[data-rtl-cycle]').value===6&&match(),'next alignment');
 panel().querySelector('[data-rtl-prev]').click();ok(+panel().querySelector('[data-rtl-cycle]').value===5&&match(),'previous alignment');
 document.querySelector('[data-experiment-action="tick"]').click();ok(+panel().querySelector('[data-rtl-cycle]').value===6&&match(),'manual tick follows hardware');
 field('cycle',1.5);panel().querySelector('[data-rtl-align]').click();ok(panel().querySelector('[data-rtl-error]').textContent.includes('整数周期'),'fractional rejected');
 document.querySelector('[data-experiment-action="tick"]').click();ok(match(),'fractional selection cannot break next render');
 const p=AN_PIPE32_RTL_DATA.programs.find(p=>p.id==='load-store-data'),f=p.traces.forward[1],saved=f.memory[0];
 field('cycle',2);const before=document.querySelector('.an-watch').textContent;
 try{f.memory[0]^=1;panel().querySelector('[data-rtl-align]').click();ok(panel().querySelector('[data-rtl-error]').textContent.includes('memory'),'corrupt snapshot rejected');ok(document.querySelector('.an-watch').textContent===before,'failed alignment preserves experiment')}finally{f.memory[0]=saved}
 field('cycle',5);panel().querySelector('[data-rtl-align]').click();
 return {status:'passed',programs:AN_PIPE32_RTL_DATA.programs.length,checks};
}
