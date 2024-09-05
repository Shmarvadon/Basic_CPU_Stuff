module cpu(
input clk,
inout [7:0] memory_data_bus,
output[15:0] memory_address_bus,
output memory_write_en,
output memory_chip_sel
);

reg [15:0] instruction_reg;
reg [15:0] program_counter;
reg [3:0] pipeline_stage_active;
wire exec_instr;
reg exec_instr_en;

wire [7:0] gpr_regs_input[3:0];
wire [7:0] gpr_regs_output[3:0];
wire [3:0] gpr_regs_write_en;

regs registers(clk, gpr_regs_input, gpr_regs_output, gpr_regs_write_en);

lsu loadstore(exec_instr, memory_data_bus, memory_address_bus, memory_chip_sel, memory_write_en, gpr_regs_input, gpr_regs_output, gpr_regs_write_en, instruction_reg);

alu arithmeticlogic(exec_instr, gpr_regs_input, gpr_regs_output, gpr_regs_write_en, instruction_reg);

//reg [15:0] mem_addr_sel;
reg mem_chip_sel;
reg mem_write_en;

// Assign exec_instr_en to drive exec_instr wire.
assign exec_instr = exec_instr_en;

// Assign the program_counter register to drive memoryaddress if in instruction fetch phase.
//assign memory_address_bus = pipeline_stage_active < 5 ? program_counter : 'hz;
assign memory_address_bus = !exec_instr_en ? program_counter : 'hz;

// Assign mem_chip_sel to drive memory_chip_sel wire if instruction fetch phase.
//assign memory_chip_sel = pipeline_stage_active < 5 ? mem_chip_sel : 'hz;
assign memory_chip_sel = !exec_instr_en ? mem_chip_sel : 'hz;

// Assign mem_write_en to drive memory_write_en wire if instruction fetch phase.
//assign memory_write_en = pipeline_stage_active < 5 ? mem_write_en : 'hz;
assign memory_write_en = !exec_instr_en ? mem_write_en : 'hz;

initial
begin
	program_counter = 16'b0000100000000000;
	pipeline_stage_active = 0;
	exec_instr_en = 0;

end

always @(posedge clk) begin

	case (pipeline_stage_active)
	// Prep RAM for instruction fetch & disable execution of instruction.
	0:
	begin
		
		exec_instr_en <= 0;
	
		mem_chip_sel <= 1;
		mem_write_en <= 0;
		pipeline_stage_active <= pipeline_stage_active + 1;
	end
	
	// Fetch first byte of instruction.
	1:
	begin
		instruction_reg [7:0] <= memory_data_bus;
		pipeline_stage_active <= pipeline_stage_active + 1;
	end
	
	// Prep RAM for second byte fetch.
	2:
	begin

		program_counter <= program_counter + 1;
		pipeline_stage_active <= pipeline_stage_active + 1;
	end
	
	// Fetch second byte of instruction.
	3:
	begin
		instruction_reg [15:8] <= memory_data_bus;
		pipeline_stage_active <= pipeline_stage_active + 1;
		exec_instr_en <= 1;
	end
	
	// Enable execution of instruction.
	4:
	begin
		pipeline_stage_active <= 0;
		program_counter <= program_counter + 1;
	end
	
	endcase
		
end





endmodule