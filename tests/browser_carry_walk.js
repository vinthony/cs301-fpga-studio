async()=>{
 const wait=ms=>new Promise(r=>setTimeout(r,ms));document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('adder');await wait(200);let checks=0;
 const next=()=>document.querySelector('[data-carry-next]').click();
 for(let i=0;i<4;i++){next();if(document.querySelector('[data-carry-stage].current').dataset.carryStage!==String(i))throw Error('stage '+i);if(!document.querySelector('[data-carry-explain]').textContent.includes('第 '+i+' 位'))throw Error('explanation');checks+=2}
 if(!document.querySelector('[data-carry-next]').disabled)throw Error('end');checks++;
 document.querySelector('[data-carry-restart]').click();if(document.querySelector('[data-carry-stage].current'))throw Error('restart');checks++;
 document.querySelector('[data-carry-play]').click();await wait(1100);document.querySelector('[data-carry-play]').click();const paused=document.querySelector('[data-carry-stage].current').dataset.carryStage;await wait(1100);
 if(document.querySelector('[data-carry-stage].current').dataset.carryStage!==paused)throw Error('pause');checks++;
 const e=document.querySelector('[data-field="av"]');e.value=15;e.dispatchEvent(new Event('change',{bubbles:true}));if(document.querySelector('[data-carry-stage].current'))throw Error('input reset');checks++;
 next();return {status:'passed',checks};
}
