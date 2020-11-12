module vga_control 
#(parameter LOG2_DISPLAY_WIDTH=10, LOG2_DISPLAY_HEIGHT=10)
(
	input	clk, rst,
	output hsync, vsync,
	output reg vga_blank_n, vga_clk,
	output reg [(LOG2_DISPLAY_WIDTH-1):0] hcount, 
	output reg [(LOG2_DISPLAY_HEIGHT-1):0] vcount
);

// parameters for a VGA 640 x 480 (60Hz) display
// dropping our 50MHz clock to a 25MHz pixel clock

localparam H_SYNC        = 10'd96;  // 3.8us  -- 25.175M * 3.8u  = 95.665
localparam H_FRONT_PORCH = 10'd16;  // 0.6us  -- 25.175M * 0.6u  = 15.105
localparam H_DISPLAY_INT = 10'd640; // 25.4us -- 25.175M * 25.4u = 639.445
localparam H_BACK_PORCH  = 10'd48;  // 1.9us  -- 25.175M * 1.9u  = 47.8325
localparam H_TOTAL       = 10'd800; // total width -- 96 + 16 + 640 + 48 = 800

localparam V_SYNC        = 10'd2;   // 2 lines
localparam V_BACK_PORCH  = 10'd33;  // 33 lines
localparam V_DISPLAY_INT = 10'd480; // 480 lines
localparam V_FRONT_PORCH = 10'd10;  // 10 lines
localparam V_TOTAL       = 10'd525; // total width -- 2 + 33 + 480 + 10 = 525

assign hsync = ~((hcount >= H_FRONT_PORCH) & (hcount < H_FRONT_PORCH + H_SYNC));
assign vsync = ~((vcount >= V_DISPLAY_INT + V_FRONT_PORCH) & (vcount < V_DISPLAY_INT + V_FRONT_PORCH + V_SYNC));


always @(posedge clk) begin
	
	if (rst) begin
		vcount  <= 10'd0;
		hcount  <= 10'd0;
		vga_clk <= 1'b0;
	end
	
	else begin
		if (vga_clk) begin
			hcount <= hcount + 1'b1;
			
			// clear if reaches end
			if (hcount == H_TOTAL) begin
				hcount <= 10'd0;
				vcount <= vcount + 1'b1;
				
				if (vcount == V_TOTAL)
					vcount <= 10'd0;
			end
		end
		vga_clk <= ~vga_clk; // generates 25MHz vga_clk
	end
end

always @(hcount,vcount) begin
	
	// bright
	if ((hcount >= H_FRONT_PORCH + H_SYNC + H_BACK_PORCH) &&
		 (hcount < H_TOTAL - H_FRONT_PORCH) &&
		 (vcount < V_DISPLAY_INT))
		 vga_blank_n = 1'b1;
	 
	 else 
		vga_blank_n = 1'b0;
		
end

endmodule
