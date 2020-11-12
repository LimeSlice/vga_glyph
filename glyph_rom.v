/** Supported Memory Block Configurations for Cyclone V Devices
  *
  * 397 M10K blocks available
  *
  * Each block can be configured as:
  *		Depth (bits)	| 	Programmable Width
  *			256			|		x40 or x32
  *			512			|		x20 or x16
  *			 1k			|		x10 or x8
  *			 2k			|		 x5 or x4
  *			 4k			|			 x2
  *			 8k			|			 x1
  */
module glyph_rom
// will technically be x40 or x32
#(parameter DATA_WIDTH=24, ADDR_WIDTH=8)
(
	input [(ADDR_WIDTH-1):0] addr,
	input clk, 
	output reg [(DATA_WIDTH-1):0] q
);

reg [(DATA_WIDTH-1):0] rom [((2**ADDR_WIDTH)-1):0];

initial
begin
	$readmemh("C:\\Users\\Kris\\Desktop\\ECE 3710\\vga\\glyphs.hex", rom);
end

always @(posedge clk)
	q <= rom[addr];

endmodule
