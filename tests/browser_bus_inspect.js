async()=>{
 const checks=[],ok=(v,n)=>{if(!v)throw Error(n);checks.push(n)},doc=(v,w)=>new DOMParser().parseFromString(anatomyBusMarkup(v,w),'text/html');
 for(const [v,w,u,s]of [[0,1,0,0],[1,1,1,-1],[15,4,15,-1],[8,4,8,-8],[-1,8,255,-1],[0x80000000,32,2147483648,-2147483648],[0xFFFFFFFF,32,4294967295,-1],[0x35,16,53,53]]){
  const d=doc(v,w),bits=[...d.querySelectorAll('.an-bus-bits b')].map(x=>x.textContent).join('');ok(bits.length===w&&BigInt('0b'+bits)===BigInt(u),'位模式 '+v+'/'+w);ok(d.querySelector('p').textContent.includes('无符号：'+u),'无符号值 '+v+'/'+w);if(w>1)ok(d.querySelector('p').textContent.includes('补码解释：'+s),'补码值 '+v+'/'+w);
 }
 for(const v of ['X','Z',undefined,null])ok(!doc(v,8).querySelector('.an-bus-bits'),'未知不变零 '+v);
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('fulladder');await new Promise(r=>setTimeout(r,120));const d=document.querySelector('.anatomy-dialog[open]');d.querySelector('[data-net="A"]').click();ok(d.querySelector('.an-inspector .an-bus-bits b').textContent==='1','选中信号显示真实位值');d.querySelector('[data-toggle="a"]').click();ok(d.querySelector('.an-inspector .an-bus-bits b').textContent==='0','位值随输入更新');return {status:'passed',checks:checks.length};
}
