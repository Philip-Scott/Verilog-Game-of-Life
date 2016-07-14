`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:20:07 05/08/2016 
// Design Name: 
// Module Name:    life_controler 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module life_controler(
	input [19:0] row_from_ram_i,
	input next_i,
	input clk_50MHz_i,
	
	output [19:0] row_to_ram_o,
	output [3:0] ram_addr_o,
	output ram_we_o
    );

wire rows_calculated_done;
wire enable_super_sipo;
wire kriptonite;
wire add_count_enable;
wire muxear_addr;
LifeFSM life_of_pi (
	.next_i(next_i),
	.clk_50MHz_i(clk_50MHz_i),
	.rst_async_la_i(1),
	.count_done_i(rows_calculated_done),
	.ram_we_o(ram_we_o),
	.ss_we_o(enable_super_sipo),
	.ss_rst_o(kriptonite),
	.subtract_addr_o(muxear_addr), //muxear
	.addr_count_en_o(add_count_enable) 
);

wire [59:0] clarks_poop;
super_sipo clark(
    .D_i(row_from_ram_i),
    .enable_i(enable_super_sipo),
    .clk_50MHz_i(clk_50MHz_i),
    .rst_async_la_i(kriptonite),
    .Q_o(clarks_poop)
);

row_calculator rows(
	.arriba(clarks_poop[19:0]),
	.medio(clarks_poop[39:20]),
	.abajo(clarks_poop[59:40]),
	.new(row_to_ram_o)
);

wire temp_addr;
contador_mod_n #(.DW(4), .N(15)) cont
(
	.enable_i(add_count_enable),
	.clk_50MHz_i(clk_50MHz_i),
	.rst_async_la_i(1),
	.conteo_salida_o(temp_addr),
	.enable_out(rows_calculated_done)
);

assign ram_addr_o = muxear_addr ? temp_addr - 2 : temp_addr - 1;
endmodule
