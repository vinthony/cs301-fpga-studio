package cs301
import chisel3._
import chisel3.util._
import scala.language.reflectiveCalls

class BasicGates extends Module {
  val io=IO(new Bundle {
    val a=Input(Bool());val b=Input(Bool())
    val andOut=Output(Bool());val orOut=Output(Bool());val notOut=Output(Bool())
    val xorOut=Output(Bool());val nandOut=Output(Bool());val norOut=Output(Bool())
  })
  io.andOut:=io.a && io.b;io.orOut:=io.a || io.b;io.notOut:= !io.a
  io.xorOut:=io.a ^ io.b;io.nandOut:= !(io.a && io.b);io.norOut:= !(io.a || io.b)
}
class SelectBit extends Module {
  val io=IO(new Bundle {val a=Input(Bool());val b=Input(Bool());val select=Input(Bool());val out=Output(Bool())})
  io.out:=Mux(io.select,io.b,io.a)
}
class UnsignedCompare4 extends Module {
  val io=IO(new Bundle {val a=Input(UInt(4.W));val b=Input(UInt(4.W));val lt=Output(Bool());val eq=Output(Bool());val gt=Output(Bool())})
  io.lt:=io.a<io.b;io.eq:=io.a===io.b;io.gt:=io.a>io.b
}
/** Core test adapter: low bits feed gates/MUX; full four-bit words feed comparator. */
class LogicTop extends Module {
  val io=IO(new Bundle {
    val a=Input(UInt(4.W));val b=Input(UInt(4.W));val select=Input(Bool())
    val gates=Output(UInt(6.W));val selected=Output(Bool())
    val lt=Output(Bool());val eq=Output(Bool());val gt=Output(Bool())
  })
  val gates=Module(new BasicGates);gates.io.a:=io.a(0);gates.io.b:=io.b(0)
  // bit0 AND, bit1 OR, bit2 NOT(A), bit3 XOR, bit4 NAND, bit5 NOR
  io.gates:=Cat(gates.io.norOut,gates.io.nandOut,gates.io.xorOut,gates.io.notOut,gates.io.orOut,gates.io.andOut)
  val mux=Module(new SelectBit);mux.io.a:=io.a(0);mux.io.b:=io.b(0);mux.io.select:=io.select;io.selected:=mux.io.out
  val cmp=Module(new UnsignedCompare4);cmp.io.a:=io.a;cmp.io.b:=io.b;io.lt:=cmp.io.lt;io.eq:=cmp.io.eq;io.gt:=cmp.io.gt
}
