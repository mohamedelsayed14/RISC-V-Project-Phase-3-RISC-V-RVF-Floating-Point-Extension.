//Convert 32-bit signed/unsignd integer into 32-bit floating point number. 
//s_u ==0  (signd) 
//s_u ==1  (unsignd)
module fp_cvt_i_f (input s_u, input [31:0] in_data, output [31:0] out_data);
wire fp_sign;
reg [7:0] fp_exp;
reg [22:0] fp_man;
wire [31:0] integer_num;
reg c;

assign integer_num = (in_data[31] & !s_u) ? (~ in_data + 1'b1) : in_data  ;
assign fp_sign = in_data[31] & !s_u;

always @(*) begin
c=1'b0;
     if(integer_num[31]) 	begin {c,fp_man}= integer_num[30:8]+integer_num[7]; 	fp_exp=8'd127+5'd31+c; end
else if(integer_num[30]) 	begin {c,fp_man}= integer_num[29:7]+integer_num[6]; 	fp_exp=8'd127+5'd30+c; end
else if(integer_num[29]) 	begin {c,fp_man}= integer_num[28:6]+integer_num[5]; 	fp_exp=8'd127+5'd29+c; end
else if(integer_num[28]) 	begin {c,fp_man}= integer_num[27:5]+integer_num[4]; 	fp_exp=8'd127+5'd28+c; end
else if(integer_num[27]) 	begin {c,fp_man}= integer_num[26:4]+integer_num[3]; 	fp_exp=8'd127+5'd27+c; end
else if(integer_num[26]) 	begin {c,fp_man}= integer_num[25:3]+integer_num[2]; 	fp_exp=8'd127+5'd26+c; end
else if(integer_num[25]) 	begin {c,fp_man}= integer_num[24:2]+integer_num[1];  	fp_exp=8'd127+5'd25+c; end
else if(integer_num[24]) 	begin {c,fp_man}= integer_num[23:1]+integer_num[0];    fp_exp=8'd127+5'd24+c; end
else if(integer_num[23]) 	begin    fp_man= integer_num[22:0];       				fp_exp=8'd127+5'd23; end
else if(integer_num[22]) 	begin    fp_man={integer_num[21:0],1'd0}; 				fp_exp=8'd127+5'd22; end
else if(integer_num[21]) 	begin    fp_man={integer_num[20:0],2'd0}; 				fp_exp=8'd127+5'd21; end
else if(integer_num[20]) 	begin    fp_man={integer_num[19:0],3'd0}; 				fp_exp=8'd127+5'd20; end
else if(integer_num[19]) 	begin    fp_man={integer_num[18:0],4'd0}; 				fp_exp=8'd127+5'd19; end
else if(integer_num[18]) 	begin    fp_man={integer_num[17:0],5'd0}; 				fp_exp=8'd127+5'd18; end
else if(integer_num[17]) 	begin    fp_man={integer_num[16:0],6'd0}; 				fp_exp=8'd127+5'd17; end
else if(integer_num[16]) 	begin    fp_man={integer_num[15:0],7'd0}; 				fp_exp=8'd127+5'd16; end
else if(integer_num[15]) 	begin    fp_man={integer_num[14:0],8'd0}; 				fp_exp=8'd127+5'd15; end
else if(integer_num[14]) 	begin    fp_man={integer_num[13:0],9'd0}; 				fp_exp=8'd127+5'd14; end
else if(integer_num[13]) 	begin    fp_man={integer_num[12:0],10'd0};				fp_exp=8'd127+5'd13; end
else if(integer_num[12]) 	begin    fp_man={integer_num[11:0],11'd0};				fp_exp=8'd127+5'd12; end
else if(integer_num[11]) 	begin    fp_man={integer_num[10:0],12'd0};				fp_exp=8'd127+5'd11; end
else if(integer_num[10]) 	begin    fp_man={integer_num[9:0],13'd0}; 				fp_exp=8'd127+5'd10; end
else if(integer_num[9])  	begin    fp_man={integer_num[8:0],14'd0}; 				fp_exp=8'd127+5'd9; end
else if(integer_num[8])  	begin    fp_man={integer_num[7:0],15'd0}; 				fp_exp=8'd127+5'd8; end
else if(integer_num[7])  	begin    fp_man={integer_num[6:0],16'd0}; 				fp_exp=8'd127+5'd7; end
else if(integer_num[6])  	begin    fp_man={integer_num[5:0],17'd0}; 				fp_exp=8'd127+5'd6; end
else if(integer_num[5])  	begin    fp_man={integer_num[4:0],18'd0}; 				fp_exp=8'd127+5'd5; end
else if(integer_num[4])  	begin    fp_man={integer_num[3:0],19'd0}; 				fp_exp=8'd127+5'd4; end
else if(integer_num[3])  	begin    fp_man={integer_num[2:0],20'd0}; 				fp_exp=8'd127+5'd3; end
else if(integer_num[2])  	begin    fp_man={integer_num[1:0],21'd0}; 				fp_exp=8'd127+5'd2; end
else if(integer_num[1])  	begin    fp_man={integer_num[0],22'd0};   				fp_exp=8'd127+5'd1; end
else if(integer_num[0])  	begin    fp_man=23'd0;                    				fp_exp=8'd127; end
else                     	begin    fp_man=23'd0;                    				fp_exp=8'd0; end
end

assign out_data={fp_sign,fp_exp,fp_man};
endmodule