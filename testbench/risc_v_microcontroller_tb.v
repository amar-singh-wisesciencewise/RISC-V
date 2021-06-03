
`timescale 1ns / 1ps


module test;

reg clk = 0;
reg reset = 0;

initial begin
#0  reset = 1;
#10 reset = 0;
#500 $finish;
end //intial end


always #5 clk = !clk;

risc_v_microcontroller uc1 (.clk(clk), .reset(reset));


endmodule
