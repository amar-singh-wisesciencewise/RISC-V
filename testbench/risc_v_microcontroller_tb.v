
`timescale 1ns / 1ps


module test;

reg clk = 0;
reg reset = 0;

initial begin
#0  reset = 1;
#10 reset = 0;
#1500 $finish;
end //intial end


always #5 clk = !clk;

risc_v_microcontroller uc1 (.clk(clk), .reset(reset));

integer i = 0;
initial begin
	#1400
	for (i=0; i<32; i++)
	begin
		$display("%d %x",i, uc1.riscv1.rf1.RegFile[i]);
	end
end //initial end

initial begin
	$dumpfile("test.vcd");
	$dumpvars(0, test);
end

/*
initial
	$monitor($time, "  %x ", uc1.riscv1.rf1.RegFile[2]);
*/
endmodule
