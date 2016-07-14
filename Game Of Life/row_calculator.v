`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:05:23 05/08/2016 
// Design Name: 
// Module Name:    row_calculator 
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
module row_calculator(
	input [19:0] arriba,
	input [19:0] medio,
	input [19:0] abajo,
	output [19:0] new
    );
	 
reglas regla1(.neigh_i({       0, arriba[0], arriba[1],         0, medio[1],       0, abajo[0], abajo[1]}),          .current_state_i(medio[0]), .next_state_o(new[0]));
reglas regla2(.neigh_i({arriba[0], arriba[1], arriba[2], medio[0], medio[2], abajo[0], abajo[1], abajo[2]}),         .current_state_i(medio[1]), .next_state_o(new[1]));
reglas regla3(.neigh_i({arriba[1], arriba[2], arriba[3], medio[1], medio[3], abajo[1], abajo[2], abajo[3]}),         .current_state_i(medio[2]), .next_state_o(new[2]));
reglas regla4(.neigh_i({arriba[2], arriba[3], arriba[4], medio[2], medio[4], abajo[2], abajo[3], abajo[4]}),         .current_state_i(medio[3]), .next_state_o(new[3]));
reglas regla5(.neigh_i({arriba[3], arriba[4], arriba[5], medio[3], medio[5], abajo[3], abajo[4], abajo[5]}),         .current_state_i(medio[4]), .next_state_o(new[4]));
reglas regla6(.neigh_i({arriba[4], arriba[5], arriba[6], medio[4], medio[6], abajo[4], abajo[5], abajo[6]}),         .current_state_i(medio[5]), .next_state_o(new[5]));
reglas regla7(.neigh_i({arriba[5], arriba[6], arriba[7], medio[5], medio[7], abajo[5], abajo[6], abajo[7]}),         .current_state_i(medio[6]), .next_state_o(new[6]));
reglas regla8(.neigh_i({arriba[6], arriba[7], arriba[8], medio[6], medio[8], abajo[6], abajo[7], abajo[8]}),         .current_state_i(medio[7]), .next_state_o(new[7]));
reglas regla9(.neigh_i({arriba[7], arriba[8], arriba[9], medio[7], medio[9], abajo[7], abajo[8], abajo[9]}),         .current_state_i(medio[8]), .next_state_o(new[8]));
reglas regl10(.neigh_i({arriba[8], arriba[9], arriba[10], medio[8], medio[10], abajo[8], abajo[9], abajo[10]}),      .current_state_i(medio[9]), .next_state_o(new[9]));
reglas regl11(.neigh_i({arriba[9], arriba[10], arriba[11], medio[9], medio[11], abajo[9], abajo[10], abajo[11]}),    .current_state_i(medio[10]), .next_state_o(new[10]));
reglas regl12(.neigh_i({arriba[10], arriba[11], arriba[12], medio[10], medio[12], abajo[10], abajo[11], abajo[12]}), .current_state_i(medio[11]), .next_state_o(new[11]));
reglas regl13(.neigh_i({arriba[11], arriba[12], arriba[13], medio[11], medio[13], abajo[11], abajo[12], abajo[13]}), .current_state_i(medio[12]), .next_state_o(new[12]));
reglas regl14(.neigh_i({arriba[12], arriba[13], arriba[14], medio[12], medio[14], abajo[12], abajo[13], abajo[14]}), .current_state_i(medio[13]), .next_state_o(new[13]));
reglas regl115(.neigh_i({arriba[13], arriba[14], arriba[15], medio[13], medio[15], abajo[13], abajo[14], abajo[15]}), .current_state_i(medio[14]), .next_state_o(new[14]));
reglas regl16(.neigh_i({arriba[14], arriba[15], arriba[16], medio[14], medio[16], abajo[14], abajo[15], abajo[16]}), .current_state_i(medio[15]), .next_state_o(new[15]));
reglas regl17(.neigh_i({arriba[15], arriba[16], arriba[17], medio[15], medio[17], abajo[15], abajo[16], abajo[17]}), .current_state_i(medio[16]), .next_state_o(new[16]));
reglas regl18(.neigh_i({arriba[16], arriba[17], arriba[18], medio[16], medio[18], abajo[16], abajo[17], abajo[18]}), .current_state_i(medio[17]), .next_state_o(new[17]));
reglas regl19(.neigh_i({arriba[17], arriba[18], arriba[19], medio[17], medio[19], abajo[17], abajo[18], abajo[19]}), .current_state_i(medio[18]), .next_state_o(new[18]));
reglas regl20(.neigh_i({arriba[18], arriba[19], 0         , medio[18],         0, abajo[18], abajo[19], 0}),         .current_state_i(medio[19]), .next_state_o(new[19]));

endmodule
