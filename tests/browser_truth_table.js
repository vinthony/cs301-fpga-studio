async()=>{
 const checks=[],ok=(v,n)=>{if(!v)throw Error(n);checks.push(n)},wait=ms=>new Promise(r=>setTimeout(r,ms));let combinations=0;
 for(const id of ['and','or','xor','nand','nor','not','cmos','mux','halfadder','fulladder']){
  document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture(id);await wait(70);const d=document.querySelector('.anatomy-dialog[open]'),s=anatomyState(),truth=anatomyTruthRows(ANATOMY[id],s);
  for(let i=0;i<truth.rows.length;i++){
   const row=truth.rows[i],{a,b=0,cin=0}=row.inputs,expected=id==='and'?a&b:id==='or'?a|b:id==='xor'?a^b:id==='nand'?1-(a&b):id==='nor'?1-(a|b):['not','cmos'].includes(id)?1-a:id==='mux'?(cin?b:a):id==='halfadder'?a^b:a^b^cin;
   ok(row.values[0]===expected,id+' 独立布尔式 '+i);if(['halfadder','fulladder'].includes(id))ok(row.values[1]===(a+b+(id==='fulladder'?cin:0)>=2?1:0),id+' 进位 '+i);
   d.querySelector('[data-truth-row="'+i+'"]').click();ok(d.querySelector('[data-truth-row="'+i+'"]').getAttribute('aria-pressed')==='true',id+' 当前行 '+i);ok(Number(d.querySelector('.an-result-readout strong').textContent)===expected,id+' 实际模型 '+i);ok(d.querySelector('.an-result-readout small').textContent.endsWith('0'),id+' 无时钟推进 '+i);combinations++;
  }
  d.querySelector('[data-observation-prev]').click();const before=d.querySelector('.an-result-readout strong').textContent;d.querySelector('[data-truth-row="0"]').click();ok(d.querySelector('.an-result-readout strong').textContent===before,id+' 历史只读');
 }
 return {status:'passed',cases:10,combinations,checks:checks.length};
}
