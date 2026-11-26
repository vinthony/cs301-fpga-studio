package cs301
object EmitBaudUARTTX extends App {
 val path="test_run_dir/BaudUARTTX_should_use_868_primary_clocks_per_ideal_bit/BaudUARTTX.lo.fir"
 require(new java.io.File(path).isFile,"Run test first")
 val file=scala.io.Source.fromFile(path);val source=try file.mkString finally file.close()
 (new firrtl2.stage.FirrtlStage).execute(Array("-X","verilog","--target-dir","generated"),Seq(firrtl2.stage.FirrtlSourceAnnotation(source)))
}
