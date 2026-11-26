package cs301
import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import scala.language.reflectiveCalls
class UARTBitRXSpec extends AnyFlatSpec with ChiselScalatestTester {
 behavior of "UARTBitRX"
 it should "check every byte and both stop levels" in {
  test(new UARTBitRX).withAnnotations(Seq(WriteVcdAnnotation)){c=>
   c.io.step.poke(false.B);c.io.rx.poke(true.B);c.io.clear.poke(true.B);c.clock.step();c.io.clear.poke(false.B)
   for(stop<-Seq(false,true);byte<-0 until 256){
    c.io.clear.poke(true.B);c.io.step.poke(false.B);c.clock.step();c.io.clear.poke(false.B)
    c.io.step.poke(true.B);c.io.rx.poke(false.B);c.clock.step();c.io.phase.expect(0.U);c.io.data.expect(0.U)
    for(bit<-0 until 8){c.io.rx.poke((((byte>>bit)&1)==1).B);c.clock.step();c.io.phase.expect((bit+1).U);c.io.data.expect((byte&((1<<(bit+1))-1)).U);c.io.valid.expect(false.B)}
    c.io.rx.poke(stop.B);c.clock.step();c.io.phase.expect(15.U);c.io.valid.expect(stop.B);c.io.error.expect((!stop).B);c.io.data.expect(byte.U)
    c.io.step.poke(false.B);c.io.rx.poke((!stop).B);c.clock.step(2);c.io.valid.expect(stop.B);c.io.error.expect((!stop).B)
    c.io.step.poke(true.B);c.io.rx.poke(true.B);c.clock.step();c.io.valid.expect(false.B);c.io.error.expect(false.B)
   }
  }
 }
 it should "ignore idle high and clear incomplete data while paused" in {
  test(new UARTBitRX){c=>
   c.io.step.poke(true.B);c.io.clear.poke(true.B);c.io.rx.poke(true.B);c.clock.step();c.io.clear.poke(false.B);c.clock.step(4);c.io.busy.expect(false.B)
   c.io.rx.poke(false.B);c.clock.step();c.io.rx.poke(true.B);c.clock.step(3);c.io.data.expect(7.U)
   c.io.clear.poke(true.B);c.io.step.poke(false.B);c.clock.step();c.io.data.expect(0.U);c.io.busy.expect(false.B);c.io.valid.expect(false.B);c.io.error.expect(false.B)
  }
 }
}
