`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:56:19 04/12/2016 
// Design Name: 
// Module Name:    top_debouncer 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Debouncer, para quitar ruido de la señal de un boton al ser presinado
//						los primeros 30 ms después de su presión
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module top_debouncer(
    input sw_sucia_i,
    input clk_50MHz_i,
    input rst_async_la_i,
    output sw_limpia_o,
    output one_shot_o
    );

wire enable_cont2fsm, enable_fsm2cont;

FSM fsm(
	.sw_sucia_i(sw_sucia_i),
	.clk_50MHz_i(clk_50MHz_i),
	.rst_async_la_i(rst_async_la_i),
	.to_30ms_i(enable_cont2fsm),
	.sw_limp_o(sw_limpia_o),
	.one_shot_o(one_shot_o),
	.en_cont_o(enable_fsm2cont)
);

contador_mod_n #(.DW(21), .N(4)) cont
(
	.enable_i(enable_fsm2cont),
	.clk_50MHz_i(clk_50MHz_i),
	.rst_async_la_i(rst_async_la_i),
	.conteo_salida_o(),
	.enable_out(enable_cont2fsm)
);

endmodule
