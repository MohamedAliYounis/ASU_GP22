module commit_stage (
	input wire clk,
	input wire nrst,
	input wire [31:0] result6,
	input wire [4:0] rd6,
	input wire we6,
	input wire [31:0] pc6,
	input wire [31:0] csr_wb6,
	input wire [11:0] csr_wb_addr6,
	input wire csr_we6,
	input wire [31:0] cause6,
	input wire exception_pending6,
	input wire mret6,
	input wire sret6,
	input wire uret6,
	output wire [31:0] wb_data6,
	output wire [4:0] rd6Issue,
	output wire we6Issue,
	output wire [31:0] csr_wb,
	output wire [11:0] csr_wb_addr,
	output wire csr_we6Issue,
	output wire [31:0] pc_exc,
	output wire [31:0] cause,
	output wire exception_pending,
	output wire mret,
	output wire sret,
	output wire uret
);

	assign rd6Issue = rd6;
	assign we6Issue = we6 & ~exception_pending;
	assign wb_data6 = result6;
	assign csr_wb = csr_wb6;
	assign csr_wb_addr = csr_wb_addr6;
	assign csr_we6Issue = csr_we6;
	assign pc_exc = pc6;
	assign cause = cause6;
	assign exception_pending = exception_pending6;
	assign mret = mret6;
	assign sret = sret6;
	assign uret = uret6;
endmodule
