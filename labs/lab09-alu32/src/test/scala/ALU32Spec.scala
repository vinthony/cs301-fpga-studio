package cs301
import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import scala.language.reflectiveCalls
class ALU32Spec extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "ALU32"
  it should "check signed boundaries shifts and invalid operations against wide integer arithmetic" in {
    test(new ALU32).withAnnotations(Seq(WriteVcdAnnotation)){c=>
      val mask=(BigInt(1)<<32)-1;val min= -(BigInt(1)<<31);val max=(BigInt(1)<<31)-1
      val edge=Seq[BigInt](0,1,2,31,32,33,BigInt("7fffffff",16),BigInt("80000000",16),mask,BigInt("aaaaaaaa",16),BigInt("55555555",16))
      val random=new scala.util.Random(301)
      val pairs=edge.flatMap(a=>edge.map(b=>(a,b)))++Seq.fill(1024)((BigInt(random.nextLong())&mask,BigInt(random.nextLong())&mask))
      for((a,b)<-pairs;op<-0 until 16){
        val sa=if(a.testBit(31))a-(BigInt(1)<<32) else a;val sb=if(b.testBit(31))b-(BigInt(1)<<32) else b;val k=(b%32).toInt
        val raw:BigInt=op match {
          case 0=>a+b;case 1=>a-b;case 2=>a&b;case 3=>a|b;case 4=>a^b;case 5=>a<<k;case 6=>a>>k;case 7=>sa>>k
          case 8=>if(sa<sb)BigInt(1) else BigInt(0);case 9=>if(a<b)BigInt(1) else BigInt(0);case _=>BigInt(0)
        }
        val r=raw&mask;val arith=op<2;val exact=if(op==0)sa+sb else sa-sb
        c.io.a.poke(a.U);c.io.b.poke(b.U);c.io.op.poke(op.U)
        c.io.result.expect(r.U);c.io.zero.expect((r==0).B);c.io.sign.expect(r.testBit(31).B)
        c.io.carry.expect((if(op==0)a+b>mask else if(op==1)a>=b else false).B)
        c.io.overflow.expect((arith&&(exact<min||exact>max)).B)
        c.io.flagsValid.expect(arith.B);c.io.operationValid.expect((op<10).B);c.clock.step()
      }
    }
  }
  it should "retain the same contract when parameterized to four bits" in {
    test(new TeachingALU(4)){c=>
      c.io.a.poke(8.U);c.io.b.poke(1.U);c.io.op.poke(7.U);c.io.result.expect(12.U)
      c.io.op.poke(8.U);c.io.result.expect(1.U);c.io.op.poke(9.U);c.io.result.expect(0.U)
    }
  }
}
