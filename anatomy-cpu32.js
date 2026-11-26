'use strict';
const AN_CPU32_DEMOS=[
 {name:'循环求和：5+4+3+2+1',source:`addi x1, x0, 5
addi x3, x0, 0
loop: add x3, x3, x1
addi x1, x1, -1
bne x1, x0, loop
sw x3, 0(x0)
lw x4, 0(x0)
ebreak`},
 {name:'板上输入：两组开关相加',source:`li x5, 0xffff0000
lw x1, 0(x5)
andi x2, x1, 15
srli x3, x1, 4
andi x3, x3, 15
add x4, x2, x3
sw x4, 4(x5)
sw x4, 8(x5)
ebreak`},
 {name:'字节读取：符号扩展与零扩展',source:`li x1, -128
sb x1, 0(x0)
lb x2, 0(x0)
lbu x3, 0(x0)
li x1, 0x8001
sh x1, 2(x0)
lh x4, 2(x0)
lhu x6, 2(x0)
ebreak`},
 {name:'调用与返回：JAL / JALR',source:`addi x3, x0, 5
jal x1, twice
addi x3, x3, 1
ebreak
twice: add x3, x3, x3
jalr x0, 0(x1)`},
 {name:'精确停止：不对齐访存',source:`addi x1, x0, 7
sw x1, 2(x0)
addi x3, x0, 99
ebreak`}
];
function anatomyAssembleCPU32(source){
 const regNames={zero:0,ra:1,sp:2,gp:3,tp:4,t0:5,t1:6,t2:7,s0:8,fp:8,s1:9,a0:10,a1:11,a2:12,a3:13,a4:14,a5:15,a6:16,a7:17,s2:18,s3:19,s4:20,s5:21,s6:22,s7:23,s8:24,s9:25,s10:26,s11:27,t3:28,t4:29,t5:30,t6:31};
 const fail=(line,message)=>{throw Error('第 '+line+' 行：'+message)},num=(s,line)=>{if(!/^[+-]?(?:0x[0-9a-f]+|0b[01]+|\d+)$/i.test(s))fail(line,'需要整数常量：'+s);const sign=s[0]==='-'?-1:1,v=Number(s.replace(/^[+-]/,''))*sign;if(!Number.isSafeInteger(v))fail(line,'整数超出范围');return v},reg=(s,line)=>{if(/^x(?:[0-9]|[12][0-9]|3[01])$/i.test(s))return Number(s.slice(1));if(Object.hasOwn(regNames,s))return regNames[s];fail(line,'未知寄存器 '+s)},range=(v,min,max,line,what)=>{if(v<min||v>max)fail(line,what+' 超出 '+min+'…'+max);return v},u=v=>v>>>0;
 const lines=[],labels=Object.create(null),words=[],sourceLines=[];let pc=0;
 String(source).split(/\r?\n/).forEach((raw,i)=>{let text=raw.replace(/(?:#|\/\/|;).*$/,'').trim();if(!text)return;let m;while((m=text.match(/^([A-Za-z_]\w*):\s*/))){if(Object.hasOwn(labels,m[1]))fail(i+1,'重复标签 '+m[1]);labels[m[1]]=pc;text=text.slice(m[0].length)}if(!text)return;const tokens=text.replace(/[,()]/g,' ').trim().split(/\s+/),op=tokens.shift().toLowerCase();let count=1;if(op==='li'){if(tokens.length!==2)fail(i+1,'li 需要 rd 和常量');const n=range(num(tokens[1],i+1),-2147483648,4294967295,i+1,'32位常量'),signed=n>2147483647?n-4294967296:n;count=signed>=-2048&&signed<=2047?1:2}lines.push({line:i+1,text,op,args:tokens,pc,count});pc+=count*4;if(pc>1024)fail(i+1,'最多256条展开后的指令')});
 const I=(op,f3,rd,rs1,imm)=>u(((imm&4095)<<20)|(rs1<<15)|(f3<<12)|(rd<<7)|op),R=(f7,f3,rd,a,b)=>u((f7<<25)|(b<<20)|(a<<15)|(f3<<12)|(rd<<7)|0x33),S=(f3,a,b,imm)=>u(((imm&0xfe0)<<20)|(b<<20)|(a<<15)|(f3<<12)|((imm&31)<<7)|0x23),B=(f3,a,b,imm)=>u(((imm&0x1000)<<19)|((imm&0x7e0)<<20)|(b<<20)|(a<<15)|(f3<<12)|((imm&0x1e)<<7)|((imm&0x800)>>>4)|0x63),J=(rd,imm)=>u(((imm&0x100000)<<11)|((imm&0x7fe)<<20)|((imm&0x800)<<9)|(imm&0xff000)|(rd<<7)|0x6f);
 const rOps={add:[0,0],sub:[32,0],sll:[0,1],slt:[0,2],sltu:[0,3],xor:[0,4],srl:[0,5],sra:[32,5],or:[0,6],and:[0,7]},iOps={addi:0,slti:2,sltiu:3,xori:4,ori:6,andi:7},loads={lb:0,lh:1,lw:2,lbu:4,lhu:5},stores={sb:0,sh:1,sw:2},branches={beq:0,bne:1,blt:4,bge:5,bltu:6,bgeu:7};
 for(const item of lines){let {op,args:a,line,pc:at}=item,out=[];const arity=n=>{if(a.length!==n)fail(line,op+' 需要 '+n+' 个参数')},rn=x=>reg(x,line),nn=x=>num(x,line),signed12=x=>range(nn(x),-2048,2047,line,'12位立即数'),offset=(x,min,max)=>{const n=Object.hasOwn(labels,x)?labels[x]-at:nn(x);range(n,min,max,line,'相对字节偏移');if(n%2)fail(line,'分支/跳转偏移必须为偶数');return n};
  if(op==='nop'){arity(0);out=[I(0x13,0,0,0,0)]}
  else if(op==='mv'){arity(2);out=[I(0x13,0,rn(a[0]),rn(a[1]),0)]}
  else if(op==='ret'){arity(0);out=[I(0x67,0,0,1,0)]}
  else if(op==='j'){arity(1);out=[J(0,offset(a[0],-1048576,1048574))]}
  else if(op==='li'){arity(2);const rd=rn(a[0]),n=range(nn(a[1]),-2147483648,4294967295,line,'32位常量'),v=n>2147483647?n-4294967296:n;if(v>=-2048&&v<=2047)out=[I(0x13,0,rd,0,v)];else{const hi=Math.floor((v+2048)/4096),lo=v-hi*4096;out=[u(((hi&0xfffff)<<12)|(rd<<7)|0x37),I(0x13,0,rd,rd,lo)]}}
  else if(Object.hasOwn(rOps,op)){arity(3);const [f7,f3]=rOps[op];out=[R(f7,f3,rn(a[0]),rn(a[1]),rn(a[2]))]}
  else if(Object.hasOwn(iOps,op)){arity(3);out=[I(0x13,iOps[op],rn(a[0]),rn(a[1]),signed12(a[2]))]}
  else if(['slli','srli','srai'].includes(op)){arity(3);const sh=range(nn(a[2]),0,31,line,'移位量');out=[I(0x13,op==='slli'?1:5,rn(a[0]),rn(a[1]),sh+(op==='srai'?1024:0))]}
  else if(Object.hasOwn(loads,op)||op==='jalr'){arity(3);out=[I(op==='jalr'?0x67:3,op==='jalr'?0:loads[op],rn(a[0]),rn(a[2]),signed12(a[1]))]}
  else if(Object.hasOwn(stores,op)){arity(3);out=[S(stores[op],rn(a[2]),rn(a[0]),signed12(a[1]))]}
  else if(Object.hasOwn(branches,op)){arity(3);out=[B(branches[op],rn(a[0]),rn(a[1]),offset(a[2],-4096,4094))]}
  else if(op==='jal'){arity(2);out=[J(rn(a[0]),offset(a[1],-1048576,1048574))]}
  else if(['lui','auipc'].includes(op)){arity(2);const imm=range(nn(a[1]),-524288,1048575,line,'20位高立即数');out=[u(((imm&0xfffff)<<12)|(rn(a[0])<<7)|(op==='lui'?0x37:0x17))]}
  else if(op==='ecall'||op==='ebreak'){arity(0);out=[op==='ecall'?0x73:0x100073]}
  else if(op==='fence'){if(a.length===0)out=[0x0ff0000f];else{arity(2);const mask=x=>{if(!/^[iorw]+$/.test(x))fail(line,'fence 集合仅支持 i/o/r/w');return [...new Set(x)].reduce((v,c)=>v|({i:8,o:4,r:2,w:1})[c],0)};out=[(mask(a[0])<<24)|(mask(a[1])<<20)|0x0f]}}
  else if(op==='.word'){arity(1);out=[u(range(nn(a[0]),-2147483648,4294967295,line,'32位编码'))]}
  else fail(line,'未知指令/伪指令 '+op+'；使用基本 RV32I 或 .word');
  for(const word of out){words.push(word);sourceLines.push({line,text:item.text})}
 }
 if(!words.length)throw Error('程序为空');return {words,sourceLines,sourceText:String(source),labels};
}
function anatomyCPU32State(program=anatomyAssembleCPU32(AN_CPU32_DEMOS[0].source),name=AN_CPU32_DEMOS[0].name){return {pc:0,regs:Array(32).fill(0),memory:Array(256).fill(0),program:program.words.slice(),sourceLines:program.sourceLines.map(x=>({...x})),sourceText:program.sourceText,programName:name,retired:0,halted:false,fault:null,last:null,led:0,display:0}}
function anatomyCPU32Preview(s){
 const c=s.cpu32,pc=c.pc>>>0,word=pc%4===0&&pc/4<c.program.length?c.program[pc/4]>>>0:0,d=anatomyDecodeRV32(word),fault=(kind,value,message)=>({kind,pc,value:value>>>0,message});
 let error=null;if(pc%4)error=fault('INSTRUCTION_ADDRESS_MISALIGNED',pc,'取指地址未按4字节对齐');else if(pc/4>=c.program.length)error=fault('INSTRUCTION_ACCESS_FAULT',pc,'PC超出本程序的只读指令存储');else if(!d.valid)error=fault('ILLEGAL_INSTRUCTION',word,d.reason);
 const r1=d.useRS1&&d.rs1?c.regs[d.rs1]>>>0:0,r2=d.useRS2&&d.rs2?c.regs[d.rs2]>>>0:0,a=d.usePC?pc:r1,b=d.useImm?d.imm:r2,alu=anatomyALU32(a,b,d.aluOp).value;let nextPC=(pc+4)>>>0,taken=false,load=0,store=null,io=null;
 if(d.branch)taken=({BEQ:r1===r2,BNE:r1!==r2,BLT:anatomySigned32(r1)<anatomySigned32(r2),BGE:anatomySigned32(r1)>=anatomySigned32(r2),BLTU:r1<r2,BGEU:r1>=r2})[d.branchKind];
 if(d.branch&&taken)nextPC=(pc+d.imm)>>>0;if(d.jump){taken=true;nextPC=d.name==='JALR'?(alu&0xfffffffe)>>>0:(pc+d.imm)>>>0}
 if(!error&&taken&&nextPC%4)error=fault('INSTRUCTION_ADDRESS_MISALIGNED',nextPC,'已选择的跳转目标未按4字节对齐；不提交链接寄存器');
 if(!error&&(d.memRead||d.memWrite)){
  const bytes=1<<d.memSize,address=alu>>>0;if(address%bytes)error=fault(d.memWrite?'STORE_ADDRESS_MISALIGNED':'LOAD_ADDRESS_MISALIGNED',address,'访存地址未按访问粒度对齐');
  else if(address<=256-bytes){if(d.memRead){for(let j=0;j<bytes;j++)load+=c.memory[address+j]*2**(8*j);if(!d.loadUnsigned&&bytes<4&&load>=2**(bytes*8-1))load-=2**(bytes*8);load>>>=0}else store={address,bytes,value:r2}}
  else if(bytes===4&&[0xffff0000,0xffff0004,0xffff0008,0xffff000c].includes(address)){
   if(d.memRead)load=address===0xffff0000?s.cpuSwitches&65535:address===0xffff000c?s.cpuButtons&31:address===0xffff0004?c.led:c.display;
   else if(address===0xffff0004||address===0xffff0008)io={address,value:r2};else error=fault('STORE_ACCESS_FAULT',address,'开关与按键寄存器只读');
  }else error=fault(d.memWrite?'STORE_ACCESS_FAULT':'LOAD_ACCESS_FAULT',address,'地址不在256字节数据RAM或教学I/O范围');
 }
 if(!error&&d.trap)error=fault(d.trapKind,0,d.trapKind==='EBREAK'?'断点请求：暂停观察；未执行调试环境':'环境调用请求：暂停观察；未执行系统服务');
 const wb=d.wb==='MEM'?load:d.wb==='PC+4'?(pc+4)>>>0:d.wb==='IMM'?d.imm:alu;
 return {pc,word,d,r1,r2,a,b,alu,nextPC,taken:!!taken,load,store,io,wb:wb>>>0,write:!error&&d.regWrite&&d.rd!==0?{address:d.rd,value:wb>>>0}:null,fault:error,enabled:!c.halted};
}
function anatomyCPU32CommitPlan(s){
 const c=s.cpu32,p=anatomyCPU32Preview(s),changes=[],add=(target,before,after)=>changes.push({target,before,after});
 if(c.halted)return {status:'stopped',instruction:p.d.name,message:'CPU 已暂停；需要重启或装载程序。',changes};
 if(p.fault)return {status:'fault',instruction:p.d.name,message:p.fault.kind+'：'+p.fault.message+'。本次不会退休、更新PC或写入寄存器/存储。',changes};
 add('PC',c.pc,p.nextPC);add('退休计数',c.retired,c.retired+1);
 if(p.write)add('x'+p.write.address,c.regs[p.write.address],p.write.value);
 if(p.store)for(let j=0;j<p.store.bytes;j++)add('RAM[0x'+(p.store.address+j).toString(16)+']',c.memory[p.store.address+j],(p.store.value>>>(j*8))&255);
 if(p.io)add(p.io.address===0xffff0004?'LED[15:0]':'显示保存字',p.io.address===0xffff0004?c.led:c.display,p.io.address===0xffff0004?p.io.value&65535:p.io.value>>>0);
 return {status:'ready',instruction:p.d.name,message:'一次有效边沿同时提交以下项目；相同数值的写入也列出。'+(p.d.regWrite&&p.d.rd===0?' x0 写请求被丢弃，x0 仍为零。':''),changes};
}
function anatomyCPU32Step(s){const c=s.cpu32;if(c.halted)return false;const p=anatomyCPU32Preview(s);s.ticks++;if(p.fault){c.halted=true;c.fault=p.fault;c.last={pc:p.pc,word:p.word,name:p.d.name,fault:p.fault};return false}if(p.store)for(let j=0;j<p.store.bytes;j++)c.memory[p.store.address+j]=(p.store.value>>>(j*8))&255;if(p.io){if(p.io.address===0xffff0004)c.led=p.io.value&65535;else c.display=p.io.value>>>0}if(p.write)c.regs[p.write.address]=p.write.value;c.regs[0]=0;c.pc=p.nextPC;c.retired++;c.last={pc:p.pc,word:p.word,name:p.d.name,nextPC:p.nextPC,write:p.write,store:p.store,io:p.io,taken:p.taken};return true}
plate('cpu32','程序运行 · 单周期 RV32I 教学 CPU',[
 P('PC',null,'cpu32pc',0,0,'PC 保存与 +4 候选'),P('IM',null,'cpu32im',0,0,'只读程序'),P('DEC','decoder32','decoder',0,0,'指令解码'),P('IMM','immgen32','wires',0,0,'立即数生成'),P('RF','regfile32','cpu32rf',0,0,'32×32 寄存器堆'),P('ALU','alu32','cpu32alu',0,0,'ALU 与输入选择'),P('DM',null,'cpu32mem',0,0,'256 字节 RAM / 教学I/O'),P('WB',null,'mux',0,0,'回写选择'),P('TARGET',null,'cpu32target',0,0,'跳转目标计算'),P('COND',null,'cpu32branch',0,0,'比较 / 跳转控制'),P('NEXT',null,'mux',0,0,'下一 PC 选择'),P('OUT',null,'cpu32board',0,0,'已保存的 LED / 显示输出')
],[N('当前 PC','PC.q','IM.addr',32),N('指令字','IM.inst','DEC.inst',32),N('指令→立即数','IM.inst','IMM.inst',32),N('解码控制','DEC.c','RF.ctrl',16,'control'),N('立即数','IMM.imm','ALU.i',32),N('读操作数 A','RF.a','ALU.a',32),N('读操作数 B','RF.b','ALU.b',32),N('ALU的PC候选','PC.q','ALU.p',32),N('ALU操作选择','DEC.a','ALU.s',4,'control'),N('ALU输入选择','DEC.c','ALU.sel',16,'control'),N('ALU 结果','ALU.result','DM.addr',32),N('存储待写数据','RF.b','DM.data',32),N('读取数据','DM.out','WB.mem',32),N('链接回写候选','PC.plus4','WB.link',32),N('高位立即数回写','IMM.imm','WB.imm',32),N('回写选择','DEC.w','WB.s',2,'control'),N('算术回写候选','ALU.result','WB.alu',32),N('回写值','WB.out','RF.write',32),N('目标PC基址','PC.q','TARGET.pc',32),N('JALR寄存器基址','RF.a','TARGET.reg',32),N('目标立即数','IMM.imm','TARGET.imm',32),N('跳转候选','TARGET.out','NEXT.target',32),N('比较源 A','RF.a','COND.a',32),N('比较源 B','RF.b','COND.b',32),N('比较控制','DEC.c','COND.ctrl',16,'control'),N('选择目标路径','COND.take','NEXT.sel',1,'control'),N('PC+4','PC.plus4','NEXT.seq',32),N('下一 PC','NEXT.out','PC.d',32),N('LED保存结果','DM.led','OUT.led',16),N('显示保存结果','DM.display','OUT.display',32)],
 [S('观察组合预览','当前 PC 选出指令；解码、读寄存器、ALU、访存读与下一状态候选在同一教学周期内完成。这里只观察，还没有提交。',['PC','IM','DEC','IMM','RF','ALU','DM','WB','NEXT']),S('一个边沿提交一条','执行边沿后，PC、目的寄存器或数据存储按条件更新。这里不是把取指/译码/执行各算一个时钟。',['PC','RF','DM','OUT'],['回写值','下一 PC','LED保存结果','显示保存结果']),S('循环、停止与异常','分支条件决定下一 PC。遇到断点、环境请求或访问异常时精确暂停，故障指令不退休、不写回、不写存储。',['PC','NEXT','DEC','DM'])],
 {lab:'cpu32',layer:'程序 → 组合候选 → 边沿提交',sources:['riscv'],boundary:'基础 RV32I 单周期功能模型；分离的只读程序与256字节数据RAM。ECALL/EBREAK/异常精确暂停，无特权CSR、操作系统、C/M扩展或流水线；不代表硬件频率。教学I/O地址与真实板引脚约束不同。图为数据路径概览，部分控制、时钟与故障门控合并省略；提交以模型的异常/使能判定为准。',question:'程序卡在同一个 PC 时，是循环分支、暂停状态，还是故障指令没有提交？'});
anExp('cpu32',[anNum('cpuProbe','观察寄存器 x0…x31',0,31),{...anNum('cpuSwitches','开关 SW（0x十六进制 / 十进制，16位）',0,65535),type:'word'},anNum('cpuButtons','教学按键位 C/U/L/R/D',0,31),anNum('cpuRunLimit','连续运行上限（次边沿）',1,500)],[['tick','执行一个 CPU 边沿 ↑'],['restart','重启当前程序（清空状态）']],'动作按钮每次尝试提交一条指令；组合预览不会写状态。连续运行的界面节奏不等于硬件频率。');
const anBeforeCPU32State=anatomyState;
anatomyState=function(){return {...anBeforeCPU32State(),cpu32:anatomyCPU32State(),cpuProbe:3,cpuSwitches:0x35,cpuButtons:0,cpuRunLimit:64}};
const anBeforeCPU32Advance=anatomyAdvance;
anatomyAdvance=function(id,s,action='tick'){if(id!=='cpu32')return anBeforeCPU32Advance(id,s,action);if(action==='reset'){const pins={cpuSwitches:s.cpuSwitches,cpuButtons:s.cpuButtons},mode=s.boardMode;Object.assign(s,anatomyState(),pins);if(mode)s.boardMode=mode;return}if(action==='restart'){const c=s.cpu32;s.cpu32=anatomyCPU32State({words:c.program,sourceLines:c.sourceLines,sourceText:c.sourceText},c.programName);s.ticks=0;return}if(action==='tick')anatomyCPU32Step(s)};
const anBeforeCPU32Evaluate=anatomyEvaluate;
anatomyEvaluate=function(id,s){const e=anBeforeCPU32Evaluate(id,s);if(id!=='cpu32')return e;const c=s.cpu32,p=anatomyCPU32Preview(s),d=p.d,hex=v=>'0x'+(v>>>0).toString(16).toUpperCase().padStart(8,'0');
 e.cpu32=p;e.result=s.cpuProbe===0?0:c.regs[s.cpuProbe]>>>0;e.led=c.led;e.digits=[AN_SEG[c.display&15],AN_SEG[(c.display>>>4)&15],AN_SEG[(c.display>>>8)&15],AN_SEG[(c.display>>>12)&15]];e.partValues={PC:c.pc,IM:p.word,DEC:d.name,IMM:d.imm,RF:p.r1,ALU:p.alu,DM:p.load,WB:p.wb,TARGET:d.name==='JALR'?(p.alu&0xfffffffe)>>>0:(p.pc+d.imm)>>>0,COND:+p.taken,NEXT:p.nextPC,OUT:c.led};e.nets={'当前 PC':c.pc,'指令字':p.word,'指令→立即数':p.word,'解码控制':d.control,'立即数':d.imm,'读操作数 A':p.r1,'读操作数 B':p.r2,'ALU的PC候选':c.pc,'ALU操作选择':AN_DEC32_ALU.indexOf(d.aluOp),'ALU输入选择':d.control,'链接回写候选':(c.pc+4)>>>0,'高位立即数回写':d.imm,'回写选择':AN_DEC32_WB.indexOf(d.wb),'ALU 结果':p.alu,'存储待写数据':p.r2,'读取数据':p.load,'算术回写候选':p.alu,'回写值':p.wb,'目标PC基址':c.pc,'JALR寄存器基址':p.r1,'目标立即数':d.imm,'比较源 A':p.r1,'比较源 B':p.r2,'比较控制':d.control,'选择目标路径':+p.taken,'跳转候选':d.name==='JALR'?(p.alu&0xfffffffe)>>>0:(p.pc+d.imm)>>>0,'PC+4':(p.pc+4)>>>0,'下一 PC':p.nextPC,'LED保存结果':c.led,'显示保存结果':c.display};
 e.watch=[{name:'CPU 状态',value:c.halted?'已暂停：'+c.fault.kind:'等待边沿 / 可连续运行',why:c.halted?c.fault.message:'图中候选来自当前指令，尚未保存'},{name:'当前 PC / 指令',value:hex(c.pc)+' / '+(p.fault&&p.fault.kind.startsWith('INSTRUCTION_')?'取指/目标异常':d.name),why:hex(p.word)+'；退休 '+c.retired+' 条；尝试边沿 '+s.ticks+' 次'},{name:'观察 x'+s.cpuProbe,value:hex(e.result)+' / '+anatomySigned32(e.result),why:'这是已保存寄存器值，x0 恒为0'},{name:'当前组合候选',value:d.regWrite?'x'+d.rd+' ← '+hex(p.wb):'无目的寄存器写回',why:c.halted?'CPU已停止，不会提交':p.fault?'有待处理异常，本条不会写回':p.write?'需下一个边沿才保存':d.regWrite?'rd=x0，写回会丢弃':'本指令没有目的寄存器写请求'},{name:'下一 PC 候选',value:c.halted?'已暂停，PC保持 '+hex(c.pc):hex(p.nextPC),why:c.halted?'没有继续提交；需重启或装载程序':p.taken?'选择分支/跳转路径；尚未更新 PC':'顺序 PC+4，或条件分支未满足'},{name:'最近一次尝试',value:c.last?hex(c.last.pc)+' '+c.last.name:'尚无',why:c.last?.fault?'精确暂停：没有退休或数据写入':c.last?.write?'已保存 x'+c.last.write.address+'='+hex(c.last.write.value):c.last?'已提交；未写目的寄存器':'先观察，再给边沿'},{name:'板上保存输出',value:'LED='+hex(c.led)+'，显示='+hex(c.display),why:'仅由程序写教学I/O改变；显示按低16位十六进制解码'},{name:'内存与地址约定',value:'RAM 0x00…0xFF；I/O 0xFFFF0000…0xFFFF000C',why:'32位访问：SW只读+0，LED可读写+4，显示可读写+8，按键只读+C；未支持访问精确暂停'}];return e;
};
AN_CONTEXT_ASSOCIATIONS.cpu32='system';
const anBeforeCPU32Descriptor=anatomyOutputDescriptor;
anatomyOutputDescriptor=function(b){return b.id==='cpu32'?{name:'已保存的观察寄存器',width:32}:anBeforeCPU32Descriptor(b)};
const anBeforeCPU32Explain=anatomyExplainObservation;
anatomyExplainObservation=function(b,p,c){const e=anBeforeCPU32Explain(b,p,c);if(b.id!=='cpu32'||!p)return e;const s=c.state,core=s.cpu32,prev=p.state.cpu32;if(core.retired>prev.retired){const last=core.last;e.title='边沿已提交 '+last.name+'，PC 更新';e.body='执行的指令位于 0x'+last.pc.toString(16)+'。'+(last.write?'保存 x'+last.write.address+' = 0x'+last.write.value.toString(16)+'。':'没有目的寄存器写入。')+(last.store?'已写入数据RAM。':last.io?'已更新教学板输出。':'')+'图中现在预览下一条；刚完成的变化可在观察时间轴回看。'}else if(core.halted&&!prev.halted){e.title='精确暂停：'+core.fault.kind;e.body=core.fault.message+'。PC和故障指令的寄存器/存储写入均未提交；退休数不增加。'}else if(core.retired<prev.retired){e.title='重新装载或重启程序';e.body='PC、寄存器、RAM与板输出恢复教学初始状态。'}else{e.title='输入/观察选择改变，CPU 没有推进';e.body='修改开关或观察寄存器不会自动执行指令。程序只会在 CPU 边沿或连续运行时推进。'}return e};
ANATOMY_ROUTES.push({name:'从程序到一次真正的状态提交',key:'single-cycle-program',prerequisite:'先认识寄存器堆、立即数与ALU；需要基本汇编概念',goal:'沿真实单周期执行区分指令预览与边沿提交',ids:['cpu32','decoder32','immgen32','regfile32','alu32'],hints:['单周期 CPU 每个边沿执行一条指令；阶段讲解不是多个硬件时钟','观察编码如何生成控制','观察立即数位如何拼接','观察读口与保存值的区别','观察当前指令的算术候选；独立实验副本不写回CPU']});

function anatomyCPU32Flow(s){
 const p=anatomyCPU32Preview(s),d=p.d,hex=v=>'0x'+(v>>>0).toString(16).toUpperCase().padStart(8,'0'),fetchFault=p.pc%4!==0||p.pc/4>=s.cpu32.program.length,valid=d.valid&&!fetchFault,plan=anatomyCPU32CommitPlan(s);
 const sources=[];if(d.useRS1)sources.push('x'+d.rs1+'='+hex(p.r1));if(d.useRS2)sources.push('x'+d.rs2+'='+hex(p.r2));if(d.useImm)sources.push('立即数='+hex(d.imm));if(d.usePC)sources.push('PC='+hex(p.pc));
 let execute=valid?'ALU '+d.aluOp+'：'+hex(p.a)+' 与 '+hex(p.b)+' → '+hex(p.alu):'无有效运算候选。';
 if(valid&&d.wb==='IMM')execute='LUI 直接选择立即数 '+hex(d.imm)+'；不把无关ALU候选当作写回值。';
 if(valid&&d.branch)execute='比较源操作数：'+d.branchKind+'，'+hex(p.r1)+' 与 '+hex(p.r2)+'；比较结果决定下一PC。';
 if(valid&&(d.trap||d.fence))execute=d.trap?'环境/断点请求不产生普通算术写回。':'FENCE 在本教学CPU中顺序推进；不模拟缓存排序硬件。';
 let access='本指令不访问数据RAM或教学I/O。';
 if(valid&&(d.memRead||d.memWrite))access=p.fault?p.fault.kind+'：'+p.fault.message+'；不会提交访存。':d.memRead?'从 '+hex(p.alu)+' 读取 '+(1<<d.memSize)+' 字节，扩展后为 '+hex(p.load):'准备向 '+hex(p.alu)+' 写入 '+(1<<d.memSize)+' 字节，源数据 '+hex(p.r2)+'；等待边沿提交。';
 if(valid&&(d.branch||d.jump))access=(d.jump?'无条件跳转':p.taken?'分支成立':'分支不成立')+'；候选下一PC='+hex(p.nextPC)+(p.fault?'；'+p.fault.kind:'');
 if(valid&&d.trap)access=p.fault.kind+'：'+p.fault.message;
 return [
  {title:'取指',part:'IM',body:fetchFault?p.fault.message:'PC='+hex(p.pc)+' → 指令编码 '+hex(p.word)},
  {title:'译码',part:'DEC',body:fetchFault?'取指失败，不解释占位编码。':d.valid?d.name+' · '+d.format+' 格式；'+d.group:'非法/未支持编码：'+d.reason},
  {title:'读取操作数',part:valid&&(d.useRS1||d.useRS2)?'RF':valid&&d.useImm?'IMM':'DEC',body:valid?(sources.join('；')||'无寄存器或立即数操作数。'):'无有效操作数。'},
  {title:'运算与地址',part:!valid||d.trap||d.fence?'DEC':d.wb==='IMM'?'IMM':d.branch?'COND':'ALU',body:execute},
  {title:'访存 / 跳转',part:d.branch||d.jump?'NEXT':d.memRead||d.memWrite?'DM':'NEXT',body:valid?access:'本指令不能进行有效数据访问或跳转。'},
  {title:'边沿提交预览',part:'WB',body:plan.status==='ready'?(plan.message+' '+plan.changes.map(x=>x.target+'：'+hex(x.before)+' → '+hex(x.after)).join('；')):plan.message}
 ];
}

function anatomyCPU32MemoryAccess(s){
 const p=anatomyCPU32Preview(s),d=p.d;if(!d.valid||!(d.memRead||d.memWrite))return null;
 const bytes=1<<d.memSize,address=p.alu>>>0,inRAM=address<=256-bytes,mmio=bytes===4&&[0xffff0000,0xffff0004,0xffff0008,0xffff000c].includes(address),space=inRAM?'RAM':mmio?'MMIO':'无效地址',write=!!d.memWrite;
 const source=write?p.r2:p.load,lanes=p.fault?[]:Array.from({length:bytes},(_,i)=>({index:i,address:inRAM?address+i:null,before:inRAM?s.cpu32.memory[address+i]:null,value:(source>>>(8*i))&255,applies:!write||inRAM||address!==0xffff0004||i<2}));
 return {instruction:d.name,address,bytes,space,write,lanes,value:source>>>0,result:write?(inRAM&&bytes<4?p.r2&((1<<(bytes*8))-1):address===0xffff0004?p.r2&65535:p.r2)>>>0:p.load>>>0,extension:write?'截取低'+(bytes*8)+'位':bytes===4?'不扩展':d.loadUnsigned?'零扩展':'符号扩展',fault:p.fault,enabled:p.enabled,rd:d.rd};
}

function anatomyCPU32ControlFlow(s){
 const p=anatomyCPU32Preview(s),d=p.d;if(!d.valid||!(d.branch||d.jump))return null;
 const sequential=(p.pc+4)>>>0,rawTarget=d.name==='JALR'?p.alu:(p.pc+d.imm)>>>0,target=d.name==='JALR'?(rawTarget&0xfffffffe)>>>0:rawTarget;
 const signed=v=>v>=0x80000000?v-0x100000000:v,a=p.r1,b=p.r2;
 return {instruction:d.name,pc:p.pc,sequential,rawTarget,target,next:p.nextPC,taken:p.taken,branch:!!d.branch,jump:!!d.jump,rs1:d.rs1,rs2:d.rs2,a,b,signedA:signed(a),signedB:signed(b),immediate:anatomySigned32(d.imm),link:d.jump?{rd:d.rd,value:sequential,allowed:!!p.write&&p.enabled}:null,fault:p.fault,enabled:p.enabled,comparisons:{BEQ:a===b,BNE:a!==b,BLT:signed(a)<signed(b),BGE:signed(a)>=signed(b),BLTU:a<b,BGEU:a>=b}};
}
AN_CPU32_DEMOS.push({name:'分支比较：有符号与无符号',source:`li x1, -1
addi x2, x0, 1
blt x1, x2, signedLess
addi x3, x0, 99
signedLess: bltu x1, x2, unsignedLess
addi x4, x0, 1
j done
unsignedLess: addi x4, x0, 2
done: ebreak`});
