module frontend_stage (
	input wire clk,
	input wire nrst,
	input wire stall,
	input wire nostall,
	input wire [1:0] killnum,
	input wire [1:0] PCSEL,
	input wire [31:0] target,
	input wire exception_pending,
	input wire [31:0] epc,
	output wire instruction_addr_misaligned2,
	output wire [31:0] pc2,
	output reg [31:0] instr2,
	output wire illegal_flag,
	output wire discardwire,
	output reg [4:0] transducer_l15_rqtype,
	output reg [2:0] transducer_l15_size,
	output reg [31:0] transducer_l15_address,
	output wire [63:0] transducer_l15_data,
	output reg transducer_l15_val,
	input wire l15_transducer_ack,
	input wire l15_transducer_header_ack,
	input wire l15_transducer_val,
	input wire [63:0] l15_transducer_data_0,
	input wire [63:0] l15_transducer_data_1,
	input wire [3:0] l15_transducer_returntype,
	output reg transducer_l15_req_ack,
	output reg [1:0] state_reg,
	input wire stall_mem,
	input wire arb_eqmem,
	input wire memOp_done
);
	
	reg [31:0] pcReg;
	reg [31:0] pcReg2;
	reg [31:0] targetsave;
	reg targetcame;
	reg killafterreq;
	reg discardReg;
	reg illegal_flagReg;
	wire pc_addr_ex;
	wire discard;
	reg instruction_addr_misalignedReg2;
	reg [31:0] npc;
	wire [31:0] pc;
	assign pc_addr_ex = pcReg[1] & pcReg[0];
	reg wake_up;
	localparam [1:0] s_req = 0;
	localparam [1:0] s_wait_ack = 1;
	localparam [1:0] s_resp = 2;
	wire req_fire;
	wire resp_init;
	wire resp_fire;
	always @(posedge clk or negedge nrst)
		if (!nrst)
			wake_up <= 0;
		else if (wake_up == 0)
			if (l15_transducer_returntype == 4'b0111)
				wake_up <= l15_transducer_val;
	assign discard = (stall ? 1'b1 : 1'b0);
	assign discardwire = discardReg;
	always @(posedge clk or negedge nrst)
		if (!nrst) begin
			pcReg <= 32'h40000000;
			pcReg2 <= 32'h40000000;
			instruction_addr_misalignedReg2 <= 0;
			discardReg <= 0;
			state_reg <= 3'b000;
			killafterreq <= 0;
			targetsave <= 0;
			targetcame <= 0;
		end
		else if (!wake_up) begin
			pcReg <= 32'h40000000;
			pcReg2 <= 32'h40000000;
			instruction_addr_misalignedReg2 <= 0;
		end
		else begin
			if (discard || (stall && nostall)) begin
				pcReg <= pcReg2;
				pcReg2 <= pcReg2;
			end
			else if (discardReg && (state_reg == s_resp)) begin
				pcReg <= pcReg2;
				pcReg2 <= pcReg2;
				targetcame <= 0;
			end
			else if (npc == targetsave) begin
				pcReg <= npc;
				if (killafterreq && targetcame)
					pcReg2 <= pcReg2;
				else
					pcReg2 <= pcReg;
				targetcame <= 0;
			end
			else if (killafterreq || targetcame)
				pcReg2 <= 0;
			else if (stall) begin
				pcReg <= pcReg;
				pcReg2 <= pcReg2;
				instruction_addr_misalignedReg2 <= instruction_addr_misalignedReg2;
			end
			else if (stall_mem || ((arb_eqmem && ~memOp_done) && ~exception_pending)) begin
				pcReg <= pcReg;
				pcReg2 <= pcReg2;
				instruction_addr_misalignedReg2 <= instruction_addr_misalignedReg2;
			end
			else begin
				pcReg <= npc;
				pcReg2 <= pcReg;
				instruction_addr_misalignedReg2 <= pc_addr_ex;
				illegal_flagReg <= nrst;
			end
			case (state_reg)
				s_req:
					if (req_fire) begin
						if (killafterreq) begin
							pcReg <= targetsave;
							killafterreq <= 0;
						end
						if (l15_transducer_ack)
							state_reg <= s_resp;
						else
							state_reg <= s_wait_ack;
					end
				s_wait_ack:
					if (l15_transducer_ack)
						state_reg <= s_resp;
				s_resp:
					if (resp_fire) begin
						state_reg <= s_req;
						if (discardReg)
							discardReg <= 0;
					end
			endcase
			if (discard || (stall && nostall))
				discardReg <= 1;
			if ((~(!killnum[0] && !killnum[1]) && targetcame) && (state_reg == s_resp))
				killafterreq <= 1;
			if ((PCSEL[1] && ~PCSEL[0]) && ~(state_reg == s_req)) begin
				targetsave <= target;
				targetcame <= 1;
			end
			else
				targetsave <= targetsave;
		end
	always @(*) begin
		npc = pcReg + 4;
		if (exception_pending || ((state_reg == s_resp) && resp_fire))
			casez ({exception_pending, PCSEL})
				3'b000: npc = (targetcame ? targetsave : pcReg + 4);
				3'b001: npc = 32'h40000000;
				3'b010: npc = target;
				3'b011: npc = npc;
				3'b1zz: npc = epc;
				default: npc = pcReg + 4;
			endcase
		else if (exception_pending)
			npc = ((state_reg == s_req) && exception_pending ? epc : pcReg);
		else
			npc = ((state_reg == s_req) && (PCSEL[1] && ~PCSEL[0]) ? target : pcReg);
	end
	instr_mem m1(
		.clk(clk),
		.addr(pc),
		.instr(instr2)
	);
	assign pc = pcReg;
	assign pc2 = pcReg2;
	assign req_fire = ((l15_transducer_header_ack && transducer_l15_val) && (state_reg == s_req)) && wake_up;
	assign resp_fire = (l15_transducer_val && (state_reg == s_resp)) && !resp_init;
	assign resp_init = (((l15_transducer_returntype != 4'b0000) && (l15_transducer_returntype != 4'b0001)) && (l15_transducer_returntype != 4'b0100)) && l15_transducer_val;
	reg [31:0] l15_data;
	always @(*)
		case (transducer_l15_address[3:2])
			2'b00: l15_data = l15_transducer_data_0[63:32];
			2'b01: l15_data = l15_transducer_data_0[31:0];
			2'b10: l15_data = l15_transducer_data_1[63:32];
			2'b11: l15_data = l15_transducer_data_1[31:0];
			default:
				;
		endcase
	always @(*)
		case (state_reg)
			s_req: begin
				if (exception_pending)
					transducer_l15_address <= epc;
				else
					transducer_l15_address <= (PCSEL[1] && ~PCSEL[0] ? target : pc);
				transducer_l15_rqtype <= 0;
				transducer_l15_size <= 8;
				transducer_l15_val <= 1 && wake_up;
				transducer_l15_req_ack <= resp_init && wake_up;
				instr2 <= 32'h00000033;
			end
			s_wait_ack: begin
				transducer_l15_address <= pc;
				transducer_l15_rqtype <= 0;
				transducer_l15_size <= 8;
				transducer_l15_val <= 0;
				transducer_l15_req_ack <= resp_init && wake_up;
				instr2 <= 32'h00000033;
			end
			s_resp: begin
				transducer_l15_address <= pc;
				transducer_l15_rqtype <= 0;
				transducer_l15_size <= 8;
				transducer_l15_val <= 0;
				transducer_l15_req_ack <= resp_init || l15_transducer_val;
				instr2 <= (l15_transducer_val ? ((((killafterreq || (killnum[0] && !killnum[1])) || discardReg) || discard) || (stall && nostall) ? 32'h00000033 : {l15_data[7:0], l15_data[15:8], l15_data[23:16], l15_data[31:24]}) : 32'h00000033);
			end
		endcase
	assign instruction_addr_misaligned2 = instruction_addr_misalignedReg2;
	assign illegal_flag = illegal_flagReg;
endmodule
