// Independent teaching control decoder for base RV32I encodings.
// FENCE reserved fields are ignored, as required for base implementations.
// This module does not execute instructions, trap entry, or memory ordering.
module rv32_decoder(input [31:0] inst,output reg [5:0] id,output reg [2:0] fmt,output reg [3:0] alu,output reg load_unsigned,shift_imm,output reg [15:0] control);
reg r1,r2,rw,mr,mw,br,jump,isel,pcsel,trap,fence;
reg [1:0] wb,size;
wire [6:0] opcode=inst[6:0];wire [2:0] f3=inst[14:12];wire [6:0] f7=inst[31:25];
always @* begin
 id=63;fmt=7;alu=0;load_unsigned=0;shift_imm=0;
 r1=0;r2=0;rw=0;mr=0;mw=0;br=0;jump=0;isel=0;pcsel=0;trap=0;fence=0;wb=0;size=0;
 case(opcode)
 7'h33:begin
  case({f7,f3})
   10'h000:begin id=0;alu=0;end
   10'h100:begin id=1;alu=1;end
   10'h001:begin id=2;alu=5;end
   10'h002:begin id=3;alu=8;end
   10'h003:begin id=4;alu=9;end
   10'h004:begin id=5;alu=4;end
   10'h005:begin id=6;alu=6;end
   10'h105:begin id=7;alu=7;end
   10'h006:begin id=8;alu=3;end
   10'h007:begin id=9;alu=2;end
  endcase
  if(id!=63)begin fmt=0;r1=1;r2=1;rw=1;end
 end
 7'h13:begin
  case(f3)
   0:begin id=10;alu=0;end
   2:begin id=11;alu=8;end
   3:begin id=12;alu=9;end
   4:begin id=13;alu=4;end
   6:begin id=14;alu=3;end
   7:begin id=15;alu=2;end
   1:if(f7==0)begin id=16;alu=5;shift_imm=1;end
   5:if(f7==0)begin id=17;alu=6;shift_imm=1;end else if(f7==7'h20)begin id=18;alu=7;shift_imm=1;end
  endcase
  if(id!=63)begin fmt=1;r1=1;rw=1;isel=1;end
 end
 7'h03:begin
  case(f3)
   0:begin id=19;size=0;end
   1:begin id=20;size=1;end
   2:begin id=21;size=2;end
   4:begin id=22;size=0;load_unsigned=1;end
   5:begin id=23;size=1;load_unsigned=1;end
  endcase
  if(id!=63)begin fmt=1;r1=1;rw=1;mr=1;isel=1;wb=1;end
 end
 7'h23:begin
  case(f3)
   0:begin id=24;size=0;end
   1:begin id=25;size=1;end
   2:begin id=26;size=2;end
  endcase
  if(id!=63)begin fmt=2;r1=1;r2=1;mw=1;isel=1;end
 end
 7'h63:begin
  case(f3)
   0:begin id=27;alu=1;end
   1:begin id=28;alu=1;end
   4:begin id=29;alu=8;end
   5:begin id=30;alu=8;end
   6:begin id=31;alu=9;end
   7:begin id=32;alu=9;end
  endcase
  if(id!=63)begin fmt=3;r1=1;r2=1;br=1;end
 end
 7'h6f:begin id=33;fmt=5;rw=1;jump=1;isel=1;pcsel=1;wb=2;end
 7'h67:if(f3==0)begin id=34;fmt=1;r1=1;rw=1;jump=1;isel=1;wb=2;end
 7'h37:begin id=35;fmt=4;rw=1;isel=1;wb=3;end
 7'h17:begin id=36;fmt=4;rw=1;isel=1;pcsel=1;end
 7'h0f:if(f3==0)begin id=37;fmt=6;fence=1;end
 7'h73:begin
  if(inst==32'h00000073)begin id=38;fmt=6;trap=1;end
  else if(inst==32'h00100073)begin id=39;fmt=6;trap=1;end
 end
 endcase
 control={size,wb,fence,trap,pcsel,isel,jump,br,mw,mr,rw,r2,r1,(id!=63)};
end
endmodule
