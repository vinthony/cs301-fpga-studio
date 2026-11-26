package cs301
import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import scala.language.reflectiveCalls
class AddersSpec extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "Adders"
  it should "exhaust all 512 four-bit operand and carry combinations" in {
    test(new CompareAdders4).withAnnotations(Seq(WriteVcdAnnotation)) { c =>
      for(a <- 0 until 16; b <- 0 until 16; cin <- 0 to 1) {
        c.io.a.poke(a.U); c.io.b.poke(b.U); c.io.cin.poke((cin==1).B)
        c.io.ripple.expect((a+b+cin).U); c.io.lookahead.expect((a+b+cin).U); c.io.equal.expect(true.B)
        var carries = cin
        for(bit <- 1 to 4) {
          val mask=(1<<bit)-1
          if ((a&mask)+(b&mask)+cin >= (1<<bit)) carries |= (1<<bit)
        }
        c.io.rippleCarries.expect(carries.U); c.io.lookaheadCarries.expect(carries.U)
        c.clock.step()
      }
    }
  }
  it should "support one and eight-bit ripple widths" in {
    for(width <- Seq(1,8)) test(new RippleAdder(width)) { c =>
      val limit=1<<width
      for(a <- Seq(0,1,limit/2,limit-1).distinct; b <- Seq(0,1,limit-1).distinct; cin <- 0 to 1) {
        c.io.a.poke(a.U); c.io.b.poke(b.U); c.io.cin.poke((cin==1).B)
        c.io.sum.expect(((a+b+cin)&(limit-1)).U);c.io.cout.expect((a+b+cin>=limit).B)
      }
    }
  }
}
