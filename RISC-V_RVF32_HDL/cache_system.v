//cache system
module cache_system (input clk, reset, we, re,
					 output  stall,
					 input   [31:0] byte_address,
					 input   [31:0] wd,
					 output  [31:0] rd);

wire [31:0] word_address;
wire hit;
wire cache_we, dm_we, dm_re, ready, wh;
wire [35:0]	cache_wd, cache_rd;				
wire new_valid;

wire [127:0] d_m_data;

assign word_address={2'b00,byte_address[31:2]};

assign cache_wd[31:0]= wd ;
assign cache_wd[35:32]={new_valid,word_address[9:7]};

assign rd=cache_rd[31:0];
assign hit = cache_rd[35] & (word_address[9:7] == cache_rd[34:32]);

cache_mem cache_mem (reset, clk, cache_we, wh,word_address[6:0], word_address[6:0] , cache_wd,d_m_data, cache_rd);

data_mem data_mem (reset, clk, dm_we, dm_re, ready, word_address[9:0], wd, d_m_data);    

cache_controller  cache_controller (clk, reset, we, re, ready, hit, cache_we, dm_we, dm_re, stall, new_valid,wh);
				  				  
endmodule 