//testbench module
//soc risc_v with FP unit and cache_memory_system and instructer_memory
`timescale 1ns/1ps
module tb_RISC_V_SOC ();

reg clk,reset;
wire [31:0] instr, pc;
wire Mem_Write, Mem_read, stall;
wire [31:0] a_data_mem, w_data_mem;
wire [31:0] r_data_mem;

RISC_V    risc_v (clk, reset, instr, pc, Mem_Write, Mem_read, stall, a_data_mem, w_data_mem, r_data_mem);       
inst_mem  i_m    (pc, instr);          
cache_system cache_system (clk, reset, Mem_Write, Mem_read, stall, a_data_mem, w_data_mem, r_data_mem);
///////////////////////////////////// //////////////////////////////////////////////////////////////////
// initialize reset
  initial
  begin
    $dumpfile("risc_v.vcd");
    $dumpvars(0,tb_RISC_V_SOC);

        reset = 1;
    #5; reset = 0;

    #300;
    $stop;
  end
////////////////////////////////////////////////////////////////////
// generate clock
  always
  begin
   clk = 1;
	#5; 
	clk = 0;
	#5;
  end

endmodule 