// A teaching microarchitecture, not an ISA-mandated physical implementation.
// Combinational dual read, rising-edge single write, synchronous clear,
// optional same-address bypass. x0 is always zero.
module rv32_regfile(input clk,reset,we,bypass,input [4:0] ra,rb,wa,input [31:0] wd,output [31:0] qa,qb);
reg [31:0] regs[0:31];integer i;
always @(posedge clk) begin
 if(reset)for(i=0;i<32;i=i+1)regs[i]<=32'b0;
 else if(we&&wa!=0)regs[wa]<=wd;
 regs[0]<=0;
end
assign qa=ra==0?32'b0:(bypass&&we&&!reset&&wa==ra)?wd:regs[ra];
assign qb=rb==0?32'b0:(bypass&&we&&!reset&&wa==rb)?wd:regs[rb];
endmodule
