module pulse
(
	input clk, reset,
	input [31:0] length1, length2,
	output reg pulse
);

reg [31:0] counter;

always @(posedge clk) begin
	if (reset) begin
		counter <= 32'd0;
		pulse <= 1'b0;
	end
	else begin
		if (pulse) begin
			if (counter == length1) begin
				counter <= 32'd0;
				pulse <= 0;
			end
			else begin
				counter <= counter + 1'b1;
				pulse   <= pulse;
			end
		end
		else begin
			if (counter == length2) begin
				counter <= 32'd0;
				pulse   <= 1'b1;
			end
			else begin
				counter <= counter + 1'b1;
				pulse   <= pulse;
			end
		end
	end

end

endmodule
