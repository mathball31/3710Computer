`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   9/6/2018
// Design Name:   alu Test
// Module Name:   
// Project Name:  ALU
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: alu
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module FSMTestbench;

	// Inputs
	reg clk, reset;
	
	// Outputs
	wire [27:0] display;  // This will obviously not be needed for the testbench, only for the board
	wire [15:0] rout;
	wire [3:0] state;
	
	integer i;
	
	// Instantiate the Unit Under Test (UUT)
	FSMForRegFileTest uut (
		.clk(clk),
		.reset(reset),
		.display(display),
		.rout(rout),
		.state(state)
	);

	always
	begin
		#5 clk = ~clk;
	end
	
	// Initialize Inputs
	
	
	initial 
	begin
		// wait 100 nanoseconds for the global reset to finish
		#100;
		clk = 1;
		reset = 0;
		
		for (i = 0; i <= 30; i = i + 1)
		begin
			$display("state = %b   rout = %b  ", state, rout);
			#5;
		end
	end
      
endmodule

