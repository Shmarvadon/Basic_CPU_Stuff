module memory(
input clk,
input [15:0] addr,
inout [7:0] data,
input write_enable,
input chip_select);

reg [7:0] memory_array [65536:0];
reg [7:0] temp_data;

always @(posedge clk) begin
	if (write_enable)
		memory_array[addr] <= data;
		//$display("Write memory value: %b", data);
end

always @ (addr or write_enable) begin
	if (!write_enable)
		temp_data <= memory_array[addr];
end

assign data = chip_select & !write_enable ? temp_data : 'hz;

endmodule