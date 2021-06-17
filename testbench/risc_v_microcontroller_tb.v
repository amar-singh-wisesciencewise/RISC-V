
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
	#1450
	$display("\tRegisterFile\tMemData");
	for (i=0; i<32; i++)
	begin
		$display("%d %x %x",i, uc1.riscv1.rf1.RegFile[i], uc1.dmem1.dmem[i]);
	end
/*
	$display("\n\n Data Memeory \n\n");
	for (i=0; i<32; i++)
	begin
		$display("%d %x",i, uc1.dmem1.dmem[i]);
	end
*/
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
