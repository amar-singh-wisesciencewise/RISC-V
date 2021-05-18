

`timescale 1ns / 1ps


// this memory is degined for data read and write -  to be used by load and store instruction
// WR is set for write and 0 for read
module data_mem(reset, clk, addr, rdata, wr, wdata);

input reset, clk, wr;

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
			dmem[i] <= 0;
		end// for 
	end //if end
end //always

always@(posedge clk) begin
	if (wr)
		dmem[addr] <= wdata;
	else
		rdata <= dmem[addr];
end //always

endmodule
