module instr_decoder (
		input wire [6:0] op,
	input wire [2:0] funct3,
	input wire [6:0] funct7,
	input wire [11:0] funct12,
	input wire instr_30,
	input wire exception_pending,
	input wire TSR,
	input wire illegal_flag,
	input wire [1:0] current_mode,
	output wire [1:0] B_SEL,
	output wire we,
	output wire [2:0] fn,
	output wire [3:0] alu_fn,
	output wire j,
	output wire jr,
	output wire bneq,
	output wire btype,
	output wire LUI,
	output wire auipc,
	output wire [3:0] mem_op,
	output wire [3:0] mulDiv_op,
	output wire [1:0] pcselect,
	output wire ecall,
	output wire ebreak,
	output wire uret,
	output wire sret,
	output wire mret,
	output wire illegal_instr,
	output wire aes_inst,
	output wire csr_we
);

	wire rtype;
	wire itype;
	wire stype;
	wire jtype;
	wire jrtype;
	wire utype;
	wire autype;
	wire ltype;
	wire system;
	wire wfi;
	wire illegal_retM;
	wire illegal_retS;
	wire illegal_ret;
	wire illegal_instruction;
	wire illegal_sret;
	wire i_lb;
	wire i_lh;
	wire i_lw;
	wire i_lbu;
	wire i_lhu;
	wire i_sb;
	wire i_sh;
	wire i_sw;
	wire i_add;
	wire i_sub;
	wire i_sll;
	wire i_slt;
	wire i_sltu;
	wire i_xor;
	wire i_srl;
	wire i_sra;
	wire i_or;
	wire i_and;
	wire i_mul;
	wire i_mulh;
	wire i_mulhsu;
	wire i_mulhu;
	wire i_div;
	wire i_divu;
	wire i_rem;
	wire i_remu;
	wire instr_25;
	wire i_addi;
	wire i_slti;
	wire i_sltiu;
	wire i_xori;
	wire i_ori;
	wire i_andi;
	wire i_slli;
	wire i_srli;
	wire i_srai;
	wire BEQ;
	wire BNE;
	wire BLT;
	wire BGE;
	wire BLTU;
	wire BGEU;
	wire i_jal;
	wire i_jalr;
	wire lui;
	wire aupc;
	wire noOp;
	assign instr_25 = ~(&funct7[6:1]) & funct7[0];
	assign noOp = ~(|op);
	assign rtype = (((((~op[6] & op[5]) & op[4]) & ~op[3]) & ~op[2]) & op[1]) & op[0];
	assign itype = (((((~op[6] & ~op[5]) & op[4]) & ~op[3]) & ~op[2]) & op[1]) & op[0];
	assign btype = (((((op[6] & op[5]) & ~op[4]) & ~op[3]) & ~op[2]) & op[1]) & op[0];
	assign jtype = (((((op[6] & op[5]) & ~op[4]) & op[3]) & op[2]) & op[1]) & op[0];
	assign jrtype = (((((op[6] & op[5]) & ~op[4]) & ~op[3]) & op[2]) & op[1]) & op[0];
	assign ltype = (((((~op[6] & ~op[5]) & ~op[4]) & ~op[3]) & ~op[2]) & op[1]) & op[0];
	assign stype = (((((~op[6] & op[5]) & ~op[4]) & ~op[3]) & ~op[2]) & op[1]) & op[0];
	assign autype = (((((~op[6] & ~op[5]) & op[4]) & ~op[3]) & op[2]) & op[1]) & op[0];
	assign utype = (((((~op[6] & op[5]) & op[4]) & ~op[3]) & op[2]) & op[1]) & op[0];
	assign system = (((((op[6] & op[5]) & op[4]) & ~op[3]) & ~op[2]) & op[1]) & op[0];
	assign ecall = (system & ~|funct3) & ~|funct12;
	assign ebreak = ((system & ~|funct3) & funct12[0]) & ~|funct7;
	assign uret = (((system & ~|funct3) & ~funct7[4]) & ~funct7[3]) & funct12[1];
	assign sret = ((((system & ~|funct3) & ~funct7[4]) & funct7[3]) & funct12[1]) & ~TSR;
	assign mret = (((system & ~|funct3) & funct7[4]) & funct7[3]) & funct12[1];
	assign wfi = (((system & ~|funct3) & funct12[0]) & funct12[2]) & funct12[8];
	assign illegal_retM = (current_mode == 2'b11) && mret;
	assign illegal_retS = (current_mode != 2'b00) && sret;
	assign illegal_ret = illegal_retM | illegal_retS;
	assign illegal_instruction = !(((((((((rtype || itype) || btype) || jtype) || jrtype) || ltype) || stype) || utype) || autype) || system) & illegal_flag;
	assign illegal_sret = ((((system & ~|funct3) & ~funct7[4]) & funct7[3]) & funct12[1]) & TSR;
	assign illegal_instr = (illegal_instruction || illegal_sret) || illegal_ret;
	assign aes_inst = (((((~op[6] & ~op[5]) & ~op[4]) & op[3]) & ~op[2]) & op[1]) & op[0];
	assign i_add = (rtype & ~instr_30) & ~(|funct3);
	assign i_sub = (rtype & instr_30) & ~(|funct3);
	assign i_sll = (((rtype & ~instr_30) & ~funct3[2]) & ~funct3[1]) & funct3[0];
	assign i_slt = (((rtype & ~instr_30) & ~funct3[2]) & funct3[1]) & ~funct3[0];
	assign i_sltu = (((rtype & ~instr_30) & ~funct3[2]) & funct3[1]) & funct3[0];
	assign i_xor = (((rtype & ~instr_30) & funct3[2]) & ~funct3[1]) & ~funct3[0];
	assign i_srl = (((rtype & ~instr_30) & funct3[2]) & ~funct3[1]) & funct3[0];
	assign i_sra = (((rtype & instr_30) & funct3[2]) & ~funct3[1]) & funct3[0];
	assign i_or = (((rtype & ~instr_30) & funct3[2]) & funct3[1]) & ~funct3[0];
	assign i_and = (rtype & ~instr_30) & &funct3;
	assign i_mul = (rtype & instr_25) & ~(|funct3);
	assign i_mulh = (((rtype & instr_25) & ~funct3[2]) & ~funct3[1]) & funct3[0];
	assign i_mulhsu = (((rtype & instr_25) & ~funct3[2]) & funct3[1]) & ~funct3[0];
	assign i_mulhu = (((rtype & instr_25) & ~funct3[2]) & funct3[1]) & funct3[0];
	assign i_div = (((rtype & instr_25) & funct3[2]) & ~funct3[1]) & ~funct3[0];
	assign i_divu = (((rtype & instr_25) & funct3[2]) & ~funct3[1]) & funct3[0];
	assign i_rem = (((rtype & instr_25) & funct3[2]) & funct3[1]) & ~funct3[0];
	assign i_remu = (rtype & instr_25) & &funct3;
	assign i_addi = (itype | wfi) & ~(|funct3);
	assign i_slti = ((itype & ~funct3[2]) & funct3[1]) & ~funct3[0];
	assign i_sltiu = ((itype & ~funct3[2]) & funct3[1]) & funct3[0];
	assign i_xori = ((itype & funct3[2]) & ~funct3[1]) & ~funct3[0];
	assign i_ori = ((itype & funct3[2]) & funct3[1]) & ~funct3[0];
	assign i_andi = itype & &funct3;
	assign i_slli = (((itype & ~instr_30) & ~funct3[2]) & ~funct3[1]) & funct3[0];
	assign i_srli = (((itype & ~instr_30) & funct3[2]) & ~funct3[1]) & funct3[0];
	assign i_srai = (((itype & instr_30) & funct3[2]) & ~funct3[1]) & funct3[0];
	assign BEQ = btype & ~(|funct3);
	assign BNE = ((btype & ~funct3[2]) & ~funct3[1]) & funct3[0];
	assign BLT = ((btype & funct3[2]) & ~funct3[1]) & ~funct3[0];
	assign BGE = ((btype & funct3[2]) & ~funct3[1]) & funct3[0];
	assign BLTU = ((btype & funct3[2]) & funct3[1]) & ~funct3[0];
	assign BGEU = btype & &funct3;
	assign i_jal = jtype;
	assign i_jalr = jrtype & ~(|funct3);
	assign lui = utype;
	assign aupc = autype;
	assign i_lb = ((ltype & ~funct3[2]) & ~funct3[1]) & ~funct3[0];
	assign i_lh = ((ltype & ~funct3[2]) & ~funct3[1]) & funct3[0];
	assign i_lw = ((ltype & ~funct3[2]) & funct3[1]) & ~funct3[0];
	assign i_lbu = ((ltype & funct3[2]) & ~funct3[1]) & ~funct3[0];
	assign i_lhu = ((ltype & funct3[2]) & ~funct3[1]) & funct3[0];
	assign i_sb = ((stype & ~funct3[2]) & ~funct3[1]) & ~funct3[0];
	assign i_sh = ((stype & ~funct3[2]) & ~funct3[1]) & funct3[0];
	assign i_sw = ((stype & ~funct3[2]) & funct3[1]) & ~funct3[0];
	assign mem_op[0] = ((((i_sw | i_sh) | i_sb) | i_lw) | i_lh) | i_lb;
	assign mem_op[1] = (((i_sw | i_sh) | i_lw) | i_lh) | i_lhu;
	assign mem_op[2] = (((i_sw | i_sb) | i_lw) | i_lb) | i_lbu;
	assign mem_op[3] = (i_sw | i_sb) | i_sh;
	assign pcselect[0] = 0;
	assign pcselect[1] = (btype | i_jal) | i_jalr;
	assign we = ((((((rtype | itype) | jtype) | jr) | ltype) | utype) | autype) | (system & ~exception_pending);
	assign csr_we = system;
	assign B_SEL[0] = ((((((i_addi | i_slti) | i_sltiu) | i_xori) | i_ori) | i_andi) | i_jalr) | ltype;
	assign B_SEL[1] = (i_slli | i_srli) | i_srai;
	assign alu_fn[0] = ((((((((((i_sll | i_slli) | i_sltu) | i_sltiu) | i_srl) | i_srli) | i_and) | i_andi) | i_sra) | i_srai) | BLTU) | BGE;
	assign alu_fn[1] = (((((((((i_slt | i_slti) | i_sltu) | i_sltiu) | i_or) | i_ori) | i_and) | i_andi) | BLTU) | BLT) | BGEU;
	assign alu_fn[2] = ((((((((i_xor | i_xori) | i_srl) | i_srli) | i_or) | i_ori) | i_and) | i_andi) | i_sra) | i_srai;
	assign alu_fn[3] = (((((i_sub | i_sra) | i_srai) | BEQ) | BNE) | BGE) | BGEU;
	assign mulDiv_op[0] = (((((i_mul | i_mulh) | i_mulhu) | i_div) | i_divu) | i_rem) | i_remu;
	assign mulDiv_op[1] = (((i_mul | i_mulhu) | i_mulhsu) | i_divu) | i_remu;
	assign mulDiv_op[2] = (((i_mulh | i_mulhu) | i_mulhsu) | i_rem) | i_remu;
	assign mulDiv_op[3] = ((i_div | i_divu) | i_rem) | i_remu;
	assign bneq = BNE;
	assign j = i_jal;
	assign jr = i_jalr;
	assign LUI = lui;
	assign auipc = aupc;
	assign fn[0] = ((i_jal | i_jalr) | lui) | aupc;
	assign fn[1] = ((((((((i_mul | i_mulh) | i_mulhsu) | i_mulhu) | i_rem) | i_remu) | i_div) | i_divu) | lui) | system;
	assign fn[2] = (ltype | aupc) | system;
endmodule
