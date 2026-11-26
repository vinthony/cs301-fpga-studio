export function drawImmediate32Symbol(p,g,{e,t,r,line}){
 if(p.type!=='imm32map')return false;
 const l=p.cx-p.w/2,top=p.cy-p.h/2,dx=34,start=l+47;
 r(l,top,p.w,p.h,{fill:'#f8fbfd',stroke:'#557b8b','stroke-width':2,rx:12,'class':'sc-body'},g);
 g._imm32Title=t('',p.cx,top+30,{'text-anchor':'middle','font-size':20,'font-weight':700,fill:'#36596f'},g);
 t('inst[31:0] · 可点击输入位',l+30,top+63,{'font-size':14,fill:'#36596f'},g);
 t('imm[31:0] · 输出只读，点击追踪来源',l+30,top+366,{'font-size':14,fill:'#36596f'},g);
 g._imm32Paths=[];
 for(let j=0;j<32;j++){const node=line('',{stroke:'#8faebe','stroke-width':1.1,fill:'none','pointer-events':'none'},g);g._imm32Paths.push({bit:31-j,node})}
 g._imm32Inputs=[];g._imm32Outputs=[];
 for(const [kind,y]of [['input',100],['output',390]])for(let j=0;j<32;j++){
  const bit=31-j,x=start+j*dx,node=e('g',{['data-imm32-'+kind+'-bit']:bit,role:'button',tabindex:0,'aria-label':kind==='input'?'翻转指令 bit'+bit:'追踪立即数 bit'+bit},g);
  t(String(bit),x+14,top+y-7,{'text-anchor':'middle','font-size':10,fill:'#607c8c'},node);
  const cell=r(x,top+y,28,40,{rx:3,fill:'#eef3f6',stroke:'#a4bac5','stroke-width':1.2},node),value=t('0',x+14,top+y+26,{'text-anchor':'middle','font-size':18,'font-family':'monospace',fill:'#36596f'},node);
  (kind==='input'?g._imm32Inputs:g._imm32Outputs).push({bit,node,cell,value,x:x+14});
 }
 g._imm32Trace=t('',l+30,top+488,{'font-size':18,'font-weight':700,fill:'#36596f'},g);
 g._imm32Detail=t('',l+30,top+516,{'font-size':13,fill:'#607c8c'},g);
 t('橙：符号位 / 符号复制　青紫绿：参与重排的字段　灰：非立即数字段 / 固定 0',l+30,top+551,{'font-size':12,fill:'#607c8c'},g);
 g._imm32Hint=t('',l+30,top+584,{'font-size':13,fill:'#607c8c'},g);
 g._imm32Geometry={top,start,dx};return true;
}
export function updateImmediate32Symbol(g,s,e,selection){
 if(!g._imm32Inputs)return;
 const {top,start,dx}=g._imm32Geometry,word=s.immInstruction>>>0,output=e.result>>>0,format=s.immFormat,source=e.imm32?.sources||Array(32).fill(-1),focus=Number.isInteger(selection?.immOutputBit)?selection.immOutputBit:31,origin=source[focus],used=new Set(source.filter(v=>v>=0));
 const color=bit=>bit===31?'#e4ac63':format==='B'&&bit===7?'#cf8aab':bit>=20?'#8dccdf':bit>=12?'#a9d6ba':'#bbabe0';
 g._imm32Title.textContent=format+' 格式 · 逐位来源图（不是物理布线）';
 for(const item of g._imm32Inputs){const bit=(word>>>item.bit)&1;item.value.textContent=String(bit);item.cell.setAttribute('fill',used.has(item.bit)?color(item.bit):'#edf1f4');item.value.setAttribute('fill',used.has(item.bit)?'#244a60':'#9aaab4');item.cell.setAttribute('stroke',item.bit===origin?'#173d57':'#9ab0be');item.cell.setAttribute('stroke-width',item.bit===origin?'3':'1.1');item.node.dataset.value=String(bit);item.node.dataset.used=String(used.has(item.bit));item.node.setAttribute('aria-label','inst['+item.bit+']='+bit+(used.has(item.bit)?'，参与立即数':'，当前格式不使用')+'；点击翻转');item.node.setAttribute('aria-pressed',String(!!bit))}
 for(const item of g._imm32Outputs){const bit=(output>>>item.bit)&1,from=source[item.bit];item.value.textContent=String(bit);item.cell.setAttribute('fill',from<0?'#edf1f4':color(from));item.cell.setAttribute('stroke',item.bit===focus?'#173d57':'#9ab0be');item.cell.setAttribute('stroke-width',item.bit===focus?'3':'1.1');item.node.dataset.value=String(bit);item.node.dataset.source=from<0?'zero':String(from);item.node.setAttribute('aria-label','imm['+item.bit+']='+bit+'，'+(from<0?'固定为0':'来自 inst['+from+']')+'；点击追踪')}
 for(const item of g._imm32Paths){const from=source[item.bit],x=start+(31-item.bit)*dx+14,sx=from<0?x:start+(31-from)*dx+14,selected=item.bit===focus;item.node.setAttribute('d',from<0?`M${x} ${top+378}V${top+390}`:`M${sx} ${top+140}C${sx} ${top+238} ${x} ${top+292} ${x} ${top+390}`);item.node.setAttribute('stroke',from<0?'#8b9fa9':color(from));item.node.setAttribute('stroke-width',selected?'3':'1.2');item.node.setAttribute('opacity',selected?'1':'.28')}
 const signLimit=({I:12,S:12,B:13,J:21})[format],extended=origin===31&&signLimit&&focus>=signLimit;
 g._imm32Trace.textContent='imm['+focus+'] = '+(origin<0?'固定 0':'inst['+origin+'] = '+((word>>>origin)&1));
 g._imm32Detail.textContent=origin<0?(format==='U'?'U 的低12位固定补零。':'偏移最低位隐含为0，不从指令中读取。'):extended?'这是符号扩展：复制 inst[31]，保留补码数值；不是补进位。':'这一位按格式从指令原位置接到输出；点击其他输出位比较来源。';
 const hint=e.imm32?.hint;g._imm32Hint.textContent=hint===format?'opcode 提示当前格式匹配；本图不验证完整指令合法性。':hint?'格式对照：opcode 提示 '+hint+'，当前手选 '+format+'；不是按此格式执行指令。':'opcode 不在格式提示范围；仍可按手选格式观察位拼接。';g._imm32Hint.setAttribute('fill',hint&&hint!==format?'#a85e31':'#607c8c');
}
