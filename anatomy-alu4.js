'use strict';
const AN_ALU4_OPS=['ADD','SUB','AND','OR','XOR','SHL','SHR','SRA','SLT','SLTU'];
function anatomyALU4(a,b,op){
 a&=15;b&=15;const sa=a>=8?a-16:a,sb=b>=8?b-16:b,shift=b&3;
 const candidates={ADD:(a+b)&15,SUB:(a-b)&15,AND:a&b,OR:a|b,XOR:a^b,SHL:(a<<shift)&15,SHR:a>>>shift,SRA:(sa>>shift)&15,SLT:+(sa<sb),SLTU:+(a<b)};
 const value=candidates[op]??0,arithmetic=op==='ADD'||op==='SUB',wide=op==='SUB'?sa-sb:sa+sb;
 return {value,zero:+(value===0),sign:(value>>>3)&1,arithmetic,carry:arithmetic?+(op==='ADD'?a+b>15:a>=b):null,overflow:arithmetic?+(wide< -8||wide>7):null,shift,candidates};
}
ANATOMY.alu.parts.push(P('CMP','alu32','logic',1,9,'有/无符号比较','展开独立32位比较原理，按4位语义扩展输入；不是此4位单元的网表'));
ANATOMY.alu.nets.push(N('输入→CMP','AB.o','CMP.i',8),N('CMP候选','CMP.o','M.i',4));
for(const step of ANATOMY.alu.steps.slice(0,2)){step.parts.push('CMP');step.nets.push(step===ANATOMY.alu.steps[0]?'输入→CMP':'CMP候选')}
ANATOMY.alu.boundary='四位、十种操作的组合ALU。移位量取B低2位；SLT按4位补码比较，SLTU按无符号比较。Carry只对ADD/SUB有效，SUB时表示无借位；Overflow只对有符号ADD/SUB有效。这里不预测时延、硬件频率或资源。';
anExp('alu',[anNum('av','A 四位模式',0,15),anNum('bv','B 四位模式 / 移位量低2位',0,15),anChoice('op','选择运算',AN_ALU4_OPS.map(x=>[x,x==='SHL'?'SHL / 逻辑左移':x==='SHR'?'SHR / 逻辑右移':x==='SRA'?'SRA / 算术右移':x==='SLT'?'SLT / 有符号小于':x==='SLTU'?'SLTU / 无符号小于':x]))],[],'各候选并行计算，操作码只选择结果。C/V只对算术操作有效；无符号进位与有符号溢出不是同一个标志。');
const anBeforeALU4Eval=anatomyEvaluate;anatomyEvaluate=function(id,s){if(id!=='alu')return anBeforeALU4Eval(id,s);const a=s.av&15,b=s.bv&15,r=anatomyALU4(a,b,s.op),c=r.candidates,logic=s.op==='OR'?c.OR:s.op==='XOR'?c.XOR:c.AND,shift=s.op==='SHR'?c.SHR:s.op==='SRA'?c.SRA:c.SHL,cmp=s.op==='SLTU'?c.SLTU:c.SLT;
 const nets={...Object.fromEntries(['ADD','SUB','LOG','SHIFT','CMP'].map(name=>['输入→'+name,(a<<4)|b])),'ADD候选':c.ADD,'SUB候选':c.SUB,'LOG候选':logic,'SHIFT候选':shift,'CMP候选':cmp,'RESULT':r.value};
 return {result:r.value,led:r.value,digits:[0,0,0,AN_SEG[r.value]],nets,partValues:{AB:(a<<4)|b,ADD:c.ADD,SUB:c.SUB,LOG:logic,SHIFT:shift,CMP:cmp,M:r.value,O:r.value},watch:[{name:'操作 / A / B',value:s.op+' / '+a+' / '+b,why:'A/B为四位原始模式；每条8位输入总线高4位A、低4位B'},{name:'输出模式 / 无符号 / 补码',value:r.value.toString(2).padStart(4,'0')+' / '+r.value+' / '+(r.value>=8?r.value-16:r.value),why:'相同结果位模式可有不同数值解释'},{name:'Zero / Sign',value:r.zero+' / '+r.sign,why:'对当前选中的结果有效'},{name:'Carry / Overflow',value:r.arithmetic?r.carry+' / '+r.overflow:'不适用 / 不适用',why:r.arithmetic?(s.op==='SUB'?'Carry=无借位；Overflow=有符号超出-8…7':'Carry=无符号进位；Overflow=有符号超出-8…7'):'逻辑/移位/比较不提供本实验C/V标志'},{name:'移位量 / 比较语义',value:String(r.shift)+' / '+(s.op==='SLTU'?'无符号':'SLT使用补码'),why:'移位量为B低2位；SRA复制符号位，SHR补零'}],flags:r};
};
function anatomyALU4Markup(b,s){if(b.id!=='alu')return '';const a=s.av&15,z=s.bv&15,r=anatomyALU4(a,z,s.op),sa=a>=8?a-16:a,sb=z>=8?z-16:z,subtract=s.op==='SUB';return '<section class="an-alu4-flags"><h4>进位与溢出分开看</h4><div><span>Zero <b>'+r.zero+'</b></span><span>Sign <b>'+r.sign+'</b></span><span>Carry <b>'+(r.arithmetic?r.carry:'—')+'</b></span><span>Overflow <b>'+(r.arithmetic?r.overflow:'—')+'</b></span></div><p>'+(r.arithmetic?'无符号精确算式：'+a+(subtract?' − ':' + ')+z+' = '+(subtract?a-z:a+z)+'；C表示'+(subtract?'无借位':'超出四位的进位')+'。<br>补码精确算式：'+sa+(subtract?' − ('+sb+')':' + ('+sb+')')+' = '+(subtract?sa-sb:sa+sb)+'；V表示是否超出−8…7。':'当前不是ADD/SUB，C/V不适用。Zero和Sign仍描述当前四位结果。')+'</p><a href="labs/lab05-alu4.zip" download>下载十操作 Chisel ALU、测试与波形 ↓</a></section>'}
