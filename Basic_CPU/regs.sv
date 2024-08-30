module regs(
input clk,
input [7:0] regs_in [3:0],
output [7:0] regs_out [3:0],
input [3:0] write_en
);

reg [7:0] reg_a;
reg [7:0] reg_b;
reg [7:0] reg_c;
reg [7:0] reg_d;

// Assign the regs to output to the wire.
assign regs_out[0] = reg_a;
assign regs_out[1] = reg_b;
assign regs_out[2] = reg_c;
assign regs_out[3] = reg_d;

initial begin
	reg_a = 2;
	reg_b = 4;
	reg_c = 8;
	reg_d = 16;
end

// On each clock edge.
always @(posedge clk) begin
	unique case (write_en)
		default: begin end
		4'b0001: reg_a <= regs_in[0];
		4'b0010: reg_b <= regs_in[1];
		4'b0100: reg_c <= regs_in[2];
		4'b1000: reg_d <= regs_in[3];
	endcase
end

endmodule
