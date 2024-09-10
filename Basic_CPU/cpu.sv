module core(
input clk,
inout [7:0] mem_dat_bus,
output[15:0] mem_addr_bus,
output mem_we,
output mem_chip_sel
);

reg [15:0] instr_reg;
reg [3:0]  pc_addr_space;
reg [3:0] pipeline_stage_active;

wire alu_en;
wire lsu_en;
wire pfcu_en;
reg exec_instr_en;

reg [11:0] pc;
wire pc_reg_we;
wire [11:0] pc_inp;

wire [7:0] gprs_inp[3:0];
wire [7:0] gprs_oup[3:0];
wire [3:0] gprs_we;
wire [7:0] alu_status;

registers regs(clk, gprs_inp, gprs_oup, gprs_we);

load_store_unit lsu(lsu_en, mem_dat_bus, mem_addr_bus, mem_chip_sel, mem_we, gprs_inp, gprs_oup, gprs_we, instr_reg);

arithmetic_logic_unit alu(alu_en, gprs_inp, gprs_oup, gprs_we, alu_status, instr_reg);

program_flow_control_unit pfcu(pfcu_en, alu_status, pc_inp, pc_reg_we, instr_reg);

reg mem_chip_sel_reg;
reg mem_we_reg;

// Assign exec_instr_en to drive exec_instr wire.
assign alu_en = instr_reg [15:14] == 2'b00 ? exec_instr_en : 0;
assign lsu_en = instr_reg [15:14] == 2'b01 ? exec_instr_en : 0;
assign pfcu_en = instr_reg [15:14] == 2'b10 ? exec_instr_en : 0;

// Assign the program_counter register to drive memoryaddress if in instruction fetch phase.
assign mem_addr_bus = !exec_instr_en ? {pc_addr_space, pc} : 'hz;

// Assign mem_chip_sel to drive memory_chip_sel wire if instruction fetch phase.
assign mem_chip_sel = !exec_instr_en ? mem_chip_sel_reg : 'hz;

// Assign mem_write_en to drive memory_write_en wire if instruction fetch phase.
assign mem_we = !exec_instr_en ? mem_we_reg : 'hz;

initial
begin
	pc = 12'b000000000000;
	pc_addr_space = 1;
	pipeline_stage_active = 0;
	exec_instr_en = 0;
end

always @(posedge clk) begin

	case (pipeline_stage_active)
	// Prep RAM for instruction fetch & disable execution of instruction.
	0:
	begin
		
		exec_instr_en <= 0;
	
		mem_chip_sel_reg <= 1;
		mem_we_reg <= 0;
		pipeline_stage_active <= pipeline_stage_active + 1;
	end
	
	// Fetch first byte of instruction.
	1:
	begin
		instr_reg [7:0] <= mem_dat_bus;
		pipeline_stage_active <= pipeline_stage_active + 1;
	end
	
	// Prep RAM for second byte fetch.
	2:
	begin

		pc <= pc + 1;
		pipeline_stage_active <= pipeline_stage_active + 1;
	end
	
	// Fetch second byte of instruction & enable execution.
	3:
	begin
		instr_reg [15:8] <= mem_dat_bus;
		pipeline_stage_active <= pipeline_stage_active + 1;
	end
	
	// Execution stuff innit.
	4:
	begin
		exec_instr_en <= 1;
		pipeline_stage_active <= pipeline_stage_active + 1;
	end
	// Execution stuff innit.
	5: 
	begin
		pipeline_stage_active <= 0;
		pc <= pc + 1;
		
		// PFCU supporting stuff.
		if (pc_reg_we & exec_instr_en) begin
			pc <= pc_inp;
		end
	end
	
	endcase
		

end





endmodule