const DEC32_EXPLANATIONS={
 valid:'编码匹配成功，不代表运行时不会发生对齐或访问异常。',
 useRS1:'启用 rs1 源操作数读取；为0时，不把这个位置的位当作源地址。',
 useRS2:'启用 rs2 源操作数读取；立即数指令的这些位通常属于立即数字段。',
 regWrite:'只提出写 rd 的请求；rd=x0 会丢弃写入，当前也没有时钟提交。',
 memRead:'请求读取存储器；地址、对齐、权限与返回数据尚未由执行阶段处理。',
 memWrite:'请求写入存储器；待写数据来自 rs2，当前尚未提交任何存储写入。',
 branch:'这是条件分支；比较两个操作数后，才决定是否选择跳转目标。',
 jump:'选择 JAL/JALR 跳转路径；目标计算、对齐检查和 PC 更新仍待执行。',
 useImm:'ALU 的 B 输入选择立即数；STORE 待写到存储器的数据仍来自 rs2。',
 usePC:'ALU 的 A 输入选择 PC，用于本教学通路的 PC 相对运算。',
 trap:'ECALL/EBREAK 提出陷入请求；本页不执行异常入口或调试环境。',
 fence:'提出内存排序请求；本页没有运行访存序列，也没有执行排序。'
};
export function drawDecoder32Symbol(p,g,{e,t,r,line}){
 if(!['dec32table','dec32control'].includes(p.type))return false;
 const l=p.cx-p.w/2,top=p.cy-p.h/2;
 r(l,top,p.w,p.h,{fill:'#f8fbfd',stroke:'#557b8b','stroke-width':2,rx:12,'class':'sc-body'},g);
 if(p.type==='dec32table'){
  t('字段取位 → 编码匹配 → 控制请求',p.cx,top+30,{'text-anchor':'middle','font-size':19,'font-weight':700,fill:'#36596f'},g);
  g._dec32Bits=[];for(let j=0;j<32;j++){const bit=31-j,x=l+52+j*28,node=e('g',{'data-dec32-input-bit':bit,role:'button',tabindex:0},g);t(String(bit),x+11,top+66,{'text-anchor':'middle','font-size':10,fill:'#607c8c'},node);const cell=r(x,top+77,22,32,{rx:3,fill:'#e5edf2',stroke:'#94aebb'},node),value=t('0',x+11,top+99,{'text-anchor':'middle','font-family':'monospace','font-size':17,fill:'#36596f'},node);g._dec32Bits.push({bit,node,cell,value})}
  g._dec32Fields=[];for(const [leftBit,rightBit]of [[31,25],[24,20],[19,15],[14,12],[11,7],[6,0]]){const x=l+52+(31-leftBit)*28,w=(leftBit-rightBit+1)*28-6;r(x,top+116,w,24,{rx:3,fill:'#eef3f6',stroke:'#c2d2db'},g);const text=t('',x+w/2,top+132,{'text-anchor':'middle','font-size':11,fill:'#607c8c'},g);g._dec32Fields.push({leftBit,rightBit,text})}
  t('点击行装载对应示例；不是执行指令',l+20,top+166,{'font-size':12,fill:'#607c8c'},g);
  t('指令 / 格式 / 类别',l+20,top+190,{'font-size':11,fill:'#607c8c'},g);t('写寄存器 / 写存储 / 陷入',l+302,top+190,{'font-size':10,fill:'#607c8c'},g);
  t('指令 / 格式 / 类别',l+520,top+190,{'font-size':11,fill:'#607c8c'},g);t('写寄存器 / 写存储 / 陷入',l+802,top+190,{'font-size':10,fill:'#607c8c'},g);
  g._dec32Rows=[];p.entries.forEach((c,index)=>{const col=Math.floor(index/20),row=index%20,x=l+14+col*500,y=top+210+row*27,node=e('g',{'data-dec32-case':index,role:'button',tabindex:0,'aria-label':'装载 '+c.name+' 示例'},g),bg=r(x,y-14,472,25,{rx:4,fill:'#fff',stroke:'#dce6ec'},node);t(c.name,x+10,y+3,{'font-size':13,'font-family':'monospace','font-weight':600,fill:'#36596f'},node);t(c.format,x+92,y+3,{'font-size':12,fill:'#607c8c'},node);t(c.group,x+119,y+3,{'font-size':11,fill:'#607c8c'},node);for(const [j,key]of ['regWrite','memWrite','trap'].entries())e('circle',{cx:x+320+j*52,cy:y-2,r:4.5,fill:c[key]?'#5aa08a':'#e3ebf0',stroke:'#a4bcc6'},node);g._dec32Rows.push({index,node,bg})});
  g._dec32Status=t('',l+24,top+785,{'font-size':18,'font-weight':700,fill:'#36596f'},g);
  g._dec32Detail=t('',l+24,top+815,{'font-size':13,fill:'#607c8c'},g);
  g._dec32Raw=t('',l+24,top+845,{'font-size':12,'font-family':'monospace',fill:'#607c8c'},g);
  t('浅灰字段可能不是源寄存器；地址位存在，不等于启用读取。扩展指令不在此表。',l+24,top+876,{'font-size':12,fill:'#607c8c'},g);
 }else{
  t('只读控制请求',p.cx,top+31,{'text-anchor':'middle','font-size':18,'font-weight':700,fill:'#36596f'},g);
  g._dec32Signals=[];p.signals.forEach(([key,label],i)=>{const y=top+67+i*32,node=e('g',{'data-dec32-signal':key,role:'button',tabindex:0},g),bg=r(l+14,y-17,p.w-28,28,{rx:4,fill:'#f8fbfd',stroke:'none'},node),lamp=e('circle',{cx:l+33,cy:y-3,r:7,fill:'#e2ebef',stroke:'#8daab9'},node),value=t('0',l+33,y+1,{'text-anchor':'middle','font-size':10,fill:'#36596f'},node);t(label,l+51,y+1,{'font-size':12,fill:'#36596f'},node);g._dec32Signals.push({key,node,bg,lamp,value})});
  g._dec32ALU=t('',l+20,top+470,{'font-size':13,fill:'#36596f'},g);g._dec32WB=t('',l+20,top+498,{'font-size':13,fill:'#36596f'},g);g._dec32Mem=t('',l+20,top+526,{'font-size':12,fill:'#607c8c'},g);g._dec32Effective=t('',l+20,top+554,{'font-size':12,fill:'#607c8c'},g);g._dec32Focus=t('',l+20,top+591,{'font-size':12,'font-weight':600,fill:'#36596f'},g);g._dec32Descriptions=[0,1,2].map(i=>t('',l+20,top+619+i*21,{'font-size':11,fill:'#607c8c'},g));g._dec32Word=t('',l+20,top+707,{'font-size':12,'font-family':'monospace',fill:'#607c8c'},g);
 }
 return true;
}
export function updateDecoder32Symbol(g,s,e,selection){
 const d=e.dec32;if(!d)return;
 for(const item of g._dec32Bits||[]){const value=(d.word>>>item.bit)&1;item.value.textContent=String(value);let fill=item.bit<=6?'#e9c17e':item.bit<=11?d.format==='S'||d.format==='B'?'#bbaadd':d.regWrite?'#a9d5ba':'#e4ebef':item.bit<=14?['R','I','S','B'].includes(d.format)?'#c4b0e3':'#b4dbcd':item.bit<=19?d.useRS1?'#98cede':'#d5e8df':item.bit<=24?d.useRS2?'#98cede':d.format==='I'||d.format==='J'||d.format==='U'?'#b4dbcd':'#e4ebef':d.format==='R'||d.shiftImmediate?'#c4b0e3':'#b4dbcd';if(!d.valid&&item.bit>6)fill='#e5e9ed';item.cell.setAttribute('fill',fill);item.node.dataset.value=String(value);item.node.setAttribute('aria-label','指令 bit'+item.bit+'='+value+'；点击翻转');item.node.setAttribute('aria-pressed',String(!!value))}
 const labels=d.format==='R'?['funct7','rs2','rs1','funct3','rd','opcode']:d.format==='I'?[d.shiftImmediate?'funct7':'imm 高位',d.shiftImmediate?'shamt':'imm 低位','rs1','funct3','rd','opcode']:d.format==='S'||d.format==='B'?['imm 高位','rs2','rs1','funct3','imm 低段','opcode']:d.format==='U'||d.format==='J'?['imm 字段','imm 字段','imm 字段','imm 字段','rd','opcode']:['SYSTEM / fm','功能字段','保留 / 忽略','funct3','保留 / 忽略','opcode'];(g._dec32Fields||[]).forEach((item,i)=>item.text.textContent=labels[i]);
 for(const item of g._dec32Rows||[]){const active=d.valid&&item.index===d.id;item.bg.setAttribute('fill',active?'#d8f0e5':'#fff');item.bg.setAttribute('stroke',active?'#37977b':'#dce6ec');item.bg.setAttribute('stroke-width',active?'2':'1');item.node.dataset.matched=String(!!active);item.node.setAttribute('aria-pressed',String(!!active))}
 if(g._dec32Status){g._dec32Status.textContent=d.valid?'已匹配 '+d.name+' · '+d.format+' 格式':'未匹配：关闭所有写请求';g._dec32Status.setAttribute('fill',d.valid?'#24795f':'#b45544');g._dec32Detail.textContent=d.reason;g._dec32Raw.textContent='opcode=0x'+d.opcode.toString(16)+'  funct3='+d.funct3+'  funct7=0x'+d.funct7.toString(16)+'  rs1='+d.rs1+'  rs2='+d.rs2+'  rd='+d.rd}
 for(const item of g._dec32Signals||[]){const v=d[item.key]?1:0;item.lamp.setAttribute('fill',v?'#79c3a1':'#e2ebef');item.value.textContent=String(v);item.bg.setAttribute('fill',selection?.decSignal===item.key?'#e4edf7':'#f8fbfd');item.node.dataset.value=String(v);item.node.setAttribute('aria-label',item.key+'='+v+'，点击查看')}
 if(g._dec32ALU){g._dec32ALU.textContent='ALU：'+(d.valid?d.aluOp:'—');g._dec32WB.textContent='回写来源：'+(d.regWrite?d.wb:'无回写');g._dec32Mem.textContent=d.memRead||d.memWrite?'访存粒度：'+['字节','半字','字'][d.memSize]+(d.memRead?(d.memSize===2?' · 32位原样':d.loadUnsigned?' · 零扩展':' · 符号扩展'):''):'当前无访存请求';g._dec32Effective.textContent='x0 保护后有效写请求：'+d.effectiveRegWrite;const focus=selection?.decSignal||'regWrite';g._dec32Focus.textContent=focus+' = '+(d[focus]?1:0)+(focus==='branch'?'（条件尚未比较）':focus==='regWrite'?'（仅解码请求）':focus==='trap'?'（尚未进入异常处理）':'（未执行）');const explanation=Array.from(DEC32_EXPLANATIONS[focus]||'');g._dec32Descriptions.forEach((node,i)=>node.textContent=explanation.slice(i*26,(i+1)*26).join(''));g._dec32Word.textContent='摘要 0x'+d.control.toString(16).toUpperCase().padStart(4,'0')+' · 高4位=回写/粒度'}
}
