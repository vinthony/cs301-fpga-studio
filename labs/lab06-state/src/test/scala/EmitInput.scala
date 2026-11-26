package cs301
object EmitInput extends App {
 val path="test_run_dir/InputConditioner_should_match_staged_sampling_and_pause_clear_priority/InputConditioner.lo.fir"
 require(new java.io.File(path).isFile,"Run test first")
 val file=scala.io.Source.fromFile(path);val source=try file.mkString finally file.close()
 (new firrtl2.stage.FirrtlStage).execute(Array("-X","verilog","--target-dir","generated"),Seq(firrtl2.stage.FirrtlSourceAnnotation(source)))
}
