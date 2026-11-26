package cs301
import chisel3._
import chisel3.util._
import scala.language.reflectiveCalls
/** Functional RV32I teaching EEI: external instruction fetch; private byte RAM and MMIO.
  * stop reason: 1 EBREAK,2 illegal,3 fetch access,4 instruction alignment,
  * 5 load alignment,6 store alignment,7 load access,8 store access,9 ECALL.
  */
class SingleCycleCPU extends Module {
 val io=IO(new Bundle {
  val step=Input(Bool());val clear=Input(Bool())
  val instruction=Input(UInt(32.W));val instructionValid=Input(Bool())
  val switches=Input(UInt(16.W));val buttons=Input(UInt(5.W))
  val pc=Output(UInt(32.W));val retired=Output(UInt(32.W));val halted=Output(Bool());val reason=Output(UInt(4.W));val faultValue=Output(UInt(32.W))
  val registers=Output(Vec(32,UInt(32.W)));val memory=Output(Vec(256,UInt(8.W)))
  val led=Output(UInt(16.W));val display=Output(UInt(32.W))
  val candidate=Output(UInt(32.W));val nextPC=Output(UInt(32.W));val commit=Output(Bool())
 })
 val pc=RegInit(0.U(32.W));val retired=RegInit(0.U(32.W));val halted=RegInit(false.B)
 val reason=RegInit(0.U(4.W));val faultValue=RegInit(0.U(32.W))
 val memory=RegInit(VecInit(Seq.fill(256)(0.U(8.W))))
 val led=RegInit(0.U(16.W));val display=RegInit(0.U(32.W))
 val dec=Module(new Decoder32);val rf=Module(new RegFile32);val alu=Module(new ALU32)
 dec.io.instruction:=io.instruction
 rf.io.ra:=Mux(dec.io.control(1),dec.io.rs1,0.U);rf.io.rb:=Mux(dec.io.control(2),dec.io.rs2,0.U)
 rf.io.wa:=dec.io.rd;rf.io.clear:=io.clear;rf.io.bypass:=false.B
 alu.io.a:=Mux(dec.io.control(9),pc,rf.io.rawA)
 alu.io.b:=Mux(dec.io.control(8),dec.io.immediate,rf.io.rawB);alu.io.op:=dec.io.alu
 val condition=WireDefault(false.B)
 switch(dec.io.branchKind){
  is(0.U){condition:=rf.io.rawA===rf.io.rawB}
  is(1.U){condition:=rf.io.rawA=/=rf.io.rawB}
  is(4.U){condition:=rf.io.rawA.asSInt<rf.io.rawB.asSInt}
  is(5.U){condition:=rf.io.rawA.asSInt>=rf.io.rawB.asSInt}
  is(6.U){condition:=rf.io.rawA<rf.io.rawB}
  is(7.U){condition:=rf.io.rawA>=rf.io.rawB}
 }
 val taken=dec.io.control(7)||(dec.io.control(6)&&condition)
 val target=Mux(dec.io.id===34.U,alu.io.result & "hfffffffe".U,(pc+dec.io.immediate)(31,0))
 val nextPC=Mux(taken,target,(pc+4.U)(31,0))
 val address=alu.io.result;val size=dec.io.control(15,14)
 val bytes=Mux(size===0.U,1.U(3.W),Mux(size===1.U,2.U(3.W),4.U(3.W)))
 val inRAM=address<=Mux(size===0.U,255.U,Mux(size===1.U,254.U,252.U))
 val mmio=Seq("hffff0000","hffff0004","hffff0008","hffff000c").map(x=>address===x.U).reduce(_||_)
 val ioWritable=address==="hffff0004".U||address==="hffff0008".U
 val ioAllowed=size===2.U&&mmio&&(!dec.io.control(5)||ioWritable)
 val memRequest=dec.io.control(4)||dec.io.control(5)
 val misaligned=Mux(size===0.U,false.B,Mux(size===1.U,address(0),address(1,0)=/=0.U))
 val ramWord=Cat((0 until 4).reverse.map(i=>memory((address+i.U)(7,0))))
 val byteValue=Mux(dec.io.loadUnsigned,Cat(0.U(24.W),ramWord(7,0)),Cat(Fill(24,ramWord(7)),ramWord(7,0)))
 val halfValue=Mux(dec.io.loadUnsigned,Cat(0.U(16.W),ramWord(15,0)),Cat(Fill(16,ramWord(15)),ramWord(15,0)))
 val ramRead=Mux(size===0.U,byteValue,Mux(size===1.U,halfValue,ramWord))
 val ioRead=Mux(address==="hffff0000".U,io.switches,Mux(address==="hffff000c".U,io.buttons,Mux(address==="hffff0004".U,led,display)))
 val load=Mux(inRAM,ramRead,ioRead)
 val wb=WireDefault(alu.io.result)
 switch(dec.io.control(13,12)){
  is(1.U){wb:=load};is(2.U){wb:=(pc+4.U)(31,0)};is(3.U){wb:=dec.io.immediate}
 }
 val fault=WireDefault(0.U(4.W));val value=WireDefault(0.U(32.W))
 when(pc(1,0)=/=0.U){fault:=4.U;value:=pc}
 .elsewhen(!io.instructionValid){fault:=3.U;value:=pc}
 .elsewhen(!dec.io.valid){fault:=2.U;value:=io.instruction}
 .elsewhen(taken&&nextPC(1,0)=/=0.U){fault:=4.U;value:=nextPC}
 .elsewhen(memRequest&&misaligned){fault:=Mux(dec.io.control(5),6.U,5.U);value:=address}
 .elsewhen(memRequest&& !inRAM&& !ioAllowed){fault:=Mux(dec.io.control(5),8.U,7.U);value:=address}
 .elsewhen(dec.io.control(10)){fault:=Mux(dec.io.trapKind===2.U,1.U,9.U)}
 val commit=io.step&& !io.clear&& !reset.asBool&& !halted&&fault===0.U
 rf.io.we:=commit&&dec.io.effectiveRegWrite;rf.io.wd:=wb
 when(io.clear){
  pc:=0.U;retired:=0.U;halted:=false.B;reason:=0.U;faultValue:=0.U;led:=0.U;display:=0.U
  memory.foreach(_:=0.U)
 }.elsewhen(io.step&& !halted){
  when(fault=/=0.U){halted:=true.B;reason:=fault;faultValue:=value}
  .otherwise{
   pc:=nextPC;retired:=retired+1.U
   when(dec.io.control(5)){
    when(inRAM){for(i<-0 until 4){when(i.U<bytes){memory((address+i.U)(7,0)):=rf.io.rawB(8*i+7,8*i)}}}
    .otherwise{when(address==="hffff0004".U){led:=rf.io.rawB(15,0)}.otherwise{display:=rf.io.rawB}}
   }
  }
 }
 io.pc:=pc;io.retired:=retired;io.halted:=halted;io.reason:=reason;io.faultValue:=faultValue
 io.registers:=rf.io.saved;io.memory:=memory;io.led:=led;io.display:=display
 io.candidate:=wb;io.nextPC:=nextPC;io.commit:=commit
}
