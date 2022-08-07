module core (
	input wire clk,
	input wire nrst,
	output reg [4:0] transducer_l15_rqtype,
	output reg [2:0] transducer_l15_size,
	output reg [39:0] transducer_l15_address,
	output reg [63:0] transducer_l15_data,
	output reg transducer_l15_val,
	input wire l15_transducer_ack,
	input wire l15_transducer_header_ack,
	input wire l15_transducer_val,
	input wire [63:0] l15_transducer_data_0,
	input wire [63:0] l15_transducer_data_1,
	input wire [3:0] l15_transducer_returntype,
	output reg transducer_l15_req_ack,
	input wire external_interrupt,
	
    //dummy pins	
	output wire [31:0] AES_Res0,
	output wire [31:0] AES_D0_O,
	
);
	
	
	wire [31:0] pc;
	wire [31:0] pc2;
	wire [31:0] pc3;
	wire [31:0] pc4;
	wire [31:0] pc6;
	wire [31:0] instr2;
	wire [4:0] rs1;
	wire [4:0] rs2;
	wire [4:0] rs1_4;
	wire [1:0] B_SEL3;
	wire [31:0] opa;
	wire [31:0] opb;
	wire [4:0] rd3;
	wire [4:0] rd4;
	wire [4:0] rd6;
	wire we3;
	wire we4;
	wire we6;
	wire [31:0] wb6;
	wire [2:0] fn3;
	wire [2:0] fn4;
	wire [3:0] alu_fn3;
	wire [3:0] alu_fn4;
	wire [31:0] I_imm3;
	wire [31:0] B_imm3;
	wire [31:0] J_imm3;
	wire [31:0] S_imm3;
	wire [31:0] U_imm3;
	wire [31:0] B_imm4;
	wire [31:0] J_imm4;
	wire [31:0] S_imm4;
	wire [31:0] U_imm4;
	wire [4:0] shamt;
	wire [31:0] U_imm6;
	wire [31:0] AU_imm6;
	wire [1:0] pcselect3;
	wire [1:0] pcselect4;
	wire [1:0] pcselect5;
	wire [31:0] target;
	wire btype3;
	wire btype4;
	wire bneq3;
	wire bneq4;
	wire LUI3;
	wire LUI4;
	wire auipc3;
	wire auipc4;
	wire [3:0] mem_op3;
	wire [3:0] mem_op4;
	wire ld_addr_misaligned6;
	wire samo_addr_misaligned6;
	wire [3:0] mulDiv_op4;
	wire [3:0] mulDiv_op3;
	wire [31:0] mul_div6;
	wire [31:0] wb_data6;
	wire we6Issue;
	wire [4:0] rd6Issue;
	wire stall;
	wire discard;
	wire nostall;
	wire [1:0] killnum;
	wire bjtaken;
	wire exception;
	wire [6:0] opcode3;
	wire [11:0] csr_addr3;
	wire [11:0] csr_addr4;
	wire [11:0] csr_wb_addr;
	wire [11:0] csr_wb_addr6;
	wire [2:0] funct3_3;
	wire [2:0] funct3_4;
	wire [31:0] csr_imm3;
	wire [31:0] csr_imm4;
	wire [31:0] csr_data;
	wire [31:0] csr_wb6;
	wire [31:0] m_cause6;
	wire [31:0] csr_wb;
	wire [31:0] pc_exc;
	wire [31:0] cause6;
	wire instruction_addr_misaligned2;
	wire instruction_addr_misaligned3;
	wire instruction_addr_misaligned4;
	wire ecall3;
	wire ecall4;
	wire ebreak3;
	wire ebreak4;
	wire mret3;
	wire mret4;
	wire mret6;
	wire sret3;
	wire sret4;
	wire sret6;
	wire uret3;
	wire uret4;
	wire uret6;
	wire illegal_instr3;
	wire illegal_instr4;
	wire exception_pending;
	wire exception_pending6;
	wire [31:0] epc;
	wire [31:0] cause;
	wire m_ret;
	wire s_ret;
	wire u_ret;
	wire [1:0] current_mode;
	wire s_timer;
	wire m_timer;
	wire m_eie;
	wire m_tie;
	wire s_eie;
	wire s_tie;
	wire m_interrupt;
	wire s_interrupt;
	wire u_interrupt;
	wire csr_we3;
	wire csr_we4;
	wire csr_we5;
	wire csr_we6;
	wire csr_we6Issue;
	wire external_interrupt_w;
	wire TSR;
	wire illegal_flag;
	wire [31:0] AES_D0;
	wire [31:0] AES_D1;
	wire [31:0] AES_D2;
	wire [31:0] AES_D3;
	wire [31:0] AES_key_addr;
	wire [31:0] AES_Res0;
	wire [31:0] AES_Res1;
	wire [31:0] AES_Res2;
	wire [31:0] AES_Res3;
	wire aes_inst3;
	wire aes_inst4;
	wire start_aes;
	wire aes_done;
	wire jr3;
	wire j3;
	wire j4;
	wire jr4;
	wire u_timer;
	wire u_eie;
	wire u_tie;
	wire u_sie;
	wire [4:0] instr_l15_rqtype;
	wire [2:0] instr_l15_size;
	wire [31:0] instr_l15_address;
	wire [63:0] instr_l15_data;
	wire instr_l15_val;
	reg l15_instr_ack;
	reg l15_instr_header_ack;
	reg l15_instr_val;
	reg [63:0] l15_instr_data_0;
	reg [63:0] l15_instr_data_1;
	reg [3:0] l15_instr_returntype;
	wire instr_l15_req_ack;
	wire [4:0] mem_l15_rqtype;
	wire [2:0] mem_l15_size;
	wire [31:0] mem_l15_address;
	wire [63:0] mem_l15_data;
	wire mem_l15_val;
	reg l15_mem_ack;
	reg l15_mem_header_ack;
	reg l15_mem_val;
	reg [63:0] l15_mem_data_0;
	reg [63:0] l15_mem_data_1;
	reg [3:0] l15_mem_returntype;
	wire mem_l15_req_ack;
	wire [1:0] state_reg;
	reg [1:0] arb_state;
	localparam [1:0] arb_instr = 0;
	localparam [1:0] arb_wait = 1;
	localparam [1:0] arb_mem = 2;
	wire dmem_waiting;
	wire dmem_finished;
	wire instr_left_cache;
	wire noMore_memOps;
	reg stall_mem;
	reg arb_eqmem;
	wire memOp_done;
	assign dmem_waiting = |mem_op3;
	assign dmem_finished = (arb_state == arb_mem) && (l15_transducer_val || l15_transducer_ack);
	assign noMore_memOps = !(|mem_op3);
	assign instr_left_cache = (arb_state == arb_wait) && l15_transducer_val;
	always @(posedge clk or negedge nrst) begin
		if (!nrst) begin
			arb_state <= arb_instr;
			stall_mem <= 0;
			arb_eqmem <= 0;
		end
		else
			case (arb_state)
				arb_instr:
					if (dmem_waiting && ~(stall && nostall)) begin
						arb_state <= arb_wait;
						stall_mem <= 1;
					end
				arb_wait:
					if (state_reg == 2'b10)
						if (instr_left_cache)
							arb_state <= arb_mem;
				arb_mem: begin
					arb_eqmem <= 1;
					stall_mem <= 0;
					if (memOp_done && noMore_memOps) begin
						arb_state <= arb_instr;
						arb_eqmem <= 0;
					end
				end
			endcase
			end
	always @(*) begin
		if (arb_state == arb_instr) begin
			transducer_l15_rqtype = instr_l15_rqtype;
			transducer_l15_size = instr_l15_size;
			transducer_l15_address = instr_l15_address;
			transducer_l15_data = instr_l15_data;
			transducer_l15_val = instr_l15_val;
			l15_instr_ack = l15_transducer_ack;
			l15_instr_header_ack = l15_transducer_header_ack;
			l15_mem_header_ack = 0;
			l15_instr_val = l15_transducer_val;
			l15_instr_data_0 = l15_transducer_data_0;
			l15_instr_data_1 = l15_transducer_data_1;
			l15_instr_returntype = l15_transducer_returntype;
			transducer_l15_req_ack = instr_l15_req_ack;
			l15_mem_val = 0;
		end
		else if (arb_state == arb_wait) begin
			l15_instr_header_ack = 0;
			l15_mem_header_ack = 0;
			transducer_l15_val = 0;
			l15_instr_val = l15_transducer_val;
			l15_instr_data_0 = l15_transducer_data_0;
			l15_instr_data_1 = l15_transducer_data_1;
			l15_instr_returntype = l15_transducer_returntype;
			transducer_l15_req_ack = instr_l15_req_ack;
			l15_instr_ack = l15_instr_ack;
		end
		else begin
			transducer_l15_rqtype = mem_l15_rqtype;
			transducer_l15_size = mem_l15_size;
			transducer_l15_address = mem_l15_address;
			transducer_l15_data = mem_l15_data;
			transducer_l15_val = mem_l15_val;
			l15_mem_ack = l15_transducer_ack;
			l15_mem_header_ack = l15_transducer_header_ack;
			l15_instr_header_ack = 0;
			l15_mem_val = l15_transducer_val;
			l15_mem_data_0 = l15_transducer_data_0;
			l15_mem_data_1 = l15_transducer_data_1;
			l15_mem_returntype = l15_transducer_returntype;
			transducer_l15_req_ack = mem_l15_req_ack;
			l15_instr_val = 0;
		end
		end
	frontend_stage frontend(
		.clk(clk),
		.nrst(nrst),
		.PCSEL(pcselect5),
		.target(target),
		.exception_pending(exception_pending),
		.epc(epc),
		.pc2(pc2),
		.instr2(instr2),
		.illegal_flag(illegal_flag),
		.stall(stall),
		.killnum(killnum),
		.discardwire(discard),
		.nostall(nostall),
		.l15_transducer_ack(l15_instr_ack),
		.l15_transducer_header_ack(l15_instr_header_ack),
		.transducer_l15_rqtype(instr_l15_rqtype),
		.transducer_l15_size(instr_l15_size),
		.transducer_l15_val(instr_l15_val),
		.transducer_l15_address(instr_l15_address),
		.transducer_l15_data(instr_l15_data),
		.l15_transducer_val(l15_instr_val),
		.l15_transducer_returntype(l15_instr_returntype),
		.l15_transducer_data_0(l15_instr_data_0),
		.l15_transducer_data_1(l15_instr_data_1),
		.transducer_l15_req_ack(instr_l15_req_ack),
		.state_reg(state_reg),
		.stall_mem(stall_mem),
		.arb_eqmem(arb_eqmem),
		.memOp_done(memOp_done),
		.instruction_addr_misaligned2(instruction_addr_misaligned2)
	);
	instdec_stage instdec(
		.clk(clk),
		.nrst(nrst),
		.instr2(instr2),
		.pc2(pc2),
		.exception_pending(exception_pending),
		.instruction_addr_misaligned2(instruction_addr_misaligned2),
		.illegal_flag(illegal_flag),
		.TSR(TSR),
		.current_mode(current_mode),
		.rs1(rs1),
		.rs2(rs2),
		.rd3(rd3),
		.B_SEL3(B_SEL3),
		.fn3(fn3),
		.alu_fn3(alu_fn3),
		.we3(we3),
		.bneq3(bneq3),
		.btype3(btype3),
		.jr3(jr3),
		.j3(j3),
		.LUI3(LUI3),
		.auipc3(auipc3),
		.shamt(shamt),
		.I_imm3(I_imm3),
		.B_imm3(B_imm3),
		.J_imm3(J_imm3),
		.U_imm3(U_imm3),
		.S_imm3(S_imm3),
		.mem_op3(mem_op3),
		.mulDiv_op3(mulDiv_op3),
		.pc3(pc3),
		.pcselect3(pcselect3),
		.stall(stall),
		.opcode3(opcode3),
		.stall_mem(stall_mem),
		.arb_eqmem(arb_eqmem),
		.memOp_done(memOp_done),
		.discardwire(discard),
		.nostall(nostall),
		.funct3_3(funct3_3),
		.csr_addr3(csr_addr3),
		.csr_imm3(csr_imm3),
		.instruction_addr_misaligned3(instruction_addr_misaligned3),
		.ecall3(ecall3),
		.ebreak3(ebreak3),
		.illegal_instr3(illegal_instr3),
		.mret3(mret3),
		.sret3(sret3),
		.uret3(uret3),
		.csr_we3(csr_we3),
		.aes_inst3(aes_inst3)
	);
	issue_stage issue(
		.clk(clk),
		.nrst(nrst),
		.we6(we6Issue),
		.rdaddr6(rd6Issue),
		.wb6(wb6),
		.csr_wb(csr_wb),
		.csr_we6(csr_we6Issue),
		.csr_wb_addr(csr_wb_addr),
		.cause(cause),
		.exception_pending(exception_pending),
		.pc_exc(pc_exc),
		.m_ret(m_ret),
		.s_ret(s_ret),
		.u_ret(u_ret),
		.m_interrupt(m_interrupt),
		.s_interrupt(s_interrupt),
		.u_interrupt(u_interrupt),
		.rs1(rs1),
		.rs2(rs2),
		.rd3(rd3),
		.B_SEL3(B_SEL3),
		.fn3(fn3),
		.alu_fn3(alu_fn3),
		.we3(we3),
		.shamt(shamt),
		.I_imm3(I_imm3),
		.B_imm3(B_imm3),
		.J_imm3(J_imm3),
		.U_imm3(U_imm3),
		.S_imm3(S_imm3),
		.bneq3(bneq3),
		.btype3(btype3),
		.j3(j3),
		.jr3(jr3),
		.LUI3(LUI3),
		.auipc3(auipc3),
		.mem_op3(mem_op3),
		.mulDiv_op3(mulDiv_op3),
		.pc3(pc3),
		.pcselect3(pcselect3),
		.funct3_3(funct3_3),
		.csr_addr3(csr_addr3),
		.csr_imm3(csr_imm3),
		.csr_we3(csr_we3),
		.instruction_addr_misaligned3(instruction_addr_misaligned3),
		.ecall3(ecall3),
		.ebreak3(ebreak3),
		.illegal_instr3(illegal_instr3),
		.mret3(mret3),
		.sret3(sret3),
		.uret3(uret3),
		.aes_inst3(aes_inst3),
		.op_a(opa),
		.op_b(opb),
		.rd4(rd4),
		.rs1_4(rs1_4),
		.we4(we4),
		.fn4(fn4),
		.alu_fn4(alu_fn4),
		.bneq4(bneq4),
		.btype4(btype4),
		.B_imm4(B_imm4),
		.J_imm4(J_imm4),
		.S_imm4(S_imm4),
		.U_imm4(U_imm4),
		.j4(j4),
		.jr4(jr4),
		.LUI4(LUI4),
		.auipc4(auipc4),
		.mem_op4(mem_op4),
		.mulDiv_op4(mulDiv_op4),
		.pc4(pc4),
		.pcselect4(pcselect4),
		.stall(stall),
		.killnum(killnum),
		.bjtaken(bjtaken),
		.exception(exception),
		.opcode3(opcode3),
		.stall_mem(stall_mem),
		.arb_eqmem(arb_eqmem),
		.memOp_done(memOp_done),
		.discard(discard),
		.nostall(nostall),
		.csr_data(csr_data),
		.funct3_4(funct3_4),
		.csr_addr4(csr_addr4),
		.csr_imm4(csr_imm4),
		.csr_we4(csr_we4),
		.instruction_addr_misaligned4(instruction_addr_misaligned4),
		.ecall4(ecall4),
		.ebreak4(ebreak4),
		.illegal_instr4(illegal_instr4),
		.epc(epc),
		.mret4(mret4),
		.sret4(sret4),
		.uret4(uret4),
		.current_mode(current_mode),
		.s_timer(s_timer),
		.m_timer(m_timer),
		.s_eie(s_eie),
		.m_eie(m_eie),
		.m_tie(m_tie),
		.s_tie(s_tie),
		.u_timer(u_timer),
		.u_eie(u_eie),
		.u_tie(u_tie),
		.u_sie(u_sie),
		.TSR(TSR),
		.AES_D0_O(AES_D0),
		.AES_D1_O(AES_D1),
		.AES_D2_O(AES_D2),
		.AES_D3_O(AES_D3),
		.AES_key_addr_O(AES_key_addr),
		.AES_Res0_i(AES_Res0),
		.AES_Res1_i(AES_Res1),
		.AES_Res2_i(AES_Res2),
		.AES_Res3_i(AES_Res3),
		.aes_done(aes_done),
		.aes_inst4(aes_inst4)
	);
	exe_stage execute(
		.clk(clk),
		.nrst(nrst),
		.op_a(opa),
		.op_b(opb),
		.fn4(fn4),
		.alu_fn4(alu_fn4),
		.rd4(rd4),
		.rs1_4(rs1_4),
		.we4(we4),
		.bneq4(bneq4),
		.btype4(btype4),
		.B_imm4(B_imm4),
		.J_imm4(J_imm4),
		.S_imm4(S_imm4),
		.U_imm4(U_imm4),
		.j4(j4),
		.jr4(jr4),
		.LUI4(LUI4),
		.auipc4(auipc4),
		.mem_op4(mem_op4),
		.mulDiv_op4(mulDiv_op4),
		.pc4(pc4),
		.pcselect4(pcselect4),
		.stall_mem(stall_mem),
		.dmem_finished(dmem_finished),
		.funct3_4(funct3_4),
		.csr_data(csr_data),
		.csr_imm4(csr_imm4),
		.csr_addr4(csr_addr4),
		.csr_we4(csr_we4),
		.instruction_addr_misaligned4(instruction_addr_misaligned4),
		.ecall4(ecall4),
		.ebreak4(ebreak4),
		.illegal_instr4(illegal_instr4),
		.mret4(mret4),
		.sret4(sret4),
		.uret4(uret4),
		.external_interrupt(external_interrupt),
		.aes_inst4(aes_inst4),
		.rd6(rd6),
		.we6(we6),
		.U_imm6(U_imm6),
		.AU_imm6(AU_imm6),
		.mul_divReg6(mul_div6),
		.wb_data6(wb_data6),
		.pc6(pc6),
		.pcselect5(pcselect5),
		.target(target),
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
		.memOp_done(memOp_done),
		.ld_addr_misaligned6(ld_addr_misaligned6),
		.samo_addr_misaligned6(samo_addr_misaligned6),
		.bjtaken6(bjtaken),
		.exception(exception),
		.exception_pending(exception_pending6),
		.cause6(cause6),
		.csr_wb(csr_wb6),
		.csr_wb_addr(csr_wb_addr6),
		.csr_we6(csr_we6),
		.mret6(mret6),
		.sret6(sret6),
		.uret6(uret6),
		.current_mode(current_mode),
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
		.start_aes(start_aes)
	); 
	commit_stage commit(
		.clk(clk),
		.nrst(nrst),
		.rd6(rd6),
		.we6(we6),
		.wb_data6(wb6),
		.csr_wb6(csr_wb6),
		.csr_wb_addr6(csr_wb_addr6),
		.csr_we6(csr_we6),
		.cause6(cause6),
		.exception_pending6(exception_pending6),
		.mret6(mret6),
		.sret6(sret6),
		.uret6(uret6),
		.pc6(pc6),
		.we6Issue(we6Issue),
		.rd6Issue(rd6Issue),
		.result6(wb_data6),
		.csr_wb(csr_wb),
		.csr_wb_addr(csr_wb_addr),
		.csr_we6Issue(csr_we6Issue),
		.pc_exc(pc_exc),
		.cause(cause),
		.exception_pending(exception_pending),
		.mret(m_ret),
		.sret(s_ret),
		.uret(u_ret)
	);
	top_aes aes(
		.clk(clk),
		.nrst(nrst),
		.start(start_aes),
		.key_addr(AES_key_addr[4:0]),
		.plaintext({AES_D3, AES_D2, AES_D1, AES_D0}),
		.result({AES_Res3, AES_Res2, AES_Res1, AES_Res0}),
		.done(aes_done)
	);
	reg [31:0] pc6Tmp;
	reg pc6Commit;
	always @(posedge clk or negedge nrst) begin
		if (!nrst) begin
			pc6Tmp <= 32'b00000000000000000000000000000000;
			pc6Commit <= 1'b0;
		end
		else if (pc6 == pc6Tmp)
			pc6Commit <= 1'b0;
		else begin
			pc6Commit <= 1'b1;
			pc6Tmp <= pc6;
		end
		end

endmodule
