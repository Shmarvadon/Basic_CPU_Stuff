module alu (
input alu_en,

// Register Interface stuff
output [7:0] regs_inp [3:0],
input  [7:0] regs_oup [3:0],
output [3:0] regs_we,

input [15:0] inst
);

wire [7:0] op_a;
wire [7:0] op_b;
wire [7:0] dst;
reg [3:0] regs_we_reg;
reg [7:0] result;

assign dst = result;
// Set regs_we_reg to drive regs_we if ALU instruction.

assign regs_we = inst[15:14] == 2'b00 ? regs_we_reg : 'hz;

// Select operand a register.
assign op_a = inst[15:14] == 2'b00 ? regs_oup[inst[9:8]] : 'hz;

// Select operand b register if needed.
assign op_b = inst[15:14] == 2'b00 & inst[10] == 0 & alu_en ? regs_oup[inst[7:6]] : (inst[15:10] == 6'b000111 & alu_en ? regs_oup[inst[7:6]] : 'hz);

// Select the destination if needed.
assign dst = inst[15:14] == 2'b00 & inst[10] == 0 & alu_en ? regs_inp[inst[7:6]] : (inst[15:10] == 6'b000111 & alu_en ? regs_inp[inst[7:6]] : 'hz);


always @ (inst) begin

	// If the instruction is an ALU instruction.
	if (inst[15:14] == 2'b00) begin
			case (inst[13:10]) 
				
				// If instruction is ADD A, B.
				4'b0000: result <= op_a + op_b;
			endcase
	end
end
endmodule
