'use strict';
function anatomySigned32(value){return value>=2147483648?value-4294967296:value}
function anatomyALU32(a,b,op){
 a=Number(a)>>>0;b=Number(b)>>>0;const A=BigInt(a),B=BigInt(b),SA=BigInt.asIntN(32,A),SB=BigInt.asIntN(32,B),shift=BigInt(b&31);let raw=0n,carry=0,overflow=0;
 switch(op){
 case 'ADD':raw=A+B;carry=+(raw>0xffffffffn);overflow=+(SA+SB>2147483647n||SA+SB< -2147483648n);break;
 case 'SUB':raw=A-B;carry=+(a>=b);overflow=+(SA-SB>2147483647n||SA-SB< -2147483648n);break;
 case 'AND':raw=A&B;break;case 'OR':raw=A|B;break;case 'XOR':raw=A^B;break;
 case 'SLL':raw=A<<shift;break;case 'SRL':raw=A>>shift;break;case 'SRA':raw=SA>>shift;break;
 case 'SLT':raw=SA<SB?1n:0n;break;case 'SLTU':raw=A<B?1n:0n;break;
 default:return {value:0,zero:1,sign:0,carry:0,overflow:0,valid:0};
 }
 const value=Number(BigInt.asUintN(32,raw));return {value,zero:+(value===0),sign:value>>>31,carry,overflow,valid:1};
}

plate('alu32','32 位 ALU · 算术、移位与有符号比较',[
 P('A',null,'port',0,0,'A[31:0]'),P('B',null,'port',0,0,'B[31:0]'),P('OP',null,'port',0,0,'运算选择'),
 P('ADD',null,'rvarith',0,0,'加 / 减 · 32 位'),P('LOG',null,'rvlogic',0,0,'AND / OR / XOR'),P('SHIFT',null,'rvshift',0,0,'SLL / SRL / SRA'),P('CMP',null,'rvcompare',0,0,'SLT / SLTU'),P('M',null,'mux',0,0,'并行候选选择'),P('O',null,'port',0,0,'R[31:0]'),P('FLAGS',null,'port',0,0,'Z S C V · 调试输出')
],[...['ADD','LOG','SHIFT','CMP'].flatMap(p=>[N('A→'+p,'A.o',p+'.a',32),N('B→'+p,'B.o',p+'.b',32)]),...['ADD','LOG','SHIFT','CMP'].map(p=>N(p+'候选',p+'.o','M.'+p.toLowerCase(),32)),N('操作选择','OP.o','M.sel',4,'control'),N('结果 R','M.o','O.i',32),N('调试标志','M.flags','FLAGS.i',4)],
 [S('一组输入，多路候选','算术、逻辑、移位、比较电路接收同一组 A 和 B；图中显示各路当前候选值。',['A','B','ADD','LOG','SHIFT','CMP']),S('明确比较与补位','SLT 按补码解释；SLTU 按无符号解释。SRL 高位补 0，SRA 复制符号位。移位量仅使用 B[4:0]。',['SHIFT','CMP']),S('末级选择与边界','操作选择器选一路作为 R。C 和 V 是不同概念；此处调试标志不是 RISC-V 架构状态。',['M','O','FLAGS'],['结果 R','调试标志'])],
 {lab:'rv32alu',layer:'处理器 · 完整 32 位数据宽度',sources:['riscv'],boundary:'10 种整数运算的组合功能模型；非完整 CPU，无延迟、面积和最高频率结论。C：ADD 的输出进位 / SUB 的无借位；其他操作 C、V 置 0。',question:'A=0xFFFFFFFF、B=1 时，SLT 与 SLTU 为什么得到不同结果？'});
anExp('alu32',[{...anNum('av','A 位模式（十进制 / 0x / 0b）',0,4294967295),type:'word'},{...anNum('bv','B 位模式（十进制 / 0x / 0b）',0,4294967295),type:'word'},anChoice('op','运算',[['ADD','ADD 加法'],['SUB','SUB 减法'],['AND','AND 按位与'],['OR','OR 按位或'],['XOR','XOR 按位异或'],['SLL','SLL 逻辑左移'],['SRL','SRL 逻辑右移'],['SRA','SRA 算术右移'],['SLT','SLT 有符号小于'],['SLTU','SLTU 无符号小于']])],[],'输入支持十进制、0x 十六进制和 0b 二进制，范围 0…4294967295；右侧同时显示十六进制和二进制。0xFFFFFFFF 的有符号解释为 −1。');
const anBeforeRV32Evaluate=anatomyEvaluate;
anatomyEvaluate=function(id,s){
 const e=anBeforeRV32Evaluate(id,s);if(id!=='alu32')return e;
 const a=s.av>>>0,b=s.bv>>>0,op=s.op,r=anatomyALU32(a,b,op),arith=anatomyALU32(a,b,op==='SUB'?'SUB':'ADD').value,logic=anatomyALU32(a,b,['AND','OR','XOR'].includes(op)?op:'AND').value,shift=anatomyALU32(a,b,['SLL','SRL','SRA'].includes(op)?op:'SLL').value,compare=anatomyALU32(a,b,op==='SLTU'?'SLTU':'SLT').value;
 e.operation=op;e.result=r.value;e.led=r.value&65535;e.partValues={A:a,B:b,OP:op,ADD:arith,LOG:logic,SHIFT:shift,CMP:compare,M:r.value,O:r.value,FLAGS:(r.zero<<3)|(r.sign<<2)|(r.carry<<1)|r.overflow};e.nets={};
 for(const p of ['ADD','LOG','SHIFT','CMP']){e.nets['A→'+p]=a;e.nets['B→'+p]=b;e.nets[p+'候选']=e.partValues[p]}
 e.nets['操作选择']=['ADD','SUB','AND','OR','XOR','SLL','SRL','SRA','SLT','SLTU'].indexOf(op);e.nets['结果 R']=r.value;e.nets['调试标志']=e.partValues.FLAGS;e.flags=r;
 const hex=n=>'0x'+n.toString(16).toUpperCase().padStart(8,'0');
 e.watch=[{name:'A 位模式',value:hex(a),why:'无符号 '+a+'；补码 '+anatomySigned32(a)},{name:'B 位模式',value:hex(b),why:'无符号 '+b+'；补码 '+anatomySigned32(b)},{name:'运算',value:op,why:'非本组运算的单元显示默认候选：ADD、AND、SLL、SLT'},{name:'结果 R[31:0]',value:hex(r.value),why:'无符号 '+r.value+'；补码 '+anatomySigned32(r.value)},{name:'结果二进制',value:r.value.toString(2).padStart(32,'0'),why:'固定 32 位，最高位为 bit31'},{name:'移位量 B[4:0]',value:String(b&31),why:'仅移位操作使用，B=32 等价于移位 0 位'},{name:'Z / S',value:r.zero+' / '+r.sign,why:'结果为零 / 结果 bit31；S 不等于发生溢出'},{name:'C / V',value:r.carry+' / '+r.overflow,why:'ADD：进位 / 补码溢出；SUB：无借位 / 补码溢出；其余置零'}];
 return e;
};
AN_CONTEXT_ASSOCIATIONS.alu32='cpu';
const anBeforeRV32Descriptor=anatomyOutputDescriptor;
anatomyOutputDescriptor=function(b){return b.id==='alu32'?{name:'R[31:0] 运算结果',width:32}:anBeforeRV32Descriptor(b)};
ANATOMY_ROUTES.push({name:'从四位加法走到 32 位 ALU',key:'alu32',prerequisite:'认识二进制进位，先完成四位加法实验',goal:'区分位宽、进位和有符号溢出，完成32位边界运算',ids:['adder','fulladder','alu','alu32'],hints:['先用四位小例看清进位','拆开一位和与进位的产生','用四位缩小示例观察并行候选','提升到完整 32 位运算；这里不声称旧示例已变成完整 CPU']});
const AN_RV32_PRESETS=[
 {label:'看无符号进位',av:0xffffffff,bv:1,op:'ADD'},
 {label:'看补码溢出',av:0x7fffffff,bv:1,op:'ADD'},
 {label:'比较 SLT / SLTU',av:0xffffffff,bv:1,op:'SLT'},
 {label:'比较 SRL / SRA',av:0x80000000,bv:1,op:'SRL'},
 {label:'移位量 32 的边界',av:1,bv:32,op:'SLL'}
];
const anBeforeRV32Explain=anatomyExplainObservation;
anatomyExplainObservation=function(b,previous,current){
 const ex=anBeforeRV32Explain(b,previous,current);if(b.id!=='alu32'||!previous)return ex;
 const s=current.state,r=current.evaluation.flags,a=s.av>>>0,z=s.bv>>>0,hex=n=>'0x'+n.toString(16).toUpperCase().padStart(8,'0');
 ex.title='32 位 '+s.op+'：'+(ex.diff.resultChanged?'结果改变':'结果保持');
 if(['SLT','SLTU'].includes(s.op))ex.body=s.op+' 使用'+(s.op==='SLT'?'补码有符号':'无符号')+'比较：'+(s.op==='SLT'?anatomySigned32(a):a)+' < '+(s.op==='SLT'?anatomySigned32(z):z)+'，输出 '+r.value+'。同样的位模式可有不同数值解释；切换 SLT / SLTU 对照。';
 else if(['SLL','SRL','SRA'].includes(s.op))ex.body='B='+z+'，只取 B[4:0] 得到移位量 '+(z&31)+'。'+(s.op==='SRA'?'算术右移复制 A 的 bit31。':s.op==='SRL'?'逻辑右移在高位补 0。':'逻辑左移在低位补 0，移出的高位丢弃。')+'结果 '+hex(r.value)+'；按补码解释为 '+anatomySigned32(r.value)+'。';
 else if(['ADD','SUB'].includes(s.op))ex.body='R='+hex(r.value)+'，补码解释 '+anatomySigned32(r.value)+'。C='+r.carry+'（'+(s.op==='ADD'?'无符号加法进位':'1 表示无借位')+'），V='+r.overflow+'（有符号溢出）。二者各自回答不同的问题；这些标志仅用于教学调试。';
 else ex.body='对 A 和 B 的对应位执行 '+s.op+'，结果 '+hex(r.value)+'。其他候选电路仍在计算；末级选择器只把这一候选送到 R。无需时钟。';
 return ex;
};
