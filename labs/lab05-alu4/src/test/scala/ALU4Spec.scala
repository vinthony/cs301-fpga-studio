package cs301
import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import scala.language.reflectiveCalls
class ALU4Spec extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "ALU4"
  it should "exhaust every operand and opcode including invalid codes" in {
    test(new ALU4).withAnnotations(Seq(WriteVcdAnnotation)){c=>
      for(a<-0 until 16;b<-0 until 16;op<-0 until 16){
        val sa=if(a>=8)a-16 else a;val sb=if(b>=8)b-16 else b;val k=b%4
        val wide=op match {
          case 0=>a+b;case 1=>a-b;case 2=>a&b;case 3=>a|b;case 4=>a^b
          case 5=>a*(1<<k);case 6=>a/(1<<k);case 7=>math.floor(sa.toDouble/(1<<k)).toInt
          case 8=>if(sa<sb)1 else 0;case 9=>if(a<b)1 else 0;case _=>0
        }
        val r=wide&15;val arith=op<2;val signedWide=if(op==0)sa+sb else sa-sb
        c.io.a.poke(a.U);c.io.b.poke(b.U);c.io.op.poke(op.U)
        c.io.result.expect(r.U);c.io.zero.expect((r==0).B);c.io.sign.expect((r>=8).B)
        c.io.operationValid.expect((op<10).B);c.io.flagsValid.expect(arith.B)
        c.io.carry.expect((if(op==0)a+b>=16 else if(op==1)a>=b else false).B)
        c.io.overflow.expect((arith&&(signedWide< -8||signedWide>7)).B)
        c.clock.step()
      }
    }
  }
}
