async()=>{
 let checks=0;const ok=(v,m)=>{if(!v)throw Error(m);checks++},act=k=>document.querySelector('[data-experiment-action="'+k+'"]').click(),preset=v=>document.querySelector('[data-flash-data="'+v+'"]').click(),saved=a=>document.querySelector('[data-flash-address="'+a+'"]').textContent;
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('flash');await new Promise(r=>setTimeout(r,180));
 ok(saved(0).includes('0xFF'),'initial erased');preset(15);ok(saved(0).includes('0xFF'),'draft not saved');act('program');ok(saved(0).includes('0x0F'),'program low nibble');
 preset(255);ok(document.querySelectorAll('.an-flash-bits .blocked').length===4,'four impossible zero-to-one bits');act('program');ok(saved(0).includes('0x0F'),'cannot set erased bits');
 preset(240);act('program');ok(saved(0).includes('0x00'),'successive programming AND');document.querySelector('[data-flash-address="1"]').click();preset(15);act('program');ok(saved(1).includes('0x0F'),'second byte programmed');ok(saved(0).includes('0x00'),'other byte preserved');
 act('erase');ok([...document.querySelectorAll('[data-flash-address]')].every(n=>n.textContent.includes('0xFF')),'whole block erased');
 document.querySelector('[data-flash-data-bit="7"]').click();ok(document.querySelector('[data-field="data"]').value==='143','bit changes pending input');ok(saved(1).includes('0xFF'),'bit toggle not write');
 const s=anatomyState();s.flashBytes[3]=0;s.addr=3;s.data=255;const html=anatomyFlashLens(ANATOMY.flash,s),d=new DOMParser().parseFromString(html,'text/html');ok(d.querySelectorAll('.blocked').length===8,'all impossible bits');ok(html.includes('不模拟真实页大小'),'model boundary visible');
 document.querySelector('.an-flash-lens').scrollIntoView({block:'center'});return {status:'passed',checks};
}
