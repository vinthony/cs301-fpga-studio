'use strict';
const AN_PIPE32_HAZARD_SOURCE=`addi x1,x0,5
add x2,x1,x1
add x3,x2,x1
sw x3,0(x0)
lw x4,0(x0)
add x5,x4,x3
ebreak`;
const AN_PIPE32_DEMOS=[{name:'数据冒险：结果应为30',source:AN_PIPE32_HAZARD_SOURCE},...AN_CPU32_DEMOS];
plate('pipeline32','五级流水CPU · 指令、前递、暂停与冲刷',[
 P('IF','instruction','pipeStage',-8,0,'IF · 取指'),P('ID','decoder32','pipeStage',-4,0,'ID · 译码/读取'),P('EX','alu32','pipeStage',0,0,'EX · 执行'),P('MEM','sram','pipeStage',4,0,'MEM · 访存'),P('WB','regfile32','pipeStage',8,0,'WB · 写回/退休'),P('RF','regfile32','pipeRF',-3,5,'32个保存寄存器'),P('DM',null,'pipeMem',4,5,'256字节RAM / 教学I/O'),P('HAZ',null,'pipeControl',0,5,'冒险、前递与冲刷控制')
],[N('IF/ID 指令','IF.o','ID.i',32),N('ID/EX 指令','ID.o','EX.i',32),N('EX/MEM 指令','EX.o','MEM.i',32),N('MEM/WB 指令','MEM.o','WB.i',32),N('读操作数 A','RF.a','ID.a',32),N('读操作数 B','RF.b','ID.b',32),N('待写回值','WB.wd','RF.wd',32),N('访存地址','MEM.addr','DM.addr',32),N('访存读值','DM.out','MEM.data',32),N('暂停/跳转候选','HAZ.ctrl','IF.ctrl',2,'control')],[S('一拍不是一条指令','每级可同时保存不同年龄的指令。四个段寄存器保存指令及其操作数，气泡不产生副作用。',['IF','ID','EX','MEM','WB'],['IF/ID 指令','ID/EX 指令','EX/MEM 指令','MEM/WB 指令']),S('解决数据相关','EX可从EX/MEM或MEM/WB取得更近的值；紧随LOAD的使用者需要暂停一次，冻结前端并向EX注入气泡。',['RF','EX','HAZ'],['待写回值','暂停/跳转候选']),S('跳转与异常','EX选择跳转时清空年轻前端指令。异常按年龄排空更早指令后停止，年轻指令不允许留下副作用。',['MEM','WB','HAZ'])],{lab:'pipeline32',layer:'Week14 · 五级指令流水功能模型',sources:['riscv','seq'],boundary:'网页为基础RV32I五级功能模型；配套Chisel流水线RTL已完成独立指令结果与逐周期对照，不等于实体FPGA时序验证。MEM执行存储、WB统计退休；WB写回对同周期ID读取采用显式写优先约定。前递策略含load-use暂停，纯暂停策略等待写回；不处理策略故意保留RAW错误。EX解析跳转、清空年轻前端；异常排空后停止。',question:'相同程序为何“不处理”得到0、“前递+暂停”和“只暂停”都得到30，但周期数不同？'});
AN_CONTEXT_ASSOCIATIONS.pipeline32='cpu32';
const anPipe32StateBase=anatomyState;anatomyState=function(){return {...anPipe32StateBase(),pipeMode:'forward',pipelineDraft:AN_PIPE32_HAZARD_SOURCE,pipeline32:anatomyPipeline32State(anatomyAssembleCPU32(AN_PIPE32_HAZARD_SOURCE),'forward','数据冒险：结果应为30')}};
anExp('pipeline32',[anChoice('pipeMode','重启时采用的策略（选择后点重启）',[['none','不处理冒险（对照错误）'],['forward','前递 + load-use暂停'],['stall','仅暂停等待写回']]),{...anNum('cpuSwitches','教学开关输入（16位）',0,65535),type:'word'},anNum('cpuButtons','教学按键位（5位）',0,31)],[['tick','推进一个流水周期 ↑'],['restart','按所选策略重启当前程序']],'该选择不会立刻改变当前流水状态，重启会清空本程序寄存器和RAM。');
const anPipe32EvalBase=anatomyEvaluate;anatomyEvaluate=function(id,s){
 if(id!=='pipeline32')return anPipe32EvalBase(id,s);const c=s.pipeline32,p=anatomyPipeline32Preview(c,{switches:s.cpuSwitches,buttons:s.cpuButtons}),stage=c.stages,word=x=>x?x.word:'气泡',d=stage.ifid?.d,regs=c.regs,read=reg=>reg===0?0:stage.memwb&&!stage.memwb.fault&&stage.memwb.write?.address===reg?stage.memwb.write.value:regs[reg],nets={'IF/ID 指令':word(stage.ifid),'ID/EX 指令':word(stage.idex),'EX/MEM 指令':word(stage.exmem),'MEM/WB 指令':word(stage.memwb),'读操作数 A':d?.useRS1?read(d.rs1):0,'读操作数 B':d?.useRS2?read(d.rs2):0,'待写回值':stage.memwb?.write?.value??0,'访存地址':stage.exmem?.alu??0,'访存读值':stage.exmem&&!stage.exmem.fault?anatomyPipeline32PacketPreview(c,stage.exmem,{switches:s.cpuSwitches,buttons:s.cpuButtons}).load:0,'暂停/跳转候选':+(p.decision?.stall||false)+2*+(p.decision?.redirect||false)};
 return {pipelinePreview:p,result:c.retired,led:c.led,digits:[0,1,2,3].map(i=>AN_SEG[(c.display>>>(i*4))&15]),nets,partValues:{IF:c.pendingTrap?'停止取指':'PC '+c.fetchPC,ID:stage.ifid?.d.name??'气泡',EX:stage.idex?.d.name??'气泡',MEM:stage.exmem?.d.name??'气泡',WB:stage.memwb?.d.name??'气泡',RF:c.regs[5],DM:c.memory[0],HAZ:p.decision?.stall?'暂停':p.decision?.redirect?'冲刷':'推进'},watch:[{name:'流水周期 / 退休',value:c.cycles+' / '+c.retired,why:'周期计数含填充、气泡与故障排空，不等于单周期CPU的退休数'},{name:'正在运行的策略',value:c.mode,why:'右侧策略选择仅在重启后生效'},{name:'x5 / RAM[0]',value:c.regs[5]+' / '+c.memory[0],why:'默认程序正确结果为x5=30、RAM[0]=15'},{name:'实际暂停 / 跳转次数',value:c.stalls+' / '+c.redirects,why:'由已经执行的周期统计'},{name:'下一边沿原因',value:c.halted?'已停止':p.decision.action,why:'候选预览不推进流水线'},{name:'状态',value:c.halted?c.fault.kind:'等待下一周期',why:c.pendingTrap?'正排空异常；更早指令仍可完成':'MEM写存储，WB写回与退休'}]};
};
const anPipe32AdvanceBase=anatomyAdvance;anatomyAdvance=function(id,s,action='tick'){
 if(id!=='pipeline32')return anPipe32AdvanceBase(id,s,action);
 if(action==='reset'){const fresh=anatomyState();s.pipeline32=fresh.pipeline32;s.pipeMode=fresh.pipeMode;s.pipelineDraft=fresh.pipelineDraft;s.ticks=0;return}
 if(action==='restart'){const c=s.pipeline32;s.pipeline32=anatomyPipeline32State({words:c.program,sourceLines:c.sourceLines,sourceText:c.sourceText},s.pipeMode,c.programName);s.ticks=0;return}
 if(action==='tick'){anatomyPipeline32Tick(s.pipeline32,{switches:s.cpuSwitches,buttons:s.cpuButtons});s.ticks=s.pipeline32.cycles}
};
function anatomyPipeline32Markup(b,s,rtlOptions={}){
 if(b.id!=='pipeline32')return '';const c=s.pipeline32,esc=x=>String(x).replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
 return '<section class="pipe32-lab"><h4>同一程序，比较三种冒险策略</h4>'+(typeof anatomyPipeline32RTLMarkup==='function'?anatomyPipeline32RTLMarkup(s,rtlOptions):'')+'<p><a href="labs/lab14-pipeline-cpu.zip" download>下载第14讲实验包 · Chisel / RTL / 测试波形 ↓</a></p><button data-pipe32-compare>三种策略从零对照运行</button><div data-pipe32-comparison role="status"></div><p>当前 <b>'+c.mode+'</b> · 周期 '+c.cycles+' · 退休 '+c.retired+' · x5='+c.regs[5]+'</p><p>'+esc(c.lastCycle?.action||'流水线为空，等待第一拍')+'</p><p>最近EX前递：A='+esc(c.lastCycle?.forwardA||'—')+'；B='+esc(c.lastCycle?.forwardB||'—')+'</p><details class="pipe32-editor"><summary>程序草稿 / 示例 · 装载会清空流水线</summary><select data-pipe32-demo>'+AN_PIPE32_DEMOS.map((d,i)=>'<option value="'+i+'">'+esc(d.name)+'</option>').join('')+'</select><button data-pipe32-copy>复制示例到草稿</button><textarea data-pipe32-source rows="9" spellcheck="false">'+esc(s.pipelineDraft)+'</textarea><button data-pipe32-load>汇编装载，按所选策略从零运行</button><p data-pipe32-error role="status"></p></details><details><summary>最近32个周期 · 指令占用（每个周期边沿前）</summary><div class="pipe32-timeline-scroll"><table><thead><tr><th>周期</th><th>IF</th><th>ID</th><th>EX</th><th>MEM</th><th>WB</th><th>原因</th></tr></thead><tbody>'+c.timeline.map(row=>'<tr data-pipe32-row="'+row.cycle+'"><th><button data-pipe32-cycle="'+row.cycle+'" aria-pressed="false">'+row.cycle+'</button></th>'+['IF','ID','EX','MEM','WB'].map(key=>'<td>'+(row.stages[key]?esc(row.stages[key].name)+'<small>@'+row.stages[key].pc+'</small>':'气泡')+'</td>').join('')+'<td>'+esc(row.action)+'</td></tr>').join('')+'</tbody></table></div><div data-pipe32-cycle-detail class="pipe32-cycle-detail" role="status">点击周期编号，展开这一拍的阶段、前递和实际写入。只读查看，不推进时钟。</div></details><details><summary>32个已保存寄存器 · 256字节RAM</summary><div class="pipe32-registers">'+c.regs.map((v,i)=>'<span><small>x'+i+'</small>'+v.toString(16).toUpperCase().padStart(8,'0')+'</span>').join('')+'</div><p>RAM[0…15]：'+c.memory.slice(0,16).map(v=>v.toString(16).padStart(2,'0')).join(' ')+'</p></details><small>无自动执行；每次推进一个真实模型周期。网页交互仍运行功能模型；配套项目可生成流水线RTL，实体板资源与时序尚待验证。</small></section>';
}

function anatomyPipeline32CycleDetail(row){
 if(!row)return '此周期不在最近32拍记录中。';
 const esc=x=>String(x).replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
 const stages=['IF','ID','EX','MEM','WB'].map(key=>{const p=row.stages[key];return '<li><b>'+key+'</b><span>'+(p?esc(p.name)+' @'+p.pc+(p.id===undefined?' · 取指候选':' · <button data-pipe32-instance="'+p.id+'">追踪实例 #'+p.id+'</button>'):'气泡')+'</span></li>'}).join('');
 const retired=row.retired,write=retired?.write,memory=row.memory;
 return '<h5>第 '+row.cycle+' 拍 · 边沿前 → 边沿后</h5><ol class="pipe32-cycle-stages">'+stages+'</ol><p><b>控制决策：</b>'+esc(row.action)+'</p><p><b>EX操作数来源：</b>A='+esc(row.forwardA)+'，B='+esc(row.forwardB)+'</p><p><b>本拍WB：</b>'+(retired?esc(retired.name)+' @'+retired.pc+' 退休；'+(write?'x'+write.address+' ← '+write.value:'不写寄存器'):'没有指令退休')+'</p><p><b>本拍MEM：</b>'+(memory?esc(memory.kind)+' 地址 '+memory.address+'，值 '+memory.value+'，'+(memory.bytes??4)+' 字节':'没有数据存储访问')+'</p><p><b>丢弃的已取指实例：</b>'+ (row.flushed.length?row.flushed.map(id=>'#'+id).join('、'):'无')+'</p><small>IF是本拍取指候选；暂停或冲刷时不一定进入流水线。实例编号区分循环中同一地址的不同执行。图上方仍显示当前实时状态。</small><div data-pipe32-track></div>';
}

function anatomyPipeline32InstructionTrack(c,id){
 const esc=x=>String(x).replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
 const appearances=[];
 for(const row of c.timeline){
  const entry=Object.entries(row.stages).find(([key,p])=>key!=='IF'&&p?.id===id);
  if(!entry)continue;
  const [stage,p]=entry,flushed=row.flushed.includes(id),retired=stage==='WB'&&!!row.retired,stopped=stage==='WB'&&row.action==='异常在WB精确停止';
  const previous=appearances.at(-1),held=previous?.stage===stage&&previous.cycle===row.cycle-1;
  appearances.push({stage,cycle:row.cycle,p,held,flushed,retired,stopped,reason:flushed?row.action:stage==='ID'&&row.stall?row.action:stage==='EX'?'A='+row.forwardA+'；B='+row.forwardB:''});
 }
 if(!appearances.length)return '<p>最近32拍中没有此实例的记录。</p>';
 const first=appearances[0],last=appearances.at(-1),live=Object.values(c.stages).some(p=>p?.id===id),status=last.flushed?'已冲刷，不会退休':last.retired?'已退休':last.stopped?'异常停止，未退休':live?'仍在流水线中':'记录窗口内未观察到终点';
 return '<section class="pipe32-track"><h5>实例 #'+id+' · '+esc(first.p.name)+' @'+first.p.pc+'</h5><p>'+status+'</p><div class="pipe32-track-controls"><button data-pipe32-prev>上一步</button><button data-pipe32-play>自动讲解</button><button data-pipe32-next>下一步</button></div><p data-pipe32-play-status role="status"></p><ol>'+appearances.map(a=>'<li data-pipe32-track-stage="'+a.stage+'"><b>第 '+a.cycle+' 拍 · '+a.stage+'</b><span>'+(a.held?'继续停留；':'')+(a.flushed?'边沿被冲刷':a.retired?'边沿退休':a.stopped?'边沿异常停止':'')+'</span><small>'+esc(a.reason)+'</small></li>').join('')+'</ol><small>仅展示最近32拍的实际记录，从ID起追踪已接收的指令；不把IF候选当作已执行指令。连续相同阶段表示停留。</small></section>';
}

function anatomyPipeline32ComparisonMarkup(comparison){
 const esc=x=>String(x).replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c])),names={none:'不处理冒险',forward:'前递 + load-use暂停',stall:'仅暂停等待写回'};
 return '<h5>同一已装载程序 · 从零独立运行</h5><div class="pipe32-comparison-cards">'+comparison.results.map(r=>'<article data-pipe32-comparison-mode="'+r.mode+'"><h5>'+names[r.mode]+'</h5><dl><dt>周期 / 退休</dt><dd>'+r.cycles+' / '+r.retired+'</dd><dt>暂停 / 跳转</dt><dd>'+r.stalls+' / '+r.redirects+'</dd><dt>x5 / RAM[0]</dt><dd>'+r.regs[5]+' / '+r.memory[0]+'</dd></dl><p>'+(r.complete?'停止原因：'+esc(r.fault):'达到 '+comparison.limit+' 拍上限，尚未停止')+'</p><p>'+(!r.comparable?'运行未结束，暂不判定终态一致性':r.mode==='forward'?'本组对照基准':r.differences.length?'与前递策略有 '+r.differences.length+' 项终态差异':'与前递策略的终态一致')+'</p>'+(r.differences.length?'<ul>'+r.differences.slice(0,5).map(d=>'<li>'+esc(d.name)+'：'+esc(d.value)+'；前递策略为 '+esc(d.baseline)+'</li>').join('')+'</ul>':'')+'</article>').join('')+'</div><small>比较全部寄存器、256字节RAM、教学I/O、PC、退休数和停止原因；有差异时列出前5项。各策略从零开始，输入引脚固定为点击时的值，不使用当前已保存寄存器。策略互相一致不等于独立正确性证明；本次结果不会写入正在观察的电路。</small>';
}
