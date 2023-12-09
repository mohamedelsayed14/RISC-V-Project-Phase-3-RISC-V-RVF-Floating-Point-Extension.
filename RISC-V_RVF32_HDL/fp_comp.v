//floating point compare module
module fp_comp (input [31:0] a,b,input [5:0] a_flags,b_flags, output eq,lt,le,out_flag_NV,le_cmp);
//slicing inputs
wire a_snan, a_qnan;
wire b_snan, b_qnan;
assign {a_snan, a_qnan} = a_flags[5:4];
assign {b_snan, b_qnan} = b_flags[5:4];

wire a_sign,b_sign;
wire [7:0]a_exp,b_exp;
wire [22:0]a_man,b_man;
assign a_sign=a[31];
assign a_exp=a[30:23];
assign a_man=a[22:0];
assign b_sign=b[31] ;
assign b_exp=b[30:23];
assign b_man=b[22:0];

wire NaN_exception, numA_sp_exception, numB_sp_exception;
wire eq_cmp,lt_cmp1,lt_cmp2,lt_cmp3;
wire sign_cmp,exp_cmp;
//////////////////////////////////////////////////////////////////exciption nan
assign numA_sp_exception=a_snan | a_qnan;
assign numB_sp_exception=b_snan | b_qnan;
assign NaN_exception = numA_sp_exception | numB_sp_exception;
assign out_flag_NV = NaN_exception;
////////////////////////////////////////////////////////////////////////////////

// EQU Comparison
assign eq = (NaN_exception) ? 1'd0 : eq_cmp;
assign eq_cmp = (a == b) ? 1'd1 : 1'd0;

// LT Comparison
assign lt = (NaN_exception) ? 1'd0 : lt_cmp1;
assign sign_cmp = (a_sign & !b_sign) ? 1'd1 : 1'd0;
assign exp_cmp = (a_exp < b_exp) ? 1'd1 : 1'd0;
assign lt_cmp1 = (a_sign == b_sign) ? lt_cmp2 : sign_cmp;
assign lt_cmp2 = (a_exp == a_exp) ? lt_cmp3 : exp_cmp;
assign lt_cmp3 = (a_man < b_man) ? 1'd1 : 1'd0;

// LTE Comparison
assign le = (NaN_exception) ? 1'd0 : le_cmp;
assign le_cmp = (eq_cmp | lt_cmp1) ? 1'd1 : 1'd0;

endmodule