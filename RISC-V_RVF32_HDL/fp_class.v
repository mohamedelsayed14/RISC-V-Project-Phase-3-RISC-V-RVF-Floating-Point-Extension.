//Identify value type of floating point number
module fp_class (input [31:0] fp_num, output snan, qnan, infinity, zero, subnormal, normal,output [31:0] fclass);

  wire sign,expOnes, expZeroes, manZeroes;
  assign sign      =   fp_num[31];
  assign expOnes   =  &fp_num[30:23];
  assign expZeroes = ~|fp_num[30:23];
  assign manZeroes = ~|fp_num[22:0];

  assign snan      =  expOnes   & ~fp_num[22] & ~manZeroes;
  assign qnan      =  expOnes   &  fp_num[22];
  assign infinity  =  expOnes   &  manZeroes;
  assign zero      =  expZeroes &  manZeroes;
  assign subnormal =  expZeroes & ~manZeroes;
  assign normal    = ~expOnes   & ~expZeroes;
////////////////////////////////////////////////
// RD BIT | MEANING
//--------|-------------------------------------
//    0   | rs1 is negative infinity
//    1   | rs1 is a negative normal number
//    2   | rs1 is a negative subnormal number
//    3   | rs1 is negative zero
//    4   | rs1 is positive zero
//    5   | rs1 is a positive subnormal number
//    6   | rs1 is a positive normal number
//    7   | rs1 is positive infinity
//    8   | rs1 is a signaling NaN
//    9   | rs1 is a quite NaN

assign fclass[0] = (sign && infinity)   ? 1'b1 : 1'b0;
assign fclass[1] = (sign && normal)     ? 1'b1 : 1'b0;
assign fclass[2] = (sign && subnormal)  ? 1'b1 : 1'b0;
assign fclass[3] = (sign && zero)       ? 1'b1 : 1'b0;
assign fclass[4] = (!sign && zero)      ? 1'b1 : 1'b0;
assign fclass[5] = (!sign && subnormal) ? 1'b1 : 1'b0;
assign fclass[6] = (!sign && normal)    ? 1'b1 : 1'b0;
assign fclass[7] = (!sign && infinity)  ? 1'b1 : 1'b0;
assign fclass[8] = (snan)               ? 1'b1 : 1'b0;
assign fclass[9] = (qnan)               ? 1'b1 : 1'b0;
assign fclass[31:10] = 22'd0;

endmodule