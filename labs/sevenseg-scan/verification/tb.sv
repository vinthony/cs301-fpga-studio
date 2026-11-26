`timescale 1ns/1ps
module tb;
 reg clk=0, reset=1, step=0; reg [15:0] word=0;
 wire [1:0] digit,phase; wire [3:0] an; wire [6:0] seg; wire dp;
 SevenSegmentScan dut(clk,reset,step,word,digit,phase,an,seg,dp);
 integer d=0,p=2,checks=0,states=0,holds=0,fd,w,i,j,n;
 reg [15:0] selected[0:19];
 function [6:0] expected_seg(input integer value);
 begin case(value)
 0:expected_seg=7'b1000000;1:expected_seg=7'b1111001;2:expected_seg=7'b0100100;3:expected_seg=7'b0110000;
 4:expected_seg=7'b0011001;5:expected_seg=7'b0010010;6:expected_seg=7'b0000010;7:expected_seg=7'b1111000;
 8:expected_seg=7'b0000000;9:expected_seg=7'b0010000;10:expected_seg=7'b0001000;11:expected_seg=7'b0000011;
 12:expected_seg=7'b1000110;13:expected_seg=7'b0100001;14:expected_seg=7'b0000110;15:expected_seg=7'b0001110;
 endcase end endfunction
 task check;
 reg [3:0] expected_an;
 begin
  expected_an=p==2?(15^(1<<d)):15;
  if(digit!==d || phase!==p || an!==expected_an || seg!==expected_seg((word>>(d*4))&15) || dp!==1)
   $fatal(1,"mismatch word=%h digit=%d phase=%d expected=%d/%d an=%b seg=%b",word,digit,phase,d,p,an,seg);
  checks=checks+1;
 end endtask
 task clock_edge;
 begin #1;clk=1;#1;clk=0;#1;end endtask
 task advance;
 begin step=1;if(p==2)begin p=0;d=(d+1)%4;end else p=p+1;clock_edge();check();end endtask
 initial begin
  $dumpfile("evidence/scan.vcd");$dumpvars(0,tb);
  clock_edge();reset=0;check();
  fd=$fopen("evidence/scan-trace.csv","w");$fdisplay(fd,"word,digit,phase,an,seg,dp");
  for(i=0;i<16;i=i+1)selected[i]=i*16'h1111;
  selected[16]=16'h1234;selected[17]=16'habcd;selected[18]=16'h0035;selected[19]=16'h805f;
  for(i=0;i<20;i=i+1)begin
   word=selected[i];#1;
   for(j=0;j<12;j=j+1)begin check();$fdisplay(fd,"%0d,%0d,%0d,%0d,%0d,%0d",word,digit,phase,an,seg,dp);advance();end
  end
  $fclose(fd);$dumpoff;
  for(w=0;w<65536;w=w+1)begin
   word=w;#1;
   for(n=0;n<12;n=n+1)begin
    check();states=states+1;step=0;clock_edge();check();holds=holds+1;advance();
   end
  end
  // Reset has priority over step after a noninitial phase.
  advance();reset=1;step=1;d=0;p=2;clock_edge();check();
  fd=$fopen("evidence/rtl-check.json","w");
  $fdisplay(fd,"{\"status\":\"passed\",\"displayWords\":65536,\"states\":%0d,\"holdEdges\":%0d,\"checks\":%0d}",states,holds,checks);
  $fclose(fd);$display("PASS states=%0d holdEdges=%0d checks=%0d",states,holds,checks);$finish;
 end
endmodule
