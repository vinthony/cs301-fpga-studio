package cs301
object EmitButtonLeds extends App {
  val path="test_run_dir/ButtonLeds_should_adapt_all_fivebutton_patterns_and_blank_every_display_output/TeachingButtonTop.lo.fir"
  require(new java.io.File(path).isFile,"Run sbt test first")
  val file=scala.io.Source.fromFile(path);val source=try file.mkString finally file.close()
  (new firrtl2.stage.FirrtlStage).execute(Array("-X","verilog","--target-dir","generated"),Seq(firrtl2.stage.FirrtlSourceAnnotation(source)))
}
