`timescale 1ns/1ps
module tb;
 reg [4:0] request_tag, saved_tag;
 reg valid;
 wire [4:0] different,same_bit;
 wire low_two,middle_two,low_four,equal,hit;
 integer a,b,v,file;
 CacheTagHit dut(request_tag,saved_tag,valid,different,same_bit,low_two,middle_two,low_four,equal,hit);
 initial begin
  $dumpfile("evidence/cache-tag-hit.vcd");$dumpvars(0,tb);
  file=$fopen("evidence/rtl.csv","w");
  $fdisplay(file,"request,saved,valid,different,same,low_two,middle_two,low_four,equal,hit");
  for(a=0;a<32;a=a+1)for(b=0;b<32;b=b+1)for(v=0;v<2;v=v+1)begin
   request_tag=a;saved_tag=b;valid=v;#1;
   $fdisplay(file,"%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d",request_tag,saved_tag,valid,different,same_bit,low_two,middle_two,low_four,equal,hit);
  end
  $fclose(file);$finish;
 end
endmodule
