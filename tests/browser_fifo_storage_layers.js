async()=>{
 let checks=0;const ok=(v,m)=>{if(!v)throw Error(m);checks++},wait=()=>new Promise(r=>setTimeout(r,180)),enter=async part=>{document.querySelector('.anatomy-dialog[open] [data-part="'+part+'"]').dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await wait()},back=async()=>{document.querySelector('[data-return-parent]').click();await wait()};
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('fifo');await wait();
 for(const v of [65,85]){const n=document.querySelector('[data-field="data"]');n.value=String(v);n.dispatchEvent(new Event('change',{bubbles:true}));document.querySelector('[data-experiment-action="tick"]').click()}
 const before=document.querySelector('.an-watch').textContent;
 await enter('WP');ok(document.querySelector('[data-field="av"]').value==='3','write pointer next candidate');ok(document.querySelector('.an-transfer-note').textContent.includes('Q=2'),'write pointer saved');ok(document.querySelector('.an-context-parent').dataset.contextPart==='WP','correct pointer instance');
 await enter('F0');ok(document.querySelector('.an-transfer-note').textContent.includes('Q=0'),'saved low pointer bit');await back();document.querySelector('[data-tick]').click();ok(document.querySelector('.an-watch').textContent.includes('3'),'local register updates');await back();ok(document.querySelector('.an-watch').textContent===before,'parent pointer unchanged');
 await enter('COUNT');ok(document.querySelector('.an-transfer-note').textContent.includes('Q=2'),'occupancy saved');ok(document.querySelector('[data-field="av"]').value==='3','occupancy candidate');await back();
 await enter('RP');ok(document.querySelector('[data-field="av"]').value==='0','read pointer holds without request');ok(document.querySelector('[data-toggle="enable"]').textContent.includes('0'),'CE holds');await back();
 for(let i=0;i<11;i++)document.querySelector('[data-fifo-tx-step]').click();await enter('RXQ');ok(document.querySelector('.an-transfer-note').textContent.includes('接收FIFO'),'receive source labeled');ok(document.querySelector('.an-watch').textContent.includes('65'),'receive data not next TX head');ok(document.querySelector('[data-toggle="we"]').textContent.includes('0'),'copy write disabled');ok(!!document.querySelector('[data-reread-parent]'),'receive reread');await back();
 return {status:'passed',checks};
}
