package cs301
import chisel3._
import chisel3.util._
import scala.language.reflectiveCalls
/** Raw slices only. rdSlice/rs slices do NOT imply that the instruction uses them. */
class InstructionFields extends Module {
  val io=IO(new Bundle {
    val instruction=Input(UInt(32.W))
    val opcode=Output(UInt(7.W));val rdSlice=Output(UInt(5.W));val funct3Slice=Output(UInt(3.W))
    val rs1Slice=Output(UInt(5.W));val rs2Slice=Output(UInt(5.W));val funct7Slice=Output(UInt(7.W))
    // opcode-only classroom format: 0 unknown, 1 R, 2 I, 3 S, 4 B, 5 U, 6 J.
    // This is not instruction legality or control decoding.
    val format=Output(UInt(3.W))
  })
  io.opcode:=io.instruction(6,0);io.rdSlice:=io.instruction(11,7);io.funct3Slice:=io.instruction(14,12)
  io.rs1Slice:=io.instruction(19,15);io.rs2Slice:=io.instruction(24,20);io.funct7Slice:=io.instruction(31,25)
  io.format:=0.U
  switch(io.instruction(6,0)) {
    is("h33".U){io.format:=1.U}
    is("h13".U,"h03".U,"h67".U){io.format:=2.U}
    is("h23".U){io.format:=3.U}
    is("h63".U){io.format:=4.U}
    is("h37".U,"h17".U){io.format:=5.U}
    is("h6f".U){io.format:=6.U}
  }
}
