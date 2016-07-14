`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:32:47 05/08/2016 
// Design Name: 
// Module Name:    FSM_LifeControler 
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
module LifeFSM(
    input next_i,
    input clk_50MHz_i,
    input rst_async_la_i,
    input count_done_i,
    output reg ram_we_o,
    output reg ss_we_o,
    output reg ss_rst_o,
    output reg subtract_addr_o,
    output reg addr_count_en_o
    );

localparam IDLE = 2'b00, READ = 2'b01, WRITE = 2'b10, WAIT = 2'b11;

reg [1:0] Edo_Actual;
reg [1:0] Edo_siguiente;
//Cto combinacional del siguete
always@*
begin
case(Edo_Actual)
IDLE:
	if(next_i)
		Edo_siguiente <= READ;
	else
		Edo_siguiente <= IDLE;
READ:
	if(clk_50MHz_i)
		Edo_siguiente <= WRITE;
	else
		Edo_siguiente <= READ;
WAIT:
	if(clk_50MHz_i)
		Edo_siguiente <= READ;
	else
		Edo_siguiente <= WAIT;
		
WRITE:
	if(clk_50MHz_i & count_done_i)
		Edo_siguiente <= IDLE;
	else if(clk_50MHz_i & ~count_done_i)
		Edo_siguiente <= WAIT;
	else
		Edo_siguiente <= WRITE;
default:
		Edo_siguiente <= IDLE;
	endcase
end

always@(posedge clk_50MHz_i, negedge rst_async_la_i)
if(!rst_async_la_i)
	Edo_Actual <= IDLE;
else
	Edo_Actual <= Edo_siguiente;
	
always@*
begin
case(Edo_Actual)
IDLE:
	begin
		ram_we_o <= 0;
		ss_we_o  <= 0;
		ss_rst_o  <= 0;
      subtract_addr_o <= 0;
		addr_count_en_o <= 0;
	end
READ:
	begin
		ram_we_o <= 0;
		ss_we_o  <= 1;
		ss_rst_o  <= 1;
      subtract_addr_o <= 0;
		addr_count_en_o <= 0;
	end
WAIT:
	begin
		ram_we_o <= 0;
		ss_we_o  <= 0;
		ss_rst_o  <= 1;
      subtract_addr_o <= 0;
		addr_count_en_o <= 1;
	end

WRITE:
	begin
		ram_we_o <= 1;
		ss_we_o  <= 0;
		ss_rst_o  <= 1;
      subtract_addr_o <= 1;
		addr_count_en_o <= 0;
	end

	endcase
end

endmodule

