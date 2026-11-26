package cs301
object EmitPipeline extends App {
 val path="test_run_dir/PipelineCPU_should_forward_dependent_arithmetic_through_a_real_five_stage_pipeline/PipelineCPU.lo.fir"
 require(new java.io.File(path).isFile,"Run test first")
 PipelineEvidence.verifyElaboration()
 val file=scala.io.Source.fromFile(path);val source=try file.mkString finally file.close()
 (new firrtl2.stage.FirrtlStage).execute(Array("-X","verilog","--target-dir","generated"),Seq(firrtl2.stage.FirrtlSourceAnnotation(source)))
 PipelineEvidence.recordRTL()
}
