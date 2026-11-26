package cs301
import chisel3._
import chisel3.util._
import scala.language.reflectiveCalls
/** One primary clock; terminal comparison is an enable, never a generated clock. */
class BaudUARTTX(val divisor:Int=868) extends Module {
 require(divisor>=2)
 val io=IO(new Bundle {
  val enable=Input(Bool());val clear=Input(Bool());val send=Input(Bool());val data=Input(UInt(8.W))
  val count=Output(UInt(log2Ceil(divisor).W));val tick=Output(Bool())
  val tx=Output(Bool());val busy=Output(Bool());val done=Output(Bool());val accepted=Output(Bool())
  val phase=Output(UInt(4.W));val captured=Output(UInt(8.W))
 })
 val count=RegInit(0.U(log2Ceil(divisor).W))
 val terminal=count===(divisor-1).U
 val tick=io.enable && !io.clear && !reset.asBool && terminal
 when(io.clear){count:=0.U}.elsewhen(io.enable){count:=Mux(terminal,0.U,count+1.U)}
 val sender=Module(new UARTBitTX)
 sender.io.step:=tick;sender.io.clear:=io.clear;sender.io.send:=io.send;sender.io.data:=io.data
 io.count:=count;io.tick:=tick;io.tx:=sender.io.tx;io.busy:=sender.io.busy;io.done:=sender.io.done
 io.accepted:=sender.io.accepted;io.phase:=sender.io.phase;io.captured:=sender.io.captured
}
