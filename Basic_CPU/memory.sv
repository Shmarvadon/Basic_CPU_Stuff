module memory(
input clk,
input [15:0] addr,
inout [7:0] data,
input write_enable,
input chip_select);

reg [7:0] memory_array [65536:0];

initial begin

	// Store register A contents to 0x08
	memory_array[4096] = 8'b00001000;
	memory_array[4097] = 8'b01100000;
	
	// Load value at address 0x08 into register B
	memory_array[4098] = 8'b00001000;
	memory_array[4099] = 8'b01001000;
	
	// Add registers A & B
	memory_array[4100] = 8'b00000000;
	memory_array[4101] = 8'b00000010;
	
	// Add 16 to register A
	memory_array[4102] = 8'b00010000;
	memory_array[4103] = 8'b00000100;
	
	// XOR register B
	memory_array[4104] = 8'b01000000;
	memory_array[4105] = 8'b00110001;
	
	// Jump back to instruction 0.
	memory_array[4106] = 8'b00000000;
	memory_array[4107] = 8'b10010000;
	
end

always @(posedge clk) begin
	if (write_enable)
		memory_array[addr] <= data;
	
	$display("Write memory value: %b", memory_array[8]);
end

assign data = chip_select & !write_enable ? memory_array[addr] : 'hz;

endmodule