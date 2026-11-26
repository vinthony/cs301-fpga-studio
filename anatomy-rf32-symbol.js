// The cells depict actual saved bits, never the bypassed output value.
export function drawRF32Symbol(p,g,{e,t,r,line}){
 if(p.type!=='rf32bank')return false;
 const l=p.cx-p.w/2,top=p.cy-p.h/2;
 r(l,top,p.w,p.h,{fill:'#f8fbfd',stroke:'#557b8b','stroke-width':2,rx:12,'class':'sc-body'},g);
 t('已保存的 32 × 32 位阵列',p.cx,top+29,{'text-anchor':'middle','font-size':18,'font-weight':700,fill:'#36596f'},g);
 t('点击行 → 读 A；Shift + 点击 → 读 B；写入须使用右侧时钟按钮',p.cx,top+49,{'text-anchor':'middle','font-size':12,fill:'#607c8c'},g);
 g._rf32=[];
 for(let col=0;col<2;col++){
  const left=l+17+col*488;
  t('寄存器',left+34,top+75,{'text-anchor':'middle','font-size':11,fill:'#607c8c'},g);
  t('十六进制',left+107,top+75,{'text-anchor':'middle','font-size':11,fill:'#607c8c'},g);
  for(let j=0;j<32;j++)if(j%4===0||j===31)t(String(31-j),left+166+j*9,top+75,{'text-anchor':'middle','font-size':9,fill:'#607c8c'},g);
  for(let row=0;row<16;row++){
   const address=col*16+row,y=top+91+row*30,node=e('g',{'data-rf32-row':address,role:'button',tabindex:0,'aria-label':'选择 x'+address+' 为读地址 A，Shift 选择 B'},g);
   const bg=r(left,y-14,470,26,{rx:4,fill:address===0?'#e7ecef':'#fff',stroke:'#d8e3e8','stroke-width':1},node);
   t('x'+address+(address===0?' / 0':''),left+10,y+4,{'font-family':'monospace','font-size':12,fill:'#36596f'},node);
   const value=t('00000000',left+108,y+4,{'text-anchor':'middle','font-family':'monospace','font-size':12,fill:'#36596f'},node),bits=[];
   for(let j=0;j<32;j++)bits.push(r(left+162+j*9,y-8,7,15,{rx:1,fill:'#e0e9ed',stroke:'none'},node));
   g._rf32.push({address,node,bg,value,bits});
  }
 }
 g._rf32WriteCells=[];t('待写输入 WD · 点击改位',l+30,top+580,{'font-size':12,fill:'#36596f'},g);
 for(let j=0;j<32;j++){const bit=31-j,node=e('g',{'data-rf32-write-bit':bit,role:'button',tabindex:0,'aria-label':'切换待写数据 bit'+bit},g),cell=r(l+215+j*13,top+568,10,17,{rx:2,fill:'#dce7ec',stroke:'#94b0bb'},node);g._rf32WriteCells.push({node,cell,bit})}
 g._rf32WriteHex=t('',l+660,top+581,{'font-size':13,'font-family':'monospace',fill:'#36596f'},g);t('bit31 → bit0；不直接修改阵列',l+788,top+580,{'font-size':11,fill:'#607c8c'},g);
 g._rf32ReadA=t('',l+30,top+604,{'font-size':13,fill:'#247f9a'},g);
 g._rf32ReadB=t('',l+30,top+627,{'font-size':13,fill:'#7752a3'},g);
 t('蓝=A　紫=B　金框=待写地址　深绿=已保存的 1　浅色=0',l+30,top+648,{'font-size':11,fill:'#607c8c'},g);
 return true;
}
export function updateRF32Symbol(g,state,evaluation){
 if(!g._rf32)return;
 for(const item of g._rf32){const i=item.address,v=i===0?0:(state.rfRegs?.[i]||0)>>>0,a=i===state.rfRA,b=i===state.rfRB,write=!!state.rfWE&&i===state.rfWA;
  item.value.textContent=v.toString(16).toUpperCase().padStart(8,'0');
  item.bg.setAttribute('fill',a&&b?'#e5e7fa':a?'#dceff7':b?'#ede5f7':i===0?'#e7ecef':'#fff');item.bg.setAttribute('stroke',write?'#b57f20':'#d8e3e8');item.bg.setAttribute('stroke-width',write?'2.4':'1');
  item.node.dataset.stored=String(v);item.node.dataset.readA=String(a);item.node.dataset.readB=String(b);item.node.dataset.pendingWrite=String(write);
  item.node.setAttribute('aria-label','x'+i+' 保存 0x'+item.value.textContent+(a?'，读 A':'')+(b?'，读 B':'')+(write?'，待写地址':'')+'；点击选 A，Shift 选 B');
  item.bits.forEach((cell,j)=>{const bit=(v>>>(31-j))&1;cell.setAttribute('fill',bit?'#398d75':'#dce7ec');cell.dataset.bit=String(bit)});
 }
 for(const item of g._rf32WriteCells||[]){const bit=((state.rfWD>>>0)>>>item.bit)&1;item.cell.setAttribute('fill',bit?'#318d9f':'#dce7ec');item.node.setAttribute('aria-label','待写 bit'+item.bit+'='+bit+'，点击翻转');item.node.setAttribute('aria-pressed',String(!!bit));item.node.dataset.value=String(bit)}if(g._rf32WriteHex)g._rf32WriteHex.textContent='0x'+(state.rfWD>>>0).toString(16).toUpperCase().padStart(8,'0');
 const info=evaluation.rf32;if(g._rf32ReadA)g._rf32ReadA.textContent='读 A · x'+(state.rfRA??0)+'：'+(info?.forwardA?'待写数据旁路（格子未写入）':'已保存阵列');if(g._rf32ReadB)g._rf32ReadB.textContent='读 B · x'+(state.rfRB??0)+'：'+(info?.forwardB?'待写数据旁路（格子未写入）':'已保存阵列');
}
