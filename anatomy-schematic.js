import {updateMultiplyRegister} from './anatomy-multiply-symbol.js';
import {updateAsyncSymbol} from './anatomy-async-symbol.js';
import {updateUARTSymbol} from './anatomy-uart-symbol.js';
import {updateFIFOSymbol} from './anatomy-fifo-symbol.js';
import {updateFlashSymbol} from './anatomy-flash-symbol.js';
import {updatePipelineSymbol} from './anatomy-pipe-symbol.js';
import {updateInputSymbol} from './anatomy-input-symbol.js';
import {updateRepresentationSymbol} from './anatomy-repr-symbol.js';
import {updateCPU32Symbol} from './anatomy-cpu32-symbol.js';
import {updateDecoder32Symbol} from './anatomy-dec32-symbol.js';
import {updateImmediate32Symbol} from './anatomy-imm32-symbol.js';
import {updateRF32Symbol} from './anatomy-rf32-symbol.js';
import {drawFunctionalSymbol} from './anatomy-symbols.js';
import {layoutSpec} from './anatomy-layouts.js';
const NS='http://www.w3.org/2000/svg';
export const ink={data:'#087f9e',control:'#9350d2',clock:'#b87a09',carry:'#d66a2c',power:'#bd654c',analog:'#c04991',protocol:'#4269cb'};
const gateTypes=new Set(['and','nand','or','nor','xor','not','inverter','mux']);
const materialTypes=new Set(['substrate','diffusion','oxide','electrode','die','lid','bga','depletion','pregion','nregion']);
export function prepareSchematic(b){
 const spec=layoutSpec(b.id);if(!spec)throw Error('缺少独立平面布局：'+b.id);
 const parts=b.parts.map(p=>{let point=spec.points[p.id];if(!point)throw Error(b.id+' 未排布器件 '+p.id);let type=p.type,w=176,h=104;
  if(type==='multiplyRegister'){w=p.id==='B'?240:340;h=150}if(type==='asyncSync'){w=330;h=210}if(type==='asyncControl'){w=360;h=220}if(type==='asyncShift'){w=360;h=220}if(type==='uartStage'){w=300;h=210}if(type==='fifoBytes'){w=340;h=190}if(type==='flashControl'){w=340;h=190}if(type==='flashBytes'){w=340;h=240}if(type==='pipeStage'){w=250;h=200}if(type==='pipeControl'){w=450;h=160}if(['pipeRF','pipeMem'].includes(type)){w=300;h=180}if(type==='inputSync'){w=260;h=196}if(['inputDebounce','inputEvent'].includes(type)){w=300;h=220}if(type==='reprInterpretation'){w=280;h=180}if(type==='cpu32pc'){w=176;h=164}if(['cpu32alu','cpu32im','cpu32rf','cpu32mem'].includes(type)){w=280;h=230}if(['cpu32target','cpu32branch'].includes(type)){w=300;h=180}if(type==='cpu32board'){w=320;h=245}if(type==='dec32table'){w=1000;h=900}if(type==='dec32control'){w=340;h=730}if(type==='imm32map'){w=1180;h=620}if(type==='rf32bank'){w=1000;h=660}if(type==='port'){w=b.id==='regfile32'?114:94;h=42}if(type==='rail'){w=86;h=26}if(gateTypes.has(type)){w=108;h=74}if(type==='mux'){w=94;h=124}if(['nmos','pmos'].includes(type)){w=76;h=94}if(['resistor','capacitor','inductor'].includes(type)){w=118;h=64}if(type==='display'){w=236;h=112}if(type==='bitgrid'){w=220;h=206}if(b.id==='segmentdecode'&&p.id==='L'){w=270;h=440}if(type==='fa'){w=160;h=122}if(type==='lut'){w=182;h=138}if(type==='muxtree'){w=246;h=240}if(type==='ram'||type==='regfile'||type==='cache'){w=192;h=140}
  if(type==='counter'&&p.storageBits){w=p.storageBits>4?330:176;h=112}if(p.coordinatePair){w=330;h=204}
  if(b.id==='rx'&&p.id==='FSM'){w=250;h=220}
  if(b.id==='slice'&&p.id==='CY'){w=96;h=660}if(b.id==='slice'&&p.id==='MUX'){w=86;h=140}
  if(b.id==='fpgaFabric'){if(p.id==='PACKAGE'){w=1080;h=650}if(type==='iobank'){w=82;h=370}if(['BRAM','DSP'].includes(p.id)){w=108;h=230}if(type==='clockspine'){w=32;h=160}if(type==='clb'){w=176;h=132}}
  if(b.id==='packageView'){w={LID:800,DIE:480,SUB:900,BALLS:800}[p.id];h={LID:60,DIE:90,SUB:70,BALLS:60}[p.id]}
  if(['nmos','pmos'].includes(b.id)){w={BODY:880,SOURCE:180,DRAIN:180,OXIDE:220,GATE:170}[p.id];h={BODY:210,SOURCE:110,DRAIN:110,OXIDE:18,GATE:58}[p.id]}
  if(b.id==='io'&&p.id==='FPGA'){w=360;h=920}
  if(b.id==='ledjunction'){w=210;h=160;if(type==='port'){w=90;h=42}}
  return {...p,cx:point[0],cy:point[1],w,h,ports:new Map()};
 });const map=new Map(parts.map(p=>[p.id,p]));
 for(const n of b.nets)for(const [end,dir]of [[n.from,'out'],[n.to,'in']]){let [id,pin]=end.split('.'),p=map.get(id);if(!p)throw Error('Unknown '+end);if(!p.ports.has(pin))p.ports.set(pin,{pin,dir,role:n.role,bits:n.bits,names:[]});p.ports.get(pin).names.push(n.name)}
 for(const p of parts){const bySide={left:[],right:[],bottom:[],top:[]};
  for(const port of p.ports.values()){let side=port.dir==='out'?'right':'left';
   if(p.type==='port')side=port.dir==='in'?'left':'right';
   else if(p.type==='rail'){side=/GND|PLATE/.test(p.id)?'top':'bottom'}
   else if(['nmos','pmos'].includes(p.type)){side=port.pin==='g'?'left':port.pin==='s'?(p.type==='pmos'?'top':'bottom'):'top';if(port.pin==='d')side=p.type==='pmos'?'bottom':'top'}
   else if(p.type==='capacitor'&&port.pin==='return')side='right';
   else if(['clk','en','we','rst','sel','tick','valid','t','wl','s','ctrl'].includes(port.pin)&&port.dir==='in')side='bottom';
   else if(p.type==='fa'&&port.pin==='ci')side='left';
   port.side=side;bySide[side].push(port);
  }
  for(const [side,ports]of Object.entries(bySide)){ports.sort((a,z)=>a.pin.localeCompare(z.pin,undefined,{numeric:true}));for(let i=0;i<ports.length;i++){let port=ports[i],f=(i+1)/(ports.length+1),x=p.cx,y=p.cy;
    if(side==='left'||side==='right'){x+=side==='left'?-p.w/2:p.w/2;y+=gateTypes.has(p.type)?(f-.5)*p.h*.85:(f-.5)*Math.max(36,p.h-38);if(ports.length===1)y=p.cy}
    else{y+=side==='top'?-p.h/2:p.h/2;x+=(f-.5)*Math.max(36,p.w-36)}
    if(['nmos','pmos'].includes(p.type)&&port.pin!=='g')x=p.cx+24;
    port.xy=[x+(side==='right'?22:side==='left'?-22:0),y+(side==='bottom'?22:side==='top'?-22:0)];
    if(side==='left'&&p.type==='alu'&&Math.abs(y-p.cy)<17)x+=27*(1-Math.abs(y-p.cy)/17);
    if(side==='left'&&['or','nor','xor'].includes(p.type)){const t=(y-(p.cy-p.h/2))/p.h;x+=60*t*(1-t)}
    if(side==='right'&&['nand','nor','not','inverter'].includes(p.type))x+=12;
    port.touch=[x,y];
  }}
 }
 return {spec,parts,map,size:spec.size||[1320,760]};
}
// A sparse visibility grid, with component/caption keepouts and separate corridors for independent nets.
export function routeWire(a,z,boxes,occupied=[]){
 const xs=[...new Set([a[0],z[0],...boxes.flatMap(b=>[b.l-12,b.r+12])])].sort((x,y)=>x-y),ys=[...new Set([a[1],z[1],...boxes.flatMap(b=>[b.t-12,b.b+12])])].sort((x,y)=>x-y);
 const crosses=(a,z,b)=>a[0]===z[0]?a[0]>b.l&&a[0]<b.r&&Math.max(a[1],z[1])>b.t&&Math.min(a[1],z[1])<b.b:a[1]>b.t&&a[1]<b.b&&Math.max(a[0],z[0])>b.l&&Math.min(a[0],z[0])<b.r;
 const overlap=(a,z,c,d)=>a[0]===z[0]&&c[0]===d[0]&&Math.abs(a[0]-c[0])<.1?Math.max(Math.min(a[1],z[1]),Math.min(c[1],d[1]))<Math.min(Math.max(a[1],z[1]),Math.max(c[1],d[1]))-.1:a[1]===z[1]&&c[1]===d[1]&&Math.abs(a[1]-c[1])<.1?Math.max(Math.min(a[0],z[0]),Math.min(c[0],d[0]))<Math.min(Math.max(a[0],z[0]),Math.max(c[0],d[0]))-.1:false;
 const sx=xs.indexOf(a[0]),sy=ys.indexOf(a[1]),ex=xs.indexOf(z[0]),ey=ys.indexOf(z[1]);const key=(x,y,dir)=>x+','+y+','+dir;
 let open=[{x:sx,y:sy,dir:0,g:0,f:0}],best=new Map(),prev=new Map(),goal=null;
 while(open.length){open.sort((a,b)=>b.f-a.f);let cur=open.pop(),ck=key(cur.x,cur.y,cur.dir);if(cur.g>(best.get(ck)??Infinity))continue;if(cur.x===ex&&cur.y===ey){goal=ck;break}
 for(const [dx,dy,dir]of [[1,0,1],[-1,0,1],[0,1,2],[0,-1,2]]){let x=cur.x+dx,y=cur.y+dy;if(x<0||y<0||x>=xs.length||y>=ys.length)continue;let p=[xs[cur.x],ys[cur.y]],q=[xs[x],ys[y]];if(boxes.some(b=>crosses(p,q,b))||occupied.some(e=>overlap(p,q,...e)))continue;let g=cur.g+Math.abs(q[0]-p[0])+Math.abs(q[1]-p[1])+(cur.dir&&cur.dir!==dir?28:0),k=key(x,y,dir);if(g>=(best.get(k)??Infinity))continue;best.set(k,g);prev.set(k,ck);open.push({x,y,dir,g,f:g+Math.abs(xs[x]-z[0])+Math.abs(ys[y]-z[1])})}}
 if(!goal)return null;let points=[];while(goal){let [x,y]=goal.split(',').map(Number);points.push([xs[x],ys[y]]);goal=prev.get(goal)}points.reverse();return points.filter((p,i,arr)=>!i||i===arr.length-1||!((arr[i-1][0]===p[0]&&p[0]===arr[i+1][0])||(arr[i-1][1]===p[1]&&p[1]===arr[i+1][1])));
}
export function mountSchematic(host,b,onSelect,onEnter){
 const layout=prepareSchematic(b),svg=document.createElementNS(NS,'svg');svg.classList.add('an-diagram-svg','an-schematic');svg.setAttribute('role','img');svg.setAttribute('aria-label',b.title+' 精排二维电路图');host.append(svg);
 const e=(tag,attrs={},parent=svg)=>{let n=document.createElementNS(NS,tag);for(let [k,v]of Object.entries(attrs))n.setAttribute(k,v);parent.append(n);return n};
 const t=(str,x,y,attrs={},parent=svg)=>{let n=e('text',{x,y,...attrs},parent);n.textContent=str;return n};
 const r=(x,y,w,h,attrs={},parent=svg)=>e('rect',{x,y,width:w,height:h,...attrs},parent);
 const line=(d,attrs={},parent=svg)=>e('path',{d,fill:'none',...attrs},parent);
 const textWidth=s=>Array.from(s).reduce((n,c)=>n+(c.charCodeAt(0)>255?1:.57),0)*15;
 function wrapped(str,x,y,maxWidth,attrs,parent){let lines=[],current='';for(const ch of str.match(/[A-Za-z0-9_]+|\s+|./gu)||[]){if(textWidth(current+ch)>maxWidth&&current){lines.push(current.trim());current=ch.trimStart()}else current+=ch}if(current)lines.push(current);return lines.map((s,i)=>t(s,x,y+i*20,attrs,parent))}
 let width=layout.size[0],height=layout.size[1];svg.setAttribute('viewBox',`0 0 ${width} ${height}`);svg.style.aspectRatio=width+'/'+height;
 const defs=e('defs'),grid=e('pattern',{id:'sc-grid-'+b.id,width:28,height:28,patternUnits:'userSpaceOnUse'},defs);e('circle',{cx:2,cy:2,r:.85,fill:'#c8d9e9'},grid);
 r(0,0,width,height,{rx:18,fill:'#f2f6fc'});r(0,0,width,height,{rx:18,fill:'url(#sc-grid-'+b.id+')',opacity:.55});r(20,20,width-40,height-40,{rx:14,fill:'none',stroke:'#d0deef'});
 t(b.layer,42,48,{'class':'sc-kicker'});t('点击元件查看端口 · 双击进入内部',width-42,48,{'text-anchor':'end','class':'sc-hint'});
 const wires=e('g',{'class':'sc-wires'}),components=e('g',{'class':'sc-components'}),labels=e('g',{'class':'sc-wire-labels'}),foot=e('g',{'class':'sc-trace-strip'});
 const partNodes=new Map(),netNodes=new Map(),labelRects=[];
 function caption(p,g){const title=(b.id==='fpgaFabric'?{IO0:'I/O BANK',IO1:'I/O BANK',BRAM:'BRAM',DSP:'DSP',CLK:'时钟'}[p.id]:null)||p.label.replace(/^[A-Z][A-Z0-9]*\s*[·・]\s*/, '');let x=p.cx,y=p.cy-p.h/2-24;if(p.type==='rail')return;
 if(g._functional){
 const heading=title===p.id?p.id:p.id+' · '+title;const titleWidth=Math.min(235,Math.max(p.w+30,textWidth(heading)));let baseline=p.cy-p.h/2-20;
 const ns=wrapped(heading,p.cx,baseline,titleWidth,{'text-anchor':'middle','class':'sc-caption'},g);
 const rows=ns.length;if(rows>1)ns.forEach((node,i)=>node.setAttribute('y',baseline-(rows-1-i)*20));
 labelRects.push({id:p.id,l:p.cx-titleWidth/2,r:p.cx+titleWidth/2,t:baseline-(rows-1)*20-17,b:baseline+5});return;
 }
 if(['nmos','pmos'].includes(p.type)){if(b.id==='sramcell')t(p.id+' · '+title,x,p.cy+95,{'text-anchor':'middle','class':'sc-caption'},g);else t(p.id+' · '+title,x+65,p.cy+5,{'class':'sc-caption'},g);return}
 if(gateTypes.has(p.type)||['resistor','capacitor','inductor','diode','contact','pushcontact'].includes(p.type)){t(p.id+' · '+title,x,y,{'text-anchor':'middle','class':'sc-caption'},g);labelRects.push({id:p.id,l:x-Math.min(180,textWidth(p.id+' · '+title))/2,r:x+Math.min(180,textWidth(p.id+' · '+title))/2,t:y-16,b:y+5});return}
 if(p.type==='port'){t(p.id,x,p.cy+5,{'text-anchor':'middle','class':'sc-port-code'},g);t(title,x,p.cy+p.h/2+24,{'text-anchor':'middle','class':'sc-port-description'},g);return}
 if(materialTypes.has(p.type)){
 if(['nmos','pmos'].includes(b.id)&&p.id==='GATE')t(title,p.cx,p.cy-p.h/2-14,{'text-anchor':'middle','class':'sc-caption'},g);
 else if(['nmos','pmos'].includes(b.id)&&p.id==='OXIDE'){line(`M${p.cx+p.w/2} ${p.cy}H${p.cx+p.w/2+25}l18 -18`,{stroke:'#7a91a3'},g);t(title,p.cx+p.w/2+50,p.cy-18,{'class':'sc-caption'},g)}
 else t(title,p.cx,p.cy+p.h/2+28,{'text-anchor':'middle','class':'sc-caption'},g);return} 
 t(p.id,p.cx-p.w/2+12,p.cy-p.h/2+21,{'class':'sc-reference'},g);wrapped(title,p.cx,p.cy-p.h/2+47,p.w-12,{'text-anchor':'middle','class':'sc-block-title','font-size':p.w<110?11:15},g);
 }
 function drawPart(p,g){let {cx:x,cy:y,w,h,type:k}=p,l=x-w/2,top=y-h/2;const wire=(d,attrs={})=>line(d,{stroke:'#3c566b','stroke-width':2,...attrs},g);g._p=p;
 const family=/register|regfile|dff|latch|shift|cpu32rf|cpu32pc/i.test(k)?'storage':/ram|rom|cache|cpu32im|cpu32dm/i.test(k)?'memory':/mux|decoder|control|branch|target/i.test(k)?'control':'compute';g.dataset.visualFamily=family;
 if(k==='packageCut'){r(l,top,w,h,{rx:14,fill:'none',stroke:'#bccbd6','stroke-dasharray':'6 5','class':'sc-body'},g);t('可配置资源示意 · 非芯片物理版图',l+20,top+28,{'class':'sc-hint'},g);return}
 if(gateTypes.has(k)){let d;if(['not','inverter'].includes(k))d=`M${l} ${top}L${l+w} ${y}L${l} ${top+h}Z`;
 else if(k==='mux')d=`M${l} ${top}L${l+w} ${top+22}L${l+w} ${top+h-22}L${l} ${top+h}Z`;
 else if(['or','nor','xor'].includes(k))d=`M${l} ${top}Q${x+8} ${top-4} ${l+w} ${y}Q${x+8} ${top+h+4} ${l} ${top+h}Q${l+30} ${y} ${l} ${top}Z`;
 else d=`M${l} ${top}H${x}A${w/2} ${h/2} 0 0 1 ${x} ${top+h}H${l}Z`;
 line(d,{fill:'#fff',stroke:'#34536a','stroke-width':2.3,'class':'sc-body'},g);if(['nand','nor','not','inverter'].includes(k))e('circle',{cx:l+w+6,cy:y,r:6,fill:'#fff',stroke:'#34536a','stroke-width':2.2},g);if(k==='xor')wire(`M${l-9} ${top}Q${l+21} ${y} ${l-9} ${top+h}`);if(k==='mux')t('MUX',x,y+5,{'text-anchor':'middle','class':'sc-symbol-name'},g);
 }else if(['nmos','pmos'].includes(k)){wire(`M${x-11} ${y-28}V${y+28}M${x+1} ${y-30}V${y+30}M${x+1} ${y-25}H${x+24}V${top}M${x+1} ${y+25}H${x+24}V${top+h}M${l} ${y}H${x-11}`);if(k==='pmos')e('circle',{cx:x-18,cy:y,r:5,fill:'#fff',stroke:'#34536a','stroke-width':2},g);g._channel=wire(`M${x+1} ${y-22}V${y+22}`,{'stroke-width':4,stroke:'#aab8c2'});
 }else if(k==='resistor'){wire(`M${l} ${y}H${l+22}M${l+w-22} ${y}H${l+w}`);r(l+22,y-12,w-44,24,{rx:2,fill:'#fff',stroke:'#566d7f','stroke-width':2},g);
 }else if(k==='capacitor'){wire(`M${l} ${y}H${x-7}M${x-7} ${y-25}V${y+25}M${x+7} ${y-25}V${y+25}M${x+7} ${y}H${l+w}`);
 }else if(k==='inductor'){wire(`M${l} ${y}H${l+15}`);let d=`M${l+15} ${y}`;for(let i=0;i<4;i++)d+=`a11 17 0 0 1 22 0`;d+=`H${l+w}`;wire(d);
 }else if(k==='rail'){if(/GND|^LO$/.test(p.id)){wire(`M${x} ${y-14}V${y}M${x-22} ${y}H${x+22}M${x-15} ${y+7}H${x+15}M${x-7} ${y+14}H${x+7}`);t('GND',x+38,y+5,{'class':'sc-pin-text'},g)}else{wire(`M${x} ${y+15}V${y-12}M${x-15} ${y-4}L${x} ${y-14}L${x+15} ${y-4}`);t(p.label,x,y-27,{'text-anchor':'middle','class':'sc-caption'},g)}
 }else if(k==='port'){let d=`M${l} ${top}H${l+w-10}L${l+w} ${y}L${l+w-10} ${top+h}H${l}Z`;line(d,{fill:'#e9f2f6',stroke:'#a6bfce','stroke-width':1.3,'class':'sc-body'},g);
 }else if(k==='contact'&&p.ports.has('h')&&p.ports.has('l')){for(const [pin,offset]of [['h',-20],['l',20]]){const port=p.ports.get(pin);wire(`M${port.touch.join(' ')}H${x-42}V${y+offset}H${x-24}`);e('circle',{cx:x-24,cy:y+offset,r:4,fill:'#fff',stroke:'#4c6679','stroke-width':2},g)}wire(`M${x+24} ${y}H${l+w}`);e('circle',{cx:x+24,cy:y,r:4,fill:'#fff',stroke:'#4c6679','stroke-width':2},g);g._spdt=wire(`M${x+24} ${y}L${x-24} ${y-20}`);
 }else if(k==='contact'||k==='pushcontact'){wire(`M${l} ${y}H${x-24}M${x+24} ${y}H${l+w}`);for(let xx of [x-24,x+24])e('circle',{cx:xx,cy:y,r:4,fill:'#fff',stroke:'#4c6679','stroke-width':2},g);g._contact=wire(`M${x-24} ${y}L${x+24} ${y-24}`);if(k==='pushcontact')wire(`M${x} ${y-40}V${y-18}M${x-22} ${y-40}H${x+22}`);
 }else if(k==='diode'){wire(`M${l} ${y}H${x-25}M${x+25} ${y}H${l+w}M${x+23} ${y-26}V${y+26}`);g._led=line(`M${x-25} ${y-26}L${x+18} ${y}L${x-25} ${y+26}Z`,{fill:'#fff',stroke:'#3c566b','stroke-width':2},g);wire(`M${x+8} ${y-25}l18 -20m-7 1l7 -1v8M${x+27} ${y-15}l18 -20m-7 1l7 -1v8`);
 }else if(materialTypes.has(k)){let palette={substrate:'#d4c9e0',diffusion:'#b7d2e5',oxide:'#b9e5d9',electrode:'#e2ce98',die:'#9db5cd',lid:'#d5dde4',bga:'#acbac7',depletion:'#eadfc5',pregion:'#e7c8d7',nregion:'#bfd6e9'};r(l,top,w,h,{rx:4,fill:palette[k],stroke:'#a4b1be','class':'sc-body'},g);if(k==='bga')for(let i=0;i<16;i++)e('circle',{cx:l+30+i*(w-60)/15,cy:y,r:10,fill:'#71889e'},g);
 }else if(drawFunctionalSymbol(p,g,{e,t,r,line})){g._functional=true;}else{r(l,top,w,h,{rx:9,fill:'#fff',stroke:'#afc1cf','stroke-width':1.5,'class':'sc-body'},g);r(l+1,top+1,w-2,6,{rx:3,fill:['dff','register','latch','shift'].includes(k)?'#7899c0':['bitgrid','lut','ram','regfile','cache'].includes(k)?'#6eac9e':'#78a6ba'},g);
 if(b.id==='segmentdecode'&&p.id==='L'){g._segmentRows=[];for(let row=0;row<16;row++){const yy=top+75+row*21;t(row.toString(16).toUpperCase(),l+24,yy+11,{'font-size':12,'font-family':'monospace'},g);let nodes=[];for(let bit=0;bit<7;bit++)nodes.push(t('0',l+64+bit*24,yy+11,{'text-anchor':'middle','font-size':12},g));g._segmentRows.push({nodes,row});}for(let bit=0;bit<7;bit++)t('abcdefg'[bit],l+64+bit*24,top+62,{'text-anchor':'middle','font-size':12},g);}
 else if(k==='bitgrid'||k==='lut'){g._cells=[];const count=8,sz=Math.min((w-32)/count,(h-65)/count),sx=x-sz*4,sy=top+57;for(let row=0;row<8;row++)for(let col=0;col<8;col++){let node=r(sx+col*sz+2,sy+row*sz+2,sz-4,sz-4,{rx:2,fill:'#d6e7e2'},g);g._cells.push({node,index:row*8+col})}}
 else if(['dff','latch','register','shift'].includes(k)){t(k==='latch'?'透明 / 保持':k==='dff'?'边沿保存':'并行状态',x,top+h-18,{'text-anchor':'middle','class':'sc-function'},g)}
 else if(k==='muxtree'){
  g._tree=[];const levels=6,dx=(w-44)/levels,usable=h-78,origin=top+58,centers=[];
  for(let level=0;level<levels;level++){const count=32>>level,step=usable/count;centers[level]=[];
   for(let index=0;index<count;index++){const xx=l+22+level*dx,yy=origin+(index+.5)*step;centers[level].push([xx,yy]);
    if(level>0)for(const child of [index*2,index*2+1]){const [cx,cy]=centers[level-1][child];line(`M${cx+8} ${cy}H${xx-5}V${yy}H${xx}`,{stroke:'#b6a9c7','stroke-width':.8},g)}
    const node=line(`M${xx} ${yy-2}L${xx+8} ${yy}L${xx} ${yy+2}Z`,{fill:'#d5c7e5',stroke:'#a08cb7','stroke-width':.5},g);g._tree.push({node,level,index});
   }
  }
  const [ex,ey]=centers[5][0];line(`M${ex+8} ${ey}H${l+w}`,{stroke:'#a08cb7','stroke-width':1.5},g);
 }
 else if(k==='crossbar'||k==='clockspine'){for(let i=0;i<4;i++){let xx=l+25+i*(w-50)/3;wire(`M${xx} ${top+57}V${top+h-12}`,{stroke:'#91acba','stroke-width':1});}for(let i=0;i<3;i++){let yy=top+63+i*13;wire(`M${l+18} ${yy}H${l+w-18}`,{stroke:'#a3bbc8','stroke-width':1})}}
 else if(k==='display'){g._digits=[];const segments=[[-15,-27,30,5],[13,-14,5,24],[13,14,5,24],[-15,27,30,5],[-18,14,5,24],[-18,-14,5,24],[-15,0,30,5]];r(l+10,top+48,w-20,h-57,{rx:5,fill:'#e8edf0'},g);for(let bit=0;bit<(b.id==='segmentdecode'?1:4);bit++)for(let j=0;j<7;j++){let [dx,dy,ww,hh]=segments[j],node=r(x+(b.id==='segmentdecode'?0:(1.5-bit)*45)+dx,y+22+dy-hh/2,ww,hh,{rx:1,fill:'#cbd3d9'},g);g._digits.push({node,bit,segment:j})}if(b.id!=='segmentdecode')for(let bit=0;bit<4;bit++){const node=e('circle',{cx:x+(1.5-bit)*45+21,cy:y+51,r:3,fill:'#cbd3d9'},g);g._digits.push({node,bit,segment:7})}}
 else{const names={adder:'A + B',fa:'S / Cout',alu:'运算 / 选择',counter:'COUNT',ram:'ADDR → DATA',regfile:'2R · 1W',decoder:'地址 → 独热',logic:'组合逻辑',rom:'指令存储',sense:'感测 / 读出',driver:'使能 / 驱动',oscillator:'100 MHz',controller:'控制 / 协议',multiply:'A × B',adc:'采样 / 量化',power:'稳压 / 启动',clockbuffer:'时钟分配',buffer:'I/O 缓冲',pad:'封装引脚',header:'接口信号',package:'用户逻辑'};if(names[k])t(names[k],x,top+h-20,{'text-anchor':'middle','class':'sc-function'},g)}
 }
 caption(p,g);
 for(const port of p.ports.values()){let [ax,ay]=port.xy,[tx,ty]=port.touch;wire(`M${ax} ${ay}L${tx} ${ty}`,{stroke:ink[port.role]||ink.data,'stroke-width':port.bits>1?2.3:1.6});port.node=e('circle',{cx:ax,cy:ay,r:3.4,fill:'#f7fafc',stroke:ink[port.role]||ink.data,'stroke-width':1.3},g);if(!gateTypes.has(k)&&!['port','rail','nmos','pmos'].includes(k)&&!materialTypes.has(k)){let px=tx+(port.side==='left'?-7:7),py=ty+(port.side==='bottom'?16:-7);t(port.pin,px,py,{'text-anchor':port.side==='left'?'end':'start','class':'sc-pin-text'},g);let tw=port.pin.length*6.5;labelRects.push({id:p.id,l:port.side==='left'?px-tw:px,r:port.side==='left'?px:px+tw,t:py-11,b:py+2})}}
 }
 // Large background resource frames must be painted before functional children.
 for(const p of [...layout.parts].sort((a,z)=>Number(z.type==='packageCut')-Number(a.type==='packageCut'))){let g=e('g',{'data-diagram-part':p.id,tabindex:0,role:'button','aria-label':p.id+' '+p.label},components);drawPart(p,g);
 if(p.w>=150&&p.h>=70&&!materialTypes.has(p.type)&&!['asyncSync','asyncControl','asyncShift','uartStage','fifoBytes','flashControl','flashBytes','pipeStage','pipeControl','pipeRF','pipeMem','inputSync','inputDebounce','inputEvent','reprInterpretation','packageCut','rf32bank','imm32map','dec32table','dec32control','cpu32pc','cpu32alu','cpu32im','cpu32rf','cpu32mem','cpu32board','cpu32target','cpu32branch'].includes(p.type)){
  const node=e('g',{'class':'sc-live-badge','data-live-part':p.id},g);if(p.type==='multiplyRegister')node.setAttribute('display','none');const badgeWidth=b.id==='alu32'?86:50;r(p.cx+p.w/2-badgeWidth-7,p.cy-p.h/2+5,badgeWidth,18,{rx:5,fill:'#fff',stroke:'#b9d1d6'},node);g._valueText=t('',p.cx+p.w/2-badgeWidth/2-7,p.cy-p.h/2+18,{'text-anchor':'middle','font-size':11,'font-family':'monospace'},node);
 }
 if(['lut','slice','fabric','routing'].includes(b.lab))for(const item of g._cells||[]){item.node.style.cursor='pointer';item.node.setAttribute('data-lut-cell',item.index);item.node.onclick=ev=>{ev.stopPropagation();onSelect({part:p.id,lutBit:item.index})}}
 for(const item of g._reprCells||[]){const choose=ev=>{ev.stopPropagation();onSelect({part:p.id,reprInputBit:item.bit})};item.node.onclick=choose;item.node.onkeydown=ev=>{if(ev.key==='Enter'||ev.key===' '){ev.preventDefault();choose(ev)}}}
 for(const [items,key,field]of [[g._cpuRegCells,'cpuProbe','index'],[g._cpuSW,'cpuSwitchBit','bit']])for(const item of items||[]){const choose=ev=>{ev.stopPropagation();onSelect({part:p.id,[key]:item[field]})};item.node.onclick=choose;item.node.onkeydown=ev=>{if(ev.key==='Enter'||ev.key===' '){ev.preventDefault();choose(ev)}}}
 for(const [items,key,field]of [[g._dec32Bits,'decInputBit','bit'],[g._dec32Rows,'decCase','index'],[g._dec32Signals,'decSignal','key']])for(const item of items||[]){const choose=ev=>{ev.stopPropagation();onSelect({part:p.id,[key]:item[field]})};item.node.onclick=choose;item.node.onkeydown=ev=>{if(ev.key==='Enter'||ev.key===' '){ev.preventDefault();choose(ev)}}}
 for(const item of [...(g._imm32Inputs||[]),...(g._imm32Outputs||[])]){const input=g._imm32Inputs.includes(item),choose=ev=>{ev.stopPropagation();onSelect({part:p.id,...(input?{immInputBit:item.bit}:{immOutputBit:item.bit})})};item.node.onclick=choose;item.node.onkeydown=ev=>{if(ev.key==='Enter'||ev.key===' '){ev.preventDefault();choose(ev)}}}
 for(const item of g._rf32WriteCells||[]){const flip=ev=>{ev.stopPropagation();onSelect({part:p.id,rf32WordBit:item.bit})};item.node.onclick=flip;item.node.onkeydown=ev=>{if(ev.key==='Enter'||ev.key===' '){ev.preventDefault();flip(ev)}}}
 for(const item of g._rf32||[]){const choose=ev=>{ev.stopPropagation();onSelect({part:p.id,rf32Row:item.address,rf32Port:ev.shiftKey?'B':'A'})};item.node.onclick=choose;item.node.onkeydown=ev=>{if(ev.key==='Enter'||ev.key===' '){ev.preventDefault();choose(ev)}}}
 for(const c of g._multiplyRegister?.bits||[]){const inspect=ev=>{ev.stopPropagation();onSelect({part:p.id,multiplyBit:c.bit})};c.group.onclick=inspect;c.group.onkeydown=ev=>{if(ev.key==='Enter'||ev.key===' '){ev.preventDefault();inspect(ev)}}}
 if(b.id==='divideShift'&&/^[RQ][0-3]$/.test(p.id))g.setAttribute('aria-label',p.id+'输入位，点击或按Enter翻转');
 g.onclick=ev=>{ev.stopPropagation();onSelect({part:p.id,editField:globalThis.anatomyInputForPart?.(b.id,p.id),divideShiftInput:b.id==='divideShift'&&/^[RQ][0-3]$/.test(p.id)?p.id:undefined})};g.ondblclick=ev=>{ev.stopPropagation();onEnter(p.id)};g.onkeydown=ev=>{if(ev.key==='Enter'||ev.key===' '){ev.preventDefault();onSelect({part:p.id,divideShiftInput:b.id==='divideShift'&&/^[RQ][0-3]$/.test(p.id)?p.id:undefined})}};partNodes.set(p.id,g)}
 let channel=null;if(['nmos','pmos'].includes(b.id)){const body=layout.map.get('BODY');channel=line(`M${layout.map.get('SOURCE').cx+80} ${body.cy-body.h/2+7}H${layout.map.get('DRAIN').cx-80}`,{stroke:'#3dba98','stroke-width':9,'stroke-linecap':'round','class':'sc-material-channel'},labels)}
 const style=e('style');style.textContent=`.an-schematic text{font-family:system-ui,"PingFang SC",sans-serif;fill:#38556b}.sc-caption,.sc-block-title{font-size:15px;font-weight:600}.sc-reference,.sc-port-code{font:600 15px ui-monospace,monospace}.sc-pin-text{font:11px ui-monospace,monospace;fill:#6d8190}.sc-function,.sc-port-description{font-size:13px;fill:#718592}.sc-kicker,.sc-hint{font-size:12px;fill:#8094a2}.sc-symbol-name{font:14px ui-monospace,monospace}.sc-components>g{cursor:pointer}.sc-components>g.selected .sc-body{stroke:#bd7b25;stroke-width:3}.sc-components>g.tracked .sc-body{stroke:#24997c;stroke-width:3}.sc-components>g:focus{outline:none}.sc-components>g:focus .sc-body{stroke:#bd7b25;stroke-width:3}`;

 style.textContent+=`.sc-components>g{--sc-accent:#139b93;--sc-tint:#edfafa}.sc-components>g[data-visual-family="storage"]{--sc-accent:#7660cf;--sc-tint:#f2efff}.sc-components>g[data-visual-family="memory"]{--sc-accent:#377cce;--sc-tint:#eef5ff}.sc-components>g[data-visual-family="control"]{--sc-accent:#b956ad;--sc-tint:#fbf0fb}.sc-components>g:not(.sc-cpu32-board)> .sc-body{fill:var(--sc-tint);stroke:var(--sc-accent);stroke-width:2.8;filter:drop-shadow(0px 5px 5px #243e6414)}.sc-components>g.selected>.sc-body,.sc-components>g.tracked>.sc-body{stroke:#e49a1b;stroke-width:4;filter:drop-shadow(0px 0px 6px #e9a62a45)}.sc-components>g:hover>.sc-body{stroke-width:3.6}.sc-components .sc-caption,.sc-components .sc-block-title{fill:#233e60;font-weight:750}.sc-pin-text{fill:#50708e}.sc-wires path{stroke-linecap:round;stroke-linejoin:round}.sc-components>g:focus-visible>.sc-body{stroke:#d78416;stroke-width:4}.sc-components .sc-live-badge rect{fill:#fff;stroke:#b7cce2}.sc-components .sc-live-badge text{fill:#24496a;font-weight:700}`;
 // Preserve material/analogue colors and physical board surfaces.
 for(const g of partNodes.values())if(materialTypes.has(g._p.type)||['packageCut','port'].includes(g._p.type)){g.querySelector('.sc-body')?.style.setProperty('fill',g.querySelector('.sc-body').getAttribute('fill'))}
 // Union only actual conductive nets, so branches share a corridor while independent inputs remain separate.
 const roots=new Map();function root(x){if(!roots.has(x))roots.set(x,x);if(roots.get(x)!==x)roots.set(x,root(roots.get(x)));return roots.get(x)}
 for(const n of b.nets)roots.set(root(n.to),root(n.from));
 const boxes=layout.parts.filter(p=>p.type!=='packageCut'&&!materialTypes.has(p.type)).map(p=>({id:p.id,l:p.cx-p.w/2-5,r:p.cx+p.w/2+5,t:p.cy-p.h/2-8,b:p.cy+p.h/2+8}));
 const occupied=[],failures=[];
 const getPort=end=>{let [id,pin]=end.split('.');return layout.map.get(id).ports.get(pin)};
 for(const [index,n]of b.nets.entries()){
  const a=getPort(n.from),z=getPort(n.to),group=root(n.from),others=occupied.filter(x=>x.group!==group).map(x=>x.segment);
  let pts=routeWire(a.xy,z.xy,[...boxes,...labelRects],others);
  // Named off-sheet terminals are clearer than routing through a component when no legal corridor exists.
  const g=e('g',{'data-diagram-net':n.name,tabindex:0,role:'button','aria-label':'信号 '+n.name},wires),paths=[];
  if(pts){const d=pts.map((p,i)=>(i?'L':'M')+p.join(' ')).join(' ');line(d,{stroke:'#f2f6fc','stroke-width':9},g);paths.push(line(d,{stroke:ink[n.role]||ink.data,'stroke-width':n.bits>1?2.5:1.8},g));line(d,{stroke:'transparent','stroke-width':13},g);for(let i=1;i<pts.length;i++)occupied.push({group,name:n.name,role:n.role,segment:[pts[i-1],pts[i]]});}
  else{failures.push(n.name);for(const port of [a,z]){const [x,y]=port.xy;t('↗ '+n.name,x+(port.side==='left'?-7:7),y-8,{'text-anchor':port.side==='left'?'end':'start','font-size':11,fill:ink[n.role]},g)}}
  g.onclick=ev=>{ev.stopPropagation();onSelect({net:n.name})};g.onkeydown=ev=>{if(ev.key==='Enter'||ev.key===' '){ev.preventDefault();onSelect({net:n.name})}};netNodes.set(n.name,{g,paths,n});
 }
 // Junction dots only join branches of the same electrical net; crossings of independent nets stay unjoined.
 const junctions=new Map();for(let i=0;i<occupied.length;i++)for(let j=i+1;j<occupied.length;j++){const a=occupied[i],b=occupied[j];if(a.group!==b.group||a.name===b.name)continue;let [p,q]=a.segment,[u,v]=b.segment;if((p[0]===q[0])===(u[0]===v[0]))continue;let h=p[1]===q[1]?[p,q]:[u,v],w=p[0]===q[0]?[p,q]:[u,v],x=w[0][0],y=h[0][1];if(x>=Math.min(h[0][0],h[1][0])&&x<=Math.max(h[0][0],h[1][0])&&y>=Math.min(w[0][1],w[1][1])&&y<=Math.max(w[0][1],w[1][1]))junctions.set(x+','+y,{x,y,role:a.role})}
 for(const {x,y,role}of junctions.values())e('circle',{cx:x,cy:y,r:4.1,fill:ink[role]||ink.data,'class':'sc-junction'},labels);
 const strip=t('选择连线查看信号值与连接说明',42,height-35,{'font-size':13},foot);
 host.dataset.routeFallbacks=JSON.stringify(failures);
 function update(state={},evaluation={},step=null,selection=null){
  if(channel){channel.style.opacity=evaluation.material?.conducting?'1':'0';channel.setAttribute('data-conducting',String(!!evaluation.material?.conducting))}
  for(const [id,g]of partNodes){
   updateMultiplyRegister(g,state,selection);updateAsyncSymbol(g,state);updateUARTSymbol(g,state);updateFIFOSymbol(g,state);updateFlashSymbol(g,state);updatePipelineSymbol(g,{...state,_pipePreview:evaluation.pipelinePreview});updateInputSymbol(g,state);updateRepresentationSymbol(g,state,evaluation);updateRF32Symbol(g,state,evaluation);updateImmediate32Symbol(g,state,evaluation,selection);updateDecoder32Symbol(g,state,evaluation,selection);updateCPU32Symbol(g,state,evaluation);
   const value=evaluation.partValues?.[id],compact=v=>typeof v==='number'?(Number.isInteger(v)?Math.abs(v)>15?(v<0?'-':'')+'0x'+Math.abs(v).toString(16):String(v):v.toFixed(1)):String(v??'—');
   if(g._operationText){const op=evaluation.operation;g._operationText.textContent=g._p.type==='rvarith'?(op==='SUB'?'SUB':'ADD'):g._p.type==='rvlogic'?(['AND','OR','XOR'].includes(op)?op:'AND'):g._p.type==='rvshift'?(['SLL','SRL','SRA'].includes(op)?op:'SLL'):(op==='SLTU'?'SLTU':'SLT')}g.dataset.value=String(value??'—');if(g._valueText){g._valueText.textContent=compact(value).length>(b.id==='alu32'?10:7)?compact(value).slice(0,b.id==='alu32'?9:6)+'…':compact(value);g._valueText.parentElement.setAttribute('aria-label','当前值 '+String(value??'—'))}
   if(g._rxStateNodes){const current=state.rxPhase<0?0:state.rxPhase<8?1:2;for(const item of g._rxStateNodes){const active=item.index===current;item.node.setAttribute('fill',active?'#f4dc97':'#fff');item.node.setAttribute('aria-current',String(active));if(item.index===1)item.text.textContent='接收数据 '+(state.rxPhase>=0&&state.rxPhase<8?'d'+state.rxPhase:'d0…d7')}const next=state.rxPhase<0?(state.a===0?'进入d0，清零组装':'保持等待'):state.rxPhase<7?'保存d'+state.rxPhase+'，进入d'+(state.rxPhase+1):state.rxPhase===7?'保存d7，进入停止检查':state.a?'VALID=1，返回等待':'ERROR=1，返回等待';g._rxNext.textContent='下一采样：'+next;}
   for(const item of g._regValueLabels||[])item.node.textContent=typeof value==='number'?String((value>>>item.bit)&1):'—';
   for(const item of g._regCells||[]){item.node.setAttribute('fill',typeof value==='number'?(value&(1<<item.bit)?'#8ccfb4':'#eaf2f8'):value==='X'?'#efb3a9':'#eaf2f8')}
   for(const item of g._memoryCells||[]){const memory=b.id==='flash'?state.flashBytes:b.lab==='regfile'?state.reg:null;if(memory)item.node.setAttribute('fill',memory[item.row]&(1<<item.bit)?'#65b89b':'#eef4f1')}
   for(const port of g._p.ports.values()){const v=evaluation.nets?.[port.names[0]],color=v==='X'?'#dd6b67':v==='Z'?'#d5ac50':v===0?'#f7fafc':v===1?'#29ad84':typeof v==='number'?'#68b8c7':'#b3c6d1';port.node?.setAttribute('fill',color);port.node?.setAttribute('data-value',String(v??'—'))}
   if(g._p.type==='port'){const node=g.querySelector('.sc-port-code'),explicit=evaluation.portLabels?.[id],label=explicit??(id+' '+compact(value));if(node){node.textContent=explicit||label.length<=(b.id==='regfile32'?14:12)?label:id;node.style.fontSize=label.length>8?'11px':'15px';node.setAttribute('aria-label',id+' '+label)}}
   if(b.id==='packageView'&&id!=='LID'){const label=g.querySelector('.sc-caption');if(label)label.textContent=g._p.label+' · '+compact(value);const shape=g.querySelector('.sc-body');if(shape)shape.style.opacity=state.enable?'1':'.4'}
   if(evaluation.material){const shape=g.querySelector('.sc-body');if(shape&&id==='GATE')shape.setAttribute('fill',evaluation.material.gate?'#e5ba5f':'#d5d8df');if(shape&&['P','J','N'].includes(id))shape.setAttribute('fill',evaluation.material.conducting?{P:'#f3b8ca',J:'#f4d785',N:'#a6d7e5'}[id]:{P:'#e7c8d7',J:'#eadfc5',N:'#bfd6e9'}[id]);}
   g.classList.toggle('selected',selection?.part===id);g.classList.toggle('tracked',!!step?.parts?.includes(id));for(const {node,index}of g._cells||[]){const v=b.id==='lut'?state.lut?.[index]:b.lab==='ram'?((state.mem?.[Math.floor(index/8)]||0)>>(7-index%8))&1:null;if(v!=null)node.setAttribute('fill',v?'#4a9c83':'#dce9e4')}
   for(const item of g._tree||[]){let selected=item.index===(state.lutAddr>>(item.level+1));item.node.setAttribute('fill',selected?'#76579b':'#d5c7e5');item.node.setAttribute('stroke',selected?'#76579b':'#a08cb7')}
   for(const {nodes,row}of g._segmentRows||[]){const mask=[63,6,91,79,102,109,125,7,127,111,119,124,57,94,121,113][row];nodes.forEach((node,bit)=>{node.textContent=String(1-((mask>>bit)&1));node.setAttribute('fill',row===(state.av&15)?'#176b59':'#8395a2');node.setAttribute('font-weight',row===(state.av&15)?'800':'400')})}
   for(const item of g._digits||[])item.node.setAttribute('fill',(b.id==='segmentdecode'?[63,6,91,79,102,109,125,7,127,111,119,124,57,94,121,113][state.av&15]:evaluation.digits?.[item.bit])&(1<<item.segment)?'#df5e58':'#cbd3d9');
   for(const item of g._indicators||[])item.node.setAttribute('fill',g._p.type==='status'?(item.bit?evaluation.done:evaluation.power)?'#87c879':'#d6e4d9':evaluation.led&(1<<item.bit)?'#87c879':'#d6e4d9');
   if(g._led)g._led.setAttribute('fill',evaluation.led?'#e88775':'#fff');
   if(g._spdt){const p=g._p;g._spdt.setAttribute('d',`M${p.cx+24} ${p.cy}L${p.cx-24} ${p.cy+(state.a?-20:20)}`)}
   if(g._contact){const p=g._p;g._contact.setAttribute('d',`M${p.cx-24} ${p.cy}L${p.cx+24} ${(b.id==='power'?state.powered:state.a)?p.cy:p.cy-24}`)}
   if(g._channel)g._channel.setAttribute('stroke',evaluation.switches?.[id]?'#28987b':'#aab8c2');
  }
  const selected=[];for(const [name,x]of netNodes){const active=selection?.net?selection.net===name:!!step?.nets?.includes(name);x.g.setAttribute('aria-pressed',String(selection?.net===name));x.g.classList.toggle('selected',selection?.net===name);for(const text of x.g.querySelectorAll('text'))text.setAttribute('fill',active?'#ce842b':ink[x.n.role]||ink.data);for(const p of x.paths){p.setAttribute('stroke',active?'#ce842b':ink[x.n.role]||ink.data);p.setAttribute('stroke-width',active?5.5:x.n.bits>1?3.8:2.8)}if(active)selected.push(name+(evaluation.nets?.[name]!==undefined?' = '+evaluation.nets[name]:''))}
  strip.textContent=selected.length?selected.slice(0,5).join('     ·     '):'选择连线查看信号值与连接说明';
  Object.assign(host.dataset,{render:'ready',mode:'2d',level:b.id,partCount:String(b.parts.length),netCount:String(b.nets.length)});
 }
 update();return {supported:true,update,dispose(){svg.remove()}};
}
