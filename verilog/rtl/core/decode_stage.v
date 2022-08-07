module instdec_stage (
	input wire clk,
	input wire nrst,
	input wire [31:0] pc2,
	input wire [31:0] instr2,
	input wire exception_pending,
	input wire instruction_addr_misaligned2,
	input wire illegal_flag,
	input wire TSR,
	input wire [1:0] current_mode,
	output wire [4:0] rs1,
	output wire [4:0] rs2,
	output wire [4:0] rd3,
	output wire [1:0] B_SEL3,
	output wire [31:0] I_imm3,
	output wire [31:0] B_imm3,
	output wire [31:0] J_imm3,
	output wire [31:0] U_imm3,
	output wire [31:0] S_imm3,
	output wire [4:0] shamt,
	output wire we3,
	output wire bneq3,
	output wire btype3,
	output wire jr3,
	output wire j3,
	output wire LUI3,
	output wire auipc3,
	output wire [2:0] fn3,
	output wire [3:0] alu_fn3,
	output wire [31:0] pc3,
	output wire [3:0] mem_op3,
	output wire [3:0] mulDiv_op3,
	output wire [1:0] pcselect3,
	input wire stall,
	input wire nostall,
	input wire discardwire,
	output wire [6:0] opcode3,
	input wire stall_mem,
	input wire arb_eqmem,
	input wire memOp_done,
	output wire [2:0] funct3_3,
	output wire [11:0] csr_addr3,
	output wire [31:0] csr_imm3,
	output wire instruction_addr_misaligned3,
	output wire ecall3,
	output wire ebreak3,
	output wire illegal_instr3,
	output wire mret3,
	output wire sret3,
	output wire uret3,
	output wire csr_we3,
	output wire aes_inst3
);
	
	wire [6:0] opcode;
	wire [2:0] funct3;
	wire [6:0] funct7;
	wire [11:0] funct12;
	wire instr_30;
	reg [31:0] instrReg3;
	reg [31:0] pcReg3;
	reg instruction_addr_misalignedReg3;
	always @(posedge clk or negedge nrst)
		if (!nrst) begin
			instrReg3 <= 0;
			pcReg3 <= 0;
			instruction_addr_misalignedReg3 <= 0;
		end
		else if ((stall && nostall) || discardwire) begin
			instrReg3 <= 32'h00000033;
			pcReg3 <= pcReg3;
			instruction_addr_misalignedReg3 <= instruction_addr_misalignedReg3;
		end
		else if (stall_mem || (arb_eqmem && ~memOp_done)) begin
			instrReg3 <= instrReg3;
			pcReg3 <= pcReg3;
			instruction_addr_misalignedReg3 <= instruction_addr_misalignedReg3;
		end
		else begin
			instrReg3 <= instr2;
			pcReg3 <= pc2;
			instruction_addr_misalignedReg3 <= instruction_addr_misaligned2;
		end
	assign rs1 = instrReg3[19:15];
	assign rs2 = instrReg3[24:20];
	assign rd3 = instrReg3[11:7];
	assign shamt = instrReg3[24:20];
	function automatic signed [31:0] sv2v_cast_32_signed;
		input reg signed [31:0] inp;
		sv2v_cast_32_signed = inp;
	endfunction
	assign I_imm3 = sv2v_cast_32_signed($signed(instrReg3[31:20]));
	assign B_imm3 = sv2v_cast_32_signed($signed({instrReg3[31], instrReg3[7], instrReg3[30:25], instrReg3[11:8], 1'b0}));
	assign J_imm3 = sv2v_cast_32_signed($signed({instrReg3[31], instrReg3[19:12], instrReg3[20], instrReg3[30:21], 1'b0}));
	assign U_imm3 = sv2v_cast_32_signed($signed({instrReg3[31:12], 12'b000000000000}));
	assign S_imm3 = sv2v_cast_32_signed($signed({instrReg3[31:25], instrReg3[11:7]}));
	assign pc3 = pcReg3;
	assign instruction_addr_misaligned3 = instruction_addr_misalignedReg3;
	assign opcode = instrReg3[6:0];
	assign funct7 = instrReg3[31:25];
	assign funct12 = instrReg3[31:20];
	assign funct3 = instrReg3[14:12];
	assign instr_30 = instrReg3[30];
	assign opcode3 = opcode;
	assign csr_addr3 = instrReg3[31:20];
	assign csr_imm3 = {27'b000000000000000000000000000, instrReg3[19:15]};
	assign funct3_3 = instrReg3[14:12];
	instr_decoder c1(
		.op(opcode),
		.funct3(funct3),
		.funct7(funct7),
		.funct12(funct12),
		.instr_30(instr_30),
		.exception_pending(exception_pending),
		.TSR(TSR),
		.illegal_flag(illegal_flag),
		.current_mode(current_mode),
		.pcselect(pcselect3),
		.we(we3),
		.B_SEL(B_SEL3),
		.alu_fn(alu_fn3),
		.fn(fn3),
		.bneq(bneq3),
		.btype(btype3),
		.mulDiv_op(mulDiv_op3),
		.j(j3),
		.jr(jr3),
		.mem_op(mem_op3),
		.LUI(LUI3),
		.auipc(auipc3),
		.ecall(ecall3),
		.ebreak(ebreak3),
		.uret(uret3),
		.sret(sret3),
		.mret(mret3),
		.illegal_instr(illegal_instr3),
		.aes_inst(aes_inst3),
		.csr_we(csr_we3)
	);
endmodule
