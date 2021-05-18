

`timescale 1ns / 1ps


// this memory is degined for instruction and only read port will be used
//by the PC and write port will be used by testbench to fill the instructions.
module instruction_memory(reset, clk, addr, rdata, wr, wdata );

input reset, clk, wr;

parameter WIDTH1 = 32;
parameter MEM_SIZE = 1024;

input [WIDTH1-1 : 0] addr;
input [WIDTH1-1 : 0] wdata;

output reg [WIDTH1-1 : 0] rdata;

reg [WIDTH1-1: 0]imem [MEM_SIZE-1 : 0];

integer i = 0;

always@(posedge reset) begin
	if (reset) begin
		for (i =0 ; i < MEM_SIZE; i++) begin
			imem[i] <= 0;
		end// for 
	end //if end
end //always

always@(posedge clk) begin
	if (wr)
		imem[addr] <= wdata;
	else
		rdata <= imem[addr];
end //always

endmodule
