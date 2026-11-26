'use strict';
// Explicit functional teaching hierarchy. Circuit diagrams are idealized, not a transistor netlist.
const ARCH={};
function unit(id,name,desc,children=[],kind='block'){ARCH[id]={name,desc,children,kind};}
unit('system','计算机系统','从输入、运算、存储到输出，沿各条路径展开。箭头表示功能联系，不表示所有单元按顺序运行。',['cpu','memorySystem','io','clocking']);
unit('cpu','处理器 CPU','以简化 RISC 风格数据通路说明取指、译码、执行、访存与写回；不是完整 ISA 实现。',['pc','instruction','control','regfile','alu','loadstore','pipeline']);
unit('pc','程序计数器 PC','保存当前指令地址，选择顺序地址或跳转目标。',['register','adder','mux']);
unit('instruction','取指与指令字段','指令位串按约定划分操作码、寄存器编号、立即数等字段。',['memorySystem','decoder','immediate']);
unit('immediate','立即数生成','从指令中选择、拼接并按格式扩展立即数。符号扩展复制最高符号位。',['mux','wires']);
unit('control','控制器','译码产生选择、使能、访存和写回控制。多周期控制可由状态机实现。',['decoder','fsm','mux']);
unit('regfile','寄存器堆','两个读地址选择操作数，一个写端口在边沿更新；零寄存器的行为需显式实现。',['decoder','register','mux']);
unit('alu','算术逻辑单元 ALU','并行计算加减、逻辑、移位与比较，由操作选择器挑出结果。',['adder','subtract','logic','shifter','compare','mux'],'alu');
unit('loadstore','访存通路','计算有效地址，按字节使能写入或取出数据；对齐和扩展规则由体系结构规定。',['adder','decoder','memorySystem','mux']);
unit('pipeline','流水线','用阶段寄存器划分数据通路，处理数据相关和控制相关。增加级数不自动保证更快。',['register','forward','hazard','branch']);
unit('forward','前递网络','比较目的寄存器与源寄存器编号，从较新的结果选择操作数。',['compare','mux']);
unit('hazard','暂停与冲刷','依赖尚未就绪时保持相关状态，插入无效操作；误预测或跳转后清除错误路径。',['compare','logic','register']);
unit('branch','分支与跳转','比较条件与目标地址计算决定下一条指令地址。',['compare','adder','mux']);
unit('adder','四位串行进位加法器','每一位接收 A、B 与前一位进位；进位沿位链传播。可操作下方模型观察各位。',['fulladder'],'adder');
unit('fulladder','一位全加器','S=A⊕B⊕Cin；Cout=(A·B)+(Cin·(A⊕B))。',['halfadder','xor','and','or'],'fulladder');
unit('halfadder','半加器','两位相加：和为异或，进位为与。全加器可由两个半加器与一个或门组成。',['xor','and'],'halfadder');
unit('subtract','补码减法','A−B 可由 A+~B+1 实现；无符号借位与有符号溢出不能混为一谈。',['not','adder','xor']);
unit('logic','按位逻辑','同一逻辑门复制到每个 bit，形成与、或、异或等总线运算。',['and','or','xor','not']);
unit('shifter','桶形移位器','多个选择级分别控制移 1、2、4…位；算术右移填符号位，逻辑右移填零。',['mux','wires']);
unit('compare','比较器','相等判断可逐位异或后归约；大小比较需区分无符号与有符号解释。',['xor','or','not','subtract']);
unit('mux','二选一选择器','Y=(~S·A)+(S·B)。选择信号决定哪路数据到达输出。',['not','and','or'],'mux');
unit('decoder','译码器','n 位输入选择 2^n 条输出之一，用于寄存器、存储或控制信号选择。',['not','and']);
unit('fsm','有限状态机','状态寄存器保存当前状态，组合逻辑计算下一状态和输出。',['register','logic','mux']);
unit('register','多位寄存器','一组触发器共享时钟，逐位保存数据；使能和复位由外围逻辑定义。',['dff','mux']);
unit('dff','D 触发器','理想上升沿模型：边沿将 D 保存为 Q，其余时间保持。物理实现还受建立、保持和亚稳态影响。',['latch','clocking'],'dff');
unit('latch','锁存器','电平敏感存储：使能有效时透明，否则保持；交叉反馈可保持一位状态。这里只展示功能层级，不宣称唯一实现。',['nand','not']);
unit('and','与门 AND','只有两个输入都为 1，输出才为 1。',['nand','not'],'and');
unit('or','或门 OR','任一输入为 1，输出为 1；可用德摩根变换构造。',['nor','not'],'or');
unit('xor','异或门 XOR','输入不同时为 1；是加法器和相等比较的重要组成。',['not','and','or'],'xor');
unit('nand','与非门 NAND','AND 的反相。静态 CMOS 示意：下拉 NMOS 串联，上拉 PMOS 并联。',['cmos'],'nand');
unit('nor','或非门 NOR','OR 的反相。静态 CMOS 示意：下拉 NMOS 并联，上拉 PMOS 串联。',['cmos'],'nor');
unit('not','反相器 NOT','输入高则输出低，输入低则输出高。',['cmos'],'not');
unit('cmos','CMOS 开关网络','理想开关示意：NMOS 在栅极高时导通，PMOS 在栅极低时导通。实际电路还涉及阈值、电容、功耗和工艺，不由此模型预测。',['nmos','pmos'],'cmos');
unit('nmos','NMOS 理想开关','栅极为 1 时，将漏源通路视为闭合；为 0 时视为断开。这不是模拟电路求解。',[],'nmos');
unit('pmos','PMOS 理想开关','栅极为 0 时导通，为 1 时关闭。与 NMOS 互补组合形成逻辑。',[],'pmos');
unit('wires','位线、拼接与扩展','连线传递位模式，拼接与切片改变连接方式。物理连线有电阻、电容与传播延迟，功能模型不体现这些参数。',[]);
unit('memorySystem','存储系统','寄存器、缓存、主存及非易失存储服务于不同容量、延迟和保持需求。',['sram','cache','dram','flash']);
unit('sram','SRAM / 片上存储','地址选择字，读写端口访问阵列。FPGA BRAM 不应直接当作此晶体管示意的精确实现。',['decoder','sramcell','mux']);
unit('sramcell','SRAM 位单元概念','交叉耦合反相器保存状态，访问器件连接字线和位线；典型 6T 只是常见结构示意。',['not','nmos']);
unit('cache','Cache 缓存','地址分为标记、组索引和块内偏移；命中才可直接返回数据，未命中需要下一级访问。',['tag','sram','cachefsm']);
unit('tag','标记与命中检测','读取候选标记并比较，同时检查有效位；多路组相联需选中命中路。',['compare','register','mux']);
unit('cachefsm','缓存控制状态机','处理查找、缺失、回填以及可能的脏块写回；策略改变会影响流程。',['fsm','register']);
unit('dram','DRAM 概念','通过电容电荷保存信息，需要刷新，行列访问和读写时序由控制器管理。',['dramcell','decoder','fsm']);
unit('dramcell','动态存储位示意','电容保存电荷，访问开关连接位线；读出需要感测与恢复。此图不计算电压或刷新时间。',['nmos']);
unit('flash','非易失 Flash','用于保持配置或数据；读、编程、擦除是不同操作，具体粒度与协议依器件。',['fsm','decoder']);
unit('io','输入输出系统','外设控制器把应用数据转换为外部可观察的信号或协议。',['input','leddriver','scan','uartcore','vgacore','gpiocore','adccore','usbcore','config']);
unit('input','异步输入处理','引脚输入经同步，再进行消抖、边沿检测或数据握手。',['synchronizer','debounce','edge']);
unit('synchronizer','两级同步器','前后级寄存器降低亚稳态传播概率；逐位同步不提供多位原子一致性。',['dff']);
unit('debounce','消抖器','候选输入持续稳定达到阈值才更新输出。',['register','adder','compare','mux']);
unit('edge','边沿检测','当前稳定值与上一周期值比较，生成单周期事件。',['dff','not','and']);
unit('leddriver','LED / PWM','输出位驱动灯；PWM 比较相位计数器与占空比阈值。',['register','adder','compare']);
unit('scan','数码管扫描','位计数器、数字选择、段译码与消隐协同驱动共享段线。',['scancounter','mux','segmentdecode','blanking']);
unit('scancounter','扫描位计数器','扫描使能到来时切换目标位；刷新速度与主时钟分开。',['register','adder']);
unit('segmentdecode','七段译码表','四位数字索引段码表。低有效接口 0 表示段发光。',['lut','not']);
unit('blanking','位选与消隐','关闭全部位，更新段码，再打开目标位；用于减少切换鬼影。',['fsm','decoder']);
unit('uartcore','UART 收发器','发送和接收为独立通路，共享或分别产生节拍。',['baud','tx','rx']);
unit('baud','位节拍发生器','计数主时钟周期产生位使能；分频误差需计算。',['register','adder','compare']);
unit('tx','发送通路 TX','起始位、低位先发的数据、停止位由状态机组织。',['fsm','shiftreg','mux']);
unit('rx','接收通路 RX','同步输入、检测起始位、定时采样并验证停止位。',['synchronizer','fsm','shiftreg']);
unit('shiftreg','移位寄存器','每次使能移动一位，可实现串并转换。',['register','mux']);
unit('vgacore','显示扫描控制器','横纵计数产生坐标，像素通路产生颜色，同步控制定义显示时序。',['pixelcounter','videotiming','framebuffer']);
unit('pixelcounter','横纵坐标计数','横坐标到行末归零并推进纵坐标，帧末回到原点。',['register','adder','compare']);
unit('videotiming','同步与消隐','比较坐标区间产生有效区、行同步和场同步。',['compare','logic']);
unit('framebuffer','像素存储与颜色通路','按坐标计算地址或颜色；存储读延迟需与控制信号对齐。',['sram','adder','register']);
unit('gpiocore','GPIO 与扩展协议','方向控制、输出数据和输入采样位于 I/O 边界；协议状态机定义传输行为。',['mux','register','fsm']);
unit('adccore','ADC 数据通路','模拟量先转换为码字，数字有效信号驱动采样寄存器与滤波。',['quantizer','register','filter']);
unit('quantizer','理想量化器','连续幅值按阈值映射到离散码字；不代表实际 XADC 的电气量程。',['compare','decoder']);
unit('filter','数字平均滤波','多个采样求和后缩放；中间位宽需容纳最大和。',['register','adder','shifter']);
unit('usbcore','键盘接口层次','真实主机传输、报告解析和应用事件是不同层。这里只做结构导航。',['usbtransport','hidparser','edge']);
unit('usbtransport','主机传输层','枚举、事务与错误处理由完整主机或板上辅助控制器负责；本模型不执行 USB 协议。',['fsm','register']);
unit('hidparser','报告与事件解析','按报告格式解码修饰位和键码，对比前后报告生成按下与松开。',['decoder','compare','register']);
unit('config','FPGA 配置路径','工具生成目标位流，配置通道装载可编程资源。',['flash','fsm','fpgaFabric']);
unit('fpgaFabric','FPGA 逻辑资源','LUT、寄存器和互连构建用户电路；这里展示通用结构。',['lut','dff','routing']);
unit('lut','查找表 LUT','输入索引配置位数组，本质上可视为选择树。',['mux','register']);
unit('routing','可编程互连','配置控制选择器连接逻辑资源；真实布线拓扑与延迟依器件实现。',['mux','wires']);
unit('clocking','时钟与复位','时钟提供状态更新事件；复位建立初态。此层不模拟物理时钟树。',['dff','reset']);
unit('reset','复位同步释放','异步置位、同步释放是一类常见方案；每个时钟域分别处理并验证约束。',['synchronizer']);
unit('subtract','补码减法器','A-B 等价于 A 加 B 的逐位取反再加一；位宽固定时需区分进位和有符号溢出。',['not','adder']);
unit('logic','按位逻辑','每一位独立执行与、或、异或、非；多位逻辑不是逐条执行软件指令。',['and','or','xor','not']);
unit('and','与门 AND','只有两个输入都为 1，输出才为 1。CMOS 实现可由 NAND 后接反相器组成。',['nand','not'],'and');
unit('or','或门 OR','任一输入为 1，输出即为 1。可由 NOR 后接反相器组成。',['nor','not'],'or');
unit('xor','异或门 XOR','两个输入不同时输出 1。以下展开是逻辑等价实现，不是唯一晶体管结构。',['not','and','or'],'xor');
unit('nand','与非门 NAND','与的取反。静态 CMOS 概念：NMOS 下拉串联，PMOS 上拉并联。',['nmos','pmos'],'nand');
unit('nor','或非门 NOR','或的取反。静态 CMOS 概念：NMOS 下拉并联，PMOS 上拉串联。',['nmos','pmos'],'nor');
unit('not','反相器 NOT','输入 0 输出 1，输入 1 输出 0；用互补上下拉说明 CMOS。',['cmos'],'not');
unit('cmos','CMOS 反相器','PMOS 上拉至供电，NMOS 下拉至地，两个栅极同接输入。理想稳态忽略过渡电流与模拟细节。',['pmos','nmos'],'cmos');
unit('nmos','NMOS 理想开关','教学开关模型：栅极高时可形成导通通路；不模拟阈值、电压、电流与寄生参数。',[],'nmos');
unit('pmos','PMOS 理想开关','教学开关模型：栅极低时可形成导通通路；电气行为需结合源漏电位和器件模型。',[],'pmos');
unit('latch','电平敏感锁存器','使能有效时允许 D 更新，关闭时反馈保持状态；与边沿触发的外部行为不同。以下为逻辑等价结构示意。',['mux','nand']);
unit('masterSlave','主从锁存概念','两级在互补相位工作，说明为何整体表现为边沿保存；不是所有 FPGA 触发器的实际晶体管实现。',['latch','not']);
ARCH.dff.children=['masterSlave'];
const ARCH_ENTRY={switches:'input',buttons:'debounce',clock:'clocking',fpga:'fpgaFabric',memory:'memorySystem',leds:'leddriver',sevenseg:'scan',programming:'config',uart:'uartcore',usbhost:'usbcore',vga:'vgacore',pmod:'gpiocore',xadc:'adccore',power:'reset'};
function archCircuit(kind,a=1,b=0,c=0){
 const wire='#83a9bf',high='#80e6b1',low='#5b6f80';
 let content='';
 if(['cmos','not'].includes(kind)){
  const p=!a,n=!!a;
  content=`<text x="210" y="22">VDD（示意）</text><path d="M210 30V65 M210 125V170 M210 170V205 M210 265V290" stroke="${wire}"/><rect x="170" y="65" width="80" height="60" rx="8" fill="${p?'#1b5541':'#263642'}"/><rect x="170" y="205" width="80" height="60" rx="8" fill="${n?'#1b5541':'#263642'}"/><path d="M210 75 L${p?210:235} 115" stroke="${p?high:low}"/><path d="M210 215 L${n?210:235} 255" stroke="${n?high:low}"/><path d="M80 95H165 M80 95V235H165 M210 170H340" stroke="${wire}"/><text x="45" y="80">A=${a}</text><text x="280" y="88">PMOS ${p?'开':'关'}</text><text x="280" y="238">NMOS ${n?'开':'关'}</text><text x="335" y="160">Y=${1-a}</text><path d="M190 290H230 M197 297H223 M204 304H216" stroke="${wire}"/>`;
 }else if(kind==='nmos'||kind==='pmos'){
 const on=kind==='nmos'?!!a:!a;content=`<text x="250" y="45">${kind.toUpperCase()} · 理想开关</text><path d="M60 160H200 M300 160H440 M200 160L${on?300:290} ${on?160:105}" stroke="${on?high:low}"/><text x="250" y="230">G=${a} → ${on?'导通':'断开'}</text><text x="250" y="270">只显示通路状态，不计算器件电压、电流</text>`;
 }else if(kind==='fulladder'||kind==='halfadder'){
 content=`<text x="30" y="40">A=${a}</text><text x="30" y="80">B=${b}</text><path d="M70 40H115V65H150 M70 80H115V85H150" stroke="${wire}"/><rect x="150" y="45" width="90" height="60" rx="8"/><text x="195" y="80">XOR</text><path d="M240 75H280V65H320 M270 160H300V90H320" stroke="${wire}"/><rect x="320" y="45" width="90" height="60" rx="8"/><text x="365" y="80">XOR</text><text x="240" y="180">Cin=${c}</text><path d="M410 75H460" stroke="${high}"/><text x="450" y="55">S=${a^b^c}</text><text x="240" y="240">G=A·B=${a&b}　H=(A⊕B)·Cin=${(a^b)&c}</text><text x="240" y="280">Cout=G+H=${(a&b)|((a^b)&c)}</text>`;
 }else{
 content=`<path d="M45 100H150 M45 180H150 M340 140H450" stroke="${wire}"/><text x="55" y="85">输入</text><rect x="150" y="65" width="190" height="150" rx="15"/><text x="245" y="145">${safe(kind.toUpperCase())}</text><text x="435" y="125">输出</text>${kind==='dff'?'<path d="M150 165l18 15-18 15" stroke="#eac67a"/><text x="245" y="245">↑ 时钟边沿保存 D → Q</text>':''}`;
 }
 return `<svg class="arch-circuit" viewBox="0 0 500 325" role="img" aria-label="${safe(kind)} 理想结构示意"><g fill="#15354a" stroke-width="3">${content}</g></svg>`;
}
function openArchitecture(entry='system'){
 let path=[entry],selected=null,a=1,b=0,cin=0,q=0,tick=0,cpuPhase=0,cpuA=5,cpuB=3,scene3d=null,sceneGeneration=0;
 let dialog=document.createElement('dialog');dialog.className='architecture-dialog';dialog.setAttribute('aria-label','计算机组成分层可视化');document.body.append(dialog);
 dialog.innerHTML='<header><div><small>计算机组成 · 分层探索</small><h2>内部结构可视化</h2></div><button id="archClose">关闭 ×</button></header><div id="archBody"></div>';
 dialog.querySelector('#archClose').onclick=()=>dialog.close();dialog.addEventListener('close',()=>{sceneGeneration++;scene3d?.dispose();scene3d=null;dialog.remove()});
 const draw=()=>{
 sceneGeneration++;scene3d?.dispose();scene3d=null;
 const id=path.at(-1),u=ARCH[id],root=dialog.querySelector('#archBody');
 const gate=['and','or','xor','nand','nor','not','nmos','pmos','cmos','mux','halfadder','fulladder','dff','alu','adder'].includes(u.kind);
 root.innerHTML=`<nav class="arch-crumb"><button data-root>计算机全景</button>${path.map((p,i)=>`<span>›</span><button data-level="${i}">${safe(ARCH[p].name)}</button>`).join('')}</nav><div class="arch-layout"><section><h2>${safe(u.name)}</h2><p>${safe(u.desc)}</p><div class="arch-boundary">功能结构示意 · 可点击方块继续展开 · 连线不代表真实芯片布线</div><div class="arch-3d-host" role="region" aria-label="内部结构三维场景"><p class="arch-3d-loading">正在构建三维结构…</p></div><details class="arch-2d"><summary>结构列表 / 键盘导航</summary><div class="arch-diagram"><div class="arch-port">输入 / 当前状态</div><div class="arch-bus">↓ 数据、选择与使能按结构分配 ↓</div><div class="arch-children">${u.children.length?u.children.map((c,i)=>`<button class="arch-unit ${selected===c?'chosen':''}" data-unit="${c}"><span class="arch-symbol">${['and','or','xor','not','nand','nor'].includes(ARCH[c].kind)?'⊳':ARCH[c].kind==='dff'?'▷':'▦'}</span><b>${safe(ARCH[c].name)}</b><small>${ARCH[c].children.length?'点击查看并继续展开 ↓':'查看工作方式'}</small></button>`).join(''):'<div class="arch-terminal">已到此教学模型的基础层<br>下方可操作模型适用时，可继续观察输入与输出。</div>'}</div><div class="arch-bus">↓ 输出与下一状态 ↓</div><div class="arch-port">结果 / 保存的状态</div></div></details><div class="arch-tools"><button id="archBack" ${path.length===1?'disabled':''}>← 返回上一层</button><button id="archCpu">转到 CPU 数据通路</button></div><div id="archExperiment"></div></section><aside id="archInspector"><h3>点击一个内部单元</h3><p>先看职责，再进入下一层。面包屑可以返回任意祖先层。</p><p>部分结构有反馈或并行分支，不能把整张图理解为顺序执行的软件步骤。</p></aside></div>`;
 const enter=c=>{if(path.includes(c)){path=path.slice(0,path.indexOf(c)+1)}else path.push(c);selected=null;draw()};
 root.querySelector('[data-root]').onclick=()=>{path=['system'];selected=null;draw()};root.querySelectorAll('[data-level]').forEach(el=>el.onclick=()=>{path=path.slice(0,Number(el.dataset.level)+1);selected=null;draw()});
 root.querySelectorAll('[data-unit]').forEach(el=>el.onclick=()=>{selected=el.dataset.unit;scene3d?.select(selected);let v=ARCH[selected];root.querySelectorAll('[data-unit]').forEach(n=>n.classList.toggle('chosen',n===el));let panel=root.querySelector('#archInspector');panel.innerHTML=`${archCircuit(v.kind,a,b,cin)}<span class="arch-symbol">▦</span><h3>${safe(v.name)}</h3><p>${safe(v.desc)}</p><div class="arch-mini">${v.children.map(c=>`<button data-mini="${c}">${safe(ARCH[c].name)}</button>`).join('')||'<span>基础层：理想开关 / 物理边界</span>'}</div><button class="primary" id="archEnter">展开这一层 →</button>`;panel.querySelector('#archEnter').onclick=()=>enter(selected);panel.querySelectorAll('[data-mini]').forEach(n=>n.onclick=()=>{let parent=selected;enter(parent);enter(n.dataset.mini)})});
 root.querySelector('#archBack').onclick=()=>{path.pop();selected=null;draw()};root.querySelector('#archCpu').onclick=()=>{path=['system','cpu'];selected=null;draw()};
 const generation=sceneGeneration,host=root.querySelector('.arch-3d-host');
 import('./architecture3d.js').then(module=>{if(generation!==sceneGeneration||!dialog.open||!host.isConnected)return;scene3d=module.mountArchitecture3D(host,{id,units:ARCH,select:key=>{let button=root.querySelector('[data-unit="'+key+'"]');if(button)button.click()},enter,values:{a,b,cin,q}});host.querySelector('.arch-3d-loading')?.remove();if(!scene3d.supported){host.innerHTML='<p>此浏览器未能启用三维显示，可使用下方结构列表继续展开。</p>';root.querySelector('.arch-2d').open=true}if(selected)scene3d.select(selected)}).catch(()=>{if(generation===sceneGeneration){host.innerHTML='<p>三维资源未能载入，可使用下方结构列表继续学习。</p>';root.querySelector('.arch-2d').open=true}});
 const experiment=root.querySelector('#archExperiment');
 if(gate){
 const k=u.kind;let y=k==='and'?a&b:k==='or'?a|b:k==='xor'?a^b:k==='nand'?1-(a&b):k==='nor'?1-(a|b):['not','pmos','cmos'].includes(k)?1-a:k==='nmos'?a:k==='mux'?(cin?b:a):k==='dff'?q:k==='fulladder'?(a^b^cin):k==='halfadder'?a^b:0;
 experiment.innerHTML=`<h3>动手看内部值 · 理想功能模型</h3><div class="arch-tools"><button id="archA">${k==='dff'?'D':k==='nmos'||k==='pmos'||k==='cmos'?'栅极 G':'A'}=${a}</button>${!['not','pmos','nmos','cmos','dff'].includes(k)?`<button id="archB">B=${b}</button>`:''}${['fulladder','mux'].includes(k)?`<button id="archCin">${k==='mux'?'选择 S':'Cin'}=${cin}</button>`:''}${k==='dff'?'<button id="archTick">上升沿 ↑</button><button id="archReset">复位 Q=0</button>':''}</div><div id="archResult" class="arch-result"></div>`;
 if(k==='adder'||k==='alu'){
 experiment.innerHTML='<h3>逐位展开四位加法 · A+B</h3><div class="arch-tools"><label>A <input id="archNumA" type="number" min="0" max="15" value="5"></label><label>B <input id="archNumB" type="number" min="0" max="15" value="3"></label><button id="archAdd">计算并展开进位</button></div><div id="archResult" class="arch-result"></div>';
 const add=()=>{let av=Number(experiment.querySelector('#archNumA').value),bv=Number(experiment.querySelector('#archNumB').value);if(!Number.isInteger(av)||av<0||av>15||!Number.isInteger(bv)||bv<0||bv>15){experiment.querySelector('#archResult').textContent='请输入 0–15 的整数';return}let carry=0;experiment.querySelector('#archResult').innerHTML='<div class="arch-bitflow">'+[0,1,2,3].map(i=>{let x=(av>>i)&1,z=(bv>>i)&1,old=carry,sum=x^z^old;carry=(x&z)|(old&(x^z));return `<button data-fa="${i}" data-a="${x}" data-b="${z}" data-cin="${old}"><b>FA${i}</b><br>A=${x} B=${z} Cin=${old}<br>S=${sum} Cout=${carry}<br><small>展开全加器 →</small></button>`}).join('<span>→</span>')+`</div><p>总和 ${av+bv} · 低四位 ${(av+bv)&15} · 最终进位 ${carry}</p>`;experiment.querySelectorAll('[data-fa]').forEach(el=>el.onclick=()=>{a=Number(el.dataset.a);b=Number(el.dataset.b);cin=Number(el.dataset.cin);enter('fulladder')})};experiment.querySelector('#archAdd').onclick=add;add();
 }else{
 let explanation=k==='fulladder'?`P=A⊕B=${a^b} → S=P⊕Cin=${y}；G=A·B=${a&b}；H=P·Cin=${(a^b)&cin} → Cout=${(a&b)|((a^b)&cin)}`:k==='halfadder'?`S=${y}，Cout=${a&b}`:k==='dff'?`边沿次数 ${tick}；D=${a} → 仅在 ↑ 保存 → Q=${q}`:k==='cmos'?`PMOS ${a?'关':'开'}；NMOS ${a?'开':'关'} → Y=${y}`:k==='nmos'||k==='pmos'?`栅极 ${a} → 通路${y?'导通':'断开'}`:`输入 → ${u.name} → Y=${y}`;
 experiment.querySelector('#archResult').innerHTML=`${archCircuit(k,a,b,k==='halfadder'?0:cin)}<div class="arch-signal ${y?'high':'low'}">${safe(explanation)}</div><p>绿色为逻辑 1 / 导通，灰色为逻辑 0 / 断开；不表示模拟电压波形。</p>`;
 experiment.querySelector('#archA').onclick=()=>{a^=1;draw()};if(experiment.querySelector('#archB'))experiment.querySelector('#archB').onclick=()=>{b^=1;draw()};if(experiment.querySelector('#archCin'))experiment.querySelector('#archCin').onclick=()=>{cin^=1;draw()};if(k==='dff'){experiment.querySelector('#archTick').onclick=()=>{q=a;tick++;draw()};experiment.querySelector('#archReset').onclick=()=>{q=0;tick=0;draw()}}
 }
 }else if(id==='cpu'){
 const phases=['准备','IF 取指','ID 译码 / 读寄存器','EX 运算','MEM 阶段','WB 写回'];
 experiment.innerHTML=`<h3>跟踪一条指令：ADD x3, x1, x2</h3><p>五个教学阶段展示一条指令的数据流，不表示本系统的真实 CPU 时钟数，也不是流水线并行执行仿真。</p><div class="arch-tools"><label>x1 <input id="cpuA" type="number" min="0" max="15" value="${cpuA}"></label><label>x2 <input id="cpuB" type="number" min="0" max="15" value="${cpuB}"></label><button id="cpuLoad">载入操作数 / 重新开始</button><button id="cpuNext" ${cpuPhase===5?'disabled':''}>下一教学阶段 →</button></div><div class="cpu-stages">${phases.map((n,i)=>`<div class="${i===cpuPhase?'current':i<cpuPhase?'past':''}">${n}</div>`).join('')}</div><div class="cpu-buses"><span>PC=${cpuPhase===5?'0x00000004':'0x00000000'}</span><b>→</b><span>指令 ${cpuPhase>=1?'ADD x3,x1,x2':'待取指'}</span><b>→</b><span>操作数 ${cpuPhase>=2?cpuA+'，'+cpuB:'待读取'}</span><b>→</b><span>ALU ${cpuPhase>=3?cpuA+cpuB:'待计算'}</span><b>→</b><span>x3=${cpuPhase>=5?cpuA+cpuB:0}</span></div><div class="note-box" id="cpuState">${['准备：x1、x2 已给定，x3=0；PC=0。','IF：PC 向指令存储器提供地址，取得指令。','ID：译码源寄存器 x1、x2 与目的寄存器 x3，读出操作数。','EX：ALU 计算 '+cpuA+' + '+cpuB+' = '+(cpuA+cpuB)+'，尚未写回 x3。','MEM：ADD 不访问数据存储器，结果继续传到写回端。','WB：写使能有效，x3 接收 ALU 结果；本例顺序 PC 更新为 4。'][cpuPhase]}</div>`;
 experiment.querySelector('#cpuNext').onclick=()=>{cpuPhase++;draw()};experiment.querySelector('#cpuLoad').onclick=()=>{let x=Number(experiment.querySelector('#cpuA').value),y=Number(experiment.querySelector('#cpuB').value);if(!Number.isInteger(x)||!Number.isInteger(y)||x<0||x>15||y<0||y>15){experiment.querySelector('#cpuState').textContent='本例操作数请输入 0–15 整数。';return}cpuA=x;cpuB=y;cpuPhase=0;draw()};
 }else{experiment.innerHTML='<h3>结构追踪</h3><p>选择内部单元后，右侧显示它的内部缩略结构。继续展开到逻辑门，可切换输入观察真值；进入触发器可单步时钟，进入加法器可查看逐位进位。</p>'}
 };
 draw();dialog.showModal();
}
