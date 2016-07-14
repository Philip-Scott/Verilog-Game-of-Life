`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:07:37 05/07/2016 
// Design Name: 
// Module Name:    top_GoF 
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
module top_GoF(
    input clk_50MHz_i,
    input rst_async_la_i,
	 input next_i,
	 input preset_i,
	 input [7:0] switches,
	 output [2:0] red_out,
	 output [2:0] green_out,
	 output [1:0] blue_out,
	 output horiz_sync_out,
	 output vert_sync_out
    );

wire next;
wire [19:0] to_vga;
wire [3:0] vga_address;

top_debouncer debu (
	.sw_sucia_i(next_i),
	.clk_50MHz_i(clk_50MHz_i),
	.rst_async_la_i(~rst_async_la_i),
	.sw_limpia_o(),
	.one_shot_o(next)
);

wire [19:0] controler_data;
wire [19:0] controler_data_o;
wire [3:0] controler_addr;
wire ram_we;
RAM_GoL ram (
	.controler_data_i(preset_i? {{8{1'b0}},switches[7:4],{8{1'b0}}} : controler_data_o),
	.controler_address_i(preset_i? switches[3:0] : controler_addr),
	.display_address_i(vga_address),
	.we_i(preset_i | ram_we),
	.clk(clk_50MHz_i),
	.controler_data_o(controler_data),
	.display_data_o(to_vga)
);

life_controler god(
	.row_from_ram_i(controler_data),
	.next_i(next),
	.clk_50MHz_i(clk_50MHz_i),
	
	.row_to_ram_o(controler_data_o),
	.ram_addr_o(controler_addr),
	.ram_we_o(ram_we)
);

VGA_ctrler vga (
	.clk_50(clk_50MHz_i),
	.fila_o(vga_address),
	.valores(to_vga),
	.red_out(red_out),
	.green_out(green_out),
	.blue_out(blue_out),
	.horiz_sync_out(horiz_sync_out),
	.vert_sync_out(vert_sync_out)
);

endmodule
