package cs301
object EmitArithmeticCPU extends App {
  val path="test_run_dir/ArithmeticCPU_should_retire_arithmetic_programs_at_edges_pause_and_stop_without_committing_faults/ArithmeticCPU.lo.fir"
  require(new java.io.File(path).isFile,"Run test first")
  val file=scala.io.Source.fromFile(path);val source=try file.mkString finally file.close()
  (new firrtl2.stage.FirrtlStage).execute(Array("-X","verilog","--target-dir","generated"),Seq(firrtl2.stage.FirrtlSourceAnnotation(source)))
}
