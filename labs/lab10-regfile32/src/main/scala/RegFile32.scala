package cs301
import chisel3._
import chisel3.util._
import scala.language.reflectiveCalls
class TeachingRegFile(val width:Int=32,val depth:Int=32) extends Module {
  require(width>0 && depth>=2 && (depth & (depth-1))==0)
  val addressWidth=log2Ceil(depth)
  val io=IO(new Bundle {
    val ra=Input(UInt(addressWidth.W));val rb=Input(UInt(addressWidth.W));val wa=Input(UInt(addressWidth.W))
    val wd=Input(UInt(width.W));val we=Input(Bool());val bypass=Input(Bool());val clear=Input(Bool())
    val qa=Output(UInt(width.W));val qb=Output(UInt(width.W))
    val rawA=Output(UInt(width.W));val rawB=Output(UInt(width.W))
    val forwardA=Output(Bool());val forwardB=Output(Bool())
  })
  val bank=RegInit(VecInit(Seq.fill(depth)(0.U(width.W))))
  when(io.clear){bank.foreach(_:=0.U)}.elsewhen(io.we && io.wa=/=0.U){bank(io.wa):=io.wd}
  val pending=io.we && !io.clear && !reset.asBool && io.wa=/=0.U
  val rawA=Mux(io.ra===0.U,0.U,bank(io.ra));val rawB=Mux(io.rb===0.U,0.U,bank(io.rb))
  val forwardA=io.bypass && pending && io.ra=/=0.U && io.ra===io.wa
  val forwardB=io.bypass && pending && io.rb=/=0.U && io.rb===io.wa
  io.rawA:=rawA;io.rawB:=rawB;io.forwardA:=forwardA;io.forwardB:=forwardB
  io.qa:=Mux(forwardA,io.wd,rawA);io.qb:=Mux(forwardB,io.wd,rawB)
}
class RegFile32 extends TeachingRegFile(32,32)
