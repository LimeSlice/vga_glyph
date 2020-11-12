module bitgen 
#(parameter DATA_WIDTH=24)
(
	input bright, pix_en,
	input [(DATA_WIDTH-1):0] pixel, 
	input [23:0] bg_color,
	output reg [23:0] rgb
);

always @(bright, pixel, bg_color, pix_en) begin

	if (bright) begin
	
		// check if valid pixel even sent
		if (pix_en) begin
			
			// check for transparency bit -- h000000
			if (pixel == 24'h000000)
				rgb = bg_color;
			
			else
				rgb = pixel;
				
		end
		
		else rgb = bg_color;
		
	end
	
	// can't actually display anything
	else rgb = 0;

end

endmodule
