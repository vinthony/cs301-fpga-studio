async()=>{
 const checks=[],ok=(v,n)=>{if(!v)throw Error(n);checks.push(n)},wait=ms=>new Promise(r=>setTimeout(r,ms)),d=()=>document.querySelector('.anatomy-dialog[open]');
 d()?.querySelector('[data-an-close]').click();openArchitecture('board');await wait(200);
 for(const [hex,a,b,low] of [['0035',5,3,8],['00FF',15,15,14]]){
  d().querySelector('[data-sw]').value=hex;d().querySelector('[data-set-sw]').click();const samples=d().querySelector('[data-observation-range]').max;
  d().querySelector('[data-board-open-adder]').click();await wait(150);ok(Number(d().querySelector('[data-field="av"]').value)===a&&Number(d().querySelector('[data-field="bv"]').value)===b,'开关输入带入 '+hex);ok(Number(d().querySelector('.an-result-readout strong').textContent)===low,'低四位和 '+hex);ok(d().querySelector('.an-transfer-note').textContent.includes('C4'),'说明整板完整和与本层低位区别');
  d().querySelector('[data-part="FA3"]').dispatchEvent(new MouseEvent('dblclick',{bubbles:true}));await wait(120);ok(d().querySelector('[data-toggle="a"]').textContent.endsWith('= '+((a>>3)&1)),'高位全加器带入实际A');
  d().querySelector('[data-return-parent]').click();await wait(100);d().querySelector('[data-return-parent]').click();await wait(120);ok(d().querySelector('[data-sw]').value===hex,'返回整板开关保持');ok(d().querySelector('[data-observation-range]').max===samples,'整板观察记录保持');ok(d().querySelector('.an-inspector .an-tag').textContent.startsWith('FPGA'),'返回定位FPGA');
 }
 return {status:'passed',checks:checks.length,cases:2};
}
