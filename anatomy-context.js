'use strict';
// Context uses declared child references plus explicitly named functional associations.
// Functional containment is not a claim about proprietary silicon floorplans.
const AN_CONTEXT_ASSOCIATIONS={repr4:'system',float32:'system',seq1011:'fsm',fpgaFabric:'board',clb:'fpgaFabric',slice:'clb',register:'slice',dff:'register',latch:'dff',lut:'slice',carry4:'slice',iobank:'fpgaFabric',dsp:'fpgaFabric',bram:'fpgaFabric',sram:'memorySystem',sramcell:'sram',fulladder:'adder',adder:'alu',logic:'alu',truth2:'logic',demorganNand:'nand',demorganNor:'nor',transmission:'logic',compare:'logic',decoder3:'sram',decoder:'logic',shifter:'alu',fsm:'control',and:'logic',or:'logic',xor:'logic',not:'logic',nand:'and',nor:'or',cmos:'not',nmos:'cmos',pmos:'cmos',mux:'alu',routing:'clb',synchronizer:'input',debounce:'input',edge:'input',input:'switches',clocking:'fpgaFabric',reset:'clocking',system:'board',cpu:'system',alu:'cpu',pc:'cpu',regfile:'cpu',instruction:'cpu',immediate:'instruction',control:'cpu',loadstore:'cpu',pipeline:'cpu',forward:'pipeline',hazard:'pipeline',branch:'cpu',memorySystem:'system',cache:'memorySystem',cachecheck:'cache',tageq5:'cachecheck',tag:'cache',cachefsm:'cache',dram:'memorySystem',dramcell:'dram',uart:'board',uartcore:'uart',baud:'uartcore',tx:'uartcore',rx:'uartcore',shiftreg:'tx',vgacore:'vga',adccore:'xadc',usbcore:'usbhost',halfadder:'fulladder',masterSlave:'dff',wires:'immediate',io:'system'};
function anatomyContextPath(id,trail=[id]){
 const parents={},queue=['board'],seen=new Set(queue);while(queue.length){const parent=queue.shift();for(const p of ANATOMY[parent].parts)if(p.ref&&!seen.has(p.ref)){parents[p.ref]=parent;seen.add(p.ref);queue.push(p.ref)}}Object.assign(parents,AN_CONTEXT_ASSOCIATIONS);
 const start=trail[0]||id,chain=[],visited=new Set();let cur=start;while(cur&&!visited.has(cur)){chain.unshift(cur);visited.add(cur);cur=parents[cur]}
 if(chain[0]!=='board')chain.unshift('board');for(const x of trail.slice(1))if(chain.at(-1)!==x)chain.push(x);if(chain.at(-1)!==id)chain.push(id);return chain;
}
// Small structural symbols share the same visual vocabulary as the main circuit.
// These icons identify a component family; they do not represent live signal levels.
function anatomyContextSymbol(type,x,y,fill,stroke,comparison='eq'){
 let body='',family=type;
 if(['and','nand'].includes(type))body='<path d="M-7-5H0A5 5 0 0 1 0 5H-7Z"/>'+(type==='nand'?'<circle cx="7" r="1.5"/>':'');
 else if(['or','nor','xor'].includes(type))body='<path d="M-8-5Q1-5 7 0Q1 5-8 5Q-3 0-8-5Z"/>'+(type==='xor'?'<path d="M-10-5Q-5 0-10 5" fill="none"/>':type==='nor'?'<circle cx="8.5" r="1.5"/>':'');
 else if(['not','inverter','buffer','clockbuffer'].includes(type))body='<path d="M-7-5L4 0-7 5Z"/>'+(['not','inverter'].includes(type)?'<circle cx="6" r="1.5"/>':'');
 else if(['mux','muxtree'].includes(type))body='<path d="M-6-7L6-4V4L-6 7Z"/><path d="M0 6V10" fill="none"/>';
 else if(['fa','adder','alu','rvarith','multiply','compare'].includes(type)){body='<circle r="7"/>'+(['alu','rvarith'].includes(type)?'<text y="2" text-anchor="middle" font-size="4" stroke="none" fill="'+stroke+'">ALU</text>':type==='compare'?(comparison==='lt'?'<path d="M3-3L-3 0 3 3" fill="none"/>':'<path d="M-3-2H3M-3 2H3" fill="none"/>'):type==='multiply'?'<path d="M-3-3L3 3M-3 3L3-3" fill="none"/>':'<path d="M-3 0H3M0-3V3" fill="none"/>');family='arithmetic' }
 else if(['ram','rom','lut','bitgrid','cache','regfile','flash','flashBytes','fifoBytes'].includes(type)){body='<rect x="-9" y="-6" width="18" height="12" rx="1"/><path d="M-3-6V6M3-6V6M-9 0H9" fill="none"/>';family='memory'}
 else if(['register','dff','latch','counter','shift','multiplyRegister','asyncShift'].includes(type)){body='<rect x="-8" y="-6" width="16" height="12" rx="1"/><path d="M-8 1L-4 3-8 5" fill="none"/><path d="M-3-3H3M3-3V3H-3" fill="none"/>';family='storage'}
 else if(['nmos','pmos'].includes(type))body='<path d="M-4-5V5M-1-5V5M-1-3H5V-8M-1 3H5V8M-8 0H-4" fill="none"/>'+(type==='pmos'?'<circle cx="-5.5" r="1.5"/>':'');
 else if(type==='resistor')body='<path d="M-10 0H-7L-5-3-2 3 1-3 4 3 7 0H10" fill="none"/>';
 else if(type==='capacitor')body='<path d="M-10 0H-2M-2-6V6M2-6V6M2 0H10" fill="none"/>';
 else if(['oscillator','clockspine','resonator'].includes(type))body='<rect x="-10" y="-6" width="20" height="12" rx="2"/><path d="M-7 3V-3H0V3H7" fill="none"/>';
 else if(type==='port')body='<path d="M-8-4H3L8 0 3 4H-8Z"/>';
 else body='<rect x="-8" y="-5" width="16" height="10" rx="2"/><path d="M-5-8V-5M0-8V-5M5-8V-5M-5 5V8M0 5V8M5 5V8" fill="none"/>';
 return `<g data-context-symbol="${family}" transform="translate(${x} ${y})" fill="${fill}" stroke="${stroke}" stroke-width="1" stroke-linecap="round" stroke-linejoin="round">${body}</g>`;
}
function anatomyContextLenses(chain,esc,instances={}){
 const width=300,row=144,height=chain.length*row+12;
 return `<div class="an-context-cutaway" tabindex="0" aria-label="逐层位置图，可滚动查看上级"><div class="an-context-tools"><button type="button" data-context-locate>◎ 回到当前层</button></div><svg class="an-context-lenses" viewBox="0 0 ${width} ${height}" role="group" aria-label="逐层透视定位图">${chain.map((id,i)=>{
  const current=i===chain.length-1,y=i*row+6,model=ANATOMY[id],next=chain[i+1],linked=model.parts.filter(p=>p.ref===next&&(!instances[i+1]||p.id===instances[i+1])),title=model.title.split(' · ')[0],contained=i===0||ANATOMY[chain[i-1]].parts.some(p=>p.ref===id);
  const parts=model.parts, xs=parts.map(p=>p.x),zs=parts.map(p=>p.z),minX=Math.min(...xs)-2,maxX=Math.max(...xs)+2,minZ=Math.min(...zs)-2,maxZ=Math.max(...zs)+2;
  const pos=p=>[24+(p.x-minX)/(maxX-minX||1)*252,y+48+(p.z-minZ)/(maxZ-minZ||1)*64];
  const wires=model.nets.map(n=>{const p=parts.find(p=>p.id===n.from.split('.')[0]),q=parts.find(p=>p.id===n.to.split('.')[0]);if(!p||!q)return '';const [x1,y1]=pos(p),[x2,y2]=pos(q);return `<path d="M${x1} ${y1}H${(x1+x2)/2}V${y2}H${x2}" fill="none" stroke="#487888" stroke-width=".7"/>`}).join('');
  const mini=parts.map(p=>{const [x,z]=pos(p),active=linked.includes(p),fill=active?'#f5d67f':p.type==='port'?'#79c5d8':'#286079';return `<g data-context-unit="${esc(p.id)}" ${active?'data-context-highlight="true"':''}><title>${esc(p.label)}</title>${anatomyContextSymbol(p.type,x,z,fill,active?'#fff3b9':'#a4d3e1',p.comparison)}${active?`<circle cx="${x}" cy="${z}" r="12" fill="none" stroke="#ffdf87" stroke-dasharray="2 2"/>`:''}</g>`}).join('');
  return `${i?`<path d="M150 ${y-17}V${y-1}" stroke="#e4c779" stroke-width="2" ${contained?'':'stroke-dasharray="3 3"'}/><path d="M146 ${y-5}L150 ${y-1}L154 ${y-5}" fill="none" stroke="#e4c779"/>`:''}<g role="button" tabindex="0" data-context-id="${esc(id)}" data-context-lens="${esc(id)}" ${current?'aria-current="location"':''} aria-label="${esc(title)}${current?'，当前位置':'，点击返回'}"><rect x="8" y="${y}" width="284" height="126" rx="10" fill="${current?'#302d20':'#102d3b'}" stroke="${current?'#f5d67f':'#497584'}"/><text x="20" y="${y+19}" fill="#e1edf0" font-size="12">${i+1}. ${esc(title.slice(0,22))}</text><rect x="17" y="${y+30}" width="266" height="85" rx="${id==='board'?12:5}" fill="${id==='board'?'#17566b':'#0c202d'}" stroke="#447b8b"/>${wires}${mini}<text x="20" y="${y+123}" fill="#f2d68f" font-size="8">${current?'● 你在这里 · 当前展开层':linked.length?'放大单元：'+esc(linked.map(p=>p.id+' '+p.label).join(' / ').slice(0,36)):'虚线关系：功能关联，非物理包含'}</text></g>`;
 }).join('')}</svg></div>`;
}
function anatomyContextRegion(id,chain=[]){
 if(['board','system','io'].includes(id))return 'board';
 if(chain.some(node=>node==='dram'||node==='dramcell'))return 'extension';
 const regions={power:'power',regulator:'power',flash:'memory',switches:'input',buttons:'input',leds:'output',ledjunction:'output',sevenseg:'display',usbhost:'interface',usbtransport:'interface',uart:'programming',programming:'programming',pmod:'expansionPort',xadc:'analog',clock:'clock',vga:'vga'};
 return regions[id]||'fpga';
}
function anatomyContextMarkup(id,trail,origins=[]){
 const esc=x=>String(x).replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c])),chain=anatomyContextPath(id,trail),title=ANATOMY[id].title.split(' · ')[0];
 const instances={};const offset=chain.length-trail.length;trail.forEach((node,i)=>{if(i>0&&origins[i])instances[offset+i]=origins[i]});
 const groups=[['power','power',20,32,43,22],['flash','memory',32,71,47,28],['switches','input',18,139,202,14],['leds','output',18,119,202,9],['sevenseg','display',30,103,49,10],['usbhost','interface',191,31,40,24],['xadc','analog',222,76,10,35],['clock','clock',79,48,19,10],['fpgaFabric','fpga',107,58,76,59]];
 const group=anatomyContextRegion(id,chain);
 const parent=chain.at(-2),candidates=parent?ANATOMY[parent].parts.filter(p=>p.ref===id):[],part=instances[chain.length-1]?candidates.find(p=>p.id===instances[chain.length-1]):candidates.length===1?candidates[0]:null;
 groups.push(['vga','vga',160,31,23,18],['programming','programming',20,32,43,22],['pmod','expansionPort',19,70,10,30]);
 groups.push(['dram','extension',160,177,76,22]);
 groups.push(['board','board',10,15,235,147]);
 const selected=groups.find(x=>x[1]===group)||groups.at(-1),[,,hx,hy,hw,hh]=selected;
 const regionLabel={fpga:'FPGA相关逻辑与器件原理',board:'整板系统示意',extension:'DRAM拓展（非板载）',power:'供电原理区域',memory:'配置Flash区域',input:'实体开关与按键区域',output:'实体LED区域',display:'数码管区域',interface:'USB Host接口区域',programming:'USB/JTAG与串口接口示意',expansionPort:'扩展接口示意',analog:'模拟接口示意',clock:'晶振区域',vga:'VGA接口示意'}[group];
 const lines=Array.from(title).reduce((all,c,i)=>{const k=Math.floor(i/10);(all[k]??=[]).push(c);return all},[]).slice(0,2).map(a=>a.join(''));
 return `<section class="an-context" data-context-current="${esc(id)}"><header><b>整体位置 · 逐层透视</b><button data-context-expand aria-label="放大整体位置图">↗</button></header><p class="an-context-location" role="status"><b>第 ${chain.length} 层 · ${esc(title)}</b><span>${parent?'从 '+esc(ANATOMY[parent].title.split(' · ')[0])+(part?' · '+esc(part.id):'')+' 展开':'从整块教学板开始探索'}</span></p><svg class="an-context-svg" viewBox="0 0 260 235" role="img" aria-label="${esc(title)}在整体中的位置"><rect x="7" y="12" width="241" height="153" rx="12" fill="#17566b" stroke="#5a9cae" stroke-width="2"/><g fill="#d5e2e4"><rect x="20" y="32" width="43" height="22" rx="3"/><rect x="191" y="31" width="40" height="24" rx="3"/><rect x="32" y="71" width="47" height="28" rx="3"/><rect x="222" y="76" width="10" height="35"/><rect x="79" y="48" width="19" height="10"/></g><rect x="160" y="31" width="23" height="18" rx="2" fill="#b5c9d0"/><rect x="19" y="70" width="10" height="30" fill="#b5c9d0"/><rect x="107" y="58" width="76" height="59" rx="4" fill="#142b37" stroke="#84a6b1"/><text x="145" y="84" text-anchor="middle" fill="#d3e8ef" font-size="14">FPGA</text><g fill="#d3dfb6">${Array.from({length:16},(_,i)=>`<rect x="${19+i*12.4}" y="120" width="7" height="5" rx="1"/>`).join('')}</g><g fill="#9bc3cf">${Array.from({length:16},(_,i)=>`<rect x="${19+i*12.4}" y="139" width="7" height="13" rx="1"/>`).join('')}</g><rect x="30" y="103" width="49" height="10" rx="2" fill="#e96558"/><rect x="${hx-3}" y="${hy-3}" width="${hw+6}" height="${hh+6}" rx="4" fill="#f5d67f" fill-opacity=".2" stroke="#f5d67f" stroke-width="2.5" data-context-region="${group}"/><path d="M${hx+hw/2} ${hy+hh/2}L138 207" fill="none" stroke="#f5d67f" stroke-width="1.5" stroke-dasharray="3 3"/>${group==='extension'?'<text x="198" y="192" text-anchor="middle" fill="#f1d78c" font-size="10">DRAM 拓展</text>':''}<rect x="14" y="205" width="232" height="25" rx="5" fill="#183b49" stroke="#dbbf76"/><text x="130" y="222" text-anchor="middle" fill="#f5ddb0" font-size="12">当前位置：${esc(title.slice(0,16))}</text></svg>${parent&&parent!=='board'?`<div class="an-context-preview-label">${part?'上一级结构：高亮 '+esc(part.id):candidates.length>1?'上一级结构：包含多个同类单元，尚未指定实例':'关联功能上级'}</div><div class="an-context-parent" data-context-parent="${esc(parent)}" data-context-part="${esc(part?.id||'')}"></div>`:''}<small data-context-region-label>${esc(regionLabel)} · 功能位置示意，不代表芯片版图</small><p class="an-context-legend"><span>● 金色：当前展开位置</span><span>实线：结构展开 · 虚线：功能关联</span><span>点击上层返回 · ↑↓ 移动焦点 · Enter 进入</span></p>${anatomyContextLenses(chain,esc,instances)}<nav class="an-context-path" aria-label="当前层级的整体路径">${chain.map((node,i)=>`<button data-context-id="${esc(node)}" ${node===id?'aria-current="location"':''}><span>${i+1}</span>${esc(ANATOMY[node].title.split(' · ')[0])}</button>`).join('')}</nav></section>`;
}
AN_CONTEXT_ASSOCIATIONS.fifo='uartcore';
AN_CONTEXT_ASSOCIATIONS.asyncrx='rx';
AN_CONTEXT_ASSOCIATIONS.register8='tx';

AN_CONTEXT_ASSOCIATIONS.registerControl='register8';
AN_CONTEXT_ASSOCIATIONS.multiply4='dsp';
AN_CONTEXT_ASSOCIATIONS.divide4='alu';
AN_CONTEXT_ASSOCIATIONS.restore5='divide4';
AN_CONTEXT_ASSOCIATIONS.divideShift='divide4';
AN_CONTEXT_ASSOCIATIONS.rastercounter='pixelcounter';
AN_CONTEXT_ASSOCIATIONS.pixelword='framebuffer';

// Move focus without navigating or changing any experimental state.
function anatomyBindContextNavigation(root,navigate){
 root.querySelectorAll('[data-context-locate]').forEach(button=>{button.onclick=()=>{const current=button.closest('.an-context-cutaway').querySelector('[data-context-lens][aria-current]');current?.focus({preventScroll:true});current?.scrollIntoView({block:'nearest',inline:'nearest'})}});
 const nodes=[...root.querySelectorAll('[data-context-id]')];
 for(const btn of nodes){
  btn.onclick=()=>navigate(btn.dataset.contextId);
  btn.onkeydown=e=>{
   if(e.key==='Enter'||e.key===' '){e.preventDefault();e.stopPropagation();btn.dispatchEvent(new MouseEvent('click',{bubbles:true}));return}
   const peers=[...btn.closest('svg,nav').querySelectorAll('[data-context-id]')],i=peers.indexOf(btn);
   const next=e.key==='Home'?0:e.key==='End'?peers.length-1:e.key==='ArrowUp'?Math.max(0,i-1):e.key==='ArrowDown'?Math.min(peers.length-1,i+1):-1;
   if(next<0)return;e.preventDefault();e.stopPropagation();peers[next].focus({preventScroll:true});peers[next].scrollIntoView({block:'nearest',inline:'nearest'});
  };
 }
}
