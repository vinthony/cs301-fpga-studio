package cs301
import chisel3._
import chisel3.util._
import scala.language.reflectiveCalls

class FetchPacket extends Bundle {
 val v=Bool();val pc=UInt(32.W);val word=UInt(32.W);val fault=UInt(4.W)
}
class ExecutePacket extends Bundle {
 val v=Bool();val pc=UInt(32.W);val word=UInt(32.W);val fault=UInt(4.W)
 val ctrl=UInt(16.W);val imm=UInt(32.W);val op=UInt(4.W);val id=UInt(6.W)
 val rd=UInt(5.W);val rs1=UInt(5.W);val rs2=UInt(5.W);val r1=UInt(32.W);val r2=UInt(32.W)
 val write=Bool();val unsignedLoad=Bool();val branch=UInt(3.W);val trap=UInt(2.W)
}
class MemoryPacket extends Bundle {
 val v=Bool();val pc=UInt(32.W);val word=UInt(32.W);val ctrl=UInt(16.W)
 val rd=UInt(5.W);val write=Bool();val unsignedLoad=Bool()
 val address=UInt(32.W);val storeData=UInt(32.W);val value=UInt(32.W);val nextPC=UInt(32.W)
 val fault=UInt(4.W);val faultValue=UInt(32.W)
}
class WritebackPacket extends Bundle {
 val v=Bool();val pc=UInt(32.W);val word=UInt(32.W);val rd=UInt(5.W);val write=Bool()
 val value=UInt(32.W);val nextPC=UInt(32.W);val fault=UInt(4.W);val faultValue=UInt(32.W)
}

/** Five-stage RV32I teaching pipeline. mode: 0 no hazard repair, 1 stall-only, 2 forwarding.
  * External combinational instruction ROM. Private 256-byte RAM and the Lab13 MMIO EEI.
  * EX redirects squash younger IF/ID. Faults drain older work and stop precisely at WB.
  * MEM commits stores. WB-to-ID bypass is explicit in all three modes.
  */
class PipelineCPU extends Module {
 val io=IO(new Bundle {
  val step=Input(Bool());val clear=Input(Bool());val mode=Input(UInt(2.W))
  val instruction=Input(UInt(32.W));val instructionValid=Input(Bool())
  val switches=Input(UInt(16.W));val buttons=Input(UInt(5.W))
  val fetchPC=Output(UInt(32.W));val pc=Output(UInt(32.W));val retired=Output(UInt(32.W))
  val halted=Output(Bool());val reason=Output(UInt(4.W));val faultValue=Output(UInt(32.W))
  val registers=Output(Vec(32,UInt(32.W)));val memory=Output(Vec(256,UInt(8.W)))
  val led=Output(UInt(16.W));val display=Output(UInt(32.W));val cycles=Output(UInt(32.W))
  val stageValid=Output(Vec(4,Bool()));val stagePC=Output(Vec(4,UInt(32.W)))
  val stall=Output(Bool());val redirect=Output(Bool());val forwardA=Output(UInt(2.W));val forwardB=Output(UInt(2.W))
  val stalls=Output(UInt(32.W));val redirects=Output(UInt(32.W));val pendingTrap=Output(Bool())
 })
 val fetchPC=RegInit(0.U(32.W));val pc=RegInit(0.U(32.W));val retired=RegInit(0.U(32.W))
 val cycles=RegInit(0.U(32.W));val halted=RegInit(false.B);val reason=RegInit(0.U(4.W));val faultValue=RegInit(0.U(32.W))
 val pendingTrap=RegInit(false.B);val stalls=RegInit(0.U(32.W));val redirects=RegInit(0.U(32.W))
 val memory=RegInit(VecInit(Seq.fill(256)(0.U(8.W))))
 val led=RegInit(0.U(16.W));val display=RegInit(0.U(32.W))
 val f=RegInit(0.U.asTypeOf(new FetchPacket));val e=RegInit(0.U.asTypeOf(new ExecutePacket))
 val m=RegInit(0.U.asTypeOf(new MemoryPacket));val w=RegInit(0.U.asTypeOf(new WritebackPacket))
 val dec=Module(new Decoder32);val rf=Module(new RegFile32);val alu=Module(new ALU32)
 dec.io.instruction:=f.word
 rf.io.ra:=Mux(dec.io.control(1),dec.io.rs1,0.U);rf.io.rb:=Mux(dec.io.control(2),dec.io.rs2,0.U)
 val wbWrite=w.v&&w.fault===0.U&&w.write
 rf.io.wa:=w.rd;rf.io.wd:=w.value;rf.io.clear:=io.clear;rf.io.bypass:=false.B
 rf.io.we:=io.step&& !io.clear&& !reset.asBool&& !halted&&wbWrite
 val decode=WireDefault(0.U.asTypeOf(new ExecutePacket))
 decode.v:=f.v;decode.pc:=f.pc;decode.word:=f.word;decode.fault:=f.fault
 decode.ctrl:=dec.io.control;decode.imm:=dec.io.immediate;decode.op:=dec.io.alu;decode.id:=dec.io.id
 decode.rd:=dec.io.rd;decode.rs1:=dec.io.rs1;decode.rs2:=dec.io.rs2;decode.write:=dec.io.effectiveRegWrite
 decode.unsignedLoad:=dec.io.loadUnsigned;decode.branch:=dec.io.branchKind;decode.trap:=dec.io.trapKind
 // WB happens at the same edge ID captures: model the write-first convention explicitly.
 decode.r1:=Mux(wbWrite&&dec.io.rs1=/=0.U&&w.rd===dec.io.rs1,w.value,rf.io.rawA)
 decode.r2:=Mux(wbWrite&&dec.io.rs2=/=0.U&&w.rd===dec.io.rs2,w.value,rf.io.rawB)

 def forwarded(reg:UInt,value:UInt,used:Bool):(UInt,UInt)={
  val out=WireDefault(Mux(used&&reg=/=0.U,value,0.U));val source=WireDefault(0.U(2.W))
  when(io.mode===2.U&&used&&reg=/=0.U){
   when(m.v&&m.fault===0.U&&m.write&& !m.ctrl(4)&&m.rd===reg){out:=m.value;source:=1.U}
   .elsewhen(wbWrite&&w.rd===reg){out:=w.value;source:=2.U}
  };(out,source)
 }
 val (r1,forwardA)=forwarded(e.rs1,e.r1,e.v&&e.ctrl(1));val (r2,forwardB)=forwarded(e.rs2,e.r2,e.v&&e.ctrl(2))
 alu.io.a:=Mux(e.ctrl(9),e.pc,r1);alu.io.b:=Mux(e.ctrl(8),e.imm,r2);alu.io.op:=e.op
 val condition=WireDefault(false.B)
 switch(e.branch){
  is(0.U){condition:=r1===r2};is(1.U){condition:=r1=/=r2}
  is(4.U){condition:=r1.asSInt<r2.asSInt};is(5.U){condition:=r1.asSInt>=r2.asSInt}
  is(6.U){condition:=r1<r2};is(7.U){condition:=r1>=r2}
 }
 val taken=e.ctrl(7)||(e.ctrl(6)&&condition)
 val target=Mux(e.id===34.U,alu.io.result & "hfffffffe".U,(e.pc+e.imm)(31,0))
 val exFault=WireDefault(e.fault);val exFaultValue=WireDefault(e.pc)
 when(e.fault===0.U){
  when(!e.ctrl(0)){exFault:=2.U;exFaultValue:=e.word}
  .elsewhen(taken&&target(1,0)=/=0.U){exFault:=4.U;exFaultValue:=target}
  .elsewhen(e.ctrl(10)){exFault:=Mux(e.trap===2.U,1.U,9.U);exFaultValue:=0.U}
 }
 val execute=WireDefault(0.U.asTypeOf(new MemoryPacket))
 execute.v:=e.v;execute.pc:=e.pc;execute.word:=e.word;execute.ctrl:=e.ctrl;execute.rd:=e.rd;execute.write:=e.write
 execute.unsignedLoad:=e.unsignedLoad;execute.address:=alu.io.result;execute.storeData:=r2
 execute.nextPC:=Mux(taken,target,(e.pc+4.U)(31,0));execute.fault:=exFault;execute.faultValue:=exFaultValue
 execute.value:=Mux(e.ctrl(13,12)===2.U,(e.pc+4.U)(31,0),Mux(e.ctrl(13,12)===3.U,e.imm,alu.io.result))

 val size=m.ctrl(15,14);val address=m.address
 val bytes=Mux(size===0.U,1.U(3.W),Mux(size===1.U,2.U(3.W),4.U(3.W)))
 val inRAM=address<=Mux(size===0.U,255.U,Mux(size===1.U,254.U,252.U))
 val mmio=Seq("hffff0000","hffff0004","hffff0008","hffff000c").map(x=>address===x.U).reduce(_||_)
 val ioWritable=address==="hffff0004".U||address==="hffff0008".U
 val ioAllowed=size===2.U&&mmio&&(!m.ctrl(5)||ioWritable)
 val memRequest=m.ctrl(4)||m.ctrl(5)
 val misaligned=Mux(size===0.U,false.B,Mux(size===1.U,address(0),address(1,0)=/=0.U))
 val memFault=WireDefault(m.fault);val memFaultValue=WireDefault(m.faultValue)
 when(m.fault===0.U){
  when(memRequest&&misaligned){memFault:=Mux(m.ctrl(5),6.U,5.U);memFaultValue:=address}
  .elsewhen(memRequest&& !inRAM&& !ioAllowed){memFault:=Mux(m.ctrl(5),8.U,7.U);memFaultValue:=address}
 }
 val word=Cat((0 until 4).reverse.map(i=>memory((address+i.U)(7,0))))
 val byteValue=Mux(m.unsignedLoad,Cat(0.U(24.W),word(7,0)),Cat(Fill(24,word(7)),word(7,0)))
 val halfValue=Mux(m.unsignedLoad,Cat(0.U(16.W),word(15,0)),Cat(Fill(16,word(15)),word(15,0)))
 val ramRead=Mux(size===0.U,byteValue,Mux(size===1.U,halfValue,word))
 val ioRead=Mux(address==="hffff0000".U,io.switches,Mux(address==="hffff000c".U,io.buttons,Mux(address==="hffff0004".U,led,display)))
 val memoryNext=WireDefault(0.U.asTypeOf(new WritebackPacket))
 memoryNext.v:=m.v;memoryNext.pc:=m.pc;memoryNext.word:=m.word;memoryNext.rd:=m.rd;memoryNext.write:=m.write
 memoryNext.value:=Mux(m.ctrl(4),Mux(inRAM,ramRead,ioRead),m.value);memoryNext.nextPC:=m.nextPC
 memoryNext.fault:=memFault;memoryNext.faultValue:=memFaultValue

 def depends(rd:UInt):Bool=rd=/=0.U&&((dec.io.control(1)&&dec.io.rs1===rd)||(dec.io.control(2)&&dec.io.rs2===rd))
 val eDependency=e.v&&e.write&&e.fault===0.U&&depends(e.rd)
 val mDependency=m.v&&m.write&&m.fault===0.U&&depends(m.rd)
 val stall=f.v&&Mux(io.mode===1.U,eDependency||mDependency,io.mode===2.U&&eDependency&&e.ctrl(4))
 val redirect=e.v&&exFault===0.U&&taken
 val fetched=WireDefault(0.U.asTypeOf(new FetchPacket));fetched.v:=true.B;fetched.pc:=fetchPC;fetched.word:=io.instruction
 fetched.fault:=Mux(fetchPC(1,0)=/=0.U,4.U,Mux(!io.instructionValid,3.U,0.U))
 when(io.clear){
  fetchPC:=0.U;pc:=0.U;retired:=0.U;cycles:=0.U;halted:=false.B;reason:=0.U;faultValue:=0.U
  pendingTrap:=false.B;stalls:=0.U;redirects:=0.U;led:=0.U;display:=0.U;memory.foreach(_:=0.U)
  f:=0.U.asTypeOf(new FetchPacket);e:=0.U.asTypeOf(new ExecutePacket);m:=0.U.asTypeOf(new MemoryPacket);w:=0.U.asTypeOf(new WritebackPacket)
 }.elsewhen(io.step&& !halted){
  cycles:=cycles+1.U
  when(w.v&&w.fault=/=0.U){
   halted:=true.B;reason:=w.fault;faultValue:=w.faultValue;pc:=w.pc;pendingTrap:=true.B
   f.v:=false.B;e.v:=false.B;m.v:=false.B;w.v:=false.B
  }.otherwise{
   when(w.v){retired:=retired+1.U;pc:=w.nextPC}
   when(m.v&&memFault===0.U&&m.ctrl(5)){
    when(inRAM){for(i<-0 until 4){when(i.U<bytes){memory((address+i.U)(7,0)):=m.storeData(8*i+7,8*i)}}}
    .otherwise{when(address==="hffff0004".U){led:=m.storeData(15,0)}.otherwise{display:=m.storeData}}
   }
   w:=memoryNext;m:=execute
   when(m.v&&memFault=/=0.U){m.v:=false.B;e.v:=false.B;f.v:=false.B;pendingTrap:=true.B}
   .elsewhen(e.v&&exFault=/=0.U){e.v:=false.B;f.v:=false.B;pendingTrap:=true.B}
   .elsewhen(redirect){fetchPC:=target;e.v:=false.B;f.v:=false.B;redirects:=redirects+1.U}
   .elsewhen(pendingTrap){e.v:=false.B;f.v:=false.B}
   .elsewhen(stall){e.v:=false.B;stalls:=stalls+1.U}
   .otherwise{e:=decode;f:=fetched;fetchPC:=(fetchPC+4.U)(31,0)}
  }
 }
 io.fetchPC:=fetchPC;io.pc:=pc;io.retired:=retired;io.halted:=halted;io.reason:=reason;io.faultValue:=faultValue
 io.registers:=rf.io.saved;io.memory:=memory;io.led:=led;io.display:=display;io.cycles:=cycles
 io.stageValid:=VecInit(Seq(f.v,e.v,m.v,w.v));io.stagePC:=VecInit(Seq(f.pc,e.pc,m.pc,w.pc))
 io.stall:=stall;io.redirect:=redirect;io.forwardA:=forwardA;io.forwardB:=forwardB
 io.stalls:=stalls;io.redirects:=redirects;io.pendingTrap:=pendingTrap
}
