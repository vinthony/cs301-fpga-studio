import {drawMultiplyRegister} from './anatomy-multiply-symbol.js';
import {drawAsyncSymbol} from './anatomy-async-symbol.js';
import {drawUARTSymbol} from './anatomy-uart-symbol.js';
import {drawFIFOSymbol} from './anatomy-fifo-symbol.js';
import {drawFlashSymbol} from './anatomy-flash-symbol.js';
import {drawPipelineSymbol} from './anatomy-pipe-symbol.js';
import {drawInputSymbol} from './anatomy-input-symbol.js';
import {drawRepresentationSymbol} from './anatomy-repr-symbol.js';
import {drawCPU32Symbol} from './anatomy-cpu32-symbol.js';
import {drawDecoder32Symbol} from './anatomy-dec32-symbol.js';
import {drawImmediate32Symbol} from './anatomy-imm32-symbol.js';
import {drawRF32Symbol} from './anatomy-rf32-symbol.js';
// Distinct, flat engineering symbols. Internal motifs are schematic previews, not extra simulated netlists.
export function drawFunctionalSymbol(p,g,{e,t,r,line}){
 if(drawMultiplyRegister(p,g,{e,t,r,line})||drawAsyncSymbol(p,g,{e,t,r,line})||drawUARTSymbol(p,g,{e,t,r,line})||drawFIFOSymbol(p,g,{e,t,r,line})||drawFlashSymbol(p,g,{e,t,r,line})||drawPipelineSymbol(p,g,{e,t,r,line})||drawInputSymbol(p,g,{e,t,r,line})||drawRepresentationSymbol(p,g,{e,t,r,line})||drawRF32Symbol(p,g,{e,t,r,line})||drawImmediate32Symbol(p,g,{e,t,r,line})||drawDecoder32Symbol(p,g,{e,t,r,line})||drawCPU32Symbol(p,g,{e,t,r,line}))return true;
 const {type:k,cx:x,cy:y,w,h}=p,l=x-w/2,top=y-h/2;
 const supported=new Set(['idealRXControl','rvarith','rvlogic','rvshift','rvcompare','adder','fa','alu','multiply','compare','comparators','dff','latch','register','shift','counter','ram','rom','regfile','cache','flash','flasharray','logic','controller','decoder','buffer','clockbuffer','driver','sense','oscillator','resonator','amplifier','adc','carry','wires','package','slice','clb','dsp','power','iobank','header','pad','usb','usbhost','vga','ledbank','switchbank','buttons','status']);
 if(!supported.has(k))return false;
 const c={ink:'#36596f',soft:'#8aa7b7',blue:'#eaf2f8',green:'#e6f2ed',purple:'#eee9f5',gold:'#fbf1dc'};
 const path=(d,a={})=>line(d,{stroke:c.ink,'stroke-width':1.7,'stroke-linecap':'round','stroke-linejoin':'round',...a},g);
 const box=(xx,yy,ww,hh,a={})=>r(xx,yy,ww,hh,{fill:'#fff',stroke:c.soft,'stroke-width':1.4,rx:3,...a},g);
 const dot=(xx,yy,rr=3,a={})=>e('circle',{cx:xx,cy:yy,r:rr,fill:'#fff',stroke:c.ink,'stroke-width':1.4,...a},g);
 const label=(s,xx,yy,a={})=>t(s,xx,yy,{'text-anchor':'middle','font-size':12,...a},g);
 const shell=(fill=c.blue,rad=12)=>box(l,top,w,h,{rx:rad,fill,'class':'sc-body'});
 const chevron=(xx,yy)=>path(`M${xx-4} ${yy-4}l4 4l-4 4`);
 const edgeLeads=()=>{path(`M${l} ${y}H${l+20}M${l+w-20} ${y}H${l+w}`)};
 if(k==='idealRXControl'){
  shell(c.purple,8);g._rxStateNodes=[];
  for(const [i,name] of ['等待起始','接收数据','检查停止'].entries()){const yy=top+22+i*55,node=box(x-68,yy,136,32,{rx:14,fill:'#fff','data-rx-control-state':i});const text=label(name,x,yy+21,{'font-size':12});g._rxStateNodes.push({node,text,index:i});if(i<2){path(`M${x} ${yy+32}v20`);path(`M${x-4} ${yy+47}l4 5l4 -5`);label(i===0?'RX=0':'已收8位',x+47,yy+46,{'font-size':8})}}
  path(`M${x+68} ${top+148}H${x+94}V${top+38}H${x+68}`);chevron(x+72,top+38);
  g._rxNext=label('下一采样',x,top+h-12,{'font-size':10,'data-rx-control-next':''});
 }else if(['rvarith','rvlogic','rvshift','rvcompare'].includes(k)){
  const fill=k==='rvshift'?c.blue:k==='rvlogic'?c.purple:c.gold;
  if(k==='rvcompare'){path(`M${l} ${top+8}L${l+w-18} ${top+8}L${l+w} ${y}L${l+w-18} ${top+h-8}L${l} ${top+h-8}Z`,{fill,'class':'sc-body'});label('<',x-32,y+11,{'font-size':30});}
  else if(k==='rvarith'){path(`M${l} ${top+5}H${l+w-15}L${l+w} ${y}L${l+w-15} ${top+h-5}H${l}V${y+13}L${l+17} ${y}L${l} ${y-13}Z`,{fill,'class':'sc-body'});label('±',x-34,y+9,{'font-size':28});}
  else if(k==='rvshift'){
   shell(fill,5);for(let i=0;i<4;i++){const yy=top+18+i*19;path(`M${l+8} ${yy}H${l+39}L${l+68} ${top+18+((i+1)%4)*19}H${l+93}`,{stroke:'#7eafc0','stroke-width':1.2});}label('× 32 bit',x+29,y+30,{'font-size':10});
  }else{shell(fill,7);label('∧  ∨  ⊕',x,y-23,{'font-size':21});}
  g._operationText=label(k==='rvshift'?'SLL':k==='rvlogic'?'AND':k==='rvcompare'?'SLT':'ADD',x+(k==='rvlogic'?0:28),y+7,{'font-size':16,'font-weight':700});
  if(k==='rvcompare')label('signed / unsigned',x,y+32,{'font-size':10});
 }else if(['adder','fa','multiply','compare'].includes(k)){
  const radius=Math.min(h*.46,w*.27);
  dot(x,y,radius,{fill:k==='multiply'?c.purple:c.gold,'stroke-width':2,'class':'sc-body'});
  label(k==='multiply'?'×':k==='compare'?(p.comparison==='lt'?'<':'='):'+',x,y+11,{'font-size':36,'font-weight':400});
  // Separate bus inputs and carry/sum terminals reach the arithmetic unit, without a surrounding card.
  for(const port of p.ports.values()){
   const [px,py]=port.touch;
   if(port.side==='left'||port.side==='right'){const dy=Math.max(-radius+2,Math.min(radius-2,py-y)),ex=x+(port.side==='left'?-1:1)*Math.sqrt(radius*radius-dy*dy);path(`M${px} ${py}H${ex}V${y+dy}`)}
   else{const dx=Math.max(-radius+2,Math.min(radius-2,px-x)),ey=y+(port.side==='top'?-1:1)*Math.sqrt(radius*radius-dx*dx);path(`M${px} ${py}V${ey}H${x+dx}`)}
  }
 }else if(k==='alu'){
  path(`M${l} ${top}L${l+w} ${top+18}V${top+h-18}L${l} ${top+h}V${y+17}L${l+27} ${y}L${l} ${y-17}Z`,{fill:c.gold,'stroke-width':2,'class':'sc-body'});
  label('ALU',x+13,y-2,{'font-size':19,'font-weight':700});label('+  −  ∧  ⊕',x+14,y+21,{'font-size':13});
 }else if(['dff','latch'].includes(k)){
  shell(c.blue,3);path(`M${l+14} ${top+14}H${l+w-14}`,{stroke:'#bfd1df'});
  label('D',l+22,y+6,{'font-size':19});label('Q',l+w-22,y+6,{'font-size':19});
  if(k==='dff')path(`M${x-7} ${top+h}l7 -11l7 11`);else{box(x-11,top+h-22,22,13,{fill:'#dce9f4'});label('G',x,top+h-12,{'font-size':10})}
  path(`M${l+42} ${y}H${l+w-42}`,{stroke:'#a9c3d5','stroke-dasharray':'3 4'});
 }else if(p.coordinatePair){
  shell(c.blue,6);g._regCells=[];g._regValueLabels=[];
  const cw=(w-70)/10,sx=x-5*cw;
  for(const [axis,offset,dy]of [['X',0,-40],['Y',10,40]]){
   const yy=y+dy;label(axis,l+17,yy+4,{'font-size':13,'font-weight':700});
   for(let i=0;i<10;i++){const bit=9-i,packedBit=offset+bit,cx=sx+i*cw+cw/2;
    const node=box(sx+i*cw+2,yy-24,cw-4,44,{fill:c.blue,'data-storage-axis':axis,'data-storage-bit':bit,'data-storage-word-bit':packedBit});g._regCells.push({node,bit:packedBit});
    label(String(bit),cx,yy-11,{'font-size':8});const value=label('0',cx,yy+5,{'font-size':11,'data-storage-value':packedBit});g._regValueLabels.push({node:value,bit:packedBit});path(`M${cx-4} ${yy+20}l4 -7l4 7`);
   }
   path(`M${sx+cw/2} ${yy+22}V${yy+30}H${sx+9.5*cw}V${yy+22}`,{stroke:'#6f93b6'});
  }
  label('共同像素边沿 · Y仅行末使能',x,top+14,{'font-size':10});
  path(`M${l} ${y}H${l+24}M${l+w-24} ${y}H${l+w}`);
 }else if(['register','shift','counter'].includes(k)){
  const n=p.storageBits||4,cw=Math.min(29,(w-34)/n),sx=x-n*cw/2;
  // A bank of edge-triggered cells; clock rail is separate from data direction.
  g._regCells=[];g._regValueLabels=[];for(let i=0;i<n;i++){const bit=p.storageMSBFirst?n-1-i:i,wordBit=(p.storageOffset||0)+bit,node=box(sx+i*cw+2,y-25,cw-4,44,{fill:c.blue,...(p.storageBits?{'data-storage-bit':bit,'data-storage-word-bit':wordBit}:{})});g._regCells.push({node,bit});if(p.storageMSBFirst)label(String(wordBit),sx+i*cw+cw/2,y-9,{'font-size':8});if(p.storageBits){const node=label('0',sx+i*cw+cw/2,y+5,{'font-size':10,'data-storage-value':wordBit});g._regValueLabels.push({node,bit})}path(`M${sx+i*cw+cw/2-4} ${y+19}l4 -7l4 7`);if(k==='shift'&&i<n-1){path(`M${sx+(i+1)*cw-1} ${y-4}h7`);chevron(sx+(i+1)*cw+6,y-4)}}
  path(`M${l} ${y}H${sx+2}M${sx+n*cw-2} ${y}H${l+w}M${sx+cw/2} ${y+20}V${y+34}H${sx+(n-.5)*cw}V${y+20}`,{stroke:'#6f93b6'});
  if(k==='counter'){path(`M${l+w-12} ${y}V${top+8}H${l+12}V${y}`);label('+1',x,top+17,{'font-size':11,fill:'#947137'})}
  e('rect',{x:l,y:top,width:w,height:h,rx:6,fill:'transparent',stroke:'none','class':'sc-body'},g);
 }else if(['ram','rom','regfile','cache','flash','flasharray'].includes(k)){
  shell(k==='rom'||k==='flash'?c.purple:c.green,7);
  const ax=l+37,ay=top+23,aw=w-73,ah=h-45;
  g._memoryCells=[];for(let row=0;row<8;row++)for(let col=0;col<8;col++){const node=box(ax+col*aw/8,ay+row*ah/8,aw/8-2,ah/8-1,{rx:1,fill:'#edf3f1',stroke:'#bfd8cf','stroke-width':.7});g._memoryCells.push({node,row,bit:7-col})}
  path(`M${l+12} ${y}H${ax-10}M${l+w-23} ${y}H${l+w-5}`);
  for(let row=0;row<4;row++){const yy=ay+(row+.5)*ah/4;path(`M${ax-12} ${yy-3}l6 3l-6 3Z`,{fill:'#8eb4a6',stroke:'none'});path(`M${ax+aw+3} ${yy-3}l6 3l-6 3Z`,{fill:'#8eb4a6',stroke:'none'})}
  label(k==='regfile'?'2R · 1W':k==='rom'?'READ':k==='cache'?'TAG / DATA':'ADDR / DATA',x,top+h-8,{'font-size':10,fill:'#658b7d'});
 }else if(k==='carry'){
  shell(c.gold,8);const count=4,yy=top+55,step=(h-95)/count;
  for(let i=0;i<count;i++){let cy=yy+i*step;path(`M${x-21} ${cy-18}L${x+17} ${cy-10}V${cy+10}L${x-21} ${cy+18}Z`,{fill:'#fff',stroke:'#bc955b'});if(i<count-1)path(`M${x+17} ${cy}h13v${step}h-13`,{stroke:'#bc955b'});dot(x-5,cy+42,11,{fill:'#fff',stroke:'#bc955b'});path(`M${x-10} ${cy+42}h10M${x-5} ${cy+37}v10`,{stroke:'#bc955b'})}
 }else if(k==='logic'){
  const gx=l+35,gy=y-22,oy=y+8;
  for(const cy of [gy,y+24]){path(`M${gx-16} ${cy-11}h14a14 11 0 0 1 0 22h-14Z`,{fill:c.purple,stroke:'#8e7aa7'});path(`M${l} ${cy-5}H${gx-16}M${l} ${cy+5}H${gx-16}`,{stroke:'#a28bb8'})}
  path(`M${x+21} ${oy-22}Q${x+52} ${oy-22} ${x+66} ${oy}Q${x+52} ${oy+22} ${x+21} ${oy+22}Q${x+35} ${oy} ${x+21} ${oy-22}Z`,{fill:c.purple,stroke:'#8e7aa7'});
  path(`M${gx+12} ${gy}H${x+7}V${oy-10}H${x+27}M${gx+12} ${y+24}H${x+12}V${oy+10}H${x+27}M${x+66} ${oy}H${l+w}V${y}`,{stroke:'#a28bb8'});
  e('rect',{x:l,y:top,width:w,height:h,fill:'transparent','class':'sc-body',stroke:'none'},g);
 }else if(k==='controller'){
  // State/control networks differ visually from arithmetic and storage symbols.
  const nodes=[[l+35,y],[x+5,top+22],[l+w-31,y+17]];
  path(`M${nodes[0][0]} ${nodes[0][1]}L${nodes[1][0]} ${nodes[1][1]}L${nodes[2][0]} ${nodes[2][1]}L${nodes[0][0]} ${nodes[0][1]}`,{stroke:'#9f8ab5'});
  for(let i=0;i<3;i++)dot(...nodes[i],k==='controller'?13:10,{fill:i===0?'#e6dcef':'#fff',stroke:'#89729d'});
  if(k==='controller')dot(...nodes[0],9,{fill:'none',stroke:'#89729d','stroke-width':.8});
  edgeLeads();path(`M${l+20} ${y}H${nodes[0][0]-13}M${nodes[2][0]+13} ${nodes[2][1]}H${l+w-20}V${y}`);
  if(k==='logic')for(let i=0;i<3;i++)path(`M${nodes[i][0]-4} ${nodes[i][1]}h8M${nodes[i][0]} ${nodes[i][1]-4}v8`,{stroke:'#947ba9'});
  e('rect',{x:l,y:top,width:w,height:h,fill:'transparent','class':'sc-body',stroke:'none'},g);
 }else if(k==='decoder'||k==='comparators'){
  path(`M${l+16} ${y-12}L${l+w-34} ${top+8}V${top+h-8}L${l+16} ${y+12}Z`,{fill:c.green,'class':'sc-body'});
  path(`M${l} ${y}H${l+16}`);for(let i=0;i<4;i++){let yy=top+18+i*(h-36)/3;path(`M${l+w-34} ${yy}H${l+w}`);dot(l+w-9,yy,2,{fill:i===1?'#3f9b7a':'#fff'})}
 }else if(['buffer','clockbuffer','amplifier','driver','sense'].includes(k)){
  const left=l+22,right=l+w-22;
  path(`M${left} ${top+10}L${right} ${y}L${left} ${top+h-10}Z`,{fill:k==='sense'?c.green:c.blue,'class':'sc-body','stroke-width':2});
  path(`M${l} ${y}H${left}M${right} ${y}H${l+w}`);
  if(k==='clockbuffer'){path(`M${x-24} ${y+11}v-18h12v18h12v-18h12`)}
  if(k==='amplifier'){label('+',left+15,y-14);label('−',left+15,y+22)}
  if(k==='buffer')path(`M${x} ${top+h-5}V${y+20}`,{stroke:'#997ab3'});
 }else if(['oscillator','resonator'].includes(k)){
  const rad=Math.min(36,h*.36);dot(x,y,rad,{fill:c.blue,'class':'sc-body'});path(`M${l} ${y}H${x-rad}M${x+rad} ${y}H${l+w}`);
  if(k==='oscillator')path(`M${x-23} ${y}v-12h14v24h14v-24h14v12`,{stroke:'#a47c29'});
  else path(`M${x-23} ${y}h12m0 -16v32m7 -28h14v24h-14Zm20 -4v32m0 -16h12`);
 }else if(k==='adc'){
  path(`M${l} ${top+12}H${l+w-22}L${l+w} ${y}L${l+w-22} ${top+h-12}H${l}Z`,{fill:c.purple,'class':'sc-body'});
  path(`M${l+14} ${y}q10 -28 20 0t20 0`,{stroke:'#b67d9d'});
  path(`M${x+9} ${y+15}v-10h13v-10h13v-10h13`,{stroke:'#7464a1'});label('ADC',x,y+36,{'font-size':11});
 }else if(k==='wires'){
  for(let i=0;i<4;i++){const yy=top+25+i*18;path(`M${l} ${yy}H${l+34+i*10}L${l+w-34-i*10} ${top+h-25-i*18}H${l+w}`,{stroke:['#4c8ca6','#699d9b','#a789b5','#c0985a'][i]})}
  e('rect',{x:l,y:top,width:w,height:h,fill:'transparent','class':'sc-body',stroke:'none'},g);
 }else if(['package','slice','clb','dsp','power','iobank'].includes(k)){
  shell(k==='power'?c.gold:c.blue,8);
  if(k==='power'){path(`M${x+5} ${top+17}l-21 34h18l-8 30l25 -40h-18Z`,{fill:'#e1bc61',stroke:'#aa893b'});}
  else if(k==='iobank'){for(let i=0;i<5;i++){let yy=top+64+i*(h-90)/5;path(`M${l+12} ${yy-7}l15 7l-15 7Z M${l+w-12} ${yy-7}l-15 7l15 7Z`,{fill:'#c0d8e8',stroke:'#769db4'});path(`M${l+27} ${yy}H${l+w-27}`,{stroke:'#bfd0da'})}}
  else{const cols=k==='slice'?4:3,rows=k==='clb'?2:3,sz=Math.min((w-36)/cols,(h-30)/rows);for(let i=0;i<cols;i++)for(let j=0;j<rows;j++)box(x+(i-cols/2)*sz+3,y+(j-rows/2)*sz+3,sz-6,sz-6,{rx:2,fill:(i+j)%3===0?'#a9c7d9':'#dce8f0',stroke:'#b3cad9'});}
 }else if(k==='ledbank'||k==='switchbank'||k==='buttons'||k==='status'){
  const n=k==='buttons'?5:k==='status'?2:8;g._indicators=[];
  for(let i=0;i<n;i++){const xx=l+18+(w-36)*i/Math.max(1,n-1);if(k==='switchbank'){box(xx-6,y-16,12,32,{fill:'#dae7ed'});box(xx-4,y-13,8,10,{fill:'#7eb9c8'})}else{let node=dot(xx,y,k==='buttons'?8:6,{fill:k==='buttons'?'#d9e4ea':'#d6e4d9',stroke:'#8daa9d'});g._indicators.push({node,bit:i})}}
  e('rect',{x:l,y:top,width:w,height:h,fill:'transparent','class':'sc-body',stroke:'none'},g);
 }else{
  // Connector silhouettes have visible sockets and contact rows.
  const hh=Math.min(h-20,58);box(l+8,y-hh/2,w-16,hh,{rx:k==='vga'?12:4,fill:'#edf1f3','class':'sc-body'});
  if(k==='usb'||k==='usbhost'){box(l+20,y-14,w-40,28,{fill:'#405a69',stroke:'none'});for(let i=0;i<4;i++)box(x-26+i*17,y-5,9,10,{fill:'#d2b66b',stroke:'none',rx:1})}
  else{const n=k==='vga'?5:6;for(let row=0;row<2;row++)for(let i=0;i<n;i++)dot(l+29+i*(w-58)/(n-1),y-9+row*18,3,{fill:'#c0b077',stroke:'#889798','stroke-width':.7})}
 }
 return true;
}
