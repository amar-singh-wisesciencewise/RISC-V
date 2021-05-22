
`timescale 1ns / 1ps


module test;

reg clk = 0;
reg reset = 0;

initial begin
#20 reset = 1;
#20 reset = 0;
#20 reset = 1;
#20 reset = 0;
#100 $finish;
end //intial end


always #5 clk = !clk;

risc_v_microcontroller uc1 (.clk(clk), .reset(reset));


endmodule
