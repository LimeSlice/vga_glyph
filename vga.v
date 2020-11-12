module vga 
#(parameter SYS_DATA_WIDTH=16, SYS_ADDR_WIDTH=16,
				GLYPH_DATA_WIDTH=24, GLYPH_ADDR_WIDTH=8)
(
	input clk, reset,
	input [(SYS_DATA_WIDTH-1):0] sys_data,
	output vga_clk, vga_blank_n, vga_vs, vga_hs,
	output [7:0] r, g, b,
	output [(SYS_ADDR_WIDTH-1):0] sys_addr
);

// size of registers log2(800) ~ 10
//							log2(525) ~ 10
localparam LOG2_DISPLAY_WIDTH  = 10;
localparam LOG2_DISPLAY_HEIGHT = 10;

/***************************************************************************/
/* 		NETS																					*/
/***************************************************************************/

wire [(LOG2_DISPLAY_WIDTH-1):0]  hcount;
wire [(LOG2_DISPLAY_HEIGHT-1):0] vcount;
wire [(GLYPH_ADDR_WIDTH-1):0] glyph_addr;
wire [(GLYPH_DATA_WIDTH-1):0] pixel;
wire [23:0] bg_color;
wire pix_en;
reg  pix_en_out;

/***************************************************************************/
/* 		VGA CONTROL																			*/
/***************************************************************************/

defparam ctrl.LOG2_DISPLAY_WIDTH = LOG2_DISPLAY_WIDTH;
defparam ctrl.LOG2_DISPLAY_HEIGHT = LOG2_DISPLAY_HEIGHT;

vga_control ctrl (
	clk, reset,					// inputs  (1-bit)			
	vga_hs, vga_vs,			// outputs (1-bit)
	vga_blank_n, vga_clk,	// outputs (1-bit)
	hcount,						// outputs (LOG2_DISPLAY_WIDTH-bit) 
	vcount						// outputs (LOG2_DISPLAY_HEIGHT-bit)
);

/***************************************************************************/
/* 		BITGEN																				*/
/***************************************************************************/

// generate dff to stall and propogate the pix_en 1 cycle to display proper pixels
always @(posedge clk)
	pix_en_out <= pix_en;
	
defparam bitgen.DATA_WIDTH = GLYPH_DATA_WIDTH;

bitgen bitgen (
	vga_blank_n, pix_en_out,	// inputs  (1-bit)
	pixel, 							// inputs  (GLYPH_DATA_WIDTH-bit)
	bg_color, 						// inputs  (24-bit)
	{r,g,b}							// outputs (24-bit)
);


/***************************************************************************/
/* 		GLYPH ADDRESS GENERATOR															*/
/***************************************************************************/

defparam addr_gen.SYS_DATA_WIDTH = SYS_DATA_WIDTH;
defparam addr_gen.SYS_ADDR_WIDTH = SYS_ADDR_WIDTH;
defparam addr_gen.GLYPH_DATA_WIDTH = GLYPH_DATA_WIDTH;
defparam addr_gen.GLYPH_ADDR_WIDTH = GLYPH_ADDR_WIDTH;
defparam addr_gen.LOG2_DISPLAY_WIDTH = LOG2_DISPLAY_WIDTH;
defparam addr_gen.LOG2_DISPLAY_HEIGHT = LOG2_DISPLAY_HEIGHT;

glyph_addr_gen addr_gen (
	clk, reset, vga_blank_n, vga_vs, vga_hs,	// inputs (1-bit)
	hcount, 												// inputs (LOG2_DISPLAY_WIDTH-bit)
	vcount,												// inputs (LOG2_DISPLAY_HEIGHT-bit)
	sys_data,											// outputs (SYS_DATA_WIDTH-bit)
	glyph_addr,											// outputs (GLYPH_ADDR_WIDTH-bit)
	sys_addr,											// outputs (SYS_ADDR_WIDTH-bit)
	bg_color,											// outputs (24-bit)
	pix_en												// outputs (1-bit)
);

/***************************************************************************/
/* 		GLYPH ROM																			*/
/***************************************************************************/

defparam glyphs.DATA_WIDTH = GLYPH_DATA_WIDTH;
defparam glyphs.ADDR_WIDTH = GLYPH_ADDR_WIDTH;

glyph_rom glyphs (
	glyph_addr,		// inputs  (GLYPH_ADDR_WIDTH-bit)
	clk, 				// inputs  (1-bit)
	pixel				// outputs (GLYPH_DATA_WIDTH-bit)
);

endmodule
