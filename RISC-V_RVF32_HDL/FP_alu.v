//Floating point alu unit
module FP_alu (input s_u, input [3:0] alu_control, input  [31:0] a, b, output reg  [31:0] result);
wire [5:0]a_flags,b_flags;
wire a_snan, a_qnan, a_infinity, a_zero, a_subnormal, a_normal;
wire b_snan, b_qnan, b_infinity, b_zero, b_subnormal, b_normal;
wire [31:0]a_fclass,b_fclass;
wire mod;
wire [31:0]res_add_sub,res_mull;
wire eq,lt,le,out_flag_NV,le_cmp;
wire [31:0] float_integr,integr_float;
wire out_flg_NV;

//classfication module
fp_class fp_class_a (a, a_snan, a_qnan, a_infinity, a_zero, a_subnormal, a_normal, a_fclass);
fp_class fp_class_b (b, b_snan, b_qnan, b_infinity, b_zero, b_subnormal, b_normal, b_fclass);
assign a_flags= {a_snan, a_qnan, a_infinity, a_zero, a_subnormal, a_normal};
assign b_flags= {b_snan, b_qnan, b_infinity, b_zero, b_subnormal, b_normal};

//adder/subtractor module
assign mod = (alu_control==4'd1)? 1'b1: 1'b0;
fp_add_sub fp_add_sub (mod,a,b,a_flags,b_flags,res_add_sub);

//Multilpier Module
FP_Mul FP_Mul (a,b,res_mull);

//compare module
fp_comp fp_comp (a,b,a_flags,b_flags,eq,lt,le,out_flag_NV,le_cmp);

//32-bit floating-point to 32-bit (signed/unsigned) integer
//s_u ==0  (signd) 
//s_u ==1  (unsignd) 
fp_cvt_f_i fp_cvt_f_i (s_u,a,float_integr,out_flg_NV);

//Convert 32-bit signed/unsignd integer into 32-bit floating point number. 
//s_u ==0  (signd) 
//s_u ==1  (unsignd)
fp_cvt_i_f fp_cvt_i_f (s_u,a,integr_float);


always@(*)
begin
    case (alu_control)
      4'd0:  result = res_add_sub;         // add
      4'd1:  result = res_add_sub;         // subtract
      4'd2:  result = res_mull;        		 // mul
    //4'd3:                                // div
 
      4'd4:  result = {31'd0,eq};          // feq
      4'd5:  result = {31'd0,lt};          // flt
      4'd6:  result = {31'd0,le};          // fle
 
      4'd7:  result = le_cmp ? a : b ;     // min
      4'd8:  result = le_cmp ? b : a ;     // max

      4'd9:  result = a_fclass ;           // fclass

      4'd10:  result = {b[31],a[30:0]} ;            // fsgnj
      4'd11:  result = {(~b[31]),a[30:0]} ;         // fsgnjn
      4'd12:  result = {(b[31] ^ a[31]),a[30:0]} ;  // fsgnjx

      4'd13:  result = float_integr ;              // fcvt.w.s  , fcvt.wu.s
      4'd14:  result = integr_float ;              // fcvt.s.w  , fcvt.s.wu
     
      default: result = 32'bx;
    endcase
end

endmodule 