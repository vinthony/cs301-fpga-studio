async()=>{
 let checks=0;
 for(let a=0;a<16;a++)for(let b=0;b<16;b++){
  const s=anatomyState();s.av=a;s.bv=b;const e=anatomyEvaluate('adder',s),sum=a+b;
  if(e.portLabels.OUT!=='S='+(sum&15)+' C4='+(sum>>>4))throw Error('output');let c=0;
  for(let i=0;i<4;i++){const v=((a>>>i)&1)+((b>>>i)&1)+c;c=v>>>1;if(e.partValues['FA'+i]!=='S'+(v&1)+' C'+c)throw Error('FA');checks++}checks++;
 }
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('adder');await new Promise(r=>setTimeout(r,250));
 document.querySelector('[data-adder-scenario="3"]').click();await new Promise(r=>setTimeout(r,150));
 const get=id=>document.querySelector('.an-scene [data-diagram-part="'+id+'"] .sc-port-code')?.textContent;
 if(get('AB')!=='A=15 B=1'||get('OUT')!=='S=0 C4=1')throw Error('rendered ports');
 return {status:'passed',checks:checks+2};
}
