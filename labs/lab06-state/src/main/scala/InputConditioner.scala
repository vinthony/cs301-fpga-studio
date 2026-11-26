package cs301
import chisel3._
import chisel3.util._
import scala.language.reflectiveCalls

/** Sample-enabled teaching chain; each enabled edge reads OLD stage registers. */
class InputConditioner(val threshold:Int=3,val countWidth:Int=32) extends Module {
  require(threshold>=1 && countWidth>=1 && BigInt(threshold)<(BigInt(1)<<countWidth))
  val io=IO(new Bundle {
    val raw=Input(Bool());val sample=Input(Bool());val clear=Input(Bool())
    val sync1=Output(Bool());val sync2=Output(Bool());val candidate=Output(Bool())
    val consecutive=Output(UInt(countWidth.W));val stable=Output(Bool())
    val previous=Output(Bool());val event=Output(Bool())
  })
  val first=RegInit(false.B);val second=RegInit(false.B)
  val candidate=RegInit(false.B);val count=RegInit(0.U(countWidth.W))
  val stable=RegInit(false.B);val previous=RegInit(false.B);val event=RegInit(false.B)
  val maximum=((BigInt(1)<<countWidth)-1).U(countWidth.W)
  val nextCandidate=Mux(second===candidate,candidate,second)
  // Saturate rather than allow a long held level to wrap the display counter.
  val nextCount=Mux(second===candidate,Mux(count===maximum,count,count+1.U),1.U(countWidth.W))
  val nextStable=Mux(nextCount>=threshold.U,nextCandidate,stable)
  when(io.clear){
    first:=false.B;second:=false.B;candidate:=false.B;count:=0.U
    stable:=false.B;previous:=false.B;event:=false.B
  }.elsewhen(io.sample){
    first:=io.raw;second:=first;candidate:=nextCandidate;count:=nextCount
    stable:=nextStable;previous:=stable;event:=nextStable && !stable
  }
  io.sync1:=first;io.sync2:=second;io.candidate:=candidate;io.consecutive:=count
  io.stable:=stable;io.previous:=previous;io.event:=event
}
