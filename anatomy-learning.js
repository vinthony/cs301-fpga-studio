'use strict';
const anLearningEscape=x=>String(x??'').replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
const anLearningClone=x=>JSON.parse(JSON.stringify(x));
function anatomyNumberForms(value){
 if(typeof value!=='number'||!Number.isFinite(value))return {decimal:String(value??'—'),hex:'—',binary:'—'};
 if(!Number.isInteger(value))return {decimal:String(value),hex:'非整数',binary:'非整数'};
 const sign=value<0?'-':'',n=Math.abs(value);return {decimal:String(value),hex:sign+'0x'+n.toString(16).toUpperCase(),binary:sign+'0b'+n.toString(2)};
}
function anatomyInputChangeMarkup(b,previous,current){
 if(!previous)return '';
 const diff=anatomyObservationDiff(b,previous,current),format=value=>{
  if(typeof value==='number')return anatomyNumberForms(value).decimal+(Number.isInteger(value)&&value>=0?' / '+anatomyNumberForms(value).hex:'');
  if(typeof value==='boolean')return value?'1':'0';
  const text=typeof value==='string'?value:JSON.stringify(value);return String(text??'未设置');
 };
 return diff.inputs.length?'<details class="an-input-changes" open><summary>本次改变的输入（'+diff.inputs.length+'）</summary><dl>'+diff.inputs.map(key=>'<div><dt>'+anLearningEscape(anatomyLearningInputName(b,key))+'</dt><dd><span>'+anLearningEscape(format(previous.state[key]))+'</span><b aria-label="变为"> → </b><span>'+anLearningEscape(format(current.state[key]))+'</span></dd></div>').join('')+'</dl></details>':'<p class="an-input-stable">外部输入未改变；对照本次操作与保存状态。</p>';
}
function anatomyStorageMarkup(b,s){
 const lab=b.lab||b.id;if(lab==='sramcell')return anatomySRAMCellLens(s);if(lab==='register')return anatomyRegisterLens(s);if(!['dff','latch'].includes(lab))return '';if(lab==='dff')return anatomyDFFPhases(s);
 const latch=lab==='latch',e=anatomyEvaluate(b.id,s),q=e.result,open=latch?!!s.enable:!s.clk,control=latch?'G='+s.enable:'CLK='+s.clk;
 const next=latch?(s.enable?s.a:q):s.a;
 return `<section class="an-storage-lens" aria-label="输入与保存状态对照"><a href="labs/lab06-state.zip" download>下载寄存器/计数器工程（不含透明锁存器RTL）↓</a><h4>${latch?'电平控制：透明与保持':'边沿保存：候选与已保存值'}</h4><svg viewBox="0 0 320 115" role="img" aria-label="D=${s.a}，Q=${q}，${control}"><path d="M36 57H92" stroke="#6dd5df" stroke-width="3"/><path d="M225 57H265" stroke="#6dd5df" stroke-width="3" ${latch?'':'stroke-dasharray="3 4"'}/>${latch?'':'<text x="243" y="43" text-anchor="middle" fill="#f3ca80" font-size="8">仅边沿</text>'}<circle cx="34" cy="57" r="20" fill="#133b49" stroke="#6dd5df"/><text x="34" y="62" text-anchor="middle" fill="#e0f4f5" font-size="17">${s.a}</text><path d="M92 30H105M92 45H105M92 70H105M92 85H105M215 30H228M215 45H228M215 70H228M215 85H228" stroke="#a9c2cb" stroke-width="4"/><rect x="105" y="18" width="110" height="78" rx="13" fill="#1c303d" stroke="#a6c5ce" stroke-width="2"/><text x="160" y="32" text-anchor="middle" fill="#a7c7d1" font-size="9">${latch?'透明门':'主级采样门'}</text><path d="M120 57H145L172 ${open?57:36}M172 57H200" fill="none" stroke="${open?'#90e2bc':'#f3ca80'}" stroke-width="3"/><circle cx="145" cy="57" r="3" fill="#e8f5e8"/><circle cx="285" cy="57" r="20" fill="#3e3524" stroke="#f3ca80"/><text x="285" y="62" text-anchor="middle" fill="#f9e5ba" font-size="17">${q}</text><text x="34" y="102" text-anchor="middle" fill="#a7c7d1" font-size="11">D 输入</text><text x="160" y="109" text-anchor="middle" fill="#e6c781" font-size="11">${control}</text><text x="285" y="102" text-anchor="middle" fill="#e5c89a" font-size="11">Q 输出</text></svg><dl><div><dt>当前输出 Q</dt><dd>${q}</dd></div><div><dt>${latch?'当前电平条件下':'下一次有效上升沿后'}</dt><dd>${next}</dd></div></dl><p>${latch?(s.enable?'G=1：当前透明，D 改变就会影响 Q。':'G=0：反馈保持，D 改变不会更新 Q。'):(s.clk?'CLK 已为高，重复点上升沿不会采样；先拉低时钟，再给上升沿。':'当前低电平，主级可跟随 D；Q 保持。给上升沿后才把当前 D 保存到 Q。')}${!latch&&s.clk?' 上方候选值以输入保持不变为前提。':''}</p><small>通路图表示教学采样条件，不是器件晶体管级网表；候选值不会提前写入。</small></section>`;
}
function anatomyTruthRows(b,s){
 const lab=b.lab||b.id;if(!['and','or','xor','nand','nor','not','cmos','mux','halfadder','fulladder'].includes(lab))return null;
 const keys=['not','cmos'].includes(lab)?['a']:['mux','fulladder'].includes(lab)?['a','b','cin']:['a','b'];
 const labels=keys.map(k=>k==='cin'?(lab==='mux'?'SEL':'Cin'):k.toUpperCase());
 const outputs=['halfadder','fulladder'].includes(lab)?['S','Cout']:['Y'];
 const rows=Array.from({length:1<<keys.length},(_,i)=>{const inputs=Object.fromEntries(keys.map((k,j)=>[k,(i>>(keys.length-1-j))&1])),e=anatomyEvaluate(b.id,{...s,...inputs});return {inputs,values:outputs.map(k=>k==='Y'||k==='S'?e.result:lab==='halfadder'?e.nets.C:e.nets.Cout),selected:keys.every(k=>s[k]===inputs[k])}});
 return {keys,labels,outputs,rows};
}
function anatomyTruthMarkup(b,s){
 const table=anatomyTruthRows(b,s);if(!table)return '';
 return '<details class="an-truth-table"><summary>真值表 · 点击输入组合试一试</summary><p>每行是稳定输入对应的组合结果；选行不推进时钟。</p>'+(['and','or','not','xor','nand','nor','mux'].includes(b.id)?'<a href="labs/lab03-logic.zip" download>下载逻辑门/MUX/比较器 Chisel 工程 ↓</a>':'')+'<table><thead><tr><th scope="col">选择输入</th>'+[...table.labels,...table.outputs,...(b.id==='fulladder'?['进位来源']:[])].map(x=>'<th scope="col">'+x+'</th>').join('')+'</tr></thead><tbody>'+table.rows.map((r,i)=>'<tr class="'+(r.selected?'selected':'')+'"><td><button data-truth-row="'+i+'" aria-pressed="'+r.selected+'" aria-label="设置 '+table.labels.map((label,j)=>label+'='+r.inputs[table.keys[j]]).join('，')+'">'+(r.selected?'当前':'试用')+'</button></td>'+[...table.keys.map(k=>r.inputs[k]),...r.values].map((v,j)=>'<td'+(j>=table.keys.length?' class="an-truth-output"':'')+'>'+v+'</td>').join('')+(b.id==='fulladder'?'<td class="an-carry-origin">'+(r.inputs.a&&r.inputs.b?'A、B产生':(r.inputs.a^r.inputs.b)&&r.inputs.cin?'Cin传播':'无进位')+'</td>':'')+'</tr>').join('')+'</tbody></table></details>';
}
function anatomyBusMarkup(value,width){
 if(!Number.isInteger(width)||width<1||width>32)return '';
 if(!Number.isInteger(value))return '<p class="an-bus-unknown">当前不是确定的整数位向量；不把 X、Z 或未计算值转换成 0。</p>';
 const mod=2**width,u=((value%mod)+mod)%mod,signed=u>=mod/2?u-mod:u;
 return '<section class="an-bus-inspect" aria-label="'+width+' 位信号展开"><div class="an-bus-bits" style="grid-template-columns:repeat('+Math.min(width,8)+',minmax(0,1fr))">'+Array.from({length:width},(_,i)=>{const bit=width-1-i,v=Math.floor(u/2**bit)%2;return '<span class="'+(v?'one':'zero')+'" aria-label="第 '+bit+' 位为 '+v+'"><small>'+bit+'</small><b>'+v+'</b></span>'}).join('')+'</div><p>无符号：<b>'+u+'</b> · 十六进制：<b>0x'+u.toString(16).toUpperCase().padStart(Math.ceil(width/4),'0')+'</b>'+(width>1?' · 若按 '+width+' 位补码解释：<b>'+signed+'</b>':'')+'</p><small>按高位到低位逐行排列，末位为 bit 0；补码解释不改变连线上的位模式。</small></section>';
}
function anatomyAdderRows(s){
 let carry=0;return Array.from({length:4},(_,bit)=>{const a=(s.av>>>bit)&1,b=(s.bv>>>bit)&1,cin=carry,sum=a+b+cin;carry=sum>=2?1:0;return {bit,a,b,cin,sum:sum&1,cout:carry}});
}
function anatomyLookaheadRows(s){
 const p=Array.from({length:4},(_,i)=>((s.av>>>i)^(s.bv>>>i))&1),g=Array.from({length:4},(_,i)=>((s.av>>>i)&(s.bv>>>i))&1);
 return Array.from({length:4},(_,i)=>{const terms=[];for(let j=i;j>=0;j--){const factors=[];for(let k=i;k>j;k--)factors.push({name:'P'+k,value:p[k]});factors.push({name:'G'+j,value:g[j]});terms.push({label:factors.map(x=>x.name).join('·'),factors,value:factors.every(x=>x.value)?1:0})}const factors=[];for(let k=i;k>=0;k--)factors.push({name:'P'+k,value:p[k]});factors.push({name:'C0',value:0});terms.push({label:factors.map(x=>x.name).join('·'),factors,value:0});return {bit:i+1,p:p[i],g:g[i],terms,value:terms.some(t=>t.value)?1:0}});
}
function anatomyLookaheadMarkup(s){
 const rows=anatomyLookaheadRows(s);return '<details class="an-lookahead"><summary>结构比较：展开P/G与先行进位</summary><p>Pᵢ=Aᵢ XOR Bᵢ；Gᵢ=Aᵢ AND Bᵢ；本页C0=0。行波写法使用前一级C，展开写法直接使用输入P/G。</p><table><thead><tr><th>位i</th><th>Pᵢ</th><th>Gᵢ</th><th>行波依赖</th></tr></thead><tbody>'+rows.map((r,i)=>'<tr><th>'+i+'</th><td>'+r.p+'</td><td>'+r.g+'</td><td>C'+r.bit+'=G'+i+' OR (P'+i+'·C'+i+')</td></tr>').join('')+'</tbody></table>'+rows.map((r,i)=>'<div class="an-look-equation"><b>C'+r.bit+' = '+r.value+'</b><div>'+r.terms.map((term,j)=>'<button data-look-term="'+i+':'+j+'" class="'+(term.value?'active':'')+'" aria-label="查看C'+r.bit+'的项'+term.label+'，结果'+term.value+'">'+term.label+' <strong>'+term.value+'</strong></button>').join('<span> OR </span>')+'</div></div>').join('')+'<p data-look-detail role="status">点击项查看各因子。本图比较逻辑依赖，不按阅读顺序制造传播时延；两种写法可能综合为类似的FPGA专用进位资源。</p></details>';
}
function anatomyAdderMarkup(b,s){
 if(b.id!=='adder')return '';const rows=anatomyAdderRows(s),a=s.av&15,z=s.bv&15,total=a+z;
 return '<section class="an-carry-table">'+anatomyAdderColumns(s)+'<h4>逐位进位 · 从低位 0 到高位 3</h4><a href="labs/lab04-adders.zip" download>下载行波/先行进位 Chisel 工程与波形 ↓</a><p>完整和：'+a+' + '+z+' = <b>'+total+'</b> · 5位：<b>'+total.toString(2).padStart(5,'0')+'</b></p><table><thead><tr>'+['进入位','A','B','Cin','S','Cout'].map(x=>'<th scope="col">'+x+'</th>').join('')+'</tr></thead><tbody>'+rows.map(r=>'<tr><th scope="row"><button data-carry-bit="'+r.bit+'" aria-label="进入第 '+r.bit+' 位全加器">FA'+r.bit+' →</button></th>'+[r.a,r.b,r.cin,r.sum,r.cout].map((v,i)=>'<td class="'+(i===2||i===4?'carry':'')+'">'+v+'</td>').join('')+'</tr>').join('')+'</tbody></table><small>每行 Cout 接下一行 Cin；这是同一次组合计算的逐位解释，不是四个时钟。最高 C4='+rows[3].cout+'，低4位='+ (total&15)+'。</small>'+anatomyLookaheadMarkup(s)+'</section>';
}
function anatomyOutputDescriptor(b){
 const id=b.id,lab=b.lab||id;
 const byId={truth2:['所定义函数的Y',1],demorganNand:['原式输出 NOT(A AND B)',1],demorganNor:['原式输出 NOT(A OR B)',1],tageq5:['EQ（五位全部相等）',1],cachecheck:['HIT（TAG相等且有效）',1],memorySystem:['上次读取返回字节（未读初值0）',8],compare10:['A < B（无符号）',1],comparebit:['前缀小于LTout',1],hsync:['HS（低有效）',1],vsync:['VS（低有效）',1],visiblearea:['ACTIVE（坐标可见）',1],pixelword:['已保存RGB[11:0]',12],rastercounter:['已保存十位Q',10],filter:['四点均值（零填充、截断除四）',8],adccore:['四点滤波输出（零填充、向下取整）',4],xadc:['四点滤波输出（零填充、向下取整）',4],transmission:['理想输出 Y（关闭为Z）',1],decoder3:['八路字线 WL[7:0]',8],decoder:['四路独热 D[3:0]',4],divideShift:['五位临时余数T（组合接线）',5],restore5:['五位恢复选择输出（未保存）',5],multiply4:['已保存部分积P（done后为乘积）',8],register8:['已保存八位Q',8],divide4:['商工作寄存器Q（完成后才有效）',4],pipeline32:['已退休指令数',32],repr4:['补码解释值',null],float32:['原始编码的binary32数值',null],segmentdecode:['seg[6:0] 低有效段码',7],iobank:['解析后的引脚',1],dsp:['保存的累加值 Q',16],pc:['当前 PC',32],branch:['候选下一 PC',32],flash:['当前地址读出字节',8],rx:['已组装的接收字节',8],regulator:['输出幅值趋势 %',null],instruction:['opcode 字段',7],pipeline:['末级保存值',8],forward:['前递后的操作数',8],hazard:['暂停请求',1],dram:['位线读出',1],dramcell:['位线读出',1]};
 const byLab={vga:['消隐后的实际RGB[11:0]',12],scan:['an[3:0] 低有效位选',4],uart:['TX 线电平',1],baud:['终值脉冲',1],hid:['HID 使用码',8],ram:['当前读出值',8],regfile:['读端口 0',8],sramcell:['保存的 Q',1],gpio:['引脚驱动',8],dff:['保存的 Q',1],synchronizer:['第二级保存值 SYNC2',1],debounce:['已接受的稳定值',1],edge:['按下事件 press',1],latch:['Q',1],register:['保存的 Q',4],counter:['计数保存值',4],lut:['LUT 输出 O6',1],slice:['组合输出 O6',1],fabric:['示例 LUT 输出',1],power:['用户计数输出',null],adc:['量化数字码',4],pwm:['PWM 输出位',1],nmos:['理想通路（1=导通）',1],pmos:['理想通路（1=导通）',1]};
 const [name,width]=byId[id]||byLab[lab]||['本层输出',null];return {name,width};
}
function anatomyLearningInputName(b,key){return AN_EXPERIMENTS[b.id]?.fields.find(f=>f.key===key)?.label||({a:['nmos','pmos'].includes(b.lab)?'栅极 G':['dff','latch'].includes(b.lab)?'D':'A',b:'B',cin:'Cin / SEL',av:'A / 待写值',bv:'B',enable:'使能',reset:'复位',lutAddr:'LUT 地址',lut:'配置表',sw:'板上开关',btnMask:'板上按键',addr:'地址',data:'待写数据',we:'写使能',vgaSource:'VGA数据来源',vgaCountEnable:'扫描计数使能',vgaWriteAddress:'帧缓冲写地址',vgaWriteData:'帧缓冲待写RGB',vgaWriteEnable:'帧缓冲写使能',word:'显示字',scanDots:'逐位小数点请求[3:0]',duty:'占空比',byte:'待发送字节',pct:'输入幅值',rgb:'RGB 数据',key:'键码',modifier:'修饰键',pressed:'按下状态',op:'运算选择',r0:'读地址 0',r1:'读地址 1',waddr:'写地址'})[key]||key}
function anatomyLearningInputKeys(b){
 if(AN_EXPERIMENTS[b.id])return AN_EXPERIMENTS[b.id].fields.map(f=>f.key);
 const lab=b.lab||b.id,table={board:['sw','btnMask'],and:['a','b'],or:['a','b'],xor:['a','b'],nand:['a','b'],nor:['a','b'],not:['a'],cmos:['a'],nmos:['a'],pmos:['a'],mux:['a','b','cin'],fulladder:['a','b','cin'],halfadder:['a','b'],adder:['av','bv'],subtract:['av','bv'],alu:['av','bv','op'],cpu:['av','bv'],shifter:['av','bv'],compare:['av','bv'],power:['powered'],contact:['a'],led:['a'],lut:['lutAddr','lut'],slice:['lutAddr','lut'],fabric:['lutAddr','lut'],routing:['lutAddr','lut'],latch:['a','enable'],dff:['a'],register:['av','enable','reset'],counter:['enable','reset'],synchronizer:['a'],reset:['a'],shiftreg:['a'],edge:['a'],debounce:['a'],regfile:['r0','r1','waddr','data','we'],ram:['addr','data','we'],sramcell:['a','enable'],scan:['word','scanDots'],pwm:['duty'],uart:['byte','baud'],adc:['pct'],filter:['data','enable'],hid:['key','pressed','modifier'],vga:['rgb','vgaSource','vgaCountEnable','vgaWriteAddress','vgaWriteData','vgaWriteEnable'],cache:['addr'],tag:['addr'],decoder:['av'],immediate:['av'],gpio:['data','we']};
 return table[lab]||[];
}
function anatomyObservationDiff(b,previous,current){
 if(!previous)return {inputs:[],nets:[],resultChanged:false,savedChanged:[],edge:false};
 const same=(a,z)=>JSON.stringify(a)===JSON.stringify(z),inputs=anatomyLearningInputKeys(b).filter(k=>!same(previous.state[k],current.state[k])),nets=b.nets.filter(n=>!same(previous.evaluation.nets[n.name],current.evaluation.nets[n.name])).map(n=>n.name),savedChanged=['pixelQ','pixelLast','rasterQ','rasterLast','vgaImageData','vgaImageImport','vgaFB','vgaOutput','vgaLast','pixel','divide4','multiply4','reg8Q','uartAsync','baudTX','fifoTX','fifoMem','fifoRead','fifoWrite','fifoCount','fifoLast','uartLoop','uartByte','uartIndex','memoryCache','memoryAccess','memoryLastRead','dramTrace','flashLast','pipeline32','cpu32','rfRegs','q','master','sliceQ','mem','reg','mainMem','pipe','pipeValid','chargeValid','chargeAge','chargeBit','flashBytes','configValid','configBit','rxData','rxValid','rxError','rxPhase','pc','adcSample','adcSampleValid','adcSamples','adcFilterCount','s1','s2','stable','previous','candidate','consecutive','keyEvent','readQ','readB','outputLevel','mode','shift','samples'].filter(k=>!same(previous.state[k],current.state[k]));
 return {inputs,nets,savedChanged,resultChanged:!same(previous.evaluation.result,current.evaluation.result),edge:previous.state.ticks!==current.state.ticks};
}
function anatomyExplainObservation(b,previous,current){
 const d=anatomyObservationDiff(b,previous,current),lab=b.lab||b.id,s=current.state,result=current.evaluation.result,old=previous?.evaluation.result;
 if(!previous)return {title:'先改变一个输入，再观察结果',body:b.question||b.formula||'右侧操作输入；图上的数值与端口是本层模型的观察结果。',diff:d};
 let title=d.resultChanged?'输出发生变化':'输出保持原值',body=d.inputs.length?'输入 '+d.inputs.map(k=>anatomyLearningInputName(b,k)).join('、')+' 已改变。':'完成了一次状态操作。';
 if(lab==='dff'){
  if(!d.edge){title='D 可以变，Q 先保持';body='没有新的有效上升沿，已保存的 Q 不跟着 D 改变。拉低时钟后再给上升沿，比较两次观察。'}
  else{title=d.resultChanged?'上升沿采入新的 D':'发生了上升沿，保存值仍相同';body='本教学模型在 CLK 从低变高时保存 D。若 D 与原 Q 相同，时钟推进了，输出数值也可以不变。'}
 }else if(lab==='latch'){
  title=s.enable?'使能打开：输出跟随 D':'使能关闭：保持已保存值';body=s.enable?'锁存器是电平敏感的；不用等待上升沿。':'关门后的输入变化不再穿过反馈选择器。';
 }else if(['register','register8','counter','dsp','pc'].includes(lab)||b.id==='slice'){
  title=!d.edge?'先改变候选值，等待保存边沿':s.reset?'复位优先':s.enable===0?'使能关闭：边沿到来也保持':'有效操作更新保存状态';body=!d.edge?'图中输入或候选计算可以变化；保存单元需要本层的边沿操作。':s.enable===0?'这次操作没有开启写入条件。比较输入与保存值，二者可以不同。':d.savedChanged.length?'发生变化的保存量：'+d.savedChanged.join('、')+'。':'发生了操作，但写入值与原保存值相同。';
 }else if(['adccore','xadc'].includes(b.id)){
  const p=anatomyADCPlan(s);if(!d.edge){title='候选输入可变，采样和滤波先保持';body='当前量化候选='+p.code+'，转换有效='+s.adcValid+'；寄存器仍保存'+s.adcSample+'，滤波窗口不因输入改变而推进。'}else{title='共同边沿，两级读取各自旧输入';body='寄存器'+(s.adcValid?'采入当前候选'+p.code:'不接受无效转换，数据保持且有效标记清零')+'；滤波器'+(previous.state.adcSampleValid?'接收边沿前保存样本'+previous.state.adcSample:'没有有效旧样本，保持窗口')+'。本拍新保存的转换不能直接穿透到滤波窗口。'}
 }else if(lab==='filter'){
  title=!d.edge?'准备样本，窗口暂不推进':s.enable?'有效样本进入四点窗口':'样本无效，四点窗口保持';body='待采样数据='+s.data+'，有效='+s.enable+'；当前窗口='+s.samples.join('、')+'，四点均值='+result+'。仅有效采样更新窗口，启动用零填充，结果向下取整。';
 }else if(lab==='compare'){
  const different=[3,2,1,0].filter(i=>((s.av>>>i)&1)!==((s.bv>>>i)&1));title=different.length?'这些位仍有差异，相等输出为0':'所有对应位相同，相等输出为1';body=`A=${s.av.toString(2).padStart(4,'0')}，B=${s.bv.toString(2).padStart(4,'0')}。${different.length?'不同位置为 '+different.map(i=>'bit'+i).join('、')+'；任意一个差异为1，就会通过或树使EQ为0。':'四个异或输出全部为0，或归约为0，再反相得到EQ=1。'}这是组合比较，不需要采样边沿；相等不是比较1的数量。`;
 }else if(lab==='synchronizer'){
  if(!d.edge){title='原始输入变化，两级暂不更新';body=`原始输入=${s.a}，SYNC1仍为${s.s1}，SYNC2仍为${s.s2}。下一共同边沿，第一级采原始输入，第二级采第一级的旧值。`;}
  else{title=d.resultChanged?'第二级接收到前一拍的样本':'两级已采样，第二级数值保持';body=`同一边沿：SYNC1采入原始输入 ${s.a}；SYNC2采入边沿前SYNC1=${previous.state.s1}。现在两级为 ${s.s1}、${s.s2}。数字采样次序不表示已模拟亚稳态电压。`;}
 }else if(lab==='debounce'){
  if(!d.edge){title='只改原始输入，连续次数还不变';body=`原始输入=${s.a}；已保存候选=${s.candidate}，连续次数=${s.consecutive}，稳定输出=${s.stable}。等待下一采样，再判断是否延续同一候选。`;}
  else{const restarted=previous.state.candidate!==s.a;title=d.resultChanged?'连续达到阈值，提交新稳定值':s.consecutive>=3?'连续达到阈值，稳定值与原来相同':restarted?'样本改变，连续计数从1开始':'继续同一候选，尚未达到阈值';body=`本拍采入 ${s.a}；${restarted?'与旧候选 '+previous.state.candidate+' 不同，重新计数':'与旧候选相同，连续计数增加'}，保存候选=${s.candidate}，连续次数=${s.consecutive}。${s.consecutive>=3?'已满足教学阈值3，接受候选':'还差 '+(3-s.consecutive)+' 次相同采样才达到教学阈值3'}；当前稳定输出=${s.stable}。`;}
 }else if(lab==='edge'){
  const p=previous.state;
  if(!d.edge){title='原始输入变了，两级保存值先保持';body=`原始输入=${s.a}，当前保存=${s.stable}，上次保存=${s.previous}，事件仍为${result}。没有采样边沿，短暂松开再按下可能完全不被保存。`;}
  else{title=result?'采到新的按下，事件为1':s.stable?'两次都采到按住，不重复触发':'采到松开，按下事件为0';body=`共同边沿：当前级采入原始输入 ${s.a}；延迟级采入边沿前当前级的 ${p.stable}，两级在同一边沿分别读取各自的边沿前输入。现在 press = ${s.stable} AND NOT ${s.previous} = ${result}。`;}
 }else if(['input','reset','sramcell'].includes(lab)){
 const info={synchronizer:['先采到第一级，再观察第二级','第二级在当前边沿接收的是第一级的旧值；输入改变不能直接穿过两级。'],debounce:['稳定采样不够，输出就先保持','连续三个相同教学采样才提交稳定状态；输入翻转会重新累计。'],input:['同步、消抖与事件要分开看','原始引脚先经过两级采样，再经过稳定判断，最后才生成单拍事件。'],reset:['复位置位与释放采用不同规则','外部复位有效时异步置位；释放后还需两级同步边沿，不是断电重启。'],edge:['比较本次与上次采样','原始输入变化不等于采样已更新；上升事件来自当前保存值与上一次值的比较。'],sramcell:['待写位线与保存位是两回事','本模型需要执行写入且 WL=1 才更新保存状态；修改待写值本身不是写入。']};[title,body]=info[lab];
 }else if(lab==='scan'&&b.id!=='segmentdecode'){
 title=s.scanPhase===2?'选中的一位正在点亮':'扫描切换期间先消隐';body='an 与 seg 都是低有效。这里的主输出是位选码，不是数码管显示的数字。观察数字、段码与位选三者的区别。';
 }else if(b.id==='segmentdecode'){
 title='数字不是段码，译码把二者对应起来';body='输入只有一个 0…F 数字，输出是七根段线的低有效编码。本层组合译码不需要推进扫描。';
 }else if(lab==='uart'||b.id==='rx'){
 title=b.id==='rx'?'逐位组装一个接收字节':'字节数据与 TX 线电平不同';body=b.id==='rx'?'先送低起始位，再按低位在先送八个数据位，最后检查高停止位。':'每次推进一个教学位周期。0x41 是要发送的字节，TX 每一时刻只有一个电平。';
 }else if(b.id==='fifo'){
  title=d.savedChanged.includes('fifoTX')?'缓冲字节与发送寄存器分开保存':d.savedChanged.includes('fifoCount')?'实际读写改变队列占用':'请求不等于已接受';body='只有发送器空闲取队首时才出队，帧内保持已捕获字节。手动读写按当前满空条件接受；待写值改变不会自动入队。FIFO为空时，串口仍可能正在发送最后一帧。';
 }else if(lab==='ram'){
  title=b.id==='bram'?'区分同步读值与写入后的阵列':'区分待写数据与已保存数据';body=b.id==='bram'?'本例边沿读出旧值后才写入；阵列已改变时，输出寄存器可能要下一边沿才读到新值。':'写使能决定访问边沿是否写入；修改“待写数据”本身不会写入存储阵列。';
 }else if(b.id==='pipeline'){
  title=s.flush?'冲刷：有效位被清空':s.stall?'暂停：各级保持':'数据逐级向后推进';body=s.flush?'气泡不是数字零：有效位为 0 表示这一格没有可用的指令数据。':s.stall?'输入端仍可以修改，但暂停期间流水寄存器保持。':'观察各级的数据与有效位，不要把输入改变当成已经到达末级。';
 }else if(b.id==='iobank'){
  title=result==='X'?'两个驱动冲突：得到 X':result==='Z'?'没有驱动：得到 Z':'引脚得到确定的数字电平';body=result==='X'?'内部与外部同时驱动相反电平；这不是第三种逻辑电平，也不预测真实冲突电流。':result==='Z'?'两个驱动都关闭。Z 是高阻／未驱动，不等于 0。':'输入缓冲观察的是引脚解析后的电平。';
 }else if(['dram','dramcell'].includes(b.id)){
  title=result==='X'?'教学保持期限已过，数据未知':s.chargeAge===0?'写入／刷新恢复了保持期限':'保存状态还在，但保持期限减少';body='8 步是人为缩小的演示期限。刷新不能凭空恢复已经变成未知的数据。';
 }else if(lab==='vga'){title=s.vgaSource==='framebuffer'?'同步读取与控制一起保存':'纯色组合扫描';body=s.vgaSource==='framebuffer'?'同一个像素边沿先读旧RAM，再执行写入；RGB、HS、VS与ACTIVE来自同一个旧坐标。计数使能关闭时坐标保持，RAM与输出仍可更新。':'当前RGB为组合纯色；可切换帧缓冲模式观察保存延迟。';
 }else if(b.id==='flash'){
  title=d.savedChanged.includes('flashBytes')?'Flash 块内容改变了':'Flash 可能没有改变';body='编程只把 1 改成 0。想把已经为 0 的位变回 1，需要擦除；待编程字节变化不等于阵列已写入。';
 }else if(['nmos','pmos','ledjunction','regulator'].includes(b.id)){
  title='观察器件原理模型的状态';body=AN_EXPERIMENTS[b.id]?.note||'颜色与通路表达理想通断或发光概念，不代表真实电流、电压与传播时间。';
 }else if(d.inputs.length&&!d.edge){
  title=d.resultChanged?'输入改变，组合结果随之改变':'输入改变了，出口也可能保持';body=d.resultChanged?'本层已经完成模型计算。下面的变化导览只按结构分组查看，不添加虚构的传播延迟。':d.nets.length?'有 '+d.nets.length+' 条内部命名信号变化，但它们没有改变最终结果。对比这些支路与出口。':'这次输入变化没有改变所观察的输出；检查当前选择、使能或有效条件。';
 }
 return {title,body,diff:d,old,result};
}
function anatomyObservationGroups(b,previous,current){
 const diff=anatomyObservationDiff(b,previous,current),changed=new Set(diff.nets),groups=[],visited=new Set(),parts=new Map(b.parts.map(p=>[p.id,p]));
 while(changed.size){
  const remaining=b.nets.filter(n=>changed.has(n.name)),destinations=new Set(remaining.map(n=>n.to.split('.')[0]));
  let ready=remaining.filter(n=>!destinations.has(n.from.split('.')[0])||parts.get(n.from.split('.')[0])?.type==='port');
  if(!ready.length)ready=[remaining[0]];
  const names=ready.map(n=>n.name),ids=[...new Set(ready.flatMap(n=>[n.from.split('.')[0],n.to.split('.')[0]]))];for(const name of names){changed.delete(name);visited.add(name)}
  groups.push({title:'变化组 '+(groups.length+1),nets:names,parts:ids});
  if(groups.length===5&&changed.size){const rest=b.nets.filter(n=>changed.has(n.name));groups.push({title:'其余变化与反馈',nets:rest.map(n=>n.name),parts:[...new Set(rest.flatMap(n=>[n.from.split('.')[0],n.to.split('.')[0]]))]});break}
 }
 if(!groups.length){const ids=b.parts.filter(p=>JSON.stringify(previous?.evaluation.partValues?.[p.id])!==JSON.stringify(current.evaluation.partValues?.[p.id])).map(p=>p.id);if(!ids.length){ids.push(...b.nets.filter(n=>parts.get(n.to.split('.')[0])?.type==='port').map(n=>n.to.split('.')[0]));if(!ids.length)ids.push(...b.parts.filter(p=>['register','dff','latch','ram','bitgrid'].includes(p.type)).slice(0,3).map(p=>p.id))}groups.push({title:diff.resultChanged?'观察当前输出':'观察保持的状态',nets:[],parts:ids})}
 return groups;
}
function anatomyWaveChannels(b,trace,selectedNet){
 if(b.id==='memorySystem'){const channels=[{key:'addr',name:'当前请求地址',kind:'state'},{key:'operation',name:'最近已执行操作（非每行事件）',kind:'memory-operation'},{key:'readAddress',name:'上次读取来源地址',kind:'memory-read-address'},{key:'readValue',name:'上次实际读取字节',kind:'memory-read-value'},{key:'readHit',name:'上次读取是否命中',kind:'memory-read-hit'},{key:'candidateHit',name:'当前候选是否命中',kind:'memory-candidate-hit'}];if(selectedNet)channels.push({key:selectedNet,name:selectedNet,kind:'net'});return channels;}

 if(b.id==='rx'){const channels=[{key:'a',name:'RX原始电平',kind:'state'},{key:'rxPhase',name:'接收阶段（下一采样）',kind:'rx-phase'},{key:'组装字节',name:'组装DATA（需检查VALID）',kind:'net'},{key:'接收有效',name:'VALID接收有效',kind:'net'},{key:'帧错误',name:'ERROR停止位错误',kind:'net'},{key:'采样使能',name:'组装寄存器写使能',kind:'net'}];if(selectedNet&&!channels.some(c=>c.kind==='net'&&c.key===selectedNet))channels.push({key:selectedNet,name:selectedNet,kind:'net'});return channels;}

 if(['scan','sevenseg'].includes(b.id)){const channels=[{key:'scanPhase',name:'扫描阶段',kind:'scan-phase'},{key:'digit',name:'目标位编号',kind:'state'},...[3,2,1,0].map(bit=>({key:bit,name:'AN'+bit+'（0选通）',kind:'scan-an'})),{key:'seg',name:'seg[g…a]（0亮）',kind:'scan-seg'},{key:'dp',name:'dp（0请求亮）',kind:'scan-dp'},{key:'dots',name:'实际亮起小数点位掩码',kind:'scan-lit-dots'}];if(selectedNet)channels.push({key:selectedNet,name:selectedNet,kind:'net'});return channels;}
 const map=new Map(b.parts.map(p=>[p.id,p])),keys=[],add=(key,name,kind='net')=>{if(!keys.some(x=>x.kind===kind&&x.key===key))keys.push({key,name,kind})};
 add('result',anatomyOutputDescriptor(b).name,'result');if(selectedNet&&b.nets.some(n=>n.name===selectedNet))add(selectedNet,selectedNet);
 for(const n of b.nets)if(map.get(n.to.split('.')[0])?.type==='port')add(n.name,n.name);
 for(const p of b.parts)if(['dff','latch','register','shift'].includes(p.type)&&trace.some(x=>x.evaluation.partValues?.[p.id]!==undefined))add(p.id,p.id+' 保存值','part');
 for(const n of b.nets)if(n.role==='clock'||n.role==='control')add(n.name,n.name);
 for(const n of b.nets)if(map.get(n.from.split('.')[0])?.type==='port')add(n.name,n.name);
 for(const n of b.nets)add(n.name,n.name);return keys.slice(0,6);
}
function anatomyObservationColumnWidth(b){return ['scan','sevenseg','alu32','regfile32','immgen32','cpu32'].includes(b.id)?88:44}
function anatomyWaveValue(row,ch){
 if(ch.kind==='memory-operation')return row.state.memoryAccess?.kind==='read'?'读':row.state.memoryAccess?.kind==='write'?'写':'未操作';
 if(ch.kind==='memory-read-address')return row.state.memoryLastRead?.address??'尚未读';
 if(ch.kind==='memory-read-value')return row.state.memoryLastRead?.value??'尚未读';
 if(ch.kind==='memory-read-hit')return row.state.memoryLastRead?+row.state.memoryLastRead.hit:'尚未读';
 if(ch.kind==='memory-candidate-hit'){const s=row.state,line=s.memoryCache[(s.addr>>>1)&3];return +(!!line.valid&&line.tag===(s.addr>>>3));}

 if(ch.kind==='rx-phase')return row.state.rxPhase<0?'IDLE':row.state.rxPhase<8?'d'+row.state.rxPhase:'STOP';
 if(ch.kind==='scan-dp')return 1-((row.state.scanDots||0)>>>row.state.digit&1);
 if(ch.kind==='scan-lit-dots')return row.state.scanPhase===2?((row.state.scanDots||0)&(1<<row.state.digit)):0;
 if(ch.kind==='scan-phase')return ['消隐','准备','点亮'][row.state.scanPhase]??'未知';
 if(ch.kind==='state')return row.state[ch.key];
 if(ch.kind==='scan-an')return Number.isInteger(row.evaluation.result)?(row.evaluation.result>>>ch.key)&1:'—';
 if(ch.kind==='scan-seg')return row.evaluation.nets['低有效段码']??row.evaluation.nets['段控制']??'—';
 return ch.kind==='result'?row.evaluation.result:ch.kind==='part'?row.evaluation.partValues?.[ch.key]:row.evaluation.nets[ch.key];
}
function anatomyWaveMarkup(b,trace,selectedNet){
 const esc=anLearningEscape,channels=anatomyWaveChannels(b,trace,selectedNet),cw=anatomyObservationColumnWidth(b),width=Math.max(cw,trace.length*cw),height=28+channels.length*27;
 let content=`<svg class="an-wave-svg" viewBox="0 0 ${width} ${height}" width="${width}" height="${height}" role="group" tabindex="0" aria-keyshortcuts="ArrowLeft ArrowRight Home End Enter" aria-label="按观察序号排列的历史值，不是物理时间；左右键回看，Home到首条，End到末条，Enter回到当前"><rect width="${width}" height="${height}" fill="#0b1d29"/><rect data-observation-cursor x="0" y="0" width="${cw}" height="${height}" fill="#d7b866" fill-opacity=".12"/>`;
 for(let i=0;i<trace.length;i++)content+=`<path d="M${i*cw} 0V${height}" stroke="#29414e"/><text x="${i*cw+cw/2}" y="18" text-anchor="middle" fill="#9bb7c8" font-size="10">#${trace[i].serial}</text>`;
 channels.forEach((ch,row)=>{
  const values=trace.map(x=>anatomyWaveValue(x,ch)),y=28+row*27;
  content+=`<g data-wave-channel="${esc(ch.name)}"><path d="M0 ${y+26}H${width}" stroke="#213b49"/>`;
  if(values.every(v=>v===0||v===1)){
   let d='';for(let i=0;i<values.length;i++){const yy=y+(values[i]?6:21);d+=(i?'V':'M')+(i?yy:`${i*cw} ${yy}`)+`H${(i+1)*cw}`}content+=`<path d="${d}" fill="none" stroke="#7cddbb" stroke-width="1.8"/>`;
  }else for(let i=0;i<values.length;i++){const raw=values[i],str=typeof raw==='number'&&Number.isInteger(raw)&&Math.abs(raw)>15?anatomyNumberForms(raw).hex:String(raw??'—'),short=str.length>(cw===88?12:6)?str.slice(0,cw===88?11:5)+'…':str,color=raw==='X'?'#ee9286':raw==='Z'?'#dec17f':'#96d6e2';content+=`<g><title>${esc(ch.name+'：'+String(raw??'—'))}</title><path d="M${i*cw+4} ${y+5}H${i*cw+cw-4}L${i*cw+cw-1} ${y+13}L${i*cw+cw-4} ${y+22}H${i*cw+4}L${i*cw+1} ${y+13}Z" fill="none" stroke="${color}"/><text x="${i*cw+cw/2}" y="${y+17}" text-anchor="middle" fill="${color}" font-size="9">${esc(short)}</text></g>`}
 content+='</g>';
 });
 return {labels:`<div class="an-wave-name">观察</div>`+channels.map(c=>`<div class="an-wave-name" title="${esc(c.name)}">${esc(c.name)}</div>`).join(''),svg:content+'</svg>',width};
}
function anatomyObservationCSV(b,trace){
 const scanChannels=['scan','sevenseg','rx','memorySystem'].includes(b.id)?anatomyWaveChannels(b,trace):[],keys=anatomyLearningInputKeys(b),headers=['层级','观察序号','教学操作次数',anatomyOutputDescriptor(b).name,...keys.map(k=>'输入 '+anatomyLearningInputName(b,k)),...b.nets.map(n=>n.name),...scanChannels.map(c=>c.name)];
 const cell=value=>{let s=typeof value==='object'?JSON.stringify(value):String(value??'');if(typeof value==='string'&&/^[=+@-]/.test(s))s="'"+s;return '"'+s.replaceAll('"','""')+'"'};
 return [headers,...trace.map(row=>[b.id,row.serial,row.state.ticks,row.evaluation.result,...keys.map(k=>row.state[k]),...b.nets.map(n=>row.evaluation.nets[n.name]),...scanChannels.map(c=>anatomyWaveValue(row,c))])].map(row=>row.map(cell).join(',')).join('\r\n');
}
function createAnatomyLearning({dialog,blueprint,state,selection,showHistorical,showCurrent}){
 const records=new Map(),serials=new Map();let index=null,timer=null,mode=null,guideStep=0,closed=false,speed=1000,panelView=null,lastRecordToken=null;
 const b=()=>blueprint(),trace=()=>records.get(b().id)||[],observed=()=>index===null?null:trace()[index],esc=anLearningEscape;
 function stop(){if(timer!==null)clearTimeout(timer);timer=null;mode=null;updateCursor()}
 function leave(){if(timer!==null)clearTimeout(timer);timer=null;mode=null;index=null;panelView=null;lastRecordToken=null}
 function preventMutation(event){if(index!==null&&event.target.closest('.an-lab-controls')&&!event.target.closest('[data-observe-section],a[download]')){event.preventDefault();event.stopImmediatePropagation()}}
 for(const type of ['click','input','change'])dialog.addEventListener(type,preventMutation,true);
 const onVisibility=()=>{if(document.hidden)stop()};document.addEventListener('visibilitychange',onVisibility);
 function ensurePanels(){
  const main=dialog.querySelector('.an-main');if(!main)return false;
  if(!main.querySelector('.an-playbar')){
   const box=document.createElement('section');box.className='an-learning';box.innerHTML=`<div class="an-coach" aria-live="polite"><b data-coach-title></b><p data-coach-body></p><div data-coach-delta></div><div data-coach-inputs></div></div><div class="an-playbar"><button data-change-guide>自动讲解变化</button><button data-change-step>逐组查看变化</button><button data-observation-prev aria-label="上一次观察">←</button><button data-observation-play>重放观察</button><button data-observation-next aria-label="下一次观察">→</button><button data-observation-live>回到当前</button><button data-observation-export>导出观察</button><label>节奏<select data-observation-speed><option value="1800">慢</option><option value="1000" selected>标准</option><option value="500">快</option></select></label><small data-observation-status></small></div><p class="an-playback-note" data-playback-note></p><p class="an-guide-detail" data-guide-detail role="status"></p>`;main.querySelector('.an-scene').after(box);
   const timeline=document.createElement('details');timeline.className='an-observation-timeline';timeline.innerHTML='<summary>观察时间轴与波形 <small>观察序号，不是物理时间</small></summary><label class="an-observation-scrub">回看记录<input data-observation-range type="range" min="0" max="0" value="0" step="1"></label><div class="an-wave-layout"><div class="an-wave-labels"></div><div class="an-wave-scroll"></div></div><p class="an-wave-help">键盘：聚焦波形后，← →逐条回看，Home首条，End末条，Enter回到当前。回看不会推进电路。</p><p data-wave-readout role="status" aria-live="polite"></p>';main.querySelector('.an-track').before(timeline);
   box.querySelector('[data-change-guide]').onclick=startGuide;box.querySelector('[data-change-step]').onclick=stepGuide;box.querySelector('[data-observation-prev]').onclick=()=>show(Math.max(0,(index??trace().length-1)-1));box.querySelector('[data-observation-next]').onclick=()=>show(Math.min(trace().length-1,(index??trace().length-1)+1));box.querySelector('[data-observation-play]').onclick=()=>mode?stop():startHistory();box.querySelector('[data-observation-live]').onclick=returnLive;box.querySelector('[data-observation-export]').onclick=()=>{const url=URL.createObjectURL(new Blob(['\uFEFF'+anatomyObservationCSV(b(),trace())],{type:'text/csv;charset=utf-8'})),a=document.createElement('a');a.href=url;a.download='CS301-'+b().id+'-observations.csv';a.click();setTimeout(()=>URL.revokeObjectURL(url),1000)};
   box.querySelector('[data-observation-speed]').onchange=event=>{speed=Number(event.target.value);if(timer!==null){clearTimeout(timer);timer=setTimeout(advance,speed)}};
   timeline.querySelector('[data-observation-range]').oninput=event=>show(Number(event.target.value));timeline.ontoggle=()=>updateCursor();panelView=b().id;
  }
  return true;
 }
 function paintCoach(row,previous){
  const explanation=anatomyExplainObservation(b(),previous,row),main=dialog.querySelector('.an-main');if(!main)return;
  main.querySelector('[data-coach-title]').textContent=explanation.title;main.querySelector('[data-coach-body]').textContent=explanation.body;
  main.querySelector('[data-coach-inputs]').innerHTML=anatomyInputChangeMarkup(b(),previous,row);
  const d=explanation.diff,output=anatomyOutputDescriptor(b()),forms=anatomyNumberForms(row.evaluation.result);if(output.width&&typeof row.evaluation.result==='number'&&row.evaluation.result>=0)forms.binary='0b'+row.evaluation.result.toString(2).padStart(output.width,'0');
  main.querySelector('[data-coach-delta]').innerHTML=`<span>${esc(output.name)}：<b>${esc(forms.decimal)}</b></span>${forms.hex!=='—'&&forms.hex!=='非整数'?`<span>${esc(forms.hex)}</span><span>${esc(forms.binary)}</span>`:''}<small>${previous?d.nets.length+' 条信号变化 · '+(d.resultChanged?'出口变化':'出口保持'):'先预测，再操作'}</small>`;
 }
 function updateCursor(){
  const rows=trace(),main=dialog.querySelector('.an-main');if(!rows.length||!main?.querySelector('.an-playbar'))return;
  const i=index??rows.length-1,range=main.querySelector('[data-observation-range]');range.max=rows.length-1;range.value=i;
  main.querySelector('[data-change-step]').disabled=rows.length<2;main.querySelector('[data-guide-detail]').textContent='';
  main.querySelector('[data-observation-status]').textContent=(index===null?'实时':'历史只读')+' · #'+rows[i].serial;const readout=main.querySelector('[data-wave-readout]'),channels=anatomyWaveChannels(b(),rows,selection()?.net);if(readout)readout.textContent=(index===null?'实时':'历史只读')+' · 观察#'+rows[i].serial+' · '+channels.map(ch=>ch.name+'='+String(anatomyWaveValue(rows[i],ch)??'未计算')).join('；');
  main.querySelector('[data-observation-prev]').disabled=i===0;main.querySelector('[data-observation-next]').disabled=i>=rows.length-1;main.querySelector('[data-change-guide]').disabled=rows.length<2;main.querySelector('[data-observation-play]').disabled=rows.length<2;main.querySelector('[data-observation-play]').textContent=mode?'暂停':'重放观察';main.querySelector('[data-observation-live]').disabled=index===null;
  main.querySelector('[data-playback-note]').textContent=index===null?'变化讲解只按结构分组高亮，不代表传播延迟。':['guide','manual'].includes(mode)?'模型计算已经完成；现在分组查看已发生的变化，不构造中间电气状态。':'正在回看历史，输入暂时锁定。回到当前后继续实验；重放不会推进时钟或写入存储。';
  const cw=anatomyObservationColumnWidth(b());main.querySelector('[data-observation-cursor]')?.setAttribute('x',i*cw);const scroll=main.querySelector('.an-wave-scroll');if(scroll?.clientWidth&&(i*cw<scroll.scrollLeft||(i+1)*cw>scroll.scrollLeft+scroll.clientWidth))scroll.scrollLeft=Math.max(0,i*cw-scroll.clientWidth/2);dialog.dataset.observationMode=index===null?'live':mode||'paused';dialog.dataset.observationIndex=i;
 }
 function paintTimeline(){
  if(!ensurePanels())return;const rows=trace(),token=b().id+':'+rows.at(-1)?.serial+':'+(selection()?.net||'');
  if(token!==lastRecordToken){const markup=anatomyWaveMarkup(b(),rows,selection()?.net);dialog.querySelector('.an-wave-labels').innerHTML=markup.labels;dialog.querySelector('.an-wave-scroll').innerHTML=markup.svg;const svg=dialog.querySelector('.an-wave-svg');svg.onclick=event=>{const r=svg.getBoundingClientRect();show(Math.min(rows.length-1,Math.max(0,Math.floor((event.clientX-r.left)/r.width*rows.length))))};svg.onkeydown=event=>{const keys=['ArrowLeft','ArrowRight','Home','End','Enter'];if(!keys.includes(event.key))return;event.preventDefault();event.stopPropagation();if(event.key==='Enter'){returnLive();return}const current=index??rows.length-1;show(event.key==='Home'?0:event.key==='End'?rows.length-1:event.key==='ArrowLeft'?current-1:current+1)};lastRecordToken=token}
  const i=index??rows.length-1;if(rows[i])paintCoach(rows[i],rows[i-1]);updateCursor();
 }
 function observe(s,e){
  if(closed||index!==null)return;const id=b().id,rows=records.get(id)||[],snapshot=JSON.stringify({state:s,evaluation:e});
  if(rows.at(-1)?.snapshot!==snapshot){const serial=(serials.get(id)||0)+1;serials.set(id,serial);rows.push({snapshot,state:anLearningClone(s),evaluation:anLearningClone(e),serial,result:e.result,nets:{...e.nets},step:s.ticks});if(rows.length>24)rows.shift();records.set(id,rows)}paintTimeline();
 }
 function display(group){
  const row=observed();if(!row)return;showHistorical(anLearningClone(row.state),anLearningClone(row.evaluation),group);paintTimeline();
 }
 function show(i){stop();index=Math.max(0,Math.min(trace().length-1,i));display()}
 function returnLive(){stop();index=null;showCurrent();paintTimeline()}
 function startHistory(){stop();index=index===null?0:index;if(index>=trace().length-1)index=0;mode='history';display();timer=setTimeout(advance,speed)}
 function startGuide(){if(trace().length<2)return;stop();index=trace().length-1;guideStep=0;mode='guide';display();timer=setTimeout(advance,speed)}
 function presentGroup(group,total){
  display(group);const row=observed(),previous=trace()[index-1];
  dialog.querySelector('[data-observation-status]').textContent='结构变化组 '+guideStep+'/'+total;
  dialog.querySelector('[data-guide-detail]').textContent=group.title+'：'+(group.nets.length?group.nets.map(name=>name+' '+String(previous?.evaluation.nets[name]??'—')+' → '+String(row.evaluation.nets[name]??'—')).join('；'):'本次没有连接值改变，对照高亮器件查看保存状态。')+'。这不是时钟步进，也不代表实际传播时间。';
 }
 function stepGuide(){
  if(trace().length<2)return;const continuing=mode==='manual'||mode==='guide';if(timer!==null)clearTimeout(timer);timer=null;
  if(!continuing){index=trace().length-1;guideStep=0}mode='manual';
  const rows=trace(),groups=anatomyObservationGroups(b(),rows[index-1],rows[index]);if(guideStep>=groups.length)guideStep=0;
  presentGroup(groups[guideStep++],groups.length);
 }
 function advance(){
  if(closed||!mode)return;timer=null;
  if(mode==='history'){if(index<trace().length-1){index++;display();timer=setTimeout(advance,speed)}else stop()}
  else{const rows=trace(),groups=anatomyObservationGroups(b(),rows[index-1],rows[index]);if(guideStep<groups.length){const group=groups[guideStep++];presentGroup(group,groups.length);timer=setTimeout(advance,speed)}else stop()}
 }
 return {get active(){return index!==null},observed,trace,observe,show,returnLive,pausePlayback:stop,repaint:()=>display(),leave,reset(){leave();records.delete(b().id);serials.delete(b().id)},clearView(id){if(b().id===id)leave();records.delete(id);serials.delete(id)},dispose(){leave();closed=true;document.removeEventListener('visibilitychange',onVisibility);for(const type of ['click','input','change'])dialog.removeEventListener(type,preventMutation,true)}};
}

// Compare one chosen bit with its containing adder without mutating either experiment.
function anatomyAdderInstanceInputs(parent,bit){
 let carry=0;
 for(let i=0;i<bit;i++)carry=((parent.av>>>i)&1)&((parent.bv>>>i)&1)|carry&(((parent.av>>>i)&1)^((parent.bv>>>i)&1));
 return [(parent.av>>>bit)&1,(parent.bv>>>bit)&1,carry];
}
function anatomyFullAdderComparison(expected,actual,label,historical=false){
 const expand=([a,b,c])=>[a,b,c,a^b^c,(a&b)|((a^b)&c)],before=expand(expected),after=expand(actual),names=['A','B','Cin','S','Cout'];
 return `<h4>局部实验与上级对照 · ${label}</h4><div class="an-instance-flow"><span>A、B、Cin 输入</span><b>→ 全加器 →</b><span>S、Cout 输出</span></div><table><thead><tr><th>来源</th>${names.map(n=>`<th>${n}</th>`).join('')}</tr></thead><tbody><tr><th>上级当前</th>${before.map((v,i)=>`<td data-parent-signal="${names[i]}">${v}</td>`).join('')}</tr><tr><th>${historical?'局部历史':'局部实验'}</th>${after.map((v,i)=>`<td data-local-signal="${names[i]}" class="${v!==before[i]?'an-instance-different':''}" aria-label="${names[i]} ${v}${v!==before[i]?'，与上级不同':''}">${v}${v!==before[i]?'<small>不同</small>':''}</td>`).join('')}</tr></tbody></table><p>${after.every((v,i)=>v===before[i])?'当前输入输出与上级该位一致。':'金色标出差异；局部实验没有改变上级电路。'}${historical?' 此处比较局部历史与上级当前值。':''}</p>`;
}

function mountAnatomyCarryWalk(host,s,onFocus,blocked=()=>false){
 if(!host)return ()=>{};
 const rows=anatomyAdderRows(s);let index=-1,timer=null,disposed=false;
 const panel=document.createElement('div');panel.className='an-carry-walk';panel.innerHTML='<h4>沿进位走一遍</h4><div data-carry-stages></div><p data-carry-explain role="status"></p><div class="an-carry-walk-controls"><button data-carry-prev>← 上一位</button><button data-carry-next>下一位 →</button><button data-carry-play>自动讲解</button><button data-carry-restart>重看</button></div><small>讲解步骤按阅读节奏展开；不推进时钟，不模拟物理传播时间。</small>';
 host.querySelector(':scope > h4').after(panel);
 const stop=()=>{if(timer!==null)clearInterval(timer);timer=null;panel.querySelector('[data-carry-play]').textContent='自动讲解'};
 const paint=()=>{
  panel.querySelector('[data-carry-stages]').innerHTML=rows.map((r,i)=>`<button data-carry-stage="${i}" class="${i===index?'current':i<index?'done':''}" aria-current="${i===index?'step':'false'}"><small>位 ${i} · FA${i}</small><b>${i<=index?r.a+' + '+r.b+' + '+r.cin:'等待展开'}</b><span>${i<=index?'S='+r.sum+' · C'+(i+1)+'='+r.cout:'输入 → 和 / 进位'}</span></button>`).join('<span class="an-carry-arrow" aria-hidden="true">↓</span>');
  const r=rows[index];panel.querySelector('[data-carry-explain]').textContent=r?`第 ${index} 位：${r.a} + ${r.b} + Cin ${r.cin} = ${r.a+r.b+r.cin}；本位留下 S=${r.sum}，${index===3?'最高进位 C4='+r.cout:'把 Cout='+r.cout+' 送给第 '+(index+1)+' 位的 Cin'}。`:'从最低位开始。C0=0；每一位接收上一位的进位。';
  panel.querySelector('[data-carry-prev]').disabled=index<0;panel.querySelector('[data-carry-next]').disabled=index===3;
  panel.querySelectorAll('[data-carry-stage]').forEach(btn=>btn.onclick=()=>{if(blocked())return;stop();index=Number(btn.dataset.carryStage);paint();onFocus(index)});
 };
 const advance=()=>{if(disposed||blocked()||!host.isConnected){stop();return}if(index<3){index++;paint();onFocus(index)}if(index===3)stop()};
 panel.querySelector('[data-carry-next]').onclick=()=>{if(blocked())return;stop();advance()};
 panel.querySelector('[data-carry-prev]').onclick=()=>{if(blocked())return;stop();index=Math.max(-1,index-1);paint();if(index>=0)onFocus(index)};
 panel.querySelector('[data-carry-restart]').onclick=()=>{if(blocked())return;stop();index=-1;paint()};
 panel.querySelector('[data-carry-play]').onclick=()=>{if(blocked())return;if(timer!==null){stop();return}if(index===3)index=-1;advance();if(index<3){timer=setInterval(advance,1000);panel.querySelector('[data-carry-play]').textContent='暂停讲解'}};
 paint();return ()=>{disposed=true;stop()};
}

const AN_ADDER_SCENARIOS=[
 [2,4,'没有进位','每位输入最多只有一个1。'],
 [1,1,'产生进位','第0位的两个1产生C1=1。'],
 [7,1,'连续传播','第0位产生进位，第1、2位把进位继续传递。'],
 [15,1,'最高位进位','完整结果为10000；低4位归零，C4=1。'],
 [15,15,'多位产生进位','每一位的A、B均为1，完整和为11110。']
];
function anatomyAdderColumns(s){
 const a=s.av&15,b=s.bv&15,rows=anatomyAdderRows(s),total=a+b,cols=[4,3,2,1,0];
 const operand=(name,v)=>`<tr><th>${name==='av'?'A':'B'}</th><td>—</td>${[3,2,1,0].map(i=>`<td><button data-adder-operand="${name}" data-adder-bit="${i}" aria-pressed="${!!((v>>>i)&1)}" aria-label="翻转${name==='av'?'A':'B'}的第${i}位，当前${(v>>>i)&1}">${(v>>>i)&1}</button></td>`).join('')}<td>${v}</td></tr>`;
 return `<div class="an-adder-columns"><h4>点击二进制位，像竖式一样计算</h4><table><thead><tr><th>位权</th>${cols.map(i=>`<th>${2**i}</th>`).join('')}<th>十进制</th></tr></thead><tbody><tr class="an-column-carry"><th>进位</th>${cols.map(i=>`<td title="C${i}">C${i}=${i===0?0:rows[i-1].cout}</td>`).join('')}<td>低位 → 高位</td></tr>${operand('av',a)}${operand('bv',b)}<tr class="an-column-sum"><th>完整和</th>${cols.map(i=>`<td data-adder-sum-bit="${i}">${(total>>>i)&1}</td>`).join('')}<td data-adder-total>${total}</td></tr></tbody></table><p>4位输入，保留5位结果：<b>${a} + ${b} = ${total}</b>。C4是最高进位，不会丢弃。</p><div class="an-adder-scenarios">${AN_ADDER_SCENARIOS.map((x,i)=>`<button data-adder-scenario="${i}" title="${x[3]}">${x[2]}<small>${x[0]} + ${x[1]}</small></button>`).join('')}</div><p data-adder-scenario-note>试试“连续传播”，再逐位讲解，区分产生与传播。</p></div>`;
}

function anatomyRegisterCandidate(s){return s.reset?0:s.enable?s.av&15:s.q&15}
function anatomyRegisterLens(s,width=4){
 const mask=(1<<width)-1,d=s.av&mask,q=(width===8?s.reg8Q:s.q)&mask,next=width===8?anatomyRegister8Next(s):anatomyRegisterCandidate(s),bits=Array.from({length:width},(_,i)=>width-1-i);
 return `<section class="an-register-lens"><h4>${width}个位，同一个有效边沿保存</h4><p>点击 D 位改输入；金色选择器按 RESET → CE → 保持的优先级决定待采样位。点击触发器进入内部。</p><svg viewBox="0 0 ${width*88+8} 188" role="group" aria-label="${width}位寄存器，D=${d}，Q=${q}，下一值=${next}"><path d="M30 155H${width*88-22}" stroke="#f0cc7d" stroke-width="2"/>${bits.map((i,j)=>{const x=42+j*88,db=(d>>>i)&1,qb=(q>>>i)&1;return `<g><path d="M${x} 30V56M${x} 119V138" stroke="#72cbd6" stroke-width="2"/><path d="M${x-21} 36H${x+21}L${x+15} 51H${x-15}Z" fill="#364335" stroke="#e3c97d"/><text x="${x}" y="47" text-anchor="middle" fill="#f4db96" font-size="8">选${(next>>>i)&1}</text><g role="button" tabindex="0" data-register-input="${i}" aria-label="翻转D${i}，当前${db}"><rect x="${x-20}" y="6" width="40" height="27" rx="7" fill="${db?'#215e66':'#18333f'}" stroke="#70c9d4"/><text x="${x}" y="25" text-anchor="middle" fill="#d2f3ef" font-size="17">${db}</text></g><g role="button" tabindex="0" data-register-cell="${i}" aria-label="进入第${i}位触发器"><rect x="${x-28}" y="57" width="56" height="62" rx="7" fill="#1d3642" stroke="#91bac6"/><path d="M${x-28} 95l9 6-9 6" stroke="#efce82" fill="none"/><text x="${x}" y="79" text-anchor="middle" fill="#cce5ea" font-size="11">F${i}</text><text x="${x}" y="104" text-anchor="middle" fill="#f2d790" font-size="19">${qb}</text></g><path d="M${x-28} 101H${x-34}V155" stroke="#efce82" fill="none"/><text x="${x}" y="146" text-anchor="middle" fill="#c4dbe2" font-size="10">Q${i}=${qb}</text></g>`}).join('')}<text x="${width*44}" y="178" text-anchor="middle" fill="#f0cc7d" font-size="11">共享时钟 · 点击“上升沿”才保存</text></svg><div class="an-register-words"><div><small>当前输入 D</small><b data-register-d>${d.toString(2).padStart(width,'0')}</b><span>${d}</span></div><div><small>已保存 Q</small><b data-register-q>${q.toString(2).padStart(width,'0')}</b><span>${q}</span></div><div><small>下一有效边沿后</small><b data-register-next>${next.toString(2).padStart(width,'0')}</b><span>${next}</span></div></div><p data-register-rule>${s.reset?'RESET=1：下一有效边沿清零；优先于使能。':s.enable?'EN=1：下一有效边沿把D保存到Q。':'EN=0：下一有效边沿仍保持Q，输入D不写入。'} 修改输入不会提前改变 Q。</p><small>图中金色连线表示共享时钟条件，不表示在测量器件传播时间。</small></section>`;
}

function anatomyMemoryPreview(id,s){
 const dual=id==='bram',next=s.mem.slice(),collision=!!(dual&&s.we&&s.weB&&s.addr===s.addrB&&s.data!==s.dataB);
 if(!collision){if(s.we)next[s.addr]=s.data;if(dual&&s.weB)next[s.addrB]=s.dataB}
 return {next,collision,readA:dual?(collision?'X':s.mem[s.addr]):next[s.addr],readB:dual?(collision?'X':s.mem[s.addrB]):null};
}
function anatomyMemoryLens(b,s){
 if(!['sram','bram'].includes(b.id))return '';const dual=b.id==='bram',p=anatomyMemoryPreview(b.id,s),binary=v=>Number.isInteger(v)?v.toString(2).padStart(8,'0'):String(v),ports=dual?['A','B']:['A'];
 return `<section class="an-memory-lens"><h4>保存阵列 · 8 个字节</h4><p>${dual?'点击行选择地址；双端口阵列可继续从主图 MEM 展开。':'点击保存位进入 SRAM 单元；A 按钮选择地址。'}下方位按钮只修改待写数据，访问边沿才写入。</p>${dual?'':`<p data-memory-wordline-summary>地址 A2 A1 A0=${s.addr.toString(2).padStart(3,'0')} → WL7…WL0=${(1<<s.addr).toString(2).padStart(8,'0')}。当前仅行${s.addr}被选中，WE=${s.we}；${s.we?'下一访问边沿允许将待写字节写入这一行':'读仍有效，但下一访问边沿不改写保存内容'}。</p>`}<table><thead><tr><th>地址</th>${dual?'':'<th>字线WL</th>'}<th>已保存 bit7…0</th><th>十进制</th><th>选地址</th></tr></thead><tbody>${s.mem.map((v,i)=>`<tr class="${s.addr===i?'selected-a':''} ${dual&&s.addrB===i?'selected-b':''}"><th>${i}</th>${dual?'':`<td data-memory-wl="${i}" data-value="${+(s.addr===i)}">${s.addr===i?'● 1':'0'}</td>`}<td class="an-memory-word">${dual?binary(v):Array.from({length:8},(_,j)=>`<button class="an-memory-cell-bit" data-memory-cell="${i}" data-memory-cell-bit="${7-j}" aria-label="展开地址${i}的第${7-j}位，保存值${(v>>>(7-j))&1}">${(v>>>(7-j))&1}</button>`).join('')}</td><td>${v}</td><td>${ports.map(port=>`<button data-memory-address="${i}" data-memory-port="${port}" aria-pressed="${(port==='A'?s.addr:s.addrB)===i}" aria-label="端口${port}选地址${i}">${port}${(port==='A'?s.addr:s.addrB)===i?' ●':''}</button>`).join('')}</td></tr>`).join('')}</tbody></table>${ports.map(port=>{const addr=port==='A'?s.addr:s.addrB,data=port==='A'?s.data:s.dataB,we=port==='A'?s.we:s.weB,read=port==='A'?(dual?s.readQ:s.mem[s.addr]):s.readB,pending=port==='A'?p.readA:p.readB;return `<div class="an-memory-port"><b>端口 ${port} · 地址 ${addr} · WE=${we}</b><small>待写数据 ${data} / 0x${data.toString(16).toUpperCase().padStart(2,'0')}</small><div class="an-memory-data">${Array.from({length:8},(_,j)=>{const bit=7-j;return `<button data-memory-data="${port}" data-memory-bit="${bit}" aria-pressed="${!!((data>>>bit)&1)}" aria-label="翻转端口${port}待写数据第${bit}位">${(data>>>bit)&1}<small>${bit}</small></button>`}).join('')}</div><dl><div><dt>当前读出</dt><dd data-memory-read="${port}">${binary(read)}</dd></div><div><dt>下一边沿后读出</dt><dd data-memory-next-read="${port}">${binary(pending)}</dd></div><div><dt>下一边沿后保存行 ${addr}</dt><dd data-memory-next-saved="${port}">${binary(p.next[addr])}</dd></div></dl></div>`}).join('')}<p class="${p.collision?'an-memory-conflict':''}" data-memory-policy>${p.collision?'两端口同址写不同数据：本教学模型保留旧存储内容，两路读出标为X。':dual?'同步读旧值：同一边沿写入新数据时，读出口先得到写入前的数据；再给边沿可读到新值。':'组合读：选地址立即改变读出；写使能有效时，访问边沿更新保存字节。'}</p><small>候选值以当前输入不变为前提，不会提前写入。阵列和冲突规则是缩小的教学模型。</small></section>`;
}

function anatomySRAMCellLens(s){
 const next=s.enable?s.a:s.q;
 return `<section class="an-cell-lens"><h4>一个保存位，两个互补节点</h4><svg viewBox="0 0 340 140" role="group" aria-label="Q=${s.q}，QB=${1-s.q}，两个反相器交叉反馈"><path d="M70 45H112M175 45H265V105H228M165 105H70V45" fill="none" stroke="#70c4d2" stroke-width="3"/><g role="button" tabindex="0" data-cell-inverter="I0" aria-label="进入INV0，输入Q=${s.q}，输出QB=${1-s.q}"><path d="M112 23L155 45L112 67Z" fill="#203e4c" stroke="#b5d5dd" stroke-width="2"/><circle cx="163" cy="45" r="7" fill="#102b39" stroke="#b5d5dd" stroke-width="2"/><text x="130" y="18" fill="#bdd6df" font-size="11">INV0</text></g><g role="button" tabindex="0" data-cell-inverter="I1" aria-label="进入INV1，输入QB=${1-s.q}，输出Q=${s.q}"><path d="M228 83L185 105L228 127Z" fill="#203e4c" stroke="#b5d5dd" stroke-width="2"/><circle cx="177" cy="105" r="7" fill="#102b39" stroke="#b5d5dd" stroke-width="2"/><text x="208" y="76" fill="#bdd6df" font-size="11">INV1</text></g><circle cx="70" cy="45" r="5" fill="#f0cf81"/><circle cx="265" cy="45" r="5" fill="#f0cf81"/><text x="45" y="38" text-anchor="middle" fill="#f6d994" font-size="18">Q=${s.q}</text><text x="291" y="38" text-anchor="middle" fill="#f6d994" font-size="18">QB=${1-s.q}</text><text x="70" y="132" text-anchor="middle" fill="#b0d0d8" font-size="10">返回同一个Q节点</text></svg><p>INV0：${s.q} → ${1-s.q}；INV1：${1-s.q} → ${s.q}。反馈与当前保存值一致，两个节点互补。</p><div class="an-cell-prepare"><button data-cell-prepare="0">准备写 0</button><button data-cell-prepare="1">准备写 1</button></div><dl><div><dt>待写 BL / BLB</dt><dd>${s.a} / ${1-s.a}</dd></div><div><dt>字线 WL</dt><dd>${s.enable}</dd></div><div><dt>执行写入后 Q / QB</dt><dd data-cell-next>${next} / ${1-next}</dd></div></dl><p>${s.enable?'WL=1：允许教学写入动作访问该位；点击上方“执行写入”才提交。':'WL=0：访问管关闭，写入动作保持原值。'} 准备输入不会先改保存值。</p><small>此处是稳定状态与离散写入模型，不计算读扰动、晶体管尺寸、电压或写入时间。</small></section>`;
}

const AN_LUT_PRESETS=[['and2','两输入 AND','I0 AND I1；I2…I5 不参与'],['or2','两输入 OR','I0 OR I1；I2…I5 不参与'],['xor2','两输入 XOR','I0 XOR I1；I2…I5 不参与'],['and6','六输入 AND','六个输入全为1时输出1'],['parity6','六输入奇校验','六个输入中1的个数为奇数时输出1'],['mux','2选1 MUX','I2=0选择I0；I2=1选择I1；I3…I5不参与']];
function anatomyLUTFunction(name,address){
 const a=address&1,b=(address>>>1)&1,sel=(address>>>2)&1;
 if(name==='and2')return a&b;if(name==='or2')return a|b;if(name==='xor2')return a^b;if(name==='and6')return +(address===63);if(name==='parity6'){let parity=0;for(let i=0;i<6;i++)parity^=(address>>>i)&1;return parity}if(name==='mux')return sel?b:a;
 throw Error('Unknown LUT teaching function');
}
function anatomyLUTLens(b,s){
 if(b.id!=='lut')return '';const address=s.lutAddr,word=BigInt('0b'+s.lut.slice().reverse().join('')).toString(16).toUpperCase().padStart(16,'0');
 return `<section class="an-lut-lens"><h4>输入选表项，配置决定函数</h4><div class="an-lut-inputs">${[5,4,3,2,1,0].map(i=>`<button data-lut-address-bit="${i}" aria-pressed="${!!((address>>>i)&1)}" aria-label="切换输入I${i}，当前${(address>>>i)&1}"><small>I${i}</small><b>${(address>>>i)&1}</b></button>`).join('')}</div><div class="an-lut-selection"><span>地址 <b data-lut-address>${address}</b></span><span>→ INIT[${address}]</span><b data-lut-output>O6=${s.lut[address]}</b></div><p>I0是地址最低位。六位输入只选择一个表项，不会改写配置。</p><div class="an-lut-config-actions"><button data-lut-selected-toggle>翻转当前 INIT[${address}]</button><button data-lut-open-cell>展开当前配置位教学单元 →</button></div><details><summary>装入一个逻辑函数 · 会替换64项配置</summary><div class="an-lut-functions">${AN_LUT_PRESETS.map(([id,label,hint])=>`<button data-lut-function="${id}" title="${hint}">${label}</button>`).join('')}</div><p data-lut-function-note>这些函数使用同一张64项表，输入数量或连接方式没有改变。</p></details>${anatomyLUTTreeLens(s)}<small class="an-lut-init">INIT[63:0] = 64'h${word}</small><small>配置编辑是教学操作，不代表完成实体板的综合或位流下载。</small></section>`;
}

function anatomyLUTSelectionStages(s){
 let values=s.lut.slice();const stages=[];
 for(let level=0;level<6;level++){
  const select=(s.lutAddr>>>level)&1,node=s.lutAddr>>>(level+1),a=values[node*2],b=values[node*2+1],out=select?b:a;
  stages.push({level,node,count:values.length/2,a,b,select,out});
  values=Array.from({length:values.length/2},(_,i)=>values[2*i+select]);
 }
 return stages;
}
function anatomyLUTTreeLens(s){
 return `<details class="an-lut-tree-lens"><summary>展开选择网络 · 六级如何选到当前配置位</summary><p>用63个2选1单元组成教学选择树。下表只列出通向当前输出的6个单元；每级还存在其他并行单元。</p><table><thead><tr><th>级</th><th>选择</th><th>候选0</th><th>候选1</th><th>输出</th><th>内部</th></tr></thead><tbody>${anatomyLUTSelectionStages(s).map(r=>`<tr><th>${r.level+1}</th><td>I${r.level}=${r.select}</td><td class="${r.select===0?'chosen':''}">${r.a}</td><td class="${r.select===1?'chosen':''}">${r.b}</td><td>${r.out}</td><td><button data-lut-stage="${r.level}" aria-label="展开第${r.level+1}级第${r.node}个2选1单元">展开 →</button></td></tr>`).join('')}</tbody></table><p>各级单元数：32 → 16 → 8 → 4 → 2 → 1。I0先选相邻配置位，I5最终决定上下半表。行序是逻辑依赖，不是6个时钟。</p><small>选择树是LUT函数的可实现教学分解，不声称是厂商内部晶体管结构。</small></details>`;
}

function anatomyInputPreview(s){
 const candidate=s.s2===s.candidate?s.candidate:s.s2,count=s.s2===s.candidate?s.consecutive+1:1,stable=count>=3?candidate:s.stable;
 return {s1:s.a,s2:s.s1,candidate,consecutive:count,stable,previous:s.stable,keyEvent:+(stable&&!s.stable)};
}
function anatomyInputChainLens(b,s){
 if(b.id!=='input')return '';const n=anatomyInputPreview(s),cards=[['SYNC','两级同步','FF1='+s.s1+' · FF2='+s.s2,'FF1='+n.s1+' · FF2='+n.s2],['DB','连续3次稳定','候选='+s.candidate+' · 次数='+s.consecutive+' · 输出='+s.stable,'候选='+n.candidate+' · 次数='+n.consecutive+' · 输出='+n.stable],['EV','按下事件','事件='+s.keyEvent,'事件='+n.keyEvent]];
 return `<section class="an-input-chain-lens"><h4>同一采样边沿，各级读取旧保存值</h4><button data-input-raw aria-pressed="${!!s.a}">原始引脚 = ${s.a} · 点击切换</button><div class="an-input-chain-cards">${cards.map(([id,title,now,next])=>`<span class="an-input-chain-arrow" aria-hidden="true">↓</span><button data-input-stage="${id}"><b>${title} → 展开</b><span>当前：${now}</span><strong>下一边沿：${next}</strong></button>`).join('')}</div><p>下一边沿：FF1取原始输入 ${s.a}，FF2取旧FF1 ${s.s1}，消抖器取旧FF2 ${s.s2}。同一边沿不会让新输入直接穿过整条链。</p><p>${n.keyEvent?'下一边沿会确认稳定值从0变1，产生一次按下事件。':n.stable?'保持按住不会重复产生事件；必须先确认松开，才能再次检测按下。':'稳定值尚未从0变1，本次没有按下事件。'}</p><small>3次是缩小的教学阈值，不表示真实消抖时间；同步器不模拟亚稳态电压或失效率。</small></section>`;
}

const AN_INPUT_SCENARIOS=[
 ['干净按下','00'+'1'.repeat(8),'输入由0变1后持续保持；应只确认一次按下。'],
 ['触点抖动','010101'+'1'.repeat(8),'前段反复翻转，连续稳定后才确认按下。'],
 ['短脉冲','001'+'0'.repeat(9),'只有一个采样宽的高电平，未满足连续3次稳定条件。'],
 ['按住、松开、再按','00'+'1'.repeat(7)+'0'.repeat(7)+'1'.repeat(7),'确认松开后再次按下，应出现第二次事件。']
];
function anatomyParseInputPattern(text){
 const bits=String(text).replace(/[\s,_]+/g,'');if(!/^[01]{1,64}$/.test(bits))throw Error('请输入1…64个0或1，可用空格、逗号、下划线分隔。');return bits;
}
function anatomyInputStimulusMarkup(b,s){
 if(b.id!=='input')return '';const pattern=s.inputPattern||'',index=s.inputPatternIndex||0,escape=x=>String(x).replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
 return `<details class="an-input-stimulus"><summary>动手实验：逐边沿送入按键序列</summary><div class="an-input-presets">${AN_INPUT_SCENARIOS.map((x,i)=>`<button data-input-pattern-example="${i}">${x[0]}</button>`).join('')}</div><label>0/1序列 · 每位对应一次采样<textarea data-input-pattern-draft rows="2" maxlength="256" spellcheck="false">${escape(s.inputPatternDraft??AN_INPUT_SCENARIOS[1][1])}</textarea></label><p data-input-pattern-hint>选择例子只修改草稿，不会推进电路。</p><button data-input-pattern-load>装入序列，从零开始本实验</button><p data-input-pattern-error role="status"></p>${pattern?`<div class="an-input-pattern-bits" aria-label="已送入${index}位，共${pattern.length}位">${Array.from(pattern,(bit,i)=>`<span class="${i<index?'done':i===index?'next':''}" title="第${i+1}个采样：${bit}">${bit}</span>`).join('')}</div><p>序列进度 <b data-input-pattern-progress>${index}/${pattern.length}</b> · 本序列采样检出事件 <b data-input-pattern-events>${s.inputPatternEvents||0}</b></p><button data-input-pattern-next ${index>=pattern.length?'disabled':''}>送入下一位并采样 ↑</button>`:''}<small>装入会清零本层同步、消抖和事件状态及观察历史。普通采样与手动切换输入不会推进序列位置。序列结束后最后引脚值保持；链路可能尚未稳定，可用普通采样继续观察。步数不代表毫秒。</small></details>`;
}

function anatomyInputSample(s){return {edge:s.ticks,raw:s.a,s1:s.s1,s2:s.s2,candidate:s.candidate,count:s.consecutive,stable:s.stable,event:s.keyEvent}}
function anatomyInputWaveMarkup(s){
 const trace=s.inputPatternTrace;if(!trace?.length)return '';const channels=[['raw','原始引脚'],['s1','FF1'],['s2','FF2'],['stable','稳定值'],['event','按下事件']],cw=38,left=94,width=Math.max(700,left+trace.length*cw+14),height=channels.length*39+72;
 const grid=trace.map((row,i)=>`<g role="button" tabindex="0" data-input-wave-sample="${i}" aria-label="查看序列采样${i}，事件${row.event}"><rect x="${left+i*cw}" y="30" width="${cw}" height="${height-52}" fill="${row.event?'#e3c580':'#78b5c8'}" fill-opacity="${row.event?'.15':'.015'}"/><path d="M${left+i*cw} 30V${height-22}" stroke="#345362" stroke-width=".6"/><text x="${left+i*cw+cw/2}" y="20" text-anchor="middle" fill="#b9d2dc" font-size="10">${i===0?'初始':i}</text></g>`).join('');
 const waves=channels.map(([key,label],j)=>{const top=39+j*39,points=trace.map((row,i)=>[left+i*cw,top+(row[key]?0:19)]);let path='M'+points[0].join(' ');for(let i=0;i<points.length;i++){if(i)path+='H'+points[i][0]+'V'+points[i][1];path+='H'+(points[i][0]+cw)}return `<g pointer-events="none"><text x="8" y="${top+12}" fill="#bfd9df" font-size="12">${label}</text><path d="${path}" stroke="${key==='event'?'#f2cf7b':key==='raw'?'#64cce0':'#94d4b5'}" fill="none" stroke-width="2"/><title>${label}：${trace.map(r=>r[key]).join(',')}</title></g>`}).join('');
 return `<h3>已经执行的激励采样 · 各级对齐观察</h3><div class="an-input-wave-scroll"><svg viewBox="0 0 ${width} ${height}" width="${width}" height="${height}" role="group" aria-label="离散采样记录，横轴为采样序号而非物理时间">${grid}${waves}</svg></div><p data-input-wave-detail role="status">点击采样列，查看该边沿后的各级保存值。金色列表示产生按下事件。</p><button data-input-wave-csv>下载采样 CSV ↓</button><small>每列是送入序列的一次真实模型操作后的状态；第0列为初始化。这里只画离散观察值，不声称测量到实际传播延迟。</small>`;
}
function anatomyInputSamplesCSV(s){
 const keys=['edge','raw','s1','s2','candidate','count','stable','event'];return ['采样序号,教学边沿次数,原始引脚,FF1,FF2,消抖候选,连续次数,稳定值,按下事件',...(s.inputPatternTrace||[]).map((row,i)=>[i,...keys.map(k=>row[k])].join(','))].join('\r\n');
}

function anatomyDFFPhases(s){
 const e=anatomyEvaluate('dff',s),m=e.nets['主状态'],q=e.result,high=!!s.clk;
 const stage=(id,label,value,open,x)=>`<g data-dff-phase="${id}" data-transparent="${+open}" data-value="${value}"><rect x="${x}" y="35" width="90" height="91" rx="12" fill="${open?'#1b4a43':'#3e382c'}" stroke="${open?'#7ad4b4':'#e3c47b'}"/><text x="${x+45}" y="54" text-anchor="middle">${label}</text><text x="${x+45}" y="83" text-anchor="middle" class="phase-value">${value}</text><text x="${x+45}" y="111" text-anchor="middle">${open?'透明 · 跟随':'关闭 · 保持'}</text></g>`;
 return `<section class="an-storage-lens an-dff-phases"><a href="labs/lab06-state.zip" download>下载寄存器/计数器工程 ↓</a><h4>两级交替透明，外部只在上升沿更新</h4><svg viewBox="0 0 320 157" role="img" aria-label="CLK=${s.clk}，D=${s.a}，主级=${m}，Q=${q}；主级${high?'保持':'透明'}，从级${high?'透明':'保持'}"><text x="15" y="20">D=${s.a}</text><text x="245" y="20">Q=${q}</text><path d="M15 78H58M148 78H175M265 78H305" fill="none" stroke="#89b9cc" stroke-width="2"/>${stage('M','主锁存 M',m,!high,58)}${stage('SL','从锁存 SL',q,high,175)}<text x="160" y="148" text-anchor="middle">CLK=${s.clk} · 主使能=${1-s.clk} · 从使能=${s.clk}</text></svg><div class="an-dff-stage-buttons"><button data-storage-stage="M">定位主级 M</button><button data-storage-stage="SL">定位从级 SL</button></div><p data-dff-phase-explanation>${high?'CLK=1：主级关闭，D的新变化被挡在主级之前；从级虽透明，但收到的是主级保持值，因此Q保持。':'CLK=0：主级透明，D改变会更新主状态；从级关闭，所以外部Q保持。'}</p><dl><div><dt>当前已保存 Q</dt><dd data-dff-saved>${q}</dd></div><div><dt>若D不再改变，下一次有效上升沿后</dt><dd data-dff-next>${s.a}</dd></div></dl><p>${high?'时钟已高，再点上升沿不会产生新边沿。先拉低时钟，再给上升沿；拉低本身不改变Q。':'下一次上升沿关闭主级、打开从级，把此刻D传到Q。'}</p><small>主从结构用于说明功能关系，非厂商触发器制造网表；不模拟建立/保持时间、亚稳态或真实传播延迟。</small></section>`;
}
