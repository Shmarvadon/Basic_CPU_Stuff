module alu ( 
input  [7:0] operand_a, 
input  [7:0] operand_b, 
output  [7:0] result_out, 
input  [3:0] instr, 
input  clk );

reg [7:0] result;
assign result_out = result;
	
always @(posedge clk)
	begin
			case (instr)
			4'b0000 : result = operand_a + operand_b;
			4'b0010 : result = operand_b - operand_a;
		endcase
	end

endmodule
