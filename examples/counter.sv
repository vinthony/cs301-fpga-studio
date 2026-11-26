module board_top(input clk, input reset, input [15:0] sw, input [4:0] btn,
 output [15:0] led, output [31:0] display);
reg [31:0] count;
always @(posedge clk) begin
 if(reset) count<=0;
 else if(sw[0]) count<=count+1;
end
assign led=count[15:0];
assign display=count;
endmodule
