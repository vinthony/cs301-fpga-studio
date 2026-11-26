package cs301
object EmitFields extends App {
  val path="test_run_dir/InstructionFields_should_extract_raw_slices_from_instruction_examples_and_deterministic_bit_patterns/InstructionFields.lo.fir"
  require(new java.io.File(path).isFile,"Run test first")
  val file=scala.io.Source.fromFile(path);val source=try file.mkString finally file.close()
  (new firrtl2.stage.FirrtlStage).execute(Array("-X","verilog","--target-dir","generated"),Seq(firrtl2.stage.FirrtlSourceAnnotation(source)))
}
