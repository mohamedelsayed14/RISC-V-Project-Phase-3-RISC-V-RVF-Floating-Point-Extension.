//cache memory
module cache_mem (input  reset, clk, cache_we, w_h,
                  input  [6:0] cache_r_addrs, cache_w_addrs,
				  input  [35:0] cache_wd, input [127:0] d_m_data,
                  output [35:0] cache_rd);

wire[127:0] d_cache_rd;
reg [31:0]cache;

always @(*) begin
	case(cache_r_addrs[1:0])
		2'b00:cache=d_cache_rd[31:0];
		2'b01:cache=d_cache_rd[63:32];
		2'b10:cache=d_cache_rd[95:64];
		2'b11:cache=d_cache_rd[127:96];
		default: cache=0;
	endcase 
end
assign cache_rd[31:0]=cache;

v_mem v_mem  (reset, clk, cache_we, cache_r_addrs[6:2], cache_wd[35], cache_rd[35]);
 
tag_mem t_mem  (clk, cache_we, cache_r_addrs[6:2], cache_wd[34:32], cache_rd[34:32]);
				  
cache_data d_cache_m  (clk, cache_we, w_h, cache_r_addrs[6:2], cache_w_addrs[6:0], d_m_data, cache_wd[31:0], d_cache_rd);					  
					  
endmodule 