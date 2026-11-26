package cs301
import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import scala.language.reflectiveCalls
class BaudUARTTXSpec extends AnyFlatSpec with ChiselScalatestTester {
 behavior of "BaudUARTTX"
 def frame(c:BaudUARTTX,div:Int,byte:Int):Unit={
  c.clock.setTimeout(30000)
  c.io.clear.poke(true.B);c.io.enable.poke(false.B);c.io.send.poke(true.B);c.io.data.poke(byte.U);c.clock.step();c.io.clear.poke(false.B);c.io.enable.poke(true.B)
  c.clock.step(div-1);c.io.count.expect((div-1).U);c.io.phase.expect(15.U);c.io.tick.expect(true.B);c.io.accepted.expect(true.B)
  c.clock.step();c.io.count.expect(0.U);c.io.phase.expect(0.U);c.io.tx.expect(false.B);c.io.captured.expect(byte.U);c.io.send.poke(false.B);c.io.data.poke((255-byte).U)
  for(bit<-0 until 8){c.clock.step(div-1);c.io.phase.expect(bit.U);c.io.tick.expect(true.B);c.clock.step();c.io.tx.expect((((byte>>bit)&1)==1).B);c.io.captured.expect(byte.U)}
  c.clock.step(div);c.io.phase.expect(9.U);c.io.tx.expect(true.B);c.io.done.expect(false.B)
  c.clock.step(div-1);c.io.phase.expect(9.U);c.io.busy.expect(true.B);c.clock.step();c.io.phase.expect(15.U);c.io.done.expect(true.B)
  c.io.enable.poke(false.B);c.clock.step(3);c.io.count.expect(0.U);c.io.done.expect(true.B)
  c.io.clear.poke(true.B);c.clock.step();c.io.captured.expect(0.U);c.io.done.expect(false.B);c.io.phase.expect(15.U)
 }
 it should "use 868 primary clocks per ideal bit" in {
  test(new BaudUARTTX).withAnnotations(Seq(WriteVcdAnnotation)){c=>for(byte<-Seq(65,85))frame(c,868,byte)}
 }
 it should "send all bytes with a short divisor" in {
  test(new BaudUARTTX(7)){c=>for(byte<-0 until 256)frame(c,7,byte)}
 }
}
