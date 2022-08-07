module branch_unit (
	input wire [31:0] pc,
	input wire [31:0] operandA,
	input wire [31:0] B_imm,
	input wire [31:0] J_imm,
	input wire [31:0] I_imm,
	input wire btaken,
	input wire jr,
	input wire j,
	output reg [31:0] target
);

	wire [31:0] b_target;
	wire [31:0] j_target;
	assign b_target = (btaken ? pc + B_imm : pc + 4);
	assign j_target = (jr ? operandA + I_imm : pc + J_imm);
	always @(*)
		if (j)
			target = j_target;
		else if (jr)
			target = {j_target[31:1], 1'b0};
		else
			target = b_target;
endmodule
