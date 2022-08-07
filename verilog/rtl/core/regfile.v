module regfile (
	input wire clk,
	input wire we,
	input wire clrn,
	input wire [4:0] write_addr,
	input wire [4:0] source_a,
	input wire [4:0] source_b,
	input wire [31:0] result,
	output reg [31:0] op_a,
	output reg [31:0] op_b
);

	reg [31:0] register [31:0];
	always @(posedge clk or negedge clrn)
		if (!clrn) begin
			register[0] <= 32'h00000000;
			begin : sv2v_autoblock_1
				reg signed [31:0] i;
				for (i = 1; i < 32; i = i + 1)
					register[i] <= 32'h00000000;
			end
		end
		else begin
			op_a = register[source_a];
			op_b = register[source_b];
			if ((write_addr != 0) && we)
				register[write_addr] <= result;
		end
endmodule
