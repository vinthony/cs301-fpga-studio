`timescale 1ns/1ps
module tb;
 reg clk=0, reset=0,enable=0;
 reg [11:0] color=0;
 wire [9:0] x,y,next_x,next_y;
 wire active,hs,vs,address_valid,line_enable;
 wire [18:0] address;
 wire [11:0] rgb;
 VGAPrefixTiming dut(.*);
 integer fd,rc,mode,bx,by,ce,rst,c,a,h,v,addr,out_rgb,le,nx,ny,c0,c1,c2,c3,c4,c5,count=0;
 reg [4095:0] vectors,wave;
 initial begin
  if(!$value$plusargs("vectors=%s",vectors))$fatal(1,"missing vectors");
  if($value$plusargs("wave=%s",wave))begin $dumpfile(wave);$dumpvars(0,dut);end
  fd=$fopen(vectors,"r");if(!fd)$fatal(1,"cannot read vectors");
  while(!$feof(fd))begin
   rc=$fscanf(fd,"%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n",mode,bx,by,ce,rst,c,a,h,v,addr,out_rgb,le,nx,ny,c0,c1,c2,c3,c4,c5);
   if(rc!=20)$fatal(1,"bad vector %0d",count);
   clk=0;
   // Arbitrary valid coordinates are injected only in exhaustive phase.
   if(mode==0)begin dut.horizontal.q=bx;dut.vertical.q=by;end
   enable=ce;reset=rst;color=c;#1;
   if(x!==bx||y!==by||active!==a||hs!==h||vs!==v||address_valid!==a||address!==addr||rgb!==out_rgb||line_enable!==le||next_x!==nx||next_y!==ny||dut.x_lt_640!==c0||dut.y_lt_480!==c1||dut.x_lt_656!==c2||dut.x_lt_752!==c3||dut.y_lt_490!==c4||dut.y_lt_492!==c5)
    $fatal(1,"pre-edge %0d x=%0d y=%0d ce=%0d rst=%0d",count,bx,by,ce,rst);
   clk=1;#1;
   if(x!==nx||y!==ny)$fatal(1,"post-edge %0d",count);
   count=count+1;
  end
  $fclose(fd);$display("PASS vectors=%0d pre_checks=17 post_checks=2",count);$finish;
 end
endmodule
