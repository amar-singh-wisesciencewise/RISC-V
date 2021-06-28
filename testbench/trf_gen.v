
`timescale 1ns / 1ps
//*****************TrfGen Module**************************//
//Purpose of the module is to provide stimulus for the dut//
//This module can also be considered as instructionmem bfm//
//********************************************************//
module trfGen(reset, addr, rdata, wr, wdata );
	parameter DATA_BUS_WIDTH = 32;
	parameter MEM_SIZE     = 1024;
	parameter OPC_WIDTH    = 7;
	parameter RD_RS_WIDTH  = 5;
	parameter FUNCT3_WIDTH = 3;
	parameter FUNCT7_WIDTH = 7;
	parameter IMM_WIDTH    = 12;
	parameter IMM_U_WIDTH  = 20;
	//
	input reset;
	inout wr;
	input [DATA_BUS_WIDTH-1 : 0] addr;
	input [DATA_BUS_WIDTH-1 : 0] wdata;
	//
	output reg [DATA_BUS_WIDTH-1 : 0] rdata;
	//
	reg [DATA_BUS_WIDTH-1: 0]imem[MEM_SIZE-1 : 0];
	//
	reg [OPC_WIDTH-1:0]rOpc;
	reg [RD_RS_WIDTH-1:0]rRd;
	reg [RD_RS_WIDTH-1:0]rRs1;
	reg [RD_RS_WIDTH-1:0]rRs2;
	reg [FUNCT3_WIDTH-1:0]rFunct3;
	reg [FUNCT7_WIDTH-1:0]rFunct7;
	reg [IMM_WIDTH-1:0]rImm1;
	reg [IMM_U_WIDTH-1:0]rImm2;
	reg rType;
	reg iType;
	reg sType;
	reg uType;
	integer unsigned rndData=0;
	integer unsigned seed=0;	
	integer unsigned j;	
	//class rnd;
	//	randc [WIDTH-1:0] idx; 
	//	rand  [OPC_WIDTH-1:0]rOpc;
	//	rand  [RD_RS_WIDTH-1:0]rRd;
	//	rand  [RD_RS_WIDTH-1:0]rRs1;
	//	rand  [RD_RS_WIDTH-1:0]rRs2;
	//	rand  [FUNCT3_WIDTH-1:0]rFunct3;
	//	rand  [FUNCT7_WIDTH-1:0]rFunct7;
	//	rand  [IMM_WIDTH-1:0]rImm1;
	//	rand  [IMM_U_WIDTH-1:0]rImm2;
	//	rand  rType;
	//	rand  iType;
	//	rand  sType;
	//	rand  uType;
	//	//ToDo: have to add constraints on opc
	//endclass
	
	initial begin
		//rnd rObj=new();
		for(j=0;j<MEM_SIZE;j++) begin
			rOpc = $urandom(seed);rRd=$urandom(seed);rRs1=$urandom(seed);
			rRs2 = $urandom(seed);rFunct3=$urandom(seed);rFunct7=$urandom(seed);
			rImm1 = $urandom(seed);rImm2=$urandom(seed);rType=$urandom(seed);
			iType = $urandom(seed);uType=$urandom(seed);sType=$urandom(seed);
			//rObj.randomize();
			//This order should also be controlled during directed traffic
			if(rType)
				rndData = {rFunct7,rRs2,rRs1,rFunct3,rRd,rOpc};
			else if(iType)
				rndData = {rImm1,rRs1,rFunct3,rRd,rOpc};
			else if(sType)
				rndData = {rImm1[11:5],rRs2,rRs1,rFunct3,rImm1[4:0],rOpc};
			else
				rndData = {rImm2,rRd,rOpc};
			imem[j] = rndData;
			$display("idx =%d, dataStored=0x%h",j,rndData);
			$display("rType =%d, sType=%d, iType=%d, uType=%d",rType,sType,iType,uType);
			$display("Opc =0x%h, Rd =0x%h, Rs1 =0x%h, Rs2 =0x%h, Funct3 =0x%h, Funct7 =0x%h, Imm1 =0x%h, Imm2 =0x%h",rOpc,rRd,rRs1,rRs2,rFunct3,rFunct7,rImm1,rImm2);
		end
	end
	
	always@(*) begin
		if(reset)
			rdata <= 0;
		else
			if(!wr)	
				rdata <= imem[addr];
	end //always

endmodule
