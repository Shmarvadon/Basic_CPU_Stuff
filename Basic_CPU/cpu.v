module cpu(
input [15:0] data_bus,
output[7:0] address_bus,
input clk
);

reg [7:0] reg_a;
reg [7:0] reg_b;
reg [7:0] reg_c;
reg [7:0] reg_d;

reg [7:0] program_counter;

initial
begin
	program_counter = 0;
	reg_a = 0;
	reg_b = 0;
	reg_c = 0;
	reg_d = 0;
end

always @(posedge clk)
begin
	
end


endmodule