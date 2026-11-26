package cs301
import chisel3._
import chisel3.util._
import scala.language.reflectiveCalls

class FullAdder extends Module {
  val io = IO(new Bundle {
    val a = Input(Bool()); val b = Input(Bool()); val cin = Input(Bool())
    val sum = Output(Bool()); val cout = Output(Bool())
  })
  val p = io.a ^ io.b
  io.sum := p ^ io.cin
  io.cout := (io.a && io.b) || (p && io.cin)
}
class RippleAdder(val width: Int) extends Module {
  require(width > 0)
  val io = IO(new Bundle {
    val a = Input(UInt(width.W)); val b = Input(UInt(width.W)); val cin = Input(Bool())
    val sum = Output(UInt(width.W)); val cout = Output(Bool())
    val carries = Output(UInt((width+1).W))
  })
  val carry = Wire(Vec(width+1, Bool())); val sums = Wire(Vec(width, Bool()))
  carry(0) := io.cin
  for(i <- 0 until width) {
    val fa = Module(new FullAdder)
    fa.io.a := io.a(i); fa.io.b := io.b(i); fa.io.cin := carry(i)
    sums(i) := fa.io.sum; carry(i+1) := fa.io.cout
  }
  io.sum := sums.asUInt; io.cout := carry(width); io.carries := carry.asUInt
}
class LookaheadAdder4 extends Module {
  val io = IO(new Bundle {
    val a = Input(UInt(4.W)); val b = Input(UInt(4.W)); val cin = Input(Bool())
    val sum = Output(UInt(4.W)); val cout = Output(Bool()); val carries = Output(UInt(5.W))
    val propagate = Output(UInt(4.W)); val generate = Output(UInt(4.W))
  })
  val p = io.a ^ io.b; val g = io.a & io.b; val c = Wire(Vec(5,Bool()))
  c(0) := io.cin
  // Expanded lookahead equations do not consume c(1), c(2), c(3) recursively.
  c(1) := g(0) || (p(0) && io.cin)
  c(2) := g(1) || (p(1) && g(0)) || (p(1) && p(0) && io.cin)
  c(3) := g(2) || (p(2) && g(1)) || (p(2) && p(1) && g(0)) || (p(2) && p(1) && p(0) && io.cin)
  c(4) := g(3) || (p(3) && g(2)) || (p(3) && p(2) && g(1)) || (p(3) && p(2) && p(1) && g(0)) || (p(3) && p(2) && p(1) && p(0) && io.cin)
  io.sum := p ^ c.asUInt(3,0); io.cout := c(4); io.carries := c.asUInt
  io.propagate := p; io.generate := g
}
class CompareAdders4 extends Module {
  val io = IO(new Bundle {
    val a = Input(UInt(4.W)); val b = Input(UInt(4.W)); val cin = Input(Bool())
    val ripple = Output(UInt(5.W)); val lookahead = Output(UInt(5.W))
    val rippleCarries = Output(UInt(5.W)); val lookaheadCarries = Output(UInt(5.W))
    val equal = Output(Bool())
  })
  val r = Module(new RippleAdder(4)); val l = Module(new LookaheadAdder4)
  r.io.a := io.a; r.io.b := io.b; r.io.cin := io.cin
  l.io.a := io.a; l.io.b := io.b; l.io.cin := io.cin
  io.ripple := Cat(r.io.cout,r.io.sum); io.lookahead := Cat(l.io.cout,l.io.sum)
  io.rippleCarries := r.io.carries; io.lookaheadCarries := l.io.carries
  io.equal := io.ripple === io.lookahead
}
