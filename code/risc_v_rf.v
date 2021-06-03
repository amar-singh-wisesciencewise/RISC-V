`timescale 1ns / 1ps

module risc_v_rf(reset, wr, waddr, wdata, re1, raddr1, rdata1, re2, raddr2, rdata2);

input reset, wr, re1, re2;

parameter WIDTH1 = 32;
parameter WIDTH2 = 5;

input [WIDTH1 - 1 : 0] wdata;
input [WIDTH2 - 1 : 0] waddr;
input [WIDTH2 - 1 : 0] raddr1;
input [WIDTH2 - 1 : 0] raddr2;
output reg [WIDTH1 - 1 : 0] rdata1;
output reg [WIDTH1 - 1 : 0] rdata2;

// define register file of 32 (1 << WIDTH2) registers of 32 (WIDTH1) bits
reg [WIDTH1 - 1 : 0] RegFile [0 : (1 << WIDTH2) - 1];

integer i;

// for data update and reset
always@(*) begin
  if (reset) begin
	for (i = 0; i < (1 << WIDTH2); i++ ) begin
		RegFile[i] <= 0; 
	end // for end
  end //if end
  else begin
    if (wr && (waddr != 0)) //R0 cannot be written
	RegFile[waddr] <= wdata;
  end //else end
end //always end


always@(*) begin
    if (re1 && (wr && (waddr == raddr1)))
	rdata1 <= wdata;
    else if (~re1)
	rdata1 <= 0;
    else
	rdata1 <= RegFile[raddr1];
end //always end

always@(*) begin
    if (re2 && (wr && (waddr == raddr2)))
	rdata2 <= wdata;
    else if (~re2)
	rdata2 <= 0;
    else
	rdata2 <= RegFile[raddr2];
end //always end

endmodule
