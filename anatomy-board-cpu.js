'use strict';
// This is a second presentation of one session CPU, not a copy of its registers.
function anatomyBindCPUBoardInputs(s){
 if(!Object.getOwnPropertyDescriptor(s,'sw')?.get)Object.defineProperty(s,'sw',{enumerable:true,configurable:true,get(){return this.cpuSwitches&65535},set(value){this.cpuSwitches=Number(value)&65535}});
 if(!Object.getOwnPropertyDescriptor(s,'btnMask')?.get)Object.defineProperty(s,'btnMask',{enumerable:true,configurable:true,get(){return this.cpuButtons&31},set(value){this.cpuButtons=Number(value)&31}});
 return s;
}
const AN_BOARD_CPU={...ANATOMY.board,cpuLinked:true,title:'GBU-CS301 · 同一CPU的整板输入输出',layer:'整板 ↔ 同一程序状态',boundary:'本解剖会话的整板与CPU32共用程序、PC、寄存器、RAM及I/O；开关/按键是CPU输入，LED/显示由程序写入后保存。功能模型，不是实物引脚扫描或整机RTL。其他接口仍可进入独立原理实验。',
 parts:ANATOMY.board.parts.map(p=>p.id==='FPGA'?{...p,ref:'cpu32',label:'FPGA 内当前的 CPU 逻辑',tip:'进入同一CPU数据通路，保留程序与全部执行状态'}:p),
 nets:[N('CPU教学脉冲','OSC.o','FPGA.clk',1,'clock','单步执行一个教学脉冲；不表示100MHz实时运行'),N('SW[15:0]','SW.o','FPGA.sw',16),N('BTN[4:0]','BTN.o','FPGA.btn',5),N('LED[15:0]','FPGA.led','LED.i',16),N('显示保存字','FPGA.display','SEG.i',32)],
 steps:[S('输入送入同一CPU','板上开关与按键和CPU页的输入是同一份；改变输入不会直接覆盖程序已保存的输出。',['SW','BTN','FPGA'],['SW[15:0]','BTN[4:0]']),S('由程序决定输出','给一个边沿或连续运行，程序读I/O并写入LED/显示寄存器后，整板才更新输出。',['FPGA','LED','SEG'],['LED[15:0]','显示保存字']),S('进入内部继续运行','双击FPGA进入同一个CPU；PC、寄存器、RAM和板输出保持，不重新装载程序。切换视图会暂停自动调度。',['FPGA']),S('分清功能与物理接口','这里直接解码显示保存字低16位；不伪装成真实数码管扫描。时钟按钮是教学执行，不是100MHz实体性能。',['OSC','SEG'],['CPU教学脉冲'])]};
const anBeforeBoardCPUState=anatomyState;
anatomyState=function(){return {...anBeforeBoardCPUState(),boardMode:'adder'}};
const anBeforeBoardCPUEvaluate=anatomyEvaluate;
anatomyEvaluate=function(id,s){if(id!=='board'||s.boardMode!=='cpu32')return anBeforeBoardCPUEvaluate(id,s);const e=anBeforeBoardCPUEvaluate('cpu32',s),c=s.cpu32;e.result=c.led;e.nets={'CPU教学脉冲':0,'SW[15:0]':s.cpuSwitches&65535,'BTN[4:0]':s.cpuButtons&31,'LED[15:0]':c.led,'显示保存字':c.display};e.partValues={SW:s.cpuSwitches&65535,BTN:s.cpuButtons&31,LED:c.led,SEG:c.display,FPGA:c.pc,OSC:0};e.watch.unshift({name:'整板信号来源',value:'CPU32 · '+c.programName,why:'与CPU页共享同一状态；切换来源不执行程序，也不清空CPU'},{name:'开关输入 / 保存输出',value:'SW=0x'+(s.cpuSwitches&65535).toString(16).padStart(4,'0')+'；LED=0x'+c.led.toString(16).padStart(4,'0'),why:'两者可以不同；只有程序写LED寄存器才改变输出'});return e};
const anBeforeBoardCPUAdvance=anatomyAdvance;
anatomyAdvance=function(id,s,action='tick'){if(id!=='board'||s.boardMode!=='cpu32')return anBeforeBoardCPUAdvance(id,s,action);const result=anBeforeBoardCPUAdvance('cpu32',s,action);s.boardMode='cpu32';return result};
const anBeforeBoardCPUDescriptor=anatomyOutputDescriptor;
anatomyOutputDescriptor=function(b){return b.id==='board'?{name:b.cpuLinked?'LED[15:0] 程序保存值':'LED[15:0] 组合结果',width:16}:anBeforeBoardCPUDescriptor(b)};
const anBeforeBoardCPUColumnWidth=anatomyObservationColumnWidth;
anatomyObservationColumnWidth=function(b){return b.cpuLinked?88:anBeforeBoardCPUColumnWidth(b)};
const anBeforeBoardCPUExplain=anatomyExplainObservation;
anatomyExplainObservation=function(b,p,c){if(b.id!=='board'||c.state.boardMode!=='cpu32')return anBeforeBoardCPUExplain(b,p,c);if(!p)return {title:'输入是当前开关，输出是程序保存值',body:'先装载开关相加示例，再给CPU边沿；改变SW不会替程序写LED。也可以双击FPGA进入同一CPU继续观察。',diff:anatomyObservationDiff(b,p,c)};const explanation=anBeforeBoardCPUExplain(ANATOMY.cpu32,p,c);explanation.diff=anatomyObservationDiff(b,p,c);return explanation};
