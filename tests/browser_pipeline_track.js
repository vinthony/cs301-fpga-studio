async()=>{
 const wait=()=>new Promise(r=>setTimeout(r,180));let checks=0;const ok=(v,m)=>{if(!v)throw Error(m);checks++};
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('pipeline32');await wait();
 for(let i=0;i<11;i++)document.querySelector('[data-experiment-action="tick"]').click();
 document.querySelector('[data-pipe32-cycle="7"]').click();
 const before=document.querySelector('.an-watch').textContent;
 document.querySelector('[data-pipe32-instance="5"]').click();
 let track=document.querySelector('[data-pipe32-track]');
 ok(track.textContent.includes('继续停留'),'load-use held instruction');
 ok(track.querySelectorAll('[data-pipe32-track-stage="ID"]').length===2,'two ID occupancies');
 ok(track.textContent.includes('已退休'),'retirement');ok(document.querySelector('.an-watch').textContent===before,'readonly trace');
 const source=document.querySelector('[data-pipe32-source]');source.value='addi x1,x0,2\nloop: addi x1,x1,-1\nbne x1,x0,loop\naddi x2,x0,9\nebreak';source.dispatchEvent(new Event('input',{bubbles:true}));document.querySelector('[data-pipe32-load]').click();
 for(let i=0;i<12;i++)document.querySelector('[data-experiment-action="tick"]').click();
 const c=anatomyPipeline32State(anatomyAssembleCPU32(source.value),'forward');for(let i=0;i<12;i++)anatomyPipeline32Tick(c);
 const row=c.timeline.find(r=>r.flushed.length);ok(!!row,'branch flush exists');
 document.querySelector('[data-pipe32-cycle="'+row.cycle+'"]').click();document.querySelector('[data-pipe32-instance="'+row.flushed[0]+'"]').click();
 ok(document.querySelector('[data-pipe32-track]').textContent.includes('已冲刷，不会退休'),'flushed UI status');
 const loops=c.timeline.flatMap(r=>Object.values(r.stages)).filter(p=>p?.pc===4&&p.id!==undefined),ids=[...new Set(loops.map(p=>p.id))];ok(ids.length===2,'loop same PC distinct IDs');
 ok(anatomyPipeline32InstructionTrack(c,ids[0]).includes('实例 #'+ids[0]),'trace first loop instance');
 ok(anatomyPipeline32InstructionTrack(c,ids[1]).includes('实例 #'+ids[1]),'trace second loop instance');
 return {status:'passed',checks};
}
