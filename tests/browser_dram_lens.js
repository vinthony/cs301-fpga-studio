async()=>{
 let checks=0;const ok=(v,m)=>{if(!v)throw Error(m);checks++},wait=()=>new Promise(r=>setTimeout(r,180)),act=k=>document.querySelector('[data-experiment-action="'+k+'"]').click(),text=()=>document.querySelector('.an-dram-lens').textContent;
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('dram');await wait();
 act('write');for(let i=0;i<6;i++)act('wait');ok(text().includes('接近期限'),'near expiry');ok(document.querySelectorAll('.an-dram-age .elapsed').length===6,'age visualization');
 act('refresh');ok(text().includes('已等待0步'),'refresh resets age');ok(text().includes('保存位：1'),'refresh preserves saved one');
 for(let i=0;i<8;i++)act('wait');ok(text().includes('保存位：X'),'expired unknown');ok(document.querySelector('[data-experiment-action="refresh"]').disabled,'refresh cannot recover');
 document.querySelector('[data-part="CELL"]').dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await wait();ok(text().includes('保存位：X'),'unknown inherited');ok(document.querySelectorAll('.an-dram-age .elapsed').length===8,'age inherited');
 document.querySelector('[data-toggle="enable"]').click();ok(text().includes('位线观察：Z'),'WL off gives Z');ok(document.querySelector('[data-experiment-action="write"]').disabled,'WL off prevents write');
 document.querySelector('[data-toggle="enable"]').click();act('write');ok(text().includes('保存位：1'),'write recovers information');
 document.querySelector('[data-return-parent]').click();await wait();ok(text().includes('保存位：X'),'child does not restore parent');
 const s=anatomyState();s.a=0;anatomyAdvance('dramcell',s,'write');for(let i=0;i<8;i++)anatomyAdvance('dramcell',s,'wait');ok(s.chargeValid===0,'zero also expires');anatomyAdvance('dramcell',s,'refresh');ok(s.chargeValid===0,'model rejects refresh after loss');
 document.querySelector('.an-dram-lens').scrollIntoView({block:'center'});return {status:'passed',checks};
}
