package cs301
import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import scala.language.reflectiveCalls
class StateElementsSpec extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "StateElements"
  it should "hold before edges and honor clear before enable across a stateful stream" in {
    test(new StateDemoTop).withAnnotations(Seq(WriteVcdAnnotation)){c=>
      c.io.data.poke(0.U);c.io.enable.poke(false.B);c.io.clear.poke(false.B);c.reset.poke(true.B);c.clock.step();c.reset.poke(false.B)
      var q=0;var count=0;var phase=0;var led=false
      val random=new scala.util.Random(301)
      for(i<-0 until 1024){
        val data=random.nextInt(16);val enable=(i<40)||random.nextBoolean();val clear=(i%29==0)
        c.io.data.poke(data.U);c.io.enable.poke(enable.B);c.io.clear.poke(clear.B)
        c.io.qInit.expect(q.U);c.io.qEnable.expect(q.U);c.io.count.expect(count.U);c.io.phase.expect(phase.U);c.io.blink.expect(led.B)
        c.clock.step()
        if(clear){q=0;count=0;phase=0;led=false}
        else if(enable){q=data;count=(count+1)%16;if(phase==2){phase=0;led= !led}else phase+=1}
        c.io.qInit.expect(q.U);c.io.qEnable.expect(q.U);c.io.count.expect(count.U);c.io.phase.expect(phase.U);c.io.blink.expect(led.B)
      }
    }
  }
  it should "toggle on the exact configured number of active edges" in {
    for(period<-Seq(1,2,3,5))test(new BlinkDivider(period)){c=>
      c.io.enable.poke(true.B);c.io.clear.poke(false.B);c.reset.poke(true.B);c.clock.step();c.reset.poke(false.B)
      for(edge<-1 to period*4){c.clock.step();c.io.phase.expect((edge%period).U);c.io.led.expect(((edge/period)%2==1).B)}
      val old=c.io.phase.peek().litValue;c.io.enable.poke(false.B);c.clock.step(5);c.io.phase.expect(old.U)
    }
  }
}
