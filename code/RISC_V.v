`timescale 1ns / 1ps

module riscv(clk, reset, iwr, iaddr, idata, wr, addr, data_in, data_out);

input clk, reset, iwr, wr;

parameter BUS_WIDTH = 32;

output reg [BUS_WIDTH-1 : 0] iaddr;
output reg [BUS_WIDTH-1 : 0] addr;
output reg [BUS_WIDTH-1 : 0] data_out;

input [BUS_WIDTH-1 : 0] idata;
input [BUS_WIDTH-1 : 0] data_in;


endmodule
