package cs301
object EmitState extends App {
  val path="test_run_dir/StateElements_should_hold_before_edges_and_honor_clear_before_enable_across_a_stateful_stream/StateDemoTop.lo.fir"
  require(new java.io.File(path).isFile,"Run test first")
  val file=scala.io.Source.fromFile(path);val source=try file.mkString finally file.close()
  (new firrtl2.stage.FirrtlStage).execute(Array("-X","verilog","--target-dir","generated"),Seq(firrtl2.stage.FirrtlSourceAnnotation(source)))
}
