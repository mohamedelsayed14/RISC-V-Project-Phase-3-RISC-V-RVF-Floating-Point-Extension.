//cache memory
module v_mem (input   reset, clk, v_we,
              input   [4:0] v_addrs,
				  input    v_wd,
              output   v_rd);

reg [31:0] RAM; 
 
//write operation
always@(negedge clk or posedge reset)
begin
   if (reset)
	   RAM=0;  //inthilaiz zeros
	else if (v_we) 
	   RAM[v_addrs] <= v_wd;
end
//read opertaion	 
	 assign v_rd =  RAM[v_addrs];
endmodule 