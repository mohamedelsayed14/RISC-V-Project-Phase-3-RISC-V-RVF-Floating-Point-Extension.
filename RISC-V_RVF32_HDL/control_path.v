//main_controller
module control_path (		input  [6:0] op,
							input  [2:0] funct3,
							input  [6:0]funct7,
							input  [4:0] src2,
							input  Zero,
                    		output [2:0] alu_control,
							output [1:0] ext_imm_sel,
							output Mem_Write, Mem_read, Reg_Write,
							output [1:0] res_rd,
							output alu_src2, pc_jalr, pc_src,

							output FP_reg_we,
							output [1:0] FP_reg_fds_sel,
							output [3:0] FP_alu_op,
							output data_mem_in_sel,FP_alu_in1_sel,fp_2reg_sel);


wire [1:0] ALUOp;
wire pc_jal, branch, beq, bne;
assign beq=~funct3[0];
assign bne= funct3[0];

assign pc_src = pc_jal | pc_jalr | (branch & (beq & Zero| bne & ~Zero));

main_decoder m1 (op,funct3,funct7,src2, ALUOp, ext_imm_sel, Mem_Write, Mem_read, Reg_Write,
						res_rd, alu_src2, pc_jalr, pc_jal, branch,
						FP_reg_we,FP_reg_fds_sel,FP_alu_op,data_mem_in_sel,FP_alu_in1_sel,fp_2reg_sel);

alu_decoder m2 (op[5], funct3, funct7[5], ALUOp, alu_control);

endmodule 