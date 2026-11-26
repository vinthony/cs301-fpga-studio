package cs301
import chisel3._
import chisel3.util._
import scala.language.reflectiveCalls
class ALU4 extends Module {
  val io=IO(new Bundle {
    val a=Input(UInt(4.W));val b=Input(UInt(4.W));val op=Input(UInt(4.W))
    val result=Output(UInt(4.W));val zero=Output(Bool());val sign=Output(Bool())
    val carry=Output(Bool());val overflow=Output(Bool())
    val flagsValid=Output(Bool());val operationValid=Output(Bool())
  })
  val result=WireDefault(0.U(4.W));val shift=io.b(1,0)
  switch(io.op){
    is(0.U){result:=io.a+io.b}
    is(1.U){result:=io.a-io.b}
    is(2.U){result:=io.a&io.b}
    is(3.U){result:=io.a|io.b}
    is(4.U){result:=io.a^io.b}
    is(5.U){result:=(io.a<<shift)(3,0)}
    is(6.U){result:=io.a>>shift}
    is(7.U){result:=(io.a.asSInt>>shift).asUInt}
    is(8.U){result:=Mux(io.a.asSInt<io.b.asSInt,1.U,0.U)}
    is(9.U){result:=Mux(io.a<io.b,1.U,0.U)}
  }
  val add=io.op===0.U;val sub=io.op===1.U
  io.result:=result;io.zero:=result===0.U;io.sign:=result(3)
  io.flagsValid:=add||sub;io.operationValid:=io.op<=9.U
  io.carry:=Mux(add,(io.a+&io.b)(4),Mux(sub,io.a>=io.b,false.B))
  io.overflow:=Mux(add,(io.a(3)===io.b(3))&&(result(3)=/=io.a(3)),
    Mux(sub,(io.a(3)=/=io.b(3))&&(result(3)=/=io.a(3)),false.B))
}
