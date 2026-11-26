package cs301
import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import scala.language.reflectiveCalls

class Representation4Spec extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "Representation4"
  it should "interpret all sixteen patterns before a clock edge and preserve negative zero flags" in {
    test(new Representation4).withAnnotations(Seq(WriteVcdAnnotation)) { c =>
      val sm = Seq(0,1,2,3,4,5,6,7,0,-1,-2,-3,-4,-5,-6,-7)
      val oc = Seq(0,1,2,3,4,5,6,7,-7,-6,-5,-4,-3,-2,-1,0)
      val tc = Seq(0,1,2,3,4,5,6,7,-8,-7,-6,-5,-4,-3,-2,-1)
      for (word <- 0 until 16) {
        c.io.bits.poke(word.U)
        c.io.unsigned.expect(word.U)
        c.io.signMagnitude.expect(sm(word).S)
        c.io.signMagnitudeNegativeZero.expect((word == 8).B)
        c.io.onesComplement.expect(oc(word).S)
        c.io.onesComplementNegativeZero.expect((word == 15).B)
        c.io.twosComplement.expect(tc(word).S)
        // Only advances the waveform; the expectations above precede this edge.
        c.clock.step()
      }
    }
  }
}
