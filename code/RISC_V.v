`timescale 1ns / 1ps

module riscv(clk, reset, iwr, iaddr, idata, wr, addr, data_in, data_out);

input clk, reset, iwr, wr;

parameter BUS_WIDTH = 32;
parameter REG_WIDTH = 5;
parameter INSTR_TYPE_WIDTH = 8;

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

reg [INSTR_TYPE_WIDTH-1 : 0] instr_type_decoder; //decoded instruction
reg [INSTR_TYPE_WIDTH-1 : 0] instr_type_rf;
reg [INSTR_TYPE_WIDTH-1 : 0] instr_type_execute;
reg [INSTR_TYPE_WIDTH-1 : 0] instr_type_ls;
reg [INSTR_TYPE_WIDTH-1 : 0] instr_type_wb;
reg [REG_WIDTH-1 : 0] rs1_decoder; //rs1
reg [REG_WIDTH-1 : 0] rs2_decoder; //rs2
reg [REG_WIDTH-1 : 0] rd_decoder; //rd
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
reg [BUS_WIDTH-1 : 0] imm_decoder; //immediate for decoder 
reg [BUS_WIDTH-1 : 0] imm_rf; //for RF
reg [BUS_WIDTH-1 : 0] imm_execute; //for execute
reg [BUS_WIDTH-1 : 0] imm_ls; //for load store
reg [BUS_WIDTH-1 : 0] imm_wb; //for write back

reg rde_decoder, rs1e_decoder, rs2e_decoder; //enable signals of rs1 rs2 and rd
reg rde_rf, rs1e_rf, rs2e_rf;
reg rde_execute, rs1e_execute, rs2e_execute;
reg rde_ls, rs1e_ls, rs2e_ls;
reg rde_wb, rs1e_wb, rs2e_wb;
wire [BUS_WIDTH-1 : 0] imm; //immediate
wire rde, rs1e, rs2e;
wire [REG_WIDTH-1 : 0] rs1, rs2, rd;
wire [INSTR_TYPE_WIDTH-1 : 0] instr_type;

wire [BUS_WIDTH-1 : 0] rs1_data; //rs1 data of RF
wire [BUS_WIDTH-1 : 0] rs2_data; //rs2 data of RF
reg [BUS_WIDTH-1 : 0] rs1_data_alu; //rs1 data of RF
reg [BUS_WIDTH-1 : 0] rs2_data_alu; //rs2 data of RF

wire [BUS_WIDTH-1 : 0] result_; //execute result
reg [BUS_WIDTH-1 : 0] result; //execute result of execute
wire is_taken; //is branch taken...TRUE if PC needs to be changed

decoder dec1(.clk(clk), .reset(reset), .inst(inst), .instr_type(instr_type), .rs1(rs1), .rs2(rs2), .rd(rd), .rs1e(rs1e), .rs2e(rs2e), .rde(rde), .imm(imm));
register_file_read rf_r1(.clk(clk), .reset(reset), .rs1e(rs1e_decoder), .rs2e(rs2e_decoder),  .rs1(rs1_decoder), .rs2(rs2_decoder), .rs1_data(rs1_data), .rs2_data(rs2_data));
execute ex1(.clk(clk), .reset(reset), .instr_type(instr_type_rf), .pc(pc_execute), .rs1(rs1_data_alu), .rs2(rs2_data_alu), .imm(imm_rf), .result(result_), .is_taken(is_taken));

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

//Register File read block
always@(posedge clk) begin
	if (reset) begin
		pc_rf <= 0;
		instr_type_rf <= 0;
		rs1_rf <= 0;
		rs2_rf <= 0;
		rd_rf <= 0;
		rs1e_rf <= 0;
		rs2e_rf <= 0;
		rde_rf <= 0;
		imm_rf <= 0;
	end else begin
		pc_execute <= pc_rf; //propogate	
		instr_type_rf <= instr_type_decoder;
		rs1_rf <= rs1_decoder;
		rs2_rf <= rs2_decoder;
		rd_rf <= rd_decoder;
		rs1e_rf <= rs1e_decoder;
		rs2e_rf <= rs2e_decoder;
		rde_rf <= rde_decoder;
		imm_rf <= imm_decoder;

		//use decoder values for register file read
		rs1_data_alu <= rs1_data;
		rs2_data_alu <= rs2_data;
	end //else
end //always end


//execute block
always@(posedge clk) begin
	if (reset) begin
		pc_execute <= 0;
		instr_type_execute <= 0;
		rs1_execute <= 0;
		rs2_execute <= 0;
		rd_execute <= 0;
		rs1e_execute <= 0;
		rs2e_execute <= 0;
		rde_execute <= 0;
		imm_execute <= 0;
	end else begin
		pc_ls <= pc_execute; //propogate	
		instr_type_execute <= instr_type_rf;
		rs1_execute <= rs1_rf;
		rs2_execute <= rs2_rf;
		rd_execute <= rd_rf;
		rs1e_execute <= rs1e_rf;
		rs2e_execute <= rs2e_rf;
		rde_execute <= rde_rf;
		imm_execute <= imm_rf;

		result <= result_;
	end //else
end //always end

endmodule
