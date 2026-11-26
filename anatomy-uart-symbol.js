export function drawUARTSymbol(p,g,{t,r,line}){
 if(p.type!=='uartStage')return false;
 const l=p.cx-p.w/2,top=p.cy-p.h/2,ref=g._uartRuntime={lines:[],cells:[]},text=(v,x,y,size=12)=>t(v,x,y,{'text-anchor':'middle','font-size':size},g);
 r(l,top,p.w,p.h,{rx:12,fill:'#eef5f7',stroke:'#749ba8','stroke-width':1.6,class:'sc-body'},g);text(['TXLINK','TXBAUD'].includes(p.id)?'捕获字节 → 低位先发':'逐位采样 → 组装字节',p.cx,top+25,14);
 line(`M${l+20} ${top+43}H${l+p.w-20}`,{stroke:'#b1c9d0','stroke-width':1},g);
 ref.lines.push(text('',p.cx,top+65,14),text('',p.cx,top+89,12));
 for(let i=0;i<8;i++){const x=l+18+i*33;ref.cells.push(r(x,top+108,27,25,{rx:4,fill:'#dce9ed',stroke:'#9ebdc8'},g));text('d'+(7-i),x+13,top+147,8)}
 ref.lines.push(text('',p.cx,top+174,11),text('',p.cx,top+196,10));return true;
}
export function updateUARTSymbol(g,s){
 const ref=g._uartRuntime;if(!ref)return;const tx=g._p.id==='TXBAUD'?s.baudTX?.tx:s.fifoTX?.tx,rx=s.fifoTX?.rx,isTX=['TXLINK','TXBAUD'].includes(g._p.id),labels=['START',...Array.from({length:8},(_,i)=>'d'+i),'STOP'];let byte=0,lines=[];
 if(isTX){const active=tx&&tx.uartIndex>=0;byte=tx?.uartByte??0;const frame=[0,...Array.from({length:8},(_,i)=>(byte>>>i)&1),1];lines=[active?labels[tx.uartIndex]:'IDLE',active?'捕获字节 '+byte:'空闲时捕获一次待发字节','TX = '+(active?frame[tx.uartIndex]:1),'完整帧含起始位、8数据位和停止位'];}
 else{byte=rx?.rxData??0;lines=[!rx?'等待起始位':rx.rxPhase<0?'等待起始位':rx.rxPhase<8?'下次采样 d'+rx.rxPhase:'下次检查 STOP','组装值 '+byte,'valid='+(rx?.rxValid??0)+' · error='+(rx?.rxError??0),'valid时写接收FIFO；满则丢弃并计数'];}
 ref.lines.forEach((n,i)=>n.textContent=lines[i]);ref.cells.forEach((n,i)=>n.setAttribute('fill',(byte>>>(7-i))&1?'#4d9986':'#dce9ed'));
}
