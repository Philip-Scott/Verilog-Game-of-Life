`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:11:07 05/07/2016 
// Design Name: 
// Module Name:    reglas 
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
module reglas(
    input [7:0] neigh_i,
    input current_state_i,
    output next_state_o
    );

wire [3:0] suma = neigh_i[7] + neigh_i[6] + neigh_i[5] + neigh_i[4] + 
						neigh_i[3] + neigh_i[2] + neigh_i[1] + neigh_i[0];

assign next_state_o = (suma == 2 && current_state_i) || suma == 3;

endmodule
