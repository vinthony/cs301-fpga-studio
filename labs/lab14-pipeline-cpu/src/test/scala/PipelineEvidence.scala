package cs301
import java.nio.file.{Files,Paths}
import java.security.MessageDigest
object PipelineEvidence {
 def sha(path:String):String=MessageDigest.getInstance("SHA-256").digest(Files.readAllBytes(Paths.get(path))).map(b=>f"${b&255}%02x").mkString
 def sourcePaths:Seq[String]={
  val stream=Files.walk(Paths.get("src"))
  val files=try {import scala.jdk.CollectionConverters._;stream.iterator.asScala.filter(p=>p.toString.endsWith(".scala")).map(_.toString).toSeq.sorted}finally stream.close()
  files++Seq("build.sbt","project/build.properties","run.sh")
 }
 def write(path:String,files:Seq[String]):Unit={Files.createDirectories(Paths.get(path).getParent);Files.writeString(Paths.get(path),files.map(p=>sha(p)+"  "+p).mkString("\n")+"\n")}
 def recordElaboration(fir:String):Unit=write("evidence/elaboration.sha256",sourcePaths:+fir)
 def verifyElaboration():Unit={
  val lines=Files.readString(Paths.get("evidence/elaboration.sha256")).trim.split("\n").map(_.split("  ",2))
  require(sourcePaths.forall(p=>lines.exists(r=>r(1)==p)),"Source set changed; rerun test")
  lines.foreach(r=>require(sha(r(1))==r(0),"Stale elaboration: "+r(1)+"; rerun test"))
 }
 def recordRTL():Unit=write("generated/source-manifest.sha256",sourcePaths:+"generated/PipelineCPU.v")
}
