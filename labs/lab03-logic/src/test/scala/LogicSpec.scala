package cs301
import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import scala.language.reflectiveCalls
class LogicSpec extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "LogicTop"
  it should "exhaust all inputs and check gate tables selection and comparison" in {
    test(new LogicTop).withAnnotations(Seq(WriteVcdAnnotation)){c=>
      // Independently enumerated gate output words for A0/B0 = 00,01,10,11.
      val truth=Seq(52,30,26,3)
      for(a<-0 until 16;b<-0 until 16;sel<-0 to 1){
        c.io.a.poke(a.U);c.io.b.poke(b.U);c.io.select.poke((sel==1).B)
        c.io.gates.expect(truth(((a&1)<<1)|(b&1)).U)
        c.io.selected.expect(((if(sel==1)b else a)&1).B)
        c.io.lt.expect((a<b).B);c.io.eq.expect((a==b).B);c.io.gt.expect((a>b).B)
        c.clock.step()
      }
    }
  }
}
