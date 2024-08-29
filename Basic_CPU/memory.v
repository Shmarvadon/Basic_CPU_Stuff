module memory(
input clk,
input [15:0] addr,
inout [7:0] data,
input write_enable,
input chip_select);

reg [7:0] memory [65536:0];
reg [7:0] temp_data;

always @(posedge clk) begin
	if (write_enable)
		memory[addr] <= data;
end

always @ (posedge clk) begin
	if (!write_enable)
		temp_data <= memory[addr];
end

assign data = chip_select & !write_enable ? temp_data : 'hz;

endmodule