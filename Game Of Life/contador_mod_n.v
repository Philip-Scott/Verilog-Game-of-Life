`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:30:46 03/31/2016 
// Design Name: 
// Module Name:    contador_mod_n 
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
module contador_mod_n
#(parameter DW=4, N=10)
(
	input enable_i,
	input clk_50MHz_i,
	input rst_async_la_i,
	output reg [DW-1:0] conteo_salida_o,
	output enable_out
);
reg [DW-1:0] entrada_reg_PIPO;
reg salida_comparador;
assign enable_out=salida_comparador&enable_i;
always@*
begin
	salida_comparador <= conteo_salida_o >= (N-1);
	if(salida_comparador)
		entrada_reg_PIPO<={DW{1'b0}};
	else
		entrada_reg_PIPO<= conteo_salida_o+1'b1;
end
always@(posedge clk_50MHz_i, negedge rst_async_la_i)
begin
	if(!rst_async_la_i)
		conteo_salida_o<={DW{1'b0}};
	else if(enable_i)
		conteo_salida_o<=entrada_reg_PIPO;
end

endmodule 
