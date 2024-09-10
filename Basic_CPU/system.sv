`timescale 1ns / 100ps

module system(
input clk);

wire [15:0] addr;
wire [7:0] bussy;
wire write_enable;
wire chip_select;

memory mem(clk, addr, bussy, write_enable, chip_select);

core cpu(clk, bussy, addr, write_enable, chip_select);


endmodule