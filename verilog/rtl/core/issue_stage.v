module issue_stage (
	input wire clk,
	input wire nrst,
	input wire we6,
	input wire [4:0] rdaddr6,
	input wire [31:0] wb6,
	input wire [31:0] csr_wb,
	input wire csr_we6,
	input wire [11:0] csr_wb_addr,
	input wire [31:0] cause,
	input wire exception_pending,
	input wire [31:0] pc_exc,
	input wire m_ret,
	input wire s_ret,
	input wire u_ret,
	input wire m_interrupt,
	input wire s_interrupt,
	input wire u_interrupt,
	input wire we3,
	input wire bneq3,
	input wire btype3,
	input wire [6:0] opcode3,
	input wire [2:0] fn3,
	input wire [3:0] alu_fn3,
	input wire [4:0] rs1,
	input wire [4:0] rs2,
	input wire [4:0] rd3,
	input wire [1:0] B_SEL3,
	input wire [31:0] I_imm3,
	input wire [31:0] B_imm3,
	input wire [31:0] J_imm3,
	input wire [31:0] S_imm3,
	input wire [31:0] U_imm3,
	input wire [4:0] shamt,
	input wire [2:0] funct3_3,
	input wire [11:0] csr_addr3,
	input wire [31:0] csr_imm3,
	input wire csr_we3,
	input wire aes_inst3,
	input wire instruction_addr_misaligned3,
	input wire ecall3,
	input wire ebreak3,
	input wire illegal_instr3,
	input wire mret3,
	input wire sret3,
	input wire uret3,
	input wire j3,
	input wire jr3,
	input wire LUI3,
	input wire auipc3,
	input wire [3:0] mem_op3,
	input wire [3:0] mulDiv_op3,
	input wire [31:0] pc3,
	input wire [1:0] pcselect3,
	output wire [31:0] op_a,
	output reg [31:0] op_b,
	output wire [4:0] rd4,
	output wire [4:0] rs1_4,
	output wire [3:0] alu_fn4,
	output wire [2:0] fn4,
	output wire [31:0] B_imm4,
	output wire [31:0] J_imm4,
	output wire [31:0] S_imm4,
	output wire [31:0] U_imm4,
	output wire we4,
	output wire bneq4,
	output wire btype4,
	output wire j4,
	output wire jr4,
	output wire LUI4,
	output wire auipc4,
	output wire [3:0] mem_op4,
	output wire [3:0] mulDiv_op4,
	output wire [31:0] pc4,
	output wire [1:0] pcselect4,
	input wire bjtaken,
	input wire discard,
	output wire stall,
	output wire nostall,
	output reg [1:0] killnum,
	input wire stall_mem,
	input wire arb_eqmem,
	input wire exception,
	input wire memOp_done,
	output wire [31:0] csr_data,
	output wire [2:0] funct3_4,
	output wire [11:0] csr_addr4,
	output wire [31:0] csr_imm4,
	output wire csr_we4,
	output wire aes_inst4,
	output wire TSR,
	output wire instruction_addr_misaligned4,
	output wire ecall4,
	output wire ebreak4,
	output wire illegal_instr4,
	output wire [31:0] epc,
	output wire mret4,
	output wire sret4,
	output wire uret4,
	output wire m_timer,
	output wire s_timer,
	output wire u_timer,
	output wire [1:0] current_mode,
	output wire m_tie,
	output wire s_tie,
	output wire m_eie,
	output wire s_eie,
	output wire u_eie,
	output wire u_tie,
	output wire u_sie,
	input wire [31:0] AES_Res0_i,
	input wire [31:0] AES_Res1_i,
	input wire [31:0] AES_Res2_i,
	input wire [31:0] AES_Res3_i,
	input wire aes_done,
	output wire [31:0] AES_D0_O,
	output wire [31:0] AES_D1_O,
	output wire [31:0] AES_D2_O,
	output wire [31:0] AES_D3_O,
	output wire [31:0] AES_key_addr_O
);
	
	wire [31:0] operand_a;
	wire [31:0] operand_b;
	wire kill;
	reg [1:0] BSELReg4;
	reg [4:0] shamtReg4;
	reg [31:0] I_immdReg4;
	reg [31:0] B_immdReg4;
	reg [31:0] J_immReg4;
	reg [31:0] S_immReg4;
	reg [31:0] U_immReg4;
	reg [4:0] rdReg4;
	reg [4:0] rs1Reg4;
	reg [3:0] alufnReg4;
	reg [2:0] fnReg4;
	reg weReg4;
	reg bneqReg4;
	reg btypeReg4;
	reg jReg4;
	reg jrReg4;
	reg LUIReg4;
	reg auipcReg4;
	reg [3:0] mem_opReg4;
	reg [3:0] mulDiv_opReg4;
	reg [31:0] pcReg4;
	reg [1:0] pcselectReg4;
	reg [2:0] funct3Reg4;
	reg [31:0] csr_immReg4;
	reg [11:0] csr_addrReg4;
	reg csr_weReg4;
	reg aes_instReg4;
	reg instruction_addr_misalignedReg4;
	reg ecallReg4;
	reg ebreakReg4;
	reg illegal_instrReg4;
	reg mretReg4;
	reg sretReg4;
	reg uretReg4;
	always @(posedge clk or negedge nrst)
		if (!nrst) begin
			BSELReg4 <= 0;
			rdReg4 <= 0;
			rs1Reg4 <= 0;
			shamtReg4 <= 0;
			I_immdReg4 <= 0;
			B_immdReg4 <= 0;
			J_immReg4 <= 0;
			S_immReg4 <= 0;
			U_immReg4 <= 0;
			alufnReg4 <= 0;
			fnReg4 <= 0;
			weReg4 <= 0;
			bneqReg4 <= 0;
			btypeReg4 <= 0;
			jReg4 <= 0;
			jrReg4 <= 0;
			LUIReg4 <= 0;
			auipcReg4 <= 0;
			mem_opReg4 <= 0;
			mulDiv_opReg4 <= 0;
			pcReg4 <= 0;
			pcselectReg4 <= 0;
			killnum <= 2'b00;
			funct3Reg4 <= 1'sb0;
			csr_addrReg4 <= 1'sb0;
			csr_immReg4 <= 1'sb0;
			csr_weReg4 <= 0;
			instruction_addr_misalignedReg4 <= 0;
			ecallReg4 <= 0;
			ebreakReg4 <= 0;
			illegal_instrReg4 <= 0;
			mretReg4 <= 0;
			sretReg4 <= 0;
			uretReg4 <= 0;
			aes_instReg4 <= 0;
		end
		else begin
			rs1Reg4 <= rs1;
			shamtReg4 <= shamt;
			B_immdReg4 <= B_imm3;
			J_immReg4 <= J_imm3;
			U_immReg4 <= U_imm3;
			S_immReg4 <= S_imm3;
			I_immdReg4 <= I_imm3;
			bneqReg4 <= bneq3;
			btypeReg4 <= btype3;
			jReg4 <= j3;
			jrReg4 <= jr3;
			LUIReg4 <= LUI3;
			auipcReg4 <= auipc3;
			mem_opReg4 <= mem_op3;
			mulDiv_opReg4 <= mulDiv_op3;
			pcReg4 <= pc3;
			funct3Reg4 <= funct3_3;
			csr_immReg4 <= csr_imm3;
			csr_addrReg4 <= csr_addr3;
			instruction_addr_misalignedReg4 <= instruction_addr_misaligned3;
			ecallReg4 <= ecall3;
			ebreakReg4 <= ebreak3;
			illegal_instrReg4 <= illegal_instr3;
			mretReg4 <= mret3;
			sretReg4 <= sret3;
			uretReg4 <= uret3;
			aes_instReg4 <= aes_inst3;
			pcReg4 <= pc3;
			if (discard || (stall && nostall)) begin
				pcselectReg4 <= 2'b00;
				weReg4 <= 1'b0;
				BSELReg4 <= 2'b01;
				alufnReg4 <= 3'b000;
				fnReg4 <= 3'b000;
				I_immdReg4 <= 32'b00000000000000000000000000000000;
				rdReg4 <= 5'b00000;
				rs1Reg4 <= 0;
				shamtReg4 <= 0;
				B_immdReg4 <= 0;
				J_immReg4 <= 0;
				U_immReg4 <= 0;
				S_immReg4 <= 0;
				I_immdReg4 <= 0;
				bneqReg4 <= 0;
				btypeReg4 <= 0;
				jReg4 <= 0;
				jrReg4 <= 0;
				LUIReg4 <= 0;
				auipcReg4 <= 0;
				mem_opReg4 <= 0;
				mulDiv_opReg4 <= 0;
				csr_weReg4 <= 0;
				instruction_addr_misalignedReg4 <= 0;
				ecallReg4 <= 0;
				ebreakReg4 <= 0;
				illegal_instrReg4 <= 0;
				mretReg4 <= 0;
				sretReg4 <= 0;
				uretReg4 <= 0;
				aes_instReg4 <= 0;
			end
			else if (kill) begin
				shamtReg4 <= 0;
				I_immdReg4 <= 0;
				B_immdReg4 <= 0;
				J_immReg4 <= 0;
				S_immReg4 <= 0;
				U_immReg4 <= 0;
				bneqReg4 <= 0;
				btypeReg4 <= 0;
				jReg4 <= 0;
				jrReg4 <= 0;
				LUIReg4 <= 0;
				auipcReg4 <= 0;
				killnum <= killnum + 1;
				pcselectReg4 <= 2'b00;
				weReg4 <= 1'b0;
				BSELReg4 <= 2'b01;
				alufnReg4 <= 3'b000;
				fnReg4 <= 3'b000;
				rdReg4 <= 5'b00000;
				rs1Reg4 <= 0;
				pcReg4 <= 0;
				csr_weReg4 <= 0;
				instruction_addr_misalignedReg4 <= 0;
				ecallReg4 <= 0;
				ebreakReg4 <= 0;
				illegal_instrReg4 <= 0;
				mretReg4 <= 0;
				sretReg4 <= 0;
				uretReg4 <= 0;
				aes_instReg4 <= 0;
			end
			else if (killnum[1] && !killnum[0]) begin
				killnum <= killnum + 1;
				shamtReg4 <= 0;
				I_immdReg4 <= 0;
				B_immdReg4 <= 0;
				J_immReg4 <= 0;
				S_immReg4 <= 0;
				U_immReg4 <= 0;
				bneqReg4 <= 0;
				btypeReg4 <= 0;
				jReg4 <= 0;
				jrReg4 <= 0;
				LUIReg4 <= 0;
				auipcReg4 <= 0;
				pcselectReg4 <= 2'b00;
				weReg4 <= 1'b0;
				BSELReg4 <= 2'b01;
				alufnReg4 <= 3'b000;
				fnReg4 <= 3'b000;
				rdReg4 <= 5'b00000;
				rs1Reg4 <= 0;
				pcReg4 <= 0;
				csr_weReg4 <= 0;
				instruction_addr_misalignedReg4 <= 0;
				ecallReg4 <= 0;
				ebreakReg4 <= 0;
				illegal_instrReg4 <= 0;
				mretReg4 <= 0;
				sretReg4 <= 0;
				uretReg4 <= 0;
				aes_instReg4 <= 0;
			end
			else if (stall_mem || (arb_eqmem && ~memOp_done)) begin
				killnum <= 2'b00;
				BSELReg4 <= BSELReg4;
				rdReg4 <= rdReg4;
				rs1Reg4 <= rs1Reg4;
				shamtReg4 <= shamtReg4;
				I_immdReg4 <= I_immdReg4;
				B_immdReg4 <= B_immdReg4;
				J_immReg4 <= J_immReg4;
				S_immReg4 <= S_immReg4;
				U_immReg4 <= U_immReg4;
				alufnReg4 <= alufnReg4;
				fnReg4 <= fnReg4;
				weReg4 <= weReg4;
				bneqReg4 <= bneqReg4;
				btypeReg4 <= btypeReg4;
				jReg4 <= jReg4;
				jrReg4 <= jrReg4;
				LUIReg4 <= LUIReg4;
				auipcReg4 <= auipcReg4;
				mem_opReg4 <= mem_opReg4;
				mulDiv_opReg4 <= mulDiv_opReg4;
				pcReg4 <= pcReg4;
				pcselectReg4 <= pcselectReg4;
				csr_immReg4 <= csr_immReg4;
				csr_addrReg4 <= csr_addrReg4;
				csr_weReg4 <= csr_weReg4;
				instruction_addr_misalignedReg4 <= instruction_addr_misalignedReg4;
				ecallReg4 <= ecallReg4;
				ebreakReg4 <= ebreakReg4;
				illegal_instrReg4 <= illegal_instrReg4;
				mretReg4 <= mretReg4;
				sretReg4 <= sretReg4;
				uretReg4 <= uretReg4;
				aes_instReg4 <= aes_instReg4;
			end
			else begin
				killnum <= 2'b00;
				pcselectReg4 <= pcselect3;
				weReg4 <= we3;
				BSELReg4 <= B_SEL3;
				alufnReg4 <= alu_fn3;
				fnReg4 <= fn3;
				rdReg4 <= rd3;
				rs1Reg4 <= rs1;
				csr_weReg4 <= csr_we3;
				instruction_addr_misalignedReg4 <= instruction_addr_misaligned3;
				ecallReg4 <= ecall3;
				ebreakReg4 <= ebreak3;
				illegal_instrReg4 <= illegal_instr3;
				mretReg4 <= mret3;
				sretReg4 <= sret3;
				uretReg4 <= uret3;
				aes_instReg4 <= aes_inst3;
			end
		end
	regfile reg1(
		.clk(clk),
		.clrn(nrst),
		.we(we6),
		.write_addr(rdaddr6),
		.source_a(rs1),
		.source_b(rs2),
		.result(wb6),
		.op_a(operand_a),
		.op_b(operand_b)
	);
	scoreboard_data_hazards scoreboard(
		.clk(clk),
		.nrst(nrst),
		.exception(exception),
		.btaken(bjtaken),
		.jr4(jr4),
		.rs1(rs1),
		.rs2(rs2),
		.rd(rd3),
		.op_code(opcode3),
		.stall(stall),
		.kill(kill),
		.nostall(nostall),
		.discard(discard),
		.aes_done(aes_done)
	);
	csr_regfile csr_registers(
		.clk(clk),
		.nrst(nrst),
		.csr_we(csr_we6),
		.csr_address_r(csr_addrReg4),
		.csr_address_wb(csr_wb_addr),
		.csr_wb(csr_wb),
		.exception_pending(exception_pending),
		.cause(cause),
		.pc_exc(pc_exc),
		.m_ret(m_ret),
		.s_ret(s_ret),
		.u_ret(u_ret),
		.csr_data(csr_data),
		.current_mode(current_mode),
		.epc(epc),
		.s_timer(s_timer),
		.m_timer(m_timer),
		.s_eie(s_eie),
		.m_eie(m_eie),
		.m_tie(m_tie),
		.s_tie(s_tie),
		.m_interrupt(m_interrupt),
		.s_interrupt(s_interrupt),
		.u_interrupt(u_interrupt),
		.u_timer(u_timer),
		.u_eie(u_eie),
		.u_tie(u_tie),
		.u_sie(u_sie),
		.TSR(TSR),
		.AES_D0_O(AES_D0_O),
		.AES_D1_O(AES_D1_O),
		.AES_D2_O(AES_D2_O),
		.AES_D3_O(AES_D3_O),
		.AES_key_addr_O(AES_key_addr_O),
		.AES_Res0_i(AES_Res0_i),
		.AES_Res1_i(AES_Res1_i),
		.AES_Res2_i(AES_Res2_i),
		.AES_Res3_i(AES_Res3_i),
		.aes_done(aes_done)
	);
	always @(*)
		case (BSELReg4)
			2'b00: op_b = operand_b;
			2'b01: op_b = I_immdReg4;
			2'b10: op_b = shamtReg4;
			default: op_b = operand_b;
		endcase
	assign op_a = (((((!(|rd4) && !(|I_immdReg4)) && !(|alufnReg4)) && !(|fnReg4)) && ~jr3) && !(|mem_op4) ? 32'b00000000000000000000000000000000 : operand_a);
	assign rd4 = rdReg4;
	assign rs1_4 = rs1Reg4;
	assign B_imm4 = B_immdReg4;
	assign J_imm4 = J_immReg4;
	assign U_imm4 = U_immReg4;
	assign S_imm4 = S_immReg4;
	assign fn4 = fnReg4;
	assign alu_fn4 = alufnReg4;
	assign we4 = weReg4;
	assign bneq4 = bneqReg4;
	assign btype4 = btypeReg4;
	assign j4 = jReg4;
	assign jr4 = jrReg4;
	assign LUI4 = LUIReg4;
	assign auipc4 = auipcReg4;
	assign mem_op4 = mem_opReg4;
	assign mulDiv_op4 = mulDiv_opReg4;
	assign pc4 = pcReg4;
	assign pcselect4 = pcselectReg4;
	assign funct3_4 = funct3Reg4;
	assign csr_imm4 = csr_immReg4;
	assign csr_addr4 = csr_addrReg4;
	assign csr_we4 = csr_weReg4;
	assign instruction_addr_misaligned4 = instruction_addr_misalignedReg4;
	assign ecall4 = ecallReg4;
	assign ebreak4 = ebreakReg4;
	assign illegal_instr4 = illegal_instrReg4;
	assign mret4 = mretReg4;
	assign sret4 = sretReg4;
	assign uret4 = uretReg4;
	assign aes_inst4 = aes_instReg4;
endmodule
