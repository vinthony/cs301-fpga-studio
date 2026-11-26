module board_top(input clk, input reset, input [15:0] sw, input [4:0] btn,
 output [15:0] led, output [31:0] display);
// 教学 RV32I 子集：整数运算、分支、跳转、字/字节/半字访存；EBREAK 停机。
// 不实现特权态、CSR、中断、总线或缓存。程序由 program.hex 初始化。
reg [31:0] pc,retired;
reg [31:0] regs[0:31],mem[0:63],rom[0:255];
reg halted,trap;
reg [31:0] last_pc,last_inst,last_wdata,last_addr,last_store;
reg [4:0] last_rd;
reg last_wen,last_mwe,last_retire;
integer i;
initial begin
 for(i=0;i<256;i=i+1) rom[i]=32'h00100073;
 $readmemh("program.hex",rom);
end
wire [31:0] inst=(pc<1024 && pc[1:0]==0)?rom[pc[9:2]]:32'hffffffff;
wire [6:0] op=inst[6:0];
wire [4:0] rd=inst[11:7],rs1=inst[19:15],rs2=inst[24:20];
wire [2:0] f3=inst[14:12];
wire [6:0] f7=inst[31:25];
wire [31:0] a=rs1==0?0:regs[rs1],b=rs2==0?0:regs[rs2];
wire [31:0] immI={{20{inst[31]}},inst[31:20]};
wire [31:0] immS={{20{inst[31]}},inst[31:25],inst[11:7]};
wire [31:0] immB={{19{inst[31]}},inst[31],inst[7],inst[30:25],inst[11:8],1'b0};
wire [31:0] immJ={{11{inst[31]}},inst[31],inst[19:12],inst[20],inst[30:21],1'b0};
reg [31:0] nextpc,result,address,storeword,loadword;
reg wen,mwe,illegal,stop;
reg branch_taken;
reg [7:0] byteval;
reg [15:0] halfval;
always @* begin
 nextpc=pc+4;result=0;address=0;storeword=0;loadword=0;
 wen=0;mwe=0;illegal=0;stop=0;branch_taken=0;byteval=0;halfval=0;
 case(op)
 7'h37:begin result={inst[31:12],12'b0};wen=1;end
 7'h17:begin result=pc+{inst[31:12],12'b0};wen=1;end
 7'h6f:begin result=pc+4;nextpc=pc+immJ;wen=1;end
 7'h67:begin result=pc+4;nextpc=(a+immI)&32'hfffffffe;wen=1;if(f3!=0)illegal=1;end
 7'h63:begin
  case(f3)
   0:branch_taken=a==b;1:branch_taken=a!=b;
   4:branch_taken=$signed(a)<$signed(b);5:branch_taken=$signed(a)>=$signed(b);
   6:branch_taken=a<b;7:branch_taken=a>=b;default:illegal=1;
  endcase
  if(branch_taken)nextpc=pc+immB;
 end
 7'h13:begin
  wen=1;
  case(f3)
   0:result=a+immI;2:result=$signed(a)<$signed(immI);3:result=a<immI;
   4:result=a^immI;6:result=a|immI;7:result=a&immI;
   1:begin result=a<<inst[24:20];if(f7!=0)illegal=1;end
   5:begin
    if(f7==0)result=a>>inst[24:20];
    else if(f7==7'h20)result=$signed(a)>>>inst[24:20];
    else illegal=1;
   end
  endcase
 end
 7'h33:begin
  wen=1;
  case(f3)
   0:if(f7==0)result=a+b;else if(f7==7'h20)result=a-b;else illegal=1;
   1:begin result=a<<b[4:0];if(f7!=0)illegal=1;end
   2:begin result=$signed(a)<$signed(b);if(f7!=0)illegal=1;end
   3:begin result=a<b;if(f7!=0)illegal=1;end
   4:begin result=a^b;if(f7!=0)illegal=1;end
   5:if(f7==0)result=a>>b[4:0];else if(f7==7'h20)result=$signed(a)>>>b[4:0];else illegal=1;
   6:begin result=a|b;if(f7!=0)illegal=1;end
   7:begin result=a&b;if(f7!=0)illegal=1;end
  endcase
 end
 7'h03:begin
  address=a+immI;wen=1;
  if(address>=256)illegal=1;
  else begin
   loadword=mem[address[7:2]];
   byteval=loadword>>(address[1:0]*8);
   halfval=loadword>>(address[1]*16);
   case(f3)
    0:result={{24{byteval[7]}},byteval};1:begin result={{16{halfval[15]}},halfval};if(address[0])illegal=1;end
    2:begin result=loadword;if(address[1:0]!=0)illegal=1;end
    4:result={24'b0,byteval};5:begin result={16'b0,halfval};if(address[0])illegal=1;end
    default:illegal=1;
   endcase
  end
 end
 7'h23:begin
  address=a+immS;mwe=1;
  if(address>=256)illegal=1;
  else begin
   storeword=mem[address[7:2]];
   case(f3)
    0:storeword=(storeword & ~(32'hff<<(address[1:0]*8)))|((b&255)<<(address[1:0]*8));
    1:begin storeword=(storeword & ~(32'hffff<<(address[1]*16)))|((b&65535)<<(address[1]*16));if(address[0])illegal=1;end
    2:begin storeword=b;if(address[1:0]!=0)illegal=1;end
    default:illegal=1;
   endcase
  end
 end
 7'h0f:begin if(f3!=0)illegal=1;end // FENCE as no-op in this single-core model
 7'h73:if(inst==32'h00100073)stop=1;else illegal=1;
 default:illegal=1;
 endcase
 if(nextpc[1:0]!=0)illegal=1;
end
always @(posedge clk) begin
 if(reset) begin
  pc<=0;retired<=0;halted<=0;trap<=0;
  last_pc<=0;last_inst<=0;last_wdata<=0;last_addr<=0;last_store<=0;
  last_rd<=0;last_wen<=0;last_mwe<=0;last_retire<=0;
  for(i=0;i<32;i=i+1)regs[i]<=0;
  for(i=0;i<64;i=i+1)mem[i]<=0;
 end else begin
  last_wen<=0;last_mwe<=0;last_retire<=0;
  if(!halted) begin
   last_pc<=pc;last_inst<=inst;
   if(illegal)begin halted<=1;trap<=1;end
   else begin
    if(wen && rd!=0)begin regs[rd]<=result;last_rd<=rd;last_wdata<=result;last_wen<=1;end
    if(mwe)begin mem[address[7:2]]<=storeword;last_addr<=address;last_store<=b;last_mwe<=1;end
    regs[0]<=0;pc<=nextpc;retired<=retired+1;last_retire<=1;
    if(stop)halted<=1;
   end
  end
 end
end
assign led=regs[3][15:0];
assign display=regs[3];
wire [31:0] dbg_pc=pc,dbg_inst=inst,dbg_retired=retired;
wire dbg_halted=halted,dbg_trap=trap,dbg_wen=last_wen,dbg_mwe=last_mwe,dbg_retire=last_retire;
wire [4:0] dbg_rd=last_rd;
wire [31:0] dbg_wdata=last_wdata,dbg_addr=last_addr,dbg_store=last_store,dbg_last_pc=last_pc,dbg_last_inst=last_inst;
wire [31:0] dbg_x0=regs[0];
wire [31:0] dbg_x1=regs[1];
wire [31:0] dbg_x2=regs[2];
wire [31:0] dbg_x3=regs[3];
wire [31:0] dbg_x4=regs[4];
wire [31:0] dbg_x5=regs[5];
wire [31:0] dbg_x6=regs[6];
wire [31:0] dbg_x7=regs[7];
wire [31:0] dbg_x8=regs[8];
wire [31:0] dbg_x9=regs[9];
wire [31:0] dbg_x10=regs[10];
wire [31:0] dbg_x11=regs[11];
wire [31:0] dbg_x12=regs[12];
wire [31:0] dbg_x13=regs[13];
wire [31:0] dbg_x14=regs[14];
wire [31:0] dbg_x15=regs[15];
wire [31:0] dbg_x16=regs[16];
wire [31:0] dbg_x17=regs[17];
wire [31:0] dbg_x18=regs[18];
wire [31:0] dbg_x19=regs[19];
wire [31:0] dbg_x20=regs[20];
wire [31:0] dbg_x21=regs[21];
wire [31:0] dbg_x22=regs[22];
wire [31:0] dbg_x23=regs[23];
wire [31:0] dbg_x24=regs[24];
wire [31:0] dbg_x25=regs[25];
wire [31:0] dbg_x26=regs[26];
wire [31:0] dbg_x27=regs[27];
wire [31:0] dbg_x28=regs[28];
wire [31:0] dbg_x29=regs[29];
wire [31:0] dbg_x30=regs[30];
wire [31:0] dbg_x31=regs[31];
wire [31:0] dbg_m0=mem[0];
wire [31:0] dbg_m1=mem[1];
wire [31:0] dbg_m2=mem[2];
wire [31:0] dbg_m3=mem[3];
wire [31:0] dbg_m4=mem[4];
wire [31:0] dbg_m5=mem[5];
wire [31:0] dbg_m6=mem[6];
wire [31:0] dbg_m7=mem[7];
wire [31:0] dbg_m8=mem[8];
wire [31:0] dbg_m9=mem[9];
wire [31:0] dbg_m10=mem[10];
wire [31:0] dbg_m11=mem[11];
wire [31:0] dbg_m12=mem[12];
wire [31:0] dbg_m13=mem[13];
wire [31:0] dbg_m14=mem[14];
wire [31:0] dbg_m15=mem[15];
wire [31:0] dbg_m16=mem[16];
wire [31:0] dbg_m17=mem[17];
wire [31:0] dbg_m18=mem[18];
wire [31:0] dbg_m19=mem[19];
wire [31:0] dbg_m20=mem[20];
wire [31:0] dbg_m21=mem[21];
wire [31:0] dbg_m22=mem[22];
wire [31:0] dbg_m23=mem[23];
wire [31:0] dbg_m24=mem[24];
wire [31:0] dbg_m25=mem[25];
wire [31:0] dbg_m26=mem[26];
wire [31:0] dbg_m27=mem[27];
wire [31:0] dbg_m28=mem[28];
wire [31:0] dbg_m29=mem[29];
wire [31:0] dbg_m30=mem[30];
wire [31:0] dbg_m31=mem[31];
wire [31:0] dbg_m32=mem[32];
wire [31:0] dbg_m33=mem[33];
wire [31:0] dbg_m34=mem[34];
wire [31:0] dbg_m35=mem[35];
wire [31:0] dbg_m36=mem[36];
wire [31:0] dbg_m37=mem[37];
wire [31:0] dbg_m38=mem[38];
wire [31:0] dbg_m39=mem[39];
wire [31:0] dbg_m40=mem[40];
wire [31:0] dbg_m41=mem[41];
wire [31:0] dbg_m42=mem[42];
wire [31:0] dbg_m43=mem[43];
wire [31:0] dbg_m44=mem[44];
wire [31:0] dbg_m45=mem[45];
wire [31:0] dbg_m46=mem[46];
wire [31:0] dbg_m47=mem[47];
wire [31:0] dbg_m48=mem[48];
wire [31:0] dbg_m49=mem[49];
wire [31:0] dbg_m50=mem[50];
wire [31:0] dbg_m51=mem[51];
wire [31:0] dbg_m52=mem[52];
wire [31:0] dbg_m53=mem[53];
wire [31:0] dbg_m54=mem[54];
wire [31:0] dbg_m55=mem[55];
wire [31:0] dbg_m56=mem[56];
wire [31:0] dbg_m57=mem[57];
wire [31:0] dbg_m58=mem[58];
wire [31:0] dbg_m59=mem[59];
wire [31:0] dbg_m60=mem[60];
wire [31:0] dbg_m61=mem[61];
wire [31:0] dbg_m62=mem[62];
wire [31:0] dbg_m63=mem[63];
endmodule
