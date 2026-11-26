package cs301
object EmitUARTBitTX extends App {
 val path="test_run_dir/UARTBitTX_should_send_all_bytes_without_changing_an_active_frame/UARTBitTX.lo.fir"
 require(new java.io.File(path).isFile,"Run test first")
 val file=scala.io.Source.fromFile(path);val source=try file.mkString finally file.close()
 (new firrtl2.stage.FirrtlStage).execute(Array("-X","verilog","--target-dir","generated"),Seq(firrtl2.stage.FirrtlSourceAnnotation(source)))
}
