//single cycle risc_v 32_bit archteciter
//control_path & data_path & Floating point unit
//top module of risc_v
module RISC_V    (  input  clk, reset,
                    input  [31:0] instr,
					output [31:0] pc,
					output Mem_Write, Mem_read, 
					input  stall,
					output [31:0] a_data_mem,w_data_mem,
				    input  [31:0] r_data_mem);
 
wire Zero, Reg_Write, alu_src2, pc_jalr, pc_src;
wire [2:0] alu_control;
wire [1:0] ext_imm_sel, res_rd;
wire [31:0]rs1,rs2,fp_2reg,frs2;

wire data_mem_in_sel,FP_reg_we,FP_alu_in1_sel,fp_2reg_sel;
wire [1:0] FP_reg_fds_sel;
wire [3:0] FP_alu_op;

control_path control_path (instr[6:0], instr[14:12], instr[31:25],instr[24:20], Zero, alu_control,ext_imm_sel,
                 Mem_Write, Mem_read, Reg_Write, res_rd,alu_src2, pc_jalr, pc_src,
                 FP_reg_we,FP_reg_fds_sel,FP_alu_op, data_mem_in_sel,FP_alu_in1_sel,fp_2reg_sel);
  
data_path data_path (stall, clk, reset, pc, instr[31:7], rs2, a_data_mem, r_data_mem, Zero,
               alu_control, ext_imm_sel, Reg_Write, res_rd, alu_src2, pc_jalr, pc_src,fp_2reg,rs1);

FPU FPU (clk, FP_reg_we ,fp_2reg_sel, FP_alu_in1_sel,FP_reg_fds_sel , FP_alu_op ,instr[31:7] , r_data_mem ,rs1,fp_2reg,frs2);

mux2 data_mem_in_mux (rs2 ,frs2 ,data_mem_in_sel, w_data_mem);
 
endmodule 



