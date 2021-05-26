
`timescale 1ns / 1ps

/*
`define IS_R_TYPE 0
`define IS_I_TYPE 1
`define IS_S_TYPE 2
`define IS_B_TYPE 3
`define IS_U_TYPE 4
`define IS_J_TYPE 5
*/

`define IS_LUI 6 
`define IS_AUIPC 7 
`define IS_JAL 8 
`define IS_JALR 9

`define IS_BEQ 10 
`define IS_BNE 11
`define IS_BLT 12
`define IS_BGE 13
`define IS_BLTU 14 
`define IS_BGEU 15

`define IS_ADDI 16
`define IS_SLTI 17
`define IS_SLTIU 18 
`define IS_XORI 19
`define IS_ORI 20
`define IS_ANDI 21 
`define IS_SLLI 22
`define IS_SRLI 23
`define IS_SRAI 24
`define IS_ADD 25
`define IS_SUB 26
`define IS_SLL 27
`define IS_SLT 28
`define IS_SLTU 29 
`define IS_XOR 30
`define IS_SRL 31
`define IS_SRA 32
`define IS_OR 33
`define IS_AND 34 
`define IS_LOAD 35

`define IS_U_INSTR(x) ((x[6:2] == 5'b01101) || (x[6:2] == 5'b00101))
`define IS_I_INSTR(x) ((x[6:2] == 5'b00001) || (x[6:2] == 5'b11001) || (x[6:2] == 5'b00000) || (x[6:2] == 5'b00100) || (x[6:2] == 5'b00110))

`define IS_R_INSTR(x) ((x[6:2] == 5'b01011) || (x[6:2] == 5'b01100) || (x[6:2] == 5'b01110) || (x[6:2] == 5'b10100))
`define IS_S_INSTR(x) ((x[6:2] == 5'b01001) || (x[6:2] == 5'b01000))
`define IS_B_INSTR(x) ((x[6:2] == 5'b11000))
`define IS_J_INSTR(x) ((x[6:2] == 5'b11011))

`define FUNCT3 (inst[14:12])
`define FUNCT7 (inst[31:25])
`define OPCODE (inst[6:0])

module decoder(clk, reset, inst, instr_type, rde, rd, rs1e, rs2e,  rs1, rs2, imm);
parameter WIDTH = 32;
parameter REG_WIDTH = 5;

input clk, reset;
input [WIDTH-1 : 0] inst;
output reg [8 : 0] instr_type; //instruction type
output reg [WIDTH-1 : 0] imm; //immediate value if there

output reg [REG_WIDTH-1 : 0] rs1; //source register 1
output reg [REG_WIDTH-1 : 0] rs2; // source register 2
output reg [REG_WIDTH-1 : 0] rd;  //register destination
output reg rde; //destination write is valid
output reg rs1e; //source rs1 is valid
output reg rs2e; //source rs2 is valid

always@(posedge clk) begin
	rs1 <= inst[19:15];
	rs2 <= inst[24:20];
	rd  <= inst[11:7];
	rs1e <= (`IS_R_INSTR(inst) || `IS_I_INSTR(inst) || `IS_S_INSTR(inst) || `IS_B_INSTR(inst));
	rs2e <= (`IS_R_INSTR(inst) || `IS_S_INSTR(inst) || `IS_B_INSTR(inst));
	rde <= (`IS_R_INSTR(inst) || `IS_I_INSTR(inst) || `IS_U_INSTR(inst) || `IS_J_INSTR(inst));


	//Decoding istruction type
	if (7'b0110111 == `OPCODE)
		instr_type <= `IS_LUI;
	else if (7'b0000011 == `OPCODE)
		instr_type <= `IS_LOAD;
	else if (7'b0010111 == `OPCODE)
		instr_type <= `IS_AUIPC;
	else if (7'b1101111 == `OPCODE)
		instr_type <= `IS_JAL;
	else if ((7'b1100111 == `OPCODE) && (3'b000 == `FUNCT3))
		instr_type <= `IS_JALR;
	else if ((7'b1100011 == `OPCODE) && (3'b000 == `FUNCT3))
		instr_type <= `IS_BEQ;
	else if ((7'b1100011 == `OPCODE) && (3'b001 == `FUNCT3))
		instr_type <= `IS_BNE;
	else if ((7'b1100011 == `OPCODE) && (3'b100 == `FUNCT3))
		instr_type <= `IS_BLT;
	else if ((7'b1100011 == `OPCODE) && (3'b101 == `FUNCT3))
		instr_type <= `IS_BGE;
	else if ((7'b1100011 == `OPCODE) && (3'b110 == `FUNCT3))
		instr_type <= `IS_BLTU;
	else if ((7'b1100011 == `OPCODE) && (3'b111 == `FUNCT3))
		instr_type <= `IS_BGEU;

	else if ((7'b0010011 == `OPCODE) && (3'b000 == `FUNCT3))
		instr_type <= `IS_ADDI;
	else if ((7'b0010011 == `OPCODE) && (3'b010 == `FUNCT3))
		instr_type <= `IS_SLTI;

	else if ((7'b0010011 == `OPCODE) && (3'b011 == `FUNCT3))
		instr_type <= `IS_SLTIU;
	else if ((7'b0010011 == `OPCODE) && (3'b100 == `FUNCT3))
		instr_type <= `IS_XORI;
	else if ((7'b0010011 == `OPCODE) && (3'b110 == `FUNCT3))
		instr_type <= `IS_ORI;
	else if ((7'b0010011 == `OPCODE) && (3'b111 == `FUNCT3))
		instr_type <= `IS_ANDI;
	else if ((7'b0010011 == `OPCODE) && (3'b001 == `FUNCT3) &&(7'b0000000 == `FUNCT7))
		instr_type <= `IS_SLLI;
	else if ((7'b0010011 == `OPCODE) && (3'b101 == `FUNCT3) &&(7'b0000000 == `FUNCT7))
		instr_type <= `IS_SRLI;
	else if ((7'b0010011 == `OPCODE) && (3'b101 == `FUNCT3) &&(7'b0100000 == `FUNCT7))
		instr_type <= `IS_SRAI;


	else if ((7'b0110011 == `OPCODE) && (3'b000 == `FUNCT3) &&(7'b0000000 == `FUNCT7))
		instr_type <= `IS_ADD;
	else if ((7'b0110011 == `OPCODE) && (3'b000 == `FUNCT3) &&(7'b0100000 == `FUNCT7))
		instr_type <= `IS_SUB;
	else if ((7'b0110011 == `OPCODE) && (3'b001 == `FUNCT3) &&(7'b0000000 == `FUNCT7))
		instr_type <= `IS_SLL;
	else if ((7'b0110011 == `OPCODE) && (3'b010 == `FUNCT3) &&(7'b0000000 == `FUNCT7))
		instr_type <= `IS_SLT;
	else if ((7'b0110011 == `OPCODE) && (3'b011 == `FUNCT3) &&(7'b0000000 == `FUNCT7))
		instr_type <= `IS_SLTU;
	else if ((7'b0110011 == `OPCODE) && (3'b100 == `FUNCT3) &&(7'b0000000 == `FUNCT7))
		instr_type <= `IS_XOR;
	else if ((7'b0110011 == `OPCODE) && (3'b101 == `FUNCT3) &&(7'b0000000 == `FUNCT7))
		instr_type <= `IS_SRL;
	else if ((7'b0110011 == `OPCODE) && (3'b101 == `FUNCT3) &&(7'b0100000 == `FUNCT7))
		instr_type <= `IS_SRA;
	else if ((7'b0110011 == `OPCODE) && (3'b110 == `FUNCT3) &&(7'b0000000 == `FUNCT7))
		instr_type <= `IS_OR;
	else if ((7'b0110011 == `OPCODE) && (3'b111 == `FUNCT3) &&(7'b0000000 == `FUNCT7))
		instr_type <= `IS_AND;
	else
		instr_type <= 7'b1111111;

	//Generating Immediate value
	if (`IS_I_INSTR(inst))
		imm <= { {21{inst[31]}}, inst[30:20]};
	else if (`IS_S_INSTR(inst))
		imm <= { {21{inst[31]}}, inst[30:25], inst[11:7] };
	else if (`IS_B_INSTR(inst))
		imm <= { {20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0 };
	else if (`IS_U_INSTR(inst))
		imm <= { inst[31], inst[30:12], 12'b0 };
	else if (`IS_J_INSTR(inst))
		imm <= { {12{inst[31]}}, inst[19:12], inst[20], inst[30:21], 1'b0 };
	else
		imm <= 32'b0;
	
	$display("instr type %x imm %x rs1 %x rs2 %x rd %x valid %x%x%x", instr_type, imm, rs1, rs2, rd, rs1e, rs2e, rde);
end //always end

endmodule
