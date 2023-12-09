//Floating Point Unit
module FPU (input clk, FP_reg_we,fp_2reg_sel,FP_alu_in1_sel, input [1:0] FP_reg_fds_sel, input  [3:0] FP_alu_op,
            input  [31:7]instr , input[31:0] r_data_mem , input [31:0] rs1,
            output [31:0] fp_2reg ,frs2);

wire [31:0] FP_reg_fds,FP_alu_in1,FP_alu_result,frs1;

mux4 FP_reg_fds_mux (FP_alu_result,r_data_mem,rs1, ,FP_reg_fds_sel,FP_reg_fds); 

FP_reg_file FP_reg_file (clk,FP_reg_we,instr[19:15],instr[24:20],instr[11:7],FP_reg_fds,frs1,frs2); 

mux2 FP_alu_in1_mux (frs1 ,rs1 ,FP_alu_in1_sel, FP_alu_in1);

FP_alu FP_alu (instr[20],FP_alu_op, FP_alu_in1, frs2, FP_alu_result);

mux2 fp_2reg_mux (frs1 ,FP_alu_result ,fp_2reg_sel,fp_2reg);

endmodule 