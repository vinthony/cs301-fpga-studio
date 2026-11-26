package cs301
import chisel3._
import chisel3.util._
import scala.language.reflectiveCalls
/** 8N1 transmitter. step is an EXTERNAL bit-period enable, not a baud generator. */
class UARTBitTX extends Module {
 val io=IO(new Bundle {
  val step=Input(Bool());val clear=Input(Bool());val send=Input(Bool());val data=Input(UInt(8.W))
  val tx=Output(Bool());val busy=Output(Bool());val done=Output(Bool());val accepted=Output(Bool())
  val phase=Output(UInt(4.W));val captured=Output(UInt(8.W))
 })
 val phase=RegInit(15.U(4.W));val captured=RegInit(0.U(8.W));val done=RegInit(false.B)
 val busy=phase=/=15.U
 io.accepted:=io.step && !io.clear && !reset.asBool && io.send && !busy
 when(io.clear){phase:=15.U;captured:=0.U;done:=false.B}
 .elsewhen(io.step){
  done:=false.B
  when(!busy){when(io.send){captured:=io.data;phase:=0.U}}
  .elsewhen(phase===9.U){phase:=15.U;done:=true.B}
  .otherwise{phase:=phase+1.U}
 }
 io.tx:=Mux(!busy,true.B,Mux(phase===0.U,false.B,Mux(phase===9.U,true.B,(captured>>(phase-1.U))(0))))
 io.busy:=busy;io.done:=done;io.phase:=phase;io.captured:=captured
}
