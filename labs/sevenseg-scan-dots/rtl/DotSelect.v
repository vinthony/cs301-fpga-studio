// Four requests are active high. The shared dp output is active low.
// This combinational circuit does not include digit enable or a scan clock.
module DotMux2(input wire a, b, sel, output wire y);
 wire nsel, low_branch, high_branch;
 not (nsel, sel);
 and (low_branch, a, nsel);
 and (high_branch, b, sel);
 or (y, low_branch, high_branch);
endmodule

module DotSelect(input wire [3:0] requests, input wire [1:0] digit,
 output wire low_group, high_group, selected, dp);
 DotMux2 M0(requests[0], requests[1], digit[0], low_group);
 DotMux2 M1(requests[2], requests[3], digit[0], high_group);
 DotMux2 M2(low_group, high_group, digit[1], selected);
 not INV(dp, selected);
endmodule
