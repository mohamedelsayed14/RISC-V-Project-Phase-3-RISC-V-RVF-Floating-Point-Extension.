//floating point multiplication module
module FP_Mul (input [31:0] in_numA, in_numB, output [31:0] out_result);
wire    result_sign;
wire    [7:0] result_exp, normalised_exp, sp_final_exp;
wire    [23:0] normalised_mant;
wire    [31:0] numA, numB;
wire    [47:0] product_mant;

assign numA = {in_numA[31], (in_numA[30:23] - 8'd127), in_numA[22:0]};
assign numB = {in_numB[31], (in_numB[30:23] - 8'd127), in_numB[22:0]};

assign result_sign = numA[31] ^ numB[31];
assign result_exp = normalised_exp + 8'd127;


//Mantisa Multiplier
wire [47:0] in_multiplicand;
wire [23:0] in_multiplier;
wire [47:0] product_0, product_1, product_2, product_3, product_4, product_5, product_6, product_7, product_8, product_9,
            product_10, product_11, product_12, product_13, product_14, product_15, product_16, product_17, product_18, product_19,
            product_20, product_21, product_22, product_23;
assign in_multiplicand={25'd1, numA[22:0]};
assign in_multiplier={1'b1, numB[22:0]};

assign product_0  =  (in_multiplier[0]) ? in_multiplicand : 48'd0;
assign product_1  =  (in_multiplier[1]) ? (in_multiplicand << 1) : 48'd0;
assign product_2  =  (in_multiplier[2]) ? (in_multiplicand << 2) : 48'd0;
assign product_3  =  (in_multiplier[3]) ? (in_multiplicand << 3) : 48'd0;
assign product_4  =  (in_multiplier[4]) ? (in_multiplicand << 4) : 48'd0;
assign product_5  =  (in_multiplier[5]) ? (in_multiplicand << 5) : 48'd0;
assign product_6  =  (in_multiplier[6]) ? (in_multiplicand << 6) : 48'd0;
assign product_7  =  (in_multiplier[7]) ? (in_multiplicand << 7) : 48'd0;
assign product_8  =  (in_multiplier[8]) ? (in_multiplicand << 8) : 48'd0;
assign product_9  =  (in_multiplier[9]) ? (in_multiplicand << 9) : 48'd0;
assign product_10 = (in_multiplier[10]) ? (in_multiplicand << 10) : 48'd0;
assign product_11 = (in_multiplier[11]) ? (in_multiplicand << 11) : 48'd0;
assign product_12 = (in_multiplier[12]) ? (in_multiplicand << 12) : 48'd0;
assign product_13 = (in_multiplier[13]) ? (in_multiplicand << 13) : 48'd0;
assign product_14 = (in_multiplier[14]) ? (in_multiplicand << 14) : 48'd0;
assign product_15 = (in_multiplier[15]) ? (in_multiplicand << 15) : 48'd0;
assign product_16 = (in_multiplier[16]) ? (in_multiplicand << 16) : 48'd0;
assign product_17 = (in_multiplier[17]) ? (in_multiplicand << 17) : 48'd0;
assign product_18 = (in_multiplier[18]) ? (in_multiplicand << 18) : 48'd0;
assign product_19 = (in_multiplier[19]) ? (in_multiplicand << 19) : 48'd0;
assign product_20 = (in_multiplier[20]) ? (in_multiplicand << 20) : 48'd0;
assign product_21 = (in_multiplier[21]) ? (in_multiplicand << 21) : 48'd0;
assign product_22 = (in_multiplier[22]) ? (in_multiplicand << 22) : 48'd0;
assign product_23 = (in_multiplier[23]) ? (in_multiplicand << 23) : 48'd0;

    assign product_mant = (((product_0 + product_1) + (product_2 + product_3)) + ((product_4 + product_5) + (product_6 + product_7))) 
                            + (((product_8 + product_9) + (product_10 + product_11)) + ((product_12 + product_13) + (product_14 + product_15))) 
                            + (((product_16 + product_17) + (product_18 + product_19)) + ((product_20 + product_21) + (product_22 + product_23)));

// Multiplier Normaliser
wire [7:0] in_Exp;
assign in_Exp=numA[30:23] + numB[30:23];
assign normalised_exp = (product_mant[47]) ? (in_Exp + 8'd1) : in_Exp;
assign normalised_mant = (product_mant[47]) ? product_mant[47:24] : product_mant[46:23];

//Final Result
assign sp_final_exp = (normalised_mant == 24'd0) ? 8'd0 : result_exp;
assign out_result = {result_sign, sp_final_exp, normalised_mant[22:0]};

endmodule