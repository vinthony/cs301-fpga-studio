module board_top(input clk, input reset, input [15:0] sw, input [4:0] btn,
 output [15:0] led, output [31:0] display);
reg [1:0] state;
reg hit;
always @(posedge clk) begin
 if(reset) begin state<=0;hit<=0;end
 else begin
  hit<=0;
  case(state)
   0:state<=sw[0]?1:0;
   1:state<=sw[0]?1:2;
   2:begin hit<=sw[0];state<=sw[0]?1:0;end
   default:state<=0;
  endcase
 end
end
assign led={15'b0,hit};
assign display={30'b0,state};
endmodule
