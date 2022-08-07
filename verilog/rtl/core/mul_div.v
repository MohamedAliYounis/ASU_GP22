module mul_div (
	input wire clk,
	input wire nrst,
	input wire [31:0] a,
	input wire [31:0] b,
	input wire [3:0] mulDiv_op,
	output reg [31:0] res
);
	
	wire [31:0] div;
	wire [31:0] rem;
	reg sign_a;
	reg sign_b;
	localparam OVERFLOW_END = 32'h80000000;
	localparam OVERFLOW_SOR = -1;
	reg [1:0] multdiv_signed_mode_i;
	wire [31:0] res_internal;
	wire [1:0] multdiv_operator_i;
	assign multdiv_operator_i = mulDiv_op[3:2];
	always @(*) begin
		sign_a = 0;
		sign_b = 0;
		case (mulDiv_op[1:0])
			1: begin
				sign_a = 1;
				sign_b = 1;
				multdiv_signed_mode_i = 2'b11;
			end
			2: begin
				sign_a = 1;
				sign_b = 0;
				multdiv_signed_mode_i = 2'b10;
			end
			3, 0: begin
				sign_a = 0;
				sign_b = 0;
				multdiv_signed_mode_i = 2'b00;
			end
		endcase
	end
	always @(*)
		if (|mulDiv_op) begin
			if (mulDiv_op[3] == 0)
				res = res_internal;
		end
		else
			res = 0;
	asu_riscv_multiplier mullll(
		.clk(clk),
		.nrst(nrst),
		.operator_i(multdiv_operator_i),
		.signed_mode_i(multdiv_signed_mode_i),
		.op_a_i(a),
		.op_b_i(b),
		.multdiv_result_o(res_internal)
	);
endmodule
