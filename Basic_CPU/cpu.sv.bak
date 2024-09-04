module cpu(
input clk,
inout [7:0] data_bus,
output[15:0] address_bus,
output memory_write_en,
output memory_chip_sel
);

reg [7:0] reg_a;
reg [7:0] reg_b;
reg [7:0] reg_c;
reg [7:0] reg_d;


reg [15:0] instr_reg;
reg [3:0] pipeline_stage_active;

reg [15:0] program_counter;

reg mem_select;
reg mem_write_en;
reg [15:0] mem_addr;

assign memory_write_en = mem_write_en;
assign memory_chip_sel = mem_select;
assign address_bus = mem_addr;

initial
begin
	program_counter = 0;
	pipeline_stage_active = 0;
	
	reg_a = 0;
	reg_b = 0;
	reg_c = 0;
	reg_d = 0;
	
	mem_select = 0;
	mem_write_en = 0;
	mem_addr = 22;
end

always @(posedge clk) begin

	case (pipeline_stage_active)
	// Prep RAM for instruction fetch.
	4'b0000:
	begin
		mem_select <= 1;
		mem_write_en <= 0;
		mem_addr <= program_counter;
		pipeline_stage_active <= pipeline_stage_active + 1;
	end
	
	// Fetch first byte of instruction.
	4'b0001:
	begin
		instr_reg [7:0] <= data_bus;
		pipeline_stage_active <= pipeline_stage_active + 1;
	end
	
	// Prep RAM for second byte fetch.
	4'b0010:
	begin

		mem_addr <= mem_addr + 1;
		pipeline_stage_active <= pipeline_stage_active + 1;
	end
	
	// Fetch second byte of instruction.
	4'b0011:
	begin
		instr_reg [15:8] <= data_bus;
		pipeline_stage_active <= pipeline_stage_active + 1;
	end
	
	4'b0100:
	begin
	
	end
	
	endcase
		
end





endmodule