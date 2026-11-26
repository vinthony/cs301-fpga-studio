module board_top(input clk, input reset, input [15:0] sw, input [4:0] btn,
 output [15:0] led, output [31:0] display);
wire [3:0] a=sw[3:0], b=sw[7:4];
reg [3:0] y;
always @* begin
 case(sw[10:8])
 0:y=a+b; 1:y=a-b; 2:y=a&b; 3:y=a|b;
 4:y=a^b; 5:y=a<<b[1:0]; 6:y=a>>b[1:0];
 7:y={3'b0,($signed(a)<$signed(b))};
 default:y=0;
 endcase
end
assign led={12'b0,y};
assign display={28'b0,y};
endmodule
