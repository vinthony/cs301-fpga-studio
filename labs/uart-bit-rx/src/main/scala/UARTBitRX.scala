package cs301
import chisel3._
import chisel3.util._
import scala.language.reflectiveCalls
/** RX must already be stable at an external ideal BIT sample enable. No synchronizer/oversampling. */
class UARTBitRX extends Module {
 val io=IO(new Bundle {
  val step=Input(Bool());val clear=Input(Bool());val rx=Input(Bool())
  val data=Output(UInt(8.W));val phase=Output(UInt(4.W));val busy=Output(Bool());val valid=Output(Bool());val error=Output(Bool())
 })
 val data=RegInit(0.U(8.W));val phase=RegInit(15.U(4.W));val valid=RegInit(false.B);val error=RegInit(false.B)
 when(io.clear){data:=0.U;phase:=15.U;valid:=false.B;error:=false.B}
 .elsewhen(io.step){
  valid:=false.B;error:=false.B
  when(phase===15.U){when(!io.rx){phase:=0.U;data:=0.U}}
  .elsewhen(phase<8.U){when(io.rx){data:=data | (1.U(8.W)<<phase)};phase:=phase+1.U}
  .otherwise{valid:=io.rx;error := !io.rx;phase:=15.U}
 }
 io.data:=data;io.phase:=phase;io.busy:=phase=/=15.U;io.valid:=valid;io.error:=error
}
