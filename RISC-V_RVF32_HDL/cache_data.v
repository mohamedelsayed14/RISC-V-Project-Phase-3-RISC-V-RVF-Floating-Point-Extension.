//cache data
module cache_data (input   clk, c_we, w_h,
                  input   [4:0] c_r_addrs,
                  input   [6:0] c_w_addrs,
				  input   [127:0] d_m_data,
				  input   [31:0] cpu_data,
                  output  [127:0] c_rd);

reg [127:0] RAM [0:31];  //memory size = 512_byte

//write operation
always@(negedge clk)
begin 		
		if (c_we) 
			if (w_h)
		  		case(c_w_addrs[1:0]) 
		   			2'b00:RAM[c_w_addrs[6:2]][31:0] <=cpu_data;
		   			2'b01:RAM[c_w_addrs[6:2]][63:32] <=cpu_data;
		   			2'b10:RAM[c_w_addrs[6:2]][95:64] <=cpu_data;
		   			2'b11:RAM[c_w_addrs[6:2]][127:96] <=cpu_data;
		  		endcase
		  	else 
		  		RAM[c_w_addrs[6:2]]<= d_m_data;		  			
end

//read opertaion	 
	 assign c_rd = RAM[c_r_addrs[4:0]];
endmodule