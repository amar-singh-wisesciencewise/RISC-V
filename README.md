# RISC-V
RISC-V CPU design in verilog


Features:
6 Stage Pipeline: Fetch; Decode; Register File Read; Execute; Load and Store; Write back.

To compile with iverilog (icarus verilog):
	sh compile_script.sh
To simulate:
	vvp a.out
and to see the waveform:
	gtkwave test.vcd
