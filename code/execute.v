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
		begin
		result <= rs1 + imm;
		is_taken <= 0;
		end
	`IS_ADD :
		begin
		result <= rs1 + rs2;
		is_taken <= 0;
		end
	`IS_ANDI :
		begin
		result <= rs1 & imm;
		is_taken <= 0;
		end
	`IS_ORI :
		begin
		result <= rs1 | imm;
		is_taken <= 0;
		end
	`IS_XORI :
		begin
		result <= rs1 ^ imm;
		is_taken <= 0;
		end
	`IS_SLLI :
		begin
		result <= rs1 << imm[5:0];
		is_taken <= 0;
		end
	`IS_SRLI :
		begin
		result <= rs1 >> imm[5:0];
		is_taken <= 0;
		end
	`IS_AND :
		begin
		result <= rs1 & rs2;
		is_taken <= 0;
		end
	`IS_OR :
		begin
		result <= rs1 | rs2;
		is_taken <= 0;
		end
	`IS_XOR :
		begin
		result <= rs1 ^ rs2;
		is_taken <= 0;
		end
	`IS_SUB :
		begin
		result <= rs1 - rs2;
		is_taken <= 0;
		end
	`IS_SLL :
		begin
		result <= rs1 << rs2[4:0];
		is_taken <= 0;
		end
	`IS_SRL :
		begin
		result <= rs1 >> rs2[4:0];
		is_taken <= 0;
		end
	`IS_SLTU :
		begin
		result <=  {31'b0, (rs1 < rs2)};
		is_taken <= 0;
		end
	`IS_SLTIU :
		begin
		result <= {31'b0, (rs1 < imm)};
		is_taken <= 0;
		end
	`IS_LUI :
		begin
		result <= { imm[31:12], 12'b0 };
		is_taken <= 0;
		end
	`IS_AUIPC :
		begin
		result <= pc + imm;
		is_taken <= 0;
		end
	`IS_JAL :
		begin
		result <= pc + imm;
		is_taken <= 0;
		end
	`IS_JALR :
		begin
		result <= rs1 + imm;
		is_taken <= 0;
		end
	`IS_SLT :
		begin
		result <= (rs1[31] == rs2[31]) ? ({31'b0, (rs1 < rs2)}) : ({31'b0, rs1[31]});
		is_taken <= 0;
		end
	`IS_SLTI :
		begin
		result <= (rs1[31] == imm[31]) ? ({31'b0, (rs1 < imm)}) : ({31'b0, imm[31]});
		is_taken <= 0;
		end
	`IS_SRA  :
		begin
		result <= rs1 >>> rs2[4:0]; //right shift with sign extention
		is_taken <= 0;
		end
	`IS_SRAI :
		begin
		result <= rs1 >>> imm[4:0];
		is_taken <= 0;
		end
	`IS_LOAD :
		begin
		result <= rs1  + imm;
		is_taken <= 0;
		end
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
		begin
		result <= 0;
		is_taken <= 0;
		end

	endcase
	end //else end

end //always end

endmodule
