package cs301
import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import scala.language.reflectiveCalls
class ButtonLedsSpec extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "ButtonLeds"
  it should "map all sixteen core input patterns without clock edges" in {
    test(new ButtonLeds){c=>
      for(mask<-0 until 16){c.io.buttons.poke(mask.U);c.io.leds.expect(mask.U)}
    }
  }
  it should "adapt all five-button patterns and blank every display output" in {
    test(new TeachingButtonTop).withAnnotations(Seq(WriteVcdAnnotation)){c=>
      for(mask<-0 until 32;sw<-Seq(0,0x35,0xffff)){
        c.io.buttons.poke(mask.U);c.io.switches.poke(sw.U)
        c.io.leds.expect((mask&15).U)
        c.io.seg.expect(127.U);c.io.an.expect(15.U);c.io.dp.expect(true.B)
        // Visualization time only: assertions precede this edge.
        c.clock.step()
      }
    }
  }
}
