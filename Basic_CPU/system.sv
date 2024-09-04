`timescale 1ns / 100ps

module system(
input clk);

wire [15:0] addr;
wire [7:0] bussy;
wire write_enable;
wire chip_select;
reg [15:0] instr;

wire [7:0] regs_output [3:0];
wire [7:0] regs_input [3:0];
wire [3:0] reg_write_en;

//regs reggs(clk, regs_input, regs_output, reg_write_en);

memory mem(clk, addr, bussy, write_enable, chip_select);

//lsu lsyou(clk, bussy, addr, chip_select, write_enable, regs_input, regs_output, reg_write_en, instr);

cpu centralprocessingunit(clk, bussy, addr, write_enable, chip_select);

initial begin
	instr <= 16'b0101000000000000;
	#15;
	instr <= 16'b0100010000000000;

end



//cpu seepeeyou(clk, bussy, addr, write_enable, chip_select);

endmodule