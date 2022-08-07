module mem_decode (
	input wire clk,
	input wire nrst,
	input wire [3:0] mem_op4,
	input wire [31:0] op_a4,
	input wire [31:0] op_b4,
	input wire [31:0] S_imm4,
	input wire stall_mem,
	input wire dmem_finished,
	output wire [31:0] addr6,
	output wire [31:0] data_in6,
	output wire [1:0] baddr6,
	output wire gwe6,
	output wire rd6,
	output wire bw06,
	output wire bw16,
	output wire bw26,
	output wire bw36,
	output wire m_op6,
	output wire addr_misaligned6,
	output wire ld_addr_misaligned6,
	output wire samo_addr_misaligned6,
	output wire [3:0] mem_op6
);
	
	reg [3:0] mem_opReg5;
	reg [31:0] op_aReg5;
	reg [31:0] op_bReg5;
	reg [31:0] S_immReg5;
	wire [3:0] mem_op5;
	wire [31:0] op_a5;
	wire [31:0] op_b5;
	wire [31:0] S_imm5;
	wire gwe5;
	wire rd5;
	wire m_op5;
	wire [31:0] addr5;
	reg [31:0] data_in5;
	wire [1:0] addr_mis5;
	wire addr_misaligned5;
	wire ld_addr_misaligned5;
	wire samo_addr_misaligned5;
	wire bw05;
	wire bw15;
	wire bw25;
	wire bw35;
	reg gweReg6;
	reg rdReg6;
	reg m_opReg6;
	reg [3:0] mem_opReg6;
	reg [31:0] addrReg6;
	reg [31:0] data_inReg6;
	reg addr_misalignedReg6;
	reg ld_addr_misalignedReg6;
	reg samo_addr_misalignedReg6;
	reg bw0Reg6;
	reg bw1Reg6;
	reg bw2Reg6;
	reg bw3Reg6;
	wire [31:0] data_out6;
	reg memstallReg;
	wire memstallwire;
	assign memstallwire = (dmem_finished && stall_mem ? 1'b0 : memstallReg);
	always @(posedge clk or negedge nrst)
		if (!nrst) begin
			mem_opReg5 <= 0;
			op_aReg5 <= 0;
			op_bReg5 <= 0;
			S_immReg5 <= 0;
			memstallReg <= 0;
		end
		else begin
			if (stall_mem && ~memstallwire) begin
				mem_opReg5 <= mem_op4;
				op_aReg5 <= op_a4;
				op_bReg5 <= op_b4;
				S_immReg5 <= S_imm4;
			end
			else if ((stall_mem && memstallwire) && memstallReg) begin
				mem_opReg5 <= mem_opReg5;
				op_aReg5 <= op_aReg5;
				op_bReg5 <= op_bReg5;
				S_immReg5 <= S_immReg5;
			end
			else begin
				mem_opReg5 <= mem_op4;
				op_aReg5 <= op_a4;
				op_bReg5 <= op_b4;
				S_immReg5 <= S_imm4;
			end
			if (stall_mem)
				memstallReg <= 1;
			if (dmem_finished)
				memstallReg <= 0;
		end
	always @(posedge clk or negedge nrst)
		if (!nrst) begin
			gweReg6 <= 0;
			rdReg6 <= 0;
			mem_opReg6 <= 0;
			addrReg6 <= 0;
			data_inReg6 <= 0;
			addr_misalignedReg6 <= 0;
			ld_addr_misalignedReg6 <= 0;
			samo_addr_misalignedReg6 <= 0;
			bw0Reg6 <= 0;
			bw1Reg6 <= 0;
			bw2Reg6 <= 0;
			bw3Reg6 <= 0;
			m_opReg6 <= 0;
		end
		else begin
			gweReg6 <= gwe5;
			rdReg6 <= rd5;
			mem_opReg6 <= mem_op5;
			addrReg6 <= addr5;
			data_inReg6 <= data_in5;
			addr_misalignedReg6 <= addr_misaligned5;
			ld_addr_misalignedReg6 <= ld_addr_misaligned5;
			samo_addr_misalignedReg6 <= samo_addr_misaligned5;
			bw0Reg6 <= bw05;
			bw1Reg6 <= bw15;
			bw2Reg6 <= bw25;
			bw3Reg6 <= bw35;
			m_opReg6 <= m_op5;
		end
	assign mem_op5 = mem_opReg5;
	assign op_a5 = op_aReg5;
	assign op_b5 = op_bReg5;
	assign S_imm5 = S_immReg5;
	assign addr5 = (mem_op5[3] ? S_imm5 + op_a5 : op_b5 + op_a5);
	assign m_op5 = |mem_op5;
	assign addr_mis5[0] = mem_op5[1] & addr5[0];
	assign addr_mis5[1] = (mem_op5[1] & mem_op5[2]) & addr5[1];
	assign addr_misaligned5 = addr_mis5[0] | addr_mis5[1];
	assign ld_addr_misaligned5 = addr_misaligned5 & ~mem_op5[3];
	assign samo_addr_misaligned5 = addr_misaligned5 & mem_op5[3];
	assign gwe5 = &mem_op5 & ~addr_misaligned5;
	assign rd5 = !mem_op5[3] & ~addr_misaligned5;
	assign bw05 = (((~addr5[1] & ~addr5[0]) & mem_op5[3]) & ~addr_misaligned5) | gwe5;
	assign bw25 = (((addr5[1] & ~addr5[0]) & mem_op5[3]) & ~addr_misaligned5) | gwe5;
	assign bw15 = (((~addr5[1] & ((addr5[0] & mem_op5[2]) | (~addr5[0] & mem_op5[1]))) & mem_op5[3]) & ~addr_misaligned5) | gwe5;
	assign bw35 = (((addr5[1] & ((addr5[0] & mem_op5[2]) | (~addr5[0] & mem_op5[1]))) & mem_op5[3]) & ~addr_misaligned5) | gwe5;
	always @(*)
		case (mem_op5[2:1])
			2'b11: data_in5 = op_b5;
			2'b01: data_in5 = {op_b5[15:0], op_b5[15:0]};
			2'b10: data_in5 = {op_b5[7:0], op_b5[7:0], op_b5[7:0], op_b5[7:0]};
			default: data_in5 = op_b5;
		endcase
	assign gwe6 = gweReg6;
	assign rd6 = rdReg6;
	assign mem_op6 = mem_opReg6;
	assign addr6 = addrReg6;
	assign data_in6 = data_inReg6;
	assign addr_misaligned6 = addr_misalignedReg6;
	assign ld_addr_misaligned6 = ld_addr_misalignedReg6;
	assign samo_addr_misaligned6 = samo_addr_misalignedReg6;
	assign bw06 = bw0Reg6;
	assign bw16 = bw1Reg6;
	assign bw26 = bw2Reg6;
	assign bw36 = bw3Reg6;
	assign m_op6 = m_opReg6;
endmodule
module piton_fsm (
	clk,
	nrst,
	addr6,
	data_in6,
	m_rd6,
	bw06,
	bw16,
	bw26,
	bw36,
	m_op6,
	mem_op6,
	core_l15_rqtype,
	core_l15_size,
	core_l15_address,
	core_l15_data,
	core_l15_val,
	l15_core_data_0,
	l15_core_data_1,
	l15_core_returntype,
	l15_core_val,
	l15_core_ack,
	l15_core_header_ack,
	core_l15_req_ack,
	mem_out6,
	memOp_done
);
	input wire clk;
	input wire nrst;
	input wire [31:0] addr6;
	input wire [31:0] data_in6;
	input wire m_rd6;
	input wire bw06;
	input wire bw16;
	input wire bw26;
	input wire bw36;
	input wire m_op6;
	input wire [3:0] mem_op6;
	output reg [4:0] core_l15_rqtype;
	output reg [2:0] core_l15_size;
	output reg [31:0] core_l15_address;
	output reg [63:0] core_l15_data;
	output reg core_l15_val;
	input wire [63:0] l15_core_data_0;
	input wire [63:0] l15_core_data_1;
	input wire [3:0] l15_core_returntype;
	input wire l15_core_val;
	input wire l15_core_ack;
	input wire l15_core_header_ack;
	output wire core_l15_req_ack;
	output reg [31:0] mem_out6;
	output reg memOp_done;
	reg state_reg;
	wire req_fire;
	wire resp_int;
	wire resp_fire;
	wire [31:0] wdata;
	wire [3:0] bw;
	reg [3:0] mem_opReg;
	reg [1:0] baddr;
	wire [3:0] rqtypeReg;
	wire [31:0] addrReg;
	reg [31:0] rdata;
	reg [31:0] piton_out;
	assign req_fire = (l15_core_header_ack && (state_reg == 1'd0)) && m_op6;
	assign resp_fire = l15_core_val && (state_reg == 1'd1);
	assign wdata = {data_in6[7:0], data_in6[15:8], data_in6[23:16], data_in6[31:24]};
	assign bw = {bw36, bw26, bw16, bw06};
	assign core_l15_req_ack = resp_fire || l15_core_val;
	always @(posedge clk or negedge nrst)
		if (!nrst)
			state_reg <= 1'd0;
		else
			case (state_reg)
				1'd0:
					if (req_fire) begin
						state_reg <= 1'd1;
						mem_opReg <= mem_op6;
					end
				1'd1:
					if (resp_fire)
						case (core_l15_rqtype)
							4'b0000:
								if (l15_core_returntype == 4'b0000)
									state_reg <= 1'd0;
							4'b0001:
								if (l15_core_returntype == 4'b0100)
									state_reg <= 1'd0;
							default: state_reg <= state_reg;
						endcase
			endcase
	always @(*)
		case (state_reg)
			1'd0: begin
				memOp_done = 0;
				baddr = addr6[1:0];
				core_l15_data = {wdata, wdata};
				core_l15_address = addr6;
				core_l15_val = m_op6;
				if (bw) begin
					core_l15_rqtype = 4'b0001;
					case (bw)
						4'b1111: core_l15_size = 3'b011;
						4'b1100, 4'b0011: core_l15_size = 3'b010;
						4'b0001, 4'b0010, 4'b0100, 4'b1000: core_l15_size = 3'b001;
						default: core_l15_size = 3'b000;
					endcase
				end
				else if (m_rd6) begin
					core_l15_rqtype = 4'b0000;
					core_l15_size = 3'b011;
				end
				else begin
					core_l15_rqtype = 4'b0000;
					core_l15_size = 3'b011;
				end
			end
			1'd1: begin
				core_l15_val = 0;
				memOp_done = l15_core_val;
				baddr = addr6[1:0];
				core_l15_data = {wdata, wdata};
				core_l15_address = addr6;
				core_l15_val = m_op6;
				if (bw) begin
					core_l15_rqtype = 4'b0001;
					case (bw)
						4'b1111: core_l15_size = 3'b011;
						4'b1100, 4'b0011: core_l15_size = 3'b010;
						4'b0001, 4'b0010, 4'b0100, 4'b1000: core_l15_size = 3'b001;
						default: core_l15_size = 3'b000;
					endcase
				end
				else if (m_rd6) begin
					core_l15_rqtype = 4'b0000;
					core_l15_size = 3'b011;
				end
				else begin
					core_l15_rqtype = 4'b0000;
					core_l15_size = 3'b011;
				end
			end
		endcase
	function automatic signed [31:0] sv2v_cast_32_signed;
		input reg signed [31:0] inp;
		sv2v_cast_32_signed = inp;
	endfunction
	always @(*)
		if ((core_l15_rqtype == 4'b0000) & (l15_core_val == 1)) begin
			case (core_l15_address[3:2])
				2'b00: rdata = l15_core_data_0[63:32];
				2'b01: rdata = l15_core_data_0[31:0];
				2'b10: rdata = l15_core_data_1[63:32];
				2'b11: rdata = l15_core_data_1[31:0];
			endcase
			piton_out = {rdata[7:0], rdata[15:8], rdata[23:16], rdata[31:24]};
			case (mem_opReg[2:0])
				3'b101: mem_out6 = sv2v_cast_32_signed($signed(piton_out[baddr * 8+:8]));
				3'b011: mem_out6 = sv2v_cast_32_signed($signed({piton_out[(baddr + 1) * 8+:8], piton_out[baddr * 8+:8]}));
				3'b111: mem_out6 = piton_out;
				3'b100: mem_out6 = {24'b000000000000000000000000, piton_out[baddr * 8+:8]};
				3'b010: mem_out6 = {16'b0000000000000000, piton_out[(baddr + 1) * 8+:8], piton_out[baddr * 8+:8]};
				default: mem_out6 = 0;
			endcase
		end
		else
			mem_out6 = 0;
endmodule
module mem_wrap (
	clk,
	nrst,
	mem_op4,
	op_a4,
	op_b4,
	S_imm4,
	stall_mem,
	dmem_finished,
	mem_l15_rqtype,
	mem_l15_size,
	mem_l15_address,
	mem_l15_data,
	mem_l15_val,
	l15_mem_data_0,
	l15_mem_data_1,
	l15_mem_returntype,
	l15_mem_val,
	l15_mem_ack,
	l15_mem_header_ack,
	mem_l15_req_ack,
	mem_out6,
	memOp_done,
	m_op6,
	ld_addr_misaligned6,
	samo_addr_misaligned6
);
	input wire clk;
	input wire nrst;
	input wire [3:0] mem_op4;
	input wire [31:0] op_a4;
	input wire [31:0] op_b4;
	input wire [31:0] S_imm4;
	input wire stall_mem;
	input wire dmem_finished;
	output wire [4:0] mem_l15_rqtype;
	output wire [2:0] mem_l15_size;
	output wire [31:0] mem_l15_address;
	output wire [63:0] mem_l15_data;
	output wire mem_l15_val;
	input wire [63:0] l15_mem_data_0;
	input wire [63:0] l15_mem_data_1;
	input wire [3:0] l15_mem_returntype;
	input wire l15_mem_val;
	input wire l15_mem_ack;
	input wire l15_mem_header_ack;
	output wire mem_l15_req_ack;
	output wire [31:0] mem_out6;
	output wire memOp_done;
	output wire m_op6;
	output wire ld_addr_misaligned6;
	output wire samo_addr_misaligned6;
	wire [31:0] addr6;
	wire [31:0] data_in6;
	wire [1:0] baddr6;
	wire gwe6;
	wire rd6;
	wire bw06;
	wire bw16;
	wire bw26;
	wire bw36;
	wire addr_misaligned6;
	wire [3:0] mem_op6;
	wire m_rd6;
	mem_decode mem_decode(
		.clk(clk),
		.nrst(nrst),
		.mem_op4(mem_op4),
		.op_a4(op_a4),
		.op_b4(op_b4),
		.S_imm4(S_imm4),
		.stall_mem(stall_mem),
		.dmem_finished(dmem_finished),
		.addr6(addr6),
		.data_in6(data_in6),
		.baddr6(baddr6),
		.gwe6(gwe6),
		.rd6(m_rd6),
		.bw06(bw06),
		.bw16(bw16),
		.bw26(bw26),
		.bw36(bw36),
		.m_op6(m_op6),
		.addr_misaligned6(addr_misaligned6),
		.ld_addr_misaligned6(ld_addr_misaligned6),
		.samo_addr_misaligned6(samo_addr_misaligned6),
		.mem_op6(mem_op6)
	);
	piton_fsm piton_fsm(
		.clk(clk),
		.nrst(nrst),
		.addr6(addr6),
		.data_in6(data_in6),
		.m_rd6(m_rd6),
		.bw06(bw06),
		.bw16(bw16),
		.bw26(bw26),
		.bw36(bw36),
		.m_op6(m_op6),
		.mem_op6(mem_op6),
		.core_l15_rqtype(mem_l15_rqtype),
		.core_l15_size(mem_l15_size),
		.core_l15_address(mem_l15_address),
		.core_l15_data(mem_l15_data),
		.core_l15_val(mem_l15_val),
		.l15_core_data_0(l15_mem_data_0),
		.l15_core_data_1(l15_mem_data_1),
		.l15_core_returntype(l15_mem_returntype),
		.l15_core_val(l15_mem_val),
		.l15_core_ack(l15_mem_ack),
		.l15_core_header_ack(l15_mem_header_ack),
		.core_l15_req_ack(mem_l15_req_ack),
		.mem_out6(mem_out6),
		.memOp_done(memOp_done)
	);
endmodule
