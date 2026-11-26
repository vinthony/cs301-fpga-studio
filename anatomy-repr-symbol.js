// Integer interpretations share bits; these are semantic panels, not invented gate networks.
export function drawRepresentationSymbol(p,g,{e,t,r}){
 if(p.type!=='reprInterpretation')return false;
 const l=p.cx-p.w/2,top=p.cy-p.h/2,signed=p.id!=='U';
 r(l,top,p.w,p.h,{rx:12,fill:'#f3f7fa',stroke:'#7f9eac','stroke-width':1.6,class:'sc-body'},g);
 const text=(value,x,y,size=12)=>t(value,x,y,{'text-anchor':'middle','font-size':size},g);
 text({U:'四位都按正权求和',SM:'符号位与三位幅值',OC:'负数逐位取反，得到幅值',TC:'最高位按负权解释'}[p.id],p.cx,top+20,12);
 g._reprCells=[];
 for(let j=0;j<4;j++){
  const bit=3-j,x=l+19+j*61,node=e('g',{role:'button',tabindex:0,'data-repr-input-bit':bit},g);
  const rect=r(x,top+43,50,42,{rx:7,fill:'#e7f1f3',stroke:'#8cabb6'},node);
  t('bit'+bit,x+25,top+37,{'text-anchor':'middle','font-size':9},node);
  const digit=t('',x+25,top+72,{'text-anchor':'middle','font-size':25,'font-family':'monospace'},node);
  const weight=p.id==='U'?[8,4,2,1][j]:p.id==='TC'?[-8,4,2,1][j]:j===0?'符号':[4,2,1][j-1];
  text(typeof weight==='number'?'权 '+weight:weight,x+25,top+102,11);
  g._reprCells.push({node,rect,digit,bit,sign:signed&&j===0});
 }
 g._reprFormula=text('',p.cx,top+130,12);
 g._reprResult=text('',p.cx,top+157,18);
 return true;
}
export function updateRepresentationSymbol(g,state,evaluation){
 if(!g._reprCells)return;const word=state.reprWord&15,id=g._p.id,sign=word>>>3,mag=word&7;
 for(const item of g._reprCells){const v=(word>>>item.bit)&1;item.digit.textContent=v;item.rect.setAttribute('fill',item.sign?'#f9ecd0':v?'#cae6dd':'#eaf1f4');item.node.setAttribute('aria-label','翻转同一输入模式的bit'+item.bit+'，当前'+v)}
 const terms=weights=>weights.map((w,j)=>w*((word>>>(3-j))&1)).join(' + ');
 g._reprFormula.textContent=id==='U'?terms([8,4,2,1]):id==='TC'?terms([-8,4,2,1]):id==='SM'?(sign?'负':'正')+'号 × 幅值 '+mag:sign?'反相 '+((~word)&15).toString(2).padStart(4,'0')+' → 幅值 '+((~word)&15):'非负：直接按正权解释';
 g._reprResult.textContent='解释值：'+evaluation.partValues?.[id];
}
