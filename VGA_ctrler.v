// ============================================================
// Title       : VGA controller
// Project     : 
// File        : VGA_ctrler.v
// Description : VGA controller
// Revisions   : 
// ============================================================
// Author      : Carlos Vazquez
// Course      : Disenio Digital
// ============================================================

module VGA_ctrler(
  input            clk_50,		// 50MHz Clock input
  //input      [2:0] red_in,	// Red color input, when generated outside
  //input      [2:0] green_in,// Green color input, when generated outside
  //input      [1:0] blue_in,	// Blue color input, when generated outside
  output [3:0] fila_o,
  input		[19:0] valores,
  output reg [2:0] red_out,	// Red color output, to VGA connector
  output reg [2:0] green_out,	// Green color output, to VGA connector
  output reg [1:0] blue_out,	// Blue color output, to VGA connector
  output reg       horiz_sync_out,	// Horizontal Sync output, to VGA connector
  output reg       vert_sync_out	   // Vertical Sync output, to VGA connector
  );
	
  //reg [19:0] valores = 20'b01011011010010101101;
  wire [3:0] fila;
  
  reg clk_25 = 0;					// 25MHz internal clock
  
  reg horiz_sync = 0;			// Internal horizontal sync
  reg vert_sync = 0;				// Internal vertical sync
  
  wire video_on;					// Monitors when pixels are printed
  reg video_on_v = 0;			// Monitors the 480 lines of printed resolution
  reg video_on_h = 0;			// Monitors the 680 columns of printed resolution
  
  reg [9:0] pixel_column;		// Column pixel counter
  reg [9:0] pixel_row;			// Row pixel counter
  
  reg [9:0] v_count = 0;		// Vertical line counter
  reg [9:0] h_count = 0;		// Horizontal column counter
  reg [20:0] Scrn_cntr =0;		// Frame (screen) counter
  
  wire [2:0]  red1;				// Red info
  wire [2:0]  green1;			// Green info
  wire [1:0]  blue1;				// Blue info
  
  
  assign fila_o = fila;
  
  // video_on - 1 - when in the 640x480 printed pixels
  assign video_on = video_on_h && video_on_v;
  
  // assignment of color info (default on white, commented comming from outside)
  assign red1 = 	/*pixel_row[4:2] 	+ Scrn_cntr[4:2];/*/3'b111;/*/red_in;*/
  assign green1 = /*pixel_row[7:5] + Scrn_cntr[4:2];/*/3'b111;/*/green_in;*/
  assign blue1 = 	/*pixel_row[9:8] 	+ Scrn_cntr[4:3];/*/2'b11;/*/blue_in;*/
  
reg en_counter;
wire en_cont_filas;
contador_mod_n  #(.DW(6), .N(32)) pixel_counter(
	.enable_i(en_counter),
	.clk_50MHz_i(clk_25),
	.rst_async_la_i(1'b1),
	.conteo_salida_o(),
	.enable_out(en_cont_filas)
);

contador_mod_n  #(.DW(4), .N(20)) row_counter(
	.enable_i(en_cont_filas),
	.clk_50MHz_i(clk_25),
	.rst_async_la_i(1'b1),
	.conteo_salida_o(fila),
	.enable_out()
);
  
  // 25MHz clock generation
  always @(posedge clk_50) clk_25 <= ~clk_25;
  
  always @(posedge clk_25)
  begin
    ////////////////////////////////// H-Sync ///////////////////////////////////
	 // ** Count starts at Tdisp **
    if ( h_count == (10'd800) ) 
      h_count <= 10'd0;
    else
      h_count <= h_count + 1;
    
	 //from 640 + 16 = 656 counts to  640 + 16 + 96 = 752 counts
    if (( h_count < (10'd752)) && (h_count > (10'd656)) )
      horiz_sync <= 1'b0;
    else
      horiz_sync <= 1'b1;
    
    if ( h_count <= (10'd640) ) 
    begin
      video_on_h <= 1'b1;
      pixel_column <= h_count;
    end
    else
      video_on_h <= 1'b0;
    //////////////////////////////// End H-Sync /////////////////////////////////
	

    ////////////////////////////////// V-Sync ///////////////////////////////////
    // ** Count starts at Tdisp **
	 if (( v_count > 10'd521 ) && ( h_count > 10'd799 )) 
    begin
      v_count <= 10'd0;
		Scrn_cntr <= Scrn_cntr + 1;
		en_counter <= 1'b0;
    end
    else if ( h_count == 10'd799 ) begin
      v_count <= v_count + 1'b1;
		en_counter <= 1'b1;
    end
	 
	 // from 480 + 10 = 490 lines  to  480 + 10 + 2 = 492 lines
    if (( v_count < 10'd492 ) && ( v_count > 10'd490 )) 
      vert_sync <= 1'b0;
    else
      vert_sync <= 1'b1;
    
    /*if ( v_count <= 10'd480 ) 
    begin
      video_on_v <= 1'b1;
      pixel_row <= v_count;
    end
    else
      video_on_v <= 1'b0;*/
		
		case(fila)
		0: if (v_count < 32 && h_count < 32)
				video_on_v <= valores[19];
			else if (v_count < 32 && h_count >= 32 && h_count < 64)
				video_on_v <= valores[18];
			else if (v_count < 32 && h_count >= 64 && h_count < 96)
				video_on_v <= valores[17];
			else if (v_count < 32 && h_count >= 96 && h_count < 128)
				video_on_v <= valores[16];
			else if (v_count < 32 && h_count >= 128 && h_count < 160)
				video_on_v <= valores[15];
			else if (v_count < 32 && h_count >= 160 && h_count < 192)
				video_on_v <= valores[14];
			else if (v_count < 32 && h_count >= 192 && h_count < 224)
				video_on_v <= valores[13];
			else if (v_count < 32 && h_count >= 224 && h_count < 256)
				video_on_v <= valores[12];
			else if (v_count < 32 && h_count >= 256 && h_count < 288)
				video_on_v <= valores[11];
			else if (v_count < 32 && h_count >= 288 && h_count < 320)
				video_on_v <= valores[10];
			else if (v_count < 32 && h_count >= 230 && h_count < 352)
				video_on_v <= valores[9];
			else if (v_count < 32 && h_count >= 352 && h_count < 384)
				video_on_v <= valores[8];
			else if (v_count < 32 && h_count >= 384 && h_count < 416)
				video_on_v <= valores[7];
			else if (v_count < 32 && h_count >= 416 && h_count < 448)
				video_on_v <= valores[6];
			else if (v_count < 32 && h_count >= 448 && h_count < 480)
				video_on_v <= valores[5];
			else if (v_count < 32 && h_count >= 480 && h_count < 512)
				video_on_v <= valores[4];
			else if (v_count < 32 && h_count >= 512 && h_count < 544)
				video_on_v <= valores[3];
			else if (v_count < 32 && h_count >= 544 && h_count < 576)
				video_on_v <= valores[2];
			else if (v_count < 32 && h_count >= 576 && h_count < 608)
				video_on_v <= valores[1];
			else if (v_count < 32 && h_count >= 608 && h_count < 640)
				video_on_v <= valores[0];
			else
				video_on_v <= 1'b0;
		1: if (v_count >= 32 && v_count < 64 && h_count < 32)
				video_on_v <= valores[19];
			else if (v_count >= 32 && v_count < 64 && h_count >= 32 && h_count < 64)
				video_on_v <= valores[18];
			else if (v_count >= 32 && v_count < 64 && h_count >= 64 && h_count < 96)
				video_on_v <= valores[17];
			else if (v_count >= 32 && v_count < 64 && h_count >= 96 && h_count < 128)
				video_on_v <= valores[16];
			else if (v_count >= 32 && v_count < 64 && h_count >= 128 && h_count < 160)
				video_on_v <= valores[15];
			else if (v_count >= 32 && v_count < 64 && h_count >= 160 && h_count < 192)
				video_on_v <= valores[14];
			else if (v_count >= 32 && v_count < 64 && h_count >= 192 && h_count < 224)
				video_on_v <= valores[13];
			else if (v_count >= 32 && v_count < 64 && h_count >= 224 && h_count < 256)
				video_on_v <= valores[12];
			else if (v_count >= 32 && v_count < 64 && h_count >= 256 && h_count < 288)
				video_on_v <= valores[11];
			else if (v_count >= 32 && v_count < 64 && h_count >= 288 && h_count < 320)
				video_on_v <= valores[10];
			else if (v_count >= 32 && v_count < 64 && h_count >= 230 && h_count < 352)
				video_on_v <= valores[9];
			else if (v_count >= 32 && v_count < 64 && h_count >= 352 && h_count < 384)
				video_on_v <= valores[8];
			else if (v_count >= 32 && v_count < 64 && h_count >= 384 && h_count < 416)
				video_on_v <= valores[7];
			else if (v_count >= 32 && v_count < 64 && h_count >= 416 && h_count < 448)
				video_on_v <= valores[6];
			else if (v_count >= 32 && v_count < 64 && h_count >= 448 && h_count < 480)
				video_on_v <= valores[5];
			else if (v_count >= 32 && v_count < 64 && h_count >= 480 && h_count < 512)
				video_on_v <= valores[4];
			else if (v_count >= 32 && v_count < 64 && h_count >= 512 && h_count < 544)
				video_on_v <= valores[3];
			else if (v_count >= 32 && v_count < 64 && h_count >= 544 && h_count < 576)
				video_on_v <= valores[2];
			else if (v_count >= 32 && v_count < 64 && h_count >= 576 && h_count < 608)
				video_on_v <= valores[1];
			else if (v_count >= 32 && v_count < 64 && h_count >= 608 && h_count < 640)
				video_on_v <= valores[0];
			else
				video_on_v <= 1'b0;
		2: if (v_count >= 64 && v_count < 96 && h_count < 32)
				video_on_v <= valores[19];
			else if (v_count >= 64 && v_count < 96 && h_count >= 32 && h_count < 64)
				video_on_v <= valores[18];
			else if (v_count >= 64 && v_count < 96 && h_count >= 64 && h_count < 96)
				video_on_v <= valores[17];
			else if (v_count >= 64 && v_count < 96 && h_count >= 96 && h_count < 128)
				video_on_v <= valores[16];
			else if (v_count >= 64 && v_count < 96 && h_count >= 128 && h_count < 160)
				video_on_v <= valores[15];
			else if (v_count >= 64 && v_count < 96 && h_count >= 160 && h_count < 192)
				video_on_v <= valores[14];
			else if (v_count >= 64 && v_count < 96 && h_count >= 192 && h_count < 224)
				video_on_v <= valores[13];
			else if (v_count >= 64 && v_count < 96 && h_count >= 224 && h_count < 256)
				video_on_v <= valores[12];
			else if (v_count >= 64 && v_count < 96 && h_count >= 256 && h_count < 288)
				video_on_v <= valores[11];
			else if (v_count >= 64 && v_count < 96 && h_count >= 288 && h_count < 320)
				video_on_v <= valores[10];
			else if (v_count >= 64 && v_count < 96 && h_count >= 230 && h_count < 352)
				video_on_v <= valores[9];
			else if (v_count >= 64 && v_count < 96 && h_count >= 352 && h_count < 384)
				video_on_v <= valores[8];
			else if (v_count >= 64 && v_count < 96 && h_count >= 384 && h_count < 416)
				video_on_v <= valores[7];
			else if (v_count >= 64 && v_count < 96 && h_count >= 416 && h_count < 448)
				video_on_v <= valores[6];
			else if (v_count >= 64 && v_count < 96 && h_count >= 448 && h_count < 480)
				video_on_v <= valores[5];
			else if (v_count >= 64 && v_count < 96 && h_count >= 480 && h_count < 512)
				video_on_v <= valores[4];
			else if (v_count >= 64 && v_count < 96 && h_count >= 512 && h_count < 544)
				video_on_v <= valores[3];
			else if (v_count >= 64 && v_count < 96 && h_count >= 544 && h_count < 576)
				video_on_v <= valores[2];
			else if (v_count >= 64 && v_count < 96 && h_count >= 576 && h_count < 608)
				video_on_v <= valores[1];
			else if (v_count >= 64 && v_count < 96 && h_count >= 608 && h_count < 640)
				video_on_v <= valores[0];
			else
				video_on_v <= 1'b0;
		3: if (v_count >= 96 && v_count < 128 && h_count < 32)
				video_on_v <= valores[19];
			else if (v_count >= 96 && v_count < 128 && h_count >= 32 && h_count < 64)
				video_on_v <= valores[18];
			else if (v_count >= 96 && v_count < 128 && h_count >= 64 && h_count < 96)
				video_on_v <= valores[17];
			else if (v_count >= 96 && v_count < 128 && h_count >= 96 && h_count < 128)
				video_on_v <= valores[16];
			else if (v_count >= 96 && v_count < 128 && h_count >= 128 && h_count < 160)
				video_on_v <= valores[15];
			else if (v_count >= 96 && v_count < 128 && h_count >= 160 && h_count < 192)
				video_on_v <= valores[14];
			else if (v_count >= 96 && v_count < 128 && h_count >= 192 && h_count < 224)
				video_on_v <= valores[13];
			else if (v_count >= 96 && v_count < 128 && h_count >= 224 && h_count < 256)
				video_on_v <= valores[12];
			else if (v_count >= 96 && v_count < 128 && h_count >= 256 && h_count < 288)
				video_on_v <= valores[11];
			else if (v_count >= 96 && v_count < 128 && h_count >= 288 && h_count < 320)
				video_on_v <= valores[10];
			else if (v_count >= 96 && v_count < 128 && h_count >= 230 && h_count < 352)
				video_on_v <= valores[9];
			else if (v_count >= 96 && v_count < 128 && h_count >= 352 && h_count < 384)
				video_on_v <= valores[8];
			else if (v_count >= 96 && v_count < 128 && h_count >= 384 && h_count < 416)
				video_on_v <= valores[7];
			else if (v_count >= 96 && v_count < 128 && h_count >= 416 && h_count < 448)
				video_on_v <= valores[6];
			else if (v_count >= 96 && v_count < 128 && h_count >= 448 && h_count < 480)
				video_on_v <= valores[5];
			else if (v_count >= 96 && v_count < 128 && h_count >= 480 && h_count < 512)
				video_on_v <= valores[4];
			else if (v_count >= 96 && v_count < 128 && h_count >= 512 && h_count < 544)
				video_on_v <= valores[3];
			else if (v_count >= 96 && v_count < 128 && h_count >= 544 && h_count < 576)
				video_on_v <= valores[2];
			else if (v_count >= 96 && v_count < 128 && h_count >= 576 && h_count < 608)
				video_on_v <= valores[1];
			else if (v_count >= 96 && v_count < 128 && h_count >= 608 && h_count < 640)
				video_on_v <= valores[0];
			else
				video_on_v <= 1'b0;
		4: if (v_count >= 128 && v_count < 160 && h_count < 32)
				video_on_v <= valores[19];
			else if (v_count >= 128 && v_count < 160 && h_count >= 32 && h_count < 64)
				video_on_v <= valores[18];
			else if (v_count >= 128 && v_count < 160 && h_count >= 64 && h_count < 96)
				video_on_v <= valores[17];
			else if (v_count >= 128 && v_count < 160 && h_count >= 96 && h_count < 128)
				video_on_v <= valores[16];
			else if (v_count >= 128 && v_count < 160 && h_count >= 128 && h_count < 160)
				video_on_v <= valores[15];
			else if (v_count >= 128 && v_count < 160 && h_count >= 160 && h_count < 192)
				video_on_v <= valores[14];
			else if (v_count >= 128 && v_count < 160 && h_count >= 192 && h_count < 224)
				video_on_v <= valores[13];
			else if (v_count >= 128 && v_count < 160 && h_count >= 224 && h_count < 256)
				video_on_v <= valores[12];
			else if (v_count >= 128 && v_count < 160 && h_count >= 256 && h_count < 288)
				video_on_v <= valores[11];
			else if (v_count >= 128 && v_count < 160 && h_count >= 288 && h_count < 320)
				video_on_v <= valores[10];
			else if (v_count >= 128 && v_count < 160 && h_count >= 230 && h_count < 352)
				video_on_v <= valores[9];
			else if (v_count >= 128 && v_count < 160 && h_count >= 352 && h_count < 384)
				video_on_v <= valores[8];
			else if (v_count >= 128 && v_count < 160 && h_count >= 384 && h_count < 416)
				video_on_v <= valores[7];
			else if (v_count >= 128 && v_count < 160 && h_count >= 416 && h_count < 448)
				video_on_v <= valores[6];
			else if (v_count >= 128 && v_count < 160 && h_count >= 448 && h_count < 480)
				video_on_v <= valores[5];
			else if (v_count >= 128 && v_count < 160 && h_count >= 480 && h_count < 512)
				video_on_v <= valores[4];
			else if (v_count >= 128 && v_count < 160 && h_count >= 512 && h_count < 544)
				video_on_v <= valores[3];
			else if (v_count >= 128 && v_count < 160 && h_count >= 544 && h_count < 576)
				video_on_v <= valores[2];
			else if (v_count >= 128 && v_count < 160 && h_count >= 576 && h_count < 608)
				video_on_v <= valores[1];
			else if (v_count >= 128 && v_count < 160 && h_count >= 608 && h_count < 640)
				video_on_v <= valores[0];
			else
				video_on_v <= 1'b0;
		5: if (v_count >= 160 && v_count < 192 && h_count < 32)
				video_on_v <= valores[19];
			else if (v_count >= 160 && v_count < 192 && h_count >= 32 && h_count < 64)
				video_on_v <= valores[18];
			else if (v_count >= 160 && v_count < 192 && h_count >= 64 && h_count < 96)
				video_on_v <= valores[17];
			else if (v_count >= 160 && v_count < 192 && h_count >= 96 && h_count < 128)
				video_on_v <= valores[16];
			else if (v_count >= 160 && v_count < 192 && h_count >= 128 && h_count < 160)
				video_on_v <= valores[15];
			else if (v_count >= 160 && v_count < 192 && h_count >= 160 && h_count < 192)
				video_on_v <= valores[14];
			else if (v_count >= 160 && v_count < 192 && h_count >= 192 && h_count < 224)
				video_on_v <= valores[13];
			else if (v_count >= 160 && v_count < 192 && h_count >= 224 && h_count < 256)
				video_on_v <= valores[12];
			else if (v_count >= 160 && v_count < 192 && h_count >= 256 && h_count < 288)
				video_on_v <= valores[11];
			else if (v_count >= 160 && v_count < 192 && h_count >= 288 && h_count < 320)
				video_on_v <= valores[10];
			else if (v_count >= 160 && v_count < 192 && h_count >= 230 && h_count < 352)
				video_on_v <= valores[9];
			else if (v_count >= 160 && v_count < 192 && h_count >= 352 && h_count < 384)
				video_on_v <= valores[8];
			else if (v_count >= 160 && v_count < 192 && h_count >= 384 && h_count < 416)
				video_on_v <= valores[7];
			else if (v_count >= 160 && v_count < 192 && h_count >= 416 && h_count < 448)
				video_on_v <= valores[6];
			else if (v_count >= 160 && v_count < 192 && h_count >= 448 && h_count < 480)
				video_on_v <= valores[5];
			else if (v_count >= 160 && v_count < 192 && h_count >= 480 && h_count < 512)
				video_on_v <= valores[4];
			else if (v_count >= 160 && v_count < 192 && h_count >= 512 && h_count < 544)
				video_on_v <= valores[3];
			else if (v_count >= 160 && v_count < 192 && h_count >= 544 && h_count < 576)
				video_on_v <= valores[2];
			else if (v_count >= 160 && v_count < 192 && h_count >= 576 && h_count < 608)
				video_on_v <= valores[1];
			else if (v_count >= 160 && v_count < 192 && h_count >= 608 && h_count < 640)
				video_on_v <= valores[0];
			else
				video_on_v <= 1'b0;
		6: if (v_count >= 192 && v_count < 224 && h_count < 32)
				video_on_v <= valores[19];
			else if (v_count >= 192 && v_count < 224 && h_count >= 32 && h_count < 64)
				video_on_v <= valores[18];
			else if (v_count >= 192 && v_count < 224 && h_count >= 64 && h_count < 96)
				video_on_v <= valores[17];
			else if (v_count >= 192 && v_count < 224 && h_count >= 96 && h_count < 128)
				video_on_v <= valores[16];
			else if (v_count >= 192 && v_count < 224 && h_count >= 128 && h_count < 160)
				video_on_v <= valores[15];
			else if (v_count >= 192 && v_count < 224 && h_count >= 160 && h_count < 192)
				video_on_v <= valores[14];
			else if (v_count >= 192 && v_count < 224 && h_count >= 192 && h_count < 224)
				video_on_v <= valores[13];
			else if (v_count >= 192 && v_count < 224 && h_count >= 224 && h_count < 256)
				video_on_v <= valores[12];
			else if (v_count >= 192 && v_count < 224 && h_count >= 256 && h_count < 288)
				video_on_v <= valores[11];
			else if (v_count >= 192 && v_count < 224 && h_count >= 288 && h_count < 320)
				video_on_v <= valores[10];
			else if (v_count >= 192 && v_count < 224 && h_count >= 230 && h_count < 352)
				video_on_v <= valores[9];
			else if (v_count >= 192 && v_count < 224 && h_count >= 352 && h_count < 384)
				video_on_v <= valores[8];
			else if (v_count >= 192 && v_count < 224 && h_count >= 384 && h_count < 416)
				video_on_v <= valores[7];
			else if (v_count >= 192 && v_count < 224 && h_count >= 416 && h_count < 448)
				video_on_v <= valores[6];
			else if (v_count >= 192 && v_count < 224 && h_count >= 448 && h_count < 480)
				video_on_v <= valores[5];
			else if (v_count >= 192 && v_count < 224 && h_count >= 480 && h_count < 512)
				video_on_v <= valores[4];
			else if (v_count >= 192 && v_count < 224 && h_count >= 512 && h_count < 544)
				video_on_v <= valores[3];
			else if (v_count >= 192 && v_count < 224 && h_count >= 544 && h_count < 576)
				video_on_v <= valores[2];
			else if (v_count >= 192 && v_count < 224 && h_count >= 576 && h_count < 608)
				video_on_v <= valores[1];
			else if (v_count >= 192 && v_count < 224 && h_count >= 608 && h_count < 640)
				video_on_v <= valores[0];
			else
				video_on_v <= 1'b0;
		7: if (v_count >= 224 && v_count < 256 && h_count < 32)
				video_on_v <= valores[19];
			else if (v_count >= 224 && v_count < 256 && h_count >= 32 && h_count < 64)
				video_on_v <= valores[18];
			else if (v_count >= 224 && v_count < 256 && h_count >= 64 && h_count < 96)
				video_on_v <= valores[17];
			else if (v_count >= 224 && v_count < 256 && h_count >= 96 && h_count < 128)
				video_on_v <= valores[16];
			else if (v_count >= 224 && v_count < 256 && h_count >= 128 && h_count < 160)
				video_on_v <= valores[15];
			else if (v_count >= 224 && v_count < 256 && h_count >= 160 && h_count < 192)
				video_on_v <= valores[14];
			else if (v_count >= 224 && v_count < 256 && h_count >= 192 && h_count < 224)
				video_on_v <= valores[13];
			else if (v_count >= 224 && v_count < 256 && h_count >= 224 && h_count < 256)
				video_on_v <= valores[12];
			else if (v_count >= 224 && v_count < 256 && h_count >= 256 && h_count < 288)
				video_on_v <= valores[11];
			else if (v_count >= 224 && v_count < 256 && h_count >= 288 && h_count < 320)
				video_on_v <= valores[10];
			else if (v_count >= 224 && v_count < 256 && h_count >= 230 && h_count < 352)
				video_on_v <= valores[9];
			else if (v_count >= 224 && v_count < 256 && h_count >= 352 && h_count < 384)
				video_on_v <= valores[8];
			else if (v_count >= 224 && v_count < 256 && h_count >= 384 && h_count < 416)
				video_on_v <= valores[7];
			else if (v_count >= 224 && v_count < 256 && h_count >= 416 && h_count < 448)
				video_on_v <= valores[6];
			else if (v_count >= 224 && v_count < 256 && h_count >= 448 && h_count < 480)
				video_on_v <= valores[5];
			else if (v_count >= 224 && v_count < 256 && h_count >= 480 && h_count < 512)
				video_on_v <= valores[4];
			else if (v_count >= 224 && v_count < 256 && h_count >= 512 && h_count < 544)
				video_on_v <= valores[3];
			else if (v_count >= 224 && v_count < 256 && h_count >= 544 && h_count < 576)
				video_on_v <= valores[2];
			else if (v_count >= 224 && v_count < 256 && h_count >= 576 && h_count < 608)
				video_on_v <= valores[1];
			else if (v_count >= 224 && v_count < 256 && h_count >= 608 && h_count < 640)
				video_on_v <= valores[0];
			else
				video_on_v <= 1'b0;
		8: if (v_count >= 256 && v_count < 288 && h_count < 32)
				video_on_v <= valores[19];
			else if (v_count >= 256 && v_count < 288 && h_count >= 32 && h_count < 64)
				video_on_v <= valores[18];
			else if (v_count >= 256 && v_count < 288 && h_count >= 64 && h_count < 96)
				video_on_v <= valores[17];
			else if (v_count >= 256 && v_count < 288 && h_count >= 96 && h_count < 128)
				video_on_v <= valores[16];
			else if (v_count >= 256 && v_count < 288 && h_count >= 128 && h_count < 160)
				video_on_v <= valores[15];
			else if (v_count >= 256 && v_count < 288 && h_count >= 160 && h_count < 192)
				video_on_v <= valores[14];
			else if (v_count >= 256 && v_count < 288 && h_count >= 192 && h_count < 224)
				video_on_v <= valores[13];
			else if (v_count >= 256 && v_count < 288 && h_count >= 224 && h_count < 256)
				video_on_v <= valores[12];
			else if (v_count >= 256 && v_count < 288 && h_count >= 256 && h_count < 288)
				video_on_v <= valores[11];
			else if (v_count >= 256 && v_count < 288 && h_count >= 288 && h_count < 320)
				video_on_v <= valores[10];
			else if (v_count >= 256 && v_count < 288 && h_count >= 230 && h_count < 352)
				video_on_v <= valores[9];
			else if (v_count >= 256 && v_count < 288 && h_count >= 352 && h_count < 384)
				video_on_v <= valores[8];
			else if (v_count >= 256 && v_count < 288 && h_count >= 384 && h_count < 416)
				video_on_v <= valores[7];
			else if (v_count >= 256 && v_count < 288 && h_count >= 416 && h_count < 448)
				video_on_v <= valores[6];
			else if (v_count >= 256 && v_count < 288 && h_count >= 448 && h_count < 480)
				video_on_v <= valores[5];
			else if (v_count >= 256 && v_count < 288 && h_count >= 480 && h_count < 512)
				video_on_v <= valores[4];
			else if (v_count >= 256 && v_count < 288 && h_count >= 512 && h_count < 544)
				video_on_v <= valores[3];
			else if (v_count >= 256 && v_count < 288 && h_count >= 544 && h_count < 576)
				video_on_v <= valores[2];
			else if (v_count >= 256 && v_count < 288 && h_count >= 576 && h_count < 608)
				video_on_v <= valores[1];
			else if (v_count >= 256 && v_count < 288 && h_count >= 608 && h_count < 640)
				video_on_v <= valores[0];
			else
				video_on_v <= 1'b0;
		9: if (v_count >= 288 && v_count < 320 && h_count < 32)
				video_on_v <= valores[19];
			else if (v_count >= 288 && v_count < 320 && h_count >= 32 && h_count < 64)
				video_on_v <= valores[18];
			else if (v_count >= 288 && v_count < 320 && h_count >= 64 && h_count < 96)
				video_on_v <= valores[17];
			else if (v_count >= 288 && v_count < 320 && h_count >= 96 && h_count < 128)
				video_on_v <= valores[16];
			else if (v_count >= 288 && v_count < 320 && h_count >= 128 && h_count < 160)
				video_on_v <= valores[15];
			else if (v_count >= 288 && v_count < 320 && h_count >= 160 && h_count < 192)
				video_on_v <= valores[14];
			else if (v_count >= 288 && v_count < 320 && h_count >= 192 && h_count < 224)
				video_on_v <= valores[13];
			else if (v_count >= 288 && v_count < 320 && h_count >= 224 && h_count < 256)
				video_on_v <= valores[12];
			else if (v_count >= 288 && v_count < 320 && h_count >= 256 && h_count < 288)
				video_on_v <= valores[11];
			else if (v_count >= 288 && v_count < 320 && h_count >= 288 && h_count < 320)
				video_on_v <= valores[10];
			else if (v_count >= 288 && v_count < 320 && h_count >= 230 && h_count < 352)
				video_on_v <= valores[9];
			else if (v_count >= 288 && v_count < 320 && h_count >= 352 && h_count < 384)
				video_on_v <= valores[8];
			else if (v_count >= 288 && v_count < 320 && h_count >= 384 && h_count < 416)
				video_on_v <= valores[7];
			else if (v_count >= 288 && v_count < 320 && h_count >= 416 && h_count < 448)
				video_on_v <= valores[6];
			else if (v_count >= 288 && v_count < 320 && h_count >= 448 && h_count < 480)
				video_on_v <= valores[5];
			else if (v_count >= 288 && v_count < 320 && h_count >= 480 && h_count < 512)
				video_on_v <= valores[4];
			else if (v_count >= 288 && v_count < 320 && h_count >= 512 && h_count < 544)
				video_on_v <= valores[3];
			else if (v_count >= 288 && v_count < 320 && h_count >= 544 && h_count < 576)
				video_on_v <= valores[2];
			else if (v_count >= 288 && v_count < 320 && h_count >= 576 && h_count < 608)
				video_on_v <= valores[1];
			else if (v_count >= 288 && v_count < 320 && h_count >= 608 && h_count < 640)
				video_on_v <= valores[0];
			else
				video_on_v <= 1'b0;
		10: if (v_count >= 320 && v_count < 352 && h_count < 32)
				video_on_v <= valores[19];
			else if (v_count >= 320 && v_count < 352 && h_count >= 32 && h_count < 64)
				video_on_v <= valores[18];
			else if (v_count >= 320 && v_count < 352 && h_count >= 64 && h_count < 96)
				video_on_v <= valores[17];
			else if (v_count >= 320 && v_count < 352 && h_count >= 96 && h_count < 128)
				video_on_v <= valores[16];
			else if (v_count >= 320 && v_count < 352 && h_count >= 128 && h_count < 160)
				video_on_v <= valores[15];
			else if (v_count >= 320 && v_count < 352 && h_count >= 160 && h_count < 192)
				video_on_v <= valores[14];
			else if (v_count >= 320 && v_count < 352 && h_count >= 192 && h_count < 224)
				video_on_v <= valores[13];
			else if (v_count >= 320 && v_count < 352 && h_count >= 224 && h_count < 256)
				video_on_v <= valores[12];
			else if (v_count >= 320 && v_count < 352 && h_count >= 256 && h_count < 288)
				video_on_v <= valores[11];
			else if (v_count >= 320 && v_count < 352 && h_count >= 288 && h_count < 320)
				video_on_v <= valores[10];
			else if (v_count >= 320 && v_count < 352 && h_count >= 230 && h_count < 352)
				video_on_v <= valores[9];
			else if (v_count >= 320 && v_count < 352 && h_count >= 352 && h_count < 384)
				video_on_v <= valores[8];
			else if (v_count >= 320 && v_count < 352 && h_count >= 384 && h_count < 416)
				video_on_v <= valores[7];
			else if (v_count >= 320 && v_count < 352 && h_count >= 416 && h_count < 448)
				video_on_v <= valores[6];
			else if (v_count >= 320 && v_count < 352 && h_count >= 448 && h_count < 480)
				video_on_v <= valores[5];
			else if (v_count >= 320 && v_count < 352 && h_count >= 480 && h_count < 512)
				video_on_v <= valores[4];
			else if (v_count >= 320 && v_count < 352 && h_count >= 512 && h_count < 544)
				video_on_v <= valores[3];
			else if (v_count >= 320 && v_count < 352 && h_count >= 544 && h_count < 576)
				video_on_v <= valores[2];
			else if (v_count >= 320 && v_count < 352 && h_count >= 576 && h_count < 608)
				video_on_v <= valores[1];
			else if (v_count >= 320 && v_count < 352 && h_count >= 608 && h_count < 640)
				video_on_v <= valores[0];
			else
				video_on_v <= 1'b0;
		11: if (v_count >= 352 && v_count < 384 && h_count < 32)
				video_on_v <= valores[19];
			else if (v_count >= 352 && v_count < 384 && h_count >= 32 && h_count < 64)
				video_on_v <= valores[18];
			else if (v_count >= 352 && v_count < 384 && h_count >= 64 && h_count < 96)
				video_on_v <= valores[17];
			else if (v_count >= 352 && v_count < 384 && h_count >= 96 && h_count < 128)
				video_on_v <= valores[16];
			else if (v_count >= 352 && v_count < 384 && h_count >= 128 && h_count < 160)
				video_on_v <= valores[15];
			else if (v_count >= 352 && v_count < 384 && h_count >= 160 && h_count < 192)
				video_on_v <= valores[14];
			else if (v_count >= 352 && v_count < 384 && h_count >= 192 && h_count < 224)
				video_on_v <= valores[13];
			else if (v_count >= 352 && v_count < 384 && h_count >= 224 && h_count < 256)
				video_on_v <= valores[12];
			else if (v_count >= 352 && v_count < 384 && h_count >= 256 && h_count < 288)
				video_on_v <= valores[11];
			else if (v_count >= 352 && v_count < 384 && h_count >= 288 && h_count < 320)
				video_on_v <= valores[10];
			else if (v_count >= 352 && v_count < 384 && h_count >= 230 && h_count < 352)
				video_on_v <= valores[9];
			else if (v_count >= 352 && v_count < 384 && h_count >= 352 && h_count < 384)
				video_on_v <= valores[8];
			else if (v_count >= 352 && v_count < 384 && h_count >= 384 && h_count < 416)
				video_on_v <= valores[7];
			else if (v_count >= 352 && v_count < 384 && h_count >= 416 && h_count < 448)
				video_on_v <= valores[6];
			else if (v_count >= 352 && v_count < 384 && h_count >= 448 && h_count < 480)
				video_on_v <= valores[5];
			else if (v_count >= 352 && v_count < 384 && h_count >= 480 && h_count < 512)
				video_on_v <= valores[4];
			else if (v_count >= 352 && v_count < 384 && h_count >= 512 && h_count < 544)
				video_on_v <= valores[3];
			else if (v_count >= 352 && v_count < 384 && h_count >= 544 && h_count < 576)
				video_on_v <= valores[2];
			else if (v_count >= 352 && v_count < 384 && h_count >= 576 && h_count < 608)
				video_on_v <= valores[1];
			else if (v_count >= 352 && v_count < 384 && h_count >= 608 && h_count < 640)
				video_on_v <= valores[0];
			else
				video_on_v <= 1'b0;
		12: if (v_count >= 384 && v_count < 416 && h_count < 32)
				video_on_v <= valores[19];
			else if (v_count >= 384 && v_count < 416 && h_count >= 32 && h_count < 64)
				video_on_v <= valores[18];
			else if (v_count >= 384 && v_count < 416 && h_count >= 64 && h_count < 96)
				video_on_v <= valores[17];
			else if (v_count >= 384 && v_count < 416 && h_count >= 96 && h_count < 128)
				video_on_v <= valores[16];
			else if (v_count >= 384 && v_count < 416 && h_count >= 128 && h_count < 160)
				video_on_v <= valores[15];
			else if (v_count >= 384 && v_count < 416 && h_count >= 160 && h_count < 192)
				video_on_v <= valores[14];
			else if (v_count >= 384 && v_count < 416 && h_count >= 192 && h_count < 224)
				video_on_v <= valores[13];
			else if (v_count >= 384 && v_count < 416 && h_count >= 224 && h_count < 256)
				video_on_v <= valores[12];
			else if (v_count >= 384 && v_count < 416 && h_count >= 256 && h_count < 288)
				video_on_v <= valores[11];
			else if (v_count >= 384 && v_count < 416 && h_count >= 288 && h_count < 320)
				video_on_v <= valores[10];
			else if (v_count >= 384 && v_count < 416 && h_count >= 230 && h_count < 352)
				video_on_v <= valores[9];
			else if (v_count >= 384 && v_count < 416 && h_count >= 352 && h_count < 384)
				video_on_v <= valores[8];
			else if (v_count >= 384 && v_count < 416 && h_count >= 384 && h_count < 416)
				video_on_v <= valores[7];
			else if (v_count >= 384 && v_count < 416 && h_count >= 416 && h_count < 448)
				video_on_v <= valores[6];
			else if (v_count >= 384 && v_count < 416 && h_count >= 448 && h_count < 480)
				video_on_v <= valores[5];
			else if (v_count >= 384 && v_count < 416 && h_count >= 480 && h_count < 512)
				video_on_v <= valores[4];
			else if (v_count >= 384 && v_count < 416 && h_count >= 512 && h_count < 544)
				video_on_v <= valores[3];
			else if (v_count >= 384 && v_count < 416 && h_count >= 544 && h_count < 576)
				video_on_v <= valores[2];
			else if (v_count >= 384 && v_count < 416 && h_count >= 576 && h_count < 608)
				video_on_v <= valores[1];
			else if (v_count >= 384 && v_count < 416 && h_count >= 608 && h_count < 640)
				video_on_v <= valores[0];
			else
				video_on_v <= 1'b0;
		13: if (v_count >= 416 && v_count < 448 && h_count < 32)
				video_on_v <= valores[19];
			else if (v_count >= 416 && v_count < 448 && h_count >= 32 && h_count < 64)
				video_on_v <= valores[18];
			else if (v_count >= 416 && v_count < 448 && h_count >= 64 && h_count < 96)
				video_on_v <= valores[17];
			else if (v_count >= 416 && v_count < 448 && h_count >= 96 && h_count < 128)
				video_on_v <= valores[16];
			else if (v_count >= 416 && v_count < 448 && h_count >= 128 && h_count < 160)
				video_on_v <= valores[15];
			else if (v_count >= 416 && v_count < 448 && h_count >= 160 && h_count < 192)
				video_on_v <= valores[14];
			else if (v_count >= 416 && v_count < 448 && h_count >= 192 && h_count < 224)
				video_on_v <= valores[13];
			else if (v_count >= 416 && v_count < 448 && h_count >= 224 && h_count < 256)
				video_on_v <= valores[12];
			else if (v_count >= 416 && v_count < 448 && h_count >= 256 && h_count < 288)
				video_on_v <= valores[11];
			else if (v_count >= 416 && v_count < 448 && h_count >= 288 && h_count < 320)
				video_on_v <= valores[10];
			else if (v_count >= 416 && v_count < 448 && h_count >= 230 && h_count < 352)
				video_on_v <= valores[9];
			else if (v_count >= 416 && v_count < 448 && h_count >= 352 && h_count < 384)
				video_on_v <= valores[8];
			else if (v_count >= 416 && v_count < 448 && h_count >= 384 && h_count < 416)
				video_on_v <= valores[7];
			else if (v_count >= 416 && v_count < 448 && h_count >= 416 && h_count < 448)
				video_on_v <= valores[6];
			else if (v_count >= 416 && v_count < 448 && h_count >= 448 && h_count < 480)
				video_on_v <= valores[5];
			else if (v_count >= 416 && v_count < 448 && h_count >= 480 && h_count < 512)
				video_on_v <= valores[4];
			else if (v_count >= 416 && v_count < 448 && h_count >= 512 && h_count < 544)
				video_on_v <= valores[3];
			else if (v_count >= 416 && v_count < 448 && h_count >= 544 && h_count < 576)
				video_on_v <= valores[2];
			else if (v_count >= 416 && v_count < 448 && h_count >= 576 && h_count < 608)
				video_on_v <= valores[1];
			else if (v_count >= 416 && v_count < 448 && h_count >= 608 && h_count < 640)
				video_on_v <= valores[0];
			else
				video_on_v <= 1'b0;
		14: if (v_count >= 448 && v_count < 480 && h_count < 32)
				video_on_v <= valores[19];
			else if (v_count >= 448 && v_count < 480 && h_count >= 32 && h_count < 64)
				video_on_v <= valores[18];
			else if (v_count >= 448 && v_count < 480 && h_count >= 64 && h_count < 96)
				video_on_v <= valores[17];
			else if (v_count >= 448 && v_count < 480 && h_count >= 96 && h_count < 128)
				video_on_v <= valores[16];
			else if (v_count >= 448 && v_count < 480 && h_count >= 128 && h_count < 160)
				video_on_v <= valores[15];
			else if (v_count >= 448 && v_count < 480 && h_count >= 160 && h_count < 192)
				video_on_v <= valores[14];
			else if (v_count >= 448 && v_count < 480 && h_count >= 192 && h_count < 224)
				video_on_v <= valores[13];
			else if (v_count >= 448 && v_count < 480 && h_count >= 224 && h_count < 256)
				video_on_v <= valores[12];
			else if (v_count >= 448 && v_count < 480 && h_count >= 256 && h_count < 288)
				video_on_v <= valores[11];
			else if (v_count >= 448 && v_count < 480 && h_count >= 288 && h_count < 320)
				video_on_v <= valores[10];
			else if (v_count >= 448 && v_count < 480 && h_count >= 230 && h_count < 352)
				video_on_v <= valores[9];
			else if (v_count >= 448 && v_count < 480 && h_count >= 352 && h_count < 384)
				video_on_v <= valores[8];
			else if (v_count >= 448 && v_count < 480 && h_count >= 384 && h_count < 416)
				video_on_v <= valores[7];
			else if (v_count >= 448 && v_count < 480 && h_count >= 416 && h_count < 448)
				video_on_v <= valores[6];
			else if (v_count >= 448 && v_count < 480 && h_count >= 448 && h_count < 480)
				video_on_v <= valores[5];
			else if (v_count >= 448 && v_count < 480 && h_count >= 480 && h_count < 512)
				video_on_v <= valores[4];
			else if (v_count >= 448 && v_count < 480 && h_count >= 512 && h_count < 544)
				video_on_v <= valores[3];
			else if (v_count >= 448 && v_count < 480 && h_count >= 544 && h_count < 576)
				video_on_v <= valores[2];
			else if (v_count >= 448 && v_count < 480 && h_count >= 576 && h_count < 608)
				video_on_v <= valores[1];
			else if (v_count >= 448 && v_count < 480 && h_count >= 608 && h_count < 640)
				video_on_v <= valores[0];
			else
				video_on_v <= 1'b0;
		default:
			video_on_v <= 1'b0;
		endcase
		
    /////////////////////////////// End V-Sync //////////////////////////////////    
    
    /////////////////////////////// Pixel assign ////////////////////////////////
    if (video_on == 1'b1) 
    begin
      red_out <= red1;
      blue_out <= blue1;
      green_out <= green1;
    end
    else
    begin
      red_out <= 3'b00;
      blue_out <= 3'b00;
      green_out <= 2'b00;
    end
    ///////////////////////////// End Pixel assign //////////////////////////////
    
    horiz_sync_out <= horiz_sync;
    vert_sync_out <= vert_sync;

  end
endmodule
