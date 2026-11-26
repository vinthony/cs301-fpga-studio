const head=`module board_top(input clk, input reset, input [15:0] sw, input [4:0] btn,
 output [15:0] led, output [31:0] display);
`;
const missions=[
{id:'gate',week:'WEEK 03 · 组合逻辑',title:'01 / 城门的双重认证',story:'快递细胞要穿过城门：只有通行证有效且没有危险警报，守卫才放行。',rules:'SW0＝通行证，SW1＝危险警报。LED0＝放行；LED1＝拦截。两个输出必须互补。',roles:['快递细胞','城门守卫'],help:['通行证 SW0','警报 SW1'],starter:head+`// TODO：按规则产生 allow 和 block
assign led = 16'b0;
assign display = 32'b0;
endmodule`,solution:head+`wire allow = sw[0] & ~sw[1];
assign led = {14'b0, ~allow, allow};
assign display = {30'b0, ~allow, allow};
endmodule`,tests:[{sw:0,tick:0,want:2},{sw:1,tick:0,want:1},{sw:2,tick:0,want:2},{sw:3,tick:0,want:2}]},
{id:'counter',week:'WEEK 06 · 时序逻辑',title:'02 / 能量补给站',story:'能源细胞每次收到时钟，就为城市补充一格能量；补给许可关闭时，能量保持原样。',rules:'SW0＝补给许可。复位时能量为 0；每个上升沿许可为 1 则 4 位计数加 1，15 后回到 0。LED3:0 显示能量。',roles:['能源细胞','储能仓'],help:['补给许可 SW0'],starter:head+`reg [3:0] energy;
always @(posedge clk) begin
  if (reset) energy <= 0;
  // TODO：许可有效时更新 energy
end
assign led = {12'b0, energy};
assign display = {28'b0, energy};
endmodule`,solution:head+`reg [3:0] energy;
always @(posedge clk) begin
  if (reset) energy <= 0;
  else if (sw[0]) energy <= energy + 1'b1;
end
assign led = {12'b0, energy};
assign display = {28'b0, energy};
endmodule`,tests:[{reset:1,tick:1,want:0},{sw:1,tick:1,want:1},{sw:0,tick:1,want:1},...Array.from({length:15},(_,i)=>({sw:1,tick:1,want:(i+2)%16})),{reset:1,sw:1,tick:1,want:0}]},
{id:'fsm',week:'WEEK 07 · 状态机',title:'03 / 病毒信号识别',story:'巡逻细胞连续读取信号，发现 101 序列时发出一次警报。信号可能重叠，比如 10101 包含两次。',rules:'SW0 为输入位，每个上升沿采样一次。LED0 在识别 101 的那个周期为 1，其余为 0；复位清除状态。',roles:['巡逻细胞','警报细胞'],help:['信号位 SW0'],starter:head+`reg [1:0] state;
reg alarm;
always @(posedge clk) begin
  if (reset) begin state <= 0; alarm <= 0; end
  else begin
    alarm <= 0;
    // TODO：状态转移和检测 101，可重叠
  end
end
assign led = {15'b0, alarm};
assign display = {30'b0, state};
endmodule`,solution:head+`reg [1:0] state;
reg alarm;
always @(posedge clk) begin
  if (reset) begin state <= 0; alarm <= 0; end
  else begin
    alarm <= 0;
    case (state)
      0: if (sw[0]) state <= 1;
      1: if (!sw[0]) state <= 2;
      2: if (sw[0]) begin state <= 1; alarm <= 1; end
         else state <= 0;
      default: state <= 0;
    endcase
  end
end
assign led = {15'b0, alarm};
assign display = {30'b0, state};
endmodule`,tests:[{reset:1,tick:1,want:0},{sw:1,tick:1,want:0},{sw:0,tick:1,want:0},{sw:1,tick:1,want:1},{sw:0,tick:1,want:0},{sw:1,tick:1,want:1},{sw:1,tick:1,want:0},{reset:1,tick:1,want:0}]}
];
const $=id=>document.getElementById(id);let current=0,sw=0,events=[],lastCode='', mode=null, timer=null, demoStep=0, running=false;
function save(){localStorage.setItem('chip-cell-'+missions[current].id,$('code').value)}
function load(i){stopMode();if($('code').value)save();current=i;sw=0;events=[];lastCode='';let m=missions[i];$('code').value=localStorage.getItem('chip-cell-'+m.id)||m.starter;$('week').textContent=m.week;$('title').textContent=m.title;$('story').textContent=m.story;$('rules').textContent=m.rules;$('role0').textContent=m.roles[0];$('role1').textContent=m.roles[1];$('state0').textContent=$('state1').textContent='等待仿真';$('cell0').classList.remove('on');$('cell1').classList.remove('on');$('actual').textContent='尚未执行';window.dispatchEvent(new CustomEvent('city-mission',{detail:{id:m.id}}));$('log').textContent='准备就绪';$('testResult').textContent='尚未测试';render()}
function render(){let m=missions[current];$('missions').innerHTML=missions.map((x,i)=>`<button class="mission ${i===current?'active':''}" data-i="${i}"><small>${x.week}</small><b>${x.title}</b></button>`).join('');document.querySelectorAll('.mission').forEach(b=>b.onclick=()=>load(Number(b.dataset.i)));$('inputHelp').textContent=m.rules;$('switches').innerHTML=m.help.map((x,i)=>`<button class="switch ${sw&(1<<i)?'on':''}" data-bit="${i}" aria-pressed="${!!(sw&(1<<i))}">${x}：${sw&(1<<i)?'开':'关'}</button>`).join('');document.querySelectorAll('.switch').forEach(b=>b.onclick=()=>{sw^=1<<Number(b.dataset.bit);render()})}
async function sim(ev,code=$('code').value){let r=await fetch('/api/sim',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({code,events:ev,profile:'teaching',program:''})});let d=await r.json();if(!r.ok)throw Error(d.error||'仿真失败');return d.samples}
function value(bits){return /^[01]+$/.test(bits||'')?parseInt(bits,2):null}
async function interact(tick,reset){try{let code=mode==='demo'?missions[current].solution:$('code').value;if(code!==lastCode){events=[];lastCode=code}let next=[...events,{sw,btn:0,reset,tick}];let samples=await sim(next,code);events=next;let s=samples.at(-1),led=value(s.led),display=value(s.display);$('actual').textContent=`${mode==='demo'?'示范电路 · ':''}LED = ${led===null?'未知':led} · DISPLAY = ${display===null?'未知':display} · ${events.length} 次采样`;let a=!!(sw&1),b=led!==null&&!!(led&1);$('cell0').classList.toggle('on',a);$('cell1').classList.toggle('on',b);$('state0').textContent=a?'输入 1':'输入 0';$('state1').textContent=led===null?'输出未知':b?'LED0 = 1':'LED0 = 0';window.dispatchEvent(new CustomEvent('city-sample',{detail:{id:missions[current].id,sw,led,display,tick,reset}}));$('log').textContent='真实 RTL 仿真完成。代码修改后互动记录会重新开始；时序任务请先复位。';return true}catch(e){$('log').textContent=e.message;stopMode();return false}}
async function test(){let m=missions[current];$('testResult').textContent='正在仿真…';try{let data=await sim(m.tests.map(x=>({sw:x.sw||0,btn:0,reset:x.reset||0,tick:x.tick||0})));let bad=m.tests.map((t,i)=>({i,expected:t.want,actual:value(data[i].led)})).filter(x=>x.actual!==x.expected);$('testResult').textContent=bad.length?`未通过：${m.tests.length-bad.length}/${m.tests.length} 项。\n第 ${bad[0].i+1} 个采样：LED 期望 ${bad[0].expected}，实际 ${bad[0].actual===null?'未知':bad[0].actual}。`:`任务通过！${m.tests.length}/${m.tests.length} 项断言通过。继续设计自己的边界测试。` }catch(e){$('testResult').textContent='编译或仿真失败：'+e.message}}
function dirty(){stopMode();save();$('actual').textContent='代码已修改，请重新采样';$('state0').textContent=$('state1').textContent='等待重新采样';window.dispatchEvent(new CustomEvent('city-dirty'));}
$('code').addEventListener('input',dirty); async function guarded(fn){if(running)return;running=true;let locked=[...document.querySelectorAll('button')].filter(b=>b.id!=='resetCamera');locked.forEach(b=>b.disabled=true);$('code').disabled=true;try{await fn()}finally{locked.forEach(b=>b.disabled=false);$('code').disabled=false;running=false}}
function stopMode(){if(mode==='demo'){events=[];lastCode='';}if(timer)clearTimeout(timer);timer=null;mode=null;if($('demo'))$('demo').textContent='▶ 播放关卡示范';if($('auto'))$('auto').textContent='▶ 自动时钟';if($('modeLabel'))$('modeLabel').textContent='示范使用参考电路，不覆盖你的代码';}
async function startMode(next){if(mode===next){stopMode();return}stopMode();mode=next;demoStep=0;events=[];lastCode='';$('demo').textContent=next==='demo'?'■ 停止示范':'▶ 播放关卡示范';$('auto').textContent=next==='auto'?'■ 停止时钟':'▶ 自动时钟';$('modeLabel').textContent=next==='demo'?'示范运行中 · 使用参考电路，编辑器代码未改变':'自动时钟 · 使用编辑器中的电路';if(next==='demo'){sw=0;render();await guarded(()=>interact(1,1));}if(mode===next)stepMode(next)}
async function stepMode(expected){if(mode!==expected)return;if(events.length>=128){stopMode();$('log').textContent='自动运行已达到 128 次采样，请复位后继续。';return}if(expected==='demo'){const id=missions[current].id;sw=id==='gate'?[1,3,1,0][demoStep%4]:id==='counter'?1:[1,0,1,0][demoStep%4];render();demoStep++}await guarded(()=>interact(expected==='demo'&&missions[current].id==='gate'?0:1,0));if(mode===expected)timer=setTimeout(()=>stepMode(expected),1100)}
$('demo').onclick=()=>startMode('demo');$('auto').onclick=()=>startMode('auto');$('sample').onclick=()=>{stopMode();guarded(()=>interact(0,0))};$('clock').onclick=()=>{stopMode();guarded(()=>interact(1,0))};$('reset').onclick=()=>{stopMode();guarded(()=>interact(1,1))};$('test').onclick=()=>{stopMode();guarded(test)};$('starter').onclick=()=>{if(confirm('恢复初始代码会覆盖当前关卡的编辑，继续吗？')){$('code').value=missions[current].starter;dirty()}};$('solution').onclick=()=>{if(confirm('载入参考实现会覆盖当前关卡的编辑，继续吗？')){$('code').value=missions[current].solution;dirty()}};load(0);
