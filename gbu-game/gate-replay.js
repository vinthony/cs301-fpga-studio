import {createGate3d} from './gate-3d.js';
// Four LED values come from four RTL simulation samples, in SW order 00,01,10,11.
export function gateTrace(samples){
 if(!Array.isArray(samples)||samples.length!==4)throw Error('仿真返回的门禁样本数量不完整');
 const expected=[0,1,0,0];return samples.map((sample,i)=>{let bits=sample?.led;let value=typeof bits==='string'&&/^[01]+$/.test(bits)?parseInt(bits,2):null;return {a:i&1,b:(i>>1)&1,actual:value===0||value===1?value:null,expected:expected[i]}});
}
export function showGateReplay(host,rows){
 let selected=0,timer=null;host.innerHTML=`<section class="gate-replay" aria-label="门禁仿真回放"><div class="gate-replay-head"><strong>门禁仿真回放</strong><span>来自本次 RTL 输出 · 点击样本查看</span></div><div class="gate-scene"><div class="gate-signals"><span id="gateA"></span><span id="gateB"></span></div><div class="gate-3d" aria-label="三维门禁动画"></div><div class="gate-lane"><span class="gate-cart" aria-hidden="true">▣</span><span class="gate-post" aria-hidden="true"><i></i></span><span class="gate-lamp" aria-hidden="true"></span></div><div class="gate-result" id="gateResult" aria-live="polite"></div></div><div class="gate-samples">${rows.map((r,i)=>`<button type="button" data-gate-sample="${i}" aria-pressed="false">A${r.a} B${r.b}</button>`).join('')}<button type="button" id="gateReplayAgain">重播 ▶</button></div></section>`;
 const $=id=>host.querySelector('#'+id),buttons=[...host.querySelectorAll('[data-gate-sample]')],scene=host.querySelector('.gate-scene');let model=null;try{model=createGate3d(host.querySelector('.gate-3d'));host.querySelector('.gate-lane').hidden=true}catch(e){host.querySelector('.gate-3d').hidden=true}
 function show(i){selected=i;let r=rows[i],known=r.actual!==null;model?.set(r.actual);scene.classList.toggle('is-open',r.actual===1);scene.classList.toggle('is-unknown',!known);$('gateA').textContent=`通行证 A = ${r.a}`;$('gateB').textContent=`警报 B = ${r.b}`;$('gateResult').textContent=`电路输出 ${known?r.actual:'未知'} · ${!known?'结果未知':r.actual?'闸门打开':'闸门关闭'} · 期望 ${r.expected}${r.actual!==r.expected?' · 不匹配':''}`;buttons.forEach((b,j)=>b.setAttribute('aria-pressed',String(i===j)))}
 function stop(){if(timer!==null)clearInterval(timer);timer=null}
 function replay(){stop();show(0);timer=setInterval(()=>{if(!host.isConnected){stop();return}if(selected>=rows.length-1){stop();return}show(selected+1)},900)}
 buttons.forEach((b,i)=>b.onclick=()=>{stop();show(i)});$('gateReplayAgain').onclick=replay;replay();return ()=>{stop();model?.dispose()};
}
