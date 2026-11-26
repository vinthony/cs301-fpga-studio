async()=>{
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('input');await new Promise(r=>setTimeout(r,120));
 document.querySelector('[data-input-pattern-example="0"]').click();document.querySelector('[data-input-pattern-load]').click();const length=AN_INPUT_SCENARIOS[0][1].length;
 for(let i=0;i<length;i++)document.querySelector('[data-input-pattern-next]').click();let checks=0;
 const samples=[...document.querySelectorAll('[data-input-wave-sample]')];if(samples.length!==length+1)throw Error('trace length');checks++;
 const event=samples.find(n=>n.getAttribute('aria-label').endsWith('事件1'));if(!event)throw Error('event');event.dispatchEvent(new KeyboardEvent('keydown',{key:'Enter',bubbles:true}));
 if(!document.querySelector('[data-input-wave-detail]').textContent.includes('事件=1'))throw Error('inspect');checks+=2;
 document.querySelector('[data-observation-prev]').click();if(document.querySelectorAll('[data-input-wave-sample]').length!==length)throw Error('history trace');checks++;
 document.querySelector('[data-observation-live]').click();if(document.querySelectorAll('[data-input-wave-sample]').length!==length+1)throw Error('return trace');checks++;
 return{status:'passed',checks};
}
