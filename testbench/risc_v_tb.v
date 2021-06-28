
`timescale 1ns / 1ps


module test;

parameter DATA_BUS_WIDTH = 32;
reg clk = 0;
reg reset = 0;
wire [DATA_BUS_WIDTH-1 : 0] iaddr;
wire [DATA_BUS_WIDTH-1 : 0] idata;
wire [DATA_BUS_WIDTH-1 :0] addr;
wire [DATA_BUS_WIDTH-1 :0] data_out;
wire [DATA_BUS_WIDTH-1 :0] data_in;
wire wr, re;
wire iwr;

initial begin
#0  reset = 1;
#10 reset = 0;
#1500 $finish;
end //intial end

always #5 clk = !clk;
//instantiation of the module

riscv dut (.clk(clk), .reset(reset), .iwr(iwr), .iaddr(iaddr), .idata(idata), .wr(wr), .addr(addr), .data_in(data_in), .re(re), .data_out(data_out));
trfGen imem(.reset(reset),.wr(iwr),.addr(iaddr),.wdata(data_out),.rdata(idata));
data_mem dmem(.reset(reset), .addr(addr), .re(re), .rdata(data_in), .wr(wr), .wdata(data_out));
//transaction part to include all the reg to drive the risc module
//always block to drive the stimulus to the module
//datamemory storage

initial begin
	$dumpfile("test.vcd");
	$dumpvars(0, test);
end

endmodule

