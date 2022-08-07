module exe_stage (
	input wire clk,
	input wire nrst,
	input wire [31:0] op_a,
	input wire [31:0] op_b,
	input wire [4:0] rd4,
	input wire [4:0] rs1_4,
	input wire [2:0] fn4,
	input wire [3:0] alu_fn4,
	input wire we4,
	input wire [31:0] B_imm4,
	input wire [31:0] J_imm4,
	input wire [31:0] U_imm4,
	input wire [31:0] S_imm4,
	input wire bneq4,
	input wire btype4,
	input wire j4,
	input wire jr4,
	input wire LUI4,
	input wire auipc4,
	input wire [3:0] mem_op4,
	input wire [3:0] mulDiv_op4,
	input wire [31:0] pc4,
	input wire [1:0] pcselect4,
	input wire stall_mem,
	input wire dmem_finished,
	input wire [2:0] funct3_4,
	input wire [31:0] csr_data,
	input wire [31:0] csr_imm4,
	input wire [11:0] csr_addr4,
	input wire csr_we4,
	input wire instruction_addr_misaligned4,
	input wire ecall4,
	input wire ebreak4,
	input wire illegal_instr4,
	input wire mret4,
	input wire sret4,
	input wire uret4,
	input wire aes_inst4,
	input wire m_timer,
	input wire s_timer,
	input wire u_timer,
	input wire [1:0] current_mode,
	input wire m_tie,
	input wire s_tie,
	input wire m_eie,
	input wire s_eie,
	input wire u_eie,
	input wire u_tie,
	input wire u_sie,
	input wire external_interrupt,
	output reg [31:0] wb_data6,
	output wire we6,
	output wire [4:0] rd6,
	output wire [31:0] U_imm6,
	output wire [31:0] AU_imm6,
	output reg [31:0] mul_divReg6,
	output wire [31:0] target,
	output wire [31:0] pc6,
	output wire [1:0] pcselect5,
	output wire [4:0] mem_l15_rqtype,
	output wire [2:0] mem_l15_size,
	output wire [31:0] mem_l15_address,
	output wire [63:0] mem_l15_data,
	output wire mem_l15_val,
	input wire [63:0] l15_mem_data_0,
	input wire [63:0] l15_mem_data_1,
	input wire [3:0] l15_mem_returntype,
	input wire l15_mem_val,
	input wire l15_mem_ack,
	input wire l15_mem_header_ack,
	output wire mem_l15_req_ack,
	output wire memOp_done,
	output wire ld_addr_misaligned6,
	output wire samo_addr_misaligned6,
	output wire bjtaken6,
	output wire exception,
	output wire [31:0] csr_wb,
	output wire [11:0] csr_wb_addr,
	output wire csr_we6,
	output wire [31:0] cause6,
	output wire exception_pending,
	output wire mret6,
	output wire sret6,
	output wire uret6,
	output wire m_interrupt,
	output wire s_interrupt,
	output wire u_interrupt,
	output wire start_aes,
	

);
	
	wire btaken;
	wire bjtaken4;
	wire j5;
	wire jr5;
	wire [31:0] mul_div5;
	wire m_op6;
	reg [31:0] opaReg5;
	reg [31:0] opbReg5;
	reg [2:0] fnReg5;
	reg [3:0] alufnReg5;
	wire [31:0] alu_res5;
	reg weReg5;
	reg [4:0] rdReg5;
	reg [4:0] rs1Reg5;
	reg bneqReg5;
	reg btypeReg5;
	reg bjtakenReg5;
	reg [31:0] B_immReg5;
	reg [31:0] J_immReg5;
	reg [31:0] U_immReg5;
	reg jReg5;
	reg jrReg5;
	reg LUIReg5;
	reg auipcReg5;
	reg [3:0] mulDiv_opReg5;
	reg [31:0] pcReg5;
	reg [1:0] pcselectReg5;
	reg [2:0] funct3Reg5;
	reg [31:0] csr_dataReg5;
	reg [31:0] csr_immReg5;
	wire [31:0] csr5;
	reg [11:0] csr_addrReg5;
	reg csr_weReg5;
	wire [31:0] csr_rd5;
	reg ecallReg5;
	reg ebreakReg5;
	reg instruction_addr_misalignedReg5;
	reg illegal_instrReg5;
	reg mretReg5;
	reg sretReg5;
	reg uretReg5;
	wire illegal_csr;
	reg aes_instReg5;
	always @(posedge clk or negedge nrst)
		if (!nrst) begin
			opaReg5 <= 0;
			opbReg5 <= 0;
			alufnReg5 <= 0;
			fnReg5 <= 0;
			rdReg5 <= 0;
			rs1Reg5 <= 0;
			weReg5 <= 0;
			B_immReg5 <= 0;
			J_immReg5 <= 0;
			U_immReg5 <= 0;
			bneqReg5 <= 0;
			btypeReg5 <= 0;
			jReg5 <= 0;
			jrReg5 <= 0;
			LUIReg5 <= 0;
			auipcReg5 <= 0;
			mulDiv_opReg5 <= 0;
			pcReg5 <= 0;
			pcselectReg5 <= 2'b00;
			bjtakenReg5 <= 0;
			funct3Reg5 <= 1'sb0;
			csr_immReg5 <= 1'sb0;
			csr_dataReg5 <= 1'sb0;
			csr_addrReg5 <= 1'sb0;
			csr_weReg5 <= 0;
			ecallReg5 <= 0;
			ebreakReg5 <= 0;
			instruction_addr_misalignedReg5 <= 0;
			illegal_instrReg5 <= 0;
			mretReg5 <= 0;
			sretReg5 <= 0;
			uretReg5 <= 0;
			aes_instReg5 <= 0;
		end
		else if (exception) begin
			opaReg5 <= 0;
			opbReg5 <= 0;
			alufnReg5 <= 0;
			fnReg5 <= 0;
			rdReg5 <= 0;
			rs1Reg5 <= 0;
			weReg5 <= 0;
			B_immReg5 <= 0;
			J_immReg5 <= 0;
			U_immReg5 <= 0;
			bneqReg5 <= 0;
			btypeReg5 <= 0;
			jReg5 <= 0;
			jrReg5 <= 0;
			LUIReg5 <= 0;
			auipcReg5 <= 0;
			mulDiv_opReg5 <= 0;
			pcReg5 <= 0;
			pcselectReg5 <= 2'b00;
			bjtakenReg5 <= 0;
			funct3Reg5 <= 1'sb0;
			csr_immReg5 <= 1'sb0;
			csr_dataReg5 <= 1'sb0;
			csr_addrReg5 <= 1'sb0;
			csr_weReg5 <= 0;
			ecallReg5 <= 0;
			ebreakReg5 <= 0;
			instruction_addr_misalignedReg5 <= 0;
			illegal_instrReg5 <= 0;
			mretReg5 <= 0;
			sretReg5 <= 0;
			uretReg5 <= 0;
			aes_instReg5 <= 0;
		end
		else begin
			opaReg5 <= op_a;
			opbReg5 <= op_b;
			alufnReg5 <= alu_fn4;
			fnReg5 <= fn4;
			rdReg5 <= rd4;
			rs1Reg5 <= rs1_4;
			weReg5 <= we4;
			B_immReg5 <= B_imm4;
			J_immReg5 <= J_imm4;
			U_immReg5 <= U_imm4;
			bneqReg5 <= bneq4;
			btypeReg5 <= btype4;
			jReg5 <= j4;
			jrReg5 <= jr4;
			LUIReg5 <= LUI4;
			auipcReg5 <= auipc4;
			mulDiv_opReg5 <= mulDiv_op4;
			pcReg5 <= pc4;
			pcselectReg5 <= pcselect4;
			bjtakenReg5 <= bjtaken4;
			funct3Reg5 <= funct3_4;
			csr_immReg5 <= csr_imm4;
			csr_dataReg5 <= csr_data;
			csr_addrReg5 <= csr_addr4;
			csr_weReg5 <= csr_we4;
			ecallReg5 <= ecall4;
			ebreakReg5 <= ebreak4;
			instruction_addr_misalignedReg5 <= instruction_addr_misaligned4;
			illegal_instrReg5 <= illegal_instr4;
			mretReg5 <= mret4;
			sretReg5 <= sret4;
			uretReg5 <= uret4;
			aes_instReg5 <= aes_inst4;
		end
	csr_unit csr_1(
		.func3(funct3Reg5),
		.rs1(rs1Reg5),
		.rs1_val(opaReg5),
		.imm(csr_immReg5),
		.csr_addr(csr_addrReg5),
		.csr_reg(csr_dataReg5),
		.system(csr_weReg5),
		.current_mode(current_mode),
		.csr_new(csr5),
		.csr_old(csr_rd5),
		.illegal_csr(illegal_csr)
	);
	reg [2:0] fnReg6;
	reg [31:0] alu_resReg6;
	reg [4:0] rdReg6;
	reg weReg6;
	reg [31:0] U_immReg6;
	reg [31:0] AU_immReg6;
	reg [31:0] pcReg6;
	wire [31:0] mem_out6;
	wire [2:0] fn6;
	reg [31:0] csr_rdReg6;
	reg [31:0] csrReg6;
	reg [11:0] csr_addrReg6;
	reg csr_weReg6;
	reg instruction_addr_misalignedReg6;
	reg ecallReg6;
	reg ebreakReg6;
	reg illegal_instrReg6;
	reg illegal_csrReg6;
	reg mretReg6;
	reg sretReg6;
	reg uretReg6;
	reg aes_instReg6;
	always @(posedge clk or negedge nrst)
		if (!nrst) begin
			fnReg6 <= 3'b000;
			rdReg6 <= 5'b00000;
			alu_resReg6 <= 32'b00000000000000000000000000000000;
			weReg6 <= 0;
			U_immReg6 <= 32'b00000000000000000000000000000000;
			AU_immReg6 <= 32'b00000000000000000000000000000000;
			mul_divReg6 <= 32'b00000000000000000000000000000000;
			pcReg6 <= 32'b00000000000000000000000000000000;
			csr_rdReg6 <= 32'b00000000000000000000000000000000;
			csrReg6 <= 32'b00000000000000000000000000000000;
			csr_addrReg6 <= 12'b000000000000;
			csr_weReg6 <= 0;
			instruction_addr_misalignedReg6 <= 0;
			ecallReg6 <= 0;
			ebreakReg6 <= 0;
			illegal_instrReg6 <= 0;
			illegal_csrReg6 <= 0;
			mretReg6 <= 0;
			sretReg6 <= 0;
			uretReg6 <= 0;
			aes_instReg6 <= 0;
		end
		else if (exception) begin
			pcReg6 <= pcReg6;
			fnReg6 <= 3'b000;
			rdReg6 <= 5'b00000;
			alu_resReg6 <= 32'b00000000000000000000000000000000;
			weReg6 <= 1'b0;
			U_immReg6 <= 32'b00000000000000000000000000000000;
			AU_immReg6 <= 32'b00000000000000000000000000000000;
			mul_divReg6 <= 32'b00000000000000000000000000000000;
			csr_weReg6 <= 0;
			csr_rdReg6 <= 32'b00000000000000000000000000000000;
			csrReg6 <= 32'b00000000000000000000000000000000;
			csr_addrReg6 <= 12'b000000000000;
			instruction_addr_misalignedReg6 <= 0;
			ecallReg6 <= 0;
			ebreakReg6 <= 0;
			illegal_instrReg6 <= 0;
			illegal_csrReg6 <= 0;
			mretReg6 <= 0;
			sretReg6 <= 0;
			uretReg6 <= 0;
			aes_instReg6 <= 0;
		end
		else begin
			fnReg6 <= fnReg5;
			rdReg6 <= rdReg5;
			alu_resReg6 <= alu_res5;
			weReg6 <= weReg5;
			U_immReg6 <= U_immReg5;
			AU_immReg6 <= U_immReg5 + pcReg5;
			mul_divReg6 <= mul_div5;
			pcReg6 <= pcReg5;
			csr_weReg6 <= csr_weReg5;
			csr_rdReg6 <= csr_rd5;
			csrReg6 <= csr5;
			csr_addrReg6 <= csr_addrReg5;
			instruction_addr_misalignedReg6 <= instruction_addr_misalignedReg5;
			ecallReg6 <= ecallReg5;
			ebreakReg6 <= ebreakReg5;
			illegal_instrReg6 <= illegal_instrReg5;
			illegal_csrReg6 <= illegal_csr;
			mretReg6 <= mretReg5;
			sretReg6 <= sretReg5;
			uretReg6 <= uretReg5;
			aes_instReg6 <= aes_instReg5;
		end
	alu exe_alu(
		.alu_fn(alufnReg5),
		.operandA(opaReg5),
		.operandB(opbReg5),
		.result(alu_res5),
		.bneq(bneqReg5),
		.btype(btypeReg5),
		.btaken(btaken)
	);
	branch_unit exe_bu(
		.pc(pcReg5),
		.operandA(opaReg5),
		.B_imm(B_immReg5),
		.J_imm(J_immReg5),
		.I_imm(opbReg5),
		.btaken(btaken),
		.jr(jrReg5 && ~jr4),
		.j(jReg5),
		.target(target)
	);
	mem_wrap exe_mem_wrap(
		.clk(clk),
		.nrst(nrst),
		.mem_op4(mem_op4),
		.op_a4(op_a),
		.op_b4(op_b),
		.S_imm4(S_imm4),
		.stall_mem(stall_mem),
		.dmem_finished(dmem_finished),
		.mem_l15_rqtype(mem_l15_rqtype),
		.mem_l15_size(mem_l15_size),
		.mem_l15_address(mem_l15_address),
		.mem_l15_data(mem_l15_data),
		.mem_l15_val(mem_l15_val),
		.l15_mem_data_0(l15_mem_data_0),
		.l15_mem_data_1(l15_mem_data_1),
		.l15_mem_returntype(l15_mem_returntype),
		.l15_mem_val(l15_mem_val),
		.l15_mem_ack(l15_mem_ack),
		.l15_mem_header_ack(l15_mem_header_ack),
		.mem_l15_req_ack(mem_l15_req_ack),
		.mem_out6(mem_out6),
		.memOp_done(memOp_done),
		.m_op6(m_op6),
		.ld_addr_misaligned6(ld_addr_misaligned6),
		.samo_addr_misaligned6(samo_addr_misaligned6)
	);
	mul_div mul1(
		.a(opaReg5),
		.b(opbReg5),
		.mulDiv_op(mulDiv_opReg5),
		.res(mul_div5)
	);
	assign start_aes = aes_instReg6;
	reg [31:0] cause;
	wire m_timer_conditioned;
	wire s_timer_conditioned;
	wire u_timer_conditioned;
	wire m_interrupt_conditioned;
	wire s_interrupt_conditioned;
	wire u_interrupt_conditioned;
	assign m_timer_conditioned = m_tie && m_timer;
	assign s_timer_conditioned = ((current_mode != 2'b11) && s_tie) && s_timer;
	assign m_interrupt_conditioned = m_eie && external_interrupt;
	assign s_interrupt_conditioned = ((current_mode != 2'b11) && s_eie) && external_interrupt;
	assign u_timer_conditioned = ((current_mode == 2'b00) && u_tie) && u_timer;
	assign u_interrupt_conditioned = ((current_mode == 2'b00) && u_eie) && external_interrupt;
	assign exception = ((((((((((((((instruction_addr_misalignedReg6 || ecallReg6) || ebreakReg6) || ld_addr_misaligned6) || samo_addr_misaligned6) || m_timer_conditioned) || s_interrupt_conditioned) || illegal_instrReg6) || illegal_csrReg6) || s_timer_conditioned) || m_interrupt_conditioned) || u_interrupt_conditioned) || u_timer_conditioned) || mretReg6) || sretReg6) || uretReg6;
	always @(*) begin
		cause[31] = 0;
		cause[30:0] = 0;
		if (m_interrupt_conditioned) begin
			cause[31] = 1;
			cause[30:0] = 32'h0000000b;
		end
		else if (s_interrupt_conditioned) begin
			cause[31] = 1;
			cause[30:0] = 32'h00000009;
		end
		else if (m_timer_conditioned) begin
			cause[31] = 1;
			cause[30:0] = 32'h00000007;
		end
		else if (s_timer_conditioned) begin
			cause[31] = 1;
			cause[30:0] = 32'h00000005;
		end
		else if (u_interrupt_conditioned) begin
			cause[31] = 1;
			cause[30:0] = 32'h00000008;
		end
		else if (u_timer_conditioned) begin
			cause[31] = 1;
			cause[30:0] = 32'h00000004;
		end
		else if (instruction_addr_misalignedReg6)
			cause[30:0] = 32'h00000000;
		else if (illegal_instrReg6 || illegal_csrReg6)
			cause[30:0] = 32'h00000002;
		else if (ecallReg6) begin
			if (current_mode == 2'b00)
				cause[30:0] = 32'h00000008;
			else if (current_mode == 2'b01)
				cause[30:0] = 32'h00000009;
			else
				cause[30:0] = 32'h0000000b;
		end
		else if (ebreakReg6)
			cause[30:0] = 32'h00000003;
		else if (ld_addr_misaligned6)
			cause[30:0] = 32'h00000004;
		else if (samo_addr_misaligned6)
			cause[30:0] = 32'h00000006;
		else begin
			cause[31] = 0;
			cause[30:0] = 0;
		end
	end
	assign fn6 = fnReg6;
	assign rd6 = rdReg6;
	assign we6 = ((m_op6 ~^ memOp_done) & weReg6) | ((!m_op6 ~^ memOp_done) & weReg6);
	assign U_imm6 = U_immReg6;
	assign AU_imm6 = AU_immReg6;
	assign csr_wb = csrReg6;
	assign csr_wb_addr = csr_addrReg6;
	assign csr_we6 = csr_weReg6;
	assign m_interrupt = m_interrupt_conditioned;
	assign s_interrupt = s_interrupt_conditioned;
	assign u_interrupt = u_interrupt_conditioned;
	assign cause6 = cause;
	assign exception_pending = exception;
	assign mret6 = mretReg6;
	assign sret6 = sretReg6;
	assign uret6 = uretReg6;
	assign pc6 = pcReg6;
	assign bjtaken6 = (btaken || j4) || jr4;
	assign pcselect5 = ((btaken || jrReg5) || jReg5 ? pcselectReg5 : 2'b00);
	always @(*)
		case (fn6)
			0: wb_data6 = alu_resReg6;
			1: wb_data6 = pcReg6 + 4;
			2: wb_data6 = mul_divReg6;
			3: wb_data6 = U_imm6;
			4: wb_data6 = mem_out6;
			5: wb_data6 = AU_imm6;
			6: wb_data6 = csr_rdReg6;
			default: wb_data6 = 0;
		endcase
endmodule
