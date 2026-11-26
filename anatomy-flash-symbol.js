export function drawFlashSymbol(p,g,{t,r,line}){
 if(!['flashControl','flashBytes'].includes(p.type))return false;
 const l=p.cx-p.w/2,top=p.cy-p.h/2,text=(s,x,y,size=12)=>t(s,x,y,{'text-anchor':'middle','font-size':size},g),ref=g._flashRuntime={kind:p.type,lines:[],rows:[],cells:[]};
 r(l,top,p.w,p.h,{rx:12,fill:'#f0f5f9',stroke:'#7898aa','stroke-width':1.6,class:'sc-body'},g);
 if(p.type==='flashControl'){
  text('功能操作 · 非串行协议状态机',p.cx,top+24,13);
  for(let i=0;i<3;i++){const x=l+12+i*108;ref.rows.push(r(x,top+41,100,43,{rx:7,fill:'#e3edf2',stroke:'#adc3cc'},g));text(['读取','编程 AND','擦除全块'][i],x+50,top+67,12)}
  line(`M${p.cx} ${top+88}v12`,{stroke:'#597c8d','stroke-width':2},g);
  for(const y of [119,146,173])ref.lines.push(text('',p.cx,top+y,12));
 }else{
  text('8字节 × 8位 · 真实保存值',p.cx,top+22,13);
  for(let a=0;a<8;a++){
   const y=top+43+a*21;ref.rows.push(r(l+10,y-13,p.w-20,20,{rx:4,fill:'none',stroke:'none'},g));text('@'+a,l+31,y+1,10);
   for(let bit=7;bit>=0;bit--){const x=l+58+(7-bit)*25;ref.cells.push({address:a,bit,node:r(x,y-11,19,15,{rx:2,fill:'#dde9ec',stroke:'#b1c6ce'},g)})}
   ref.lines.push(text('',l+p.w-31,y+1,10));
  }
  text('深色=1 · 浅色=0 · 金框=当前地址',p.cx,top+p.h-10,10);
 }
 return true;
}
export function updateFlashSymbol(g,s){
 const ref=g._flashRuntime;if(!ref||!s.flashBytes)return;const hex=v=>'0x'+v.toString(16).toUpperCase().padStart(2,'0');
 if(ref.kind==='flashControl'){
  const last=s.flashLast,selected=last?.kind==='program'?1:last?.kind==='erase'?2:0;
  ref.rows.forEach((n,i)=>n.setAttribute('fill',i===selected?'#f3dfaa':'#e3edf2'));
  const lines=['当前读取 @'+s.addr+' = '+hex(s.flashBytes[s.addr]),last?.kind==='program'?'最近编程 @'+last.address+'：'+hex(last.before)+' AND '+hex(last.data):last?.kind==='erase'?'最近操作：8字节整块擦除':'尚未执行编程 / 擦除',last?.kind==='program'?'实际保存 → '+hex(last.after):last?.kind==='erase'?'全部恢复 0xFF':'修改输入只是候选，不写阵列'];
  ref.lines.forEach((n,i)=>n.textContent=lines[i]);
 }else{
  ref.rows.forEach((n,a)=>{n.setAttribute('stroke',a===s.addr?'#c3912b':'none');n.setAttribute('fill',a===s.addr?'#fff1c9':'none')});
  for(const c of ref.cells)c.node.setAttribute('fill',(s.flashBytes[c.address]>>>c.bit)&1?'#4e9b87':'#dce7ec');
  ref.lines.forEach((n,a)=>n.textContent=s.flashBytes[a].toString(16).toUpperCase().padStart(2,'0'));
 }
}
