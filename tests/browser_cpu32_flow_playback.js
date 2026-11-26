async()=>{
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('cpu32');await new Promise(r=>setTimeout(r,120));
 const wait=ms=>new Promise(r=>setTimeout(r,ms)),index=()=>document.querySelector('[data-cpu32-flow][aria-current="step"]').dataset.cpu32Flow,status=()=>document.querySelector('.cpu32-program-status').textContent;let checks=0;const before=status();
 document.querySelector('[data-cpu32-flow-play]').click();await wait(1150);if(index()!=='1'||status()!==before)throw Error('auto/commit');checks+=2;
 document.querySelector('[data-cpu32-flow-play]').click();const paused=index();await wait(1100);if(index()!==paused||document.querySelector('.cpu32-flow').dataset.flowPlaying!=='false')throw Error('pause');checks+=2;
 document.querySelector('[data-cpu32-flow-play]').click();document.querySelector('[data-experiment-action="tick"]').click();await wait(1100);if(index()!=='0'||document.querySelector('.cpu32-flow').dataset.flowPlaying!=='false')throw Error('edge');checks+=2;
 document.querySelector('[data-cpu32-flow-play]').click();document.querySelector('[data-observation-prev]').click();if(!document.querySelector('[data-cpu32-flow-play]').disabled||document.querySelector('.cpu32-flow').dataset.flowPlaying!=='false')throw Error('history');checks+=2;
 document.querySelector('[data-observation-live]').click();document.querySelector('[data-cpu32-flow="4"]').click();document.querySelector('[data-cpu32-flow-play]').click();await wait(1150);if(index()!=='5'||document.querySelector('.cpu32-flow').dataset.flowPlaying!=='false')throw Error('end');checks+=2;
 return{status:'passed',checks};
}
