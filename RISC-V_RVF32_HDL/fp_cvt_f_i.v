//32-bit floating-point to 32-bit (signed/unsigned) integer
//s_u ==0  (signd) 
//s_u ==1  (unsignd)  
module fp_cvt_f_i (input s_u, input [31:0] in_data, output [31:0] out_data,output out_flg_NV);
wire    [54:0] shifted_num, mant;
wire    sign, invalid_case_1, invalid_case_2;
wire    [7:0] exp, exp_abs;
wire    [31:0] num,output_su;

assign sign = in_data[31];
assign exp = in_data[30:23] - 8'd127;
assign mant = {32'd1, in_data[22:0]}; //hiden bit

assign shifted_num = mant << exp[5:0];
assign num =  shifted_num[54:23];  //integer number
assign output_su = (sign & !s_u) ? (~ num + 1'd1) : num;

assign out_data = (exp[7]) ? 32'd0 : output_su; // The exponent is negative, which means fraction number >> integer=0

// Get absolute value of exponent
assign exp_abs = (exp[7]) ? (~exp + 8'd1) : exp;

// Check if the input number can fit in 32 bit ?
// If it could, NV flag is zero, otherwise, it is true
assign invalid_case_1 = ((exp_abs > 8'd31) & (s_u == 1'b0)) ? 1'b1 : 1'b0;
assign invalid_case_2 = ((exp_abs > 8'd32) & (s_u == 1'b1)) ? 1'b1 : 1'b0;
assign out_flg_NV = invalid_case_1 | invalid_case_2;
endmodule