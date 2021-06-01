

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

initial begin
imem[0] = {12'b10101, 5'd0, 3'b000, 5'd1, 7'b0010011};
imem[1] = {12'b111, 5'd0, 3'b000, 5'd2, 7'b0010011};
imem[2] = {12'b111111111100, 5'd0, 3'b000, 5'd3, 7'b0010011};
imem[3] = {12'b1011100, 5'd1, 3'b111, 5'd5, 7'b0010011};
imem[4] = {12'b10101, 5'd5, 3'b100, 5'd5, 7'b0010011};
imem[5] = {12'b1011100, 5'd1, 3'b110, 5'd6, 7'b0010011};
imem[6] = {12'b1011100, 5'd6, 3'b100, 5'd6, 7'b0010011};
imem[7] = {12'b111, 5'd1, 3'b000, 5'd7, 7'b0010011};
imem[8] = {12'b11101, 5'd7, 3'b100, 5'd7, 7'b0010011};
imem[9] = {6'b000000, 6'b110, 5'd1, 3'b001, 5'd8, 7'b0010011};
imem[10] = {12'b10101000001, 5'd8, 3'b100, 5'd8, 7'b0010011};
imem[11] = {6'b000000, 6'b10, 5'd1, 3'b101, 5'd9, 7'b0010011};
imem[12] = {12'b100, 5'd9, 3'b    100, 5'd9, 7'b0010011};
imem[13] = {7'b0000000, 5'd2, 5'd1, 3'b111, 5'd10, 7'b0110011};
imem[14] = {12'b100, 5'd10, 3'b100, 5'd10, 7'b0010011};
imem[15] = {7'b0000000, 5'd2, 5'd1, 3'b110, 5'd11, 7'b0110011};
imem[16] = {12'b10110, 5'd11, 3'b100, 5'd11, 7'b0010011};
imem[17] = {7'b0000000, 5'd2, 5'd1, 3'b100, 5'd12, 7'b0110011};
imem[18] = {12'b10011, 5'd12, 3'b100, 5'd12, 7'b0010011};
imem[19] = {7'b0000000, 5'd2, 5'd1, 3'b000, 5'd13, 7'b0110011};
imem[20] = {12'b11101, 5'd13, 3'b100, 5'd13, 7'b0010011};
imem[21] = {7'b0100000, 5'd2, 5'd1, 3'b000, 5'd14, 7'b0110011};
end

/*
always@(posedge reset) begin
	if (reset) begin
		for (i =0 ; i < MEM_SIZE; i++) begin
			imem[i] <= 0;
		end// for 
	end //if end
end //always
*/


always@(posedge clk) begin
	if (wr)
		imem[addr] <= wdata;
	else
		rdata <= imem[addr];
end //always

endmodule
