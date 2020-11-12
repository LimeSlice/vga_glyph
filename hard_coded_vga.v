module hard_coded_vga
(
	input clk, resetn,
	output vga_clk, vga_blank_n, vga_vs, vga_hs,
	output [7:0] r, g, b
);

wire [9:0] hcount, vcount;

vga_control #(10,10) ctrl (
	clk, ~resetn,				// inputs  (1-bit)			
	vga_hs, vga_vs,			// outputs (1-bit)
	vga_blank_n, vga_clk,	// outputs (1-bit)
	hcount,						// outputs (LOG2_DISPLAY_WIDTH-bit) 
	vcount						// outputs (LOG2_DISPLAY_HEIGHT-bit)
);

hard_coded_bitgen bitgen (
	vga_blank_n, 
	hcount, vcount, 
	{r,g,b}
);

endmodule
