package cs301
object EmitSingleCycle extends App {
 val path="test_run_dir/SingleCycleCPU_should_execute_a_loop_with_store_load_and_precise_breakpoint/SingleCycleCPU.lo.fir"
 require(new java.io.File(path).isFile,"Run test first")
 val file=scala.io.Source.fromFile(path);val source=try file.mkString finally file.close()
 (new firrtl2.stage.FirrtlStage).execute(Array("-X","verilog","--target-dir","generated"),Seq(firrtl2.stage.FirrtlSourceAnnotation(source)))
}
