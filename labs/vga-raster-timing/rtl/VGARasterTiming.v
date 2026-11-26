// Fixed teaching mode: 800x521 total, 640x480 visible.
// The input clock is already the pixel clock; no PLL or clock divider here.
module VGARasterTiming(
 input wire clk, reset, enable,
 input wire [11:0] color,
 output wire [9:0] x,y,next_x,next_y,
 output wire active,hs,vs,address_valid,line_enable,
 output wire [18:0] address,
 output wire [11:0] rgb
);
 wire x_terminal;
 RasterCounter horizontal(.clk(clk),.reset(reset),.enable(enable),.limit(10'd799),
  .q(x),.increment(),.terminal(x_terminal),.d(),.next_q(next_x));
 assign line_enable = enable && x_terminal;
 RasterCounter vertical(.clk(clk),.reset(reset),.enable(line_enable),.limit(10'd520),
  .q(y),.increment(),.terminal(),.d(),.next_q(next_y));
 assign active = (x < 10'd640) && (y < 10'd480);
 assign hs = !((x >= 10'd656) && (x < 10'd752));
 assign vs = !((y >= 10'd490) && (y < 10'd492));
 assign address_valid = active;
 assign address = active ? ({9'b0,y} * 19'd640 + {9'b0,x}) : 19'd0;
 assign rgb = active ? color : 12'd0;
endmodule
