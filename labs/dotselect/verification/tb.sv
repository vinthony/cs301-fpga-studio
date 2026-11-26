`timescale 1ns/1ps
module tb;
 reg [3:0] requests;
 reg [1:0] digit;
 wire low_group, high_group, selected, dp;
 integer r, d, file;
 DotSelect dut(requests,digit,low_group,high_group,selected,dp);
 initial begin
  $dumpfile("evidence/dotselect.vcd"); $dumpvars(0,tb);
  file=$fopen("evidence/rtl.csv","w");
  $fdisplay(file,"requests,digit,low_group,high_group,selected,dp");
  for(r=0;r<16;r=r+1)for(d=0;d<4;d=d+1)begin
   requests=r;digit=d;#1;
   $fdisplay(file,"%0d,%0d,%0d,%0d,%0d,%0d",requests,digit,low_group,high_group,selected,dp);
  end
  $fclose(file);$finish;
 end
endmodule
