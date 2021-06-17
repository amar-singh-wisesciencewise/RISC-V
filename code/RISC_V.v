`timescale 1ns / 1ps

module riscv(clk, reset, iwr, iaddr, idata, wr, addr, data_out, re, data_in);

input clk, reset;

parameter BUS_WIDTH = 32;
parameter REG_WIDTH = 5;
parameter INSTR_TYPE_WIDTH = 8;

output [BUS_WIDTH-1 : 0] iaddr;
output [BUS_WIDTH-1 : 0] addr;
output [BUS_WIDTH-1 : 0] data_out;

input [BUS_WIDTH-1 : 0] idata;
input [BUS_WIDTH-1 : 0] data_in;
output reg iwr = 1'b0;
output reg wr /* store */, re /* load */;

reg [BUS_WIDTH-1 : 0] pc;
reg [BUS_WIDTH-1 : 0] pc_fetch;
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
wire [BUS_WIDTH-1 : 0] imm; //immediate of decoder
wire rde, rs1e, rs2e;
wire [REG_WIDTH-1 : 0] rs1, rs2, rd;
wire [INSTR_TYPE_WIDTH-1 : 0] instr_type;

wire [BUS_WIDTH-1 : 0] rs1_data; //rs1 data of RF
wire [BUS_WIDTH-1 : 0] rs2_data; //rs2 data of RF
reg [BUS_WIDTH-1 : 0] rs1_data_rf; //rs1 data of RF
reg [BUS_WIDTH-1 : 0] rs2_data_rf; //rs2 data of RF
reg [BUS_WIDTH-1 : 0] rs1_data_execute; //rs1 data of execute
reg [BUS_WIDTH-1 : 0] rs2_data_execute; //rs2 data of execute

wire [BUS_WIDTH-1 : 0] result; //execute result
reg [BUS_WIDTH-1 : 0] result_execute; //execute result of execute
reg [BUS_WIDTH-1 : 0] result_ls; //execute result of ls
wire is_taken; //is branch taken...TRUE if PC needs to be changed
reg is_taken_execute;
reg is_taken_ls;

wire [BUS_WIDTH-1 : 0] rdata_; //for load store module

decoder dec1(.reset(reset), .inst(inst), .instr_type(instr_type), .rs1(rs1), .rs2(rs2), .rd(rd), .rs1e(rs1e), .rs2e(rs2e), .rde(rde), .imm(imm));
execute ex1(.reset(reset), .instr_type(instr_type_rf), .pc(pc_rf), .rs1(rs1_data_rf), .rs2(rs2_data_rf), .imm(imm_rf), .result(result), .is_taken(is_taken));

risc_v_rf rf1(.reset(reset), .wr(rde_ls), .waddr(rd_ls), .wdata(result_ls), .re1(rs1e_decoder), .raddr1(rs1_decoder), .rdata1(rs1_data), .re2(rs2e_decoder), .raddr2(rs2_decoder), .rdata2(rs2_data));
assign iaddr = pc; //instruction to be always fetched from PC address
assign addr = result_execute;
assign data_out = rs2_data_execute; //store rs2

// PC logic
always@(posedge clk) begin
	if (reset) begin
		pc <= 0;
	end else begin
	//if branch change the PC
		if (is_taken)
			pc <= result;
		else
			pc <= pc + 4;
	end // else end
end //always

//fetch block
always@(posedge clk) begin
	pc_fetch <= pc;
	inst <= idata;
//	$display("%x",inst);
end //always end

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
		pc_decoder <= pc_fetch; //propogate	
		instr_type_decoder <= instr_type;
		rs1_decoder <= rs1;
		rs2_decoder <= rs2;
		rd_decoder <= rd;
		rs1e_decoder <= rs1e;
		rs2e_decoder <= rs2e;
		rde_decoder <= rde;
		imm_decoder <= imm;
//	$display("instr type %x imm %x rs1 %x rs2 %x rd %x valid %x%x%x", instr_type, imm, rs1, rs2, rd, rs1e, rs2e, rde);
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
		rs1_data_rf <= 0;
		rs2_data_rf <= 0;
	end else begin
		pc_rf <= pc_decoder; //propogate	
		instr_type_rf <= instr_type_decoder;
		rs1_rf <= rs1_decoder;
		rs2_rf <= rs2_decoder;
		rd_rf <= rd_decoder;
		rs1e_rf <= rs1e_decoder;
		rs2e_rf <= rs2e_decoder;
		rde_rf <= rde_decoder;
		imm_rf <= imm_decoder;

		//use decoder values for register file read
		rs1_data_rf <= rs1_data;
		rs2_data_rf <= rs2_data;
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
		rs1_data_execute <= 0;
		rs2_data_execute <= 0;
		result_execute <= 0;
		is_taken_execute <= 0;
		re <= 1'b0;
		wr <= 1'b0;
	end else begin
		pc_execute <= pc_rf; //propogate	
		instr_type_execute <= instr_type_rf;
		rs1_execute <= rs1_rf;
		rs2_execute <= rs2_rf;
		rd_execute <= rd_rf;
		rs1e_execute <= rs1e_rf;
		rs2e_execute <= rs2e_rf;
		rde_execute <= rde_rf;
		imm_execute <= imm_rf;

		rs1_data_execute <= rs1_data_rf;
		rs2_data_execute <= rs2_data_rf;

		if (instr_type_rf == `IS_LOAD) begin
			re <= 1'b1;
			wr <= 1'b0;
		end else if (instr_type_rf == `IS_STORE) begin
			wr <= 1'b1;
			re <= 1'b0;
		end else begin
			re <= 1'b0;
			wr <= 1'b0;
		end

		result_execute <= result;
		is_taken_execute <= is_taken;
//		$display("result %h",result_execute);
		
	end //else
end //always end


//load and store block
always@(posedge clk) begin
	if (reset) begin
		pc_ls <= 0;
		instr_type_ls <= 0;
		rs1_ls <= 0;
		rs2_ls <= 0;
		rd_ls <= 0;
		rs1e_ls <= 0;
		rs2e_ls <= 0;
		rde_ls <= 0;
		imm_ls <= 0;
		result_ls <= 0;
	end else begin
		pc_ls <= pc_execute; //propogate	
		instr_type_ls <= instr_type_execute;
		rs1_ls <= rs1_execute;
		rs2_ls <= rs2_execute;
		rd_ls <= rd_execute;
		rs1e_ls <= rs1e_execute;
		rs2e_ls <= rs2e_execute;
		rde_ls <= rde_execute;
		imm_ls <= imm_execute;

		if (instr_type_execute == `IS_LOAD)
			result_ls <= data_in;
		else
			result_ls <= result_execute;
	end //else
end //always end

endmodule
