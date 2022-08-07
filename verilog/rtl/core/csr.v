module csr_unit (
input wire [2:0] func3,
	input wire [4:0] rs1,
	input wire [31:0] rs1_val,
	input wire [31:0] imm,
	input wire [11:0] csr_addr,
	input wire [31:0] csr_reg,
	input wire system,
	input wire [1:0] current_mode,
	output reg [31:0] csr_new,
	output wire [31:0] csr_old,
	output reg illegal_csr
);
	
	always @(*)
		if (system) begin
			if (csr_addr[9:8] > current_mode) begin
				illegal_csr = 1;
				csr_new = csr_reg;
			end
			else if ((csr_addr[11:10] == 2'b11) && ((func3 == 3'b001) || (func3 == 3'b101))) begin
				illegal_csr = 1;
				csr_new = csr_reg;
			end
			else if (((rs1 != 0) && (csr_addr[11:10] == 2'b11)) && ((((func3 == 3'b011) || (func3 == 3'b111)) || (func3 == 3'b010)) || (func3 == 3'b110))) begin
				illegal_csr = 1;
				csr_new = csr_reg;
			end
			else begin
				illegal_csr = 0;
				case (func3)
					3'b001: csr_new = rs1_val;
					3'b010: csr_new = csr_reg | rs1_val;
					3'b011: csr_new = csr_reg & ~rs1_val;
					3'b101: csr_new = imm;
					3'b110: csr_new = csr_reg | imm;
					3'b111: csr_new = csr_reg & ~imm;
					default: csr_new = csr_reg;
				endcase
			end
		end
		else begin
			csr_new = csr_reg;
			illegal_csr = 0;
		end
	assign csr_old = csr_reg;
endmodule
