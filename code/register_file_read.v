`timescale 1ns/1ps

module register_file_read(clk, reset, rs1e, rs2e,  rs1, rs2, rs1_data, rs2_data);
parameter WIDTH = 32;
parameter REG_WIDTH = 5;

input clk, reset;

input [REG_WIDTH-1 : 0] rs1; //source register 1
input [REG_WIDTH-1 : 0] rs2; // source register 2
input rs1e; //source rs1 is valid
input rs2e; //source rs2 is valid

output reg [WIDTH-1 : 0] rs1_data; //rs1
output reg [WIDTH-1 : 0] rs2_data; //rs2

reg [REG_WIDTH-1 : 0] rd_ = 0; // destination register is 0 since not write back stage
reg wr_ = 0; // write enable 0
wire [WIDTH-1 : 0] rs1_data_; //rs1 wire
wire [WIDTH-1 : 0] rs2_data_; //rs2 wire
wire [WIDTH-1 : 0] wdata_ = 0; //write data 0

risc_v_rf rf1 (.clk(clk), .reset(reset), .wr(wr_), .waddr(rd_), .wdata(wdata_), .re1(rs1e), .raddr1(rs1), .rdata1(rs1_data_), .re2(rs1e), .raddr2(rs2), .rdata2(rs2_data_));

always@(posedge clk) begin
	if (reset) begin
		rs1_data <= 0;
		rs2_data <= 0;
	end else begin
		//TODO: add stall logic
		rs1_data <= rs1_data_;
		rs2_data <= rs2_data_;
	end//else end
end //always end
endmodule
