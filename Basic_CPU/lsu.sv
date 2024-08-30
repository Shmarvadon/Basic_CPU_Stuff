module lsu(
input clk,

// Memory interface stuff.
inout [7:0]  memory_data_bus,
output [15:0] memory_address_bus,
output memory_enable,
output memory_write_enable,

// Backend interface stuff.
inout [7:0] reg_a,
inout [7:0] reg_b,
inout [7:0] reg_c,
inout [7:0] reg_d,
input [15:0] instruction,

input lsu_en,
output lsu_done
);

always_comb begin
	
	unique case (instruction[11:10])
		2'b00: assign memory_data_bus = reg_a;
		//2'b01:
		//2'b10:
		//2'b11:
	endcase
end




reg [15:0] tmp;
reg [15:0] addr_reg;
reg [3:0] stage;
reg [7:0] data_bus_tx_reg;

reg memory_write_en;
reg memory_select;

assign memory_address_bus = addr_reg;
assign mem_en = memory_select;
assign write_en = memory_write_en;

assign memory_data_bus = memory_write_en ? data_bus_tx_reg : 'hz;

initial begin
	stage = 0;
	addr_reg = 234;
end

always_ff @(posedge clk) begin
	case (stage)
	
	// Read 16 bits from RAM.
		4'b0000:
		begin
			memory_select <= 1;
			memory_write_en <= 0;
			addr_reg <= 0;
			stage <= stage + 1;
		end
		
		4'b0001:
		begin
			addr_reg <= 1;
			stage <= stage + 1;
		end
		
	// Write 16 bits to RAM.
		4'b0010:
		begin
			addr_reg <= 2;
			stage <= stage + 1;
			memory_write_en <= 1;
		end
		
		4'b0011:
		begin
			addr_reg <= 3;
			stage <= stage + 1;
		end
		
	endcase
end

always @(negedge clk) begin
	case (stage)
	
	// Read 16 bits from RAM.
		4'b0001:
		begin
			tmp[7:0] <= memory_data_bus;
			//stage <= stage + 1;
		end
		
		4'b0010:
		begin
			tmp[15:8] <= memory_data_bus;
			//stage <= stage + 1;
		end
		
	// Write 16 bits to RAM.
		4'b0011:
		begin
			data_bus_tx_reg <= tmp[7:0];
		end
		
		4'b0100:
		begin
			data_bus_tx_reg <= tmp[15:8];
		end
		
		
	endcase
end


endmodule