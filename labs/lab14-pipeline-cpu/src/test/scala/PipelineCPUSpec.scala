package cs301
import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import scala.language.reflectiveCalls
class PipelineCPUSpec extends AnyFlatSpec with ChiselScalatestTester {
 behavior of "PipelineCPU"
 def initialize(c:PipelineCPU,mode:Int):Unit={
  c.io.step.poke(false.B);c.io.clear.poke(false.B);c.io.mode.poke(mode.U)
  c.io.instruction.poke(0.U);c.io.instructionValid.poke(false.B);c.io.switches.poke(0x35.U);c.io.buttons.poke(21.U)
  c.reset.poke(true.B);c.clock.step();c.reset.poke(false.B)
 }
 def run(c:PipelineCPU,program:Seq[Long]):Unit={
  var attempts=0
  while(!c.io.halted.peek().litToBoolean&&attempts<300){
   val pc=c.io.fetchPC.peek().litValue;val valid=pc%4==0&&pc/4<program.size
   c.io.instruction.poke((if(valid)BigInt(program((pc/4).toInt))else BigInt(0)).U);c.io.instructionValid.poke(valid.B)
   if(!c.io.stageValid(1).peek().litToBoolean){c.io.forwardA.expect(0.U);c.io.forwardB.expect(0.U)}
   val cycles=c.io.cycles.peek().litValue;c.io.step.poke(false.B);c.clock.step();c.io.cycles.expect(cycles.U);c.io.fetchPC.expect(pc.U)
   c.io.step.poke(true.B);c.clock.step();attempts+=1
  }
  assert(attempts<300,"pipeline did not reach precise stop");c.io.halted.expect(true.B)
 }
 val chain=Seq(0x00500093L,0x00108133L,0x001101b3L,0x00100073L)
 it should "forward dependent arithmetic through a real five stage pipeline" in {
  test(new PipelineCPU).withAnnotations(Seq(WriteVcdAnnotation)){c=>
   initialize(c,2);run(c,chain);c.io.registers(1).expect(5.U);c.io.registers(2).expect(10.U);c.io.registers(3).expect(15.U)
   c.io.reason.expect(1.U);c.io.pc.expect(12.U);c.io.retired.expect(3.U);c.io.stalls.expect(0.U)
   val cycles=c.io.cycles.peek().litValue;c.clock.step(2);c.io.cycles.expect(cycles.U)
   c.io.step.poke(false.B);c.io.clear.poke(true.B);c.clock.step();c.io.retired.expect(0.U);c.io.fetchPC.expect(0.U);c.io.registers(3).expect(0.U)
  }
  PipelineEvidence.recordElaboration("test_run_dir/PipelineCPU_should_forward_dependent_arithmetic_through_a_real_five_stage_pipeline/PipelineCPU.lo.fir")
 }
 it should "demonstrate wrong results with repair disabled and fix them by stalling" in {
  test(new PipelineCPU){c=>initialize(c,0);run(c,chain);c.io.registers(3).expect(0.U)}
  test(new PipelineCPU){c=>initialize(c,1);run(c,chain);c.io.registers(3).expect(15.U);assert(c.io.stalls.peek().litValue>0)}
 }
 it should "forward store data and insert one load use bubble" in {
  test(new PipelineCPU){c=>initialize(c,2);run(c,Seq(0x00900093L,0x00102023L,0x00002103L,0x001101b3L,0x00100073L))
   c.io.memory(0).expect(9.U);c.io.registers(2).expect(9.U);c.io.registers(3).expect(18.U);c.io.stalls.expect(1.U);c.io.retired.expect(4.U)
  }
 }
 it should "flush a younger store when an EX branch redirects" in {
  test(new PipelineCPU){c=>initialize(c,2);run(c,Seq(0x00700093L,0x00000463L,0x00102023L,0x00300113L,0x00100073L))
   c.io.memory(0).expect(0.U);c.io.registers(2).expect(3.U);c.io.redirects.expect(1.U);c.io.retired.expect(3.U);c.io.pc.expect(16.U)
  }
 }
 it should "drain older work and suppress younger writes on a MEM fault" in {
  test(new PipelineCPU){c=>initialize(c,2);run(c,Seq(0x00700093L,0x00102103L,0x00102023L,0x06300193L,0x00100073L))
   c.io.reason.expect(5.U);c.io.faultValue.expect(1.U);c.io.pc.expect(4.U);c.io.retired.expect(1.U)
   c.io.registers(1).expect(7.U);c.io.registers(3).expect(0.U);for(i<-0 until 256)c.io.memory(i).expect(0.U)
  }
 }
 it should "run the Lab13 branch loop with identical architectural results" in {
  test(new PipelineCPU){c=>initialize(c,2);run(c,Seq(5243027L,403L,1147315L,4293951635L,4261453027L,3153955L,8707L,1048691L))
   c.io.pc.expect(28.U);c.io.retired.expect(19.U);c.io.reason.expect(1.U);c.io.registers(3).expect(15.U);c.io.registers(4).expect(15.U);c.io.memory(0).expect(15.U)
  }
 }
}
