package cs301
object EmitRegFile extends App {
  val path="test_run_dir/RegFile32_should_separate_saved_values_bypass_values_and_synchronous_writes_in_a_stateful_stream/RegFile32.lo.fir"
  require(new java.io.File(path).isFile,"Run test first")
  val file=scala.io.Source.fromFile(path);val source=try file.mkString finally file.close()
  (new firrtl2.stage.FirrtlStage).execute(Array("-X","verilog","--target-dir","generated"),Seq(firrtl2.stage.FirrtlSourceAnnotation(source)))
}
