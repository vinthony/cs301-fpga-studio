package cs301
object EmitFIFO extends App {
 val path="test_run_dir/TeachingFIFO_should_preserve_queue_order_and_simultaneous_boundaries/TeachingFIFO.lo.fir"
 require(new java.io.File(path).isFile,"Run test first")
 val file=scala.io.Source.fromFile(path);val source=try file.mkString finally file.close()
 (new firrtl2.stage.FirrtlStage).execute(Array("-X","verilog","--target-dir","generated"),Seq(firrtl2.stage.FirrtlSourceAnnotation(source)))
}
