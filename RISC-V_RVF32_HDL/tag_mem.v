//tag memory
module tag_mem  (input   clk, t_we,
                 input   [4:0] t_addrs,
				 input   [2:0] t_wd,
                 output  [2:0] t_rd);

reg [2:0] RAM [0:31];  
 
//write operation
always@(negedge clk)
begin
		if (t_we) 
		  begin 
		   RAM[t_addrs[4:0]] <= t_wd;
		  end
end
//read opertaion	 
	 assign t_rd =  RAM[t_addrs[4:0]];
endmodule 