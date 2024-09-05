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
reg [3:0] regs_we_reg;
reg [7:0] result;


// READ THIS https://electronics.stackexchange.com/questions/400034/easy-way-to-define-wire-output-multiplexers-in-verilog


// Set regs_we_reg to drive regs_we if ALU instruction.

assign regs_we = inst[15:14] == 2'b00 & alu_en ? regs_we_reg : 'hz;

// Select operand a register.
assign op_a = inst[15:14] == 2'b00 ? regs_oup[inst[9:8]] : 'hz;

// Select operand b register if needed.
assign op_b = op_b_assign_function(inst);

function [7:0] op_b_assign_function(input [15:0] inst);
	case (inst[15:10])
	
		// ADD A, B
		6'b000000: op_b_assign_function = regs_oup[inst[7:6]];
		// ADD k, A
		6'b000001: op_b_assign_function = inst[7:0];
		// SUB A, B
		6'b000010:	op_b_assign_function = regs_oup[inst[7:6]];
		// SUB k, A
		6'b000011:	op_b_assign_function = inst[7:0];
		// CMP A, B
		6'b000100:	op_b_assign_function = regs_oup[inst[7:6]];
		// CMP k, A
		6'b000101:	op_b_assign_function = inst[7:0];
		// RLS A, B
		6'b000110:	op_b_assign_function = regs_oup[inst[7:6]];
		// RRS A, B
		6'b000111:	op_b_assign_function = regs_oup[inst[7:6]];
		// AND A, B
		6'b001000:	op_b_assign_function = regs_oup[inst[7:6]];
		// AND k, A
		6'b001001:	op_b_assign_function = inst[7:0];
		// IOR A, B
		6'b001010:	op_b_assign_function = regs_oup[inst[7:6]];
		// IOR k, A
		6'b001011:	op_b_assign_function = inst[7:0];
		// XOR A, B
		6'b001100:	op_b_assign_function = regs_oup[inst[7:6]];
		// XOR k, A
		6'b001101:	op_b_assign_function = inst[7:0];
		// NOT A, B
		6'b001111:	op_b_assign_function = regs_oup[inst[7:6]];
		// NOT k, A
		6'b001111:	op_b_assign_function = inst[7:0];
		
	endcase
endfunction

// Select the destination if needed.
assign regs_inp[0] = get_oup_reg(inst) == 3'b000  & alu_en ? result : 'hz;
assign regs_inp[1] = get_oup_reg(inst) == 3'b001  & alu_en ? result : 'hz;
assign regs_inp[2] = get_oup_reg(inst) == 3'b010  & alu_en ? result : 'hz;
assign regs_inp[3] = get_oup_reg(inst) == 3'b011  & alu_en ? result : 'hz;

function [2:0] get_oup_reg(input [15:0] inst);
	case (inst[15:10])
		
		// ADD A, B
		6'b000000:	get_oup_reg = inst[7:6];
		// ADD k, A
		6'b000001:	get_oup_reg[1:0] = inst[9:8];
		// SUB A, B
		6'b000010:	get_oup_reg[1:0] = inst[7:6];
		// SUB k, A
		6'b000011:	get_oup_reg[1:0] = inst[9:8];
		// CMP A, B
		6'b000100:	get_oup_reg = 3'b100;
		// CMP k, A
		6'b000101:	get_oup_reg = 3'b100;
		// RLS A, B
		6'b000110:	get_oup_reg[1:0] = inst[7:6];
		// RRS A, B
		6'b000111:	get_oup_reg[1:0] = inst[7:6];
		// AND A, B
		6'b001000:	get_oup_reg[1:0] = inst[7:6];
		// AND k, A
		6'b001001:	get_oup_reg[1:0] = inst[9:8];
		// IOR A, B
		6'b001010:	get_oup_reg[1:0] = inst[7:6];
		// IOR k, A
		6'b001011:	get_oup_reg[1:0] = inst[9:8];
		// XOR A, B
		6'b001100:	get_oup_reg[1:0] = inst[7:6];
		// XOR k, A
		6'b001101:	get_oup_reg[1:0] = inst[9:8];
		// NOT A, B
		6'b001111:	get_oup_reg[1:0] = inst[7:6];
		// NOT k, A
		6'b001111:	get_oup_reg[1:0] = inst[9:8];
		
		default: get_oup_reg = 3'b100;
	endcase
endfunction

always @ (inst) begin

	// If the instruction is an ALU instruction.
	if (inst[15:14] == 2'b00) begin

		// Setup the Registers ready to recieve the result.
		case(get_oup_reg(inst))
			0:	regs_we_reg <= 4'b0001;
			1: regs_we_reg <= 4'b0010;
			2: regs_we_reg <= 4'b0100;
			3: regs_we_reg <= 4'b1000;
		endcase
			
		// Check which instruction it is.	
		case (inst[13:10]) 
			
			// If instruction is ADD A, B
			4'b0000: result <= op_a + op_b;
			// If instruction is ADD k, A
			4'b0001: result <= op_a + op_b;
			// If instruction is SUB A, B
			4'b0010: result <= op_b - op_a;
			// if instruction is SUB k, A
			4'b0011: result <= op_b - op_a;
			
			
			// if instruction is RLS A, B
			4'b0110: result <= {op_a[6:0], 0};
			// if instruction is RRS A, B
			4'b0111: result <= {0, op_a[7:1]};
			// if instruction is AND A, B
			4'b1000: result <= op_a & op_b;
			// if instruction is AND k, A
			4'b1001: result <= op_a & op_b;
			// if instruction is IOR A, B
			4'b1010: result <= op_a | op_b;
			// if instruction is IOR k, A
			4'b1011: result <= op_a | op_b;
			// if instruction is XOR A, B
			4'b1100: result <= op_a ^ op_b;
			// if instruction is XOR k, A
			4'b1101: result <= op_a ^ op_b;
			// if instruction is NOT A, B
			4'b1110: result <= !op_a;
			// if instruction is NOT k, A
			4'b1111: result <= !op_a;
		endcase
	end
end
endmodule


