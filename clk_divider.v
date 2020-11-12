module clk_divider
(
	input clk_in, reset,
	input [31:0] count,
	output reg clk_out
);

reg [31:0] counter;

always @(posedge clk_in) begin
	if (reset) begin
		counter <= 32'd0;
		clk_out <= 1'b0; 
	end
	else begin
		if (counter == count) begin
			counter <= 32'd0;
			clk_out <= ~clk_out;
		end
		else begin
			counter <= counter + 1'b1;
			clk_out <= clk_out;
		end
	end

end

endmodule
