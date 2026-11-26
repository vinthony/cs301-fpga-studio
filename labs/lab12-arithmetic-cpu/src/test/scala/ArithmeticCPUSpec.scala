package cs301
import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import scala.language.reflectiveCalls
class ArithmeticCPUSpec extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "ArithmeticCPU"
  it should "retire arithmetic programs at edges pause and stop without committing faults" in {
    test(new ArithmeticCPU).withAnnotations(Seq(WriteVcdAnnotation)){c=>
      c.io.step.poke(false.B);c.io.clear.poke(false.B);c.io.instruction.poke(0.U);c.io.instructionValid.poke(true.B)
      c.reset.poke(true.B);c.clock.step();c.reset.poke(false.B)
      val program=Seq(0x00500093L,0x00700113L,0x002081b3L,0x40118233L,0x00100073L)
      val expected=Seq((1,5L),(2,7L),(3,12L),(4,7L))
      for(i<-0 until 4){
        c.io.instruction.poke(program(i).U);c.io.step.poke(false.B);c.clock.step(2)
        c.io.pc.expect((i*4).U);c.io.retired.expect(i.U);c.io.registers(expected(i)._1).expect(0.U)
        c.io.step.poke(true.B);c.clock.step();c.io.pc.expect(((i+1)*4).U);c.io.retired.expect((i+1).U);c.io.registers(expected(i)._1).expect(expected(i)._2.U)
      }
      c.io.instruction.poke(program(4).U);c.clock.step();c.io.halted.expect(true.B);c.io.reason.expect(1.U);c.io.pc.expect(16.U);c.io.retired.expect(4.U)
      c.io.instruction.poke("h7ff00093".U);c.clock.step(3);c.io.registers(1).expect(5.U);c.io.retired.expect(4.U)
      c.io.clear.poke(true.B);c.clock.step();c.io.clear.poke(false.B);c.io.pc.expect(0.U);c.io.retired.expect(0.U);c.io.halted.expect(false.B)
      for(i<-0 until 32)c.io.registers(i).expect(0.U)
      c.io.instruction.poke("h00002083".U);c.clock.step();c.io.reason.expect(2.U);c.io.retired.expect(0.U);c.io.registers(1).expect(0.U)
    }
  }
  it should "reject missing fetches and discard x0 writes while retiring legal instructions" in {
    test(new ArithmeticCPU){c=>
      c.io.step.poke(false.B);c.io.clear.poke(false.B);c.io.instructionValid.poke(true.B);c.io.instruction.poke(0.U);c.reset.poke(true.B);c.clock.step();c.reset.poke(false.B)
      c.io.instruction.poke("hfff00013".U);c.io.step.poke(true.B);c.clock.step();c.io.registers(0).expect(0.U);c.io.retired.expect(1.U)
      c.io.instructionValid.poke(false.B);c.clock.step();c.io.reason.expect(3.U);c.io.pc.expect(4.U);c.io.retired.expect(1.U)
    }
  }
}
