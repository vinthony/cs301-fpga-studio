module board_top(input clk, input reset, input [15:0] sw, input [4:0] btn,
 output [15:0] led, output [31:0] display);
// 教学流水线：只执行内嵌的三条 ADDI，不是完整 RV32I 核。
// SW0=1 启用 EX/MEM、MEM/WB 前递；SW0=0 会出现 RAW 冒险。
reg [31:0] regs[0:3];
reg [31:0] pc,retired;
reg id_v,ex_v,mem_v,wb_v;
reg [31:0] id_pc,ex_pc,mem_pc,wb_pc;
reg [1:0] id_rs,id_rd,ex_rs,ex_rd,mem_rd,wb_rd;
reg [31:0] id_imm,ex_imm,ex_a,mem_y,wb_y;
reg [31:0] operand;
integer i;
always @* begin
 operand=ex_a;
 if(1'b0 && wb_v && wb_rd!=0 && wb_rd==ex_rs)operand=wb_y;
 if(1'b0 && mem_v && mem_rd!=0 && mem_rd==ex_rs)operand=mem_y;
end
always @(posedge clk) begin
 if(reset) begin
  pc<=0;retired<=0;id_v<=0;ex_v<=0;mem_v<=0;wb_v<=0;
  id_pc<=0;ex_pc<=0;mem_pc<=0;wb_pc<=0;
  id_rs<=0;id_rd<=0;ex_rs<=0;ex_rd<=0;mem_rd<=0;wb_rd<=0;
  id_imm<=0;ex_imm<=0;ex_a<=0;mem_y<=0;wb_y<=0;
  for(i=0;i<4;i=i+1)regs[i]<=0;
 end else begin
  if(wb_v)begin if(wb_rd!=0)regs[wb_rd]<=wb_y;retired<=retired+1;end
  wb_v<=mem_v;wb_pc<=mem_pc;wb_rd<=mem_rd;wb_y<=mem_y;
  mem_v<=ex_v;mem_pc<=ex_pc;mem_rd<=ex_rd;mem_y<=operand+ex_imm;
  ex_v<=id_v;ex_pc<=id_pc;ex_rd<=id_rd;ex_rs<=id_rs;ex_imm<=id_imm;ex_a<=regs[id_rs];
  id_v<=pc<12;id_pc<=pc;
  case(pc)
   0:begin id_rs<=0;id_rd<=1;id_imm<=5;end
   4:begin id_rs<=1;id_rd<=2;id_imm<=1;end
   8:begin id_rs<=2;id_rd<=3;id_imm<=1;end
   default:begin id_rs<=0;id_rd<=0;id_imm<=0;end
  endcase
  if(pc<12)pc<=pc+4;
 end
end
assign display=regs[3];assign led=regs[3][15:0];
wire [31:0] dbg_pc=pc,dbg_retired=retired;
wire dbg_halted=(retired==3),dbg_trap=0;
wire [31:0] dbg_x0=0,dbg_x1=regs[1],dbg_x2=regs[2],dbg_x3=regs[3];
wire [31:0] dbg_if_pc=pc,dbg_id_pc=id_pc,dbg_ex_pc=ex_pc,dbg_mem_pc=mem_pc,dbg_wb_pc=wb_pc;
wire dbg_if_valid=pc<12,dbg_id_valid=id_v,dbg_ex_valid=ex_v,dbg_mem_valid=mem_v,dbg_wb_valid=wb_v;
endmodule
