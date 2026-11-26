export function drawAsyncSymbol(p,g,{t,r,line}){
 if(!['asyncSync','asyncControl','asyncShift'].includes(p.type))return false;
 const l=p.cx-p.w/2,top=p.cy-p.h/2,ref=g._asyncRuntime={kind:p.type,lines:[],cells:[]},text=(v,x,y,size=12)=>t(v,x,y,{'text-anchor':'middle','font-size':size},g);
 r(l,top,p.w,p.h,{rx:12,fill:'#eff5f8',stroke:'#7a9eae','stroke-width':1.6,class:'sc-body'},g);
 if(p.type==='asyncSync'){
  text('每级采旧值 · 非亚稳态仿真',p.cx,top+25,13);
  for(let i=0;i<2;i++){const x=l+25+i*150;r(x,top+50,100,74,{rx:4,fill:'#e1edf3',stroke:'#7c9eaf'},g);text('FF'+(i+1),x+50,top+72,12);ref.lines.push(text('',x+50,top+104,23))}
  line(`M${l+125} ${top+88}H${l+175}`,{stroke:'#6e96a4','stroke-width':2},g);ref.lines.push(text('',p.cx,top+158,12),text('状态机使用边沿前的FF2',p.cx,top+184,11));
 }else if(p.type==='asyncControl'){
  text('8倍采样状态机',p.cx,top+25,14);for(const y of [58,89,120,154,187])ref.lines.push(text('',p.cx,top+y,y===58?20:12));
 }else{
  text('按d0…d7逐位保存',p.cx,top+25,14);for(let i=0;i<8;i++){const x=l+18+i*40;ref.cells.push(r(x,top+48,30,29,{rx:4,fill:'#dbe9ed',stroke:'#aac6cf'},g));text('d'+(7-i),x+15,top+94,9)}
  for(const y of [125,157,188])ref.lines.push(text('',p.cx,top+y,12));
 }
 return true;
}
export function updateAsyncSymbol(g,s){
 const ref=g._asyncRuntime,r=s.uartAsync;if(!ref||!r)return;let lines=[];
 if(ref.kind==='asyncSync')lines=[r.first,r.second,'当前原始RX='+s.a,'状态机使用边沿前的FF2'];
 else if(ref.kind==='asyncControl')lines=[r.phase,r.phase==='DATA'?'等待计数 '+r.timer+' · 下一数据位 d'+r.bit:r.phase==='START'?'起始确认计数 '+r.timer+' / 4':r.phase==='STOP'?'停止位计数 '+r.timer+' / 8':'等待起始低电平','valid='+r.valid+' · error='+r.error,'拒绝起始候选 '+r.falseStarts+' 次','采样总数 '+r.samples];
 else{lines=['组装值 '+r.shift+' / 0x'+r.shift.toString(16).padStart(2,'0'),'最近完成字节 '+r.data,'当前采样valid事件：'+r.valid];ref.cells.forEach((n,i)=>n.setAttribute('fill',(r.shift>>>(7-i))&1?'#4f9c86':'#dbe9ed'))}
 ref.lines.forEach((n,i)=>n.textContent=lines[i]);
}
