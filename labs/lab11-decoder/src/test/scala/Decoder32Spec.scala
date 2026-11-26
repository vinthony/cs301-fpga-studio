package cs301
import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import scala.language.reflectiveCalls
class Decoder32Spec extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "Decoder32"
  it should "check fixed control contracts and reject extension and reserved encodings" in {
    test(new Decoder32).withAnnotations(Seq(WriteVcdAnnotation)){c=>
      val cases=Seq(
        (0x002081b3L,0,0,0,0x000f,0L),
        (0x402081b3L,1,0,1,0x000f,0L),
        (0xffc10093L,10,1,0,0x010b,0xfffffffcL),
        (0x00812083L,21,1,0,0x911b,8L),
        (0x00112623L,26,2,0,0x8127,12L),
        (0x00208463L,27,3,1,0x0047,8L),
        (0x00c000efL,33,5,0,0x2389,12L),
        (0x000100e7L,34,1,0,0x218b,0L),
        (0x123451b7L,35,4,0,0x3109,0x12345000L),
        (0x12345197L,36,4,0,0x0309,0x12345000L),
        (0xfff0808fL,37,6,0,0x0801,0L),
        (0x00000073L,38,6,0,0x0401,0L),
        (0x00100073L,39,6,0,0x0401,0L),
        (0x022081b3L,63,7,0,0,0L), // MUL not RV32I
        (0x0000100fL,63,7,0,0,0L), // FENCE.I not base FENCE
        (0x00001073L,63,7,0,0,0L), // CSR not supported
        (0xffffffffL,63,7,0,0,0L))
      for((word,id,fmt,alu,control,imm)<-cases){
        c.io.instruction.poke(word.U);c.io.id.expect(id.U);c.io.format.expect(fmt.U);c.io.alu.expect(alu.U);c.io.control.expect(control.U);c.io.immediate.expect(imm.U)
        c.io.valid.expect((id!=63).B);c.io.effectiveRegWrite.expect(((control&8)!=0&&((word>>7)&31)!=0).B);c.clock.step()
      }
      // A legal request targeting x0 is decoded, but must not become a storage write.
      c.io.instruction.poke("h00100013".U);c.io.valid.expect(true.B);c.io.effectiveRegWrite.expect(false.B)
    }
  }
  it should "reassemble every immediate format including sign edges and unknown formats" in {
    test(new Immediate32){c=>
      val random=new scala.util.Random(301);val mask=(1L<<32)-1
      val words=Seq(0L,mask,0x80000000L)++(0 until 32).map(i=>1L<<i)++Seq.fill(1024)(random.nextLong()&mask)
      def signed(value:Long,width:Int):Long=if((value&(1L<<(width-1)))!=0)value-(1L<<width) else value
      for(word<-words;fmt<-0 until 8){
        val v=fmt match{
          case 0=>signed(word/1048576,12)
          case 1=>signed((word/33554432)*32+((word/128)%32),12)
          case 2=>signed((word/2147483648L)*4096+((word/128)%2)*2048+((word/33554432)%64)*32+((word/256)%16)*2,13)
          case 3=>(word/4096)*4096
          case 4=>signed((word/2147483648L)*1048576+((word/4096)%256)*4096+((word/1048576)%2)*2048+((word/2097152)%1024)*2,21)
          case _=>0L
        }
        c.io.instruction.poke(word.U);c.io.format.poke(fmt.U);c.io.immediate.expect((v&mask).U)
      }
    }
  }
}
