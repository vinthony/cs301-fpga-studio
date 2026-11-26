'use strict';
const AN_SEG=[63,6,91,79,102,109,125,7,127,111,119,124,57,94,121,113];
function anatomyState(){return {a:1,b:0,cin:0,q:0,master:0,clk:0,ticks:0,enable:1,reset:0,word:0x35,sw:0x35,av:5,bv:3,op:'ADD',addr:0,data:42,we:1,mem:Array(8).fill(0),readQ:0,lut:Array.from({length:64},(_,i)=>((i&1)^((i>>1)&1))),lutAddr:1,truthMask:6,digit:0,scanDots:0,scanPhase:2,phase:0,duty:8,pct:50,byte:65,uartIndex:-1,uartByte:65,baud:115200,pressed:0,stable:0,previous:0,consecutive:0,candidate:0,s1:0,s2:0,release0:1,release1:1,shift:0,samples:[0,0,0,0],cpuStage:0,r0:1,r1:2,waddr:3,reg:Array(8).fill(0),key:4,modifier:0,cmp10A:655,cmp10B:656,cmpBitA:0,cmpBitB:1,cmpPrefixEq:1,cmpPrefixLt:0,timingX:655,timingY:489,rasterQ:0,rasterLimit:799,rasterStart:0,rasterEnable:1,rasterReset:0,rasterLast:null,pixelQ:0,pixelD:0xf00,pixelWE:1,pixelAddress:null,pixelLast:null,pixel:0,rgb:0x0cf,vgaSource:"uniform",vgaCountEnable:1,vgaFB:{},vgaImageData:"",vgaImageImport:null,vgaOutput:null,vgaWriteAddress:0,vgaWriteData:0xf00,vgaWriteEnable:0,vgaWrites:0,vgaLast:null,cache:Array.from({length:4},()=>({valid:0,tag:0,data:0})),mode:0,powered:1,configured:0,flash:0,userCount:0,adcValid:1,adcSample:0,adcSampleValid:0,adcSamples:[0,0,0,0],adcFilterCount:0,filterLast:null,history:[]}}
function anatomyDebouncePreview(s){const same=s.a===s.candidate,candidate=s.a,count=same?s.consecutive+1:1,ready=count>=3;return {same,candidate,count,ready,stable:ready?candidate:s.stable}}
function anatomyRasterPlan(s){const q=s.rasterQ,increment=q+1,terminal=+(q===s.rasterLimit),d=terminal?0:increment&1023;return {increment,terminal,d,next:s.rasterReset?0:s.rasterEnable?d:q};}
function anatomyVGAQuantizeRGBA(pixels){if(pixels.length!==640*480*4)throw Error('需要640×480的RGBA像素');const words=new Array(307200);for(let address=0;address<307200;address++){const i=address*4;words[address]=(((pixels[i]>>>4)<<8)|((pixels[i+1]>>>4)<<4)|(pixels[i+2]>>>4)).toString(16).padStart(3,'0');}return words.join('');}
function anatomyVGABaseMemory(s,address){return s.vgaImageData?parseInt(s.vgaImageData.slice(address*3,address*3+3),16):0;}
function anatomyVGAMemory(s,address){return s.vgaFB?.[address]??anatomyVGABaseMemory(s,address);}
function anatomyVGAOutput(s){return s.vgaSource==='framebuffer'?(s.vgaOutput||{valid:0,x:0,y:0,active:0,hs:1,vs:1,rgb:0,address:null}):{...anatomyVGAPlan(s),valid:1};}
function anatomyVGAAdvance(s,count=1){
 if(!Number.isInteger(count)||count<1||count>416800)throw Error('像素推进数量须为1…416800');
 if(s.vgaSource!=='framebuffer'){if(s.vgaCountEnable!==0)s.pixel=(s.pixel+count)%416800;s.ticks+=count;return;}
 if(s.vgaWriteEnable&&(!Number.isInteger(s.vgaWriteAddress)||s.vgaWriteAddress<0||s.vgaWriteAddress>=307200||!Number.isInteger(s.vgaWriteData)||s.vgaWriteData<0||s.vgaWriteData>4095))throw Error('帧缓冲写地址或12位数据越界');
 s.vgaFB??={};for(let i=0;i<count;i++){
  const v=anatomyVGAPlan(s),write=s.vgaWriteEnable?{address:s.vgaWriteAddress,before:anatomyVGAMemory(s,s.vgaWriteAddress),after:s.vgaWriteData}:null;
  s.vgaOutput={...v,valid:1};s.vgaLast={edge:s.ticks+1,requestPixel:s.pixel,readAddress:v.address,readValue:v.rgb,write,counterEnabled:s.vgaCountEnable!==0};
  if(write){if(write.after===anatomyVGABaseMemory(s,write.address))delete s.vgaFB[write.address];else s.vgaFB[write.address]=write.after;s.vgaWrites=(s.vgaWrites||0)+1;}
  if(s.vgaCountEnable!==0)s.pixel=(s.pixel+1)%416800;s.ticks++;
 }
}
function anatomyVGAPlan(s){
 const x=s.pixel%800,y=Math.floor(s.pixel/800),active=x<640&&y<480,hs=+(x<656||x>=752),vs=+(y<490||y>=492),address=active?y*640+x:null;
 return {x,y,active:+active,hs,vs,rgb:active?(s.vgaSource==='framebuffer'?anatomyVGAMemory(s,address):s.rgb):0,address,hzone:x<640?'可见':x<656?'前肩':x<752?'同步':'后肩',vzone:y<480?'可见':y<490?'前肩':y<492?'同步':'后肩'};
}
function anatomyEvaluate(id,s){let lab=ANATOMY[id]?.lab||id,nets={},watch=[],led=0,digits=[0,0,0,0],result=null;
 const n=(name,v)=>nets[name]=v,w=(name,v,why)=>watch.push({name,value:String(v),why});const bits=(v,c=4)=>(v>>>0).toString(2).padStart(c,'0');
 if(lab==='compare10'||lab==='comparebit'){const p=lab==='compare10'?anatomyCompare10Plan(s):anatomyCompareBitPlan(s);return {result:p.lt,led:p.lt,digits:[0,0,0,AN_SEG[p.lt]],nets:p.nets,watch:p.watch};}
 if(lab==='timingcompare'){const p=anatomyTimingPlan(id,s);return {result:p.result,led:p.result,digits:[0,0,0,AN_SEG[p.result]],nets:p.nets,watch:p.watch};}
 if(['and','or','xor','nand','nor','not','cmos','nmos','pmos','mux','halfadder','fulladder'].includes(lab)){
 let a=s.a,b=s.b,c=s.cin,y=lab==='and'?a&b:lab==='or'?a|b:lab==='xor'?a^b:lab==='nand'?1-(a&b):lab==='nor'?1-(a|b):['not','cmos','pmos'].includes(lab)?1-a:lab==='nmos'?a:lab==='mux'?(c?b:a):lab==='halfadder'?a^b:a^b^c;
 result=y;led=y;n('A',a);n('B',b);n('Y',y);n('P',a^b);n('P支路',a^b);n('A支路',a);n('B支路',b);n('G',a&b);n('H',(a^b)&c);n('S',y);n('C',a&b);n('Cout',(a&b)|((a^b)&c));n('Cin',c);n('Cin支路',c);n('VDD',1);n('GND',0);n('上拉',1-a);n('下拉',1-a);n('A→P栅',a);n('A→N栅',a);n('SEL',c);n('SEL直连',c);n('~SEL',1-c);n('路径0',a&(1-c));n('路径1',b&c);n('~A',1-a);n('~B',1-b);n('A直连',a);n('B直连',b);n('项0',(1-a)&b);n('项1',a&(1-b));
 w('输入',['nmos','pmos'].includes(lab)?`G=${a}`:['not','cmos'].includes(lab)?`A=${a}`:`A=${a}, B=${b}${['mux','fulladder'].includes(lab)?', '+(lab==='mux'?'SEL':'Cin')+'='+c:''}`,'固定输入后观察稳态结果');w(['nmos','pmos'].includes(lab)?'通路状态':'输出',y,['nmos','pmos'].includes(lab)?(y?'理想通路闭合':'理想通路断开'):'不代表物理延迟');if(lab==='fulladder'){w('P=A⊕B',a^b,'传播项');w('G=A·B',a&b,'直接产生进位');w('H=P·Cin',(a^b)&c,'传播输入进位');w('Cout',(a&b)|((a^b)&c),'送到高一位')}
 if(lab==='nand'||lab==='nor'){const p0=1-a,p1=1-b,n0=a,n1=b;w('P1 / P2',p0+' / '+p1,'PMOS 低栅导通');w('N1 / N2',n0+' / '+n1,'NMOS 高栅导通');w('上拉可达',lab==='nand'?p0|p1:p0&p1,'NAND 上拉并联；NOR 上拉串联');w('下拉可达',lab==='nand'?n0&n1:n0|n1,'NAND 下拉串联；NOR 下拉并联')}
 }else if(['adder','subtract','alu'].includes(lab)){
 let a=s.av&15,b=s.bv&15,total=lab==='subtract'?a+((~b)&15)+1:a+b,res=total&15;
 if(lab==='alu'){res=s.op==='AND'?a&b:s.op==='OR'?a|b:s.op==='XOR'?a^b:s.op==='SUB'?(a-b)&15:s.op==='SHL'?(a<<(b&3))&15:res;}
 result=res;led=res;w('A / B',bits(a)+' / '+bits(b),'四位操作数');w('低四位结果',bits(res)+' = '+res,'四位总线输出');w('算术进位',(total>>4)&1,'仅对这里的加减候选有意义，不能当所有 ALU 操作的标志');let carry=lab==='subtract'?1:0,bitsB=lab==='subtract'?(~b)&15:b;
 for(let i=0;i<4;i++){let av=(a>>i)&1,bv=(bitsB>>i)&1,old=carry,sv=av^bv^old;carry=(av&bv)|(old&(av^bv));n('C'+i,old);n('S'+i,sv);n('A'+i+'/B'+i,av+'/'+bv);w('FA'+i,`A=${av} B=${bv} Cin=${old} → S=${sv} Cout=${carry}`,'低位向高位传播')};n('C4',carry);n('RESULT',res);n('A',a);n('B',b);n('~B',(~b)&15);n('Cin=1',1);
 }else if(lab==='contact'||lab==='led'){result=s.a;led=s.a;n('公共端',s.a);n('内部输入',s.a);n('按钮节点',s.a);n('原始输入',s.a);n('输出驱动',s.a);w('数字输入 / 输出',s.a,'理想电平模型，不计算触点电阻或 LED 电流');w('下一层',lab==='contact'?'进入同步 / 消抖结构，观察采样过程':'进入 PWM，观察周期与占空比','实体电气层与数字功能层分开');}else if(lab==='power'){result=s.powered&&s.configured?s.userCount:0;led=result;w('POWER',s.powered,'仅表示本模型有供电');w('DONE',s.powered&&s.configured?1:0,'配置已加载不等于程序正确');w('Flash',s.flash?'有非易失配置':'无配置','断电不丢失本模型的 Flash 内容');w('用户计数',result,'需通电且配置完成才能运行');n('电源良好',s.powered);n('POWER提示',s.powered);n('DONE提示',s.powered&&s.configured?1:0);}else if(lab==='board'){
 let a=s.sw&15,b=(s.sw>>4)&15;led=a+b;result=led;digits=[AN_SEG[led&15],AN_SEG[(led>>4)&15],AN_SEG[0],AN_SEG[0]];n('SW[15:0]','0x'+s.sw.toString(16).padStart(4,'0'));n('LED[15:0]',led);n('SEG / AN','扫描显示 '+led.toString(16));w('教学电路','低四位 A='+a+'；次低四位 B='+b,'这里明确使用加法器，不把开关直接连灯');w('LED',bits(led,16),'高位到低位');w('LD 点亮位',Array.from({length:16},(_,i)=>i).filter(i=>led&(1<<i)).join(', ')||'全灭','独立输出位');
 }else if(lab==='latch'){result=s.enable?s.a:s.q;led=result;w('使能 G',s.enable,s.enable?'透明：输出跟随输入':'保持：反馈存储状态');w('D',s.a,'输入数据');w('Q',result,'锁存器电平敏感，不是只等上升沿');n('D',s.a);n('EN',s.enable);n('保持反馈',result);n('Q',result);}else if(['register','dff','synchronizer','reset','counter','shiftreg','edge','debounce','fsm'].includes(lab)){
 result=['counter','register','shiftreg'].includes(lab)?lab==='counter'?s.q:lab==='shiftreg'?s.shift:s.q:lab==='synchronizer'?s.s2:lab==='reset'?s.release1:lab==='edge'?s.stable&(1-s.previous):lab==='debounce'?s.stable:lab==='fsm'?s.mode:s.q;led=result;
 w('边沿次数',s.ticks,'只在点按明确的边沿操作时推进');w('输入 D / 原始值',lab==='register'?s.av:s.a,'输入改变不自动保存寄存状态');w('当前输出',result,'观察保持、延迟和更新条件');n('当前值',s.q);n('加一结果',(s.q+1)&15);n('保持',s.q);n('下一状态',s.reset?0:s.enable?(s.q+1)&15:s.q);n('异步数据',s.a);n('前级输出',s.s1);n('级联',s.release0);n('当前',s.stable);n('上一拍',s.previous);n('上一拍为0',1-s.previous);
 if(lab==='dff'){n('D',s.a);n('Q',s.q);n('CLK',s.clk);n('~CLK',1-s.clk);n('时钟反相输入',s.clk);n('主状态',s.clk?s.master:s.a);n('从时钟',s.clk);n('反相时钟',1-s.clk);w('CLK',s.clk,'低电平时主级透明；高电平时从级透明');w('主级状态',s.clk?s.master:s.a,'这是主从教学实现，不是厂商 FF 的制造网表')};if(lab==='synchronizer'){w('SYNC1',s.s1,'本边沿捕获异步数字样本；不模拟亚稳态电压');w('SYNC2',s.s2,'接收前级旧值')};if(lab==='debounce'){w('候选 / 连续次数',s.candidate+' / '+s.consecutive,'本例阈值为3个教学采样');w('稳定值',s.stable,'需要三个连续相同样本')};if(lab==='reset')w('释放链',s.release0+' → '+s.release1,'外部复位有效时异步置1，按边沿同步释放');
 }else if(lab==='lut'||lab==='slice'||lab==='fabric'||lab==='routing'){
 result=s.lut[s.lutAddr];led=result;n('选择地址',bits(s.lutAddr,6));n('O6',result);n('配置位','64 项表');w('六位输入',bits(s.lutAddr,6)+' = '+s.lutAddr,'作为 INIT 选择地址');w('INIT['+s.lutAddr+']',result,'被选中的配置位');w('配置与输入','改地址选择不同项；改表项改变函数','两种操作含义不同');
 }else if(lab==='ram'){
 result=['bram'].includes(id)?s.readQ:s.mem[s.addr];led=result;n('地址',s.addr);n('字线WL',1<<s.addr);n('写使能',s.we);n('待写字节',s.data);n('读位线',result);n('写位线',id==='sram'&&!s.we?'Z':s.data);w('地址',s.addr,'只选中一行');w('待写数据',s.data,'修改输入不会立即写入');w('读出值',result,id==='bram'?'本例同步读；同址写采用读旧值模型':'本例组合读，地址改变后观察当前数组值');w('写使能',s.we,'仅边沿且使能有效写入');
 }else if(lab==='sramcell'){
 result=s.q;led=result;n('Q',s.q);n('QB',1-s.q);n('Q反馈',s.q);n('QB访问',1-s.q);n('WL0',s.enable);n('WL1',s.enable);n('BL',s.a);n('BLB',1-s.a);w('Q / QB',s.q+' / '+(1-s.q),'互补稳定状态');w('WL',s.enable,'访问管开关');w('待写BL / BLB',s.a+' / '+(1-s.a),'仅写入动作可更新，读电路未模拟');
 }else if(lab==='scan'){
 const nib=(s.word>>(s.digit*4))&15,mask=AN_SEG[nib],an=s.scanPhase===2?(15^(1<<s.digit)):15,seg=(~mask)&127;digits[s.digit]=s.scanPhase===2?(mask|(((s.scanDots||0)>>>s.digit&1)<<7)):0;result=an;w('显示字','0x'+s.word.toString(16).padStart(4,'0'),'按 AN0 从最低 nibble 取数');w('阶段',['消隐','准备段码','点亮'][s.scanPhase],'观察步骤不是实体时钟周期');w('an[3:0]',bits(an),'低有效，0 选通');w('seg[6:0]',bits(seg,7),'低有效段码');w('当前数字',nib.toString(16).toUpperCase(),'仅选通位亮');n('数字地址',nib);n('低有效段码',bits(seg,7));n('四个数字',s.word);n('当前位',s.digit);n('待显示数字',nib);n('seg与dp',bits(seg,7)+' / dp='+ (1-((s.scanDots||0)>>>s.digit&1)));w('dp',1-((s.scanDots||0)>>>s.digit&1),'0请求小数点亮；仍需位选接通');n('位编号',s.digit);n('an低有效',bits(an));
 }else if(lab==='pwm'){
 result=s.phase<s.duty?1:0;led=result;w('phase',s.phase,'四位相位 0…15');w('duty',s.duty,'本例允许 0…16，16 提供严格全亮端点');w('输出',result,'phase<duty');w('理论占空比',(s.duty/16*100)+'%','整周期的理想比例');n('相位',s.phase);n('占空阈值',s.duty);n('数字输出',result);
 }else if(lab==='uart'){
 const frame=anatomyUARTFrame(s),activeByte=s.uartIndex<0?s.byte:(s.uartByte??s.byte);result=s.uartIndex<0?1:frame[s.uartIndex];led=s.byte;w('待发送字节','0x'+s.byte.toString(16).padStart(2,'0'),'忙时修改仅影响下一帧');w('当前帧字节','0x'+activeByte.toString(16).padStart(2,'0'),'起始时捕获，帧内保持');w('当前位',s.uartIndex<0?'空闲':s.uartIndex===0?'起始':s.uartIndex===9?'停止':'d'+(s.uartIndex-1),'每次点按推进一个位周期');w('TX',result,'低位先发');w('8N1帧',frame.join(' '),'1起始+8数据+1停止');w('位周期',(1e6/s.baud).toFixed(3)+' μs','波特率定义的理想周期');n('串行TX',result);n('发送电平',result);n('低位数据',(activeByte>>>Math.max(0,s.uartIndex-1))&1);
 }else if(lab==='baud'){
 const divisor=Math.round(100000000/s.baud);result=divisor;w('主时钟',100000000+' Hz','参考时钟');w('整数分频数',divisor,'示例取最近整数');w('实际波特率',(100000000/divisor).toFixed(3),'频率 / 分频数');w('相对误差',((100000000/divisor/s.baud-1)*100).toFixed(4)+'%','不保证任意目标速率恰好可整除');
 }else if(lab==='adc'){
 result=Math.min(15,Math.floor(s.pct*16/100));led=result;n('编码输出',result);n('幅值',s.pct+'%');n('数字码',bits(result));w('输入',s.pct+'%','归一化幅值，不是实体电压');w('四位码',bits(result)+' = '+result,'0…15');w('区间',result===15?'[93.75%,100%]':'['+(result*6.25)+'%,'+((result+1)*6.25)+'%)','本例理想分区');
 }else if(lab==='filter'){
 result=s.samples.reduce((a,b)=>a+b,0)>>2;led=result;w('四个样本',s.samples.join(', '),'最近一次在最前');w('扩位求和',s.samples.reduce((a,b)=>a+b,0),'四个8位无符号数需10位和');w('平均值',result,'本例启动以零填充，除4截断');
 }else if(lab==='cpu'){
 result=s.cpuStage===5?s.av+s.bv:0;led=result;w('指令','ADD x3,x1,x2','本例只有这条指令的数据跟踪');w('阶段',['准备','IF','ID','EX','MEM','WB'][s.cpuStage],'教学阶段，不声称每阶段等于一个物理周期');w('操作数',s.cpuStage>=2?s.av+' / '+s.bv:'尚未读取','从寄存器堆取得');w('ALU',s.cpuStage>=3?s.av+s.bv:'尚未计算','EX 后形成结果');w('x3',result,'只在 WB 后更新');w('PC',s.cpuStage===5?'0x00000004':'0x00000000','本例顺序执行');n('PC地址',s.cpuStage===5?4:0);n('操作数A',s.av);n('操作数B',s.bv);n('ALU写回支路',s.av+s.bv);n('写回数据',s.av+s.bv);n('写使能',s.cpuStage===5?1:0);
 }else if(lab==='hid'){
 result=s.pressed?s.key:0;led=result;w('报告',`${s.pressed?s.modifier.toString(16).padStart(2,'0'):'00'} 00 ${result.toString(16).padStart(2,'0')} 00 00 00 00 00`,'通用 Boot 键盘报告示例');w('使用码',result,'不直接等于字符 ASCII');w('应用解释',s.pressed?(s.key===4?(s.modifier?'A':'a'):s.key===5?(s.modifier?'B':'b'):s.key===40?'Enter':'Space'):'松开','本例固定少量键位，不模拟 USB 传输');
 }else if(lab==='pixelword'){
 result=s.pixelQ;led=result;w('所看原RAM地址',s.pixelAddress===null?'独立示例（未读取上级）':s.pixelAddress,'来源定位，不是本独立字的可写地址选择');w('保存RGB / 待写RGB','0x'+s.pixelQ.toString(16).padStart(3,'0')+' / 0x'+s.pixelD.toString(16).padStart(3,'0'),'候选不直接覆盖保存位');w('R / G / B',(s.pixelQ>>>8)+' / '+((s.pixelQ>>>4)&15)+' / '+(s.pixelQ&15),'每通道四位');for(const [name,value]of Object.entries({'红候选D':s.pixelD>>>8,'绿候选D':(s.pixelD>>>4)&15,'蓝候选D':s.pixelD&15,'红写使能':s.pixelWE,'绿写使能':s.pixelWE,'蓝写使能':s.pixelWE,'保存红':s.pixelQ>>>8,'保存绿':(s.pixelQ>>>4)&15,'保存蓝':s.pixelQ&15}))n(name,value);
 }else if(lab==='rastercounter'){
 const p=anatomyRasterPlan(s);result=s.rasterQ;led=result;w('保存Q',s.rasterQ+' / '+bits(s.rasterQ,10));w('终值 / 相等',s.rasterLimit+' / '+p.terminal,'只比较相等；降低终值不会立即清零');w('加一 / 回绕候选',p.increment+' / '+p.d,'十一位加一，提交低十位');w('下一有效边沿Q',p.next,'同步RESET优先CE');for(const [name,value]of Object.entries({'当前计数':s.rasterQ,'比较当前':s.rasterQ,'终值':s.rasterLimit,'十一位加一':p.increment,'终值相等':p.terminal,'低八位D':p.d&255,'高两位D':p.d>>>8,'低位CE':s.rasterEnable,'高位CE':s.rasterEnable,'低位RESET':s.rasterReset,'高位RESET':s.rasterReset,'低八位Q':s.rasterQ&255,'高两位Q':s.rasterQ>>>8}))n(name,value);
 }else if(lab==='vga'){
 const v=anatomyVGAPlan(s),o=anatomyVGAOutput(s);result=o.rgb;led=o.rgb;w('扫描坐标',v.x+','+v.y,'总计800×521，包含消隐');w('横区间 / 纵区间',v.hzone+' / '+v.vzone);w('HS / VS / ACTIVE',o.hs+' / '+o.vs+' / '+o.active,'同步低有效；消隐时RGB强制黑');w('实际RGB',o.rgb.toString(16).padStart(3,'0'),s.vgaSource==='framebuffer'?'同步RAM输出，控制同拍保存':'纯色组合源');w('输出坐标 / 有效',o.x+','+o.y+' / '+o.valid,'帧缓冲模式在像素边沿保存读值与HS/VS/ACTIVE');w('像素操作计数',s.ticks,'批量推进只记录终点，不生成虚构的中间观察');w('模式','640×480 / 25 MHz','Digilent手册示例：800×521，约59.98Hz；不是所有VGA模式');n('像素数据',v.rgb);n('坐标→像素',(v.y<<10)|v.x);
 }else if(lab==='cache'||lab==='tag'){
 let addr=s.addr,index=(addr>>1)&3,tag=addr>>3,entry=s.cache[index],hit=entry.valid&&entry.tag===tag;result=hit?1:0;led=result;w('地址分解',`tag=${tag}, index=${index}, offset=${addr&1}`,'本例4行，每行2字节，只演示标签判断');w('存储tag / valid',entry.tag+' / '+entry.valid,'初始化 valid=0');w('HIT',result,'标签相等且有效才命中');n('命中',result);n('有效',entry.valid);n('相等',entry.tag===tag?1:0);
 }else if(lab==='compare'){result=s.av===s.bv?1:0;led=result;for(let i=0;i<4;i++){n('A'+i,(s.av>>>i)&1);n('B'+i,(s.bv>>>i)&1);n('差异'+i,((s.av^s.bv)>>>i)&1)}n('低两位不同',+!!((s.av^s.bv)&3));n('高两位不同',+!!((s.av^s.bv)&12));n('相等输出',result);n('输入',s.av+'/'+s.bv);n('差异位',s.av^s.bv);n('至少一位不同',s.av===s.bv?0:1);w('A XOR B',bits(s.av^s.bv),'哪一位不同');w('归约 OR',s.av===s.bv?0:1,'任一位不同即为1');w('EQ',result,'图中末级反相后的相等信号');}else if(lab==='regfile'){result=s.r0===0?0:s.reg[s.r0];led=result;w('缩小模型','8×8 位；x0 固定读0','用来说明端口与零寄存器，不宣称是完整ISA寄存器堆');w('读端口0',s.r0+' → '+result,'组合读');w('读端口1',s.r1+' → '+(s.r1===0?0:s.reg[s.r1]),'独立组合读');w('写端口',s.waddr+' ← '+s.data+'，WE='+s.we,'有效边沿且目的不为0时写入');}else if(lab==='decoder'){result=1<<(s.av&3);led=result;w('地址',bits(s.av&3,2),'两位');w('独热输出',bits(result),'恰有一位为1');for(let i=0;i<4;i++)n('D'+i,((s.av&3)===i)?1:0);
 }else if(lab==='shifter'){result=(s.av<<(s.bv&3))&15;led=result;w('输入',bits(s.av),'四位');w('移位量',s.bv&3,'两级：1位与2位');w('输出',bits(result),'左移补0，丢弃移出高位');
 }else if(lab==='immediate'){let v=s.av&15;result=v&8?(v|0xf0):v;led=result;w('原四位',bits(v),'最高位为符号');w('符号扩展到8位',bits(result,8),'复制最高符号位');w('按补码解释',v&8?v-16:v,'数值保持');
 }else if(lab==='gpio'){result=s.we?s.data:'Z';led=s.we?s.data:0;w('输出数据',s.data,'保持在输出寄存器');w('输出使能',s.we,'关闭时释放驱动');w('引脚驱动',result,'Z 表示未驱动，不是布尔0；实际采样受外部电路影响');}
 if(result!==null&&lab!=='board'&&lab!=='scan'&&Number.isInteger(result)){digits=[AN_SEG[result&15],AN_SEG[(result>>4)&15],0,0]}
 return {nets,watch,led,digits,result,power:lab==='power'?!!s.powered:true,done:lab==='power'?!!(s.powered&&s.configured):true};
}
function anatomyAdvance(id,s,action='tick'){
 const lab=ANATOMY[id]?.lab||id;
 if(action==='low'&&lab==='dff'){s.clk=0;s.master=s.a;return}
 if(action==='reset'){Object.assign(s,anatomyState());return}
 if(lab==='cpu'){s.cpuStage=Math.min(5,s.cpuStage+1);return}
 if(lab==='uart'){if(s.uartIndex<0)s.uartByte=s.byte;s.uartIndex=s.uartIndex>=9?-1:s.uartIndex+1;return}
 if(lab==='scan'){s.scanPhase=(s.scanPhase+1)%3;if(s.scanPhase===0)s.digit=(s.digit+1)%4;s.ticks++;return}
 if(lab==='pwm'){s.phase=(s.phase+1)&15;s.ticks++;return}
 if(lab==='pixelword'){const before=s.pixelQ;if(s.pixelWE)s.pixelQ=s.pixelD&4095;s.pixelLast={before,after:s.pixelQ,input:s.pixelD,enable:s.pixelWE,edge:s.ticks+1};s.ticks++;return}
 if(lab==='rastercounter'){if(action==='load'){s.rasterQ=s.rasterStart;s.rasterLast=null;s.ticks=0;return}const p=anatomyRasterPlan(s);s.rasterLast={before:s.rasterQ,d:p.d,after:p.next,enable:s.rasterEnable,reset:s.rasterReset,edge:s.ticks+1};s.rasterQ=p.next;s.ticks++;return}
 if(lab==='vga'){anatomyVGAAdvance(s);return}
 if(lab==='cache'||lab==='tag'){let index=(s.addr>>1)&3;s.cache[index]={valid:1,tag:s.addr>>3,data:s.data};return}
 if(lab==='sramcell'){if(s.enable)s.q=s.a;s.ticks++;return}
 if(lab==='regfile'){if(s.we&&s.waddr!==0)s.reg[s.waddr]=s.data;s.reg[0]=0;s.ticks++;return}
 if(lab==='ram'){s.readQ=s.mem[s.addr];if(s.we)s.mem[s.addr]=s.data;s.ticks++;return}
 if(lab==='filter'){const before=s.samples.slice(),inputs=[s.data,...before.slice(0,3)],after=s.enable?inputs:before;s.filterLast={edge:s.ticks+1,data:s.data,valid:s.enable,before,inputs:inputs.slice(),after:after.slice()};s.samples=after.slice();s.ticks++;return}
 if(lab==='dff'){if(s.clk===0){s.master=s.a;s.q=s.master;s.clk=1;s.ticks++}return}
 s.ticks++;if(lab==='dff')s.q=s.a;
 else if(lab==='register')s.q=s.reset?0:s.enable?s.av:s.q;
 else if(lab==='counter')s.q=s.reset?0:s.enable?(s.q+1)&15:s.q;
 else if(lab==='shiftreg')s.shift=((s.shift<<1)|s.a)&15;
 else if(lab==='dff'){n('D',s.a);n('Q',s.q);n('CLK',s.clk);n('~CLK',1-s.clk);n('时钟反相输入',s.clk);n('主状态',s.clk?s.master:s.a);n('从时钟',s.clk);n('反相时钟',1-s.clk);w('CLK',s.clk,'低电平时主级透明；高电平时从级透明');w('主级状态',s.clk?s.master:s.a,'这是主从教学实现，不是厂商 FF 的制造网表')};if(lab==='synchronizer'){s.s2=s.s1;s.s1=s.a}
 else if(lab==='reset'){if(s.a){s.release0=1;s.release1=1}else{let old=s.release0;s.release0=0;s.release1=old}}
 else if(lab==='edge'){s.previous=s.stable;s.stable=s.a}
 else if(lab==='debounce'){const next=anatomyDebouncePreview(s);s.candidate=next.candidate;s.consecutive=next.count;s.stable=next.stable}
 else if(lab==='fsm')s.mode=(s.mode+1)%3;
}
// Resolve gate-level wires from the actual declared topology, including intermediate nets.
function anatomyCircuitSignals(blueprint,s){
 const gateTypes=['and','or','xor','nand','nor','not','inverter','mux'];
 const hasMOS=blueprint.parts.some(p=>p.type==='pmos')&&blueprint.parts.some(p=>p.type==='nmos');
 if(hasMOS&&['nand','nor','cmos','not'].includes(blueprint.lab)){
  let parent=new Map(),root=x=>{if(!parent.has(x))parent.set(x,x);let p=parent.get(x);if(p!==x)parent.set(x,root(p));return parent.get(x)},join=(a,b)=>parent.set(root(a),root(b));
  blueprint.nets.forEach(n=>join(n.from,n.to));
  const sources={'A.o':s.a,'B.o':s.b,'V.o':1,'GND.i':0};
  const level=pin=>{let vals=Object.entries(sources).filter(([key])=>root(key)===root(pin)).map(([,v])=>v);return vals.length?vals.every(v=>v===vals[0])?vals[0]:'X':undefined};
  for(const p of blueprint.parts.filter(p=>['pmos','nmos'].includes(p.type))){let gate=level(p.id+'.g');if(gate!==undefined&&((p.type==='pmos'&&gate===0)||(p.type==='nmos'&&gate===1)))join(p.id+'.s',p.id+'.d')}
  return Object.fromEntries(blueprint.nets.map(n=>[n.name,level(n.from)??'Z']));
 }
 if(!blueprint.parts.some(p=>gateTypes.includes(p.type))||!['and','or','xor','mux','fulladder','halfadder','decoder'].includes(blueprint.lab))return {};
 const pins={'A.o':s.a,'B.o':s.b,'C.o':s.cin,'S.o':s.cin,'A0.o':s.av&1,'A1.o':(s.av>>1)&1};
 for(let round=0;round<blueprint.parts.length+2;round++){
  for(const n of blueprint.nets)if(pins[n.from]!==undefined)pins[n.to]=pins[n.from];
  for(const p of blueprint.parts){let a=pins[p.id+'.a'],b=pins[p.id+'.b'];if(['not','inverter'].includes(p.type)&&a!==undefined)pins[p.id+'.o']=1-a;
   else if(a!==undefined&&b!==undefined){if(p.type==='and')pins[p.id+'.o']=a&b;if(p.type==='or')pins[p.id+'.o']=a|b;if(p.type==='xor')pins[p.id+'.o']=a^b;if(p.type==='nand')pins[p.id+'.o']=1-(a&b);if(p.type==='nor')pins[p.id+'.o']=1-(a|b)}
  }
 }
 return Object.fromEntries(blueprint.nets.filter(n=>pins[n.from]!==undefined).map(n=>[n.name,pins[n.from]]));
}
const anatomyEvaluateBase=anatomyEvaluate;
anatomyEvaluate=function(id,s){const e=anatomyEvaluateBase(id,s);Object.assign(e.nets,anatomyCircuitSignals(ANATOMY[id],s));e.switches={};for(const p of ANATOMY[id].parts.filter(p=>['nmos','pmos'].includes(p.type))){let n=ANATOMY[id].nets.find(n=>n.to===p.id+'.g');let gate=n?e.nets[n.name]:undefined;if(gate===0||gate===1)e.switches[p.id]=p.type==='nmos'?gate:1-gate}return e};

function anatomyUARTFrame(s){const byte=s.uartIndex<0?s.byte:(s.uartByte??s.byte);return [0,...Array.from({length:8},(_,i)=>(byte>>>i)&1),1]}

function anatomyTimingPlan(id,s){
 const visible=id==='visiblearea',vertical=id==='vsync',value=vertical?s.timingY:s.timingX,low=vertical?490:656,high=vertical?492:752;
 if(visible){const x=+(s.timingX<640),y=+(s.timingY<480);return {result:x&y,nets:{'横坐标':s.timingX,'纵坐标':s.timingY,'横边界':640,'纵边界':480,'横可见':x,'纵可见':y,'显示有效':x&y},watch:[{name:'横条件 X < 640',value:x,why:'640本身已在可见区之外'},{name:'纵条件 Y < 480',value:y,why:'480本身已在可见区之外'},{name:'ACTIVE',value:x&y,why:'两个条件同时满足；不是输出流水VALID'}]};}
 const a=+(value<low),b=+(value<high),result=a|(1-b);
 return {result,value,low,high,nets:{'坐标→下界比较':value,'坐标→上界比较':value,'下界':low,'上界':high,'小于下界':a,'小于上界':b,'不小于上界':1-b,'同步输出':result},watch:[{name:'小于下界',value:a,why:value+' < '+low},{name:'小于上界',value:b,why:value+' < '+high},{name:'不小于上界',value:1-b,why:'反相后得到大于等于上界'},{name:vertical?'VS':'HS',value:result,why:'区间['+low+','+high+')内为0，区间外为1'}]};
}

function anatomyCompareBitPlan(s){
 const a=s.cmpBitA,b=s.cmpBitB,e=s.cmpPrefixEq,l=s.cmpPrefixLt,small=(1-a)&b,same=1-(a^b),eq=e&same,lt=l|(e&small);
 return {eq,lt,nets:{'A反相输入':a,'A异或输入':a,'B小于输入':b,'B异或输入':b,'A反相':1-a,'当前不同':a^b,'当前相等':same,'前缀相等→保持':e,'前缀相等→判定':e,'当前小于':small,'已有小于':l,'新判小于':e&small,'相等输出':eq,'小于输出':lt},watch:[{name:'EQin / LTin',value:e+' / '+l,why:e&&l?'手动设置的非法比较前缀，只演示门真值':'合法前缀：仍相等、已小于或已大于'},{name:'当前相等 / 当前小于',value:same+' / '+small,why:'仅在EQin为1时允许改变比较结论'},{name:'EQout / LTout',value:eq+' / '+lt,why:'组合输出，没有保存边沿'}]};
}
function anatomyCompare10Plan(s){
 const a=s.cmp10A,b=s.cmp10B,rows=[],nets={};let eq=1,lt=0,first=null;
 for(let bit=9;bit>=0;bit--){const av=(a>>>bit)&1,bv=(b>>>bit)&1,eqIn=eq,ltIn=lt;if(first===null&&av!==bv)first=bit;eq=eqIn&+(av===bv);lt=ltIn|(eqIn&(1-av)&bv);rows.push({bit,a:av,b:bv,eqIn,ltIn,eq,lt});nets['A'+bit]=av;nets['B'+bit]=bv;nets['EQ进入'+bit]=eqIn;nets['LT进入'+bit]=ltIn;}
 nets['最终相等']=eq;nets['最终小于']=lt;
 return {eq,lt,first,rows,nets,watch:[{name:'十位A / B',value:a+' / '+b,why:'0…1023无符号，不按补码解释'},{name:'最高不同位',value:first===null?'没有，所有位相等':'bit'+first,why:'这一位决定大小；更低位不能推翻'},{name:'最终EQ / LT',value:eq+' / '+lt,why:eq?'两个数相等':lt?'A小于B':'A大于B'}]};
}
