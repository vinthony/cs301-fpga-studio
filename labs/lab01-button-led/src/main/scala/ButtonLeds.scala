package cs301
import chisel3._
import chisel3.util._
import scala.language.reflectiveCalls

/** Four independent combinational wires; no counter, sampling or debounce. */
class ButtonLeds extends Module {
  val io=IO(new Bundle {
    val buttons=Input(UInt(4.W))
    val leds=Output(UInt(4.W))
  })
  io.leds:=io.buttons
}
/** Teaching interface matching the web profile, not physical pin constraints.
  * buttons[0..4] = C,U,L,R,D. D and switches are deliberately unused.
  * seg/an/dp use an explicitly assumed active-low display interface.
  */
class TeachingButtonTop extends Module {
  val io=IO(new Bundle {
    val buttons=Input(UInt(5.W));val switches=Input(UInt(16.W))
    val leds=Output(UInt(16.W));val seg=Output(UInt(7.W));val an=Output(UInt(4.W));val dp=Output(Bool())
  })
  val core=Module(new ButtonLeds)
  core.io.buttons:=io.buttons(3,0)
  io.leds:=Cat(0.U(12.W),core.io.leds)
  io.seg:="b1111111".U;io.an:="b1111".U;io.dp:=true.B
}
