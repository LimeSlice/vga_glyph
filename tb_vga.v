module tb_vga;

reg clk, resetn;
wire vga_clk, vga_blank_n, vga_vs, vga_hs;
wire [7:0] r, g, b;

glyph_vga uut(
	clk, resetn,
	vga_clk, vga_blank_n, vga_vs, vga_hs,
	r, g, b
);

initial begin
	clk = 0;
	resetn = 1; #2;
	resetn = 0; #10;
	resetn = 1; #10;
end

always #5 clk = ~clk;

endmodule
