module TagEqual5(input wire [4:0] request_tag, saved_tag,
 output wire [4:0] different, same_bit,
 output wire low_two, middle_two, low_four, equal);
 genvar i;
 generate for(i=0;i<5;i=i+1)begin: BIT
  xor X(different[i],request_tag[i],saved_tag[i]);
  not N(same_bit[i],different[i]);
 end endgenerate
 and E01(low_two,same_bit[0],same_bit[1]);
 and E23(middle_two,same_bit[2],same_bit[3]);
 and E03(low_four,low_two,middle_two);
 and E04(equal,low_four,same_bit[4]);
endmodule

module CacheTagHit(input wire [4:0] request_tag, saved_tag,
 input wire valid,
 output wire [4:0] different, same_bit,
 output wire low_two, middle_two, low_four, equal, hit);
 TagEqual5 EQ(request_tag,saved_tag,different,same_bit,low_two,middle_two,low_four,equal);
 and VALID_AND(hit,equal,valid);
endmodule
