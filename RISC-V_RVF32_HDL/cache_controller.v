//cache controller
module cache_controller (input clk, reset, cpu_we, cpu_re, ready, hit,
						 output c_we, dm_we, dm_re, stall, new_valid, wh);
reg [5:0] signals; 
assign {c_we, dm_we, dm_re, stall, new_valid, wh}= signals;	
							 
localparam[1:0]idel=2'b00;
localparam[1:0]read=2'b01;
localparam[1:0]write=2'b10;

reg [1:0] c_state_reg;	
reg [1:0] n_state_reg;

always@(negedge clk , posedge reset)
begin
if(reset)
c_state_reg <= idel;
else
c_state_reg <= n_state_reg;
end

//signals>>>{c_we,   dm_we,    dm_re,   stall,   new_valid,    wh}
always@(*)
begin
///////////////////////////////////////////////////////////////////////////
if(reset) begin n_state_reg=idel; signals=6'b0_0_0_0_0_0; end 
else begin
case(c_state_reg)
idel:
begin
		case({cpu_re,cpu_we})
				//no_read_neigther_write
				2'b00: begin n_state_reg=idel; signals=6'b0_0_0_0_0_0; end 
				//invalied
				2'b11: begin n_state_reg=idel; signals=6'b0_0_0_0_0_0; end 
				//read
				2'b10: begin                       
								if(hit) begin n_state_reg=idel; signals=6'b0_0_0_0_0_0; end       
								else    begin n_state_reg=read; signals=6'b1_0_1_1_1_0; end  
					   end		
				//write						
				2'b01:begin                       
								if(hit) begin n_state_reg=write; signals=6'b1_1_0_1_1_1; end
								else    begin n_state_reg=write; signals=6'b0_1_0_1_0_0; end  
					   end	
			  default:begin n_state_reg=idel;  signals=6'b0_0_0_0_0_0; end
		endcase				   			 
end	
////////////////////////////////////////////////////////////////////////////
read:
begin 
		if(ready) begin 

                      if(cpu_re) begin  
                                            if(hit) begin n_state_reg=idel; signals=6'b0_0_0_0_0_0; end
								            else    begin n_state_reg=read; signals=6'b1_0_1_1_1_0; end 
						           end
						
                       else if(cpu_we) begin  
                                                if(hit) begin n_state_reg=write; signals=6'b1_1_0_1_1_1;end
								                else    begin n_state_reg=write; signals=6'b0_1_0_1_0_0; end  
						               end

					   else             begin   n_state_reg=idel; signals=6'b0_0_0_0_0_0; end

				  end
		else      begin n_state_reg=read; signals=6'b1_0_1_1_1_0; end  
			
end
///////////////////////////////////////////////////////////////////////////
write:
begin  
	if(hit) begin 
			if(ready) begin
							if(!cpu_re) begin	n_state_reg=idel;  signals=6'b0_0_0_0_0_0; end 
								else begin if(hit) begin n_state_reg=idel; signals=6'b0_0_0_0_0_0; end      
										   else    begin n_state_reg=read; signals=6'b1_0_1_1_1_0; end    
									 end
					     end

			else      begin n_state_reg=write; signals=6'b1_1_0_1_1_1; end			
    		end
    else 	begin       
				if(ready) begin
							if(!cpu_re) begin	n_state_reg=idel;  signals=6'b0_0_0_0_0_0; end 
								else begin if(hit) begin n_state_reg=idel; signals=6'b0_0_0_0_0_0; end      
											else    begin n_state_reg=read; signals=6'b1_0_1_1_1_0; end    
									 end
					       end

				else      begin n_state_reg=write; signals=6'b0_1_0_1_0_0; end			
    		end
end
default:begin n_state_reg=idel; signals=6'b0_0_0_0_0_0; end 
endcase
/////////////////////////////////////////////////////////////////////////// 		  
end 
end								 
						  
endmodule 