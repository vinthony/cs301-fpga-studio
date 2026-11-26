// A synchronous 10-bit teaching counter. No derived/gated clocks.
module RasterCounter(
 input wire clk, reset, enable,
 input wire [9:0] limit,
 output reg [9:0] q,
 output wire [10:0] increment,
 output wire terminal,
 output wire [9:0] d,
 output wire [9:0] next_q
);
 assign increment = {1'b0,q} + 11'd1;
 assign terminal = q == limit;
 assign d = terminal ? 10'd0 : increment[9:0];
 assign next_q = reset ? 10'd0 : enable ? d : q;
 always @(posedge clk) q <= next_q;
endmodule
