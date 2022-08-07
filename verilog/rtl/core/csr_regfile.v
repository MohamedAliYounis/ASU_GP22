module csr_regfile (
	input wire clk,
	input wire nrst,
	input wire csr_we,
	input wire [11:0] csr_address_r,
	input wire [11:0] csr_address_wb,
	input wire [31:0] csr_wb,
	input wire exception_pending,
	input wire [31:0] cause,
	input wire [31:0] pc_exc,
	input wire m_ret,
	input wire s_ret,
	input wire u_ret,
	input wire m_interrupt,
	input wire s_interrupt,
	input wire u_interrupt,
	input wire [31:0] AES_Res0_i,
	input wire [31:0] AES_Res1_i,
	input wire [31:0] AES_Res2_i,
	input wire [31:0] AES_Res3_i,
	input wire aes_done,
	output reg m_timer,
	output reg s_timer,
	output reg u_timer,
	output reg [31:0] csr_data,
	output wire m_eie,
	output wire m_tie,
	output wire s_eie,
	output wire s_tie,
	output wire u_eie,
	output wire u_tie,
	output wire u_sie,
	output reg [1:0] current_mode,
	output wire TSR,
	output reg [31:0] epc,
	output wire [31:0] AES_D0_O,
	output wire [31:0] AES_D1_O,
	output wire [31:0] AES_D2_O,
	output wire [31:0] AES_D3_O,
	output wire [31:0] AES_key_addr_O
);
	
	reg [1:0] next_mode;
	reg status_sie;
	reg status_mie;
	reg status_spie;
	reg status_mpie;
	reg status_spp;
	reg [1:0] status_mpp;
	reg status_TSR;
	reg status_sum;
	reg [31:0] AES_D0;
	reg [31:0] AES_D1;
	reg [31:0] AES_D2;
	reg [31:0] AES_D3;
	reg [31:0] AES_key_addr;
	reg [31:0] AES_Res0;
	reg [31:0] AES_Res1;
	reg [31:0] AES_Res2;
	reg [31:0] AES_Res3;
	reg status_upie;
	reg status_uie;
	reg meie;
	reg seie;
	reg mtie;
	reg stie;
	reg usip;
	reg utip;
	reg ueip;
	reg usie;
	reg utie;
	reg ueie;
	reg mcause_interrupt;
	reg [30:0] mcause_code;
	reg scause_interrupt;
	reg [30:0] scause_code;
	reg ucause_interrupt;
	reg [30:0] ucause_code;
	reg [31:2] mtvec;
	reg [31:2] stvec;
	reg [31:2] utvec;
	reg [31:0] mscratch;
	reg [31:0] sscratch;
	reg [31:0] uscratch;
	wire [31:0] mcause;
	wire [31:0] scause;
	wire [31:0] ucause;
	reg [31:0] mepc;
	reg [31:0] sepc;
	reg [31:0] uepc;
	reg [31:0] mtval;
	reg [31:0] utval;
	reg [15:0] medeleg;
	reg [11:0] mideleg;
	reg [15:0] sedeleg;
	reg [11:0] sideleg;
	reg [31:0] stval;
	wire [31:0] mstatus;
	wire [31:0] mip;
	wire [31:0] mie;
	wire [31:0] sstatus;
	wire [31:0] sip;
	wire [31:0] sie;
	wire [31:0] ustatus;
	wire [31:0] uip;
	wire [31:0] uie;
	wire [31:0] medeleg_w;
	wire [31:0] mideleg_w;
	wire [31:0] sedeleg_w;
	wire [31:0] sideleg_w;
	reg [31:0] tvec_out;
	reg [63:0] stimecmp;
	reg [63:0] utimecmp;
	reg [63:0] mtimecmp;
	reg [63:0] timer;
	always @(*)
		case (csr_address_r)
			12'h301: csr_data = 32'b01000000000101000011000100000000;
			12'hf11: csr_data = 1'sb0;
			12'hf12: csr_data = 1'sb0;
			12'hf13: csr_data = 1'sb0;
			12'hf14: csr_data = 1'sb0;
			12'h300: csr_data = mstatus;
			12'h344: csr_data = mip;
			12'h304: csr_data = mie;
			12'h305: csr_data = {mtvec, 2'b00};
			12'h341: csr_data = {mepc[31:2], 2'b00};
			12'h342: csr_data = mcause;
			12'h343: csr_data = mtval;
			12'h340: csr_data = mscratch;
			12'hbbf: csr_data = mtimecmp;
			12'h302: csr_data = medeleg_w;
			12'h303: csr_data = mideleg_w;
			12'hc81, 12'hc80: csr_data = timer[63:32];
			12'hc01, 12'hc00: csr_data = timer[31:0];
			12'h7c0: csr_data = AES_D0;
			12'h7c1: csr_data = AES_D1;
			12'h7c2: csr_data = AES_D2;
			12'h7c3: csr_data = AES_D3;
			12'h7c4: csr_data = AES_key_addr;
			12'h7c5: csr_data = AES_Res0;
			12'h7c6: csr_data = AES_Res1;
			12'h7c7: csr_data = AES_Res2;
			12'h7c8: csr_data = AES_Res3;
			12'h141: csr_data = {sepc[31:2], 2'b00};
			12'h100: csr_data = sstatus;
			12'h104: csr_data = sie;
			12'h105: csr_data = {stvec, 2'b00};
			12'h140: csr_data = sscratch;
			12'h144: csr_data = sip;
			12'h142: csr_data = scause;
			12'h143: csr_data = stval;
			12'h5c0: csr_data = stimecmp;
			12'h102: csr_data = sedeleg_w;
			12'h103: csr_data = sideleg_w;
			12'h000: csr_data = ustatus;
			12'h004: csr_data = uie;
			12'h044: csr_data = uip;
			12'h005: csr_data = {utvec, 2'b00};
			12'h041: csr_data = {uepc[31:2], 2'b00};
			12'h042: csr_data = ucause;
			12'h043: csr_data = utval;
			12'h040: csr_data = uscratch;
			12'h8ff: csr_data = utimecmp;
			default: csr_data = 0;
		endcase
	assign mstatus = {9'b000000000, status_TSR, 3'b000, status_sum, 1'b0, 4'b0000, status_mpp, 2'b00, status_spp, status_mpie, 1'b0, status_spie, status_upie, status_mie, 1'b0, status_sie, status_uie};
	assign mip = {20'b00000000000000000000, m_interrupt, 1'b0, s_interrupt, 1'b0, m_timer, 1'b0, s_timer, 5'b00000};
	assign mie = {20'b00000000000000000000, meie, 1'b0, seie, 1'b0, mtie, 1'b0, stie, 5'b00000};
	assign mcause = {mcause_interrupt, mcause_code};
	assign medeleg_w = {16'b0000000000000000, medeleg};
	assign mideleg_w = {20'b00000000000000000000, mideleg};
	assign sstatus = {13'b0000000000000, status_sum, 9'b000000000, status_spp, status_upie, status_spie, 3'b000, status_sie, status_uie};
	assign sip = {22'b0000000000000000000000, s_interrupt, 3'b000, s_timer, 5'b00000};
	assign sie = {22'b0000000000000000000000, seie, 3'b000, stie, 5'b00000};
	assign scause = {scause_interrupt, scause_code};
	assign sedeleg_w = {16'b0000000000000000, sedeleg};
	assign sideleg_w = {20'b00000000000000000000, sideleg};
	assign ustatus = {27'b000000000000000000000000000, status_upie, 3'b000, status_uie};
	assign uip = {24'b000000000000000000000000, u_interrupt, 3'b000, u_timer, 3'b000, usip};
	assign uie = {24'b000000000000000000000000, ueie, 3'b000, utie, 3'b000, usie};
	assign ucause = {ucause_interrupt, ucause_code};
	always @(posedge clk or negedge nrst)
		if (!nrst) begin
			current_mode <= 2'b11;
			status_sie <= 0;
			status_mie <= 0;
			status_spie <= 0;
			status_mpie <= 0;
			status_spp <= 0;
			status_mpp <= 2'b11;
			status_sum <= 0;
			mtvec <= 0;
			mscratch <= 0;
			mepc <= 0;
			mtval <= 0;
			meie <= 0;
			seie <= 0;
			mtie <= 0;
			stie <= 0;
			mcause_interrupt <= 0;
			mcause_code <= 0;
			scause_interrupt <= 0;
			scause_code <= 0;
			ucause_interrupt <= 0;
			ucause_code <= 0;
			medeleg <= 0;
			mideleg <= 0;
			sedeleg <= 0;
			sideleg <= 0;
			sscratch <= 0;
			stvec <= 0;
			sepc <= 0;
			status_upie <= 0;
			status_uie <= 0;
			usip <= 0;
			utip <= 0;
			ueip <= 0;
			usie <= 0;
			utie <= 0;
			ueie <= 0;
			utvec <= 0;
			uscratch <= 0;
			uepc <= 0;
			utval <= 0;
			mtimecmp <= 0;
			stimecmp <= 0;
			utimecmp <= 0;
			AES_D0 <= 1'sb0;
			AES_D1 <= 1'sb0;
			AES_D2 <= 1'sb0;
			AES_D3 <= 1'sb0;
			AES_key_addr <= 1'sb0;
			AES_Res0 <= 1'sb0;
			AES_Res1 <= 1'sb0;
			AES_Res2 <= 1'sb0;
			AES_Res3 <= 1'sb0;
		end
		else begin
			current_mode <= next_mode;
			if (!exception_pending) begin
				if (csr_we)
					case (csr_address_wb)
						12'h300: begin
							status_sie <= csr_wb[1];
							status_mie <= csr_wb[3];
							status_spie <= csr_wb[5];
							status_mpie <= csr_wb[7];
							status_spp <= csr_wb[8];
							status_mpp <= csr_wb[12:11];
							status_sum <= csr_wb[18];
							status_TSR <= csr_wb[22];
						end
						12'h305: mtvec <= csr_wb[31:2];
						12'h304: begin
							stie <= csr_wb[5];
							mtie <= csr_wb[7];
							seie <= csr_wb[9];
							meie <= csr_wb[11];
						end
						12'h340: mscratch <= csr_wb;
						12'hbbf: mtimecmp <= csr_wb;
						12'h341: mepc <= {csr_wb[31:2], 2'b00};
						12'h342: begin
							mcause_code <= csr_wb[5:0];
							mcause_interrupt <= csr_wb[31];
						end
						12'h343: mtval <= csr_wb;
						12'h302: medeleg <= csr_wb[15:0];
						12'h303: mideleg <= csr_wb[11:0];
						12'h7c0: AES_D0 <= csr_wb;
						12'h7c1: AES_D1 <= csr_wb;
						12'h7c2: AES_D2 <= csr_wb;
						12'h7c3: AES_D3 <= csr_wb;
						12'h7c4: AES_key_addr <= csr_wb;
						12'h7c5: AES_Res0 <= csr_wb;
						12'h7c6: AES_Res1 <= csr_wb;
						12'h7c7: AES_Res2 <= csr_wb;
						12'h7c8: AES_Res3 <= csr_wb;
						12'h100: begin
							status_sum <= csr_wb[18];
							status_spp <= csr_wb[8];
							status_spie <= csr_wb[5];
							status_sie <= csr_wb[1];
						end
						12'h105: stvec <= csr_wb[31:2];
						12'h141: sepc <= {csr_wb[31:2], 2'b00};
						12'h142: begin
							scause_code <= csr_wb[5:0];
							scause_interrupt <= csr_wb[31];
						end
						12'h143: stval <= csr_wb;
						12'h104: begin
							stie <= csr_wb[5];
							seie <= csr_wb[9];
						end
						12'h140: sscratch <= csr_wb;
						12'h102: sedeleg <= csr_wb[15:0];
						12'h103: sideleg <= csr_wb[11:0];
						12'h5c0: stimecmp <= csr_wb;
						12'h000: begin
							status_upie <= csr_wb[4];
							status_uie <= csr_wb[0];
						end
						12'h004: begin
							usie <= csr_wb[0];
							utie <= csr_wb[4];
							ueie <= csr_wb[8];
						end
						12'h044: usip <= csr_wb[0];
						12'h040: uscratch <= csr_wb;
						12'h041: uepc <= {csr_wb[31:2], 2'b00};
						12'h042: begin
							mcause_code <= csr_wb[5:0];
							mcause_interrupt <= csr_wb[31];
						end
						12'h043: utval <= csr_wb;
						12'h005: utvec <= csr_wb[31:2];
						12'h8ff: utimecmp <= csr_wb;
					endcase
			end
			else if (!exception_pending && aes_done) begin
				AES_Res0 <= AES_Res0_i;
				AES_Res1 <= AES_Res1_i;
				AES_Res2 <= AES_Res2_i;
				AES_Res3 <= AES_Res3_i;
			end
			else if ((exception_pending && (next_mode == 2'b11)) && !m_ret) begin
				mepc <= {pc_exc[31:2], 2'b00};
				status_mie <= 0;
				status_mpie <= status_mie;
				status_mpp <= current_mode;
				mcause_interrupt <= cause[31];
				mcause_code <= cause[30:0];
				if (!cause[31])
					case (cause[30:0])
						32'h00000000: mtval <= {pc_exc[31:1], 1'b0};
						32'h00000002: mtval <= 0;
						default: mtval <= 0;
					endcase
				else
					mtval <= 0;
			end
			else if (m_ret) begin
				status_mie <= status_mpie;
				status_mpie <= 1;
				status_mpp <= 2'b00;
			end
			else if ((exception_pending && (next_mode == 2'b01)) && !s_ret) begin
				sepc <= {pc_exc[31:2], 2'b00};
				status_sie <= 0;
				status_spie <= status_sie;
				status_spp <= current_mode[0];
				scause_interrupt <= cause[31];
				scause_code <= cause[30:0];
				if (!cause[31])
					case (cause[30:0])
						32'h00000000: stval <= {pc_exc[31:1], 1'b0};
						32'h00000002: stval <= 0;
						default: stval <= 0;
					endcase
				else
					stval <= 0;
			end
			else if (s_ret) begin
				status_sie <= status_spie;
				status_spie <= 1;
				status_spp <= 0;
			end
			else if ((exception_pending && (next_mode == 2'b00)) && !u_ret) begin
				uepc <= {pc_exc[31:2], 2'b00};
				status_uie <= 0;
				status_upie <= status_uie;
				ucause_interrupt <= cause[31];
				ucause_code <= cause[30:0];
				if (!cause[31])
					case (cause[30:0])
						32'h00000000: utval <= {pc_exc, 1'b0};
						32'h00000002: utval <= 0;
						default: utval <= 0;
					endcase
				else
					utval <= 0;
			end
			else if (u_ret) begin
				status_uie <= status_upie;
				status_upie <= 1;
			end
		end
	always @(*) begin
		next_mode = current_mode;
		if (exception_pending)
			if (m_ret)
				next_mode = status_mpp;
			else if (s_ret)
				next_mode = (status_spp ? 2'b01 : 2'b00);
			else if (u_ret)
				next_mode = 2'b00;
			else if (cause[31]) begin
				if (mideleg[cause[30:0]] && sideleg[cause[30:0]])
					next_mode = 2'b00;
				else if (mideleg[cause[30:0]])
					next_mode = 2'b01;
				else
					next_mode = 2'b11;
			end
			else if (!cause[31]) begin
				if (medeleg[cause[30:0]] && sedeleg[cause[30:0]])
					next_mode = 2'b00;
				else if (medeleg[cause[30:0]])
					next_mode = 2'b01;
				else
					next_mode = 2'b11;
			end
			else
				next_mode = current_mode;
	end
	always @(posedge clk or negedge nrst)
		if (!nrst)
			timer <= 0;
		else
			timer <= timer + 1;
	always @(posedge clk or negedge nrst)
		if (!nrst)
			m_timer <= 0;
		else
			m_timer <= timer >= mtimecmp;
	always @(posedge clk or negedge nrst)
		if (!nrst)
			s_timer <= 0;
		else
			s_timer <= timer >= stimecmp;
	always @(posedge clk or negedge nrst)
		if (!nrst)
			u_timer <= 0;
		else
			u_timer <= timer >= utimecmp;
	assign m_eie = meie && status_mie;
	assign m_tie = mtie && status_mie;
	assign s_eie = seie && status_sie;
	assign s_tie = stie && status_sie;
	assign u_tie = utie && status_uie;
	assign u_eie = ueie && status_uie;
	assign u_sie = usie && status_uie;
	always @(*)
		if (next_mode == 2'b11)
			tvec_out = {mtvec, 2'b00};
		else if (next_mode == 2'b01)
			tvec_out = {stvec, 2'b00};
		else
			tvec_out = {utvec, 2'b00};
	always @(*)
		case ({m_ret, s_ret, u_ret})
			3'b000: epc = tvec_out;
			3'b100: epc = mepc;
			3'b010: epc = sepc;
			3'b001: epc = uepc;
			default: epc = tvec_out;
		endcase
	assign TSR = status_TSR;
	assign AES_D0_O = AES_D0;
	assign AES_D1_O = AES_D1;
	assign AES_D2_O = AES_D2;
	assign AES_D3_O = AES_D3;
	assign AES_key_addr_O = AES_key_addr;
endmodule
