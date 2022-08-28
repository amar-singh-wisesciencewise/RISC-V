
`timescale 1ns / 1ps


module test;


reg clk = 0;
reg reset = 0;
integer ret;
integer bin_file;
reg [31:0] endian_cor;
integer position;
reg [32-1: 0]tmem [1024-1 : 0]; //temp memory

initial begin
#0  reset = 1;
#10 reset = 0;
#1500 $finish;
end //intial end


always #5 clk = !clk;

risc_v_microcontroller uc1 (.clk(clk), .reset(reset));

integer i = 0;
initial begin
	/* Opening the binary code file to load it in instruction memory */
	bin_file = $fopen("prog.bin","rb");
	if (bin_file == 0)
		$display("File opening failed prog.bin not present. FP= %d\n", bin_file);
	else begin
		position = $ftell(bin_file);
		$display("Binary file position %d\n", position);
		ret = $fread(tmem, bin_file); //read the files in tmem
		for (i=0; i<1024 - 1; i++)
		begin
			endian_cor = tmem[i];
			/* Load the instructions from position 2 as 0th is used for
			   initializing the SP  and LR */
			uc1.imem1.imem[i+2] = {endian_cor[7:0], endian_cor[15:8], endian_cor[23:16], endian_cor[31:24]};
		end
	end //if end

	#1450
	$display("\tRegisterFile\tMemData\t\tIntructionData");
	for (i=0; i<32; i++)
	begin
		$display("%04d\t%08x\t%08x\t%08x",i, uc1.riscv1.rf1.RegFile[i], uc1.dmem1.dmem[i], uc1.imem1.imem[i]);
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
