package cs301
import chisel3._
import chisel3.util._
import scala.language.reflectiveCalls
/** Lab12: RV32I R/I arithmetic path; instruction memory is external combinational input.
  * One enabled edge retires one supported arithmetic instruction. EBREAK stops precisely.
  * reason: 0 running, 1 EBREAK, 2 unsupported, 3 fetch unavailable, 4 PC misaligned.
  */
class ArithmeticCPU extends Module {
  val io=IO(new Bundle {
    val step=Input(Bool());val clear=Input(Bool())
    val instruction=Input(UInt(32.W));val instructionValid=Input(Bool())
    val pc=Output(UInt(32.W));val retired=Output(UInt(32.W));val halted=Output(Bool());val reason=Output(UInt(3.W))
    val registers=Output(Vec(32,UInt(32.W)))
    val candidate=Output(UInt(32.W));val candidateRd=Output(UInt(5.W));val commit=Output(Bool())
  })
  val pc=RegInit(0.U(32.W));val retired=RegInit(0.U(32.W));val halted=RegInit(false.B);val reason=RegInit(0.U(3.W))
  val dec=Module(new Decoder32);val rf=Module(new RegFile32);val alu=Module(new ALU32)
  dec.io.instruction:=io.instruction
  rf.io.ra:=Mux(dec.io.control(1),dec.io.rs1,0.U);rf.io.rb:=Mux(dec.io.control(2),dec.io.rs2,0.U)
  rf.io.wa:=dec.io.rd;rf.io.clear:=io.clear;rf.io.bypass:=false.B
  alu.io.a:=rf.io.rawA;alu.io.b:=Mux(dec.io.control(8),dec.io.immediate,rf.io.rawB);alu.io.op:=dec.io.alu
  val supported=dec.io.valid && dec.io.id<=18.U
  val bad= !io.instructionValid || pc(1,0)=/=0.U || !supported
  val commit=io.step && !halted && !io.clear && !reset.asBool && !bad
  rf.io.we:=commit && dec.io.effectiveRegWrite;rf.io.wd:=alu.io.result
  when(io.clear){pc:=0.U;retired:=0.U;halted:=false.B;reason:=0.U}
    .elsewhen(io.step && !halted){
      when(bad){
        halted:=true.B
        reason:=Mux(!io.instructionValid,3.U,Mux(pc(1,0)=/=0.U,4.U,Mux(dec.io.id===39.U,1.U,2.U)))
      }.otherwise{pc:=pc+4.U;retired:=retired+1.U}
    }
  io.pc:=pc;io.retired:=retired;io.halted:=halted;io.reason:=reason;io.registers:=rf.io.saved
  io.candidate:=alu.io.result;io.candidateRd:=dec.io.rd;io.commit:=commit
}
