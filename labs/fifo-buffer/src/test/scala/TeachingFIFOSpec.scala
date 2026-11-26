package cs301
import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import scala.collection.mutable.ArrayBuffer
import scala.language.reflectiveCalls
class TeachingFIFOSpec extends AnyFlatSpec with ChiselScalatestTester {
 behavior of "TeachingFIFO"
 it should "preserve queue order and simultaneous boundaries" in {
  test(new TeachingFIFO).withAnnotations(Seq(WriteVcdAnnotation)){c=>
   val queue=ArrayBuffer.empty[Int];val memory=Array.fill(4)(0);var rp=0;var wp=0
   c.io.step.poke(false.B);c.io.clear.poke(false.B);c.io.push.poke(false.B);c.io.pop.poke(false.B);c.io.data.poke(0.U);c.reset.poke(true.B);c.clock.step();c.reset.poke(false.B)
   def check():Unit={c.io.count.expect(queue.length.U);c.io.readPointer.expect(rp.U);c.io.writePointer.expect(wp.U);c.io.empty.expect(queue.isEmpty.B);c.io.full.expect((queue.length==4).B);c.io.valid.expect(queue.nonEmpty.B);c.io.head.expect(queue.headOption.getOrElse(0).U);for(i<-0 until 4)c.io.saved(i).expect(memory(i).U)}
   def edge(push:Boolean,pop:Boolean,data:Int,step:Boolean=true,clear:Boolean=false):Unit={
    c.io.push.poke(push.B);c.io.pop.poke(pop.B);c.io.data.poke(data.U);c.io.step.poke(step.B);c.io.clear.poke(clear.B)
    val takePop=step && !clear && pop && queue.nonEmpty
    val takePush=step && !clear && push && (queue.length<4 || takePop)
    c.io.popAccepted.expect(takePop.B);c.io.pushAccepted.expect(takePush.B);check();c.clock.step()
    if(clear){queue.clear();java.util.Arrays.fill(memory,0);rp=0;wp=0}
    else{if(takePop){queue.remove(0);rp=(rp+1)%4};if(takePush){queue+=data;memory(wp)=data;wp=(wp+1)%4}}
    check()
   }
   edge(true,true,11);for(v<-Seq(22,33,44))edge(true,false,v);edge(true,false,99);edge(true,true,55);for(i<-0 until 5)edge(false,true,0)
   edge(true,true,77,step=false);edge(true,true,88,step=false,clear=true)
   val rng=new scala.util.Random(301);for(i<-0 until 4096)edge(rng.nextBoolean(),rng.nextBoolean(),rng.nextInt(256),step=i%5!=0,clear=i%113==0)
  }
 }
 it should "support a different power of two depth" in {
  test(new TeachingFIFO(depth=8,width=4)){c=>
   c.io.clear.poke(true.B);c.io.step.poke(false.B);c.io.push.poke(false.B);c.io.pop.poke(false.B);c.io.data.poke(0.U);c.clock.step();c.io.clear.poke(false.B);c.io.step.poke(true.B);c.io.push.poke(true.B)
   for(i<-0 until 8){c.io.data.poke(i.U);c.clock.step()};c.io.full.expect(true.B);c.io.push.poke(false.B);c.io.pop.poke(true.B)
   for(i<-0 until 8){c.io.head.expect(i.U);c.clock.step()};c.io.empty.expect(true.B)
  }
 }
}
