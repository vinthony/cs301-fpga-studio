package cs301
import chisel3._
import chisel3.util._
import scala.language.reflectiveCalls

/** Combinational interpretations of the same four wires. Negative zero has a
  * separate encoding flag because an SInt arithmetic output cannot distinguish it.
  */
class Representation4 extends Module {
  val io = IO(new Bundle {
    val bits = Input(UInt(4.W))
    val unsigned = Output(UInt(4.W))
    val signMagnitude = Output(SInt(5.W))
    val signMagnitudeNegativeZero = Output(Bool())
    val onesComplement = Output(SInt(5.W))
    val onesComplementNegativeZero = Output(Bool())
    val twosComplement = Output(SInt(4.W))
  })
  val negative = io.bits(3)
  val magnitude = Cat(0.U(1.W), io.bits(2,0)).asSInt
  val inverted = (~io.bits).asUInt.asSInt
  io.unsigned := io.bits
  io.signMagnitude := Mux(negative, -magnitude, magnitude)
  io.signMagnitudeNegativeZero := io.bits === "b1000".U
  io.onesComplement := Mux(negative, -inverted, io.bits.asSInt)
  io.onesComplementNegativeZero := io.bits === "b1111".U
  io.twosComplement := io.bits.asSInt
}
