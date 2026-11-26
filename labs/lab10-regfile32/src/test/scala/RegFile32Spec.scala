package cs301
import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import scala.language.reflectiveCalls
class RegFile32Spec extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "RegFile32"
  it should "separate saved values bypass values and synchronous writes in a stateful stream" in {
    test(new RegFile32).withAnnotations(Seq(WriteVcdAnnotation)){c=>
      val bank=Array.fill[BigInt](32)(0);val random=new scala.util.Random(301);val mask=(BigInt(1)<<32)-1
      c.io.ra.poke(0.U);c.io.rb.poke(0.U);c.io.wa.poke(0.U);c.io.wd.poke(0.U);c.io.we.poke(false.B);c.io.bypass.poke(false.B);c.io.clear.poke(false.B)
      c.reset.poke(true.B);c.clock.step();c.reset.poke(false.B)
      for(i<-0 until 2048){
        val wa=if(i<32)i else random.nextInt(32);val ra=if(i%3==0)wa else random.nextInt(32);val rb=if(i%5==0)wa else random.nextInt(32)
        val wd=if(i%11==0)mask else BigInt(random.nextLong())&mask
        val we=i<32||random.nextBoolean();val bypass=random.nextBoolean();val clear=i>0&&i%97==0;val reset=i>0&&i%193==0
        c.io.ra.poke(ra.U);c.io.rb.poke(rb.U);c.io.wa.poke(wa.U);c.io.wd.poke(wd.U);c.io.we.poke(we.B);c.io.bypass.poke(bypass.B);c.io.clear.poke(clear.B);c.reset.poke(reset.B)
        def check():Unit={
          val fa=ra!=0&&wa==ra&&bypass&&we && !clear && !reset
          val fb=rb!=0&&wa==rb&&bypass&&we && !clear && !reset
          c.io.rawA.expect(bank(ra).U);c.io.rawB.expect(bank(rb).U)
          c.io.qa.expect((if(fa)wd else bank(ra)).U);c.io.qb.expect((if(fb)wd else bank(rb)).U)
          c.io.forwardA.expect(fa.B);c.io.forwardB.expect(fb.B)
        }
        check();c.clock.step()
        if(reset||clear)for(address<-bank.indices)bank(address)=BigInt(0)
        else if(we&&wa!=0)bank(wa)=wd
        bank(0)=0;check()
      }
    }
  }
  it should "read every address pair independently and never write or bypass x0" in {
    test(new RegFile32){c=>
      c.io.bypass.poke(false.B);c.io.clear.poke(false.B);c.io.ra.poke(0.U);c.io.rb.poke(0.U);c.io.wd.poke(0.U);c.io.wa.poke(0.U);c.io.we.poke(false.B)
      c.reset.poke(true.B);c.clock.step();c.reset.poke(false.B)
      for(address<-0 until 32){c.io.wa.poke(address.U);c.io.wd.poke((0x1000L+address).U);c.io.we.poke(true.B);c.clock.step()}
      c.io.we.poke(false.B)
      for(a<-0 until 32;b<-0 until 32){c.io.ra.poke(a.U);c.io.rb.poke(b.U);c.io.qa.expect((if(a==0)0L else 0x1000L+a).U);c.io.qb.expect((if(b==0)0L else 0x1000L+b).U)}
      c.io.we.poke(true.B);c.io.bypass.poke(true.B);c.io.wa.poke(0.U);c.io.wd.poke("hffffffff".U);c.io.ra.poke(0.U);c.io.rb.poke(0.U)
      c.io.qa.expect(0.U);c.io.qb.expect(0.U);c.io.forwardA.expect(false.B);c.clock.step();c.io.qa.expect(0.U)
    }
  }
}
