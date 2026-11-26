module board_top(input clk, input reset, input [15:0] sw, input [4:0] btn,
 output [15:0] led, output [31:0] display);
// sw / btn / led / display 与板上器件颜色对应
assign led = sw ^ {11'b0,btn};
assign display = {16'b0,led};
endmodule
