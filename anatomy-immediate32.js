'use strict';
const AN_IMMEDIATE32_FORMATS=['I','S','B','U','J'];
// Output-index -> instruction-index, -1 means a hardwired zero.
function anatomyImmediate32Sources(format){return Array.from({length:32},(_,j)=>{
 if(format==='I')return j<12?20+j:31;
 if(format==='S')return j<5?7+j:j<12?20+j:31;
 if(format==='B')return j===0?-1:j<=4?7+j:j<=10?20+j:j===11?7:31;
 if(format==='U')return j<12?-1:j;
 if(format==='J')return j===0?-1:j<=10?20+j:j===11?20:j<20?j:31;
 return -1;
})}
function anatomyImmediate32(instruction,format){const word=Number(instruction)>>>0,sources=anatomyImmediate32Sources(format);let value=0;for(let j=0;j<32;j++)if(sources[j]>=0)value+=((word>>>sources[j])&1)*2**j;return value>>>0}
function anatomyImmediate32Hint(word){return ({3:'I',19:'I',103:'I',35:'S',99:'B',55:'U',23:'U',111:'J'})[word&127]||null}
const AN_IMMEDIATE32_PRESETS=[
 {label:'I：addi x1,x0,−1',immInstruction:0xfff00093,immFormat:'I'},
 {label:'S：sw x1,−16(x2)',immInstruction:0xfe112823,immFormat:'S'},
 {label:'B：beq x1,x2,+8',immInstruction:0x00208463,immFormat:'B'},
 {label:'B：beq x1,x2,−4',immInstruction:0xfe208ee3,immFormat:'B'},
 {label:'U：lui x1,0x12345',immInstruction:0x123450b7,immFormat:'U'},
 {label:'J：jal x1,+2048',immInstruction:0x001000ef,immFormat:'J'},
 {label:'J：jal x1,−4',immInstruction:0xffdff0ef,immFormat:'J'}
];
plate('immgen32','立即数生成 · 指令位到 32 位数值',[
 P('INST',null,'port',0,0,'inst[31:0]'),P('FMT',null,'port',0,0,'I / S / B / U / J'),P('MAP',null,'imm32map',0,0,'重排、补零与符号复制'),P('O',null,'port',0,0,'imm[31:0]')
],[N('指令字','INST.o','MAP.inst',32),N('格式选择','FMT.o','MAP.fmt',3,'control'),N('立即数','MAP.imm','O.i',32)],
 [S('从指令中取位','上排是可点击修改的指令位。彩色位参与当前格式的立即数，灰色位用于其他指令字段。',['INST','FMT','MAP'],['指令字','格式选择']),S('按输出位追踪来源','点击下排任意输出位，追踪它来自哪一指令位；输出只读。B、J 的最低位固定为 0。',['MAP','O'],['立即数']),S('解释符号与补零','I、S、B、J 的高位复制 inst[31]；U 直接保留高 20 位并把低 12 位清零。数值与位模式分开看。',['MAP','O'],['立即数'])],
 {lab:'imm32',layer:'处理器 · 完整 I/S/B/U/J 立即数',sources:['riscv'],boundary:'组合立即数生成器。格式由输入手选，不是完整 Decoder；opcode 只提供格式提示，不验证全部指令合法性。位连线表示对应关系，不是传播动画或物理布线。',question:'为什么 B 格式中的 inst[7] 出现在 imm[11]，而 imm[0] 总是 0？'});
anExp('immgen32',[{...anNum('immInstruction','32 位指令（十进制 / 0x / 0b）',0,4294967295),type:'word'},anChoice('immFormat','观察的立即数格式',AN_IMMEDIATE32_FORMATS.map(v=>[v,v+' 格式']))],[],'可以故意用不同格式解释同一组位。格式不匹配时会提示；不把它当作合法指令执行。');
const anBeforeImm32State=anatomyState;
anatomyState=function(){return {...anBeforeImm32State(),immInstruction:0xfff00093,immFormat:'I'}};
const anBeforeImm32Evaluate=anatomyEvaluate;
anatomyEvaluate=function(id,s){const e=anBeforeImm32Evaluate(id,s);if(id!=='immgen32')return e;const word=s.immInstruction>>>0,format=s.immFormat,value=anatomyImmediate32(word,format),hint=anatomyImmediate32Hint(word),sources=anatomyImmediate32Sources(format),hex=v=>'0x'+v.toString(16).toUpperCase().padStart(8,'0');
 e.result=value;e.led=value&65535;e.partValues={INST:word,FMT:format,MAP:value,O:value};e.nets={'指令字':word,'格式选择':AN_IMMEDIATE32_FORMATS.indexOf(format),'立即数':value};e.imm32={sources,hint,sign:word>>>31};
 e.watch=[{name:'当前格式',value:format,why:hint===format?'opcode 的格式提示匹配；仍不保证整条指令合法':hint?'注意：opcode 提示 '+hint+'，当前按 '+format+' 做位布局比较':'opcode 不在本模块的格式提示范围；仍可观察位映射'},{name:'指令位模式',value:hex(word),why:'上排 32 个位可直接翻转；inst[31]='+String(word>>>31)},{name:'立即数位模式',value:hex(value),why:'无符号 '+value+'；补码 '+anatomySigned32(value)},{name:'立即数二进制',value:value.toString(2).padStart(32,'0'),why:'下排从 bit31 到 bit0，输出位不可直接修改'},{name:'符号与补零',value:format==='U'?'低 12 位补 0':['B','J'].includes(format)?'最低位补 0，高位复制符号':'高位复制符号',why:format==='U'?'inst[31:12] 对应 imm[31:12]':'扩展到 32 位，符号源固定为 inst[31]'},{name:'offset 的含义',value:['B','J'].includes(format)?'带符号字节偏移':'立即数数值',why:['B','J'].includes(format)?'编码含隐含的最低位 0；本模块不执行跳转或检测目标地址异常':'U 是高位立即数；I/S 常用于算术或访存偏移；不在此执行指令'}];return e;
};
AN_CONTEXT_ASSOCIATIONS.immgen32='instruction';
const anBeforeImm32Descriptor=anatomyOutputDescriptor;
anatomyOutputDescriptor=function(b){return b.id==='immgen32'?{name:'imm[31:0] 立即数编码',width:32}:anBeforeImm32Descriptor(b)};
const anBeforeImm32Explain=anatomyExplainObservation;
anatomyExplainObservation=function(b,previous,current){const e=anBeforeImm32Explain(b,previous,current);if(b.id!=='immgen32'||!previous)return e;const s=current.state,word=s.immInstruction>>>0,result=current.evaluation.result,ignored=e.diff.inputs.includes('immInstruction')&&!e.diff.resultChanged;
 e.title=ignored?'指令位改变，立即数可以保持':e.diff.inputs.includes('immFormat')?'同一组指令位，换一种布局解释':'参与立即数的指令位发生变化';
 e.body='当前 '+s.immFormat+' 格式得到 0x'+result.toString(16).toUpperCase().padStart(8,'0')+'，补码解释 '+anatomySigned32(result)+'。'+(ignored?'被修改的位可能不属于当前格式的立即数字段；观察灰色位与彩色位的区别。':s.immFormat==='U'?'高20位直接取自指令，低12位固定为零。':['B','J'].includes(s.immFormat)?'最低位固定为0，高位通过复制 inst[31] 扩展；中间位按格式重排。':'高位由 inst[31]='+String(word>>>31)+' 复制填充。')+' 此处只解释位布局，不执行指令。';return e;
};
ANATOMY_ROUTES.push({name:'一条指令里的偏移藏在哪里',key:'instruction-immediate',prerequisite:'认识指令位号与有符号扩展',goal:'追踪I/S/B/U/J格式的真实位来源',ids:['instruction','immgen32','immediate','alu32'],hints:['先认识 opcode 与寄存器字段；本页不是完整指令执行器','完整 I/S/B/U/J 位拼接，逐个输出位追来源','切到四位到八位的缩小示例，单独理解符号扩展','把生成的立即数显式复制为 ALU 的 B，可继续观察运算']});
