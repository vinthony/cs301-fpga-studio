`timescale 1ns/1ps
module tb;
 reg clk=0, reset=0, enable=0;
 reg [9:0] limit=0;
 wire [9:0] q,d,next_q;
 wire [10:0] increment;
 wire terminal;
 RasterCounter dut(.*);
 integer fd,rc,mode,before_q,lim,ce,rst,inc,term,candidate,expected,count=0;
 reg [4095:0] vectors,wave;
 initial begin
  if (!$value$plusargs("vectors=%s",vectors)) $fatal(1,"missing vectors");
  if($value$plusargs("wave=%s",wave))begin $dumpfile(wave);$dumpvars(0,tb);end
  fd=$fopen(vectors,"r"); if(!fd)$fatal(1,"cannot read vectors");
  while(!$feof(fd)) begin
   rc=$fscanf(fd,"%d %d %d %d %d %d %d %d %d\n",mode,before_q,lim,ce,rst,inc,term,candidate,expected);
   if(rc!=9)$fatal(1,"bad vector %0d",count);
   clk=0;
   // Exhaustive phase deposits arbitrary initial state ONLY in the testbench.
   // Trajectory phase never deposits: q is produced by previous real edges.
   if(mode==0)dut.q=before_q;
   limit=lim;enable=ce;reset=rst;#1;
   if(q!==before_q || increment!==inc || terminal!==term || d!==candidate || next_q!==expected)
    $fatal(1,"pre-edge mismatch %0d q=%0d limit=%0d ce=%0d reset=%0d",count,before_q,lim,ce,rst);
   clk=1;#1;
   if(q!==expected)$fatal(1,"post-edge mismatch %0d",count);
   count=count+1;
  end
  $fclose(fd);$display("PASS vectors=%0d pre_and_post_checked=1",count);$finish;
 end
endmodule
