

`timescale 1ns / 1ps


// this memory is degined for data read and write -  to be used by load and store instruction
// WR is set for write and 0 for read
module data_mem(reset, addr, re, rdata, wr, wdata);

input reset, wr, re;

parameter WIDTH1 = 32;
parameter MEM_SIZE = 1024;

input [WIDTH1-1 : 0] addr;
input [WIDTH1-1 : 0] wdata;

output reg [WIDTH1-1 : 0] rdata;

reg [WIDTH1-1: 0]dmem [MEM_SIZE-1 : 0];

integer i = 0;

always@(posedge reset) begin
	if (reset) begin
		for (i =0 ; i < MEM_SIZE; i++) begin
			dmem[i] <= i;
		end// for 
	end //if end
end //always

always@(*) begin
	if (wr)
		dmem[addr >> 2] <= wdata;
	else if (re)
		rdata <= dmem[addr >> 2];
	else
		rdata <= 0;
end //always

endmodule
