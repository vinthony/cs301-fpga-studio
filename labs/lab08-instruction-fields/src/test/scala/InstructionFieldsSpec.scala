package cs301
import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import scala.language.reflectiveCalls
class InstructionFieldsSpec extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "InstructionFields"
  it should "extract raw slices from instruction examples and deterministic bit patterns" in {
    test(new InstructionFields).withAnnotations(Seq(WriteVcdAnnotation)){c=>
      val fixtures=Seq(
        (0x002081b3L,0x33,3,0,1,2,0,1), // add x3,x1,x2
        (0xffc10093L,0x13,1,0,2,28,127,2), // addi x1,x2,-4: rs2Slice is immediate bits
        (0x00812083L,0x03,1,2,2,8,0,2),
        (0x00112623L,0x23,12,2,2,1,0,3), // rdSlice is immediate, not a destination
        (0x00208463L,0x63,8,0,1,2,0,4),
        (0x00c000efL,0x6f,1,0,0,12,0,6),
        (0x123451b7L,0x37,3,5,8,3,9,5))
      for((word,op,rd,f3,r1,r2,f7,fmt)<-fixtures){
        c.io.instruction.poke(word.U);c.io.opcode.expect(op.U);c.io.rdSlice.expect(rd.U)
        c.io.funct3Slice.expect(f3.U);c.io.rs1Slice.expect(r1.U);c.io.rs2Slice.expect(r2.U);c.io.funct7Slice.expect(f7.U);c.io.format.expect(fmt.U)
      }
      val random=new scala.util.Random(301)
      val words=Seq(0L,0xffffffffL)++(0 until 32).map(i=>1L<<i)++Seq.fill(4096)(random.nextLong()&0xffffffffL)
      val formats=Map(0x33->1,0x13->2,0x03->2,0x67->2,0x23->3,0x63->4,0x37->5,0x17->5,0x6f->6)
      for(word<-words){
        c.io.instruction.poke(word.U)
        c.io.opcode.expect((word%128).U);c.io.rdSlice.expect(((word/128)%32).U)
        c.io.funct3Slice.expect(((word/4096)%8).U);c.io.rs1Slice.expect(((word/32768)%32).U)
        c.io.rs2Slice.expect(((word/1048576)%32).U);c.io.funct7Slice.expect((word/33554432).U)
        c.io.format.expect(formats.getOrElse((word%128).toInt,0).U);c.clock.step()
      }
    }
  }
}
