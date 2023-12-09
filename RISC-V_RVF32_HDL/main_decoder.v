//main decoder
module main_decoder(input   [6:0] op, input [2:0] funct3 , input [6:0]funct7,input  [4:0] src2,
							output [1:0] ALUOp,
							output [1:0] ext_imm_sel,
							output Mem_Write,Mem_read,Reg_Write,
							output [1:0] res_rd,
							output alu_src2,pc_jalr,pc_jal,branch,

							output FP_reg_we,
							output [1:0] FP_reg_fds_sel,
							output [3:0] FP_alu_op,
							output data_mem_in_sel, FP_alu_in1_sel,fp_2reg_sel);

  reg [12:0] signals;
  reg [9:0] FPU_signals;

  assign {ALUOp,ext_imm_sel,Mem_Write,Mem_read,Reg_Write,res_rd,alu_src2,pc_jalr,pc_jal,branch} = signals;
	assign {FP_reg_we, FP_reg_fds_sel ,FP_alu_op ,data_mem_in_sel, FP_alu_in1_sel, fp_2reg_sel} = FPU_signals;
// ALUOp, ext_imm_sel, Mem_Write,Mem_read, Reg_Write ,res_rd, alu_src2, pc_jalr, pc_jal, branch
// FP_reg_we, FP_reg_fds_sel ,FP_alu_op,data_mem_in_sel,FP_alu_in1_sel,fp_2reg_sel
  always@(*)
  begin
    case(op)
	7'd51	:begin signals = 13'b10_xx_0_0_1_00_0_0_0_0; FPU_signals= 10'b0_00_0000_0_0_0; end//R-TYPE (Integer)
	7'd19	:begin signals = 13'b10_00_0_0_1_00_1_0_0_0; FPU_signals= 10'b0_00_0000_0_0_0; end//I-TYPE(ALU) (Integer)
	7'd3	:begin signals = 13'b00_00_0_1_1_01_1_0_0_0; FPU_signals= 10'b0_00_0000_0_0_0; end//I-TYPE(LW) (Integer)
	7'd103:begin signals = 13'b00_00_0_0_1_10_1_1_0_0; FPU_signals= 10'b0_00_0000_0_0_0; end//I-TYPE(JALR) (Integer)
	7'd35	:begin signals = 13'b00_01_1_0_0_00_1_0_0_0; FPU_signals= 10'b0_00_0000_0_0_0; end//S-TYPE(SW) (Integer)
	7'd99	:begin signals = 13'b01_10_0_0_0_00_0_0_0_1; FPU_signals= 10'b0_00_0000_0_0_0; end//B-TYPE(BEQ,BNE) (Integer)
	7'd111:begin signals = 13'b00_11_0_0_1_10_0_0_1_0; FPU_signals= 10'b0_00_0000_0_0_0; end//J-TYPE(JAL) (Integer)
//Floating point control signals///////////////////////////////////////////////////////////////////////////////////
   7'd7	:begin
   			 if(funct3==3'b010)
  			  begin signals = 13'b00_00_0_1_0_01_1_0_0_0; FPU_signals= 10'b1_01_0000_0_0_0; end//I-TYPE(FLW) (RVF)
  			 else
          begin signals = 13'b00_00_0_1_0_01_1_0_0_0; FPU_signals= 10'b0_00_0000_0_0_0; end//
          end

  7'd39	:begin 
         if(funct3==3'b010)
  			  begin signals = 13'b00_01_1_0_0_00_1_0_0_0; FPU_signals= 10'b0_00_0000_1_0_0; end//S-TYPE(FSW) (RVF)
  			 else
          begin signals = 13'b00_01_1_0_0_00_1_0_0_0; FPU_signals= 10'b0_00_0000_0_0_0; end//
          end
////////////
  7'd83	:begin
         		if(funct3==3'b000 && funct7==7'b1110000 && src2==5'd0)
  				begin signals = 13'b10_00_0_0_1_11_0_0_0_0; FPU_signals= 10'b0_00_0000_0_0_0; end//R-TYPE (FMV.X.W)   dest>integer
  				 else if(funct3==3'b000 && funct7==7'b1111000 && src2==5'd0)
  				begin signals = 13'b10_00_0_0_0_00_0_0_0_0; FPU_signals= 10'b1_10_0000_0_0_0; end//R-TYPE (FMV.W.X)   dest>float
////////////				
			   else if(funct7==7'b0000000)
  				begin signals = 13'b10_00_0_0_0_00_0_0_0_0; FPU_signals= 10'b1_00_0000_0_0_0; end//R-TYPE (FADD)
			   else if(funct7==7'b0000100)
  				begin signals = 13'b10_00_0_0_0_00_0_0_0_0; FPU_signals= 10'b1_00_0001_0_0_0; end//R-TYPE (FSUB)  				
			   else if(funct7==7'b0001000)
  				begin signals = 13'b10_00_0_0_0_00_0_0_0_0; FPU_signals= 10'b1_00_0010_0_0_0; end//R-TYPE (FMUL)
///////////
			   else if(funct3==3'b010 && funct7==7'b1010000)
  				begin signals = 13'b10_00_0_0_1_11_0_0_0_0; FPU_signals= 10'b0_00_0100_0_0_1; end//R-TYPE (FEQ)  				
			   else if(funct3==3'b001 && funct7==7'b1010000)
  				begin signals = 13'b10_00_0_0_1_11_0_0_0_0; FPU_signals= 10'b0_00_0101_0_0_1; end//R-TYPE (FLT)
			   else if(funct3==3'b000 && funct7==7'b1010000)
  				begin signals = 13'b10_00_0_0_1_11_0_0_0_0; FPU_signals= 10'b0_00_0110_0_0_1; end//R-TYPE (FLE)
///////////
			   else if(funct3==3'b000 && funct7==7'b0010100)
  				begin signals = 13'b10_00_0_0_0_00_0_0_0_0; FPU_signals= 10'b1_00_0111_0_0_0; end//R-TYPE (FMIN)
			   else if(funct3==3'b001 && funct7==7'b0010100)
  				begin signals = 13'b10_00_0_0_0_00_0_0_0_0; FPU_signals= 10'b1_00_1000_0_0_0; end//R-TYPE (FMAX)
///////////  				
  			 else if(funct3==3'b001 && funct7==7'b1110000 && src2==5'd0)
  				begin signals = 13'b10_00_0_0_1_11_0_0_0_0; FPU_signals= 10'b0_00_1001_0_0_1; end//R-TYPE (FCLASS)
///////////
  			 else if(funct3==3'b000 && funct7==7'b0010000)
  				begin signals = 13'b10_00_0_0_0_00_0_0_0_0; FPU_signals= 10'b1_00_1010_0_0_0; end//R-TYPE (FSGNJ)  				
  			 else if(funct3==3'b001 && funct7==7'b0010000)
  				begin signals = 13'b10_00_0_0_0_00_0_0_0_0; FPU_signals= 10'b1_00_1011_0_0_0; end//R-TYPE (FSGNJN)
  			 else if(funct3==3'b010 && funct7==7'b0010000)
  				begin signals = 13'b10_00_0_0_0_00_0_0_0_0; FPU_signals= 10'b1_00_1100_0_0_0; end//R-TYPE (FSGNJX)
///////////
  			 else if(funct7==7'b1100000 && (src2==5'd1 || src2==5'd0))
  				begin signals = 13'b10_00_0_0_1_11_0_0_0_0; FPU_signals= 10'b0_00_1101_0_0_1; end//R-TYPE (FCVT.W.S  FCVT.WU.S)   dest>INTEGER
  			 else if(funct7==7'b1101000 && (src2==5'd1 || src2==5'd0))
  				begin signals = 13'b10_00_0_0_0_00_0_0_0_0; FPU_signals= 10'b1_00_1110_0_1_0; end//R-TYPE (FCVT.S.W  FCVT.S.WU)   dest>FLOAT
///////////
          else begin signals = 13'bxx_xx_x_x_x_xx_x_x_x_x; FPU_signals= 10'bx_xx_xxxx_x_x_x; end// non-implemented instruction
          end
///////////
   default:begin signals = 13'bxx_xx_x_x_x_xx_x_x_x_x; FPU_signals= 10'bx_xx_xxxx_x_x_x; end// non-implemented instruction
    endcase
  end
endmodule 