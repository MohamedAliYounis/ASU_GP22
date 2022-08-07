module alu (
	input wire bneq,
	input wire btype,
	input wire [3:0] alu_fn,
	input wire [31:0] operandA,
	input wire [31:0] operandB,
	output reg btaken,
	output reg [31:0] result
);

	always @(*) begin
		case (alu_fn)
			4'b0000: result = $signed(operandA) + $signed(operandB);
			4'b0001: result = $signed(operandA) << $signed(operandB[4:0]);
			4'b0010: result = $signed(operandA) < $signed(operandB);
			4'b0011: result = operandA < operandB;
			4'b0100: result = $signed(operandA) ^ $signed(operandB);
			4'b0101: result = $signed(operandA) >> $signed(operandB[4:0]);
			4'b0110: result = $signed(operandA) | $signed(operandB);
			4'b0111: result = $signed(operandA) & $signed(operandB);
			4'b1000: result = $signed(operandA) - $signed(operandB);
			4'b1001: result = $signed(operandA) > $signed(operandB);
			4'b1010: result = operandA > operandB;
			4'b1101: result = $signed(operandA) >>> $signed(operandB[4:0]);
			default: result = 0;
		endcase
		if (btype)
			case (alu_fn)
				4'b1000:
					if (bneq)
						btaken = (|result ? 1'b1 : 1'b0);
					else
						btaken = (~|result ? 1'b1 : 1'b0);
				4'b0010: btaken = (|result ? 1'b1 : 1'b0);
				4'b0011: btaken = (|result ? 1'b1 : 1'b0);
				4'b1001: btaken = (|result ? 1'b1 : (operandA == operandB ? 1'b1 : 1'b0));
				4'b1010: btaken = (|result ? 1'b1 : (operandA == operandB ? 1'b1 : 1'b0));
				default: btaken = 0;
			endcase
		else
			btaken = 0;
	end
endmodule
