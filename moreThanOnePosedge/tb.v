module tb;

reg clk;
reg  a, b, c, d;

wire [2:0] out_rtl, out_gl;

moreThanOnePosedge_rtl uut_rtl(clk, a, b, c, d, out_rtl);
moreThanOnePosedge_gl uut_gl(clk, a, b, c, d, out_gl);

initial begin
	$dumpvars;
	a = 1;
	b = 1;
	c = 1;
	d = 1;

	repeat (20) @(negedge clk);
	$finish;

end

initial begin
	clk = 0;
	forever
		#5 clk = ~clk;
end		

endmodule