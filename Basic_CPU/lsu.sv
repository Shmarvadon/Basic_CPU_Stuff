module lsu(
input clk,

// Memory interface stuff.
inout [7:0]  memory_data_bus,
output [15:0] memory_address_bus,
output memory_enable,
output memory_write_enable,

// Backend interface stuff.
output [7:0] regs_input [3:0],
input [7:0] regs_output [3:0],
output [3:0] regs_write_en,
input [15:0] instruction
);

reg [15:0] memory_addr;
reg [7:0] memory_data;
reg memory_write_enable_reg;
reg memory_select;

reg [3:0] reg_write_en_reg;
reg command_given;

// Set reg_write_en_reg to drive regs_write_en if the instruction is a memory one.
assign regs_write_en = instruction[15:14] == 2'b01 ? reg_write_en_reg : 'hz;

// assign memory_data to drive data bus if instruction is a write instruction.
assign memory_data_bus = instruction[15:14] == 2'b01 & instruction[13:12] == 2'b01 ? memory_data : 'hz;

// Assign memory_addr to drive memory_address_bus if instruction is memory one.
assign memory_address_bus = instruction[15:14] == 2'b01 ? memory_addr : 'hz;

// Assign memory write enable to be driven by memory_write_enable_reg if instruction is memory one.
assign memory_write_enable = instruction[15:14] == 2'b01 ? memory_write_enable_reg : 'hz;

// Assign memory_enable to be driven by memory_select if instruction is memory one.
assign memory_enable = instruction[15:14] == 2'b01 ? memory_select : 'hz;

// Setup a 4:1 mux to connect the data bus to the inputs to the regs based on instruction bits.
assign regs_input[0] = command_given & instruction[13:12] == 2'b00 & instruction[11:10] == 0 ? memory_data_bus : 'hz;
assign regs_input[1] = command_given & instruction[13:12] == 2'b00 & instruction[11:10] == 1 ? memory_data_bus : 'hz;
assign regs_input[2] = command_given & instruction[13:12] == 2'b00 & instruction[11:10] == 2 ? memory_data_bus : 'hz;
assign regs_input[3] = command_given & instruction[13:12] == 2'b00 & instruction[11:10] == 3 ? memory_data_bus : 'hz;

initial begin
	memory_addr = 0;
	command_given = 0;
end

always @(posedge clk) begin
	
	// If the instruction is a load instruction.
	if (instruction[15:14] == 2'b01) begin
	
		case (command_given)
		
		// Command not given yet.
		0:
			begin
				// Set the address & enable memory.
				memory_addr <= instruction[9:0];
				memory_select <= 1;
				
				// Set read or write mode.
				case (instruction[13:12])
					
					// Read mode.
					2'b00: 
						begin
						
						// Give the command to memory & mark the command as given.
						memory_write_enable_reg <= 0;
						command_given <= 1;
						
						// Tell the register to clock in data at the next positive edge.
						case (instruction[11:10])
							1:	reg_write_en_reg <= 4'b0001;
							2: reg_write_en_reg <= 4'b0010;
							3: reg_write_en_reg <= 4'b0100;
							4: reg_write_en_reg <= 4'b1000;
						endcase
						
						end
					
					// Write mode.
					2'b01: 
						begin
							
							// Present write enable & data values on the bus.
							memory_write_enable_reg <= 1;
							memory_data <= regs_output[instruction[11:10]];
							command_given <= 1;
		
						end
				endcase
			end
			
		// Command has been given.
		1:
			begin
			
				// Read from memory into register (register wont actually read anything unless in read mode).
				//regs_input[instruction[11:10]] = memory_data_bus;
				
				// Set command given back to 0.
				command_given <= 0;
				
				// Put deselect the memory.
				memory_data <= 0;
				memory_write_enable_reg <= 0;
				memory_select <= 0;
				
			end
		endcase
	end
end

endmodule