// Teaching ALU: RV32 integer operations. Z/S/C/V are debug outputs,
// not an architectural RISC-V condition-code register. SUB C = no borrow.
module rv32_alu(input [31:0] a,b,input [3:0] op,output reg [31:0] y,output z,s,output reg c,v);
reg [32:0] extended;
always @* begin
 y=0;c=0;v=0;extended=0;
 case(op)
 0:begin extended={1'b0,a}+{1'b0,b};y=extended[31:0];c=extended[32];v=(a[31]==b[31])&&(y[31]!=a[31]);end
 1:begin y=a-b;c=(a>=b);v=(a[31]!=b[31])&&(y[31]!=a[31]);end
 2:y=a&b;
 3:y=a|b;
 4:y=a^b;
 5:y=a<<b[4:0];
 6:y=a>>b[4:0];
 7:y=$signed(a)>>>b[4:0];
 8:y=($signed(a)<$signed(b))?32'd1:32'd0;
 9:y=(a<b)?32'd1:32'd0;
 default:y=0;
 endcase
end
assign z=(y==0);
assign s=y[31];
endmodule
