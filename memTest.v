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
// Verilog Test Fixture created for module: mem
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
	parameter ADDR_WIDTH = 10;
	reg [(DATA_WIDTH-1):0] data;
	reg [(ADDR_WIDTH-1):0] read_addr, write_addr;
	reg we, clk;
	reg [3:0] state;
	wire [(DATA_WIDTH-1):0] out;
	reg [(DATA_WIDTH-1):0] expected_out;
	
	event terminate_sim;
	event checkResult;
	reg error;
	
	// Instantiate the Unit Under Test (UUT)
	mem uut (
		.data(data), 
		.read_addr(read_addr), 
		.write_addr(write_addr), 
		.we(we), 
		.clk(clk),
		.q(out)
	);
	
	//check results
	always @(checkResult) 
	begin
		if (out !== expected_out)
		begin
			$display ("ERROR at time: %d, state: %d", $time, state);
			$display ("read_addr: %h, %b; write_addr: %h, %b", read_addr, read_addr, write_addr, write_addr);
			$display ("Expected value: %d, %b; Actual Value: %d, %b, data: %d, %b", expected_out, expected_out, out, out, data, data);
			error = 1;
			#5 -> terminate_sim;
		end
	end
	
		
	initial @(terminate_sim) 
	begin
		$display("Terminating simulation");
		if (error == 0)
		begin
			$display("Simulation Result: PASSED");
		end
		else begin
			$display("Simulation Result: FAILED");
		end
		#1 $finish;
	end
	
	integer i;

	initial
	begin
		#5;
		data = 0;
		read_addr = 0;
		write_addr = 0;
		we = 0;
		clk = 1;
		state = 0;
		
		for (i = 0; i <= 70; i = i + 1)
		begin
			clk = ~clk;
			$display("state = %b   out = %b  ", state, out);
			#5;
		end
	end
	
	
	always @(posedge clk)
	begin
		
		case (state)
			0:
			begin
				we = 1;
				data = 16'b1;
				write_addr = 10'b0;
			end
			1:
			begin
				we = 0;
				read_addr = 10'b0;
			end
			2:
			begin
				expected_out =  16'b1;
				#5-> checkResult;
			end
			3:
			begin
			
			end
			4:
			begin
			
			end
			5:
			begin
			
			end
		endcase
		
		state = state + 4'b0001;
	end
	
      
endmodule

