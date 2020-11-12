module glyph_vga
(
	input clk, resetn,
	output vga_clk, vga_blank_n, vga_vs, vga_hs,
	output [7:0] r, g, b
);

localparam SYS_DATA_WIDTH=16, SYS_ADDR_WIDTH=16;
localparam GLYPH_DATA_WIDTH=24, GLYPH_ADDR_WIDTH=14;


wire [(SYS_DATA_WIDTH-1):0] data_a, data_b;
wire [(SYS_ADDR_WIDTH-1):0] addr_a, addr_b, q_a, q_b;
wire we_a, we_b;


defparam vga.SYS_DATA_WIDTH = SYS_DATA_WIDTH;
defparam vga.SYS_ADDR_WIDTH = SYS_ADDR_WIDTH;
defparam vga.GLYPH_DATA_WIDTH = GLYPH_DATA_WIDTH;
defparam vga.GLYPH_ADDR_WIDTH = GLYPH_ADDR_WIDTH;

vga vga (
	clk, ~resetn,									// inputs
	q_b,												// inputs  (SYS_DATA_WIDTH-bit)
	vga_clk, vga_blank_n, vga_vs, vga_hs,	// outputs (1-bit)
	r, g, b,											// outputs (8-bit)
	addr_b											// outputs (SYS_ADDR_WIDTH-bit)
);


defparam ram.DATA_WIDTH = SYS_DATA_WIDTH;
defparam ram.ADDR_WIDTH = SYS_ADDR_WIDTH;

bram ram (
	data_a, data_b,	// inputs  (SYS_DATA_WIDTH-bit)
	addr_a, addr_b,	// inputs  (SYS_ADDR_WIDTH-bit)
	we_a, we_b, clk,	// inputs  (1-bit)
	q_a, q_b				// outputs (SYS_DATA_WIDTH-bit)
);


defparam move.DATA_WIDTH = SYS_DATA_WIDTH;
defparam move.ADDR_WIDTH = SYS_ADDR_WIDTH;

movement move (
	clk, ~resetn,		// inputs  (1-bit)
	q_a,					// inputs  (SYS_DATA_WIDTH-bit)
	addr_a,				// outputs (SYS_ADDR_WIDTH-bit)
	data_a,				// outputs (SYS_DATA_WIDTH-bit)
	we_a					// outputs (1-bit)
);


endmodule
