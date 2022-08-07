module asu_riscv_multiplier (
	input wire clk,
	input wire nrst,
	input wire [1:0] operator_i,
	input wire [1:0] signed_mode_i,
	input wire [31:0] op_a_i,
	input wire [31:0] op_b_i,
	output wire [31:0] multdiv_result_o
);

	wire signed [34:0] mac_res_signed;
	wire [34:0] mac_res_ext;
	wire [33:0] accum;
	wire sign_a;
	wire sign_b;
	reg mult_valid;
	wire signed_mult;
	reg [33:0] mac_res_d;
	wire [33:0] mac_res;
	wire multdiv_en;
	reg mult_hold;
	wire mult_en_internal;
	assign mult_en_internal = ~mult_hold;
	assign multdiv_en = mult_en_internal;
	wire unused_mac_res_ext;
	assign unused_mac_res_ext = mac_res_ext[34];
	assign signed_mult = signed_mode_i != 2'b00;
	assign multdiv_result_o = mac_res_d[31:0];
	reg mult_state_q;
	reg mult_state_d;
	wire signed [33:0] mult1_res;
	wire signed [33:0] mult2_res;
	wire signed [33:0] mult3_res;
	wire [33:0] mult1_res_uns;
	wire [33:32] unused_mult1_res_uns;
	wire [15:0] mult1_op_a;
	wire [15:0] mult1_op_b;
	wire [15:0] mult2_op_a;
	wire [15:0] mult2_op_b;
	reg [15:0] mult3_op_a;
	reg [15:0] mult3_op_b;
	wire mult1_sign_a;
	wire mult1_sign_b;
	wire mult2_sign_a;
	wire mult2_sign_b;
	reg mult3_sign_a;
	reg mult3_sign_b;
	reg [33:0] summand1;
	reg [33:0] summand2;
	reg [33:0] summand3;
	assign mult1_res = $signed({mult1_sign_a, mult1_op_a}) * $signed({mult1_sign_b, mult1_op_b});
	assign mult2_res = $signed({mult2_sign_a, mult2_op_a}) * $signed({mult2_sign_b, mult2_op_b});
	assign mult3_res = $signed({mult3_sign_a, mult3_op_a}) * $signed({mult3_sign_b, mult3_op_b});
	assign mac_res_signed = ($signed(summand1) + $signed(summand2)) + $signed(summand3);
	assign mult1_res_uns = $unsigned(mult1_res);
	assign mac_res_ext = $unsigned(mac_res_signed);
	assign mac_res = mac_res_ext[33:0];
	assign sign_a = signed_mode_i[0] & op_a_i[31];
	assign sign_b = signed_mode_i[1] & op_b_i[31];
	assign mult1_sign_a = 1'b0;
	assign mult1_sign_b = 1'b0;
	assign mult1_op_a = op_a_i[15:0];
	assign mult1_op_b = op_b_i[15:0];
	assign mult2_sign_a = 1'b0;
	assign mult2_sign_b = sign_b;
	assign mult2_op_a = op_a_i[15:0];
	assign mult2_op_b = op_b_i[31:16];
	assign accum[17:0] = 18'b000000000000000000;
	assign accum[33:18] = {16 {signed_mult & 1'b0}};
	always @(*) begin
		mult3_sign_a = sign_a;
		mult3_sign_b = 1'b0;
		mult3_op_a = op_a_i[31:16];
		mult3_op_b = op_b_i[15:0];
		summand1 = {18'h00000, mult1_res_uns[31:16]};
		summand2 = $unsigned(mult2_res);
		summand3 = $unsigned(mult3_res);
		mac_res_d = {2'b00, mac_res[15:0], mult1_res_uns[15:0]};
		mult_valid = 1'b1;
		mult_state_d = 1'd0;
		mult_hold = 1'b0;
		case (mult_state_q)
			1'd0:
				if (operator_i != 2'b00) begin
					mac_res_d = mac_res;
					mult_valid = 1'b0;
					mult_state_d = 1'd1;
				end
				else
					mult_hold = 1'b0;
			1'd1: begin
				mult3_sign_a = sign_a;
				mult3_sign_b = sign_b;
				mult3_op_a = op_a_i[31:16];
				mult3_op_b = op_b_i[31:16];
				mac_res_d = mac_res;
				summand1 = 1'sb0;
				summand2 = accum;
				summand3 = $unsigned(mult3_res);
				mult_state_d = 1'd0;
				mult_valid = 1'b1;
				mult_hold = 1'b0;
			end
			default: mult_state_d = 1'd0;
		endcase
	end
	always @(posedge clk or negedge nrst)
		if (!nrst)
			mult_state_q <= 1'd0;
		else if (mult_en_internal)
			mult_state_q <= mult_state_d;
	assign unused_mult1_res_uns = mult1_res_uns[33:32];
endmodule
