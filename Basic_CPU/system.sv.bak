module system(
input clk);

wire [15:0] addr;
wire [7:0] bussy;
wire write_enable;
wire chip_select;


memory mem(clk, addr, bussy, write_enable, chip_select);

lsu lsyou(clk, bussy, addr, chip_select, write_enable);


//cpu seepeeyou(clk, bussy, addr, write_enable, chip_select);

endmodule