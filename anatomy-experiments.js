'use strict';
// Per-level experiments. Digital models are deterministic; analog/material views are explicitly qualitative.
const AN_EXPERIMENTS={};
const anNum=(key,label,min=0,max=15)=>({key,label,min,max,type:'number'});
const anBit=(key,label)=>({key,label,type:'toggle'});
const anChoice=(key,label,options)=>({key,label,type:'select',options});
const anExp=(ids,fields,actions=[],note='')=>{for(const id of ids.split(' '))AN_EXPERIMENTS[id]={fields,actions,note}};
anExp('truth2',[anBit('a','测试输入A'),anBit('b','测试输入B'),anNum('truthMask','四位函数表（bit0对应00）',0,15)],[],'改函数表定义函数；改A/B测试输入。均为组合重算，不产生时钟。');
anExp('demorganNand demorganNor',[anBit('a','输入A'),anBit('b','输入B')],[],'两条电路共享同一输入；改变输入只触发组合重算，不产生时钟。');
anExp('tageq5',[anNum('av','请求TAG（五位）',0,31),anNum('bv','保存TAG（五位）',0,31)],[],'所有五位相同才EQ=1；本层不检查VALID，也不推进缓存。');
anExp('cachecheck',[anNum('av','请求TAG（五位）',0,31),anNum('bv','保存TAG（五位）',0,31),anBit('enable','保存VALID')],[],'HIT要求五位TAG全部相等且有效；组合判断不推进缓存。');
anExp('dotselect',[anNum('av','四位小数点请求',0,15),anNum('bv','当前AN编号',0,3)],[],'请求位1表示希望亮；共享dp低有效，实际发光还需位选。');
anExp('compare10',[anNum('cmp10A','十位无符号A',0,1023),anNum('cmp10B','十位无符号B',0,1023)],[],'最高不同位决定大小；组合级联不是十个时间拍。');
anExp('comparebit',[anBit('cmpBitA','当前位A'),anBit('cmpBitB','当前位B'),anBit('cmpPrefixEq','高位仍相等EQin'),anBit('cmpPrefixLt','高位已小于LTin')],[],'完整比较的合法EQ/LT前缀为1/0、0/1或0/0；1/1只是手动门真值组合。');
anExp('hsync',[anNum('timingX','局部横坐标X（十位无符号）',0,1023)],[],'组合判断，不需要时钟；只改变本层副本，实际扫描横范围仍是0…799。');
anExp('vsync',[anNum('timingY','局部纵坐标Y（十位无符号）',0,1023)],[],'组合判断，不需要时钟；只改变本层副本，实际扫描纵范围仍是0…520。');
anExp('visiblearea',[anNum('timingX','局部横坐标X',0,1023),anNum('timingY','局部纵坐标Y',0,1023)],[],'两个无符号比较与一个与门；局部坐标不反写上级扫描，ACTIVE不是流水VALID。');
anExp('packageView',[anNum('data','引脚输入字节',0,255),anBit('enable','引脚连接有效')],[],'仅演示封装的信号连接，不模拟封装寄生参数。');
anExp('clb',[anNum('av','Slice 输入 A'),anNum('bv','Slice 输入 B'),anBit('cin','输入进位')]);
anExp('carry4',[anNum('av','S[3:0] 传播选择'),anNum('bv','DI[3:0] 数据'),anBit('cin','CI')]);
anExp('iobank',[anBit('a','外部输入电平'),anBit('data','内部输出位'),anBit('we','内部输出使能'),anBit('extDrive','外部驱动使能')],[],'使能关闭为 Z；两个驱动电平冲突时标 X。理想数字模型，不计算电流。');
anExp('dsp',[anNum('av','乘数 A'),anNum('bv','乘数 B'),anBit('enable','累加使能')],[['tick','乘加边沿 ↑']],'16 位缩小乘加器，边沿执行 Q ← Q + A×B。');
anExp('pc',[anBit('enable','PC 写使能'),anBit('take','选择跳转'),anNum('target','跳转目标',0,252)],[['tick','更新 PC ↑']]);
anExp('instruction',[anNum('pc','取指地址',0,252),anNum('instruction','32 位指令（十进制）',0,4294967295)],[],'字段拆分采用 RV32 格式；不表示本例已实现完整指令集。');
anExp('loadstore',[anNum('av','基址',0,7),anNum('bv','偏移',0,7),anNum('data','待写字节',0,255),anBit('signExtend','有符号扩展')],[['store','写入这一字节'],['load','执行读取']],'16 字节缩小存储；显示字节所在的四字节字与字节使能。');
anExp('pipeline',[anNum('data','送入流水线的字节',0,255),anBit('stall','暂停保持'),anBit('flush','清空 / 冲刷')],[['tick','推进一个边沿 ↑']],'四级数据流教学模型：暂停保持全部级，冲刷清空全部级。');
anExp('forward',[anNum('r0','源寄存器',0,7),anNum('exRd','EX/MEM 目的',0,7),anNum('memRd','MEM/WB 目的',0,7),anBit('exWe','EX/MEM 写使能'),anBit('memWe','MEM/WB 写使能'),anNum('av','EX/MEM 值',0,255),anNum('bv','MEM/WB 值',0,255),anNum('data','寄存器原值',0,255)],[],'同时命中时选择较新的 EX/MEM；目的寄存器 0 不前递。');
anExp('hazard',[anBit('isLoad','前级为 LOAD'),anNum('exRd','前级目的',0,7),anNum('r0','后级源',0,7),anBit('valid','前级有效'),anBit('flush','分支冲刷')],[],'演示一个源操作数的 load-use 检测，暂停和冲刷分别观察。');
anExp('branch',[anNum('av','比较 A'),anNum('bv','比较 B'),anBit('enable','允许相等分支'),anNum('offset','字节偏移',-32,32)],[['tick','提交下一 PC ↑']],'演示相等分支：不跳转时 PC+4，跳转时 PC+偏移。');
anExp('input',[anBit('a','原始引脚')],[['tick','采样边沿 ↑']],'两级同步后做连续 3 次稳定采样和上升沿检测。');
anExp('memorySystem',[anNum('addr','字节地址',0,15),anNum('data','待写字节',0,255)],[['access','访问 / 缺失回填'],['write','写后备存储并失效缓存']],'4 行、每行 2 字节；手动访问显示本次命中和读出，不模拟真实延迟。');
anExp('dram dramcell',[anBit('a','待写位'),anBit('enable','字线 WL')],[['write','写入（WL=1）'],['refresh','刷新'],['wait','等待一次']],'保持时间缩小为 8 个教学等待步骤，超时显示 X；不是实际电压或时间模型。');
anExp('flash',[anNum('addr','地址',0,7),anNum('data','编程数据',0,255)],[['program','编程 1→0'],['erase','擦除整个示例块']],'8 字节缩小 Flash：编程只能把 1 改为 0，擦除恢复 FF。');
anExp('config programming',[anBit('a','待下载配置位')],[['download','下载当前配置'],['save','保存到 Flash'],['power','断电 / 上电']],'上电后可从本演示保存的 Flash 配置启动；复位演示会清除全部示例状态。');
anExp('usbtransport',[anBit('connected','设备接入'),anNum('byte','事务字节',0,255)],[['enumerate','完成枚举'],['transfer','提交一次事务']],'仅演示接入→枚举→有效事务，不模拟 USB 电气或完整协议。');
anExp('regulator',[anNum('pct','输入归一化幅值 %',0,100),anNum('duty','占空比 /16',0,16)],[['tick','推进开关相位']],'理想稳态目标为输入×占空比；电容条用教学渐近步骤表示趋近，不用于电源设计。');
anExp('rx',[anBit('a','RX 线电平')],[['tick','采样一个位周期']],'手动送入 8N1：低起始位，8 位低位先发，再送高停止位；不模拟过采样或亚稳态。');
anExp('hidparser',[anNum('key','报告键码',0,255),anBit('pressed','报告为按下')],[['tick','提交报告']],'报告变化时产生按下或松开事件，重复报告不重复产生事件。');
anExp('baud clock',[anChoice('baud','目标波特率',[[9600,'9600'],[115200,'115200']])],[['tick','推进一个教学计数']],'主时钟按 100 MHz，整数分频；教学单步不代表浏览器按该频率运行。');
const anStateBase=anatomyState;
anatomyState=function(){return {...anStateBase(),divide4:null,multiply4:null,reg8Q:0,reg8Last:null,uartAsync:anatomyAsyncRXState(),baudTX:null,fifoTX:null,uartLoop:null,dramTrace:[],flashLast:null,memoryAccess:null,memoryLastRead:null,fifoAutoRead:1,fifoText:{draft:'Hi',bytes:[],index:0},fifoProbe:null,fifoMem:Array(4).fill(0),fifoRead:0,fifoWrite:0,fifoCount:0,fifoPush:1,fifoPop:0,fifoLast:null,btnMask:0,addrB:1,dataB:99,weB:0,readB:0,bramCollision:0,opType:0,sliceQ:Array(8).fill(0),extDrive:0,take:0,target:16,pc:0,instruction:0x002081b3,signExtend:0,stall:0,flush:0,exRd:3,memRd:4,exWe:1,memWe:1,isLoad:1,valid:1,offset:8,pipe:[0,0,0,0],pipeValid:[0,0,0,0],mainMem:Array(16).fill(0),memoryCache:Array.from({length:4},()=>({valid:0,tag:0,bytes:[0,0]})),lastHit:0,lastRead:0,chargeBit:0,chargeAge:0,chargeValid:1,flashBytes:Array(8).fill(255),configBit:0,configValid:0,savedConfig:null,connected:0,enumerated:0,usbByte:0,usbValid:0,outputLevel:0,rxPhase:-1,rxCount:0,rxData:0,rxValid:0,rxError:0,previousKey:0,keyEvent:0};};
function anCarry(s){let c=s.cin,cs=[],sum=0;for(let i=0;i<4;i++){const si=(s.av>>i)&1,di=(s.bv>>i)&1;sum|=(si^c)<<i;c=si?c:di;cs.push(c)}return {cs,sum,carry:c}}
function anForward(s){const ex=s.exWe&&s.exRd!==0&&s.exRd===s.r0,mem=s.memWe&&s.memRd!==0&&s.memRd===s.r0;return {select:ex?2:mem?1:0,value:ex?s.av:mem?s.bv:s.data}}
function anPin(s){const internal=s.we?s.data&1:null,external=s.extDrive?s.a:null;return internal===null?(external===null?'Z':external):external===null||internal===external?internal:'X'}
const anEvalBase=anatomyEvaluate;
anatomyEvaluate=function(id,s){
 const e=anEvalBase(id,s),b=ANATOMY[id],lab=b.lab||id,n=(name,v)=>e.nets[name]=v,w=(name,value,why='')=>e.watch.push({name,value:String(value),why}),out=(v)=>{e.result=v;e.led=typeof v==='number'?v:0},spec=AN_EXPERIMENTS[id];
 if(spec){e.watch=[];
 switch(id){
 case 'adccore':case 'xadc':{const p=anatomyADCPlan(s);out(Math.floor(s.adcSamples.reduce((a,b)=>a+b,0)/4));n('模拟输入',s.pct+'%');n('数字码',p.code);n('转换有效',s.adcValid);n('样本',s.adcSample);n('样本有效',s.adcSampleValid);n('滤波输出',e.result);w('当前量化候选',p.code,'输入改变只更新候选');w('保存样本 / 有效',s.adcSample+' / '+s.adcSampleValid,'采样寄存器的边沿后状态');w('滤波窗口',s.adcSamples.join('、'),'最近已接收样本，不足四点用初始零填充');w('滤波输出',e.result,'四点和除4，向下取整');w('滤波已接收数',s.adcFilterCount);break;}
 case 'truth2':{const p=anatomyTruth2Plan(s);out(p.output);n('A取反',s.a);n('B取反',s.b);for(let i=0;i<4;i++){n('m'+i+'的A条件',i&2?s.a:1-s.a);n('m'+i+'的B条件',i&1?s.b:1-s.b);n('最小项'+i,+(p.row===i));n('配置位'+i,(s.truthMask>>>i)&1);n('启用支路'+i,+(p.row===i)*((s.truthMask>>>i)&1));}n('低两项',p.row<2?p.output:0);n('高两项',p.row>=2?p.output:0);n('最终Y',p.output);w('表中当前行',p.row.toString(2).padStart(2,'0'));w('最小项表达式',p.expression);w('两变量化简式',p.simplified);w('Y',p.output);break;}
 case 'demorganNand':case 'demorganNor':{const nand=id==='demorganNand',left=nand?1-(s.a&s.b):1-(s.a|s.b),right=nand?((1-s.a)|(1-s.b)):((1-s.a)&(1-s.b));out(left);n('A到原式',s.a);n('B到原式',s.b);n('A到取反',s.a);n('B到取反',s.b);n('反相A',1-s.a);n('反相B',1-s.b);n('原式结果',left);n('变换式结果',right);w('原式输出',left);w('变换式输出',right);w('本组输入相同',+(left===right));break;}
 case 'tageq5':{out(+(s.av===s.bv));for(let i=0;i<5;i++){n('请求位'+i,(s.av>>>i)&1);n('保存位'+i,(s.bv>>>i)&1);n('不同位'+i,((s.av^s.bv)>>>i)&1);n('相同位'+i,1-(((s.av^s.bv)>>>i)&1));}n('低两位相等',+((s.av&3)===(s.bv&3)));n('中两位相等',+((s.av&12)===(s.bv&12)));n('低四位相等',+((s.av&15)===(s.bv&15)));n('五位相等',e.result);w('请求/保存TAG',s.av+' / '+s.bv);w('不同位掩码',s.av^s.bv);w('EQ',e.result,'五位全相同才为1；不含有效位');break;}
 case 'cachecheck':{const equal=+(s.av===s.bv);out(equal&s.enable);n('请求标签',s.av);n('保存标签',s.bv);n('标签相等',equal);n('行有效',s.enable);n('命中结果',e.result);w('五位请求/保存',s.av+' / '+s.bv);w('标签相等',equal);w('VALID',s.enable);w('HIT',e.result,'相等且有效才命中');break;}
 case 'dotselect':{const low=(s.av>>>(s.bv&1))&1,high=(s.av>>>(2+(s.bv&1)))&1,selected=(s.av>>>s.bv)&1;out(1-selected);for(let i=0;i<4;i++)n('请求'+i,(s.av>>>i)&1);n('低组选择',s.bv&1);n('高组选择',s.bv&1);n('低组候选',low);n('高组候选',high);n('最终选择',s.bv>>>1);n('当前位请求',selected);n('低有效dp',e.result);w('编号',s.bv);w('选中请求',selected);w('共享dp',e.result,'0请求亮；AN关闭时仍不发光');break;}
 case 'transmission':{out(s.enable?s.a:'Z');n('D至NMOS',s.a);n('D至PMOS',s.a);n('使能至NMOS',s.enable);n('使能反相输入',s.enable);n('互补使能',1-s.enable);n('NMOS输出支路',e.result);n('PMOS输出支路',e.result);e.switches={N:s.enable,P:s.enable};w('输入D',s.a);w('EN / 互补EN',s.enable+' / '+(1-s.enable));w('输出Y',e.result,s.enable?'两条理想开关接通，Y跟随D':'两条开关断开，本层无其他驱动');break;}
 case 'decoder3':{const a=s.av&7;out(1<<a);n('低两位地址',a&3);n('最高位',a>>>2);for(let i=0;i<8;i++){n('低位匹配'+i,+((a&3)===(i&3)));n('高位条件'+i,i<4?1-(a>>>2):a>>>2);n('字线'+i,+(a===i))}w('三位地址',a.toString(2).padStart(3,'0'));w('八路字线',(1<<a).toString(2).padStart(8,'0'),'高有效；恰好一条，不包含写使能');break;}
 case 'divideShift':{const t=(s.av<<1)|(s.bv>>>3),shift=(s.bv<<1)&15;out(t);for(let i=0;i<4;i++)n('R'+i+'接到T'+(i+1),(s.av>>>i)&1);n('Q3接到T0',(s.bv>>>3)&1);for(let i=0;i<3;i++)n('Q'+i+'接到S'+(i+1),(s.bv>>>i)&1);n('常量0接到S0',0);w('五位T',t,'T[4:1]=R，T[0]=Q[3]');w('先补0的S',shift,'S[3:1]=Q[2:0]，S[0]=0；最终商位由上级决定');break;}
 case 'restore5':{const value=s.cin?s.av:s.bv;out(value);for(let i=0;i<5;i++){n('原值位'+i,(s.av>>>i)&1);n('试减位'+i,(s.bv>>>i)&1);n('借位'+i,s.cin);n('结果位'+i,(value>>>i)&1)}w('借位',s.cin,'1恢复原值，0保留差');w('选择结果',value,'组合候选，尚未保存');break;}
 case 'divide4':{const m=s.divide4||{q:0,r:0,d:0,k:0,zero:false},p=anatomyDivide4Plan(s);out(m.zero?'ERR':m.q);e.operation='SUB';n('旧余数',m.r);n('被除数下一位',(m.q>>>3)&1);n('移入后余数',p.shifted);n('恢复时原值',p.shifted);n('捕获除数',m.d);n('试减低5位',p.trial);n('无借位',+p.ok);n('下一余数候选',p.nextR);n('本轮商位',p.qbit);n('商工作值',m.q);n('保存余数',m.r);n('完成标志',+(!!s.divide4&&(m.zero||m.k===4)));n('除零错误',+m.zero);w('已提交轮数',m.k+' / 4');w('状态',m.zero?'除零：无有效商余数':m.k===4?'商余数有效':s.divide4?'运行中，Q只是工作位':'尚未装载');w('移入 / 试减整数差',p.shifted+' / '+p.difference,'五位临时试减，低5位编码与借位一起解释');w('下一Q / R候选',p.nextQ+' / '+p.nextR);if(s.divide4&&!m.zero){w('已处理被除数前缀',m.inputA>>>(4-m.k));w('Q中已生成商段',m.q&((1<<m.k)-1),m.k===4?'已成为完整商':'低'+m.k+'位，后续仍会左移')}break;}
 case 'multiply4':{const m=s.multiply4||{a:0,b:0,p:0,k:0},active=!!s.multiply4&&m.k<4,candidate=active?m.p+((m.b&1)?m.a:0):m.p;out(m.p);n('左移被乘数',m.a);n('乘数最低位',m.b&1);n('部分积反馈',m.p);n('下一部分积候选',candidate);n('保存乘积',m.p);n('完成标志',+(!!s.multiply4&&m.k===4));w('已执行轮数',m.k+' / 4');w('条件',active?'B0='+(m.b&1)+'，'+((m.b&1)?'相加':'保持'):'未装载或已完成');w('下一部分积候选',candidate,'等待下一轮边沿提交');break;}
 case 'registerControl':{const mid=s.enable?s.a:s.b,final=s.reset?0:mid;out(final);n('原始D',s.a);n('保存反馈',s.b);n('使能选择',s.enable);n('CE后候选',mid);n('清零常量',0);n('复位选择',s.reset);n('最终候选',final);w('CE后候选',mid);w('最终待采样D',final,'候选变化不等于已经保存');break;}
 case 'register8':{out(s.reg8Q);for(let i=0;i<8;i++){n('D'+i,(s.av>>>i)&1);n('候选'+i,(anatomyRegister8Next(s)>>>i)&1);n('反馈'+i,(s.reg8Q>>>i)&1);n('CE'+i,s.enable);n('RESET'+i,s.reset);n('Q'+i,(s.reg8Q>>>i)&1);n('控制'+i,s.ticks&1)}w('输入 D',s.av);w('已保存 Q',s.reg8Q);w('下一有效边沿候选',anatomyRegister8Next(s),'RESET优先，CE关闭时保持');break;}
 case 'asyncrx':{const r=s.uartAsync;out(r.data);n('原始RX',s.a);n('同步RX',r.second);n('采样计数',r.timer);n('组装值',r.shift);n('保存字节',r.data);n('有效帧',r.valid);w('采样序号',r.samples);w('第一级 / 第二级',r.first+' / '+r.second);w('状态 / 等待计数',r.phase+' / '+r.timer);w('组装值 / 完成字节',r.shift+' / '+r.data);w('valid / 帧错误',r.valid+' / '+r.error,'只在对应采样产生，下一采样清除');w('拒绝的短起始候选',r.falseStarts);break;}
 case 'fifo':{const p=anatomyFIFOPlan(s);out(s.fifoCount);n('写数据',s.data);n('读地址',s.fifoRead);n('写地址',s.fifoWrite);n('队首',s.fifoCount?s.fifoMem[s.fifoRead]:'X');n('占用',s.fifoCount);const link=s.fifoTX,tx=link?.tx,rx=link?.rx,q=link?.rxFIFO;n('待捕获队首',s.fifoCount?s.fifoMem[s.fifoRead]:'X');n('实际串行位',tx&&tx.uartIndex>=0?anatomyUARTFrame(tx)[tx.uartIndex]:1);n('接收组装字节',rx?.rxData??0);n('接收队首',q?.fifoCount?q.fifoMem[q.fifoRead]:'X');w('占用 / 容量',s.fifoCount+' / 4');w('当前队首',s.fifoCount?s.fifoMem[s.fifoRead]:'无有效数据');w('下一边沿接受 写 / 读',+p.push+' / '+ +p.pop,'空时同拍读写只写入；满时可读腾位置并写入');w('上次实际读出',s.fifoLast?.pop?s.fifoLast.value:'本拍未读出');break;}
 case 'segmentdecode':{const digit=s.av&15,seg=(~AN_SEG[digit])&127;out(seg);n('数字地址',digit);n('低有效段码',seg);w('输入数字',digit.toString(16).toUpperCase());w('seg[6:0]',seg.toString(2).padStart(7,'0'),'低有效：0 点亮相应段');w('点亮的段',Array.from('abcdefg').filter((_,i)=>AN_SEG[digit]&(1<<i)).join(' '));break;}
 case 'packageView':out(s.enable?s.data:'Z');w('封装外部输入',s.data);w('硅片端接收',e.result,s.enable?'理想连接有效':'本演示关闭连接，内部无驱动');break;
 case 'clb':{const sum=s.av+s.bv+s.cin;out(sum&15);n('通用互连→Slice0',s.av+'/'+s.bv);n('通用互连→Slice1',s.av+'/'+s.bv);n('Slice0进位',s.cin);n('Slice1进位',sum>>4);w('输入 A / B / CI',s.av+' / '+s.bv+' / '+s.cin);w('低四位 / 进位',e.result+' / '+(sum>>4),'演示两个 Slice 的资源协作，不是固定的 CLB 功能');break;}
 case 'carry4':{const c=anCarry(s);out(c.sum);n('S与DI',s.av+'/'+s.bv);for(let i=0;i<3;i++)n('级联'+i,c.cs[i]);n('CO3',c.carry);w('O[3:0]',c.sum.toString(2).padStart(4,'0'));w('CO[3:0]',c.cs.slice().reverse().join(''));w('最后进位',c.carry,'COi = Si ? CIi : DIi；Oi = Si XOR CIi');break;}
 case 'iobank':{const pin=anPin(s);out(pin);n('输入采样',pin);n('内部输入',pin);n('输出数据',s.data&1);n('引脚驱动',s.we?s.data&1:'Z');n('三态T',1-s.we);w('内部驱动',s.we?s.data&1:'Z');w('外部驱动',s.extDrive?s.a:'Z');w('引脚 / 输入采样',pin,pin==='X'?'两个理想驱动冲突':pin==='Z'?'两个驱动都关闭':'输入缓冲观察引脚');break;}
 case 'bram':out(s.readQ);n('端口A',s.addr);n('端口B',s.addrB);n('读出A',s.readQ);n('读出B',s.readB);w('A: 地址 / 待写 / WE',s.addr+' / '+s.data+' / '+s.we);w('B: 地址 / 待写 / WE',s.addrB+' / '+s.dataB+' / '+s.weB);w('同步读 A / B',s.readQ+' / '+s.readB,'本例两个端口均读边沿前的旧值');w('双写冲突',s.bramCollision?'同址不同值：读出 X，存储保留旧值':'无');break;
 case 'dsp':out(s.q);n('操作数',s.av+'/'+s.bv);n('积',s.av*s.bv);n('结果',(s.q+s.av*s.bv)&65535);n('累加反馈',s.q);w('乘积',s.av*s.bv);w('已保存累加值',s.q,'输入改变只改变候选结果，点击边沿才保存');break;
 case 'pc':{const next=s.take?s.target:s.pc+4;out(s.pc);n('当前地址',s.pc);n('顺序地址',s.pc+4);n('跳转地址',s.target);n('下一地址',next);w('当前 PC',s.pc);w('候选下一 PC',next,s.enable?'下一边沿写入':'使能关闭，边沿保持');break;}
 case 'instruction':{const ins=s.instruction>>>0;out(ins&127);n('地址',s.pc);n('控制字段','opcode='+ (ins&127)+', funct3='+((ins>>>12)&7));n('寄存器字段','rs1='+((ins>>>15)&31)+', rs2='+((ins>>>20)&31)+', rd='+((ins>>>7)&31));n('立即数字段',ins>>>20);w('指令 HEX','0x'+ins.toString(16).padStart(8,'0'));w('opcode / funct3 / funct7',(ins&127)+' / '+((ins>>>12)&7)+' / '+(ins>>>25));w('rs1 / rs2 / rd',((ins>>>15)&31)+' / '+((ins>>>20)&31)+' / '+((ins>>>7)&31));w('I 型原始高12位',ins>>>20,'字段观察，具体格式由指令种类决定');break;}
 case 'loadstore':{const addr=s.av+s.bv,v=s.mainMem[addr],wordBase=addr&~3;out(s.signExtend&&v&128?v-256:v);n('基址',s.av);n('有效地址',addr);n('低地址位',addr&3);n('字节使能',1<<(addr&3));n('读数据',v);w('有效字节地址',addr);w('字节使能',(1<<(addr&3)).toString(2).padStart(4,'0'));w('当前存储字节',v);w('最近执行读取',s.lastRead);w('读出扩展',e.result,s.signExtend?'8 位有符号扩展':'零扩展');w('所在四字节字',s.mainMem.slice(wordBase,wordBase+4).map(v=>v.toString(16).padStart(2,'0')).reverse().join(''));break;}
 case 'pipeline':out(s.pipe[3]);for(let i=0;i<3;i++)n('阶段数据'+i,s.pipeValid[i]?s.pipe[i]:'气泡');n('依赖信息',s.pipeValid[1]?s.pipe[1]:'气泡');n('暂停',s.stall);n('结果前递',s.pipe[2]);n('前递操作数',s.pipe[2]);w('各级数据',s.pipe.map((v,i)=>s.pipeValid[i]?v:'—').join(' → '));w('有效位',s.pipeValid.join(''));w('末级输出',s.pipeValid[3]?s.pipe[3]:'无有效数据');break;
 case 'forward':{const f=anForward(s);out(f.value);n('编号',s.r0+'/'+s.exRd+'/'+s.memRd);n('命中选择',f.select);n('候选结果',s.av+'/'+s.bv+'/'+s.data);w('选择来源',['寄存器原值','MEM/WB','EX/MEM'][f.select]);w('送往操作数',f.value);break;}
 case 'hazard':{const stall=+(s.isLoad&&s.valid&&s.exRd!==0&&s.exRd===s.r0);out(stall);n('相关条件',stall);n('保持PC',stall);n('气泡 / 清空',s.flush||stall?1:0);w('暂停请求',stall);w('PC 写使能',1-stall);w('冲刷请求',s.flush,'与暂停分别控制');w('后级有效',s.flush||stall?0:1);break;}
 case 'branch':{const take=+(s.enable&&s.av===s.bv),next=take?s.pc+s.offset:s.pc+4;out(next);n('是否跳转',take);n('目标地址',s.pc+s.offset);n('下一PC',next);w('当前 PC',s.pc);w('相等 / 采用跳转',+(s.av===s.bv)+' / '+take);w('候选下一 PC',next,'点击边沿才提交');break;}
 case 'input':out(s.keyEvent);n('输入',s.a);n('同步值',s.s2);n('稳定值',s.stable);n('单周期事件',s.keyEvent);w('原始 / 同步1 / 同步2',s.a+' / '+s.s1+' / '+s.s2);w('连续稳定次数',s.consecutive);w('稳定值 / 上升事件',s.stable+' / '+s.keyEvent);break;
 case 'memorySystem':{const idx=(s.addr>>1)&3,entry=s.memoryCache[idx],hit=entry.valid&&entry.tag===(s.addr>>3);out(s.lastRead);n('处理器访问',s.addr);n('片上后备存储',s.addr);n('装载配置/程序','本例未加载');n('可选主存访问',s.addr);w('本次请求当前会命中',+!!hit);w('上次访问命中',s.lastHit);w('上次返回字节',s.lastRead);w('后备存储当前字节',s.mainMem[s.addr]);w('缓存行 / tag',idx+' / '+(s.addr>>3));break;}
 case 'dram':case 'dramcell':{const value=s.chargeValid?s.chargeBit:'X';out(s.enable?value:'Z');n('位线访问',s.a);n('电荷节点',value);n('字线栅极',s.enable);n('参考极板','Vplate');n('字线',s.enable);n('微弱位线',s.enable?value:'Z');n('恢复写回',value);n('刷新请求',s.chargeAge>=6?1:0);w('保存位',value);w('剩余保持步骤',Math.max(0,8-s.chargeAge),'8 步为人为缩小的教学期限');w('字线读出',e.result,s.enable?'字线打开':'字线关闭，位线不由本单元驱动');break;}
 case 'flash':out(s.flashBytes[s.addr]);n('命令地址',s.addr);n('阵列地址',s.addr);n('读数据',e.result);n('串行返回',e.result);w('读出字节','0x'+e.result.toString(16).padStart(2,'0'));w('待编程数据','0x'+s.data.toString(16).padStart(2,'0'));w('块内容',s.flashBytes.map(v=>v.toString(16).padStart(2,'0')).join(' '));break;
 case 'config':case 'programming':out(s.powered&&s.configValid?s.configBit:'未配置');n('下载位流',s.a);n('启动读取',s.savedConfig===null?'空':s.savedConfig);n('装载配置位',e.result);w('电源 / DONE',s.powered+' / '+(s.powered&&s.configValid?1:0));w('当前有效配置',e.result);w('Flash 配置',s.savedConfig===null?'空':s.savedConfig);e.power=!!s.powered;e.done=!!(s.powered&&s.configValid);break;
 case 'usbtransport':out(s.connected&&s.enumerated&&s.usbValid?s.usbByte:'无有效数据');n('接入信息',s.connected);n('配置状态',s.connected&&s.enumerated?1:0);n('数据事务',s.byte);n('有效数据',e.result);w('设备状态',!s.connected?'未接入':s.enumerated?'已枚举':'待枚举');w('接收有效',s.usbValid&&s.connected?1:0);w('已接收数据',s.usbValid&&s.connected?s.usbByte:'—');break;
 case 'regulator':{const gate=+(s.phase<s.duty),target=s.pct*s.duty/16;out(s.outputLevel);n('输入',s.pct+'%');n('开关节点',gate?s.pct+'%':'0%');n('滤波输出',s.outputLevel.toFixed(1)+'%');n('储能滤波',s.outputLevel.toFixed(1)+'%');n('反馈电压',s.outputLevel.toFixed(1)+'%');n('占空控制',gate);n('电容回流',0);w('相位 / 开关',s.phase+' / '+gate);w('理想稳态目标',target.toFixed(1)+'%');w('输出趋势',s.outputLevel.toFixed(1)+'%','每次演示步趋近目标的 1/4，不是电路时间常数');break;}
 case 'rx':out(s.rxData);n('原始RX',s.a);n('理想采样位',s.a);n('起始检测',s.rxPhase<0?+(s.a===0):0);n('采样使能',+(s.rxPhase>=0&&s.rxPhase<8||s.rxPhase<0&&s.a===0));n('组装字节',s.rxData);n('接收有效',s.rxValid);n('帧错误',s.rxError);w('接收阶段',s.rxPhase<0?'等待起始位':s.rxPhase<8?'数据位 d'+s.rxPhase:'停止位');w('已组装字节',s.rxData);w('有效 / 帧错误',s.rxValid+' / '+s.rxError);break;
 case 'hidparser':{const key=s.pressed?s.key:0;out(s.keyEvent);n('当前键',key);n('上一键',s.previousKey);n('按下/松开',s.keyEvent);n('记住报告',key);w('本次报告 / 已保存报告',key+' / '+s.previousKey);w('上次提交事件',s.keyEvent===1?'按下':s.keyEvent===2?'松开':'无新事件');break;}
 case 'baud':case 'clock':{const divisor=Math.max(1,Math.round(1e8/s.baud));out(+(s.ticks%divisor===divisor-1));n('更新时钟',s.ticks&1);n('当前计数',s.ticks%divisor);n('到达',e.result);n('下一计数',(s.ticks+1)%divisor);n('振荡反馈',s.ticks&1);n('驱动反馈',s.ticks&1);n('整形输出',s.ticks&1);n('进入 FPGA',s.ticks&1);w('整数分频数',divisor);w('累计主时钟边沿',s.ticks,'手动推进的虚拟边沿，不是浏览器墙钟时间');w('当前计数',s.ticks%divisor);w('终值脉冲',e.result);if(id==='baud'){const tx=s.baudTX?.tx;n('位使能',e.result);n('分频发送电平',tx&&tx.uartIndex>=0?anatomyUARTFrame(tx)[tx.uartIndex]:1);w('分频驱动TX',s.baudTX?s.baudTX.done?'帧已完成':tx.uartIndex<0?'等待首次使能':'当前发送位 '+tx.uartIndex:'尚未准备一帧')}w('实际波特率',(1e8/divisor).toFixed(3));break;}
 }
 if(spec.note)w('模型边界',spec.note);
 }
 anCompleteSignals(id,s,e);
 e.partValues={};for(const p of b.parts){const outs=b.nets.filter(n=>n.from.startsWith(p.id+'.')),ins=b.nets.filter(n=>n.to.startsWith(p.id+'.'));const vals=(outs.length?outs:ins).map(n=>e.nets[n.name]).filter(v=>v!==undefined);if(vals.length)e.partValues[p.id]=vals[0]}
 if(id==='leddriver'){e.partValues.LED=e.result;e.partValues.GND=0;}
 if(id==='pixelword'){e.partValues.D=s.pixelD;e.partValues.OUT=s.pixelQ;}
 if(id==='compare10'){const p=anatomyCompare10Plan(s);e.partValues.EQ0=1;e.partValues.LT0=0;e.partValues.A=s.cmp10A;e.partValues.B=s.cmp10B;for(const row of p.rows)e.partValues['S'+row.bit]='E'+row.eq+' L'+row.lt;}
 if(id==='videotiming'){const v=anatomyVGAPlan(s);Object.assign(e.partValues,{XY:(v.y<<10)|v.x,H:v.hs,V:v.vs,A:v.active,OUT:v.hs|(v.vs<<1)|(v.active<<2)});}
 if(id==='pixelcounter'){const v=anatomyVGAPlan(s);Object.assign(e.partValues,{X:v.x,Y:v.y,EN:+(s.vgaCountEnable!==0),HL:799,VL:520,CX:+(v.x===799),CY:+(v.y===520),GATE:+(s.vgaCountEnable!==0&&v.x===799),END:+(v.x===799&&v.y===520),FRAME:+(v.x===799&&v.y===520)});}

 if(id==='rastercounter'){const p=anatomyRasterPlan(s);Object.assign(e.partValues,{INC:p.increment,CMP:p.terminal,MUX:p.d,LO:s.rasterQ&255,HI:s.rasterQ>>>8,OUT:s.rasterQ});}
 if(id==='framebuffer'){const v=anatomyVGAPlan(s),o=anatomyVGAOutput(s);e.partValues.Q=o.rgb;e.partValues.RAM=v.rgb;e.portLabels={Q:'保存RGB=0x'+o.rgb.toString(16).padStart(3,'0'),RAM:'候选RGB=0x'+v.rgb.toString(16).padStart(3,'0')};}
 if(id==='divideShift'){e.portLabels={};for(let i=0;i<4;i++){e.partValues['R'+i]=(s.av>>>i)&1;e.partValues['Q'+i]=(s.bv>>>i)&1;e.partValues['S'+i]=(((s.bv<<1)&15)>>>i)&1}for(let i=0;i<5;i++)e.partValues['T'+i]=(((s.av<<1)|(s.bv>>>3))>>>i)&1;e.partValues.ZERO=0;for(const [key,v]of Object.entries(e.partValues))e.portLabels[key]=key+'='+v}
 if(id==='restore5'){e.partValues.RAW=s.av;e.partValues.TRIAL=s.bv;e.partValues.BORROW=s.cin;e.partValues.OUT=e.result;e.portLabels={RAW:'原值='+s.av,TRIAL:'试减码='+s.bv,BORROW:'借位='+s.cin,OUT:'选择='+e.result}}
 if(id==='divide4'){const m=s.divide4||{q:0,r:0,d:0,k:0},p=anatomyDivide4Plan(s);Object.assign(e.partValues,{Q:m.q,R:m.r,D:m.d,SHIFT:p.shifted,SUB:p.trial,SEL:p.nextR,COUNT:m.k,OUT:m.zero?'ERR':m.q});e.portLabels={OUT:m.zero?'除零 / 无效':'Q='+m.q+' / R='+m.r}}
 if(id==='multiply4'){const m=s.multiply4||{a:0,b:0,p:0,k:0};Object.assign(e.partValues,{A:m.a,B:m.b,P:m.p,COUNT:m.k,ADD:e.nets['下一部分积候选'],OUT:m.p});e.portLabels={OUT:'P='+m.p+' / done='+ +(!!s.multiply4&&m.k===4)}}
 if(id==='register8'){e.partValues.D=s.av;e.partValues.Q=s.reg8Q;e.partValues.CE=s.enable;e.partValues.RST=s.reset;e.portLabels={D:'D='+s.av,Q:'Q='+s.reg8Q,CE:'CE='+s.enable,RST:'RESET='+s.reset};}
 if(id==='tx')e.partValues.SR=s.uartByte??s.byte;
 if(id==='synchronizer'){e.partValues.F1=s.s1;e.partValues.F2=s.s2;}
 if(id==='decoder3'){Object.assign(e.partValues,{LOW:s.av&3,HIGH:(s.av>>>2)&1,DEC2:1<<(s.av&3)});e.portLabels={LOW:'A1A0='+(s.av&3).toString(2).padStart(2,'0'),HIGH:'A2='+((s.av>>>2)&1)}}
 if(['adccore','xadc'].includes(id)){Object.assign(e.partValues,{ADC:anatomyADCPlan(s).code,REG:s.adcSample,F:e.result,OUT:e.result});e.portLabels={OUT:'均值='+e.result}}
 if(id==='compare'){e.partValues.IN='A='+s.av+' B='+s.bv;e.partValues.OUT=e.result;e.portLabels={IN:'A='+s.av+' / B='+s.bv,OUT:'EQ='+e.result}}
 if(id==='debounce'){Object.assign(e.partValues,{CMP:+(s.a===s.candidate),COUNT:s.consecutive,ST:s.stable,OLD:s.candidate})}
 if(id==='cache'){const entry=s.cache[(s.addr>>>1)&3];e.partValues.ADDR=s.addr;e.portLabels={ADDR:'ADDR '+s.addr};e.partValues.TAG='V'+entry.valid+' T'+entry.tag;}
 // Multi-output assemblies need explicit summaries; the first wire is not the whole value.
 if(id==='adder'){
  const a=s.av&15,bb=s.bv&15,total=a+bb;let carry=0;
  e.partValues.AB='A='+a+' B='+bb;e.partValues.CI=0;e.partValues.OUT='S='+(total&15)+' C4='+(total>>>4);
  e.portLabels={AB:'A='+a+' B='+bb,OUT:'S='+(total&15)+' C4='+(total>>>4)};
  for(let i=0;i<4;i++){const v=((a>>>i)&1)+((bb>>>i)&1)+carry;carry=v>>>1;e.partValues['FA'+i]='S'+(v&1)+' C'+carry}
 }
 if(id==='register'){e.partValues.D=s.av&15;e.partValues.Q=s.q&15;e.portLabels={D:'D='+(s.av&15),Q:'Q='+(s.q&15)}}
 if(id==='regfile'){
  e.partValues.WA='W'+s.waddr+' R'+s.r0+'/'+s.r1;e.partValues.BANK='双读阵列';
  e.partValues.R0=s.r0?s.reg[s.r0]:0;e.partValues.R1=s.r1?s.reg[s.r1]:0;
  e.portLabels={WA:'W'+s.waddr+' R'+s.r0+'/'+s.r1};
 }
 if(id==='bram'){
  e.partValues.MEM='双端口';e.partValues.QA=s.readQ;e.partValues.QB=s.readB;
  e.portLabels={A:'addr='+s.addr+' WE='+s.we,B:'addr='+s.addrB+' WE='+s.weB};
 }
 if(id==='subtract'){const total=(s.av&15)+((~s.bv)&15)+1;e.partValues.ADD='S'+(total&15)+' C'+(total>>>4)}
 if(id==='slice')for(let i=0;i<4;i++){e.partValues['F'+['A','B','C','D'][i]]=s.sliceQ[i*2];e.partValues['F'+['A','B','C','D'][i]+'2']=s.sliceQ[i*2+1]}
 if(id==='nmos'||id==='pmos'){const on=id==='nmos'?s.a:1-s.a;e.material={conducting:!!on,gate:s.a};e.partValues.GATE=s.a;e.partValues.BODY=on?'形成理想通路':'无理想通路';}
 if(id==='ledjunction')e.material={conducting:!!s.a,gate:s.a};
 if(id==='packageView')for(const p of b.parts)e.partValues[p.id]=p.id==='LID'?'保护盖板':e.result;
 return e;
};
const anAdvanceBase=anatomyAdvance;
anatomyAdvance=function(id,s,action='tick'){
 if(id==='slice'&&action==='tick'){for(let i=0;i<4;i++){s.sliceQ[i*2]=s.lut[s.lutAddr];s.sliceQ[i*2+1]=s.lut[s.lutAddr&31]}s.ticks++;return}
 if(id==='pixelword'||id==='rastercounter'||!AN_EXPERIMENTS[id]||action==='reset')return anAdvanceBase(id,s,action);
 switch(id){
 case 'adccore':case 'xadc':{const p=anatomyADCPlan(s);s.adcSamples=p.samples;s.adcSample=p.sample;s.adcSampleValid=p.valid;s.adcFilterCount+=+p.accepted;break;}
 case 'divide4':{if(action==='load'){s.divide4={q:s.av&15,r:0,d:s.bv&15,k:0,inputA:s.av&15,inputB:s.bv&15,zero:(s.bv&15)===0,rows:[]};s.ticks=0;return}const m=s.divide4,p=anatomyDivide4Plan(s);if(!p.active)return;m.rows.push({k:m.k,q:m.q,r:m.r,...p});m.q=p.nextQ;m.r=p.nextR;m.k++;break;}
 case 'multiply4':{if(action==='load'){s.multiply4={a:s.av&15,b:s.bv&15,p:0,k:0,inputA:s.av&15,inputB:s.bv&15,rows:[]};s.ticks=0;return}const m=s.multiply4;if(!m||m.k===4)return;const row={k:m.k,a:m.a,b:m.b,b0:m.b&1,before:m.p,after:m.p+((m.b&1)?m.a:0)};m.rows.push(row);m.p=row.after;m.a=(m.a<<1)&255;m.b>>>=1;m.k++;break;}
 case 'register8':{const before=s.reg8Q,after=anatomyRegister8Next(s);s.reg8Last={before,after,input:s.av,enable:s.enable,reset:s.reset,edge:s.ticks+1};s.reg8Q=after;break;}
 case 'asyncrx':{const r=s.uartAsync;if(action==='tick')anatomyAsyncRXStep(s);else{const remaining=r.stimulus.length-r.index,amount=action==='finish'?remaining:Math.min(remaining,action==='batch8'?8:1);for(let i=0;i<amount;i++){s.a=+r.stimulus[r.index++];anatomyAsyncRXStep(s,r.index-1)}}s.ticks=r.samples-1;break;}
 case 'baud':{if(action==='prepare'){s.ticks=0;s.baudTX={tx:{byte:s.byte,uartByte:0,uartIndex:-1},done:false,records:[]};return}const divisor=Math.max(1,Math.round(1e8/s.baud)),start=s.ticks;let distance=1;if(action==='terminal')distance=(divisor-1-start%divisor)||divisor;else if(action==='batch32')distance=32;else if(action==='period')distance=divisor;anatomyBaudTransmitAdvance(s,start,start+distance,divisor);s.ticks=start+distance-1;break;}
 case 'fifo':{const p=anatomyFIFOPlan(s),before={mem:[...s.fifoMem],read:s.fifoRead,write:s.fifoWrite,count:s.fifoCount};s.fifoLast={...p,before,requestedPush:!!s.fifoPush,requestedPop:!!s.fifoPop};if(p.push){s.fifoMem[s.fifoWrite]=s.data;s.fifoWrite=(s.fifoWrite+1)%4}if(p.pop)s.fifoRead=(s.fifoRead+1)%4;s.fifoCount+=+p.push-+p.pop;s.fifoLast.after={mem:[...s.fifoMem],read:s.fifoRead,write:s.fifoWrite,count:s.fifoCount};break;}
 case 'fsm':s.mode=s.reset?0:s.a?(s.mode+1)%3:s.mode;break;
 case 'control':if(s.enable)s.mode=(s.mode+1)%5;break;
 case 'cachefsm':s.mode=s.mode===0?(s.a?1:0):s.mode===1?(s.valid?2:1):0;break;
 case 'bram':{const a=s.mem[s.addr],b=s.mem[s.addrB];s.bramCollision=+(s.we&&s.weB&&s.addr===s.addrB&&s.data!==s.dataB);s.readQ=s.bramCollision?'X':a;s.readB=s.bramCollision?'X':b;if(!s.bramCollision){if(s.we)s.mem[s.addr]=s.data;if(s.weB)s.mem[s.addrB]=s.dataB}break;}
 case 'dsp':if(s.enable)s.q=(s.q+s.av*s.bv)&65535;break;
 case 'pc':if(s.enable)s.pc=s.take?s.target:s.pc+4;break;
 case 'branch':s.pc=s.enable&&s.av===s.bv?s.pc+s.offset:s.pc+4;break;
 case 'loadstore':if(action==='store')s.mainMem[s.av+s.bv]=s.data;else s.lastRead=s.mainMem[s.av+s.bv];break;
 case 'pipeline':if(s.flush){s.pipe=[0,0,0,0];s.pipeValid=[0,0,0,0]}else if(!s.stall){s.pipe=[s.data,...s.pipe.slice(0,3)];s.pipeValid=[1,...s.pipeValid.slice(0,3)]}break;
 case 'input':{const oldStable=s.stable,old2=s.s2;s.previous=oldStable;s.s2=s.s1;s.s1=s.a;if(old2===s.candidate)s.consecutive++;else{s.candidate=old2;s.consecutive=1}if(s.consecutive>=3)s.stable=s.candidate;s.keyEvent=+(s.stable&&!oldStable);break;}
 case 'memorySystem':{const idx=(s.addr>>1)&3,tag=s.addr>>3,entry=s.memoryCache[idx],hit=!!entry.valid&&entry.tag===tag,oldTag=entry.valid?entry.tag:null;if(action==='write'){s.mainMem[s.addr]=s.data;entry.valid=0;s.memoryAccess={kind:'write',address:s.addr,value:s.data,index:idx,oldTag}}else{s.lastHit=+hit;if(!s.lastHit){entry.valid=1;entry.tag=tag;entry.bytes=s.mainMem.slice(s.addr&~1,(s.addr&~1)+2)}s.lastRead=entry.bytes[s.addr&1];s.memoryLastRead={address:s.addr,value:s.lastRead,hit};s.memoryAccess={kind:'read',address:s.addr,value:s.lastRead,index:idx,hit,oldTag,bytes:entry.bytes.slice()}}break;}
 case 'dram':case 'dramcell':{let applied=false;if(action==='write'&&s.enable){s.chargeBit=s.a;s.chargeAge=0;s.chargeValid=1;applied=true}else if(action==='refresh'&&s.chargeValid){s.chargeAge=0;applied=true}else if(action==='wait'){s.chargeAge++;if(s.chargeAge>=8)s.chargeValid=0;applied=true}if(['write','refresh','wait'].includes(action)){s.dramTrace??=[];s.dramTrace.push({action,applied,age:s.chargeAge,value:s.chargeValid?s.chargeBit:'X',wl:s.enable});if(s.dramTrace.length>16)s.dramTrace.shift()}break;}
 case 'flash':if(action==='erase'){s.flashBytes.fill(255);s.flashLast={kind:'erase'}}if(action==='program'){const before=s.flashBytes[s.addr];s.flashBytes[s.addr]&=s.data;s.flashLast={kind:'program',address:s.addr,before,data:s.data,after:s.flashBytes[s.addr]}}break;
 case 'config':case 'programming':if(action==='download'&&s.powered){s.configBit=s.a;s.configValid=1}if(action==='save'&&s.configValid&&s.powered)s.savedConfig=s.configBit;if(action==='power'){s.powered^=1;s.configValid=s.powered&&s.savedConfig!==null?1:0;s.configBit=s.configValid?s.savedConfig:0}break;
 case 'usbtransport':if(action==='enumerate')s.enumerated=s.connected?1:0;if(action==='transfer'){s.usbValid=s.connected&&s.enumerated?1:0;if(s.usbValid)s.usbByte=s.byte}break;
 case 'regulator':s.phase=(s.phase+1)&15;s.outputLevel+=(s.pct*s.duty/16-s.outputLevel)/4;break;
 case 'rx':s.rxValid=0;s.rxError=0;if(s.rxPhase<0){if(s.a===0){s.rxPhase=0;s.rxData=0}}else if(s.rxPhase<8){s.rxData|=s.a<<s.rxPhase;s.rxPhase++}else{s.rxValid=s.a?1:0;s.rxError=s.a?0:1;s.rxPhase=-1}break;
 case 'hidparser':{const key=s.pressed?s.key:0;s.keyEvent=key===s.previousKey?0:key?1:2;s.previousKey=key;break;}
 }
 s.ticks++;
};
AN_EXPERIMENTS.logic={fields:[['av','A',0,15],['bv','B',0,15],['op','逻辑操作','select',[['AND','AND'],['OR','OR'],['XOR','XOR'],['NOT','NOT A']]]],actions:[]};
// Normalize descriptors: compact arrays are used below to keep every control explicit and reviewable.
for(const spec of Object.values(AN_EXPERIMENTS))if(!spec.fields)spec.fields=[];
AN_EXPERIMENTS.fsm={fields:[['a','转移请求','toggle'],['reset','RESET','toggle']],actions:[['tick','状态边沿 ↑']]};
AN_EXPERIMENTS.control={fields:[['opType','示例操作','select',[[0,'ADD'],[1,'LOAD'],[2,'STORE']]],['enable','控制推进','toggle']],actions:[['tick','推进控制阶段']]};
AN_EXPERIMENTS.cachefsm={fields:[['a','查找未命中','toggle'],['valid','返回数据有效','toggle']],actions:[['tick','状态边沿 ↑']]};
function anCompleteSignals(id,s,e){
 const b=ANATOMY[id],lab=b.lab||id,put=o=>{for(const [key,v]of Object.entries(o))if(e.nets[key]===undefined)e.nets[key]=v},a=s.av&15,bb=s.bv&15,clock=s.ticks&1,bin=(v,bits=4)=>(v>>>0).toString(2).padStart(bits,'0');
 if(id==='logic'){e.result=s.op==='OR'?a|bb:s.op==='XOR'?a^bb:s.op==='NOT'?(~a)&15:a&bb;e.led=e.result;e.watch=[{name:'A / B',value:bin(a)+' / '+bin(bb),why:'四位逻辑操作数'},{name:'操作 / 输出',value:s.op+' → '+bin(e.result),why:'组合结果立即更新'}]}
 if(id==='fsm'){e.result=s.mode;e.led=s.mode;e.watch=[{name:'当前状态',value:String(s.mode),why:'三个教学状态 0、1、2'},{name:'输入 / 候选状态',value:s.a+' / '+(s.reset?0:s.a?(s.mode+1)%3:s.mode),why:'无请求保持；复位优先'}]}
 if(id==='control'){const wb=+(s.mode===4&&s.opType!==2),rd=+(s.mode===3&&s.opType===1),wr=+(s.mode===3&&s.opType===2);e.result=wb|(rd<<1)|(wr<<2);e.led=e.result;e.watch=[{name:'阶段',value:['IF','ID','EX','MEM','WB'][s.mode%5],why:'教学阶段'},{name:'RegWrite / MemRead / MemWrite',value:wb+' / '+rd+' / '+wr,why:'信号根据操作种类与阶段产生'}];put({'字段':s.opType||0,'操作种类':['ADD','LOAD','STORE'][s.opType||0],'控制字':e.result})}
 if(id==='cachefsm'){e.result=s.mode;e.led=s.mode;e.watch=[{name:'当前状态',value:['LOOKUP','MISS','FILL'][s.mode%3],why:'缺失后等待有效返回，回填后重新查找'}];put({'未命中':s.a,'返回数据':s.valid?s.data:'无有效数据','重新查找':+(s.mode===2)})}
 if(lab==='adder'){
 let c=0;put({'C0':0});for(let i=0;i<4;i++){let ai=(a>>i)&1,bi=(bb>>i)&1;put({['S'+i]:ai^bi^c});c=(ai&bi)|(c&(ai^bi));put({['C'+(i+1)]:c})}
 }
 if(lab==='alu')put({'输入→ADD':a+'/'+bb,'输入→SUB':a+'/'+bb,'输入→LOG':a+'/'+bb,'输入→SHIFT':a+'/'+bb,'ADD候选':(a+bb)&15,'SUB候选':(a-bb)&15,'LOG候选':s.op==='OR'?a|bb:s.op==='XOR'?a^bb:a&bb,'SHIFT候选':(a<<(bb&3))&15,'RESULT':e.result});
 if(id==='logic'){for(const name of ['AND','OR','XOR','NOT'])put({['操作数→'+name]:a+'/'+bb});put({'AND→结果':a&bb,'OR→结果':a|bb,'XOR→结果':a^bb,'NOT→结果':(~a)&15})}
 if(lab==='board')put({'CLK100':clock,'BTN[4:0]':s.btnMask,'配置数据':1,'JTAG / UART':'空闲','RGB / HS / VS':s.rgb,'HID接口':s.pressed?s.key:0,'模拟输入':s.pct+'%','供电分配':1,'POWER状态':1,'DONE状态':1});
 if(lab==='cpu')put({'指令':'ADD x3,x1,x2','rs1/rs2/rd':'1/2/3','ALU结果/地址':s.cpuStage>=3?s.av+s.bv:'尚未形成','存储读数据':0,'控制':'ADD','当前PC':s.cpuStage===5?4:0,'下一PC':4,'指令与数据请求':s.cpuStage,'存储返回':s.av+s.bv,'外设访问':0,'系统时钟':clock});
 if(lab==='fabric')put({'外部输入':s.lutAddr,'路由0':e.result,'路由1':e.result,'存储接口':s.mem[s.addr],'乘加接口':s.av*s.bv,'外部输出':s.av*s.bv,'时钟分配':clock});
 if(lab==='slice')for(const c of ['A','B','C','D'])put({[c+'O6']:s.lut[s.lutAddr],[c+'O5']:s.lut[s.lutAddr&31],[c+'进位输入']:s.lut[s.lutAddr],[c+'宽函数']:s.lut[s.lutAddr]});
 if(lab==='routing')put({'候选数据':s.lutAddr&1,'配置控制':s.lut[s.lutAddr],'选中路径':s.lut[s.lutAddr]?(s.lutAddr&1):0});
 if(lab==='register')for(let i=0;i<4;i++)put({['D'+i]:(s.av>>i)&1,['Q'+i]:(s.q>>i)&1,['CLK'+i]:clock});
 if(lab==='synchronizer')put({'CLK1':clock,'CLK2':clock});
 if(lab==='debounce')put({'输入':s.a,'候选':s.candidate,'一致':+(s.a===s.candidate),'到达阈值':+anatomyDebouncePreview(s).ready,'提交值':s.a,'更新候选':s.a});
 if(lab==='edge')put({'待采样输入':s.a,'延迟采样':s.stable,'按下事件':e.result});
 if(lab==='counter')put({'参考时钟':clock,'CLK':clock,'复位时钟':clock,'本域复位':s.reset});
 if(lab==='reset')put({'异步置位0':s.a,'异步置位1':s.a,'释放时钟0':clock,'释放时钟1':clock});
 if(lab==='ram')put({'端口A':s.addr,'端口B':s.addr,'读出A':s.readQ,'读出B':s.readQ});
 if(lab==='regfile')put({'写选择':s.waddr,'独热写使能':s.we&&s.waddr?1<<s.waddr:0,'读地址0':s.r0,'读地址1':s.r1,'读出候选0':s.r0?s.reg[s.r0]:0,'读出候选1':s.r1?s.reg[s.r1]:0});
 if(lab==='fsm')put({'外部输入':s.a,'状态反馈':s.mode,'D_next':s.reset?0:s.a?(s.mode+1)%3:s.mode,'状态→输出':s.mode,'字段':s.a,'操作种类':s.mode,'控制字':s.mode,'未命中':s.a,'返回数据':s.data,'重新查找':+(s.mode===2)});
 if(lab==='immediate')put({'字段':a,'候选格式':a,'立即数':e.result,'低位切片':a,'符号位':(a>>3)&1,'低位数据':a,'高位复制':a&8?15:0});
 if(lab==='shifter'){const stage=(a<<((bb&1)?1:0))&15;put({'输入':a,'重排补零':(a<<1)&15,'第一级':stage,'再移2位':(stage<<2)&15,'结果':e.result})}
 if(lab==='scan'){
 const nib=(s.word>>(s.digit*4))&15,seg=(~AN_SEG[nib])&127,an=s.scanPhase===2?15^(1<<s.digit):15;
 put({'位编号':s.digit,'独热位':1<<s.digit,'blank':+(s.scanPhase!==2),'低有效位选':an,'段控制':bin(seg,7)+' / dp='+ (1-((s.scanDots||0)>>>s.digit&1)),'共享段支路':bin(seg,7)+' / dp='+ (1-((s.scanDots||0)>>>s.digit&1)),'位选供电':1,'公共阳极':15^an,'an低有效':bin(an),'段线生成':bin(seg,7)+' / dp='+ (1-((s.scanDots||0)>>>s.digit&1)),'七段码':bin(seg,7),'小数点线':1-((s.scanDots||0)>>>s.digit&1)});
 }
 if(lab==='pwm')put({'LED支路':e.result,'阴极接地':0});
 if(lab==='uart'&&id!=='rx')put({'发送字节':s.byte,'发送节拍':s.ticks,'接收节拍':s.ticks,'串行RX':s.a,'接收字节':'接收模型请进入 RX','装载':s.byte,'状态选择':s.uartIndex<0?'IDLE':s.uartIndex===0?'START':s.uartIndex===9?'STOP':'DATA','异步RX':s.a,'同步RX':s.a,'起始检测':+(s.a===0),'采样使能':1,'组装字节':s.byte});
 if(lab==='shiftreg')for(let i=0;i<3;i++)put({['移位'+i]:(s.shift>>i)&1});
 if(lab==='shiftreg')put({'输入':s.a});
 if(lab==='vga'){
 const v=anatomyVGAPlan(s),o=anatomyVGAOutput(s),{x,y}=v,rowEnd=+(x===799),frameEnd=+(s.pixel===416799);
 put({'可见横坐标':x,'可见纵坐标':y,'横同步':v.hs,'纵同步':v.vs,'横使能':+(s.vgaCountEnable!==0),'纵使能条件':+(s.vgaCountEnable!==0),'横终值':799,'纵终值':520,'纵计数使能':+(s.vgaCountEnable!==0&&rowEnd),'行末判定':rowEnd,'末行判定':+(y===520),'帧末位置':frameEnd});
 put({'坐标→时序':(y<<10)|x,'同步控制':v.hs|(v.vs<<1)|(v.active<<2),'显示输出':o.rgb|(o.hs<<12)|(o.vs<<13)|(o.active<<14),'横计数':x,'行结束':rowEnd,'回绕x':rowEnd,'纵计数':y,'帧回绕':frameEnd,'横坐标':x,'纵坐标':y,'显示区比较':v.active,'坐标':(y<<10)|x,'像素地址':v.address??'无效'});
 }
 if(lab==='gpio')put({'输出数据':s.data,'三态控制':1-s.we,'引脚输出':s.we?s.data:'Z','引脚输入':s.we?s.data:'Z'});
 if(lab==='adc')put({'模拟输入':s.pct+'%','转换有效':1,'样本':e.result,'阈值结果':(1<<e.result)-1});
 if(lab==='filter'){e.operation='SRL';for(let i=0;i<3;i++)put({['延迟'+i]:s.samples[i]});for(let i=0;i<4;i++)put({['样本'+i]:s.samples[i],['有效'+i]:s.enable});put({'待采样输入':s.data,'低两项和':s.samples[0]+s.samples[1],'高两项和':s.samples[2]+s.samples[3],'W+2位和':s.samples.reduce((a,b)=>a+b,0),'固定移位量':2,'平均输出':e.result})}
 if(lab==='cache'||lab==='tag'){const index=(s.addr>>1)&3,entry=s.cache[index];put({'index→标签':index,'index→数据':index,'tag请求':s.addr>>3,'存储tag':entry.tag,'有效位':entry.valid,'块数据':entry.data,'请求':s.addr>>3,'标签':entry.tag})}
 if(lab==='hid')put({'USB传输':s.pressed?s.key:0,'接口报告':s.pressed?s.key:0,'键事件':s.pressed?(s.modifier?'Shift+':'')+s.key:'松开','当前键':s.pressed?s.key:0,'上一键':s.previousKey,'按下/松开':s.keyEvent,'记住报告':s.pressed?s.key:0});
 if(lab==='contact')put({'高位触点':1,'低位触点':0,'触点供电':1,'偏置连接':s.a,'偏置接地':0});
 if(lab==='led')put({'限流支路':s.a,'阴极接地':0,'用户输出':s.a,'阳极连接':s.a,'PN结':s.a,'结到N区':s.a,'阴极连接':0});
 if(lab==='power')put({'输入电源':s.powered,'开关后电源':s.powered,'1.0V / 1.8V / 3.3V':s.powered?'电源轨已建立':'断电','就地去耦':s.powered,'电容回流':0});
}
// Source terminals that can be toggled directly in the diagram. Bus inputs remain editable in the panel.
function anatomyInputForPart(id,part){const lab=ANATOMY[id].lab||id;
 if(['and','or','xor','nand','nor','not','cmos','mux','fulladder','halfadder'].includes(lab))return {A:'a',B:'b',C:'cin',S:'cin'}[part];
 if(['latch','dff'].includes(lab))return part==='D'?'a':part==='EN'?'enable':null;
 if(id==='dramcell')return part==='BL'?'a':part==='WL'?'enable':null;
 if(id==='sramcell')return part==='BL'?'a':part==='WL'?'enable':null;
 if(['nmos','pmos'].includes(id)&&part==='GATE')return 'a';if(id==='ledjunction'&&part==='P')return 'a';
 if(lab==='contact')return part==='SW'?'a':null;
 return null;
}

for(const spec of Object.values(AN_EXPERIMENTS))spec.fields=spec.fields.map(f=>Array.isArray(f)?f[2]==='toggle'?anBit(f[0],f[1]):f[2]==='select'?anChoice(f[0],f[1],f[3]):anNum(...f):f);

ANATOMY_SOURCES.riscv={title:'RISC-V · RV32I 指令格式',url:'https://docs.riscv.org/reference/isa/unpriv/rv32.html'};ANATOMY.instruction.sources.push('riscv');
ANATOMY_SOURCES.buck={title:'TI · 理想降压变换器占空比',url:'https://www.ti.com/document-viewer/lit/html/SSZTCO3/GUID-292D8B9D-5297-46CB-98DA-C7099A8F41F7'};ANATOMY.regulator.sources.push('buck');

anExp('bram',[anNum('addr','端口 A 地址',0,7),anNum('data','A 待写数据',0,255),anBit('we','A 写使能'),anNum('addrB','端口 B 地址',0,7),anNum('dataB','B 待写数据',0,255),anBit('weB','B 写使能')],[['tick','双端口访问边沿 ↑']],'8×8 位缩小模型，同步读旧值；同址不同值双写显示冲突，不声称真实原语的冲突结果。');

anExp('segmentdecode',[anNum('av','待显示数字 0…15',0,15)],[],'组合译码不需要扫描时钟；位选与动态扫描请进入上一级数码管。');

anExp('fifo',[anNum('data','待写字节',0,255),anBit('fifoPush','写请求'),anBit('fifoPop','读请求')],[['tick','提交一个读写边沿 ↑']],'写入与读出只有在本拍被接受时才改变指针/占用。');
function anatomyFIFOPlan(s){const pop=!!s.fifoPop&&s.fifoCount>0,push=!!s.fifoPush&&(s.fifoCount<4||pop);return {push,pop,value:pop?s.fifoMem[s.fifoRead]:null,writeValue:push?s.data:null}}

anExp('baud',[anChoice('baud','目标波特率（切换后计数与发送归零）',[[9600,'9600'],[115200,'115200']]),anNum('byte','待准备字节',0,255)],[['prepare','准备一帧并把计数归零'],['tick','主时钟边沿 +1'],['batch32','主时钟 +32'],['terminal','快进至下一终值'],['period','推进一个完整位周期']],'100MHz参考时钟；整数分频取最近整数。快进只记录最终状态，不伪造中途波形。');

function anatomyBaudTransmitAdvance(s,start,end,divisor){
 const link=s.baudTX;if(!link||link.done)return;
 const first=start+(divisor-start%divisor);
 for(let clock=first;clock<=end&&!link.done;clock+=divisor){
  anatomyAdvance('tx',link.tx);const position=link.tx.uartIndex;
  link.records.push({clock,position,level:position<0?1:anatomyUARTFrame(link.tx)[position]});
  if(position<0)link.done=true;
 }
}

anExp('asyncrx',[anBit('a','当前原始RX'),anNum('byte','激励字节',0,255)],[['tick','采样当前RX一次'],['next','送下一激励并采样'],['batch8','送最多8个激励采样'],['finish','执行剩余激励']],'每次采样是接收器8倍采样时钟的一次边沿；不等同一个数据位周期。装入例子会清零本实验。');
function anatomyAsyncRXState(){return {first:1,second:1,firstSource:null,secondSource:null,phase:'IDLE',timer:0,bit:0,shift:0,data:0,valid:0,error:0,samples:0,falseStarts:0,trace:[],received:[],stimulus:'',index:0,name:'未装入激励'}}
function anatomyAsyncRXStep(s,sourceIndex=null){
 const r=s.uartAsync,observed=r.second,first=r.first,observedSource=r.secondSource;r.secondSource=r.firstSource;r.firstSource=sourceIndex;r.first=s.a;r.second=first;r.valid=0;r.error=0;r.samples++;let event='保持 / 等待',sampled='';
 if(r.phase==='IDLE'){if(observed===0){r.phase='START';r.timer=0;event='检测到低起始候选'}}
 else if(r.phase==='START'){r.timer++;if(r.timer===4){r.timer=0;if(observed===0){r.phase='DATA';r.bit=0;r.shift=0;event='起始位中心确认';sampled='START'}else{r.phase='IDLE';r.falseStarts++;event='短起始候选被拒绝';sampled='REJECT'}}}
 else if(r.phase==='DATA'){r.timer++;if(r.timer===8){r.timer=0;r.shift=(r.shift&~(1<<r.bit))|(observed<<r.bit);sampled='d'+r.bit;event='中心采样 '+sampled+'='+observed;if(r.bit===7)r.phase='STOP';else r.bit++}}
 else{r.timer++;if(r.timer===8){r.timer=0;r.data=r.shift;r.valid=observed;r.error=1-observed;r.phase='IDLE';sampled='STOP';event=observed?'停止位正确，帧有效':'停止位错误，帧无效';r.received.push({sample:r.samples,data:r.data,valid:r.valid,error:r.error});if(r.received.length>8)r.received.shift()}}
 r.trace.push({sample:r.samples,sourceIndex,observedSource,raw:s.a,first:r.first,second:r.second,observed,phase:r.phase,timer:r.timer,shift:r.shift,valid:r.valid,error:r.error,event,sampled});if(r.trace.length>192)r.trace.shift();
}
function anatomyAsyncRXLoad(s,kind){
 const r=anatomyAsyncRXState(),byte=s.byte&255,period=kind==='fast'?7:kind==='slow'?9:8;r.name=kind==='glitch'?'2采样低脉冲':kind==='bad'?'错误停止位':kind==='fast'?'发送每位7采样':kind==='slow'?'发送每位9采样':'正常8倍采样帧';
 r.stimulusKind=kind;r.txStart=8;r.txPeriod=kind==='glitch'?null:period;r.stimulus=kind==='glitch'?'1'.repeat(8)+'00'+'1'.repeat(16):'1'.repeat(8)+[0,...Array.from({length:8},(_,i)=>(byte>>>i)&1),kind==='bad'?0:1].map(v=>String(v).repeat(period)).join('')+'1'.repeat(16);r.expected=kind==='glitch'?null:byte;s.uartAsync=r;s.a=1;s.ticks=0;
}

anExp('register8',[anNum('av','D[7:0]',0,255),anBit('enable','CE'),anBit('reset','同步RESET')],[['tick','字节保存边沿 ↑']],'修改D不会提前保存；RESET优先CE，八个位并行更新。');
function anatomyRegister8Next(s){return s.reset?0:s.enable?s.av&255:s.reg8Q&255}

anExp('registerControl',[anBit('a','原始D'),anBit('b','已保存Q（独立输入）'),anBit('enable','CE'),anBit('reset','同步RESET')],[],'本层为组合选择，无保存边沿；修改输入只更新候选。');

anExp('multiply4',[anNum('av','待装载A（无符号）',0,15),anNum('bv','待装载B（无符号）',0,15)],[['load','装载并开始新乘法'],['tick','执行一轮条件相加与移位 ↑']],'装载捕获A/B；每轮同时提交部分积和两个移位寄存器，四轮结束保持结果。');

anExp('divide4',[anNum('av','待装载被除数',0,15),anNum('bv','待装载除数',0,15)],[['load','装载新除法'],['tick','执行一轮试减与商位提交 ↑']],'无符号四轮恢复除法；除零立即报错，商余数无效。输入改变不影响已捕获操作数。');
function anatomyDivide4Plan(s){const m=s.divide4||{q:0,r:0,d:0,k:0},active=!!s.divide4&&!m.zero&&m.k<4,shifted=(m.r<<1)|((m.q>>>3)&1),difference=shifted-m.d,ok=difference>=0,qbit=+ok;return {active,shifted,difference,trial:difference&31,ok,qbit,nextR:active?(ok?difference:shifted):m.r,nextQ:active?((m.q<<1)&15)|qbit:m.q}}

anExp('restore5',[anNum('av','移入原值[4:0]',0,31),anNum('bv','试减差低5位',0,31),anBit('cin','借位（1恢复原值）')],[],'独立组合选择，不保存；借位由上级给出，本层不重新执行试减。');

anExp('divideShift',[anNum('av','旧余数R[3:0]',0,15),anNum('bv','Q工作位[3:0]',0,15)],[],'纯组合移位拼接；输入位改变立即更新输出，无保存边沿。');

anExp('decoder3',[anNum('av','地址 A2 A1 A0',0,7)],[],'组合3→8译码；字线选择本身不代表已写入。');

anExp('transmission',[anBit('a','数据D'),anBit('enable','使能EN')],[],'组合理想传输门；Z为未驱动，不等于0或保留旧值。');

function anatomyADCPlan(s){const code=Math.min(15,Math.floor(s.pct*16/100)),accepted=!!s.adcSampleValid,samples=accepted?[s.adcSample,...s.adcSamples.slice(0,3)]:s.adcSamples.slice();return {code,accepted,samples,sample:s.adcValid?code:s.adcSample,valid:+!!s.adcValid,filtered:Math.floor(samples.reduce((a,b)=>a+b,0)/4)}}
anExp('adccore xadc',[{key:'pct',label:'归一化幅值 %',min:0,max:100,type:'number',step:0.01},anBit('adcValid','本次转换有效')],[['tick','共同采样边沿 ↑']],'寄存器接收当前有效转换，滤波器同时读取寄存器旧样本/旧有效位。四点窗口初始补零，结果向下取整。');
anExp('rastercounter',[anNum('rasterLimit','终值LIMIT（相等时回0）',0,1023),anNum('rasterStart','准备起点（点击装载才生效）',0,1023),anBit('rasterEnable','计数使能CE'),anBit('rasterReset','同步复位RESET')],[['tick','推进一个共同计数边沿 ↑'],['load','装载准备起点（实验初始化）']],'同步复位优先CE；装载是实验初始条件注入，不是额外的硬件指令。');
anExp('pixelword',[{...anNum('pixelD','待写RGB444（支持0x）',0,4095),type:'word'},anBit('pixelWE','本像素写使能')],[['tick','提交本像素写入边沿 ↑']],'只修改候选不写入；WE=0保持。由帧缓冲进入时，WE还要求写地址与所看读地址相等。');

function anatomyTruth2Plan(s){
 const mask=s.truthMask&15,row=(s.a<<1)|s.b,labels=['¬A·¬B','¬A·B','A·¬B','A·B'],enabled=[0,1,2,3].filter(i=>mask&(1<<i));
 const cubes=[];for(const a of ['0','1','-'])for(const b of ['0','1','-']){let cover=0;for(let i=0;i<4;i++)if((a==='-'||Number(a)===(i>>>1))&&(b==='-'||Number(b)===(i&1)))cover|=1<<i;if(cover&&(cover&mask)===cover)cubes.push({a,b,cover,literals:+(a!=='-')+(b!=='-')});}
 let best=[];if(mask){let score=Infinity;for(let subset=1;subset<(1<<cubes.length);subset++){const terms=cubes.filter((_,i)=>subset&(1<<i)),cover=terms.reduce((v,t)=>v|t.cover,0),cost=terms.length*10+terms.reduce((v,t)=>v+t.literals,0);if(cover===mask&&cost<score){score=cost;best=terms;}}}
 const term=t=>[t.a==='-'?'':t.a==='1'?'A':'¬A',t.b==='-'?'':t.b==='1'?'B':'¬B'].filter(Boolean).join('·')||'1';
 return {row,output:(mask>>>row)&1,enabled,expression:enabled.map(i=>'('+labels[i]+')').join(' + ')||'0',simplified:best.map(term).join(' + ')||'0',groups:best};
}
