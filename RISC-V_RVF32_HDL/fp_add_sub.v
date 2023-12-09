//floating point adder / subtractor
module fp_add_sub (input mod, input [31:0] a,b,input [5:0] a_flags,b_flags, output  [31:0] res);
//slicing inputs
wire a_snan, a_qnan, a_infinity, a_zero, a_subnormal, a_normal;
wire b_snan, b_qnan, b_infinity, b_zero, b_subnormal, b_normal;
assign {a_snan, a_qnan, a_infinity, a_zero, a_subnormal, a_normal} = a_flags;
assign {b_snan, b_qnan, b_infinity, b_zero, b_subnormal, b_normal} = b_flags;

wire a_sign,b_sign;
wire [7:0]a_exp,b_exp;
wire [22:0]a_man,b_man;
assign a_sign=a[31];
assign a_exp=a[30:23];
assign a_man=a[22:0];
assign b_sign=b[31] ^ mod; //invert sign of second operand in case of subtraction
assign b_exp=b[30:23];
assign b_man=b[22:0];

reg res_sign;
reg [7:0]res_exp;
reg [22:0]res_man;
assign res[31]=res_sign;
assign res[30:23]=res_exp;
assign res[22:0]=res_man;

reg [7:0]shift_amt;
reg [7:0] intermed_exp, intermed_exp9,max_exp_sh; // non_normalized and normalized exp and max_shift_amount

reg [25:0] a_man_adj,b_man_adj,a_man_adj_ns,b_man_adj_ns;
reg  [25:0]  a_25,b_25,res_25;

reg [25:0] intermed_man;
reg [23:0]intermed_man2;  //normalized mantisa

reg overflow, underflow;

/////////////////////////////////////////////////////////////////////////////////////////
always @(*) begin
a_man_adj_ns = a_normal ? {3'b001,a_man} : {3'b000,a_man};
b_man_adj_ns = b_normal ? {3'b001,b_man} : {3'b000,b_man};

//to prevent latchs
overflow=1'b0;
underflow=1'b0;
intermed_exp9=8'd0;
max_exp_sh=8'd0;
intermed_exp=8'd0;
shift_amt=8'd0;
a_man_adj=26'd0;
b_man_adj=26'd0;
a_25=26'd0;
b_25=26'd0;
res_25=26'd0;
intermed_man=26'd0;
intermed_man2=24'd0;
//////////////////////////
if (a_snan | b_snan)
      begin
        {res_sign,res_exp,res_man} = a_snan ? a : b;
      end
else if (a_qnan | b_qnan)
      begin
        {res_sign,res_exp,res_man} = a_qnan ? a : b;
      end
else if (a_infinity | b_infinity)
      begin
        {res_sign,res_exp,res_man} = a_infinity ? a : b;
      end      
else if (a_zero & b_zero)
      begin
        {res_sign,res_exp,res_man} = 0;
      end
else begin
/////////////////////////////////////////////////////////////////////////////////////// normal or sub normal

//exponents comparasion and adjust manstesa of smaller
    if((a_exp ==8'd0) && (b_exp==8'd0)) begin
      intermed_exp=a_exp-8'd127;
      a_man_adj=a_man_adj_ns;
      b_man_adj=b_man_adj_ns;
    end
    else if(a_exp >= b_exp) begin  //b is smaller
      intermed_exp=a_exp-8'd127;
      shift_amt= b_exp?(a_exp-8'd127)-(b_exp-8'd127):(a_exp-8'd127)-(b_exp-8'd127)-8'd1;
      a_man_adj=a_man_adj_ns;
      b_man_adj=b_man_adj_ns >> shift_amt[7:0];
    end
    else begin  //a is samller
      intermed_exp=b_exp-8'd127;
      shift_amt=a_exp?(b_exp-8'd127)-(a_exp-8'd127):(b_exp-8'd127)-(a_exp-8'd127)-8'd1;
      b_man_adj=b_man_adj_ns;
      a_man_adj=a_man_adj_ns >> shift_amt[7:0];      
    end

//concatinate sign and mantisa and add or sub depend on (mod) 
 a_25=a_sign ? (~a_man_adj+1'd1) : a_man_adj ;
 b_25=b_sign ? (~b_man_adj+1'd1) : b_man_adj ;
 res_25= a_25 + b_25;
 intermed_man=res_25[25] ? (~res_25+1'd1) : res_25 ;
 res_sign=res_25[25];
 
////////////////////////////////////////////////
 //normalization to standard format

 if( (a_subnormal & b_subnormal) || (a_subnormal & b_zero) || (a_zero & b_subnormal))  //sub normal expected result
 begin
    if (intermed_man[23] == 1'b1) begin 
      intermed_man2=intermed_man[23:0];
      intermed_exp9=intermed_exp+1'd1;
     end
     else begin
      intermed_man2= intermed_man[23:0];
      intermed_exp9=intermed_exp;
     end
res_exp=intermed_exp9+8'd127;
res_man=intermed_man2[22:0];
 end 
 else begin //at least normal operand exists
//carry exists??
     if (intermed_man[24] == 1'b1) begin 
      intermed_man2= {1'b1,intermed_man[23:2],intermed_man[1]}; //to round to top {intermed_man[1]||intermed_man[0]}
      intermed_exp9=intermed_exp+1'b1;
     end
     else begin
      intermed_man2= intermed_man[23:0];
      intermed_exp9=intermed_exp;
     end

 //normalize result

 max_exp_sh=intermed_exp9+8'd126;
if (intermed_man2[23]==1'b1) begin res_man=intermed_man2[22:0]; res_exp=intermed_exp9+8'd127; end
else if (intermed_man2[22]==1'b1)   begin if(( 1 > max_exp_sh))
                                             begin res_man=intermed_man2[22:0]<<max_exp_sh; res_exp=intermed_exp9-max_exp_sh+8'd126; end
                                        else begin res_man={intermed_man2[21:0],1'd0}; res_exp=intermed_exp9-8'd1+8'd127; end
                                    end
else if (intermed_man2[21]==1'b1)   begin if(( 2 > max_exp_sh))
                                             begin res_man=intermed_man2[22:0]<<max_exp_sh; res_exp=intermed_exp9-max_exp_sh+8'd126; end
                                        else begin res_man={intermed_man2[20:0],2'd0}; res_exp=intermed_exp9-8'd2+8'd127; end
                                    end
else if (intermed_man2[20]==1'b1)   begin if(( 3 > max_exp_sh))
                                             begin res_man=intermed_man2[22:0]<<max_exp_sh; res_exp=intermed_exp9-max_exp_sh+8'd126; end
                                        else begin res_man={intermed_man2[19:0],3'd0}; res_exp=intermed_exp9-8'd3+8'd127; end
                                    end
else if (intermed_man2[19]==1'b1)   begin if(( 4 > max_exp_sh))
                                             begin res_man=intermed_man2[22:0]<<max_exp_sh; res_exp=intermed_exp9-max_exp_sh+8'd126; end
                                        else begin res_man={intermed_man2[18:0],4'd0}; res_exp=intermed_exp9-8'd4+8'd127; end
                                    end                                    
else if (intermed_man2[18]==1'b1)   begin if(( 5 > max_exp_sh))
                                             begin res_man=intermed_man2[22:0]<<max_exp_sh; res_exp=intermed_exp9-max_exp_sh+8'd126; end
                                        else begin res_man={intermed_man2[17:0],5'd0}; res_exp=intermed_exp9-8'd5+8'd127; end
                                    end
else if (intermed_man2[17]==1'b1)   begin if(( 6 > max_exp_sh))
                                             begin res_man=intermed_man2[22:0]<<max_exp_sh; res_exp=intermed_exp9-max_exp_sh+8'd126; end
                                        else begin res_man={intermed_man2[16:0],6'd0}; res_exp=intermed_exp9-8'd6+8'd127; end
                                    end
else if (intermed_man2[16]==1'b1)   begin if(( 7 > max_exp_sh))
                                             begin res_man=intermed_man2[22:0]<<max_exp_sh; res_exp=intermed_exp9-max_exp_sh+8'd126; end
                                        else begin res_man={intermed_man2[15:0],7'd0}; res_exp=intermed_exp9-8'd7+8'd127; end
                                    end
else if (intermed_man2[15]==1'b1)   begin if(( 8 > max_exp_sh))
                                             begin res_man=intermed_man2[22:0]<<max_exp_sh; res_exp=intermed_exp9-max_exp_sh+8'd126; end
                                        else begin res_man={intermed_man2[14:0],8'd0}; res_exp=intermed_exp9-8'd8+8'd127; end
                                    end
else if (intermed_man2[14]==1'b1)   begin if(( 9 > max_exp_sh))
                                             begin res_man=intermed_man2[22:0]<<max_exp_sh; res_exp=intermed_exp9-max_exp_sh+8'd126; end
                                        else begin res_man={intermed_man2[13:0],9'd0}; res_exp=intermed_exp9-8'd9+8'd127; end
                                    end
else if (intermed_man2[13]==1'b1)   begin if(( 10 > max_exp_sh))
                                             begin res_man=intermed_man2[22:0]<<max_exp_sh; res_exp=intermed_exp9-max_exp_sh+8'd126; end
                                        else begin res_man={intermed_man2[12:0],10'd0}; res_exp=intermed_exp9-8'd10+8'd127; end
                                    end
else if (intermed_man2[12]==1'b1)   begin if(( 11 > max_exp_sh))
                                             begin res_man=intermed_man2[22:0]<<max_exp_sh; res_exp=intermed_exp9-max_exp_sh+8'd126; end
                                        else begin res_man={intermed_man2[11:0],11'd0}; res_exp=intermed_exp9-8'd11+8'd127; end
                                    end
else if (intermed_man2[11]==1'b1)   begin if(( 12 > max_exp_sh))
                                             begin res_man=intermed_man2[22:0]<<max_exp_sh; res_exp=intermed_exp9-max_exp_sh+8'd126; end
                                        else begin res_man={intermed_man2[10:0],12'd0}; res_exp=intermed_exp9-8'd12+8'd127; end
                                    end
else if (intermed_man2[10]==1'b1)   begin if(( 13 > max_exp_sh))
                                             begin res_man=intermed_man2[22:0]<<max_exp_sh; res_exp=intermed_exp9-max_exp_sh+8'd126; end
                                        else begin res_man={intermed_man2[9:0],13'd0}; res_exp=intermed_exp9-8'd13+8'd127; end
                                    end
else if (intermed_man2[9]==1'b1)   begin if(( 14 > max_exp_sh))
                                             begin res_man=intermed_man2[22:0]<<max_exp_sh; res_exp=intermed_exp9-max_exp_sh+8'd126; end
                                        else begin res_man={intermed_man2[8:0],14'd0}; res_exp=intermed_exp9-8'd14+8'd127; end
                                    end
else if (intermed_man2[8]==1'b1)   begin if(( 15 > max_exp_sh))
                                             begin res_man=intermed_man2[22:0]<<max_exp_sh; res_exp=intermed_exp9-max_exp_sh+8'd126; end
                                        else begin res_man={intermed_man2[7:0],15'd0}; res_exp=intermed_exp9-8'd15+8'd127; end
                                    end
else if (intermed_man2[7]==1'b1)   begin if(( 16 > max_exp_sh))
                                             begin res_man=intermed_man2[22:0]<<max_exp_sh; res_exp=intermed_exp9-max_exp_sh+8'd126; end
                                        else begin res_man={intermed_man2[6:0],16'd0}; res_exp=intermed_exp9-8'd16+8'd127; end
                                    end
else if (intermed_man2[6]==1'b1)   begin if(( 17 > max_exp_sh))
                                             begin res_man=intermed_man2[22:0]<<max_exp_sh; res_exp=intermed_exp9-max_exp_sh+8'd126; end
                                        else begin res_man={intermed_man2[5:0],17'd0}; res_exp=intermed_exp9-8'd17+8'd127; end
                                    end
else if (intermed_man2[5]==1'b1)   begin if(( 18 > max_exp_sh))
                                             begin res_man=intermed_man2[22:0]<<max_exp_sh; res_exp=intermed_exp9-max_exp_sh+8'd126; end
                                        else begin res_man={intermed_man2[4:0],18'd0}; res_exp=intermed_exp9-8'd18+8'd127; end
                                    end
else if (intermed_man2[4]==1'b1)   begin if(( 19 > max_exp_sh))
                                             begin res_man=intermed_man2[22:0]<<max_exp_sh; res_exp=intermed_exp9-max_exp_sh+8'd126; end
                                        else begin res_man={intermed_man2[3:0],19'd0}; res_exp=intermed_exp9-8'd19+8'd127; end
                                    end
else if (intermed_man2[3]==1'b1)   begin if(( 20 > max_exp_sh))
                                             begin res_man=intermed_man2[22:0]<<max_exp_sh; res_exp=intermed_exp9-max_exp_sh+8'd126; end
                                        else begin res_man={intermed_man2[2:0],20'd0}; res_exp=intermed_exp9-8'd20+8'd127; end
                                    end
else if (intermed_man2[2]==1'b1)   begin if(( 21 > max_exp_sh))
                                             begin res_man=intermed_man2[22:0]<<max_exp_sh; res_exp=intermed_exp9-max_exp_sh+8'd126; end
                                        else begin res_man={intermed_man2[1:0],21'd0}; res_exp=intermed_exp9-8'd21+8'd127; end
                                    end
else if (intermed_man2[1]==1'b1)   begin if(( 22 > max_exp_sh))
                                             begin res_man=intermed_man2[22:0]<<max_exp_sh; res_exp=intermed_exp9-max_exp_sh+8'd126; end
                                        else begin res_man={intermed_man2[0],22'd0}; res_exp=intermed_exp9-8'd22+8'd127; end
                                    end
else if (intermed_man2[0]==1'b1)   begin if(( 23 > max_exp_sh))
                                             begin res_man=intermed_man2[22:0]<<max_exp_sh; res_exp=intermed_exp9-max_exp_sh+8'd126; end
                                        else begin res_man={23'd0}; res_exp=intermed_exp9-8'd23+8'd127; end
                                    end
else                               begin res_man=23'd0; res_exp=8'd0; end
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Check for overflow and underflow
overflow = (res_exp > 8'd254);
underflow = (res_exp == 8'd0);

    if (overflow) begin
        // Overflow: Set result to infinity
        {res_sign,res_exp,res_man} = {1'b0, 8'b11111111, 23'b0};
        end
     else begin
        // Normalized result
        {res_sign,res_exp,res_man} = {res_sign,res_exp,res_man};
    end

 end   
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
end

end
endmodule 