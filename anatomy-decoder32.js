'use strict';
ANATOMY_SOURCES.decoderRTL={title:'独立 Verilog 参考 · 用于对照验证，页面使用功能模型',url:'hardware/rv32_decoder.v'};
const AN_DEC32_FORMATS=['R','I','S','B','U','J','N'];
const AN_DEC32_ALU=['ADD','SUB','AND','OR','XOR','SLL','SRL','SRA','SLT','SLTU'];
const AN_DEC32_WB=['ALU','MEM','PC+4','IMM'];
const AN_DEC32_SIGNALS=[['valid','支持的编码'],['useRS1','读 rs1'],['useRS2','读 rs2'],['regWrite','写寄存器请求'],['memRead','读存储器'],['memWrite','写存储器'],['branch','条件分支'],['jump','无条件跳转'],['useImm','ALU B 选立即数'],['usePC','ALU A 选 PC'],['trap','环境调用 / 断点'],['fence','内存排序请求']];
const AN_RV32_DECODE_CASES=[];
function anDecodeCase(name,mask,match,format,group,options={}){AN_RV32_DECODE_CASES.push({name,mask:mask>>>0,match:match>>>0,format,group,...options})}
for(const [name,f3,f7] of [['ADD',0,0],['SUB',0,32],['SLL',1,0],['SLT',2,0],['SLTU',3,0],['XOR',4,0],['SRL',5,0],['SRA',5,32],['OR',6,0],['AND',7,0]])anDecodeCase(name,0xfe00707f,(f7*2**25)+(f3<<12)+0x33,'R','寄存器运算',{useRS1:1,useRS2:1,regWrite:1,aluOp:name});
for(const [name,f3]of [['ADDI',0],['SLTI',2],['SLTIU',3],['XORI',4],['ORI',6],['ANDI',7]])anDecodeCase(name,0x707f,(f3<<12)+0x13,'I','立即数运算',{useRS1:1,regWrite:1,useImm:1,aluOp:({ADDI:'ADD',SLTI:'SLT',SLTIU:'SLTU',XORI:'XOR',ORI:'OR',ANDI:'AND'})[name]});
for(const [name,f3,f7,aluOp]of [['SLLI',1,0,'SLL'],['SRLI',5,0,'SRL'],['SRAI',5,32,'SRA']])anDecodeCase(name,0xfe00707f,(f7*2**25)+(f3<<12)+0x13,'I','立即数移位',{useRS1:1,regWrite:1,useImm:1,shiftImmediate:1,aluOp});
for(const [name,f3,size,unsigned]of [['LB',0,0,0],['LH',1,1,0],['LW',2,2,0],['LBU',4,0,1],['LHU',5,1,1]])anDecodeCase(name,0x707f,(f3<<12)+3,'I','读取数据',{useRS1:1,regWrite:1,memRead:1,useImm:1,wb:'MEM',memSize:size,loadUnsigned:unsigned});
for(const [name,f3,size]of [['SB',0,0],['SH',1,1],['SW',2,2]])anDecodeCase(name,0x707f,(f3<<12)+0x23,'S','写入数据',{useRS1:1,useRS2:1,memWrite:1,useImm:1,memSize:size});
for(const [name,f3,aluOp]of [['BEQ',0,'SUB'],['BNE',1,'SUB'],['BLT',4,'SLT'],['BGE',5,'SLT'],['BLTU',6,'SLTU'],['BGEU',7,'SLTU']])anDecodeCase(name,0x707f,(f3<<12)+0x63,'B','条件分支',{useRS1:1,useRS2:1,branch:1,branchKind:name,aluOp});
anDecodeCase('JAL',0x7f,0x6f,'J','无条件跳转',{regWrite:1,jump:1,useImm:1,usePC:1,wb:'PC+4'});
anDecodeCase('JALR',0x707f,0x67,'I','无条件跳转',{useRS1:1,regWrite:1,jump:1,useImm:1,wb:'PC+4'});
anDecodeCase('LUI',0x7f,0x37,'U','高位立即数',{regWrite:1,useImm:1,wb:'IMM'});
anDecodeCase('AUIPC',0x7f,0x17,'U','PC 相对运算',{regWrite:1,useImm:1,usePC:1});
// Base FENCE ignores rs1, rd and reserved fm/pred/succ combinations as specified.
anDecodeCase('FENCE',0x707f,0x0f,'N','内存排序',{fence:1});
anDecodeCase('ECALL',0xffffffff,0x00000073,'N','环境调用',{trap:1,trapKind:'ECALL'});
anDecodeCase('EBREAK',0xffffffff,0x00100073,'N','调试断点',{trap:1,trapKind:'EBREAK'});
function anatomyDecodeRV32(instruction){
 const word=Number(instruction)>>>0,opcode=word&127,rd=(word>>>7)&31,funct3=(word>>>12)&7,rs1=(word>>>15)&31,rs2=(word>>>20)&31,funct7=word>>>25,entry=AN_RV32_DECODE_CASES.find(c=>((word&c.mask)>>>0)===c.match);
 const d={word,opcode,rd,rs1,rs2,funct3,funct7,valid:0,name:'未支持 / 保留编码',format:null,group:'未解码',id:63,aluOp:'ADD',wb:'ALU',memSize:0,loadUnsigned:0,shiftImmediate:0,branchKind:'',trapKind:'',imm:0,...Object.fromEntries(AN_DEC32_SIGNALS.slice(1).map(([key])=>[key,0]))};
 if(entry)Object.assign(d,entry,{valid:1,id:AN_RV32_DECODE_CASES.indexOf(entry)});
 d.imm=d.valid&&['I','S','B','U','J'].includes(d.format)?anatomyImmediate32(word,d.format):0;
 d.effectiveRegWrite=+(!!d.regWrite&&rd!==0);d.shamt=rs2;
 d.reason=d.valid?'本模块支持的 RV32I 编码':opcode===0x33&&funct7===1?'M 扩展编码；本模块只支持基础 RV32I':opcode===0x0f&&funct3===1?'FENCE.I 属于 Zifencei 扩展，不在本模块内':opcode===0x73&&funct3!==0?'CSR / 扩展 SYSTEM 编码，不在本模块内':(word&3)!==3?'压缩或其他非32位编码；本模块只观察32位 RV32I':'不匹配本模块的基础 RV32I 编码；可能是扩展或保留字段';
 d.control=AN_DEC32_SIGNALS.reduce((v,[key],i)=>v|((d[key]?1:0)<<i),0)|(AN_DEC32_WB.indexOf(d.wb)<<12)|(d.memSize<<14);
 return d;
}
function anatomyDecode32Example(index){const c=AN_RV32_DECODE_CASES[index];if(!c)return 0;
 if(c.name==='ECALL'||c.name==='EBREAK')return c.match;
 if(c.name==='FENCE')return 0x0ff0000f;
 if(c.format==='R')return (c.match|(2<<20)|(1<<15)|(3<<7))>>>0;
 if(c.shiftImmediate)return (c.match|(4<<20)|(1<<15)|(3<<7))>>>0;
 if(c.format==='I')return (c.match|(4<<20)|(1<<15)|(3<<7))>>>0;
 if(c.format==='S')return (c.match|(2<<20)|(1<<15)|(4<<7))>>>0;
 if(c.format==='B')return (c.match|(2<<20)|(1<<15)|(4<<8))>>>0;
 if(c.format==='U')return (c.match|0x12345000|(3<<7))>>>0;
 return (c.match|(8<<20)|(3<<7))>>>0;
}
plate('decoder32','指令解码 · 从编码到控制信号',[
 P('INST',null,'port',0,0,'32 位指令'),P('DEC',null,'dec32table',0,0,'RV32I 编码匹配与字段'),P('CTRL',null,'dec32control',0,0,'控制请求 · 输出只读'),P('IMM',null,'port',0,0,'立即数 / 原始 I 拼接值'),P('ADDR',null,'port',0,0,'rs1 / rs2 / rd 原始字段')
],[N('指令字','INST.o','DEC.inst',32),N('控制摘要','DEC.ctrl','CTRL.i',16,'control'),N('ALU 选择','DEC.alu','CTRL.alu',4,'control'),N('访存零扩展','DEC.unsigned','CTRL.unsigned',1,'control'),N('分支比较码','DEC.branchcond','CTRL.branchcond',3,'control'),N('立即数','DEC.imm','IMM.i',32),N('寄存器字段原始位','DEC.regs','ADDR.i',15,'control')],
 [S('先匹配操作编码','opcode 选择大类；funct3、funct7 或完整 SYSTEM 编码继续区分。点击某一行装载它的示例，再修改上方位。',['INST','DEC'],['指令字']),S('字段不等于一定使用','同一位置可以属于寄存器地址，也可以属于立即数字段。只有“读 rs1 / 读 rs2”开启时才作为源寄存器使用。',['DEC','ADDR','IMM'],['寄存器字段原始位','立即数']),S('控制请求还不是执行','RegWrite 是解码写请求，rd=x0 时最终写入仍被丢弃。分支输出只表示这是分支，不表示条件已经满足。',['DEC','CTRL'],['控制摘要','ALU 选择','访存零扩展','分支比较码'])],
 {lab:'dec32',layer:'处理器 · 基础 RV32I 编码与控制',sources:['riscv','decoderRTL'],boundary:'识别基础 RV32I 的40种指令编码，产生本教学数据通路约定的控制请求。不是完整 CPU；不执行访存、跳转、异常入口或 FENCE 内存排序。M/C/CSR/FENCE.I 等扩展不在此模块。',question:'同样是读了 rs2 字段，为什么 ADD 会使用它，而 ADDI 不把它当作寄存器地址？'});
ANATOMY.decoder32.parts.find(p=>p.id==='DEC').entries=AN_RV32_DECODE_CASES;
ANATOMY.decoder32.parts.find(p=>p.id==='CTRL').signals=AN_DEC32_SIGNALS;
anExp('decoder32',[{...anNum('decInstruction','指令编码（十进制 / 0x / 0b）',0,4294967295),type:'word'}],[],'点击匹配表装载示例；翻转输入位观察控制变化。所有控制位是只读结果，不会直接修改存储或寄存器。');
const anBeforeDec32State=anatomyState;
anatomyState=function(){return {...anBeforeDec32State(),decInstruction:0x002081b3}};
const anBeforeDec32Evaluate=anatomyEvaluate;
anatomyEvaluate=function(id,s){const e=anBeforeDec32Evaluate(id,s);if(id!=='decoder32')return e;const d=anatomyDecodeRV32(s.decInstruction),hex=n=>'0x'+n.toString(16).toUpperCase().padStart(8,'0');
 e.dec32=d;e.result=d.control;e.led=d.control;e.partValues={INST:d.word,DEC:d.name,CTRL:d.control,IMM:d.imm,ADDR:(d.rs1<<10)|(d.rs2<<5)|d.rd};e.nets={'指令字':d.word,'控制摘要':d.control,'ALU 选择':AN_DEC32_ALU.indexOf(d.aluOp),'访存零扩展':d.loadUnsigned,'分支比较码':d.branch?d.funct3:0,'立即数':d.imm,'寄存器字段原始位':e.partValues.ADDR};
 e.watch=[{name:'解码结果',value:d.valid?d.name:'未支持 / 保留编码',why:d.reason},{name:'格式 / 操作类别',value:(d.format||'—')+' / '+d.group,why:'表中列出40种基础编码；仅识别和产生控制，不执行指令'},{name:'读地址字段',value:'rs1=x'+d.rs1+'；rs2=x'+d.rs2,why:'读 rs1='+d.useRS1+'，读 rs2='+d.useRS2+'；未使用字段不得误作源操作数'},{name:'rd 位置的原始位',value:d.regWrite?'x'+d.rd:'不作目的寄存器（位值 '+d.rd+'）',why:'解码写请求='+d.regWrite+'；经 x0 保护后的有效写请求='+d.effectiveRegWrite},{name:d.shiftImmediate?'移位量 shamt':'立即数',value:d.shiftImmediate?String(d.shamt):d.format&&d.format!=='R'&&d.format!=='N'?hex(d.imm)+' / '+anatomySigned32(d.imm):'本指令无立即数',why:d.shiftImmediate?'只用 inst[24:20]；原始 I 拼接值 '+hex(d.imm)+' 包含移位操作编码，不当作普通加数':'格式由本次匹配结果决定；R/N 的立即数端口输出0'},{name:'ALU 与回写选择',value:d.valid?d.aluOp+' / '+d.wb:'无有效选择',why:!d.valid?'未解码：所有执行使能关闭，默认内部编码不是执行 ADD':'A='+ (d.usePC?'PC':d.useRS1?'rs1':'ZERO')+'，B='+(d.useImm?'IMM':d.useRS2?'rs2':'ZERO')+'；这些是教学数据通路选择'},{name:'访存请求',value:'读='+d.memRead+'，写='+d.memWrite,why:d.memRead||d.memWrite?['字节','半字','字'][d.memSize]+(d.memRead?(d.memSize===2?'；32位整字，不额外扩展':d.loadUnsigned?'；零扩展到32位':'；符号扩展到32位'):'；待写数据来自 rs2'):'当前无访存请求'},{name:'控制流 / 系统',value:d.branch?d.name+'（尚未比较条件）':d.jump?d.name+'（尚未计算目标）':d.trap?d.trapKind+'（产生陷入请求）':d.fence?'FENCE（排序请求）':'顺序路径',why:'本模块不运行程序；陷入、取指对齐、访问异常和内存排序需由执行环境处理'}];return e;
};
AN_CONTEXT_ASSOCIATIONS.decoder32='instruction';
const anBeforeDec32Descriptor=anatomyOutputDescriptor;
anatomyOutputDescriptor=function(b){return b.id==='decoder32'?{name:'16 位教学控制摘要',width:16}:anBeforeDec32Descriptor(b)};
const anBeforeDec32Explain=anatomyExplainObservation;
anatomyExplainObservation=function(b,p,c){const e=anBeforeDec32Explain(b,p,c);if(b.id!=='decoder32'||!p)return e;const d=c.evaluation.dec32,old=p.evaluation.dec32;e.title=!d.valid?'编码未匹配：关闭写入请求':d.name!==old?.name?'解码从 '+(old?.name||'未支持')+' 变为 '+d.name:'指令字段变化，操作仍为 '+d.name;e.body=d.valid?'ALU 选择 '+d.aluOp+'。读 rs1='+d.useRS1+'、读 rs2='+d.useRS2+'、寄存器写请求='+d.regWrite+'、存储写请求='+d.memWrite+'。'+(d.rd===0&&d.regWrite?'rd=x0，不会实际写入；不能因此跳过可能的访存或异常。':d.branch?'分支请求不等于分支已跳转；还需要比较操作数。':'控制已经生成，但没有提交任何执行状态。'):d.reason+'。寄存器与存储器写请求均关闭；不是把未知指令当作 ADD 执行。';return e};
ANATOMY_ROUTES.push({name:'一条指令怎样发出控制请求',key:'instruction-control',prerequisite:'认识操作码、寄存器字段与ALU运算',goal:'区分字段值、实际使用使能与非法编码',ids:['decoder32','immgen32','regfile32','alu32'],hints:['匹配编码并区分地址字段与使用使能','将有效格式与指令显式复制，追踪立即数来源','复制地址和写请求到独立寄存器堆；仍须手动提供数据与边沿','ALU 仅执行所选运算；四个模块尚不是自动运行的 CPU']});
