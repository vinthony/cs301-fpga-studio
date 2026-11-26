'use strict';
// This teaching implementation chooses asynchronous reads, synchronous writes,
// optional combinational bypass, and a synchronous clear. ISA does not mandate these circuits.
plate('regfile32','32×32 寄存器堆 · 两读一写与 x0',[
 P('RA',null,'port',0,0,'读地址 A · 5 bit'),P('RB',null,'port',0,0,'读地址 B · 5 bit'),P('WA',null,'port',0,0,'写地址 · 5 bit'),P('WD',null,'port',0,0,'待写数据 · 32 bit'),P('WE',null,'port',0,0,'写使能'),P('CLK',null,'port',0,0,'教学时钟沿'),P('RST',null,'port',0,0,'同步清零请求'),P('BYP',null,'port',0,0,'同址前递开关'),P('BANK',null,'rf32bank',0,0,'32 个寄存器 · 每行 32 位'),P('QA',null,'port',0,0,'读出 A · 32 bit'),P('QB',null,'port',0,0,'读出 B · 32 bit')
],[N('读地址 A','RA.o','BANK.ra',5,'control'),N('读地址 B','RB.o','BANK.rb',5,'control'),N('写地址','WA.o','BANK.wa',5,'control'),N('待写数据','WD.o','BANK.wd',32),N('写使能','WE.o','BANK.we',1,'control'),N('教学时钟','CLK.o','BANK.clk',1,'clock'),N('同步清零','RST.o','BANK.rst',1,'control'),N('同址前递','BYP.o','BANK.bypass',1,'control'),N('读出 A','BANK.qa','QA.i',32),N('读出 B','BANK.qb','QB.i',32)],
 [S('读是选择，不是写入','A、B 两个地址分别选择一行；不用时钟即可读出当前值。点击阵列某行可选择 A，按住 Shift 点击可选择 B。',['RA','RB','BANK','QA','QB'],['读地址 A','读地址 B','读出 A','读出 B']),S('写入需要有效边沿','修改待写数据不会修改阵列。只有写使能有效、地址非 x0 且发生边沿时，才更新一行。',['WA','WD','WE','CLK','BANK'],['写地址','待写数据','写使能','教学时钟']),S('区分旁路与保存','打开同址前递后，读口可以提前看到待写值，但格子仍显示已保存内容。x0 不允许写入，也不允许旁路非零值。',['BYP','BANK','QA','QB'],['同址前递','读出 A','读出 B'])],
 {lab:'rf32',layer:'处理器 · 完整 32×32 规格',sources:['riscv','seq'],boundary:'本例：组合读、上升沿写、可选同址旁路、同步清零。教学初始值全零；这些电路与复位选择不由 RISC-V ISA 统一规定。不是完整 CPU，也不估算资源和频率。',question:'为什么读口已经显示新值，而阵列格子还是旧值？先检查是否打开了同址前递。'});
anExp('regfile32',[anNum('rfRA','读地址 A（x0…x31）',0,31),anNum('rfRB','读地址 B（x0…x31）',0,31),anNum('rfWA','写地址（x0…x31）',0,31),{...anNum('rfWD','待写值（十进制 / 0x / 0b）',0,4294967295),type:'word'},anBit('rfWE','写使能'),anBit('rfBypass','同址前递'),anBit('rfReset','同步清零请求')],[['tick','执行一个上升沿 ↑']],'蓝：读 A；紫：读 B；金色描边：写地址。格子只显示已保存位，前递不修改阵列。');
const anBeforeRF32State=anatomyState;
anatomyState=function(){return {...anBeforeRF32State(),rfRegs:Array(32).fill(0),rfRA:1,rfRB:2,rfWA:1,rfWD:0x12345678,rfWE:1,rfBypass:0,rfReset:0,rfLastWrite:-1}};
function anatomyRF32Read(s,address){return address===0?0:s.rfBypass&&s.rfWE&&!s.rfReset&&s.rfWA===address?s.rfWD>>>0:s.rfRegs[address]>>>0}
const anBeforeRF32Evaluate=anatomyEvaluate;
anatomyEvaluate=function(id,s){const e=anBeforeRF32Evaluate(id,s);if(id!=='regfile32')return e;
 const qa=anatomyRF32Read(s,s.rfRA),qb=anatomyRF32Read(s,s.rfRB),rawA=s.rfRA===0?0:s.rfRegs[s.rfRA]>>>0,rawB=s.rfRB===0?0:s.rfRegs[s.rfRB]>>>0,forwardA=!!(s.rfRA&&s.rfBypass&&s.rfWE&&!s.rfReset&&s.rfWA===s.rfRA),forwardB=!!(s.rfRB&&s.rfBypass&&s.rfWE&&!s.rfReset&&s.rfWA===s.rfRB),hex=v=>'0x'+v.toString(16).toUpperCase().padStart(8,'0');
 e.result=qa;e.led=qa&65535;e.partValues={RA:s.rfRA,RB:s.rfRB,WA:s.rfWA,WD:s.rfWD>>>0,WE:s.rfWE,CLK:0,RST:s.rfReset,BYP:s.rfBypass,BANK:qa,QA:qa,QB:qb};e.nets={'读地址 A':s.rfRA,'读地址 B':s.rfRB,'写地址':s.rfWA,'待写数据':s.rfWD>>>0,'写使能':s.rfWE,'教学时钟':0,'同步清零':s.rfReset,'同址前递':s.rfBypass,'读出 A':qa,'读出 B':qb};e.rf32={rawA,rawB,forwardA,forwardB};
 e.watch=[{name:'读端口 A：x'+s.rfRA,value:hex(qa),why:(forwardA?'来自待写数据旁路；保存值仍为 '+hex(rawA):'来自已保存阵列')+'；补码 '+anatomySigned32(qa)},{name:'读端口 B：x'+s.rfRB,value:hex(qb),why:(forwardB?'来自待写数据旁路；保存值仍为 '+hex(rawB):'来自已保存阵列')+'；补码 '+anatomySigned32(qb)},{name:'待写 x'+s.rfWA,value:hex(s.rfWD>>>0),why:s.rfReset?'清零请求只在下一个边沿生效，优先于写入':!s.rfWE?'写使能关闭，边沿也不会写入':s.rfWA===0?'x0 永远为零，本次写入会被丢弃':'等待下一个上升沿；修改输入还不是写入'},{name:'最近一次边沿',value:s.rfLastWrite===-2?'同步清零':s.rfLastWrite<0?'未写入':'保存到 x'+s.rfLastWrite,why:'只描述最近一次边沿；不是当前写请求已经执行'},{name:'有效边沿次数',value:String(s.ticks),why:'单步按钮每次执行一个 0→1→0 教学脉冲，稳态 CLK 回到 0，不表示实体时钟频率'},{name:'x0',value:'0x00000000',why:'读取恒零，写入和旁路均不改变它'}];return e;
};
const anBeforeRF32Advance=anatomyAdvance;
anatomyAdvance=function(id,s,action='tick'){if(id!=='regfile32'||action==='reset')return anBeforeRF32Advance(id,s,action);if(action!=='tick')return;s.ticks++;s.rfLastWrite=-1;if(s.rfReset){s.rfRegs.fill(0);s.rfLastWrite=-2}else if(s.rfWE&&s.rfWA!==0){s.rfRegs[s.rfWA]=s.rfWD>>>0;s.rfLastWrite=s.rfWA}s.rfRegs[0]=0};
AN_CONTEXT_ASSOCIATIONS.regfile32='cpu';
const anBeforeRF32Descriptor=anatomyOutputDescriptor;
anatomyOutputDescriptor=function(b){return b.id==='regfile32'?{name:'读端口 A[31:0]',width:32}:anBeforeRF32Descriptor(b)};
const anBeforeRF32Explain=anatomyExplainObservation;
anatomyExplainObservation=function(b,previous,current){const e=anBeforeRF32Explain(b,previous,current);if(b.id!=='regfile32'||!previous)return e;const s=current.state,info=current.evaluation.rf32;
 e.title=e.diff.edge?s.rfReset?'边沿执行同步清零':!s.rfWE?'写使能关闭：阵列保持':s.rfWA===0?'x0 丢弃写入':'边沿保存到 x'+s.rfWA:info.forwardA||info.forwardB?'读口走前递，阵列尚未写入':'改变读口选择或待写条件';
 e.body=e.diff.edge?s.rfReset?'本教学实现的同步清零优先于写入；32 行已清零。':!s.rfWE?'时钟推进了一次，但写使能为 0。已保存内容保持。':s.rfWA===0?'x0 是硬连零寄存器；无论待写值和前递开关如何，都读出 0。':'只有选中的非零地址更新。两个读端口独立选择当前行，写入后的值可立即被组合读口看到。':'格子显示保存内容；A、B 输出独立选择。打开同址前递时，匹配的非零读口显示待写值，这不等于已经保存。';return e;
};
ANATOMY_ROUTES.push({name:'读到新值，就是写进去了吗',key:'regfile-writeback',prerequisite:'认识寄存器读口、写请求与保存边沿',goal:'区分前递读口、待写值与阵列已保存值',ids:['regfile32','register','dff','latch'],hints:['完整 32×32 阵列：分开看读口、待写值与前递','切到四位缩小示例，观察一行如何由保存单元构成','再观察一位的有效上升沿','比较电平透明与边沿采样；这些是原理示例而非厂商网表']});
