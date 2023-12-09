//floating point register file 
//three ported
//async two ports for read [a1/frs1  ,  a2/frs2]
//sync one port for write [a3,fds3,we3]

module FP_reg_file (input   clk,we3, 
                    input   [4:0]  a1, a2, a3, 
                    input   [31:0] fds3, 
                    output  [31:0] frs1, frs2);

reg [31:0] FP_reg_f [31:0];

//write operation
  always@(posedge clk)
    if (we3) FP_reg_f[a3] <= fds3;

//read operation
  assign frs1 = FP_reg_f[a1];
  assign frs2 = FP_reg_f[a2];
endmodule 