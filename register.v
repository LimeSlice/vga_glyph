module register
#(parameter WIDTH = 8)
(
	input clk, reset, en,
	input [(WIDTH-1):0] d,
	output reg [(WIDTH-1):0] q
);

always @(posedge clk) begin

	if (reset) 		q <= 'd0;
	else if (en) 	q <= d;
	else 				q <= q;

end

endmodule
