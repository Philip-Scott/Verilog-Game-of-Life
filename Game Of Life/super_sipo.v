`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:53:13 03/29/2016 
// Design Name: 
// Module Name:    registro_SIPO 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Un registro SIPO (serial in, parallel out) paramétrico, el parámetro DW determina el
//                      ancho de palabra de salida, así como el número de FF-D en la instancia.
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

//20 x 3

module super_sipo (
    input [19:0] D_i,
    input enable_i,
    input clk_50MHz_i,
    input rst_async_la_i,
    output [59:0] Q_o
    );

reg [59:0] temp; 

always@(posedge clk_50MHz_i, negedge rst_async_la_i) begin
	if (!rst_async_la_i) 
		temp <= 'b0;
	else if (enable_i) begin 
		temp[19:0] <= temp[39:20];
		temp[39:20] <= temp[59:40];
		temp[59:40] <= D_i;
	end
end

assign Q_o = temp;

endmodule
