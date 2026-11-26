import {mountSchematic} from './anatomy-schematic.js';
// Flat SVG diagrams. No canvas, WebGL, orbit controls, perspective or animation.
const NS='http://www.w3.org/2000/svg';
const COLORS={data:'#56cfe9',control:'#c399ef',clock:'#f1c65f',carry:'#f6a65c',power:'#da9f70',analog:'#e88eb0',protocol:'#a8bdff'};
export function mountAnatomyDiagram(host,b,onSelect,onEnter){
 if(b.id==='board')return mountFlatBoard(host,b,onSelect,onEnter);
 return mountSchematic(host,b,onSelect,onEnter);
}

// Preserve the existing detailed two-dimensional replica at the top level.
function mountFlatBoard(host,b,onSelect,onEnter){
 const frame=document.createElement('div');frame.className='an-flat-board learning-board-shell';frame.setAttribute('role','group');const board=document.getElementById('basysBoard').cloneNode(true);frame.append(board);host.append(frame);
 const idMap=new Map();board.querySelectorAll('[id]').forEach(e=>{idMap.set(e.id,'flat-'+e.id);e.dataset.boardOriginal=e.id;e.id='flat-'+e.id});board.removeAttribute('id');
 for(const node of board.querySelectorAll('*'))for(const attr of [...node.attributes])if(/url\(#|^#/.test(attr.value)){let value=attr.value;for(const [old,next]of idMap)value=value.replaceAll('url(#'+old+')','url(#'+next+')').replace('#'+old,'#'+next);node.setAttribute(attr.name,value)}
 const original=id=>board.querySelector('[data-board-original="'+id+'"]');
 const topicPart={fpga:'FPGA',clock:'OSC',memory:'FLASH',programming:'JTAG',uart:'JTAG',usbhost:'USB',vga:'VGA',xadc:'ADC',power:'POWER',sevenseg:'SEG',leds:'LED'};
 const targets={FPGA:board.querySelector('[data-topic="fpga"]'),SW:original('switches'),LED:original('leds'),SEG:original('sevenseg'),BTN:original('boardKeys'),STATUS:board.querySelector('.power-ind')};
 for(const e of board.querySelectorAll('.hotspot')){let topic=e.dataset.topic,part=topicPart[topic];if(topic==='pmod'){let label=e.getAttribute('aria-label')||'';part=label.includes('JB')?'JB':label.includes('JC')?'JC':'JA'}if(part){targets[part]??=e;e.onclick=()=>onSelect({part});e.ondblclick=()=>onEnter(part)}}
 for(const [part,node]of Object.entries(targets))if(node){if(!node.classList.contains('hotspot')){node.onclick=e=>{e.stopPropagation();onSelect({part})};node.ondblclick=e=>{e.stopPropagation();onEnter(part)}}}
 board.querySelectorAll('[data-learn-bit]').forEach(e=>{e.onclick=ev=>{ev.stopPropagation();onSelect({part:'SW',swBit:Number(e.dataset.learnBit)})};e.ondblclick=ev=>{ev.stopPropagation();onEnter('SW')}});
 original('leds')?.querySelectorAll('.led').forEach((node,i)=>{const hit=node.closest('.pin')||node;hit.setAttribute('role','button');hit.tabIndex=0;hit.onkeydown=ev=>{if(ev.key==='Enter'||ev.key===' '){ev.preventDefault();onSelect({part:'LED',ledBit:15-i})}};hit.onclick=ev=>{ev.stopPropagation();onSelect({part:'LED',ledBit:15-i})};hit.ondblclick=ev=>{ev.stopPropagation();onEnter('LED')}});
 original('sevenseg')?.querySelectorAll('.digit').forEach((node,i)=>{node.setAttribute('role','button');node.tabIndex=0;node.onkeydown=ev=>{if(ev.key==='Enter'||ev.key===' '){ev.preventDefault();onSelect({part:'SEG',displayDigit:3-i})}};node.onclick=ev=>{ev.stopPropagation();onSelect({part:'SEG',displayDigit:3-i})};node.ondblclick=ev=>{ev.stopPropagation();onEnter('SEG')}});
 board.querySelectorAll('.board-key').forEach((e,i)=>{e.onclick=ev=>{ev.stopPropagation();onSelect({part:'BTN',btnBit:i})};e.ondblclick=ev=>{ev.stopPropagation();onEnter('BTN')}});
 const overlay=document.createElementNS(NS,'svg');overlay.classList.add('an-board-links');frame.append(overlay);let savedState={},savedEvaluation={},savedStep=null,savedSelection=null;
 function update(state={},evaluation={},step=null,selection=null){savedState=state;savedEvaluation=evaluation;savedStep=step;savedSelection=selection;
 frame.dataset.signalSource=state.boardMode==='cpu32'?'cpu32':state.boardMode==='buttons'?'buttons':'adder';frame.dataset.switchValue=String(state.sw??0);frame.dataset.buttonValue=String(state.btnMask??0);frame.dataset.ledValue=String(evaluation.led??0);frame.dataset.displayValue=String(state.boardMode==='cpu32'?state.cpu32.display:evaluation.result??0);if(state.boardMode==='cpu32')frame.dataset.cpuPc=String(state.cpu32.pc);else delete frame.dataset.cpuPc;frame.setAttribute('aria-label',(state.boardMode==='cpu32'?'同一CPU32的整板状态':state.boardMode==='buttons'?'按键直连四灯整板状态':'组合加法整板状态')+'，开关'+(state.sw??0)+'，LED'+(evaluation.led??0));
 original('switches')?.querySelectorAll('[data-learn-bit]').forEach(e=>{const v=(state.sw>>Number(e.dataset.learnBit))&1;e.disabled=!!evaluation.readOnly;e.classList.toggle('on',!!v);e.setAttribute('aria-pressed',String(!!v));e.setAttribute('aria-label','SW'+e.dataset.learnBit+'='+v+'，点击切换输入')});
 original('leds')?.querySelectorAll('.led').forEach((e,i)=>{const v=(evaluation.led>>>(15-i))&1;e.classList.toggle('on',!!v);(e.closest('.pin')||e).setAttribute('aria-label','LD'+(15-i)+' 输出='+v+'；点击观察，双击展开')});
 original('sevenseg')?.querySelectorAll('.digit').forEach((digit,i)=>digit.querySelectorAll('polygon').forEach((p,j)=>p.classList.toggle('lit',!!(evaluation.digits?.[3-i]&(1<<j)))));
 original('leds')?.querySelectorAll('.led').forEach((node,i)=>{node.setAttribute('role','button');node.tabIndex=0;node.onkeydown=ev=>{if(ev.key==='Enter'||ev.key===' '){ev.preventDefault();onSelect({part:'LED',ledBit:15-i})}};node.onclick=ev=>{ev.stopPropagation();onSelect({part:'LED',ledBit:15-i})};node.ondblclick=ev=>{ev.stopPropagation();onEnter('LED')}});
 original('sevenseg')?.querySelectorAll('.digit').forEach((node,i)=>{node.setAttribute('role','button');node.tabIndex=0;node.onkeydown=ev=>{if(ev.key==='Enter'||ev.key===' '){ev.preventDefault();onSelect({part:'SEG',displayDigit:3-i})}};node.onclick=ev=>{ev.stopPropagation();onSelect({part:'SEG',displayDigit:3-i})};node.ondblclick=ev=>{ev.stopPropagation();onEnter('SEG')}});
 board.querySelectorAll('.board-key').forEach((e,i)=>{const pressed=!!(state.btnMask&(1<<i));e.disabled=!!evaluation.readOnly;e.classList.toggle('pressed',pressed);e.setAttribute('aria-pressed',String(pressed))});
 board.querySelectorAll('.power-ind i').forEach((e,i)=>e.classList.toggle('off',!(i?evaluation.done:evaluation.power)));
 for(const [id,node]of Object.entries(targets))node?.classList.toggle('an-board-chosen',selection?.part===id);
 overlay.replaceChildren();let base=frame.getBoundingClientRect();overlay.setAttribute('viewBox','0 0 '+base.width+' '+base.height);
 const point=id=>{let e=targets[id];if(!e)return null;let r=e.getBoundingClientRect();return [r.left-base.left+r.width/2,r.top-base.top+r.height/2]};
 for(const n of b.nets.filter(n=>selection?.net===n.name||step?.nets?.includes(n.name))){let a=point(n.from.split('.')[0]),z=point(n.to.split('.')[0]);if(!a||!z)continue;let p=document.createElementNS(NS,'path');p.setAttribute('d',`M${a[0]} ${a[1]}H${(a[0]+z[0])/2}V${z[1]}H${z[0]}`);p.setAttribute('stroke',COLORS[n.role]||COLORS.data);p.setAttribute('stroke-width','2');p.setAttribute('fill','none');overlay.append(p);let t=document.createElementNS(NS,'text');t.setAttribute('x',(a[0]+z[0])/2+5);t.setAttribute('y',(a[1]+z[1])/2);t.textContent=n.name+(evaluation.nets?.[n.name]!==undefined?' = '+evaluation.nets[n.name]:'');overlay.append(t)}
 host.dataset.render='ready';host.dataset.mode='2d';host.dataset.level=b.id;host.dataset.partCount=b.parts.length;host.dataset.netCount=b.nets.length;
 }
 const resize=new ResizeObserver(()=>update(savedState,savedEvaluation,savedStep,savedSelection));resize.observe(frame);update();return{supported:true,update,dispose(){resize.disconnect();frame.remove()}};
}
