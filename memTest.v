`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   9/6/2018
// Design Name:   mem Test
// Module Name:   
// Project Name:  ECE3700Project
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mem
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module memTest;
	parameter DATA_WIDTH = 16;
	parameter ADDR_WIDTH = 6;
	reg [(DATA_WIDTH-1):0] data;
	reg [(ADDR_WIDTH-1):0] read_addr, write_addr;
	reg we, clk;
	wire [(DATA_WIDTH-1):0] out;
	
	// Instantiate the Unit Under Test (UUT)
	mem #(
		.DATA_WIDTH(DATA_WIDTH),
		.ADDR_WIDTH(ADDR_WIDTH)
		) uut (
		.data(data), 
		.read_addr(read_addr), 
		.write_addr(write_addr), 
		.we(we), 
		.clk(clk),
		.q(out)
	);

	
      
endmodule

