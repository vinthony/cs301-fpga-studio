module basys_top(input clk, input [15:0] sw,
 input btnC,btnU,btnL,btnR,btnD,
 output [15:0] led, output reg [6:0] seg,
 output reg [3:0] an, output dp);
// 共阳极显示：an 和 seg 都是低有效。BTNC 是本示例的同步复位。
// 教学演示每个时钟切换一位；实体板应调大 DIV 到 100000 左右。
parameter DIV=1;
reg [16:0] divider;
reg [1:0] digit;
reg [3:0] value;
always @(posedge clk) begin
 if(btnC) begin divider<=0;digit<=0;end
 else if(divider==DIV-1) begin divider<=0;digit<=digit+1;end
 else divider<=divider+1;
end
always @* begin
 an=~(4'b0001<<digit);
 case(digit)
 0:value=sw[3:0];1:value=sw[7:4];2:value=sw[11:8];3:value=sw[15:12];
 default:value=0;
 endcase
 case(value)
 0:seg=7'b1000000;1:seg=7'b1111001;2:seg=7'b0100100;3:seg=7'b0110000;
 4:seg=7'b0011001;5:seg=7'b0010010;6:seg=7'b0000010;7:seg=7'b1111000;
 8:seg=7'b0000000;9:seg=7'b0010000;10:seg=7'b0001000;11:seg=7'b0000011;
 12:seg=7'b1000110;13:seg=7'b0100001;14:seg=7'b0000110;15:seg=7'b0001110;
 default:seg=7'b1111111;
 endcase
end
assign dp=1'b1;
assign led=sw ^ {11'b0,btnD,btnR,btnL,btnU,btnC};
endmodule
