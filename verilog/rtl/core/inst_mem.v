module instr_mem (
	input clk,
	input wire [31:0] addr,
	output reg [31:0] instr
);
	
	wire [31:0] rom [99:0];
	always @(posedge clk) instr <= rom[addr];
endmodule
