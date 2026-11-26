package cs301
import chisel3._
import chisel3.util._
import scala.language.reflectiveCalls
/** Single-clock FIFO; empty simultaneous push/pop does not bypass the new byte. */
class TeachingFIFO(val depth:Int=4,val width:Int=8) extends Module {
 require(depth>=2 && isPow2(depth) && width>=1)
 private val ptrWidth=log2Ceil(depth)
 val io=IO(new Bundle {
  val step=Input(Bool());val clear=Input(Bool());val push=Input(Bool());val pop=Input(Bool());val data=Input(UInt(width.W))
  val pushAccepted=Output(Bool());val popAccepted=Output(Bool())
  val head=Output(UInt(width.W));val valid=Output(Bool());val empty=Output(Bool());val full=Output(Bool())
  val readPointer=Output(UInt(ptrWidth.W));val writePointer=Output(UInt(ptrWidth.W));val count=Output(UInt(log2Ceil(depth+1).W))
  val saved=Output(Vec(depth,UInt(width.W)))
 })
 val mem=RegInit(VecInit(Seq.fill(depth)(0.U(width.W))))
 val rp=RegInit(0.U(ptrWidth.W));val wp=RegInit(0.U(ptrWidth.W));val count=RegInit(0.U(log2Ceil(depth+1).W))
 val allowed=io.step && !io.clear && !reset.asBool
 val takePop=allowed && io.pop && count=/=0.U
 val takePush=allowed && io.push && (count<depth.U || takePop)
 when(io.clear){mem.foreach(_:=0.U);rp:=0.U;wp:=0.U;count:=0.U}
 .otherwise{
  when(takePush){mem(wp):=io.data;wp:=wp+1.U}
  when(takePop){rp:=rp+1.U}
  when(takePush && !takePop){count:=count+1.U}
  when(takePop && !takePush){count:=count-1.U}
 }
 io.pushAccepted:=takePush;io.popAccepted:=takePop
 io.valid:=count=/=0.U;io.empty:=count===0.U;io.full:=count===depth.U
 io.head:=Mux(io.valid,mem(rp),0.U);io.readPointer:=rp;io.writePointer:=wp;io.count:=count;io.saved:=mem
}
