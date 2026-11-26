package cs301
object EmitUARTBitRX extends App {
 val path="test_run_dir/UARTBitRX_should_check_every_byte_and_both_stop_levels/UARTBitRX.lo.fir"
 require(new java.io.File(path).isFile,"Run test first")
 val file=scala.io.Source.fromFile(path);val source=try file.mkString finally file.close()
 (new firrtl2.stage.FirrtlStage).execute(Array("-X","verilog","--target-dir","generated"),Seq(firrtl2.stage.FirrtlSourceAnnotation(source)))
}
