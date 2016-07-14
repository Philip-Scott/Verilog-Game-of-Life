`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:00:13 05/06/2016 
// Design Name: 
// Module Name:    RAM_GoF 
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
module RAM_GoF(
    input Data_i,
    input [8:0] Address_i,
    input w_e_i,
	 input clk_50MHz_i,
    output Data_o,
    output reg [7:0] Neigh_o
    );
	 
reg Locations[299:0];

wire [8:0] arriba_izq = Address_i-16;
wire [8:0] arriba = Address_i-1;
wire [8:0] arriba_der = Address_i+14;
wire [8:0] izquierda = Address_i-15;
wire [8:0] derecha = Address_i+15;
wire [8:0] abajo_izq = Address_i-14;
wire [8:0] abajo = Address_i+1;
wire [8:0] abajo_der = Address_i+16;

always @(posedge clk_50MHz_i)
begin
	if (w_e_i==1) 		// Escribe cuando we=1
		Locations[Address_i]<=Data_i;
end

assign Data_o=Locations[Address_i];

always@(arriba_izq,arriba,arriba_der,izquierda,derecha,abajo_izq,abajo,abajo_der,Address_i,Neigh_o,
Locations[0],Locations[1],Locations[2],Locations[3],Locations[4],Locations[5],Locations[6],Locations[7],Locations[8],Locations[9],Locations[10],Locations[11],Locations[12],Locations[13],Locations[14],Locations[15],
Locations[16],Locations[17],Locations[18],Locations[19],Locations[20],Locations[21],Locations[22],Locations[23],Locations[24],Locations[25],Locations[26],Locations[27],Locations[28],Locations[29],Locations[30],
Locations[31],Locations[32],Locations[33],Locations[34],Locations[35],Locations[36],Locations[37],Locations[38],Locations[39],Locations[40],Locations[41],Locations[42],Locations[43],Locations[44],Locations[45],
Locations[46],Locations[47],Locations[48],Locations[49],Locations[50],Locations[51],Locations[52],Locations[53],Locations[54],Locations[55],Locations[56],Locations[57],Locations[58],Locations[59],Locations[60],
Locations[61],Locations[62],Locations[63],Locations[64],Locations[65],Locations[66],Locations[67],Locations[68],Locations[69],Locations[70],Locations[71],Locations[72],Locations[73],Locations[74],Locations[75],
Locations[76],Locations[77],Locations[78],Locations[79],Locations[80],Locations[81],Locations[82],Locations[83],Locations[84],Locations[85],Locations[86],Locations[87],Locations[88],Locations[89],Locations[90],
Locations[91],Locations[92],Locations[93],Locations[94],Locations[95],Locations[96],Locations[97],Locations[98],Locations[99],Locations[100],Locations[101],Locations[102],Locations[103],Locations[104],Locations[105],
Locations[106],Locations[107],Locations[108],Locations[109],Locations[110],Locations[111],Locations[112],Locations[113],Locations[114],Locations[115],Locations[116],Locations[117],Locations[118],Locations[119],Locations[120],
Locations[121],Locations[122],Locations[123],Locations[124],Locations[125],Locations[126],Locations[127],Locations[128],Locations[129],Locations[130],Locations[131],Locations[132],Locations[133],Locations[134],Locations[135],
Locations[136],Locations[137],Locations[138],Locations[139],Locations[140],Locations[141],Locations[142],Locations[143],Locations[144],Locations[145],Locations[146],Locations[147],Locations[148],Locations[149],Locations[150],
Locations[151],Locations[152],Locations[153],Locations[154],Locations[155],Locations[156],Locations[157],Locations[158],Locations[159],Locations[160],Locations[161],Locations[162],Locations[163],Locations[164],Locations[165],
Locations[166],Locations[167],Locations[168],Locations[169],Locations[170],Locations[171],Locations[172],Locations[173],Locations[174],Locations[175],Locations[176],Locations[177],Locations[178],Locations[179],Locations[180],
Locations[181],Locations[182],Locations[183],Locations[184],Locations[185],Locations[186],Locations[187],Locations[188],Locations[189],Locations[190],Locations[191],Locations[192],Locations[193],Locations[194],Locations[195],
Locations[196],Locations[197],Locations[198],Locations[199],Locations[200],Locations[201],Locations[202],Locations[203],Locations[204],Locations[205],Locations[206],Locations[207],Locations[208],Locations[209],Locations[210],
Locations[211],Locations[212],Locations[213],Locations[214],Locations[215],Locations[216],Locations[217],Locations[218],Locations[219],Locations[220],Locations[221],Locations[222],Locations[223],Locations[224],Locations[225],
Locations[226],Locations[227],Locations[228],Locations[229],Locations[230],Locations[231],Locations[232],Locations[233],Locations[234],Locations[235],Locations[236],Locations[237],Locations[238],Locations[239],Locations[240],
Locations[241],Locations[242],Locations[243],Locations[244],Locations[245],Locations[246],Locations[247],Locations[248],Locations[249],Locations[250],Locations[251],Locations[252],Locations[253],Locations[254],Locations[255],
Locations[256],Locations[257],Locations[258],Locations[259],Locations[260],Locations[261],Locations[262],Locations[263],Locations[264],Locations[265],Locations[266],Locations[267],Locations[268],Locations[269],Locations[270],
Locations[271],Locations[272],Locations[273],Locations[274],Locations[275],Locations[276],Locations[277],Locations[278],Locations[279],Locations[280],Locations[281],Locations[282],Locations[283],Locations[284],Locations[285],
Locations[286],Locations[287],Locations[288],Locations[289],Locations[290],Locations[291],Locations[292],Locations[293],Locations[294],Locations[295],Locations[296],Locations[297],Locations[298],Locations[299])
begin
if (Address_i == 0)
	Neigh_o <= {{4{1'b0}},Locations[derecha],1'b0,Locations[abajo],Locations[abajo_der]};
else if (Address_i == 15 || Address_i == 30 || Address_i == 45 || Address_i == 60 || Address_i == 75 || Address_i == 90 || Address_i == 105 || Address_i == 120 || Address_i == 135 || Address_i == 150 || Address_i == 165 || Address_i == 180 || Address_i == 195 || Address_i == 210 || Address_i == 225 || Address_i == 240 || Address_i == 255 || Address_i == 270)
	Neigh_o <= {{3{1'b0}},Locations[izquierda],Locations[derecha],Locations[abajo_izq],Locations[abajo],Locations[abajo_der]};
else if (Address_i > 0 && Address_i < 15)
	Neigh_o <= {1'b0,Locations[arriba],Locations[arriba_der],1'b0,Locations[derecha],1'b0,Locations[abajo],Locations[abajo_der]};
else if (Address_i > 285 && Address_i < 300)
	Neigh_o <= {Locations[arriba_izq],Locations[arriba],1'b0,Locations[izquierda],1'b0,Locations[abajo_izq],Locations[abajo],1'b0};
else if (Address_i == 29 || Address_i == 44 || Address_i == 59 || Address_i == 74 || Address_i == 89 || Address_i == 104 || Address_i == 119 || Address_i == 134 || Address_i == 149 || Address_i == 164 || Address_i == 179 || Address_i == 194 || Address_i == 209 || Address_i == 224 || Address_i == 239 || Address_i == 254 || Address_i == 269 || Address_i == 284)
	Neigh_o <= {Locations[arriba_izq],Locations[arriba],Locations[arriba_der],Locations[izquierda],Locations[derecha],{3{1'b0}}};
else if (Address_i == 14)
	Neigh_o <= {1'b0,Locations[arriba],Locations[arriba_der],1'b0,Locations[derecha],{3{1'b0}}};
else if (Address_i == 285)
	Neigh_o <= {{3{1'b0}},Locations[izquierda],1'b0,Locations[abajo_izq],Locations[abajo],1'b0};
else if (Address_i == 299)
	Neigh_o <= {Locations[arriba_izq],Locations[arriba],1'b0,Locations[izquierda],{4{1'b0}}};
else
	Neigh_o <= 8'b0;
end

endmodule
