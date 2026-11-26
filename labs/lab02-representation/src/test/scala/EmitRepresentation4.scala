package cs301
object EmitRepresentation4 extends App {
  val path = "test_run_dir/Representation4_should_interpret_all_sixteen_patterns_before_a_clock_edge_and_preserve_negative_zero_flags/Representation4.lo.fir"
  require(new java.io.File(path).isFile, "Run sbt test first")
  val file = scala.io.Source.fromFile(path)
  val source = try file.mkString finally file.close()
  (new firrtl2.stage.FirrtlStage).execute(
    Array("-X", "verilog", "--target-dir", "generated"),
    Seq(firrtl2.stage.FirrtlSourceAnnotation(source)))
}
