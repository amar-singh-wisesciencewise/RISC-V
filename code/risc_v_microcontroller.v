


`timescale 1ns / 1ps


// This module combine RISC V CPU and Instruction and Data memory

module risc_v_microcontroller(reset, clk);
input reset, clk;

parameter BUS_WIDTH = 32;

// RISC V signals
wire iwr; //instruction memory write
wire wr; // data memory write
wire re; // data memory read
wire [BUS_WIDTH-1 : 0] iaddr; //instruction memory address
wire [BUS_WIDTH-1 : 0] addr; //data memory address
wire [BUS_WIDTH-1 : 0] data_out; // data memory write
wire [BUS_WIDTH-1 : 0] idata; //instruction memory read data
wire [BUS_WIDTH-1 : 0] data_in; // data memory read data


instruction_memory imem1 (.reset(reset), .clk(clk), .addr(iaddr), .rdata(idata), .wr(iwr), .wdata(data_out));

data_mem dmem1 (.reset(reset), .clk(clk), .addr(addr), .re(re), .rdata(data_in), .wr(wr), .wdata(data_out));

riscv riscv1 (.clk(clk), .reset(reset), .iwr(iwr), .iaddr(iaddr), .idata(idata), .wr(wr), .addr(addr), .data_in(data_in), .re(re), .data_out(data_out));

endmodule
