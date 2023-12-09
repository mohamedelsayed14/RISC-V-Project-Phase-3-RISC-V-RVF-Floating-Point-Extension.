//FP_ALU testbench module_2
//Test all alu supurted operations
`timescale 1ns/1ps
module tb2_FP_ALU ();
reg s_u;
reg [3:0]alu_control;
reg [31:0] a;
reg [31:0] b;
wire [31:0] result;
reg [31:0] result_expected;
wire tt;
localparam t = 10;
reg  [0:120]msg;
reg  [248:-248]res_s;
reg  [40:-40]op;
reg  [44:-44]casen;

FP_alu tb2_FP_ALU (s_u, alu_control, a, b, result);

always@(alu_control)
begin
#2
msg= (result == result_expected) ? "[Test Passed]" : "[Test Failed]";
#3
$display ("%s%s   0x%h    0x%h   =0x%h     [0x%h]    %s:%s",casen,op,a,b,result,result_expected,msg,res_s);
end
//Force data/////////////////////////////////////////////////////////////////////////////
initial
begin
alu_control=4'd15;
$display (" Case:        	Operation  	 In1	          	In2         Result  	    Expected_Result     Test State:   	             Description:");
$dumpfile("tb2_FP_ALU.vcd");
$dumpvars(0,tb2_FP_ALU);
/////////////////////////////////////////////////////////////////////////////////////
a = 32'h448C0000;//a=1120.0 
b = 32'hC2F00000;//b=-120.0
///////////////////////////////////////////////////////////////////////////////////
//case0:Add
casen="[Case:0   ]";
op="Add";
res_s="(1120.0 + -120.0=1000.0)";
result_expected =32'h447A0000;
alu_control=4'd0;
#t
////////////////////////////////////////////////////////////////////////////////////
//case1:Sub
casen="[Case:1   ]";
op="Sub";
res_s="(1120.0 - -120.0=1240.0)";
result_expected =32'h449B0000; 
alu_control=4'd1;
#t
/////////////////////////////////////////////////////////////////////////////////////
//case2:Mul
casen="[Case:2   ]";
op="Mul";
res_s="(1120.0 x -120.0=-134400.0)";
result_expected =32'hC8034000; 
alu_control=4'd2;
#t
/////////////////////////////////////////////////////////////////////////////////////
//case4:Feq
casen="[Case:4   ]";
op="Feq";
res_s="(1120.0 == -120.0)";
result_expected =32'd0; 
alu_control=4'd4;
#t
/////////////////////////////////////////////////////////////////////////////////////
//case5:Flt
casen="[Case:5   ]";
op="Flt";
res_s="(1120.0 < -120.0)";
result_expected =32'd0; 
alu_control=4'd5;
#t
/////////////////////////////////////////////////////////////////////////////////////
//case6:Fle
casen="[Case:6   ]";
op="Fle";
res_s="(1120.0 <= -120.0)";
result_expected =32'd0; 
alu_control=4'd6;
#t
/////////////////////////////////////////////////////////////////////////////////////
//case7:Fmin
casen="[Case:7   ]";
op="Fmin";
res_s="Min(1120.0 , -120.0)";
result_expected =32'hC2F00000; 
alu_control=4'd7;
#t
/////////////////////////////////////////////////////////////////////////////////////
//case8:Fmax
casen="[Case:8   ]";
op="Fmax";
res_s="Max(1120.0 , -120.0)";
result_expected =32'h448C0000; 
alu_control=4'd8;
#t
/////////////////////////////////////////////////////////////////////////////////////
//case9:Fclass
casen="[Case:9   ]";
op="Fclass"; //6   | rs1 is a positive normal number
res_s="Fclass(1120.0)= res[6]=1: +ve normal";
result_expected =32'h00000040;
alu_control=4'd9;
#t
/////////////////////////////////////////////////////////////////////////////////////
//case10:Fsgnj
casen="[Case:10  ]";
op="Fsgnj"; 
res_s="(-1120.0)";
result_expected =32'hC48C0000;
alu_control=4'd10;
#t
/////////////////////////////////////////////////////////////////////////////////////
//case11:Fsgnjn
casen="[Case:11  ]";
op="Fsgnjn"; 
res_s="(1120.0)";
result_expected =32'h448C0000;
alu_control=4'd11;
#t
/////////////////////////////////////////////////////////////////////////////////////
//case12:Fsgnjx
casen="[Case:12  ]";
op="Fsgnjx"; 
res_s="(-1120.0)";
result_expected =32'hC48C0000;
alu_control=4'd12;
#t
/////////////////////////////////////////////////////////////////////////////////////
//case13.1:Fcvt.w.s
casen="[Case:13.1]";
a = 32'hC2C8CCCD;//a=-100.4;
s_u=1'b0;
op="Fcvt.w.s"; 
res_s="(Cvt folat(-100.4) to S_integer(-100))";
result_expected =32'hFFFFFF9C; //-100
alu_control=4'd13;
#t
/////////////////////////////////////////////////////////////////////////////////////
//case14.1:Fcvt.s.w
a = 32'hFFFFFF9C;//a=-100;
s_u=1'b0;
casen="[Case:14.1]";
op="Fcvt.s,w"; 
res_s="(Cvt S_integer(-100) to float(-100.0))";
result_expected =32'hC2C80000; //-100.0
alu_control=4'd14;
#t
/////////////////////////////////////////////////////////////////////////////////////
//case13.2:Fcvt.wu.s
casen="[Case:13.2]";
a = 32'hC2C8CCCD;//a=-100.4;
s_u=1'b1;
op="Fcvt.wu.s"; 
res_s="(Cvt folat(-100.4) to U_integer(100))";
result_expected =32'h00000064; //100
alu_control=4'd13;
#t
/////////////////////////////////////////////////////////////////////////////////////
//case14.2:Fcvt.s.wu
a = 32'hFFFFFF9C;//a=-100;
s_u=1'b1;
casen="[Case:14.2]";
op="Fcvt.s,wu"; 
res_s="(Cvt U_integer(-100 => (4294967196)) to float(4.2949673E9))";
result_expected =32'h4F800000; //4.2949673E9
alu_control=4'd14;
#t
////////////////////////////////////////////////////////////////////////////////////
$stop;
end
endmodule