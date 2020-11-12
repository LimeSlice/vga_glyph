module hard_coded_bitgen (
	input bright, 
	input [9:0] hcount, vcount, 
	output [23:0] rgb
);

reg [7:0] r, g, b;
assign rgb = {r,g,b};

// recall x_start = 158 = H_BACK_PORCH + H_SYNC + H_FRONT_PORCH
// 		 x_end   = 745 = H_TOTAL - H_BACK_PORCH
//        y_start = 0
//        y_end   = 480 = V_DISPLAY_INT
wire [9:0] x_pos, y_pos;
assign x_pos = hcount - 10'd158;
assign y_pos = vcount; 

always @(bright, x_pos, y_pos) begin

	{r,g,b} = 0;
	
	// can display
	if (bright) begin
	
		// draw a square
		if (x_pos >= 200 && x_pos < 400 &&
			 y_pos >= 200 && y_pos < 300)
				r = 8'd255;
				
		else if (x_pos >= 250 && x_pos < 450 &&
					y_pos >= 350 && y_pos < 450)
				g = 8'd255;
		
		// background color
		else begin
			r = 8'd255;
			g = 8'd255;
			b = 8'd255;
		end
				
	end
	
	// cannot display
	// defaulted above to {r,g,b} = 0;

end

endmodule
