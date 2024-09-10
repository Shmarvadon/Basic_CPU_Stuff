module program_flow_control_unit(
input pfcu_en,

// Backend interfacing stuff
input [7:0] alu_status,
output [11:0] pc_inp,
output pc_we,

input [15:0] inst
);

reg [11:0] program_counter_new_val;
reg pc_we_reg;
reg [11:0] pc_stack [7:0]; // Make this a shift reg.

// Assign the program counter input wire to be driven by this module if pfcu_en is true.
assign pc_inp = pfcu_en ? program_counter_new_val : 'hz;

// Assign the program counter write enable to be driven by pc_we_reg if pfcu_en is true.
assign pc_we = pfcu_en ? pc_we_reg : 'hz;


initial begin
	pc_we_reg = 0;
	program_counter_new_val = 0;
end


always @ (inst) begin
	// If the instruction is a PFCU instruction.
	if (inst[15:14] == 2'b10) begin
	
		case (inst[13:12])
	
			// JMP k
			2'b00: 
				begin
					pc_we_reg <= 1;
					program_counter_new_val <= inst[11:0];
				end
				
			// JIZ k
			2'b01: 
				begin
					if (alu_status[0] == 1) begin
						pc_we_reg <= 1;
						program_counter_new_val <= inst[11:0];
					end
					else pc_we_reg <= 0;
				end
		endcase
	end
	else begin
		pc_we_reg <= 0;
	end
end

endmodule