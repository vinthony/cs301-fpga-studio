`timescale 1ns/1ps
module tb;
 reg [9:0] a=0,b=0;
 wire eq,lt;
 wire [10:0] prefix_eq,prefix_lt;
 Compare10 dut(.*);
 integer fd,rc,av,bv,e,l,emask,lmask,count=0;
 reg [4095:0] vectors,wave;
 initial begin
  if(!$value$plusargs("vectors=%s",vectors))$fatal(1,"missing vectors");
  if($value$plusargs("wave=%s",wave))begin $dumpfile(wave);$dumpvars(0,dut);end
  fd=$fopen(vectors,"r");if(!fd)$fatal(1,"cannot read vectors");
  while(!$feof(fd))begin
   rc=$fscanf(fd,"%d %d %d %d %d %d\n",av,bv,e,l,emask,lmask);
   if(rc!=6)$fatal(1,"bad vector %0d",count);
   a=av;b=bv;#1;
   if(eq!==e||lt!==l||prefix_eq!==emask||prefix_lt!==lmask)
    $fatal(1,"mismatch %0d A=%0d B=%0d eq/lt=%b/%b masks=%h/%h expected=%h/%h",count,av,bv,eq,lt,prefix_eq,prefix_lt,emask,lmask);
   count=count+1;
  end
  $fclose(fd);$display("PASS pairs=%0d prefix_bits_per_pair=22 final_bits_per_pair=2",count);$finish;
 end
endmodule

module tb_bit;
 reg a=0,b=0,eq_in=0,lt_in=0;
 wire eq_out,lt_out;
 CompareBit dut(.*);
 integer fd,rc,av,bv,ei,li,eo,lo,count=0;
 reg [4095:0] vectors;
 initial begin
  if(!$value$plusargs("vectors=%s",vectors))$fatal(1,"missing vectors");
  fd=$fopen(vectors,"r");if(!fd)$fatal(1,"cannot read vectors");
  while(!$feof(fd))begin
   rc=$fscanf(fd,"%d %d %d %d %d %d\n",av,bv,ei,li,eo,lo);
   if(rc!=6)$fatal(1,"bad bit vector %0d",count);
   a=av;b=bv;eq_in=ei;lt_in=li;#1;
   if(eq_out!==eo||lt_out!==lo)$fatal(1,"bit truth table mismatch %0d",count);
   count=count+1;
  end
  $fclose(fd);$display("PASS bit_truth_cases=%0d",count);$finish;
 end
endmodule
