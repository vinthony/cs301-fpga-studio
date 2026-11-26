package cs301
import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import scala.language.reflectiveCalls
class UARTBitTXSpec extends AnyFlatSpec with ChiselScalatestTester {
 behavior of "UARTBitTX"
 it should "send all bytes without changing an active frame" in {
  test(new UARTBitTX).withAnnotations(Seq(WriteVcdAnnotation)){c=>
   c.io.step.poke(false.B);c.io.clear.poke(true.B);c.io.send.poke(false.B);c.io.data.poke(0.U);c.clock.step();c.io.clear.poke(false.B)
   for(byte<-0 until 256){
    c.io.data.poke(byte.U);c.io.send.poke(true.B);c.io.step.poke(true.B);c.io.accepted.expect(true.B);c.clock.step()
    c.io.tx.expect(false.B);c.io.phase.expect(0.U);c.io.busy.expect(true.B);c.io.captured.expect(byte.U)
    for(bit<-0 until 8){c.io.data.poke((255-byte).U);c.io.accepted.expect(false.B);c.clock.step();c.io.tx.expect((((byte>>bit)&1)==1).B);c.io.captured.expect(byte.U)}
    c.clock.step();c.io.phase.expect(9.U);c.io.tx.expect(true.B);c.io.busy.expect(true.B);c.io.done.expect(false.B)
    c.io.step.poke(false.B);c.clock.step(2);c.io.phase.expect(9.U);c.io.done.expect(false.B)
    c.io.step.poke(true.B);c.clock.step();c.io.busy.expect(false.B);c.io.tx.expect(true.B);c.io.done.expect(true.B)
    c.io.step.poke(false.B);c.clock.step();c.io.done.expect(true.B)
   }
  }
 }
 it should "clear while paused and refuse unrequested starts" in {
  test(new UARTBitTX){c=>
   c.io.clear.poke(true.B);c.io.step.poke(false.B);c.io.send.poke(true.B);c.io.data.poke(65.U);c.clock.step();c.io.clear.poke(false.B);c.io.send.poke(false.B);c.io.step.poke(true.B);c.clock.step(3);c.io.busy.expect(false.B)
   c.io.send.poke(true.B);c.clock.step();c.io.busy.expect(true.B);c.io.step.poke(false.B);c.io.clear.poke(true.B);c.io.accepted.expect(false.B);c.clock.step();c.io.busy.expect(false.B);c.io.captured.expect(0.U);c.io.done.expect(false.B)
  }
 }
}
