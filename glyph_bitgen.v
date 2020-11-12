module glyph_bitgen 
#(parameter DATA_WIDTH=64, ADDR_WIDTH=12)
(
	input bright,
	input [(DATA_WIDTH-1):0] data,
	input [9:0] hcount, vcount, x_start, y_start,
	input [23:0] rgb_in,
	output reg [23:0] rgb_out
);

// recall x_start = 158 = H_BACK_PORCH + H_SYNC + H_FRONT_PORCH
// 		 x_end   = 745 = H_TOTAL - H_BACK_PORCH
//        y_start = 0
//        y_end   = 480 = V_DISPLAY_INT
wire [9:0] x_pos, y_pos;
assign x_pos = hcount - 10'd158;
assign y_pos = vcount;

wire [9:0] x_end, y_end;

assign x_end = x_start + 10'd8;
assign y_end = y_start + 10'd8;

wire [0:7] glyph [0:7];
assign glyph[0] = data[63:56];
assign glyph[1] = data[55:48];
assign glyph[2] = data[47:40];
assign glyph[3] = data[39:32];
assign glyph[4] = data[31:24];
assign glyph[5] = data[23:16];
assign glyph[6] = data[15:8];
assign glyph[7] = data[7:0];

always @* begin

	rgb_out = 24'hffffff;
	
	if (bright) begin
	
		if ((x_pos >= x_start) && (x_pos < x_end)) begin
			if ((y_pos >= y_start) && (y_pos < y_end)) begin
				if (glyph[y_pos - y_start][x_pos - x_start]) begin
					rgb_out = rgb_in;
				end
			end
		end
	
	end

end

endmodule
