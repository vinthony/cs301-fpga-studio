async()=>{
 let checks=0;
 for(let d=0;d<16;d++)for(let q=0;q<16;q++){
  const s=anatomyState();s.av=d;s.q=q;const e=anatomyEvaluate('register',s);
  if(e.partValues.D!==d||e.partValues.Q!==q)throw Error('register');checks+=2;
 }
 for(let a=0;a<8;a++)for(let b=0;b<8;b++){
  const s=anatomyState();s.reg=[0,11,22,33,44,55,66,77];s.r0=a;s.r1=b;const e=anatomyEvaluate('regfile',s);
  if(e.partValues.R0!==s.reg[a]||e.partValues.R1!==s.reg[b])throw Error('regfile');checks+=2;
 }
 for(const [a,b]of [[0,255],[85,170],['X',17]]){
  const s=anatomyState();s.readQ=a;s.readB=b;const e=anatomyEvaluate('bram',s);
  if(e.partValues.QA!==a||e.partValues.QB!==b)throw Error('bram');checks+=2;
 }
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('register');await new Promise(r=>setTimeout(r,200));
 if(document.querySelector('.an-scene [data-diagram-part="D"] .sc-port-code')?.textContent!=='D=5')throw Error('rendered D');
 return {status:'passed',checks:checks+1};
}
