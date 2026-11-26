// Teaching scan driver: synchronous reset, clock enable, 3 observation phases.
module SevenSegmentScan(
 input wire clk, input wire reset, input wire step,
 input wire [15:0] word,
 output reg [1:0] digit, output reg [1:0] phase,
 output wire [3:0] an, output wire [6:0] seg, output wire dp
);
 reg [6:0] on_mask;
 wire [3:0] nibble = (word >> (digit * 4)) & 4'hf;
 always @* begin
  case (nibble)
   0:on_mask=7'h3f; 1:on_mask=7'h06; 2:on_mask=7'h5b; 3:on_mask=7'h4f;
   4:on_mask=7'h66; 5:on_mask=7'h6d; 6:on_mask=7'h7d; 7:on_mask=7'h07;
   8:on_mask=7'h7f; 9:on_mask=7'h6f; 10:on_mask=7'h77; 11:on_mask=7'h7c;
   12:on_mask=7'h39; 13:on_mask=7'h5e; 14:on_mask=7'h79; default:on_mask=7'h71;
  endcase
 end
 assign seg = ~on_mask;
 assign an = phase == 2 ? ~(4'b0001 << digit) : 4'b1111;
 assign dp = 1'b1;
 always @(posedge clk) begin
  if (reset) begin digit <= 0; phase <= 2; end
  else if (step) begin
   if (phase == 2) begin phase <= 0; digit <= digit + 1'b1; end
   else phase <= phase + 1'b1;
  end
 end
endmodule
