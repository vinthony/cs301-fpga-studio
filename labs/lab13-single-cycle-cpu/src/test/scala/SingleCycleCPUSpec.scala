package cs301
import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import scala.language.reflectiveCalls
class SingleCycleCPUSpec extends AnyFlatSpec with ChiselScalatestTester {
 behavior of "SingleCycleCPU"
 def initialize(c:SingleCycleCPU):Unit={
  c.io.step.poke(false.B);c.io.clear.poke(false.B);c.io.instruction.poke(0.U);c.io.instructionValid.poke(false.B)
  c.io.switches.poke(0x35.U);c.io.buttons.poke(21.U);c.reset.poke(true.B);c.clock.step();c.reset.poke(false.B)
 }
 def run(c:SingleCycleCPU,program:Seq[Long]):Unit={
  var attempts=0
  while(!c.io.halted.peek().litToBoolean && attempts<100){
   val pc=c.io.pc.peek().litValue.toInt;val valid=pc%4==0 && pc/4<program.size
   c.io.instruction.poke((if(valid)program(pc/4)else 0L).U);c.io.instructionValid.poke(valid.B)
   c.io.step.poke(false.B);c.clock.step(2);c.io.pc.expect(pc.U)
   c.io.step.poke(true.B);c.clock.step();attempts+=1
  }
  assert(attempts<100);c.io.halted.expect(true.B)
 }
 it should "execute a loop with store load and precise breakpoint" in {
  test(new SingleCycleCPU).withAnnotations(Seq(WriteVcdAnnotation)){c=>
   initialize(c);run(c,Seq(5243027L,403L,1147315L,4293951635L,4261453027L,3153955L,8707L,1048691L))
   c.io.pc.expect(28.U);c.io.retired.expect(19.U);c.io.reason.expect(1.U)
   c.io.registers(3).expect(15.U);c.io.registers(4).expect(15.U);c.io.memory(0).expect(15.U)
   c.io.instruction.poke(0x7ff00193L.U);c.io.instructionValid.poke(true.B);c.clock.step(3);c.io.registers(3).expect(15.U);c.io.pc.expect(28.U)
   c.io.step.poke(false.B);c.io.clear.poke(true.B);c.clock.step();c.io.halted.expect(false.B);c.io.pc.expect(0.U);c.io.retired.expect(0.U);c.io.memory(0).expect(0.U)
  }
 }
 it should "extend byte halfword loads and retain little endian boundary bytes" in {
  test(new SingleCycleCPU){c=>initialize(c);run(c,Seq(4293918867L,235933603L,267403523L,267387267L,235937571L,266359299L,266343043L,235941411L,264250115L,1048691L))
   c.io.registers(2).expect(255.U);c.io.registers(3).expect("hffffffff".U);c.io.registers(4).expect(65535.U);c.io.registers(5).expect("hffffffff".U);c.io.registers(6).expect("hffffffff".U)
   for(i<-252 until 256)c.io.memory(i).expect(255.U)
  }
 }
 it should "read external pins and commit teaching MMIO outputs" in {
  test(new SingleCycleCPU){c=>initialize(c);run(c,Seq(4294901943L,41219L,2138659L,12624259L,3187747L,4235779L,8430211L,1048691L))
   c.io.led.expect(0x35.U);c.io.display.expect(21.U);c.io.registers(4).expect(0x35.U);c.io.registers(5).expect(21.U)
  }
 }
 it should "stop faulting stores before any architectural write" in {
  test(new SingleCycleCPU){c=>initialize(c);run(c,Seq(0xfff00093L,0x001020a3L))
   c.io.reason.expect(6.U);c.io.faultValue.expect(1.U);c.io.pc.expect(4.U);c.io.retired.expect(1.U)
   for(i<-0 until 256)c.io.memory(i).expect(0.U)
  }
 }
}
