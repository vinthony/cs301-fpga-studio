package cs301
import chisel3._
import chisel3.util._
import scala.language.reflectiveCalls
class Immediate32 extends Module {
  val io=IO(new Bundle {val instruction=Input(UInt(32.W));val format=Input(UInt(3.W));val immediate=Output(UInt(32.W))})
  val i=io.instruction;io.immediate:=0.U
  switch(io.format){
    is(0.U){io.immediate:=Cat(Fill(20,i(31)),i(31,20))}
    is(1.U){io.immediate:=Cat(Fill(20,i(31)),i(31,25),i(11,7))}
    is(2.U){io.immediate:=Cat(Fill(19,i(31)),i(31),i(7),i(30,25),i(11,8),0.U(1.W))}
    is(3.U){io.immediate:=Cat(i(31,12),0.U(12.W))}
    is(4.U){io.immediate:=Cat(Fill(11,i(31)),i(31),i(19,12),i(20),i(30,21),0.U(1.W))}
  }
}
class Decoder32 extends Module {
  val io=IO(new Bundle {
    val instruction=Input(UInt(32.W))
    val id=Output(UInt(6.W));val format=Output(UInt(3.W));val alu=Output(UInt(4.W))
    val loadUnsigned=Output(Bool());val shiftImmediate=Output(Bool());val control=Output(UInt(16.W))
    val opcode=Output(UInt(7.W));val rd=Output(UInt(5.W));val rs1=Output(UInt(5.W));val rs2=Output(UInt(5.W))
    val funct3=Output(UInt(3.W));val funct7=Output(UInt(7.W));val immediate=Output(UInt(32.W))
    val valid=Output(Bool());val effectiveRegWrite=Output(Bool());val branchKind=Output(UInt(3.W));val trapKind=Output(UInt(2.W))
  })
  io.id:=63.U;io.format:=7.U;io.alu:=0.U;io.loadUnsigned:=false.B;io.shiftImmediate:=false.B;io.control:=0.U
  for(row<-DecoderTable.rows){
    when((io.instruction & BigInt(row.mask,16).U(32.W))===BigInt(row.pattern,16).U(32.W)){
      io.id:=row.id.U;io.format:=row.fmt.U;io.alu:=row.alu.U
      io.loadUnsigned:=row.unsigned.B;io.shiftImmediate:=row.shift.B;io.control:=BigInt(row.control,16).U(16.W)
    }
  }
  io.opcode:=io.instruction(6,0);io.rd:=io.instruction(11,7);io.rs1:=io.instruction(19,15);io.rs2:=io.instruction(24,20)
  io.funct3:=io.instruction(14,12);io.funct7:=io.instruction(31,25)
  val imm=Module(new Immediate32);imm.io.instruction:=io.instruction
  imm.io.format:=Mux(io.format>=1.U && io.format<=5.U,io.format-1.U,7.U)
  io.immediate:=imm.io.immediate;io.valid:=io.control(0)
  io.effectiveRegWrite:=io.control(3) && io.rd=/=0.U
  io.branchKind:=Mux(io.control(6),io.instruction(14,12),0.U)
  io.trapKind:=Mux(io.id===38.U,1.U,Mux(io.id===39.U,2.U,0.U))
}
