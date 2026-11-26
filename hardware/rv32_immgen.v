// Combinational immediate generator; fmt is supplied by a separate decoder.
// 0=I, 1=S, 2=B, 3=U, 4=J. No instruction legality or jump execution here.
module rv32_immgen(input [31:0] inst,input [2:0] fmt,output reg [31:0] imm);
always @* begin
 case(fmt)
 0:imm={{20{inst[31]}},inst[31:20]};
 1:imm={{20{inst[31]}},inst[31:25],inst[11:7]};
 2:imm={{19{inst[31]}},inst[31],inst[7],inst[30:25],inst[11:8],1'b0};
 3:imm={inst[31:12],12'b0};
 4:imm={{11{inst[31]}},inst[31],inst[19:12],inst[20],inst[30:21],1'b0};
 default:imm=0;
 endcase
end
endmodule
