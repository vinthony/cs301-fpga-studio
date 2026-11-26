package cs301
import chisel3._
import chisel3.util._

/** Four-prefix Mealy detector with an edge-sampled output pulse.
  * reset is synchronous. enable=false consumes no input and holds all registers.
  */
class Sequence1011 extends Module {
  val io = IO(new Bundle {
    val bitIn = Input(Bool())
    val enable = Input(Bool())
    val state = Output(UInt(2.W))
    val nextState = Output(UInt(2.W))
    val candidate = Output(Bool())
    val hit = Output(Bool())
    val count = Output(UInt(32.W))
  })
  val state = RegInit(0.U(2.W))
  val hit = RegInit(false.B)
  val count = RegInit(0.U(32.W))
  val next = WireDefault(0.U(2.W))
  switch(state) {
    is(0.U) { next := Mux(io.bitIn, 1.U, 0.U) }
    is(1.U) { next := Mux(io.bitIn, 1.U, 2.U) }
    is(2.U) { next := Mux(io.bitIn, 3.U, 0.U) }
    is(3.U) { next := Mux(io.bitIn, 1.U, 2.U) }
  }
  val candidate = state === 3.U && io.bitIn && !reset.asBool
  when(io.enable) {
    state := next
    hit := candidate
    when(candidate) { count := count + 1.U }
  }
  io.state := state
  io.nextState := Mux(reset.asBool, 0.U, next)
  io.candidate := candidate
  io.hit := hit
  io.count := count
}
