package cs301
object EmitALU32 extends App {
  val path="test_run_dir/ALU32_should_check_signed_boundaries_shifts_and_invalid_operations_against_wide_integer_arithmetic/ALU32.lo.fir"
  require(new java.io.File(path).isFile,"Run test first")
  val file=scala.io.Source.fromFile(path);val source=try file.mkString finally file.close()
  (new firrtl2.stage.FirrtlStage).execute(Array("-X","verilog","--target-dir","generated"),Seq(firrtl2.stage.FirrtlSourceAnnotation(source)))
}
