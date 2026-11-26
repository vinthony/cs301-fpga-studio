package cs301
object EmitLogic extends App {
  val path="test_run_dir/LogicTop_should_exhaust_all_inputs_and_check_gate_tables_selection_and_comparison/LogicTop.lo.fir"
  require(new java.io.File(path).isFile,"Run test first")
  val file=scala.io.Source.fromFile(path);val source=try file.mkString finally file.close()
  (new firrtl2.stage.FirrtlStage).execute(Array("-X","verilog","--target-dir","generated"),Seq(firrtl2.stage.FirrtlSourceAnnotation(source)))
}
