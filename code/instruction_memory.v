

`timescale 1ns / 1ps


// this memory is degined for instruction and only read port will be used
//by the PC and write port will be used by testbench to fill the instructions.
module instruction_memory(reset, addr, rdata, wr, wdata );

input reset, wr;

parameter WIDTH1 = 32;
parameter MEM_SIZE = 1024; //when changed please correct in testbench file as well

/* Instruction should be satrted from below this loaction.
 As above that is reserved for ABI support in case binary file is loaded*/
parameter INST_POSTION = 10;

input [WIDTH1-1 : 0] addr;
input [WIDTH1-1 : 0] wdata;

output reg [WIDTH1-1 : 0] rdata;

reg [WIDTH1-1: 0]imem [MEM_SIZE-1 : 0];

integer i = 0;

initial begin
/* Initializing the stack pointer. Code will be auto loaded from position 1 */
imem[0] = {12'd256, 5'd0, 3'b000, 5'd2, 7'b0010011}; //ADDI R2,R0,256;
/* Pointing to the end of Instruction mem in X1 i.e. LR Register for ABI */
imem[1] = {12'd1023, 5'd0, 3'b000, 5'd1, 7'b0010011}; //ADDI R1,R0,1023;
imem[2] = {12'd1, 5'd1, 3'b000, 5'd7, 7'b0010011}; //dummy
imem[3] = {12'd1, 5'd1, 3'b000, 5'd7, 7'b0010011}; //dummy
imem[4] = {12'd1, 5'd1, 3'b000, 5'd7, 7'b0010011}; //dummy
imem[5] = {12'd1, 5'd1, 3'b000, 5'd7, 7'b0010011}; //dummy
imem[6] = {12'd1, 5'd1, 3'b000, 5'd7, 7'b0010011}; //dummy
imem[7] = {12'd1, 5'd1, 3'b000, 5'd7, 7'b0010011}; //dummy
/* Undoing ABI changes so that below manual instructions can work */
imem[INST_POSTION - 1] = {12'd2, 5'd0, 3'b000, 5'd2, 7'b0010011}; //ADDI R2,R0,0;
imem[INST_POSTION - 2] = {12'd0, 5'd0, 3'b000, 5'd1, 7'b0010011}; //ADDI R1,R0,1023;
// START INSTRUCTIONS FROM POSITION INST_POSTION AS ABI RELATED ABOVE
/*
imem[0] = {12'd1, 5'd0, 3'b000, 5'd1, 7'b0010011};

imem[1] = {12'd2, 5'd0, 3'b000, 5'd2, 7'b0010011}; //ADDI R2,R0,0x2; 
imem[2] = {12'd3, 5'd0, 3'b000, 5'd3, 7'b0010011}; //ADDI R3,R0,0x3;
imem[3] = {12'd4, 5'd0, 3'b000, 5'd4, 7'b0010011};
imem[4] = {12'd5, 5'd0, 3'b000, 5'd5, 7'b0010011};
imem[5] = {12'd6, 5'd0, 3'b000, 5'd6, 7'b0010011};
imem[6] = {12'd7, 5'd0, 3'b000, 5'd7, 7'b0010011};
imem[7] = {12'd8, 5'd0, 3'b000, 5'd8, 7'b0010011};
imem[8] = {12'd9, 5'd0, 3'b000, 5'd9, 7'b0010011};
imem[9] = {12'd10, 5'd0, 3'b000, 5'd10, 7'b0010011};
imem[10] = {12'd11, 5'd0, 3'b000, 5'd11, 7'b0010011};
imem[11] = {12'd12, 5'd0, 3'b000, 5'd12, 7'b0010011};
imem[12] = {12'd13, 5'd0, 3'b000, 5'd13, 7'b0010011};
imem[13] = {12'd14, 5'd0, 3'b000, 5'd14, 7'b0010011};
imem[14] = {12'd15, 5'd0, 3'b000, 5'd15, 7'b0010011};
imem[15] = {12'd16, 5'd0, 3'b000, 5'd16, 7'b0010011};
imem[16] = {12'd17, 5'd0, 3'b000, 5'd17, 7'b0010011};
imem[17] = {12'd18, 5'd0, 3'b000, 5'd18, 7'b0010011};
imem[18] = {12'd19, 5'd0, 3'b000, 5'd19, 7'b0010011};
imem[19] = {12'd20, 5'd0, 3'b000, 5'd20, 7'b0010011};
imem[20] = {12'd21, 5'd0, 3'b000, 5'd21, 7'b0010011};
imem[21] = {12'd22, 5'd0, 3'b000, 5'd22, 7'b0010011};
imem[22] = {12'd23, 5'd0, 3'b000, 5'd23, 7'b0010011};
imem[23] = {12'd24, 5'd0, 3'b000, 5'd24, 7'b0010011};


imem[24] = {12'b00101, 5'd5, 3'b100, 5'd25, 7'b0010011}; //XORI R25,R5,0x05

imem[25] = {12'b010000, 5'd17, 3'b111, 5'd26, 7'b0010011}; //ANDI R26,R17,0x10

imem[26] = {6'b000000, 6'b010, 5'd1, 3'b001, 5'd27, 7'b0010011}; //SLLI R27,R1,0x2

imem[27] = {6'b000000, 6'b010, 5'd16, 3'b101, 5'd28, 7'b0010011}; //SRLI R28,R16,0x2

imem[28] = {7'b0000000, 5'd2, 5'd24, 3'b010, 5'b00000, 7'b0100011}; //Store mem[(R24 + 0)/4] = R2; i.e. mem[6] = 2;
imem[29] = {12'd16, 5'd0, 3'b010, 5'd29, 7'b0000011}; // R29 = mem[(R0 + 16)/4]; i.e. R29 = 4;
*/


//Branching testing
//Program to test loop which adds 1 to 9;
//ADDI, R14, R0, 0             // Initialize sum register R14 with 0
//ADDI, R12, R0, 1010          // Store count of 10 in register R12.
//ADDI, R13, R0, 1             // Initialize loop count register R13 with 1
// Loop:
//ADD, R14, R13, R14           // Incremental summation
//ADDI, R13, R13, 1            // Increment loop count by 1
//BLT, R13, R12, 1111111111000 // If R13 is less than R12, branch to label named <Loop>
//ADDI, R30, R14, 111111010100 // Subtract expected value of 44 to set R30 to 1 if and only if the result is 45 (1 + 2 + ... + 9)
//BGE, R0, R0, 0
imem[0 + INST_POSTION] = {12'd0, 5'd0, 3'b000, 5'd1, 7'b0010011};
imem[1 + INST_POSTION] = {12'd0, 5'd0, 3'b000, 5'd2, 7'b0010011};
imem[2 + INST_POSTION] = {12'd0, 5'd0, 3'b000, 5'd3, 7'b0010011};
imem[3 + INST_POSTION] = {12'd0, 5'd0, 3'b000, 5'd4, 7'b0010011};
imem[4 + INST_POSTION] = {12'd0, 5'd0, 3'b000, 5'd5, 7'b0010011};
imem[5 + INST_POSTION] = {12'd0, 5'd0, 3'b000, 5'd6, 7'b0010011};
imem[6 + INST_POSTION] = {12'd0, 5'd0, 3'b000, 5'd7, 7'b0010011};
imem[7 + INST_POSTION] = {12'd0, 5'd0, 3'b000, 5'd8, 7'b0010011};
imem[8 + INST_POSTION] = {12'd0, 5'd0, 3'b000, 5'd9, 7'b0010011};

imem[9 + INST_POSTION] = {12'b0, 5'd0, 3'b000, 5'd14, 7'b0010011}; // R14 = 0; 
imem[10 + INST_POSTION] = {12'b1010, 5'd0, 3'b000, 5'd12, 7'b0010011}; // R12 = 10;
imem[11 + INST_POSTION] = {12'b1, 5'd0, 3'b000, 5'd13, 7'b0010011}; // R13 = 1;

/*
imem[12] = {12'd1, 5'd1, 3'b000, 5'd1, 7'b0010011}; //dummy coomand to avoid data hazard
imem[13] = {12'd1, 5'd2, 3'b000, 5'd2, 7'b0010011}; // dummy for data hazard
imem[14] = {12'd1, 5'd3, 3'b000, 5'd3, 7'b0010011}; // dummy for data hazard
*/
imem[12 + INST_POSTION] = {7'b0000000, 5'd14, 5'd13, 3'b000, 5'd14, 7'b0110011}; // R14 = R14 + R13
imem[13 + INST_POSTION] = {12'b1, 5'd13, 3'b000, 5'd13, 7'b0010011}; // increment R13 
/*
imem[17] = {12'd1, 5'd4, 3'b000, 5'd4, 7'b0010011}; // data hazard dummy
imem[18] = {12'd1, 5'd5, 3'b000, 5'd5, 7'b0010011}; // data hazard dummy
imem[19] = {12'd1, 5'd6, 3'b000, 5'd6, 7'b0010011}; // data hazard dummy 
*/
imem[14 + INST_POSTION] = {1'b1, 6'b111111, 5'd12, 5'd13, 3'b100, 4'b1010, 1'b1, 7'b1100011}; //branch to instruction 14 if loop executed for 10 times
/*
imem[22] = {12'd1, 5'd1, 3'b000, 5'd1, 7'b0010011}; // dummy for control hazard
imem[23] = {12'd1, 5'd2, 3'b000, 5'd2, 7'b0010011}; // dummy for control hazard
imem[24] = {12'd1, 5'd3, 3'b000, 5'd3, 7'b0010011}; // dummy for control hazard
*/
imem[15 + INST_POSTION] = {12'b111111010100, 5'd14, 3'b000, 5'd30, 7'b0010011}; // subtract 44 from result expected to be 45.
imem[16 + INST_POSTION] = {1'b0, 6'b000000, 5'd0, 5'd0, 3'b101, 4'b0000, 1'b0, 7'b1100011}; // halt

imem[17 + INST_POSTION] = {12'd1, 5'd1, 3'b000, 5'd7, 7'b0010011}; //dummy
imem[18 + INST_POSTION] = {12'd1, 5'd2, 3'b000, 5'd8, 7'b0010011}; //dummy
imem[19 + INST_POSTION] = {12'd1, 5'd3, 3'b000, 5'd9, 7'b0010011}; //dummy


/*
imem[1] = {12'b111, 5'd0, 3'b000, 5'd2, 7'b0010011};
imem[2] = {12'b111111111100, 5'd0, 3'b000, 5'd3, 7'b0010011};
imem[3] = {12'b1011100, 5'd1, 3'b111, 5'd5, 7'b0010011};
imem[4] = {12'b10101, 5'd5, 3'b100, 5'd5, 7'b0010011};
imem[5] = {12'b1011100, 5'd1, 3'b110, 5'd6, 7'b0010011};
imem[6] = {12'b1011100, 5'd6, 3'b100, 5'd6, 7'b0010011};
imem[7] = {12'b111, 5'd1, 3'b000, 5'd7, 7'b0010011};
imem[8] = {12'b11101, 5'd7, 3'b100, 5'd7, 7'b0010011};
imem[9] = {6'b000000, 6'b110, 5'd1, 3'b001, 5'd8, 7'b0010011};
imem[10] = {12'b10101000001, 5'd8, 3'b100, 5'd8, 7'b0010011};
imem[11] = {6'b000000, 6'b10, 5'd1, 3'b101, 5'd9, 7'b0010011};
imem[12] = {12'b100, 5'd9, 3'b    100, 5'd9, 7'b0010011};
imem[13] = {7'b0000000, 5'd2, 5'd1, 3'b111, 5'd10, 7'b0110011};
imem[14] = {12'b100, 5'd10, 3'b100, 5'd10, 7'b0010011};
imem[15] = {7'b0000000, 5'd2, 5'd1, 3'b110, 5'd11, 7'b0110011};
imem[16] = {12'b10110, 5'd11, 3'b100, 5'd11, 7'b0010011};
imem[17] = {7'b0000000, 5'd2, 5'd1, 3'b100, 5'd12, 7'b0110011};
imem[18] = {12'b10011, 5'd12, 3'b100, 5'd12, 7'b0010011};
imem[19] = {7'b0000000, 5'd2, 5'd1, 3'b000, 5'd13, 7'b0110011};
imem[20] = {12'b11101, 5'd13, 3'b100, 5'd13, 7'b0010011};
imem[21] = {7'b0100000, 5'd2, 5'd1, 3'b000, 5'd14, 7'b0110011};
imem[22] = {12'b1111, 5'd14, 3'b100, 5'd14, 7'b0010011}; 
imem[23] = {7'b0000000, 5'd2, 5'd2, 3'b001, 5'd15, 7'b0110011};
imem[24] = {12'b1110000001, 5'd15, 3'b100, 5'd15, 7'b0010011};
imem[25] = {7'b0000000, 5'd2, 5'd1, 3'b101, 5'd16, 7'b0110011};
imem[26] = {12'b1, 5'd16, 3'b100, 5'd16, 7'b0010011};
imem[27] = {7'b0000000, 5'd1, 5'd2, 3'b011, 5'd17, 7'b0110011};
imem[28] = {12'b0, 5'd17, 3'b100, 5'd17, 7'b0010011};
imem[29] = {12'b10101, 5'd2, 3'b011, 5'd18, 7'b0010011};
imem[30] = {12'b0, 5'd18, 3'b100, 5'd18, 7'b0010011};
imem[31] = {20'b00000000000000000000, 5'd19, 7'b0110111};
imem[32] = {12'b1, 5'd19, 3'b100, 5'd19, 7'b0010011};
imem[33] = {6'b010000, 6'b1, 5'd3, 3'b101, 5'd20, 7'b0010011};
imem[34] = {12'b111111111111, 5'd20, 3'b100, 5'd20, 7'b0010011};
imem[35] = {7'b0000000, 5'd1, 5'd3, 3'b010, 5'd21, 7'b0110011};
imem[36] = {12'b0, 5'd21, 3'b100, 5'd21, 7'b0010011};
imem[37] = {12'b1, 5'd3, 3'b010, 5'd22, 7'b0010011};
imem[38] = {12'b0, 5'd22, 3'b100, 5'd22, 7'b0010011};
imem[39] = {7'b0100000, 5'd2, 5'd1, 3'b101, 5'd23, 7'b0110011};
imem[40] = {12'b1, 5'd23, 3'b100, 5'd23, 7'b0010011};
imem[41] = {20'b00000000000000000100, 5'd4, 7'b0010111};
imem[42] = {6'b000000, 6'b111, 5'd4, 3'b101, 5'd24, 7'b0010011};
imem[43] = {12'b10000000, 5'd24, 3'b100, 5'd24, 7'b0010011};
imem[44] = {1'b0, 10'b0000000010, 1'b0, 8'b00000000, 5'd25, 7'b1101111};
imem[45] = {20'b00000000000000000000, 5'd4, 7'b0010111};
imem[46] = {7'b0000000, 5'd4, 5'd25, 3'b100, 5'd25, 7'b0110011};
imem[47] = {12'b1, 5'd25, 3'b100, 5'd25, 7'b0010011};
imem[48] = {12'b10000, 5'd4, 3'b000, 5'd26, 7'b1100111};
imem[49] = {7'b0100000, 5'd4, 5'd26, 3'b000, 5'd26, 7'b0110011};
imem[50] = {12'b111111110001, 5'd26, 3'b000, 5'd26, 7'b0010011};
imem[51] = {7'b0000000, 5'd1, 5'd2, 3'b010, 5'b00001, 7'b0100011};
imem[52] = {12'b1, 5'd2, 3'b010, 5'd27, 7'b0000011};
imem[53] = {12'b10100, 5'd27, 3'b100, 5'd27, 7'b0010011};
imem[54] = {12'b1, 5'd0, 3'b000, 5'd28, 7'b0010011};
imem[55] = {12'b1, 5'd0, 3'b000, 5'd29, 7'b0010011};
imem[56] = {12'b1, 5'd0, 3'b000, 5'd30, 7'b0010011};
imem[57] = {1'b0, 10'b0000000000, 1'b0, 8'b00000000, 5'd0, 7'b1101111};
*/
end

/*
always@(posedge reset) begin
	if (reset) begin
		for (i =0 ; i < MEM_SIZE; i++) begin
			imem[i] <= 0;
		end// for 
	end //if end
end //always
*/


always@(*) begin
	if (wr)
		imem[addr >> 2] <= wdata;
	else
		rdata <= imem[addr >> 2];
end //always

endmodule
