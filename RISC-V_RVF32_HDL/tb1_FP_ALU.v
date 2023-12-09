//FP_ALU testbench module_1
//coverage most arthimatic cases
`timescale 1ns/1ps
module tb1_FP_ALU ();
reg s_u;
reg [3:0]alu_control;
reg [31:0] a;
reg [31:0] b;
wire [31:0] result;
reg [31:0] result_expected;
wire tt;
localparam t = 10;

FP_alu tb1_FP_ALU (s_u, alu_control, a, b, result);

//test ADD
initial
begin
$dumpfile("tb1_FP_ALU.vcd");
$dumpvars(0,tb1_FP_ALU);
s_u=1'b0;
alu_control = 4'b0000; //ADD
/////////////////////////////////////////////////////////////////////////////////////
//case1:test a + (+/- zero)
a = 32'b0_00001001_00000000000000000001111; 
b = 32'd0;
result_expected = a;
#t
if (result == result_expected)
	$display ("Succeded case1:the test a + (+/- zero) succeded");
else
	$display ("Falid case1:the test a + (+/- zero) falid and the out is : %b", result);
//////////////////////////////////////////////////////////////////////////////////
//case2:test a + NAN
a = 32'b0_00001001_00000000000000000001111; 
b = 32'b0_11111111_00000000000000000001111; 
result_expected = b; // NAN
#t    
if (result == result_expected) // if out = NAN
	$display ("Succeded case2:the test a + NAN succeded");
else
	$display ("Falid case2:the test a + NAN falid and the out is : %b", result);
/////////////////////////////////////////////////////////////////////////////////		
//case3:test a + (+/- inifity)
a = 32'b0_00001001_00000000000000000001111; 
b = 32'b0_11111111_00000000000000000000000;
result_expected = b;
#t      
if (result === result_expected)
	$display ("Succeded case3:the test a + (+/- inifity) succeded");
else
	$display ("Falid case3:the test a + (+/- inifity) falid and the out is : %b", result);
/////////////////////////////////////////////////////////////////////////////////	
//case4:test (+/- inifity) + b
b = 32'b0_00001001_00000000000000000001111; 
a = 32'b0_11111111_00000000000000000000000;
result_expected = a;
#t
if (result === result_expected)
	$display ("Succeded case4:the test b + (+/- inifity) succeded");
else
	$display ("Falid case4:the test b + (+/- inifity) falid and the out is : %b", result);
//////////////////////////////////////////////////////////////////////////////////	
//case5:test (+/- inifity) + (+/- inifity)
a = 32'b0_11111111_00000000000000000000000;
b = 32'b0_11111111_00000000000000000000000;
result_expected = a;
#t
if (result === result_expected)
	$display ("Succeded case5:the test (+/- inifity) + (+/- inifity) succeded");
else
	$display ("Falid case5:the test (+/- inifity) + (+/- inifity) falid and the out is : %b", result);
///////////////////////////////////////////////////////////////////////////////////	
//case6:test a_expo=b_expo !=0 --> (+-1.m) + (+-1.m) --> no overflow
a = 32'b0_00001001_00000000000000000000001; 
b = 32'b0_00001001_00000000000000000000001; 
result_expected = 32'b0_00001010_00000000000000000000001;
#t
if (result == result_expected)
	$display ("Succeded case6:the test a_expo = b_expo !=0 --> (+-1.m) + (+-1.m) --> no overflow succeded");
else
	$display ("Falid case6:the test a_expo = b_expo !=0 --> (+-1.m) + (+-1.m) --> no overflow falid and the out is : %b", result);
//////////////////////////////////////////////////////////////////////////////////	
//case7:test a_expo = b_expo !=0 --> (+-1.m) + (+-1.m) --> overflow
a = 32'b0_00001001_11111111111111111111111; 
b = 32'b0_00001001_00000000000000000000001; 
result_expected = 32'b0_00001010_10000000000000000000000;
#t
if (result == result_expected)
	$display ("Succeded case7:the test a_expo = b_expo !=0 --> (+-1.m) + (+-1.m) --> overflow succeded");
else
	$display ("Falid case7:the test a_expo = b_expo !=0 --> (+-1.m) + (+-1.m) --> overflow falid and the out is : %b", result);
/////////////////////////////////////////////////////////////////////////////////	
//case8:test a_expo = b_expo !=0 --> (+-1.m) + (-+1.m) -->  (+>-) and test n/malize --> expo < shift
a = 32'b0_00001001_00000000000000000000011; 
b = 32'b1_00001001_00000000000000000000001; 
result_expected = 32'b0_00000000_00000000000001000000000;
#t
if (result == result_expected)
	$display ("Succeded case8:the test a_expo = b_expo !=0 --> (+-1.m) + (-+1.m) -->  (+>-) and test n/malize --> expo < shift succeded");
else
	$display ("Falid case8:the test a_expo = b_expo !=0 --> (+-1.m) + (-+1.m) -->  (+>-) and test n/malize --> expo < shift falid and the out is : %b", result);
/////////////////////////////////////////////////////////////////////////////////////////////
//case9:test a_expo = b_expo !=0 --> (+-1.m) + (-+1.m) -->  (+>-) and test n/malize --> expo > shift
a = 32'b0_00100010_00000000000000000000011; 
b = 32'b1_00100010_00000000000000000000001; 
result_expected = 32'b0_00001100_00000000000000000000000;
#t
if (result == result_expected)
	$display ("Succeded case9:the test a_expo = b_expo !=0 --> (+-1.m) + (-+1.m) -->  (+>-) and test n/malize --> expo > shift succeded");
else
	$display ("Falid case9:the test a_expo = b_expo !=0 --> (+-1.m) + (-+1.m) -->  (+>-) and test n/malize --> expo > shift falid and the out is : %b", result);
//////////////////////////////////////////////////////////////////////////////////////////////		
//case10:test a_expo = b_expo !=0 --> (+-1.m) + (-+1.m) -->  (->+) and test n/malize --> expo > shift
a = 32'b1_00100010_00000000000000000000011; 
b = 32'b0_00100010_00000000000000000000001; 
result_expected = 32'b1_00001100_00000000000000000000000;
#t
if (result == result_expected)
	$display ("Succeded case10:the test a_expo = b_expo !=0 --> (+-1.m) + (-+1.m) -->  (->+) and test n/malize --> expo > shift succeded");
else
	$display ("Falid case10:the test a_expo = b_expo !=0 --> (+-1.m) + (-+1.m) -->  (->+) and test n/malize --> expo > shift falid and the out is : %b", result);
//////////////////////////////////////////////////////////////////////////////////////////////	
//case11:test a_expo = b_expo = 0 --> (+-0.m) + (+-0.m) no overflow
a = 32'b0_00000000_00000000000000000000011; 
b = 32'b0_00000000_00000000000000000000001; 
result_expected = 32'b0_00000000_00000000000000000000100;
#t
if (result == result_expected)
	$display ("Succeded case11:the test a_expo = b_expo = 0 --> (+-0.m) + (+-0.m) no overflow succeded");
else
	$display ("Falid case11:the test a_expo = b_expo = 0 --> (+-0.m) + (+-0.m) no overflow falid and the out is : %b", result);
///////////////////////////////////////////////////////////////////////////////////////////////
//case12:test a_expo = b_expo = 0 --> (+-0.m) + (+-0.m) overflow
a = 32'b0_00000000_11111111111111111111111; 
b = 32'b0_00000000_00000000000000000000001; 
result_expected = 32'b0_00000001_00000000000000000000000;
#t
if (result == result_expected)
	$display ("Succeded case12:the test a_expo = b_expo = 0 --> (+-0.m) + (+-0.m) overflow succeded");
else
	$display ("Falid case12:the test a_expo = b_expo = 0 --> (+-0.m) + (+-0.m) overflow falid and the out is : %b", result);
////////////////////////////////////////////////////////////////////////////////////////////	
//case13:test [a_expo > b_expo] & [b_expo= 0] & [a_expo >= 23]
a = 32'b0_00100000_11111111111111111111111; 
b = 32'b0_00000000_00000000000000000000001; 
result_expected = a;
#t
if (result == result_expected)
	$display ("Succeded case13:the test [a_expo > b_expo] & [b_expo= 0] & [a_expo >= 23] succeded");
else
	$display ("Falid case13:the test [a_expo > b_expo] & [b_expo= 0] & [a_expo >= 23] falid and the out is : %b", result);
////////////////////////////////////////////////////////////////////////////////////////
//case14:test [a_expo > b_expo] & [b_expo= 0] & [a_expo < 23] --> (+-1.m) + (+-0.m) overflow
a = 32'b0_00000010_11111111111111111111111; 
b = 32'b0_00000000_00000000000000000000100; 
result_expected = 32'b0_00000011_00000000000000000000000;
#t
if (result == result_expected)
	$display ("Succeded case14:the test [a_expo > b_expo] & [b_expo= 0] & [a_expo < 23] --> (+-1.m) + (+-0.m) overflow succeded");
else
	$display ("Falid case14:the test [a_expo > b_expo] & [b_expo= 0] & [a_expo < 23] --> (+-1.m) + (+-0.m) overflow falid and the out is : %b", result);
/////////////////////////////////////////////////////////////////////////////////////////
//case15:test [a_expo > b_expo] & [b_expo= 0] & [a_expo < 23] --> (+-1.m) + (+-0.m) no overflow
a = 32'b0_00000010_11111111111111111111000; 
b = 32'b0_00000000_00000000000000000000100; 
result_expected = 32'b0_00000010_11111111111111111111010;
#t
if (result == result_expected)
	$display ("Succeded case15:the test [a_expo > b_expo] & [b_expo= 0] & [a_expo < 23] --> (+-1.m) + (+-0.m) no overflow succeded");
else
	$display ("Falid case15:the test [a_expo > b_expo] & [b_expo= 0] & [a_expo < 23] --> (+-1.m) + (+-0.m) no overflow falid and the out is : %b", result);
//////////////////////////////////////////////////////////////////////////////////////////
//case16:test [a_expo > b_expo] & [b_expo= 0] & [a_expo < 23] --> (+-1.m) + (-+0.m) no b/row
a = 32'b0_00000010_11111111111111111111000; 
b = 32'b1_00000000_00000000000000000100000; 
result_expected = 32'b0_00000010_11111111111111111101000;
#t
if (result == result_expected)
	$display ("Succeded case16:the test [a_expo > b_expo] & [b_expo= 0] & [a_expo < 23] --> (+-1.m) + (+-0.m) no b/row succeded");
else
	$display ("Falid case16:the test [a_expo > b_expo] & [b_expo= 0] & [a_expo < 23] --> (+-1.m) + (+-0.m) no b/row falid and the out is : %b", result);
////////////////////////////////////////////////////////////////////////////////////////
//case17:test [a_expo > b_expo] & [b_expo= 0] & [a_expo < 23] --> (+-1.m) + (-+0.m) b/row
a = 32'b0_00000010_00000000000000000000000; 
b = 32'b1_00000000_10000000000000000000000; 
result_expected = 32'b0_00000001_10000000000000000000000;
#t
if (result == result_expected)
	$display ("Succeded case17:the test [a_expo > b_expo] & [b_expo= 0] & [a_expo < 23] --> (+-1.m) + (+-0.m) b/row succeded");
else
	$display ("Falid case17:the test [a_expo > b_expo] & [b_expo= 0] & [a_expo < 23] --> (+-1.m) + (+-0.m) b/row falid and the out is : %b", result);	
/////////////////////////////////////////////////////////////////////////////////////////	
//case18:test [a_expo > b_expo] & [b_expo!= 0] & [a_expo-b_expo >= 24]
a = 32'b0_00100000_11111111111111111111111;
b = 32'b0_00000100_00000000000000000000001;
result_expected = a;
#t
if (result == result_expected)
	$display ("Succeded case18:the test [a_expo > b_expo] & [b_exp!o= 0] & [a_expo-b_expo >= 24] succeded");
else
	$display ("Falid case18:the test [a_expo > b_expo] & [b_exp!o= 0] & [a_expo-b_expo >= 24] falid and the out is : %b", result);
/////////////////////////////////////////////////////////////////////////////////////////
//case19:test [a_expo > b_expo] & [b_expo!= 0] & [a_expo-b_expo < 24] --> (+-1.m) + (+-0.m) overflow
a = 32'b0_00000110_11111111111111111111111; 
b = 32'b0_00000100_00000000000000000000100; 
result_expected = 32'b0_00000111_00100000000000000000000;
#t
if (result == result_expected)
	$display ("Succeded case19:the test [a_expo > b_expo] & [b_expo!= 0] & [a_expo-b_expo < 24] --> (+-1.m) + (+-0.m) overflow succeded");
else
	$display ("Falid case19:the test [a_expo > b_expo] & [b_expo!= 0] & [a_expo-b_expo < 24] --> (+-1.m) + (+-0.m) overflow falid and the out is : %b", result);
////////////////////////////////////////////////////////////////////////////////////////////////
//case20:test [a_expo > b_expo] & [b_expo!= 0] & [a_expo-b_expo < 24] --> (+-1.m) + (+-0.m) no overflow
a = 32'b0_00000110_10111111111111111111000; 
b = 32'b0_00000100_00000000000000000000100; 
result_expected = 32'b0_00000110_11111111111111111111001;
#t
if (result == result_expected)
	$display ("Succeded case20:the test [a_expo > b_expo] & [b_expo!= 0] & [a_expo-b_expo < 24] --> (+-1.m) + (+-0.m) no overflow succeded");
else
	$display ("Falid case20:the test [a_expo > b_expo] & [b_expo!= 0] & [a_expo-b_expo < 24] --> (+-1.m) + (+-0.m) no overflow falid and the out is : %b", result);
/////////////////////////////////////////////////////////////////////////////////////////////////
//case21:test [a_expo > b_expo] & [b_expo!= 0] & [a_expo-b_expo < 24] --> (+-1.m) + (-+0.m) no b/row
a = 32'b0_00000110_11111111111111111111000; 
b = 32'b1_00000100_00000000000000000100000; 
result_expected = 32'b0_00000110_10111111111111111110000;
#t
if (result == result_expected)
	$display ("Succeded case21:the test [a_expo > b_expo] & [b_expo!= 0] & [a_expo-b_expo < 24] --> (+-1.m) + (+-0.m) no b/row succeded");
else
	$display ("Falid case21:the test [a_expo > b_expo] & [b_expo!= 0] & [a_expo-b_expo < 24] --> (+-1.m) + (+-0.m) no b/row falid and the out is : %b", result);
/////////////////////////////////////////////////////////////////////////////////////////////////
//case22:test [a_expo > b_expo] & [b_expo!= 0] & [a_expo-b_expo < 24] --> (+-1.m) + (-+0.m) b/row
a = 32'b0_00000110_00000000000000000000000; 
b = 32'b1_00000100_00000000000000000000000; 
result_expected = 32'b0_00000101_10000000000000000000000;
#t
if (result == result_expected)
	$display ("Succeded case22:the test [a_expo > b_expo] & [b_expo!= 0] & [a_expo-b_expo < 24] --> (+-1.m) + (+-0.m) b/row succeded");
else
	$display ("Falid case22:the test [a_expo > b_expo] & [b_expo!= 0] & [a_expo-b_expo < 24] --> (+-1.m) + (+-0.m) b/row falid and the out is : %b", result);
////////////////////////////////////////////////////////////////////////////////////////////////////
$stop;
end
endmodule