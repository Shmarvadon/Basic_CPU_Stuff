module memory(
input clk,
input [15:0] addr,
inout [7:0] data,
input write_enable,
input chip_select);

reg [7:0] memory_array [65536:0];
reg [7:0] temp_data;

initial begin

	// Store register a contents to 0x08
	memory_array[0] = 8'b00001000;
	memory_array[1] = 8'b01100000;
	
	// Load value at address 0x08 into register b
	memory_array[2] = 8'b00001000;
	memory_array[3] = 8'b01001000;
	
	// Add registers A & B
	memory_array[4] = 8'b00000000;
	memory_array[5] = 8'b00000010;
	
	// Add registers A & B
	memory_array[6] = 8'b00010000;
	memory_array[7] = 8'b00000100;
	
end

always @(posedge clk) begin
	if (write_enable)
		memory_array[addr] <= data;
		//$display("Write memory value: %b", data);
		
	//if (!write_enable)
		//temp_data <= memory_array[addr];
end

assign data = chip_select & !write_enable ? memory_array[addr] : 'hz;

endmodule