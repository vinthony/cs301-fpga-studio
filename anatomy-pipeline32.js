'use strict';
// Five-stage instruction model. Shared ISA functions, independently staged operands and hazards.
function anatomyPipeline32State(program=anatomyAssembleCPU32(AN_CPU32_DEMOS[0].source),mode='forward',name='五级流水线程序'){
 if(!['none','forward','stall'].includes(mode))throw Error('未知冒险策略');
 const c=anatomyCPU32State(program,name);
 return {...c,mode,fetchPC:0,cycles:0,sequence:0,pendingTrap:false,stalls:0,redirects:0,stages:{ifid:null,idex:null,exmem:null,memwb:null},lastCycle:null,lastRetired:null,timeline:[]};
}
function anatomyPipeline32PacketPreview(c,packet,pins,r1=packet.r1,r2=packet.r2){
 const regs=c.regs.slice(),d=packet.d;if(d.useRS1&&d.rs1)regs[d.rs1]=r1>>>0;if(d.useRS2&&d.rs2)regs[d.rs2]=r2>>>0;
 return anatomyCPU32Preview({cpu32:{...c,pc:packet.pc,regs,halted:false},cpuSwitches:pins.switches??0x35,cpuButtons:pins.buttons??0});
}
function anatomyPipeline32Tick(c,pins={}){
 if(c.halted)return false;
 const old=c.stages,report={cycle:c.cycles+1,action:'正常推进',stall:false,redirect:false,forwardA:'未使用',forwardB:'未使用',retired:null,memory:null,flushed:[]};
 report.stages={IF:c.pendingTrap?null:{pc:c.fetchPC,name:c.fetchPC%4===0&&c.fetchPC/4<c.program.length?anatomyDecodeRV32(c.program[c.fetchPC/4]).name:'取指不可用'},ID:old.ifid?{id:old.ifid.id,pc:old.ifid.pc,name:old.ifid.fetchUnavailable?'取指不可用':old.ifid.d.name}:null,EX:old.idex?{id:old.idex.id,pc:old.idex.pc,name:old.idex.d.name}:null,MEM:old.exmem?{id:old.exmem.id,pc:old.exmem.pc,name:old.exmem.d.name}:null,WB:old.memwb?{id:old.memwb.id,pc:old.memwb.pc,name:old.memwb.d.name}:null};
 c.cycles++;
 const record=()=>{c.lastCycle=report;c.timeline.push(JSON.parse(JSON.stringify(report)));if(c.timeline.length>32)c.timeline.shift()};
 // WB writes before ID reads: explicit write-first/WB-to-ID bypass convention.
 const wb=old.memwb;
 if(wb){
  if(wb.fault){c.halted=true;c.fault={...wb.fault};c.pc=wb.pc;c.pendingTrap=true;c.stages={ifid:null,idex:null,exmem:null,memwb:null};report.action='异常在WB精确停止';record();return false}
  if(wb.write)c.regs[wb.write.address]=wb.write.value>>>0;c.regs[0]=0;
  c.pc=wb.nextPC;c.retired++;c.lastRetired={pc:wb.pc,word:wb.word,name:wb.d.name,write:wb.write,store:wb.store,io:wb.io,nextPC:wb.nextPC};report.retired=c.lastRetired;
 }
 let memoryPacket=null;
 if(old.exmem){
  const packet=old.exmem;
  if(packet.fault)memoryPacket={...packet};
  else{
   const p=anatomyPipeline32PacketPreview(c,packet,pins);
   memoryPacket={...packet,write:p.write,wb:p.wb,store:p.store,io:p.io,fault:p.fault};
   if(!p.fault){
    // Standard MEM-stage stores; younger effects are squashed before reaching MEM on fault.
    if(p.store){for(let i=0;i<p.store.bytes;i++)c.memory[p.store.address+i]=(p.store.value>>>(8*i))&255;report.memory={...p.store,kind:'store'}}
    if(p.io){if(p.io.address===0xffff0004)c.led=p.io.value&65535;else c.display=p.io.value>>>0;report.memory={...p.io,kind:'I/O store'}}
    if(packet.d.memRead)report.memory={address:p.alu,value:p.load,bytes:1<<packet.d.memSize,kind:'load'};
   }
  }
 }
 let executePacket=null;
 if(old.idex){
  const packet=old.idex,d=packet.d;
  const resolve=(reg,value,used)=>{
   if(!used||reg===0)return {value:0,source:used?'x0':'未使用'};
   if(c.mode==='forward'){
    const ex=old.exmem;
    if(ex&&!ex.fault&&ex.d.regWrite&&ex.d.rd===reg&&reg!==0){
     if(ex.d.memRead)return {value,source:'EX/MEM为LOAD，结果尚未就绪'};
     return {value:ex.wb>>>0,source:'EX/MEM'};
    }
    const m=old.memwb;if(m&&!m.fault&&m.write?.address===reg)return {value:m.write.value>>>0,source:'MEM/WB'};
   }
   return {value:value>>>0,source:'ID/EX保存值'};
  };
  const a=resolve(d.rs1,packet.r1,d.useRS1),b=resolve(d.rs2,packet.r2,d.useRS2);
  report.forwardA=a.source;report.forwardB=b.source;
  const p=anatomyPipeline32PacketPreview(c,packet,pins,a.value,b.value);
  // Data access faults and returned data become authoritative in MEM, not EX.
  const exFault=p.fault&&!/^(LOAD|STORE)_/.test(p.fault.kind)?p.fault:null;
  executePacket={...packet,r1:a.value,r2:b.value,alu:p.alu,wb:p.wb,nextPC:p.nextPC,taken:p.taken,write:p.write,fault:exFault,forwardA:a.source,forwardB:b.source};
 }
 const next={ifid:null,idex:null,exmem:executePacket,memwb:memoryPacket};
 const squash=()=>{report.flushed=[old.ifid?.id,old.idex?.id].filter(x=>x!==undefined);next.ifid=null;next.idex=null};
 if(memoryPacket?.fault){
  c.pendingTrap=true;next.exmem=null;squash();report.action='MEM异常，清空更年轻指令';
 }else if(executePacket?.fault){
  c.pendingTrap=true;squash();report.flushed=[old.ifid?.id].filter(x=>x!==undefined);report.action='EX异常，排空更早指令';
 }else if(executePacket?.taken){
  c.fetchPC=executePacket.nextPC;next.ifid=null;next.idex=null;c.redirects++;report.redirect=true;report.action='EX选择跳转，清空两级年轻指令';report.flushed=[old.ifid?.id].filter(x=>x!==undefined);
 }else if(c.pendingTrap){
  next.exmem=null;next.ifid=null;next.idex=null;report.action='异常排空中';
 }else{
  const id=old.ifid,d=id?.d,depends=packet=>packet&&packet.d.regWrite&&packet.d.rd!==0&&((d.useRS1&&d.rs1===packet.d.rd)||(d.useRS2&&d.rs2===packet.d.rd));
  const loadUse=!!(id&&old.idex?.d.memRead&&depends(old.idex));
  const raw=!!(id&&(depends(old.idex)||depends(old.exmem)));
  const stall=(c.mode==='forward'&&loadUse)||(c.mode==='stall'&&raw);
  if(stall){next.ifid=id;next.idex=null;c.stalls++;report.stall=true;report.action=loadUse?'load-use：保持PC/IF-ID，向ID-EX注入气泡':'RAW：等待旧指令写回，保持PC/IF-ID'}
  else{
   if(id)next.idex={...id,r1:d.useRS1&&d.rs1?c.regs[d.rs1]>>>0:0,r2:d.useRS2&&d.rs2?c.regs[d.rs2]>>>0:0};
   const pc=c.fetchPC>>>0,word=pc%4===0&&pc/4<c.program.length?c.program[pc/4]>>>0:0;
   next.ifid={id:c.sequence++,pc,word,d:anatomyDecodeRV32(word),r1:0,r2:0,fetchUnavailable:pc%4!==0||pc/4>=c.program.length};c.fetchPC=(pc+4)>>>0;
  }
 }
 c.regs[0]=0;c.stages=next;record();return true;
}
function anatomyPipeline32Preview(c,pins={}){
 const after=JSON.parse(JSON.stringify(c));anatomyPipeline32Tick(after,pins);return {after,decision:after.lastCycle};
}

function anatomyPipeline32Compare(program,pins={},limit=2000){
 if(!Number.isInteger(limit)||limit<1||limit>10000)throw Error('对照周期上限须为1至10000');
 const results=['none','forward','stall'].map(mode=>{
  const c=anatomyPipeline32State(program,mode);
  while(!c.halted&&c.cycles<limit)anatomyPipeline32Tick(c,pins);
  return {mode,cycles:c.cycles,retired:c.retired,stalls:c.stalls,redirects:c.redirects,complete:c.halted,fault:c.fault?.kind||null,pc:c.pc,regs:c.regs.slice(),memory:c.memory.slice(),led:c.led,display:c.display};
 });
 const baseline=results[1];
 for(const r of results){
  r.differences=[];r.comparable=r.complete&&baseline.complete;
  if(!r.comparable)continue;
  for(let i=0;i<32;i++)if(r.regs[i]!==baseline.regs[i])r.differences.push({name:'x'+i,value:r.regs[i],baseline:baseline.regs[i]});
  for(let i=0;i<256;i++)if(r.memory[i]!==baseline.memory[i])r.differences.push({name:'RAM['+i+']',value:r.memory[i],baseline:baseline.memory[i]});
  for(const key of ['led','display','pc','retired','fault'])if(r[key]!==baseline[key])r.differences.push({name:key,value:r[key],baseline:baseline[key]});
 }
 return {limit,results};
}
