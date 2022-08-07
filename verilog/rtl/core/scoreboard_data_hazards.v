module scoreboard_data_hazards (
	input wire clk,
	input wire nrst,
	input wire btaken,
	input wire discard,
	input wire exception,
	input wire [4:0] rs1,
	input wire [4:0] rs2,
	input wire [4:0] rd,
	input wire jr4,
	input wire [6:0] op_code,
	input wire aes_done,
	output wire stall,
	output wire kill,
	output reg nostall
);

	reg [4:0] scoreboard [0:31];
	reg [2:0] function_unit;
	reg killReg;
	reg [1:0] killnum;
	reg stall_wire;
	always @(posedge clk or negedge nrst)
		if (!nrst) begin : sv2v_autoblock_1
			reg signed [31:0] i;
			for (i = 0; i < 32; i = i + 1)
				scoreboard[i] <= 7'b0000000;
		end
		else begin
			begin : sv2v_autoblock_2
				reg signed [31:0] j;
				for (j = 0; j < 32; j = j + 1)
					begin
						if (scoreboard[j][0] && !scoreboard[j][1]) begin
							scoreboard[j][4] <= 0;
							scoreboard[j][3] <= 0;
						end
						scoreboard[j][2:0] <= {1'b0, scoreboard[j][2:1]};
					end
			end
			case (function_unit)
				3'b001:
					if ((|rd && !stall) && !kill) begin
						scoreboard[rd][4] <= 1;
						scoreboard[rd][3] <= 1;
						scoreboard[rd][2] <= 1;
					end
				3'b010:
					if ((|rd && (scoreboard[rs1][4] || scoreboard[rs2][4])) && !kill)
						;
					else if ((|rd && !stall) && !kill) begin
						scoreboard[rd][4] <= 1;
						scoreboard[rd][3] <= 1;
						scoreboard[rd][2] <= 1;
					end
				3'b011:
					if ((scoreboard[rs1][4] || scoreboard[rs2][4]) && !kill)
						;
				3'b100:
					if ((|rd && scoreboard[rs1][4]) && !kill)
						;
					else if ((|rd && !stall) && !kill) begin
						scoreboard[rd][4] <= 1;
						scoreboard[rd][3] <= 1;
						scoreboard[rd][2] <= 1;
					end
				default:
					;
			endcase
		end
	always @(*)
		case (op_code)
			7'b0110111: begin
				function_unit = 3'b001;
				nostall = 0;
				stall_wire = 0;
			end
			7'b0010111: begin
				function_unit = 3'b001;
				nostall = 0;
				stall_wire = 0;
			end
			7'b1101111: begin
				function_unit = 3'b001;
				nostall = 0;
				stall_wire = 0;
			end
			7'b0110011: begin
				function_unit = 3'b010;
				stall_wire = scoreboard[rs1][3] || scoreboard[rs2][3];
				nostall = scoreboard[rs1][3] || scoreboard[rs2][3];
			end
			7'b1100011: begin
				function_unit = 3'b011;
				stall_wire = scoreboard[rs1][3] || scoreboard[rs2][3];
				nostall = scoreboard[rs1][3] || scoreboard[rs2][3];
			end
			7'b0100011: begin
				function_unit = 3'b011;
				stall_wire = scoreboard[rs1][3] || scoreboard[rs2][3];
				nostall = scoreboard[rs1][3] || scoreboard[rs2][3];
			end
			7'b1100111: begin
				function_unit = 3'b011;
				stall_wire = scoreboard[rs1][3] || scoreboard[rs2][3];
				nostall = scoreboard[rs1][3] || scoreboard[rs2][3];
			end
			7'b0010011: begin
				function_unit = 3'b100;
				stall_wire = scoreboard[rs1][3];
				nostall = scoreboard[rs1][3];
			end
			7'b0000011: begin
				function_unit = 3'b100;
				stall_wire = scoreboard[rs1][3];
				nostall = scoreboard[rs1][3];
			end
			7'b1110011: begin
				function_unit = 3'b100;
				stall_wire = scoreboard[rs1][3];
				nostall = scoreboard[rs1][3];
			end
			7'b0001011: begin
				function_unit = 3'b000;
				stall_wire = (aes_done ? 1'b0 : 1'b1);
				nostall = (aes_done ? 1'b0 : 1'b1);
			end
			default: begin
				function_unit = 0;
				nostall = 0;
				stall_wire = 0;
			end
		endcase
	assign stall = (kill ? 1'b0 : stall_wire);
	assign kill = ((((btaken || killReg) || exception) && ~stall) && ~discard ? 1'b1 : 1'b0);
	always @(posedge clk)
		if (!nrst) begin
			killnum <= 2'b00;
			killReg <= 0;
		end
		else if (btaken || exception) begin
			killReg <= 1;
			killnum <= killnum + 1;
		end
		else if ((kill && !killnum[1]) && killnum[0]) begin
			killReg <= 1;
			killnum <= killnum + 1;
		end
		else
			killReg <= 0;
endmodule
