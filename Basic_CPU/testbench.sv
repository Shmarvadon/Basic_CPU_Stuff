`timescale 1ns / 100ps


// CPU testbench.
module testbench;

reg clk;


system sys(clk);

// Setup UUT(s)
initial 
begin
	clk = 0;
	
	// Set first 2 memory locations to value of 64.
	//sys.mem.memory_array [0] = 64;
	//sys.mem.memory_array [1] = 32;
end


// Modulates the clock.
always
begin
	#10 clk <= ~clk;
	//$display("Read reg value: %b", sys.lsyou.tmp);
	$display("Write mempry value: %b%b", sys.mem.memory_array[2], sys.mem.memory_array[3]);
end

endmodule







/*
// memory testbench.
module testbench;

reg clk;
reg  [7:0]  ones;
reg  [7:0]  zeros;
wire [7:0]  bussy;
reg  [7:0]  data_bus_reg;
reg  [15:0] addr;

reg write_enable;
reg chip_select;

assign bussy = data_bus_reg;

memory mem(clk, addr, bussy, write_enable, chip_select);

// Stimulus for UUT.
initial 
begin
	clk = 0;
	ones =  8'b11111111;
	zeros = 8'b00000000;
	addr =  16'b0000000000000001;
	
	write_enable = 0;
	chip_select = 1;
end


// Modulates the clock.
always
begin
	#10 clk <= ~clk;
end

initial
begin

// Initial delay then write 0xFF to 0x0001
	#40;
	data_bus_reg <= ones;
	write_enable = 1;
	#20;
	write_enable = 0;
	$display("Bus value %d written to address %h", bussy, addr);

// Delay a bit then write 0x00 to 0x0010
	#40;
	addr = 16'b0000000000100000;
	data_bus_reg <= zeros;
	write_enable = 1;
	#20;
	write_enable = 0;
	
// Delay a bit then read from 0x0001
	#40;
	addr = 16'b0000000000000001;
	
	
end

endmodule
*/





// ALU testbench.
/*
module testbench;

reg clk;
reg [7:0] operand_a;
reg [7:0] operand_b;
wire [7:0] result;
reg [3:0] instr;

alu uut(operand_a,operand_b,result,instr,clk);

// Stimulus for UUT.
initial 
begin
	clk = 0;
	operand_a = 8'b00000001;
	operand_b = 8'b00000001;
	instr = 4'b0000;
end


// Modulates the clock.
always
begin
	#10 clk <= ~clk;
end





endmodule
*/