package cs301
import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec

class Sequence1011Spec extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "Sequence1011"
  it should "match every twelve-bit stream with overlap against a string oracle" in {
    test(new Sequence1011) { c =>
      c.io.enable.poke(true.B)
      for (word <- 0 until 4096) {
        c.reset.poke(true.B); c.io.bitIn.poke(false.B); c.clock.step()
        c.io.state.expect(0.U); c.io.hit.expect(false.B); c.io.count.expect(0.U)
        c.reset.poke(false.B)
        var history = ""; var count = 0
        for (bit <- word.toBinaryString.reverse.padTo(12, '0').reverse) {
          c.io.bitIn.poke((bit == '1').B)
          c.io.count.expect(count.U) // changing the input must not commit
          history += bit
          val matched = history.endsWith("1011")
          c.io.candidate.expect(matched.B)
          val prefix = (0 to 3).filter(k => history.endsWith("1011".take(k))).max
          c.io.nextState.expect(prefix.U)
          c.clock.step()
          if (matched) count += 1
          c.io.state.expect(prefix.U); c.io.hit.expect(matched.B); c.io.count.expect(count.U)
        }
      }
    }
  }
  it should "hold on disabled clocks and reset synchronously with priority" in {
    test(new Sequence1011).withAnnotations(Seq(WriteVcdAnnotation)) { c =>
      c.io.enable.poke(true.B); c.reset.poke(true.B); c.clock.step(); c.reset.poke(false.B)
      for (bit <- "1011011") { c.io.bitIn.poke((bit == '1').B); c.clock.step() }
      c.io.count.expect(2.U); c.io.state.expect(1.U); c.io.hit.expect(true.B)
      c.io.enable.poke(false.B); c.io.bitIn.poke(false.B); c.clock.step(3)
      c.io.count.expect(2.U); c.io.state.expect(1.U); c.io.hit.expect(true.B)
      c.reset.poke(true.B); c.io.count.expect(2.U) // no clock yet
      c.clock.step(); c.io.count.expect(0.U); c.io.state.expect(0.U); c.io.hit.expect(false.B)
    }
  }
}
