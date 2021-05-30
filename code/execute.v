`timescale 1ns/1ps

module execute(clk, reset, instr_type, pc, rs1, rs2, imm, result, is_taken);
parameter WIDTH = 32;
parameter REG_WIDTH = 5;
parameter INSTR_TYPE_WIDTH = 8;

input clk, reset;
input [INSTR_TYPE_WIDTH-1 : 0] instr_type; //instruction type
input [WIDTH-1 : 0] imm; //immediate value if there
input [WIDTH-1 : 0] rs1; //rs1 value
input [WIDTH-1 : 0] rs2; //rs2 value
input [WIDTH-1 : 0] pc; // program counter

output reg [WIDTH-1 : 0] result; //output of ALU
output reg is_taken;

always@(posedge clk) begin
	if(reset) begin
		result <= 0;
	end else begin

	case(instr_type)
	`IS_ADDI :
		result <= rs1 + imm;
	`IS_ADD :
		result <= rs1 + rs2;
	`IS_ANDI :
		result <= rs1 & imm;
	`IS_ORI :
		result <= rs1 | imm;
	`IS_XORI :
		result <= rs1 ^ imm;
	`IS_SLLI :
		result <= rs1 << imm[5:0];
	`IS_SRLI :
		result <= rs1 >> imm[5:0];
	`IS_AND :
		result <= rs1 & rs2;
	`IS_OR :
		result <= rs1 | rs2;
	`IS_XOR :
		result <= rs1 ^ rs2;
	`IS_SUB :
		result <= rs1 - rs2;
	`IS_SLL :
		result <= rs1 << rs2[4:0];
	`IS_SRL :
		result <= rs1 >> rs2[4:0];
	`IS_SLTU :
		result <=  {31'b0, (rs1 < rs2)};
	`IS_SLTIU :
		result <= {31'b0, (rs1 < imm)};
	`IS_LUI :
		result <= { imm[31:12], 12'b0 };
	`IS_AUIPC :
		result <= pc + imm;
	`IS_JAL :
		result <= pc + imm;
	`IS_JALR :
		result <= rs1 + imm;
	`IS_SLT :
		result <= (rs1[31] == rs2[31]) ? ({31'b0, (rs1 < rs2)}) : ({31'b0, rs1[31]});
	`IS_SLTI :
		result <= (rs1[31] == imm[31]) ? ({31'b0, (rs1 < imm)}) : ({31'b0, imm[31]});
	`IS_SRA  :
		result <= rs1 >>> rs2[4:0]; //right shift with sign extention
	`IS_SRAI :
		result <= rs1 >>> imm[4:0];
	`IS_LOAD :
		result <= rs1  + imm;
	`IS_BEQ :
		begin
		result <= rs1 + imm;
		is_taken <= (rs1 == rs2) ? 1'b1 : 1'b0;
		end
	`IS_BNE :
		begin
		result <= rs1 + imm;
		is_taken <= (rs1 != rs2) ? 1'b1 : 1'b0;
		end
	`IS_BLT :
		begin
		result <= rs1 + imm;
		is_taken <= ((rs1 < rs2) ^ (rs1[31] != rs2[31])) ? 1'b1 : 1'b0;
		end
	`IS_BGE :
		begin
		result <= rs1 + imm;
		is_taken <= ((rs1 >= rs2) ^ (rs1[31] != rs2[31])) ? 1'b1 : 1'b0;
		end
	`IS_BLTU :
		begin
		result <= rs1 + imm;
		is_taken <= (rs1 < rs2) ? 1'b1 : 1'b0;
		end
	`IS_BGEU :
		begin
		result <= rs1 + imm;
		is_taken <= (rs1 >= rs2) ? 1'b1 : 1'b0;
		end
	default :
		result <= 0;

	endcase
	end //else end

end //always end

endmodule
