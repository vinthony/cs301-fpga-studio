package cs301
object EmitALU4 extends App {
  val path="test_run_dir/ALU4_should_exhaust_every_operand_and_opcode_including_invalid_codes/ALU4.lo.fir"
  require(new java.io.File(path).isFile,"Run test first")
  val file=scala.io.Source.fromFile(path);val source=try file.mkString finally file.close()
  (new firrtl2.stage.FirrtlStage).execute(Array("-X","verilog","--target-dir","generated"),Seq(firrtl2.stage.FirrtlSourceAnnotation(source)))
}
