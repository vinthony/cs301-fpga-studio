export function drawFIFOSymbol(p,g,{t,r}){
 if(p.type!=='fifoBytes')return false;
 const l=p.cx-p.w/2,top=p.cy-p.h/2,ref=g._fifoRuntime={rows:[],cells:[],labels:[],values:[]},text=(v,x,y,size=11)=>t(v,x,y,{'text-anchor':'middle','font-size':size},g);
 r(l,top,p.w,p.h,{rx:10,fill:'#f1f6f8',stroke:'#7899a9','stroke-width':1.6,class:'sc-body'},g);text('4 × 8位物理阵列 · 旧值也保留',p.cx,top+23,13);
 for(let a=0;a<4;a++){const y=top+52+a*30;ref.rows.push(r(l+8,y-15,p.w-16,25,{rx:4,fill:'none',stroke:'none'},g));ref.labels.push(text('',l+43,y+1,9));for(let bit=7;bit>=0;bit--)ref.cells.push({a,bit,node:r(l+78+(7-bit)*24,y-12,18,18,{rx:2,fill:'#dce9ed',stroke:'#b4c8d0'},g)});ref.values.push(text('',l+p.w-26,y+1))}
 text('实线金框=有效 · R读指针 / W写指针',p.cx,top+p.h-10,10);return true;
}
export function updateFIFOSymbol(g,s){
 const ref=g._fifoRuntime;if(!ref)return;if(g._p.id==='RXQ')s=s.fifoTX?.rxFIFO||{fifoMem:[0,0,0,0],fifoCount:0,fifoRead:0,fifoWrite:0};if(!s.fifoMem)return;
 const valid=Array.from({length:s.fifoCount},(_,i)=>(s.fifoRead+i)%4);
 ref.rows.forEach((n,a)=>{n.setAttribute('stroke',valid.includes(a)?'#bd9b45':'#bfccd1');n.setAttribute('stroke-dasharray',valid.includes(a)?'none':'3 3')});
 ref.labels.forEach((n,a)=>n.textContent='@'+a+(s.fifoRead===a?' R':'')+(s.fifoWrite===a?' W':''));
 for(const c of ref.cells){c.node.setAttribute('fill',(s.fifoMem[c.a]>>>c.bit)&1?'#4d9785':'#dce9ed');c.node.setAttribute('opacity',valid.includes(c.a)?1:.4)}
 ref.values.forEach((n,a)=>n.textContent=s.fifoMem[a].toString(16).toUpperCase().padStart(2,'0'));
}
