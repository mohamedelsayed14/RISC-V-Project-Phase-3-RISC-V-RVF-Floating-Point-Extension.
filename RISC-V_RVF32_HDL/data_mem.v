//data memory
module data_mem (input   reset, clk, dm_we, dm_re,
                 output  reg ready,
				 input   [9:0] dm_addrs,
				 input   [31:0] dm_wd,
                 output  [127:0] dm_rd_2cache );
					  
reg [2:0] cycle_num;
reg [31:0] RAM [0:1023];  //memory size = 4k_byte
 

//write operation
  always@(negedge clk)
    if (dm_we)
	     RAM[dm_addrs[9:0]] <= dm_wd;

//read opertaion	 
	 assign dm_rd_2cache = {RAM[{dm_addrs[9:2],2'b11}], RAM[{dm_addrs[9:2],2'b10}],
                            RAM[{dm_addrs[9:2],2'b01}], RAM[{dm_addrs[9:2],2'b00}]};

//ready_generation
always@(posedge clk or posedge reset)
begin
  if(reset)
       cycle_num=0;
   else if (dm_we || dm_re) 
        cycle_num=cycle_num+1'b1;
   else
        cycle_num=0;
end
 
 always @(negedge clk)
        ready= (cycle_num == 3) ;

endmodule 