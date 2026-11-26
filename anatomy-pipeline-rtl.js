'use strict';
let AN_PIPE32_RTL_DATA=null,AN_PIPE32_RTL_PENDING=null;
const AN_PIPE32_RTL_REASONS={EBREAK:1,ILLEGAL_INSTRUCTION:2,INSTRUCTION_ACCESS_FAULT:3,INSTRUCTION_ADDRESS_MISALIGNED:4,LOAD_ADDRESS_MISALIGNED:5,STORE_ADDRESS_MISALIGNED:6,LOAD_ACCESS_FAULT:7,STORE_ACCESS_FAULT:8,ECALL:9};
function anatomyPipelineRTLEscape(v){return String(v).replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]))}
function anatomyValidatePipelineRTL(data){
 if(data?.format!=='GBU-CS301-pipeline-rtl-traces'||data.version!==1||!Array.isArray(data.programs)||!data.programs.length||!/^[a-f0-9]{64}$/.test(data.rtlSHA256))throw Error('硬件记录格式不支持');
 const uint=(v,max=4294967295)=>Number.isInteger(v)&&v>=0&&v<=max,ids=new Set();
 for(const p of data.programs){
  if(!/^[a-z0-9-]+$/.test(p.id)||ids.has(p.id)||!Array.isArray(p.words)||!p.words.length||!p.words.every(x=>uint(x))||!uint(p.pins?.switches,65535)||!uint(p.pins?.buttons,31))throw Error('硬件样例定义损坏');ids.add(p.id);
  for(const mode of ['stall','forward']){const frames=p.traces?.[mode];if(!Array.isArray(frames)||!frames.length)throw Error('硬件周期缺失');
   frames.forEach((f,i)=>{if(f.cycles!==i+1||!Array.isArray(f.regs)||f.regs.length!==32||!f.regs.every(x=>uint(x))||!Array.isArray(f.memory)||f.memory.length!==256||!f.memory.every(x=>uint(x,255))||!Array.isArray(f.stagePC)||f.stagePC.length!==4||!f.stagePC.every(x=>uint(x))||!Array.isArray(f.stageValid)||f.stageValid.length!==4||!f.stageValid.every(x=>typeof x==='boolean')||!['pc','retired','faultValue','display','led','fetchPC','stalls','redirects'].every(k=>uint(f[k]))||!uint(f.reason,9)||!uint(f.forwardA,2)||!uint(f.forwardB,2)||typeof f.halted!=='boolean'||typeof f.pendingTrap!=='boolean')throw Error('硬件周期记录损坏');});
   if(!frames.at(-1).halted)throw Error('硬件样例缺少停止记录');
  }
 }
 return data;
}
async function anatomyLoadPipelineRTL(){
 if(AN_PIPE32_RTL_DATA)return AN_PIPE32_RTL_DATA;if(AN_PIPE32_RTL_PENDING)return AN_PIPE32_RTL_PENDING;
 AN_PIPE32_RTL_PENDING=(async()=>{const [r,m]=await Promise.all([fetch('pipeline-rtl-traces.json'),fetch('labs/lab14-pipeline-cpu/generated/source-manifest.sha256')]);if(!r.ok||!m.ok)throw Error('本地硬件记录暂时无法读取');const data=anatomyValidatePipelineRTL(await r.json()),manifest=await m.text(),line=manifest.split('\n').find(x=>x.endsWith('  generated/PipelineCPU.v'));if(!line||line.split('  ')[0]!==data.rtlSHA256)throw Error('硬件记录与实验包RTL版本不一致');AN_PIPE32_RTL_DATA=data;return data})().finally(()=>AN_PIPE32_RTL_PENDING=null);return AN_PIPE32_RTL_PENDING;
}
function anatomyPipelineRTLDiff(c,f){
 const packets=['ifid','idex','exmem','memwb'].map(k=>c.stages[k]),forward=x=>x==='EX/MEM'?1:x==='MEM/WB'?2:0;
 const actual={cycles:c.cycles,pc:c.pc,retired:c.retired,halted:c.halted,reason:c.fault?.kind?AN_PIPE32_RTL_REASONS[c.fault.kind]:0,faultValue:c.fault?.value||0,led:c.led,display:c.display,regs:c.regs,memory:c.memory,stagePC:packets.map(p=>p?.pc||0),stageValid:packets.map(Boolean),pendingTrap:c.pendingTrap,redirects:c.redirects,stalls:c.stalls,fetchPC:c.fetchPC,forwardA:forward(c.lastCycle?.forwardA),forwardB:forward(c.lastCycle?.forwardB)};
 return Object.keys(actual).filter(k=>JSON.stringify(actual[k])!==JSON.stringify(f[k]));
}
function anatomyPipelineRTLSource(p){return p.words.map(w=>'.word 0x'+w.toString(16).padStart(8,'0')).join('\n')}
function anatomyPipelineRTLRebuild(p,mode,cycle){
 if(!['stall','forward'].includes(mode)||!Number.isInteger(cycle)||cycle<1||cycle>p.traces[mode].length)throw Error('请选择记录范围内的整数周期');
 const c=anatomyPipeline32State(anatomyAssembleCPU32(anatomyPipelineRTLSource(p)),mode,p.title+' · RTL记录对齐');for(let i=0;i<cycle;i++)anatomyPipeline32Tick(c,p.pins);
 const diff=anatomyPipelineRTLDiff(c,p.traces[mode][cycle-1]);if(diff.length)throw Error('网页与硬件记录不一致：'+diff.join('、')+'；原实验保留');return c;
}
function anatomyPipelineRTLSameProgram(s,p,mode){return s.pipeline32.mode===mode&&s.cpuSwitches===p.pins.switches&&s.cpuButtons===p.pins.buttons&&JSON.stringify(s.pipeline32.program)===JSON.stringify(p.words)}
function anatomyPipelineRTLChanges(p,mode,cycle){
 const f=p.traces[mode][cycle-1],before=cycle>1?p.traces[mode][cycle-2]:null;
 if(!before)return {initial:true,registers:[],memory:[],outputs:[],stages:[]};
 const changes=(a,b)=>b.flatMap((value,index)=>value!==a[index]?[{index,before:a[index],after:value}]:[]);
 return {initial:false,registers:changes(before.regs,f.regs),memory:changes(before.memory,f.memory),outputs:['led','display'].filter(k=>before[k]!==f[k]).map(key=>({key,before:before[key],after:f[key]})),stages:f.stageValid.map((valid,index)=>({index,beforeValid:before.stageValid[index],beforePC:before.stagePC[index],afterValid:valid,afterPC:f.stagePC[index]})),retired:f.retired-before.retired,stalls:f.stalls-before.stalls,redirects:f.redirects-before.redirects,stopped:!before.halted&&f.halted};
}
function anatomyPipelineRTLFlow(p,mode,cycle){
 const c=anatomyPipelineRTLRebuild(p,mode,Math.max(1,cycle-1));
 if(cycle===1)return null;
 const keys=['ifid','idex','exmem','memwb'],before=keys.map(k=>c.stages[k]&&({...c.stages[k]}));
 anatomyPipeline32Tick(c,p.pins);if(anatomyPipelineRTLDiff(c,p.traces[mode][cycle-1]).length)throw Error('轨迹模型与硬件周期不一致');
 const after=keys.map(k=>c.stages[k]),report=c.lastCycle;
 const edges=before.flatMap((packet,from)=>{if(!packet)return [];const to=after.findIndex(next=>next?.id===packet.id);const reason=to>=0?(to===from?'保持':'推进'):from===3&&report.retired?'正常退休':from===3&&c.halted&&packet.fault?'异常/断点在WB停止':report.flushed.includes(packet.id)?(report.redirect?'跳转冲刷':'异常清除年轻指令'):c.halted?'停止时清空保存段':'异常排空清除';return [{id:packet.id,pc:packet.pc,from,to,reason,kind:to<0?'leave':to===from?'hold':'advance'}]});
 return {before,after,edges,action:report.action,arrivals:after.flatMap((packet,to)=>packet&&!before.some(old=>old?.id===packet.id)?[{id:packet.id,pc:packet.pc,to}]:[])};
}
function anatomyPipelineRTLFlowMarkup(p,mode,cycle){
 const flow=anatomyPipelineRTLFlow(p,mode,cycle);if(!flow)return '';
 const box=(packet,x,i)=>'<g><text x="'+(x+44)+'" y="'+(30+i*53)+'" text-anchor="middle">'+['IF/ID','ID/EX','EX/MEM','MEM/WB'][i]+'</text><rect x="'+x+'" y="'+(34+i*53)+'" width="88" height="36" rx="6" class="'+(packet?'packet':'bubble')+'"/><text x="'+(x+44)+'" y="'+(48+i*53)+'" text-anchor="middle">'+(packet?'#'+packet.id+' @'+packet.pc:'气泡')+'</text><text x="'+(x+44)+'" y="'+(62+i*53)+'" text-anchor="middle">'+(packet?anatomyPipelineRTLEscape(packet.d.name):'无效')+'</text></g>';
 return '<details class="pipe32-rtl-flow"><summary>看指令跨段移动 · 编号追踪</summary><p>指令编号来自与硬件状态逐拍一致的网页模型，硬件记录本身不含编号。</p><button data-rtl-flow-play>回放这一拍（不推进）</button><svg viewBox="0 0 280 256" role="img" aria-label="按独立指令编号连接上一拍和当前拍"><text x="48" y="18" text-anchor="middle">上一拍</text><text x="232" y="18" text-anchor="middle">当前拍</text>'+flow.before.map((packet,i)=>box(packet,4,i)).join('')+flow.after.map((packet,i)=>box(packet,188,i)).join('')+flow.edges.map(e=>{const y=52+e.from*53,y2=e.to<0?y:52+e.to*53,path='M94 '+y+' C128 '+y+' 152 '+y2+' '+(e.to<0?170:186)+' '+y2;return '<g data-rtl-flow-edge="'+e.id+'" data-kind="'+e.kind+'"><path d="'+path+'" class="flow-link '+e.kind+'"/><circle r="4" fill="#ffe69a" opacity="0"><animateMotion begin="indefinite" dur="1.2s" path="'+path+'"/><animate attributeName="opacity" values="1;1;0" keyTimes="0;.95;1" begin="indefinite" dur="1.2s"/></circle></g>'}).join('')+flow.arrivals.map(e=>{const y=52+e.to*53,path='M140 '+(y-18)+' Q163 '+(y-18)+' 186 '+y;return '<g data-rtl-flow-arrival="'+e.id+'"><path class="flow-link arrival" d="'+path+'"/><circle r="4" fill="#98e6ae" opacity="0"><animateMotion begin="indefinite" dur="1.2s" path="'+path+'"/><animate attributeName="opacity" values="1;1;0" keyTimes="0;.95;1" begin="indefinite" dur="1.2s"/></circle></g>'}).join('')+'</svg><p data-rtl-flow-status role="status">金色斜线：推进；青色横线：保持；虚线止于中间：离开保存段。新编号为本拍进入前端的指令。</p><ul class="pipe32-flow-reasons">'+flow.edges.filter(e=>e.kind!=='advance').map(e=>'<li data-rtl-flow-reason="'+e.id+'">#'+e.id+'：'+e.reason+'</li>').join('')+flow.arrivals.map(e=>'<li data-rtl-flow-new="'+e.id+'">#'+e.id+'：取指进入 IF/ID</li>').join('')+'</ul><p>本拍控制：'+anatomyPipelineRTLEscape(flow.action)+'</p><small>绿色轨迹为新取指进入；原因取自对齐模型的实际周期事件。动画速度只用于讲解。</small></details>';
}
function anatomyPipelineRTLTransitionMarkup(p,mode,cycle){
 const d=anatomyPipelineRTLChanges(p,mode,cycle);if(d.initial)return '';
 const esc=anatomyPipelineRTLEscape,describe=(valid,pc)=>!valid?'气泡':('0x'+pc.toString(16)+' '+(pc%4===0&&pc/4<p.words.length?anatomyDecodeRV32(p.words[pc/4]).name:'取指不可用'));
 return '<figure class="pipe32-rtl-transition"><figcaption>段状态对照 · 第'+(cycle-1)+'拍 → 第'+cycle+'拍</figcaption><svg viewBox="0 0 280 280" role="img" aria-label="四个段寄存器在相邻两拍的保存状态对照"><text x="68" y="18" text-anchor="middle">上一拍</text><text x="212" y="18" text-anchor="middle">当前拍</text>'+d.stages.map((v,i)=>{const y=30+i*61,changed=v.beforeValid!==v.afterValid||(v.afterValid&&v.beforePC!==v.afterPC);return '<g data-rtl-transition-stage="'+i+'" data-changed="'+changed+'"><text x="140" y="'+(y+8)+'" text-anchor="middle">'+['IF/ID','ID/EX','EX/MEM','MEM/WB'][i]+'</text>'+[[v.beforeValid,v.beforePC,4],[v.afterValid,v.afterPC,148]].map(([valid,pc,x])=>'<rect x="'+x+'" y="'+(y+15)+'" width="128" height="31" rx="7" class="'+(valid?'packet':'bubble')+'"/><text x="'+(x+64)+'" y="'+(y+35)+'" text-anchor="middle">'+esc(describe(valid,pc))+'</text>').join('')+'<path class="comparison-arrow" d="M135 '+(y+30)+'H145m-4 -4 4 4-4 4"/></g>'}).join('')+'</svg><small>箭头表示同一段的旧值与新值对照，不表示指令沿横向移动。虚线框为无效包；金色边框为状态变化。逐段传递请结合主图和周期时间表查看。</small></figure>';
}
function anatomyPipelineRTLChangesMarkup(p,mode,cycle){
 const d=anatomyPipelineRTLChanges(p,mode,cycle),hex=v=>'0x'+v.toString(16).padStart(8,'0');
 if(d.initial)return '<section class="pipe32-rtl-changes"><h4>这一拍改变了什么？</h4><p>这是首个已记录边沿；没有上一拍记录可供差分。段表显示本拍保存状态。</p></section>';
 const value=(name,v)=>'<li><b>'+name+'</b><span>'+hex(v.before)+' → '+hex(v.after)+'</span></li>',slot=(valid,pc)=>valid?'PC '+hex(pc):'气泡';
 return '<section class="pipe32-rtl-changes" data-rtl-changes><h4>这一拍改变了什么？</h4><p>对比第'+(cycle-1)+'拍 → 第'+cycle+'拍的硬件保存状态。</p><div class="pipe32-rtl-metrics"><span>退休 +'+d.retired+'</span><span>暂停 +'+d.stalls+'</span><span>跳转 +'+d.redirects+'</span></div>'+anatomyPipelineRTLTransitionMarkup(p,mode,cycle)+anatomyPipelineRTLFlowMarkup(p,mode,cycle)+'<h4>寄存器 / RAM / 输出</h4><ul>'+d.registers.map(v=>value('x'+v.index,v)).join('')+d.memory.map(v=>value('RAM['+v.index+'] 字节',v)).join('')+d.outputs.map(v=>value(v.key.toUpperCase(),v)).join('')+'</ul>'+(!d.registers.length&&!d.memory.length&&!d.outputs.length?'<p>这些保存值均未改变；相同值写入不会出现在差分中。</p>':'<small>列出数值变化；不等同于全部写使能事件。</small>')+'<h4>四个段寄存器</h4><ol>'+d.stages.map(v=>'<li><b>'+['IF/ID','ID/EX','EX/MEM','MEM/WB'][v.index]+'</b><span>'+slot(v.beforeValid,v.beforePC)+' → '+slot(v.afterValid,v.afterPC)+'</span></li>').join('')+'</ol>'+(d.stopped?'<p>本拍进入停止状态；查看状态原因区分断点与异常。</p>':'')+'<small>PC相同不能证明是同一动态指令实例；暂停与跳转以实际计数增量为准。</small></section>';
}
function anatomyPipelineRTLInspect(s,p,mode,cycle){
 const f=p.traces[mode][cycle-1],esc=anatomyPipelineRTLEscape,same=anatomyPipelineRTLSameProgram(s,p,mode)&&s.pipeline32.cycles===cycle,diff=same?anatomyPipelineRTLDiff(s.pipeline32,f):[],match=same&&!diff.length;
 const status=match?'主图已与这拍硬件记录逐项一致。':same?'不一致字段：'+diff.join('、'):'当前主图尚未对齐这拍；点击“对齐主图”将重建所选样例。';
 return `<p data-rtl-match="${match}" role="status">${esc(status)}</p><p>真实RTL记录：第${cycle}拍，退休${f.retired}，暂停${f.stalls}，跳转${f.redirects}。</p><table class="pipe32-rtl-stages"><thead><tr><th>边沿后保存包</th><th>有效</th><th>PC / 指令</th></tr></thead><tbody>${f.stageValid.map((valid,i)=>{const pc=f.stagePC[i],name=valid?(pc%4===0&&pc/4<p.words.length?anatomyDecodeRV32(p.words[pc/4]).name:'取指不可用'):'气泡';return `<tr data-rtl-stage="${i}" data-valid="${valid}" data-pc="${pc}"><th>${['IF/ID','ID/EX','EX/MEM','MEM/WB'][i]}</th><td>${+valid}</td><td>${valid?'0x'+pc.toString(16)+' / ':''}${esc(name)}</td></tr>`}).join('')}</tbody></table><p>该边沿EX前递：A=${['保存值/未使用','EX/MEM','MEM/WB'][f.forwardA]}，B=${['保存值/未使用','EX/MEM','MEM/WB'][f.forwardB]}。${f.pendingTrap?'正在异常排空或已停止。':''}</p>${anatomyPipelineRTLChangesMarkup(p,mode,cycle)}<small>主图展示该边沿后的保存包与下一拍候选。比较包含32寄存器、256字节RAM、外设、PC、段状态和控制计数；不是在浏览器运行RTL。</small>`;
}
function anatomyPipeline32RTLMarkup(s,options={}){
 const data=AN_PIPE32_RTL_DATA;
 if(!data)return '<details class="pipe32-rtl"><summary>真实RTL周期记录 · 与主图对齐</summary><p>读取本地已生成的硬件仿真记录；读取本身不改变当前程序。</p><button data-rtl-prepare>读取硬件记录</button><p data-rtl-error role="status"></p></details>';
 const c=s.pipeline32,matching=data.programs.find(p=>JSON.stringify(p.words)===JSON.stringify(c.program)),p=data.programs.find(p=>p.id===options.id)||matching||data.programs[0],mode=['stall','forward'].includes(options.mode)?options.mode:['stall','forward'].includes(c.mode)?c.mode:'forward',cycle=anatomyPipelineRTLSameProgram(s,p,mode)&&c.cycles>0&&c.cycles<=p.traces[mode].length?c.cycles:Math.min(p.traces[mode].length,Math.max(1,Math.floor(Number(options.cycle)||1))),esc=anatomyPipelineRTLEscape;
 return `<details class="pipe32-rtl"><summary>真实RTL周期记录 · 与主图对齐</summary><p>选取${data.programs.length}个课堂样例。记录来自实验包生成电路；完整验证覆盖${data.verifiedProgramCount}程序，RTL版本${esc(data.rtlSHA256.slice(0,12))}。对齐会重建样例、替换当前程序并清空观察历史；开关/按键设为记录中的固定值。</p><label>硬件样例<select data-rtl-case>${data.programs.map(x=>`<option value="${x.id}" ${x.id===p.id?'selected':''}>${esc(x.title)}</option>`).join('')}</select></label><label>修复策略<select data-rtl-mode><option value="forward" ${mode==='forward'?'selected':''}>前递与load-use暂停</option><option value="stall" ${mode==='stall'?'selected':''}>只暂停</option></select></label><label>记录周期<input data-rtl-cycle type="number" min="1" max="${p.traces[mode].length}" step="1" value="${cycle}"></label><div><button data-rtl-align>对齐主图</button><button data-rtl-prev ${cycle<=1?'disabled':''}>上一拍并对齐</button><button data-rtl-next ${cycle>=p.traces[mode].length?'disabled':''}>下一拍并对齐</button></div><p data-rtl-error role="status"></p><div data-rtl-inspect>${anatomyPipelineRTLInspect(s,p,mode,cycle)}</div><small>范围为已记录的硬件仿真周期；不代表实体FPGA时序。不处理冒险的错误策略另见主实验。</small></details>`;
}
function mountAnatomyPipelineRTL(host,s,{blocked,active,commit,loaded}){
 const panel=host.querySelector('.pipe32-rtl');if(!panel)return;
 panel.querySelector('[data-rtl-prepare]')?.addEventListener('click',async()=>{if(blocked())return;const button=panel.querySelector('[data-rtl-prepare]');button.disabled=true;try{await anatomyLoadPipelineRTL();if(active()&&!blocked())loaded()}catch(error){if(panel.isConnected)panel.querySelector('[data-rtl-error]').textContent=error.message}finally{if(button.isConnected)button.disabled=false}});
 panel.addEventListener('click',event=>{if(!event.target.closest('[data-rtl-flow-play]'))return;const flow=panel.querySelector('.pipe32-rtl-flow');if(!flow)return;const reduced=matchMedia('(prefers-reduced-motion: reduce)').matches;flow.querySelector('[data-rtl-flow-status]').textContent=reduced?'已按减少动态效果设置保留静态轨迹；实验未推进。':'正在回放所选边沿的指令轨迹；实验未推进。';if(!reduced){flow.querySelector('animateMotion')?.addEventListener('endEvent',()=>{if(flow.isConnected)flow.querySelector('[data-rtl-flow-status]').textContent='回放结束；实验未推进。可再次回放或对齐下一拍。'},{once:true});flow.querySelectorAll('animateMotion,animate').forEach(a=>a.beginElement());}});
 if(!AN_PIPE32_RTL_DATA)return;
 const choice=()=>{const p=AN_PIPE32_RTL_DATA.programs.find(p=>p.id===panel.querySelector('[data-rtl-case]').value),mode=panel.querySelector('[data-rtl-mode]').value,cycle=Number(panel.querySelector('[data-rtl-cycle]').value);return {p,mode,cycle}};
 function inspect(){const {p,mode}=choice(),input=panel.querySelector('[data-rtl-cycle]'),cycle=Math.min(p.traces[mode].length,Math.max(1,Number(input.value)||1));input.max=p.traces[mode].length;if(Number.isInteger(cycle)){input.value=cycle;panel.querySelector('[data-rtl-inspect]').innerHTML=anatomyPipelineRTLInspect(s,p,mode,cycle)}panel.querySelector('[data-rtl-prev]').disabled=cycle<=1;panel.querySelector('[data-rtl-next]').disabled=cycle>=p.traces[mode].length;}
 for(const selector of ['[data-rtl-case]','[data-rtl-mode]','[data-rtl-cycle]'])panel.querySelector(selector).addEventListener('change',inspect);
 function align(delta=0){if(blocked())return;const {p,mode,cycle}=choice(),target=cycle+delta;try{const c=anatomyPipelineRTLRebuild(p,mode,target);commit(c,p,mode)}catch(error){panel.querySelector('[data-rtl-error]').textContent=error.message}}
 panel.querySelector('[data-rtl-align]').onclick=()=>align();panel.querySelector('[data-rtl-prev]').onclick=()=>align(-1);panel.querySelector('[data-rtl-next]').onclick=()=>align(1);
}
