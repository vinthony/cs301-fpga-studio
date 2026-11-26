async()=>{
 const wait=ms=>new Promise(r=>setTimeout(r,ms));let checks=0;const ok=(v,m)=>{if(!v)throw Error(m);checks++};
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('pipeline32');await wait(180);
 for(let i=0;i<11;i++)document.querySelector('[data-experiment-action="tick"]').click();
 document.querySelector('[data-pipe32-cycle="7"]').click();document.querySelector('[data-pipe32-instance="5"]').click();
 const host=document.querySelector('[data-pipe32-track]'),status=()=>host.querySelector('[data-pipe32-play-status]').textContent,active=()=>host.querySelector('[aria-current="step"]'),before=document.querySelector('.an-watch').textContent;
 ok(host.querySelector('[data-pipe32-prev]').disabled,'first step bound');
 host.querySelector('[data-pipe32-next]').click();ok(status().includes('记录 2 /'),'manual next');ok(active().textContent.includes('继续停留'),'held cycle explained');
 host.querySelector('[data-pipe32-prev]').click();ok(status().includes('记录 1 /'),'manual previous');
 host.querySelector('[data-pipe32-play]').click();await wait(1150);ok(status().includes('记录 2 /'),'auto advances record');
 host.querySelector('[data-pipe32-play]').click();const paused=status();await wait(1100);ok(status()===paused,'pause holds');
 ok(document.querySelector('.an-watch').textContent===before,'play never advances processor');
 for(let i=0;i<8;i++)host.querySelector('[data-pipe32-next]').click();ok(host.querySelector('[data-pipe32-next]').disabled,'last step bound');ok(active().textContent.includes('边沿退休'),'last is real retirement');
 host.querySelector('[data-pipe32-play]').click();ok(status().includes('记录 1 /'),'restart playback from beginning');
 document.querySelector('[data-experiment-action="tick"]').click();const detached=status();await wait(1100);ok(status()===detached,'model advance cancels old playback');
 ok(!document.querySelector('[data-pipe32-play]'),'old trace removed on new cycle');
 return {status:'passed',checks};
}
