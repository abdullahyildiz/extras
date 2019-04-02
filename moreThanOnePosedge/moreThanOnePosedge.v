`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:00:11 11/28/2018 
// Design Name: 
// Module Name:    moreThanOnePosedge 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module moreThanOnePosedge_rtl(clk, a, b, c, d, out
    );
	input clk, a, b, c, d;
	output reg [2:0] out;
	reg [1:0] tmp;
	
	always begin
	  @(posedge clk);
			tmp <= a + b;
      @(posedge clk);
			tmp <= tmp + c;
	  @(posedge clk);
			out <= tmp + d;
	end

endmodule
