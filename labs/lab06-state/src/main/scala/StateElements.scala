package cs301
import chisel3._
import chisel3.util._
import scala.language.reflectiveCalls

/** Two equivalent synchronous clear + enable register organizations. */
class RegisterCompare(val width:Int=4) extends Module {
  require(width>0)
  val io=IO(new Bundle {
    val data=Input(UInt(width.W));val enable=Input(Bool());val clear=Input(Bool())
    val regInitQ=Output(UInt(width.W));val regEnableQ=Output(UInt(width.W))
  })
  val explicit=RegInit(0.U(width.W))
  when(io.clear){explicit:=0.U}.elsewhen(io.enable){explicit:=io.data}
  // Bool reset is synchronous; clear has priority even when enable is low.
  val enabled=withReset(reset.asBool || io.clear){RegEnable(io.data,0.U(width.W),io.enable)}
  io.regInitQ:=explicit;io.regEnableQ:=enabled
}
class EnabledCounter(val width:Int=4) extends Module {
  require(width>0)
  val io=IO(new Bundle {val enable=Input(Bool());val clear=Input(Bool());val count=Output(UInt(width.W))})
  val count=RegInit(0.U(width.W))
  when(io.clear){count:=0.U}.elsewhen(io.enable){count:=count+1.U}
  io.count:=count
}
/** Toggle after exactly halfPeriod ENABLED edges. No generated clock is used. */
class BlinkDivider(val halfPeriod:Int) extends Module {
  require(halfPeriod>=1)
  val phaseWidth=math.max(1,log2Ceil(halfPeriod))
  val io=IO(new Bundle {val enable=Input(Bool());val clear=Input(Bool());val led=Output(Bool());val phase=Output(UInt(phaseWidth.W))})
  val phase=RegInit(0.U(phaseWidth.W));val led=RegInit(false.B)
  when(io.clear){phase:=0.U;led:=false.B}.elsewhen(io.enable){
    when(phase===(halfPeriod-1).U){phase:=0.U;led:= !led}.otherwise{phase:=phase+1.U}
  }
  io.led:=led;io.phase:=phase
}
/** 100 MHz assumption: toggle per 50,000,000 active edges -> full period one second. */
class OneHzBlink extends BlinkDivider(50000000)
class StateDemoTop extends Module {
  val io=IO(new Bundle {
    val data=Input(UInt(4.W));val enable=Input(Bool());val clear=Input(Bool())
    val qInit=Output(UInt(4.W));val qEnable=Output(UInt(4.W));val count=Output(UInt(4.W))
    val blink=Output(Bool());val phase=Output(UInt(2.W))
  })
  val registers=Module(new RegisterCompare(4));val counter=Module(new EnabledCounter(4));val divider=Module(new BlinkDivider(3))
  registers.io.data:=io.data;registers.io.enable:=io.enable;registers.io.clear:=io.clear
  counter.io.enable:=io.enable;counter.io.clear:=io.clear;divider.io.enable:=io.enable;divider.io.clear:=io.clear
  io.qInit:=registers.io.regInitQ;io.qEnable:=registers.io.regEnableQ
  io.count:=counter.io.count;io.blink:=divider.io.led;io.phase:=divider.io.phase
}
