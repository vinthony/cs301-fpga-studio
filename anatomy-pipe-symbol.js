export function drawPipelineSymbol(p,g,{t,r,line}){
 if(!['pipeStage','pipeControl','pipeRF','pipeMem'].includes(p.type))return false;
 const l=p.cx-p.w/2,top=p.cy-p.h/2,text=(value,x,y,size=12)=>t(value,x,y,{'text-anchor':'middle','font-size':size},g);
 r(l,top,p.w,p.h,{rx:12,fill:'#f0f6f9',stroke:'#7d9daa','stroke-width':1.5,class:'sc-body'},g);
 const refs=g._pipeRuntime={kind:p.type,lines:[]};
 if(p.type==='pipeStage'){
  r(l,top,8,p.h,{rx:4,fill:'#b1cbb8'},g);text(p.id,p.cx,top+22,15);
  const ix=l+p.w-43,iy=top+10;
  if(p.id==='IF'){for(let i=0;i<4;i++)line(`M${ix} ${iy+i*5}h24`,{stroke:'#6d91a2','stroke-width':2},g)}
  if(p.id==='ID'){for(let i=0;i<4;i++)r(ix+i*7,iy,5,21,{fill:['#b7d9cf','#dcc8e9','#e4d29b','#b7d9cf'][i],rx:1},g)}
  if(p.id==='EX')text('±',ix+12,iy+20,25);
  if(p.id==='MEM'){for(let i=0;i<6;i++)r(ix+(i%3)*9,iy+Math.floor(i/3)*11,7,8,{fill:'#b6d6c7',rx:1},g)}
  if(p.id==='WB'){line(`M${ix+26} ${iy+12}H${ix}m8 -7-8 7 8 7`,{fill:'none',stroke:'#6d91a2','stroke-width':2},g)}

  refs.lines.push(text('',p.cx,top+52,19),text('',p.cx,top+78,12),text('',p.cx,top+105,11),text('',p.cx,top+132,11),text('',p.cx,top+158,11));
  text(p.id==='IF'?'下一条取指候选':'段寄存器保持的指令',p.cx,top+p.h-9,10);
 }else if(p.type==='pipeControl'){
  text('下一边沿的控制候选',p.cx,top+25,13);for(const y of [54,84,114,140])refs.lines.push(text('',p.cx,top+y,11));
 }else if(p.type==='pipeRF'){
  text('32 × 32 保存数组',p.cx,top+23,13);refs.cells=[];
  for(let i=0;i<32;i++){const x=l+12+(i%8)*34,y=top+40+Math.floor(i/8)*23;refs.cells.push(r(x,y,29,18,{rx:3,fill:'#dceaf0',stroke:'#b4c8d0'},g));text(''+i,x+14,y+13,8)}
  refs.lines.push(text('',p.cx,top+151,11));
 }else{
  text('小端数据RAM · MEM执行存储',p.cx,top+23,12);for(const y of [57,87,117,147])refs.lines.push(text('',p.cx,top+y,11));
 }
 return true;
}
export function updatePipelineSymbol(g,s){
 const ref=g._pipeRuntime,c=s.pipeline32;if(!ref||!c)return;
 const hex=v=>'0x'+(v>>>0).toString(16).toUpperCase().padStart(8,'0');let lines=[];
 if(ref.kind==='pipeStage'){
  const id=g._p.id,packet=id==='IF'?(c.pendingTrap?null:{pc:c.fetchPC,word:c.program[c.fetchPC/4],d:null}):c.stages[{ID:'ifid',EX:'idex',MEM:'exmem',WB:'memwb'}[id]];
  if(!packet)lines=['气泡 / 空级','无有效指令','不会写回或访问存储','',''];
  else if(id==='IF')lines=[Number.isInteger(packet.word)?'准备取指':'程序范围外',hex(packet.pc),Number.isInteger(packet.word)?hex(packet.word):'异常若未冲刷，将在EX确认','同一边沿若暂停则保持','跳转时当前前端候选被丢弃'];
  else lines=[packet.fetchUnavailable?'取指不可用':packet.d.name,hex(packet.pc)+' · #'+packet.id,packet.fault?'故障：'+packet.fault.kind:id==='ID'?hex(packet.word):'A '+hex(packet.r1)+' · B '+hex(packet.r2),id==='EX'?'当前保存操作数，前递另选':id==='MEM'?'ALU / 地址 '+hex(packet.alu??0):id==='WB'?'写回候选 '+hex(packet.wb??0):'按解码字段读保存寄存器',packet.fault?'等待更早指令排空':id==='WB'?'下一边沿写回 / 退休':id==='MEM'?'LOAD返回值下拍进入MEM/WB':'依赖当前冒险策略推进'];
 }else if(ref.kind==='pipeControl'){
  const d=s._pipePreview?.decision;lines=[d?.action??'等待推进','EX前递A：'+(d?.forwardA??'—'),'EX前递B：'+(d?.forwardB??'—'),'当前策略 '+c.mode+' · 暂停 '+c.stalls+' · 跳转 '+c.redirects];
 }else if(ref.kind==='pipeRF'){
  ref.cells.forEach((cell,i)=>cell.setAttribute('fill',c.regs[i]?'#a9d7bf':'#e9f2f6'));lines=['x5='+hex(c.regs[5])+' · WB→ID写优先'];
 }else lines=['RAM[0..3] '+c.memory.slice(0,4).map(v=>v.toString(16).padStart(2,'0')).join(' '),'LED '+hex(c.led),'DISPLAY '+hex(c.display),'存储可先于该指令WB退休可见'];
 ref.lines.forEach((node,i)=>node.textContent=lines[i]??'');
}
