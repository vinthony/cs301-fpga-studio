module board_top(input clk, input reset, input [15:0] sw, input [4:0] btn,
 output [15:0] led, output [31:0] display);
wire [3:0] a=sw[3:0], b=sw[7:4];
wire [4:0] sum={1'b0,a}+{1'b0,b};
assign led={11'b0,sum};
assign display={27'b0,sum};
endmodule
