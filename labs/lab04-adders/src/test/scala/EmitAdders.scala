package cs301
object EmitAdders extends App {
  val path="test_run_dir/Adders_should_exhaust_all_512_fourbit_operand_and_carry_combinations/CompareAdders4.lo.fir"
  require(new java.io.File(path).isFile,"Run sbt test first")
  val file=scala.io.Source.fromFile(path);val source=try file.mkString finally file.close()
  (new firrtl2.stage.FirrtlStage).execute(Array("-X","verilog","--target-dir","generated"),Seq(firrtl2.stage.FirrtlSourceAnnotation(source)))
}
