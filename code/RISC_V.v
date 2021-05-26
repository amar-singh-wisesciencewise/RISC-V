`timescale 1ns / 1ps

module riscv(clk, reset, iwr, iaddr, idata, wr, addr, data_in, data_out);

input clk, reset, iwr, wr;

parameter BUS_WIDTH = 32;
parameter REG_WIDTH = 5;
parameter INSTR_TYPE_WIDTH = 9;

output reg [BUS_WIDTH-1 : 0] iaddr;
output reg [BUS_WIDTH-1 : 0] addr;
output reg [BUS_WIDTH-1 : 0] data_out;

input [BUS_WIDTH-1 : 0] idata;
input [BUS_WIDTH-1 : 0] data_in;

reg [BUS_WIDTH-1 : 0] pc;
reg [BUS_WIDTH-1 : 0] pc_decoder;
reg [BUS_WIDTH-1 : 0] pc_rf; //pc for register file
reg [BUS_WIDTH-1 : 0] pc_execute;
reg [BUS_WIDTH-1 : 0] pc_ls; // pc for load store
reg [BUS_WIDTH-1 : 0] pc_wb; //pc for write back

reg [BUS_WIDTH-1 : 0] inst; //instruction for fetch stage

reg [INSTR_TYPE_WIDTH-1 : 0] instr_type_decoder;
reg [INSTR_TYPE_WIDTH-1 : 0] instr_type_rf;
reg [INSTR_TYPE_WIDTH-1 : 0] instr_type_execute;
reg [INSTR_TYPE_WIDTH-1 : 0] instr_type_ls;
reg [INSTR_TYPE_WIDTH-1 : 0] instr_type_wb;
reg [REG_WIDTH-1 : 0] rs1_decoder; 
reg [REG_WIDTH-1 : 0] rs2_decoder; 
reg [REG_WIDTH-1 : 0] rd_decoder; 
reg [REG_WIDTH-1 : 0] rs1_rf; 
reg [REG_WIDTH-1 : 0] rs2_rf; 
reg [REG_WIDTH-1 : 0] rd_rf; 
reg [REG_WIDTH-1 : 0] rs1_execute; 
reg [REG_WIDTH-1 : 0] rs2_execute; 
reg [REG_WIDTH-1 : 0] rd_execute; 
reg [REG_WIDTH-1 : 0] rs1_ls; 
reg [REG_WIDTH-1 : 0] rs2_ls; 
reg [REG_WIDTH-1 : 0] rd_ls; 
reg [REG_WIDTH-1 : 0] rs1_wb; 
reg [REG_WIDTH-1 : 0] rs2_wb; 
reg [REG_WIDTH-1 : 0] rd_wb; 
reg [BUS_WIDTH-1 : 0] imm_decoder; //instruction
reg rde_decoder, rs1e_decoder, rs2e_decoder;
wire [BUS_WIDTH-1 : 0] imm; //instruction
wire rde, rs1e, rs2e;
wire [REG_WIDTH-1 : 0] rs1, rs2, rd;
wire [INSTR_TYPE_WIDTH-1 : 0] instr_type;


decoder dec1(.clk(clk), .reset(reset), .inst(inst), .instr_type(instr_type), .rs1(rs1), .rs2(rs2), .rd(rd), .rs1e(rs1e), .rs2e(rs2e), .rde(rde), .imm(imm));
// PC logic and fetch logic
always@(posedge clk) begin
	if (reset) begin
		pc <= 0;
	end else begin
		pc <= pc + 1;
		pc_decoder <= pc;
		iaddr <= pc;
		inst <= idata;
		$display("%x",inst);
	end // else end
end //always

//decode block
always@(posedge clk) begin
	if (reset) begin
		pc_decoder <= 0;
		instr_type_decoder <= 0;
		rs1_decoder <= 0;
		rs2_decoder <= 0;
		rd_decoder <= 0;
		rs1e_decoder <= 0;
		rs2e_decoder <= 0;
		rde_decoder <= 0;
		imm_decoder <= 0;
	end else begin
		pc_rf <= pc_decoder; //propogate	
		instr_type_decoder <= instr_type;
		rs1_decoder <= rs1;
		rs2_decoder <= rs2;
		rd_decoder <= rd;
		rs1e_decoder <= rs1e;
		rs2e_decoder <= rs2e;
		rde_decoder <= rde;
		imm_decoder <= imm;
	end //else
end //always 



endmodule
