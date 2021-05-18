`timescale 1ns / 1ps

// Register  for pipe line i.e. it lets read and write in the same cycle.
// stage before register can write to it and stage ahead the register can read it on same cycle
// updates the data when wr is 1.
module register(clk, reset, wr, wdata, rdata);

input clk, reset, wr;

parameter WIDTH = 32;

input [WIDTH-1 : 0] wdata;
output reg [WIDTH-1 : 0] rdata;

reg [WIDTH-1 : 0] register;

//writting and reset
always@(posedge clk) begin
	if(reset)
		register <= 0;
	else begin
	if (wr)
		register <= wdata;
	end //if end
end //always

// supplying read values
always@(posedge clk) begin
	rdata <= register; 
end //always

endmodule

