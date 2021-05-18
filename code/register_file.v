`timescale 1ns / 1ps

module register_file(clk, reset, sel, wr, addr, wdata, rdata);

input clk, reset, sel, wr;

parameter WIDTH1 = 32;
parameter WIDTH2 = 5;

input [WIDTH1 - 1 : 0] wdata;
input [WIDTH2 - 1 : 0] addr;
output [WIDTH1 - 1 : 0] rdata;

// define register file of 32 (1 << WIDTH2) registers of 32 (WIDTH1) bits
reg [WIDTH1 - 1 : 0] RegFile [0 : (1 << WIDTH2) - 1];

integer i;

// for data update and reset
always@(posedge clk) begin
  if (reset) begin
	for (i = 0; i < (1 << WIDTH2); i++ ) begin
		RegFile[i] <= 0; 
	end // for end
  end //if end
else begin
  if (sel & wr)
	RegFile[addr] <= wdata;
  end // else end
end //always end

// For read
assign rdata = (sel & !wr) ? RegFile[addr] : 0;

endmodule
