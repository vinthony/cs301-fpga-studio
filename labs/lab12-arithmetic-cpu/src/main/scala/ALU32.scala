package cs301
import chisel3._
import chisel3.util._
import scala.language.reflectiveCalls
class TeachingALU(val width:Int=32) extends Module {
  require(width>=2 && (width & (width-1))==0, "power-of-two width required")
  val io=IO(new Bundle {
    val a=Input(UInt(width.W));val b=Input(UInt(width.W));val op=Input(UInt(4.W))
    val result=Output(UInt(width.W));val zero=Output(Bool());val sign=Output(Bool())
    val carry=Output(Bool());val overflow=Output(Bool())
    val flagsValid=Output(Bool());val operationValid=Output(Bool())
  })
  val result=WireDefault(0.U(width.W));val shift=io.b(log2Ceil(width)-1,0)
  switch(io.op){
    is(0.U){result:=io.a+io.b}
    is(1.U){result:=io.a-io.b}
    is(2.U){result:=io.a&io.b}
    is(3.U){result:=io.a|io.b}
    is(4.U){result:=io.a^io.b}
    is(5.U){result:=(io.a<<shift)(width-1,0)}
    is(6.U){result:=io.a>>shift}
    is(7.U){result:=(io.a.asSInt>>shift).asUInt}
    is(8.U){result:=Mux(io.a.asSInt<io.b.asSInt,1.U,0.U)}
    is(9.U){result:=Mux(io.a<io.b,1.U,0.U)}
  }
  val add=io.op===0.U;val sub=io.op===1.U
  io.result:=result;io.zero:=result===0.U;io.sign:=result(width-1)
  io.flagsValid:=add||sub;io.operationValid:=io.op<=9.U
  io.carry:=Mux(add,(io.a+&io.b)(width),Mux(sub,io.a>=io.b,false.B))
  io.overflow:=Mux(add,(io.a(width-1)===io.b(width-1))&&(result(width-1)=/=io.a(width-1)),
    Mux(sub,(io.a(width-1)=/=io.b(width-1))&&(result(width-1)=/=io.a(width-1)),false.B))
}

class ALU32 extends TeachingALU(32)
