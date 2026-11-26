package cs301
object EmitDecoder extends App {
  val path="test_run_dir/Decoder32_should_check_fixed_control_contracts_and_reject_extension_and_reserved_encodings/Decoder32.lo.fir"
  require(new java.io.File(path).isFile,"Run test first")
  val file=scala.io.Source.fromFile(path);val source=try file.mkString finally file.close()
  (new firrtl2.stage.FirrtlStage).execute(Array("-X","verilog","--target-dir","generated"),Seq(firrtl2.stage.FirrtlSourceAnnotation(source)))
}
