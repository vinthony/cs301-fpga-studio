async()=>{
 let checks=0;const wait=()=>new Promise(r=>setTimeout(r,70));
 for(const raw of [0,1])for(const count of [0,1,2])for(const part of ['F1','F2']){
  openArchitecture('synchronizer');await wait();if(raw===0)document.querySelector('[data-toggle="a"]').click();for(let i=0;i<count;i++)document.querySelector('[data-tick]').click();
  const saved1=count>=1?raw:0,saved2=count>=2?raw:0,expectedD=part==='F1'?raw:saved1,expectedQ=part==='F1'?saved1:saved2;
  document.querySelector('[data-part="'+part+'"]').dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await wait();
  if(+(document.querySelector('[data-toggle="a"]').getAttribute('aria-pressed')==='true')!==expectedD)throw Error('D');
  if(!document.querySelector('.an-watch').textContent.includes('当前输出'+expectedQ))throw Error('Q');
  if(document.querySelector('[data-tick]').disabled)throw Error('clock');checks+=3;
 }
 return{status:'passed',checks};
}
