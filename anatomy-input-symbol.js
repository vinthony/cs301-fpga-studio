export function drawInputSymbol(p,g,{e,t,r,line}){
 if(!['inputSync','inputDebounce','inputEvent'].includes(p.type))return false;
 const l=p.cx-p.w/2,top=p.cy-p.h/2,text=(s,x,y,size=12)=>t(s,x,y,{'text-anchor':'middle','font-size':size},g),wire=d=>line(d,{stroke:'#558797','stroke-width':1.8},g),box=(x,y,w,h,fill='#edf4f7')=>r(x,y,w,h,{rx:7,fill,stroke:'#8eacb9','stroke-width':1.3},g);
 r(l,top,p.w,p.h,{rx:11,fill:'#f7fafb',stroke:'#809faa','stroke-width':1.5,class:'sc-body'},g);
 g._inputRuntime={kind:p.type};const refs=g._inputRuntime;
 if(p.type==='inputSync'){
  text('两个触发器 · 第二级接收旧值',p.cx,top+21,12);
  refs.ff=[];
  for(let i=0;i<2;i++){const x=l+25+i*130;box(x,top+48,80,69);text('FF'+(i+1),x+40,top+64,11);refs.ff.push(text('',x+40,top+92,20));wire(`M${x} ${top+98}l8 5-8 5`);}
  wire(`M${l} ${top+98}H${l+12}V${top+82}H${l+25}M${l+105} ${top+82}H${l+155}M${l+235} ${top+82}H${l+248}V${top+98}H${l+260}`);
  wire(`M${l+15} ${top+141}H${l+160}M${l+15} ${top+141}V${top+104}H${l+25}M${l+145} ${top+141}V${top+104}H${l+155}`);
  text('共享采样边沿',p.cx,top+160,11);refs.next=text('',p.cx,top+180,10);
 }else if(p.type==='inputDebounce'){
  text('候选匹配与连续计数',p.cx,top+21,12);wire(`M${l} ${top+110}H${l+8}V${top+65}H${l+15}M${l+268} ${top+172}H${l+290}V${top+110}H${l+300}`);
  box(l+15,top+38,120,54);box(l+165,top+38,120,54);text('候选值',l+75,top+55,11);text('连续次数',l+225,top+55,11);refs.candidate=text('',l+75,top+80,19);refs.count=text('',l+225,top+80,19);
  wire(`M${l+135} ${top+65}H${l+165}`);text('相同 +1 · 不同重记1',p.cx,top+114,11);wire(`M${p.cx} ${top+120}V${top+148}`);
  box(l+32,top+149,p.w-64,46,'#e9f1de');text('次数≥3才更新稳定值',p.cx,top+145,11);refs.stable=text('',p.cx,top+178,16);
 }else{
  text('当前稳定值 AND NOT 上一稳定值',p.cx,top+21,11);
  refs.current=text('',l+65,top+54,14);wire(`M${l} ${top+110}H${l+8}V${top+65}H${l+15}`);wire(`M${l+15} ${top+65}H${l+155}`);
  box(l+15,top+110,90,48);text('上一稳定值',l+60,top+125,10);refs.previous=text('',l+60,top+147,17);
  wire(`M${l+105} ${top+135}H${l+119}`);line(`M${l+119} ${top+122}L${l+140} ${top+135}L${l+119} ${top+148}Z`,{fill:'#fff',stroke:'#558797','stroke-width':1.6},g);e('circle',{cx:l+144,cy:top+135,r:4,fill:'#fff',stroke:'#558797'},g);wire(`M${l+148} ${top+135}H${l+151}V${top+88}H${l+155}`);
  line(`M${l+155} ${top+45}H${l+190}A35 30 0 0 1 ${l+190} ${top+105}H${l+155}Z`,{fill:'#f0eadf',stroke:'#558797','stroke-width':1.6},g);wire(`M${l+225} ${top+75}H${l+p.w-10}V${top+110}H${l+p.w}`);refs.event=text('',p.cx,top+190,17);
 }
 return true;
}
export function updateInputSymbol(g,s){
 const refs=g._inputRuntime;if(!refs)return;
 if(refs.kind==='inputSync'){refs.ff[0].textContent=s.s1;refs.ff[1].textContent=s.s2;refs.next.textContent='下一边沿：'+s.a+' → FF1；旧FF1 '+s.s1+' → FF2'}
 else if(refs.kind==='inputDebounce'){refs.candidate.textContent=s.candidate;refs.count.textContent=s.consecutive;refs.stable.textContent='已保存稳定值 = '+s.stable}
 else{refs.current.textContent='当前 = '+s.stable;refs.previous.textContent=s.previous;refs.event.textContent=s.stable+' AND NOT '+s.previous+' = '+s.keyEvent}
}
