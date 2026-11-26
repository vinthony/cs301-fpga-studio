'use strict';
// Curriculum-aligned functional experiments. These do not claim synthesis, timing closure, or a full CPU.
ANATOMY_SOURCES.ieee32={title:'Oracle Numerical Computation Guide · IEEE single format',url:'https://docs.oracle.com/cd/E19957-01/806-3568/ncg_math.html'};
const anWord=(key,label)=>({...anNum(key,label,0,4294967295),type:'word'});
function anatomyParseUnsignedWord(text){text=String(text).trim();return /^(?:0x[0-9a-f]{1,8}|0b[01]{1,32}|\d{1,10})$/i.test(text)?Number(text):NaN}
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
function anatomyFloat32(bits){
 bits=Number(bits)>>>0;const sign=bits>>>31,exponent=(bits>>>23)&255,fraction=bits&0x7fffff,buffer=new ArrayBuffer(4),view=new DataView(buffer);view.setUint32(0,bits,false);const value=view.getFloat32(0,false);
 const category=exponent===255?(fraction?'NaN':'无穷'):exponent===0?(fraction?'次正规数':'零'):'规格化数';
 const shown=category==='NaN'?'NaN':category==='无穷'?(sign?'−∞':'+∞'):category==='零'?(sign?'−0':'+0'):value;
 return {bits,sign,exponent,fraction,value:shown,category,unbiased:exponent===0?-126:exponent-127};
}
function anatomyFloat32Bits(value){const view=new DataView(new ArrayBuffer(4));view.setFloat32(0,value,false);return view.getUint32(0,false)}
const AN_SEQUENCE_TRANSITIONS=[[0,1],[2,1],[0,3],[2,4],[2,1]];
function anatomySequenceNext(state,input,mode){const next=AN_SEQUENCE_TRANSITIONS[state]?[AN_SEQUENCE_TRANSITIONS[state][0],AN_SEQUENCE_TRANSITIONS[state][1]][input]:0;return mode==='MEALY'&&next===4?1:next}
function anatomyCourseInputChanged(b,s,name){if(name==='seqMode'){s.seqState=0;s.seqHistory='';s.seqHits=0;s.seqLastHit=0}}
plate('wordrepr','位模式 · 同一串位的两种解释',[
 P('IN',null,'port',0,0,'输入位模式'),{...P('BITS',null,'wordbits',0,0,'逐位观察与编辑'),field:'reprBits',widthField:'reprWidth'},P('U',null,'readout',0,0,'按无符号解释'),P('S',null,'readout',0,0,'按补码解释')
],[N('位模式','IN.o','BITS.i',32),N('无符号解释','BITS.u','U.i',32),N('补码解释','BITS.s','S.i',32)],
 [S('先固定一串位','先选 4 位并输入 0xF。位没有自带“正负”含义。',['IN','BITS'],['位模式']),S('比较两种解释','无符号把最高位作为正权重，补码把最高位作为负权重。',['U','S'],['无符号解释','补码解释']),S('只改一位','点击最高有效位，观察两种数值怎样改变。改变解释规则不等于改变位模式。',['BITS','U','S'])],
 {lab:'wordrepr',layer:'数据表示',sources:['logic'],boundary:'观察低 4/8/32 位；输入保留完整 32 位。负数显示的是补码解释，不把它误作有符号十六进制编码。'});
plate('float32','IEEE binary32 · 符号、指数与小数字段',[
 P('IN',null,'port',0,0,'32 位存储编码'),{...P('BITS',null,'floatbits',0,0,'1 位符号 · 8 位指数 · 23 位小数'),field:'floatBits'},P('SIGN',null,'readout',0,0,'符号位 S'),P('EXP',null,'readout',0,0,'存储指数 E'),P('FRAC',null,'readout',0,0,'小数字段 F'),P('VALUE',null,'readout',0,0,'按 binary32 解码的值')
],[N('存储编码','IN.o','BITS.i',32),N('符号','BITS.sign','SIGN.i',1),N('指数','BITS.exp','EXP.i',8),N('小数','BITS.frac','FRAC.i',23),N('浮点数值','BITS.value','VALUE.i',32)],
 [S('把存储位与数值分开','十六进制输入表示原始编码；也可把十进制输入舍入成 binary32。',['IN','BITS']),S('拆开三个字段','存储指数不是直接使用的指数。规格化数使用 E−127，指数为零时另按规则解释。',['SIGN','EXP','FRAC']),S('观察特殊编码','比较正负零、次正规数、无穷和 NaN。NaN 不是一个非常大的有限数。',['VALUE'])],
 {lab:'float32',layer:'数据表示',sources:['ieee32'],boundary:'依据 IEEE binary32 位字段，用 DataView 解码和舍入；十进制输入由双精度数作参照，不模拟浮点运算电路或任意精度实数。'});
plate('alu32','32 位 ALU · 运算、比较与调试标志',[
 P('A',null,'port',0,0,'A[31:0]'),P('B',null,'port',0,0,'B[31:0]'),P('OP',null,'port',0,0,'操作名称'),P('ARITH',null,'adder',0,0,'加法 / 减法'),P('LOGIC',null,'logic',0,0,'按位逻辑'),P('SHIFT',null,'mux',0,0,'移位网络'),P('COMPARE',null,'compare',0,0,'有符号 / 无符号小于'),P('MUX',null,'mux',0,0,'选择结果'),P('OUT',null,'port',0,0,'R[31:0]'),P('FLAGS',null,'flagbank',0,0,'Z / S / C / V 调试标志')
],[N('A操作数','A.o','ARITH.a',32),N('B操作数','B.o','ARITH.b',32),N('逻辑输入','A.o','LOGIC.i',32),N('逻辑B','B.o','LOGIC.b',32),N('移位输入','A.o','SHIFT.a',32),N('移位量低5位','B.o','SHIFT.s',5,'control'),N('比较A','A.o','COMPARE.a',32),N('比较B','B.o','COMPARE.b',32),N('算术候选','ARITH.o','MUX.a',32),N('逻辑候选','LOGIC.o','MUX.b',32),N('移位候选','SHIFT.o','MUX.shift',32),N('比较候选','COMPARE.o','MUX.compare',32),N('操作选择','OP.o','MUX.s',4,'control'),N('结果','MUX.o','OUT.i',32),N('调试标志','MUX.flags','FLAGS.i',4,'control')],
 [S('先看位宽','输入可以使用十进制、0x 十六进制或 0b 二进制；结果按 32 位截断。',['A','B','ARITH'],['A操作数','B操作数']),S('比较解释规则','用 A=FFFFFFFF、B=1 比较 SLT 与 SLTU；再比较 SRA 与 SRL。',['COMPARE','SHIFT','MUX'],['比较候选','移位候选']),S('边界与标志','比较 7FFFFFFF+1 与 FFFFFFFF+1，区分符号溢出和进位。',['OUT','FLAGS'],['结果','调试标志'])],
 {lab:'alu32',layer:'32 位功能模型',sources:['riscv'],boundary:'支持 ADD/SUB/AND/OR/XOR/SLL/SRL/SRA/SLT/SLTU。Z/S/C/V 是本教学接口的调试量，不是 RV32I 架构标志寄存器；SUB 的 C=1 约定为无借位。不计算真实延迟。'});
plate('seq1011','1011 检测器 · 重叠序列与 Moore / Mealy',[
 P('IN',null,'port',0,0,'当前输入位'),P('FSM',null,'sequencegraph',0,0,'前缀状态与转移'),P('OUT',null,'port',0,0,'检测输出'),P('COUNT',null,'readout',0,0,'已采样命中次数')
],[N('输入位','IN.o','FSM.i',1),N('检测输出','FSM.o','OUT.i',1),N('累计命中','FSM.hits','COUNT.i',16)],
 [S('一次只采样一位','先改变输入位，再给一次采样边沿。当前前缀状态表示已匹配的后缀。',['IN','FSM'],['输入位']),S('匹配后继续找','依次采样 1011011，观察能够重叠匹配两次。检测到一次不应丢掉可复用后缀。',['FSM','COUNT'],['累计命中']),S('比较输出时机','Moore 输出取决于保存状态；Mealy 输出还取决于当前输入，可在下一采样边沿前改变。切换形式会重置本实验。',['FSM','OUT'],['检测输出'])],
 {lab:'seq1011',layer:'序列检测实验',sources:['seq'],boundary:'每次操作采样一个输入位，支持重叠 1011。Moore 默认便于观察；Mealy 的当前输出与最近采样命中分别显示，不把组合输出当成已采样事件。'});
anExp('wordrepr',[anChoice('reprWidth','观察位宽',[[4,'4 位'],[8,'8 位'],[32,'32 位']]),anWord('reprBits','输入位模式（十进制 / 0x / 0b）')],[],'只解释当前观察位宽的低位；切换解释不会改写输入位模式。');
anExp('float32',[anWord('floatBits','binary32 原始位模式'),{...anNum('floatInput','待舍入的十进制数',-1e50,1e50),type:'real'}],[['round32','将十进制输入舍入到 binary32']]);
anExp('alu32',[anWord('aluA32','A[31:0]'),anWord('aluB32','B[31:0]'),anChoice('aluOp','运算',['ADD','SUB','AND','OR','XOR','SLL','SRL','SRA','SLT','SLTU'].map(x=>[x,x]))]);
anExp('seq1011',[anBit('a','当前输入'),anChoice('seqMode','输出形式',[['MOORE','Moore：看保存状态'],['MEALY','Mealy：看状态与当前输入']])],[['tick','采样这个位 ↑']]);
const anCourseStateBase=anatomyState;anatomyState=function(){return {...anCourseStateBase(),reprWidth:4,reprBits:15,floatBits:0x3dcccccd,floatInput:.1,aluA32:0x7fffffff,aluB32:1,aluOp:'ADD',seqMode:'MOORE',seqState:0,seqHistory:'',seqHits:0,seqLastHit:0}};
const anCourseEvaluateBase=anatomyEvaluate;anatomyEvaluate=function(id,s){
 const e=anCourseEvaluateBase(id,s);if(!['wordrepr','float32','alu32','seq1011'].includes(id))return e;
 e.watch=[];e.nets={};e.partValues={};const n=(name,v)=>e.nets[name]=v,w=(name,value,why='')=>e.watch.push({name,value:String(value),why});
 if(id==='wordrepr'){
  const width=s.reprWidth,mask=2**width-1,unsigned=(Number(s.reprBits)>>>0)%2**width,signed=unsigned>=2**(width-1)?unsigned-2**width:unsigned;
  e.result=signed;e.led=unsigned;n('位模式',unsigned);n('无符号解释',unsigned);n('补码解释',signed);Object.assign(e.partValues,{IN:unsigned,BITS:unsigned,U:unsigned,S:signed});
  w('观察位串',unsigned.toString(2).padStart(width,'0'),width+' 位，最高位编号 '+(width-1));w('无符号值',unsigned);w('补码值',signed,'最高位权重为 −2^'+(width-1));w('两种解释范围','无符号 0…'+mask+'；补码 '+(-2**(width-1))+'…'+(2**(width-1)-1));
 }else if(id==='float32'){
  const f=anatomyFloat32(s.floatBits);e.result=f.value;e.led=0;n('存储编码',f.bits);n('符号',f.sign);n('指数',f.exponent);n('小数',f.fraction);n('浮点数值',f.value);Object.assign(e.partValues,{IN:f.bits,BITS:f.bits,SIGN:f.sign,EXP:f.exponent,FRAC:f.fraction,VALUE:f.value});
  w('分类',f.category);w('解码值',f.value);w('符号 / 存储指数 / 小数',f.sign+' / '+f.exponent+' / '+f.fraction);w('有效指数',f.exponent===255?'特殊编码':f.unbiased,'E=0 使用 −126，不简单计算 E−127');w('待舍入十进制数',s.floatInput,'点按钮才更新原始位模式');if(typeof f.value==='number')w('与待舍入输入的数值差',f.value-s.floatInput,'双精度输入参照');
 }else if(id==='alu32'){
  const r=anatomyALU32(s.aluA32,s.aluB32,s.aluOp),arith=anatomyALU32(s.aluA32,s.aluB32,s.aluOp==='SUB'?'SUB':'ADD'),logic=anatomyALU32(s.aluA32,s.aluB32,['OR','XOR'].includes(s.aluOp)?s.aluOp:'AND'),shift=anatomyALU32(s.aluA32,s.aluB32,['SRL','SRA'].includes(s.aluOp)?s.aluOp:'SLL'),compare=anatomyALU32(s.aluA32,s.aluB32,s.aluOp==='SLTU'?'SLTU':'SLT');
  e.result=r.value;e.led=r.value;e.flags=r;const flags=r.zero|(r.sign<<1)|(r.carry<<2)|(r.overflow<<3);for(const name of ['A操作数','逻辑输入','移位输入','比较A'])n(name,s.aluA32>>>0);for(const name of ['B操作数','逻辑B','比较B'])n(name,s.aluB32>>>0);n('移位量低5位',s.aluB32&31);n('算术候选',arith.value);n('逻辑候选',logic.value);n('移位候选',shift.value);n('比较候选',compare.value);n('操作选择',s.aluOp);n('结果',r.value);n('调试标志',flags);Object.assign(e.partValues,{A:s.aluA32>>>0,B:s.aluB32>>>0,OP:s.aluOp,ARITH:arith.value,LOGIC:logic.value,SHIFT:shift.value,COMPARE:compare.value,MUX:r.value,OUT:r.value,FLAGS:flags});
  w('运算',s.aluOp);w('无符号结果',r.value);w('补码解释',anatomySigned32(r.value));w('Z / S / C / V',r.zero+' / '+r.sign+' / '+r.carry+' / '+r.overflow,'调试标志；SUB 的 C=1 表示无借位');w('实际移位量',s.aluB32&31,'只取 B 的低 5 位');
 }else{
  const hit=+(s.seqState===3&&s.a===1),output=s.seqMode==='MOORE'?+(s.seqState===4):hit;e.result=output;e.led=output;e.sequence={state:s.seqState,mode:s.seqMode};n('输入位',s.a);n('检测输出',output);n('累计命中',s.seqHits);Object.assign(e.partValues,{IN:s.a,FSM:s.seqState,OUT:output,COUNT:s.seqHits});w('当前前缀',['空','1','10','101','1011'][s.seqState]);w('当前输出',output,s.seqMode==='MOORE'?'只看保存状态':'还看当前输入，可在边沿前变');w('最近采样命中',s.seqLastHit);w('累计命中',s.seqHits);w('已采样位串',s.seqHistory||'尚未采样');
 }
 return e;
};
const anCourseAdvanceBase=anatomyAdvance;anatomyAdvance=function(id,s,action='tick'){
 if(action==='reset')return anCourseAdvanceBase(id,s,action);
 if(id==='float32'&&action==='round32'){s.floatBits=anatomyFloat32Bits(s.floatInput);s.ticks++;return}
 if(id==='seq1011'&&action==='tick'){s.seqLastHit=+(s.seqState===3&&s.a===1);s.seqHits+=s.seqLastHit;s.seqState=anatomySequenceNext(s.seqState,s.a,s.seqMode);s.seqHistory=(s.seqHistory+s.a).slice(-40);s.ticks++;return}
 return anCourseAdvanceBase(id,s,action);
};
if(typeof AN_CONTEXT_ASSOCIATIONS!=='undefined')Object.assign(AN_CONTEXT_ASSOCIATIONS,{wordrepr:'system',float32:'wordrepr',alu32:'cpu',seq1011:'fsm'});
if(typeof anatomyOutputDescriptor==='function'){const base=anatomyOutputDescriptor;anatomyOutputDescriptor=function(b){return ({wordrepr:{name:'补码数值解释',width:null,kind:'interpretation'},float32:{name:'解码出的浮点值',width:null,kind:'real'},alu32:{name:'R[31:0]',width:32},seq1011:{name:'当前检测输出',width:1}})[b.id]||base(b)}}
