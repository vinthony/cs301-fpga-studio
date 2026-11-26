package cs301
/** JVM FIRRTL backend matches the chiseltest dependency and works on ARM macOS.
  * This exports the actual Chisel-generated circuit, not handwritten reference RTL.
  */
object EmitSequence1011 extends App {
  val path = "test_run_dir/Sequence1011_should_hold_on_disabled_clocks_and_reset_synchronously_with_priority/Sequence1011.lo.fir"
  require(new java.io.File(path).isFile, "Run sbt test first to elaborate and verify the Chisel circuit")
  val file = scala.io.Source.fromFile(path)
  val source = try file.mkString finally file.close()
  (new firrtl2.stage.FirrtlStage).execute(
    Array("-X", "verilog", "--target-dir", "generated"),
    Seq(firrtl2.stage.FirrtlSourceAnnotation(source))
  )
}
