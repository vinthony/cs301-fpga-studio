package cs301
import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import scala.language.reflectiveCalls
class InputConditionerSpec extends AnyFlatSpec with ChiselScalatestTester {
 behavior of "InputConditioner"
 it should "match staged sampling and pause clear priority" in {
  test(new InputConditioner).withAnnotations(Seq(WriteVcdAnnotation)){c=>
   c.io.raw.poke(false.B);c.io.sample.poke(false.B);c.io.clear.poke(false.B)
   c.reset.poke(true.B);c.clock.step();c.reset.poke(false.B)
   var first=false;var second=false;var candidate=false;var count=0L
   var stable=false;var previous=false;var event=false
   def check():Unit={c.io.sync1.expect(first.B);c.io.sync2.expect(second.B);c.io.candidate.expect(candidate.B);c.io.consecutive.expect(count.U);c.io.stable.expect(stable.B);c.io.previous.expect(previous.B);c.io.event.expect(event.B)}
   def drive(raw:Boolean,sample:Boolean,clear:Boolean):Unit={
    c.io.raw.poke(raw.B);c.io.sample.poke(sample.B);c.io.clear.poke(clear.B);check();c.clock.step()
    if(clear){first=false;second=false;candidate=false;count=0;stable=false;previous=false;event=false}
    else if(sample){val oldSecond=second;val oldStable=stable;second=first;first=raw;if(oldSecond==candidate)count=math.min(0xffffffffL,count+1)else{candidate=oldSecond;count=1};if(count>=3)stable=candidate;previous=oldStable;event=stable && !oldStable}
    check()
   }
   for(pattern<-Seq("0011111111","01010111111111","001000000000","00111111100000001111111")){
    drive(false,false,true);for(bit<-pattern)drive(bit=='1',true,false);drive(false,false,false)
   }
   val random=new scala.util.Random(301)
   for(i<-0 until 2048)drive(random.nextBoolean(),i%5!=0,i%67==0)
   // clear must work even while sample is disabled.
   drive(true,false,true)
  }
 }
 it should "saturate a short observation counter and retain an event while sampling is paused" in {
  test(new InputConditioner(threshold=3,countWidth=2)){c=>
   c.io.raw.poke(true.B);c.io.sample.poke(true.B);c.io.clear.poke(false.B)
   c.reset.poke(true.B);c.clock.step();c.reset.poke(false.B)
   c.clock.step(5);c.io.stable.expect(true.B);c.io.event.expect(true.B);c.io.consecutive.expect(3.U)
   c.io.sample.poke(false.B);c.clock.step(4);c.io.event.expect(true.B)
   c.io.sample.poke(true.B);c.clock.step(20);c.io.event.expect(false.B);c.io.consecutive.expect(3.U)
   c.io.clear.poke(true.B);c.io.sample.poke(false.B);c.clock.step();c.io.stable.expect(false.B);c.io.event.expect(false.B);c.io.consecutive.expect(0.U)
  }
 }
}
