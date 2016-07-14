`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:23:29 04/12/2016 
// Design Name: 
// Module Name:    FSM 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Máquina de estado finito (FSM) del debouncer
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module FSM(
    input sw_sucia_i,
    input clk_50MHz_i,
    input rst_async_la_i,
    input to_30ms_i,
    output reg sw_limp_o,
    output reg one_shot_o,
    output reg en_cont_o
    );

localparam BAJO = 2'b00, DLY1 = 2'b01, ALTO = 2'b10, DLY2 = 2'b11;

reg [1:0] Edo_Actual;
reg [1:0] Edo_siguiente;
//Cto combinacional del siguete
always@*
begin
case(Edo_Actual)
BAJO:
	if(sw_sucia_i==1'b0)
		Edo_siguiente <= BAJO;
	else
		Edo_siguiente <= DLY1;
DLY1:
	if(to_30ms_i==1'b0)
		Edo_siguiente <= DLY1;
	else
		Edo_siguiente <= ALTO;
ALTO:
	if(sw_sucia_i==1'b0)
		Edo_siguiente <= DLY2;
	else
		Edo_siguiente <= ALTO;
DLY2:
	if(to_30ms_i==1'b0)
		Edo_siguiente <= DLY2;
	else
		Edo_siguiente <= BAJO;
default:
		Edo_siguiente <= BAJO;
	endcase
end

always@(posedge clk_50MHz_i, negedge rst_async_la_i)
if(!rst_async_la_i)
	Edo_Actual <= BAJO;
else
	Edo_Actual <= Edo_siguiente;
	
always@*
begin
case(Edo_Actual)
BAJO:
	begin
		sw_limp_o <= 1'b0;
		one_shot_o <= 1'b0;
		en_cont_o <= 1'b0;
	end
DLY1:
	begin
		sw_limp_o <= 1'b0;
		one_shot_o <= to_30ms_i;
		en_cont_o <= 1'b1;
	end
ALTO:
	begin
		sw_limp_o <= 1'b1;
		one_shot_o <= 1'b0;
		en_cont_o <= 1'b0;
	end
DLY2:
	begin
		sw_limp_o <= 1'b1;
		one_shot_o <= 1'b0;
		en_cont_o <= 1'b1;
	end
default:
	begin
		sw_limp_o <= 1'b0;
		one_shot_o <= 1'b0;
		en_cont_o <= 1'b0;
	end
	endcase
end

endmodule
