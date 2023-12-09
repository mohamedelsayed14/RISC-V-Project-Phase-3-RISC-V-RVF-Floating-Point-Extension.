//asyn_reset_flip_flop
module pc_flip #(parameter WIDTH = 32)
              (input clk, reset,stall,
               input [WIDTH-1:0] d, 
               output reg [WIDTH-1:0] q);

  always@(posedge clk, posedge reset, posedge stall)
  begin
    if (reset)
      q <= 0;
    else if (stall)
      q <= q;
    else
      q <= d;
	end
endmodule 