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

module ALUtest;

	// Inputs
	reg [15:0] A;
	reg [15:0] B;
	reg [7:0] Opcode;

	// Outputs
	wire [15:0] C;
	/* ZCFNL
 * 4 = Zero flag
 * 3 = Carry flag
 * 2 = Overflow flag
 * 1 = Negative flag
 * 0 = Low flag
 */
	wire [4:0] Flags;
	// opcode hi = 0000
	parameter AND = 4'b0001;
	parameter OR = 4'b0010;
	parameter XOR = 4'b0011;
	parameter NOT = 4'b0100;
	parameter ADD = 4'b0101;
	parameter ADDU = 4'b0110;
	parameter ADDC = 4'b0111;
	parameter ADDCU = 4'b1000;
	parameter SUB = 4'b1001;
	// 4'b1010
	parameter CMP = 4'b1011;
	parameter CMPU = 4'b1111;
	// 4'b1100, 4'b1101, and 4'b1110

	// opcodes 4'b0001-4'b0100 can be used (?)

	// opcode hi = 1000
	parameter LSHI = 4'b0000;		// can also be 0001
	parameter LSH = 4'b0100;

	// opcode hi = 1001 = SUBI
	// ONLY assign 1001 to SUBI - the last 4 bits of opcode will be used for the immediate add operation

	// opcode hi = 1011 = CMPI
	// ONLY assign 1011 to CMPI - the last 4 bits of opcode will be used for the immediate add operation

	/*
	parameter ADDCUI = 8'b???? immHi;
	parameter CMPI = immHi;	1011
	parameter CMPUI = 8'b??? immHi;
	parameter RSH = 8'b???
	parameter RSHI = 8'b???? immHi;
	parameter ALSH = 8'b???
	parameter ARSH = 8'b???
	*/

	/* We will do: ADD, ADDI, ADDU, ADDUI, ADDC, ADDCU, ADDCUI, ADDCI, SUB, SUBI, CMP, CMPI, CMPU/I, AND,
	OR, XOR, NOT, LSH, LSHI, RSH, RSHI, ALSH, ARSH, NOP/WAIT      */

	event terminate_sim;
	reg error;
	integer i;
	reg [15:0] expectedC;
	reg [4:0] expectedFlags;
	
	// Instantiate the Unit Under Test (UUT)
	ALU uut (
		.A(A), 
		.B(B), 
		.C(C), 
		.Opcode(Opcode), 
		.Flags(Flags)
	);

	initial
	@ (terminate_sim) begin
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
	
	initial 
	begin
//			$monitor("A: %0d, B: %0d, C: %0d, Flags[1:0]:
//%b, time:%0d", A, B, C, Flags[1:0], $time );
//Instead of the $display stmt in the loop, you could use just this
//monitor statement which is executed everytime there is an event on any
//signal in the argument list.

		// Initialize Inputs
		A = 0;
		B = 0;
		Opcode = 0;

			// random simulation
			for (i = 0; i < 10; i = 1+1)
			begin
				#10;
				A = $random % 1000;
				B = $random % 1000;
				expectedC = 16'bx;
				expectedFlags = 5'bx;

				//check all opcodes
				for( Opcode = 0; Opcode < 8'b1111111; Opcode = Opcode+1)
				begin
					#10;
					expectedC = 16'bx;
					expectedFlags = 5'bx;
					
					// check first half of Opcode
					case (Opcode[7:4])
						// basic ops
						4'b0000:
						begin
							case (Opcode[3:0])
								AND:
								begin
									// test value
									// expectedC is the value that the ALU *SHOULD* put in C
									expectedC = A & B; 
									// If C is not the expected value, print helpful information and terminate
									if (C != expectedC)
									begin
										$display ("ERROR at time: %d", $time);
										$display ("Expected value: %d, Actual Value: %d, Opcode: %b", expectedC, C, Opcode);
										#5 -> terminate_sim;
									end
									// test flags
									// same with above but for flags
									expectedFlags = {(C == 16'b0000_0000_0000_0000), 4'b0000};
									if (Flags != expectedFlags)
									begin
										$display ("ERROR at time: %d", $time);										
										$display ("Expected value: %d, Actual Value: %d, Opcode: %b", expectedC, C, Opcode);
										$display ("Expected flag %b, Actual flag %b", expectedFlags, Flags);
										#5 -> terminate_sim;
									end
								end
								
								OR:
								begin
									expectedC = A | B; 
									// If C is not the expected value, print helpful information and terminate
									if (C != expectedC)
									begin
										$display ("ERROR at time: %d", $time);
										$display ("Expected value: %d, Actual Value: %d, Opcode: %b", expectedC, C, Opcode);
										#5 -> terminate_sim;
									end
									
									expectedFlags = {(C == 16'b0000_0000_0000_0000), 4'b0000};
									if (Flags != expectedFlags)
									begin
										$display ("ERROR at time: %d", $time);										
										$display ("Expected value: %d, Actual Value: %d, Opcode: %b", expectedC, C, Opcode);
										$display ("Expected flag %b, Actual flag %b", expectedFlags, Flags);
										#5 -> terminate_sim;
									end
								end
								
								XOR:
								begin
									expectedC = A ^ B; 
									// If C is not the expected value, print helpful information and terminate
									if (C != expectedC)
									begin
										$display ("ERROR at time: %d", $time);
										$display ("Expected value: %d, Actual Value: %d, Opcode: %b", expectedC, C, Opcode);
										#5 -> terminate_sim;
									end
									
									expectedFlags = {(C == 16'b0000_0000_0000_0000), 4'b0000};
									if (Flags != expectedFlags)
									begin
										$display ("ERROR at time: %d", $time);										
										$display ("Expected value: %d, Actual Value: %d, Opcode: %b", expectedC, C, Opcode);
										$display ("Expected flag %b, Actual flag %b", expectedFlags, Flags);
										#5 -> terminate_sim;
									end
								end
								
								NOT:
								begin
									expectedC = ~A; 
									// If C is not the expected value, print helpful information and terminate
									if (C != expectedC)
									begin
										$display ("ERROR at time: %d", $time);
										$display ("Expected value: %d, Actual Value: %d, Opcode: %b", expectedC, C, Opcode);
										#5 -> terminate_sim;
									end
									
									expectedFlags = {(C == 16'b0000_0000_0000_0000), 4'b0000};
									if (Flags != expectedFlags)
									begin
										$display ("ERROR at time: %d", $time);										
										$display ("Expected value: %d, Actual Value: %d, Opcode: %b", expectedC, C, Opcode);
										$display ("Expected flag %b, Actual flag %b", expectedFlags, Flags);
										#5 -> terminate_sim;
									end
								end
								
								ADD:
								begin
									expectedC = A + B;
									if (C != expectedC)
									begin
										$display ("ERROR at time: %d", $time);
										$display ("Expected value: %d, Actual Value: %d, Opcode: %b", expectedC, C, Opcode);
										#5 -> terminate_sim;
									end
									
									expectedFlags[4] = (C == 16'b0000_0000_0000_0000);
									// Check for overflow
									expectedFlags[2] = ((~A[15] && ~B[15] && C[15]) || (A[15] && B[15] && ~C[15]));
									// Set the Carry(3), negative(1), and low(0) flags to 0
									expectedFlags[1:0] = 2'b00; expectedFlags[3] = 1'b0;
									if (Flags != expectedFlags)
									begin
										$display ("ERROR at time: %d", $time);										
										$display ("Expected value: %d, Actual Value: %d, Opcode: %b", expectedC, C, Opcode);
										$display ("Expected flag %b, Actual flag %b", expectedFlags, Flags);
										#5 -> terminate_sim;
									end									
								end
								
								ADDU:
								begin
									expectedC = A + B; 
									if (C != expectedC)
									begin
										$display ("ERROR at time: %d", $time);
										$display ("Expected value: %d, Actual Value: %d, Opcode: %b", expectedC, C, Opcode);
										#5 -> terminate_sim;
									end
									
									expectedFlags = {(C == 16'b0000_0000_0000_0000), (A + B), 3'b000}; // why setting [3] this way? --Michelle
									if (Flags != expectedFlags)
									begin
										$display ("ERROR at time: %d", $time);										
										$display ("Expected value: %d, Actual Value: %d, Opcode: %b", expectedC, C, Opcode);
										$display ("Expected flag %b, Actual flag %b", expectedFlags, Flags);
										#5 -> terminate_sim;
									end	
								end
								
								ADDC:
								begin
									expectedC = A + B + 1;
									if (C != expectedC)
									begin
										$display ("ERROR at time: %d", $time);
										$display ("Expected value: %d, Actual Value: %d, Opcode: %b", expectedC, C, Opcode);
										#5 -> terminate_sim;
									end
									
									expectedFlags[4] = (C == 16'b0000_0000_0000_0000);
									// Check for overflow
									expectedFlags[2] = ((~A[15] && ~B[15] && C[15]) || (A[15] && B[15] && ~C[15]));
									expectedFlags[1:0] = 2'b00; expectedFlags[3] = A + B + 1; // Why setting [3] this way? --Michelle
									if (Flags != expectedFlags)
									begin
										$display ("ERROR at time: %d", $time);										
										$display ("Expected value: %d, Actual Value: %d, Opcode: %b", expectedC, C, Opcode);
										$display ("Expected flag %b, Actual flag %b", expectedFlags, Flags);
										#5 -> terminate_sim;
									end	
								end
								
								ADDCU:
								begin
									{expectedFlags[3], expectedC} = A + B + 1;
									if (C != expectedC)
									begin
										$display ("ERROR at time: %d", $time);
										$display ("Expected value: %d, Actual Value: %d, Opcode: %b", expectedC, C, Opcode);
										#5 -> terminate_sim;
									end
									
									expectedFlags[4] = (C == 16'b0000_0000_0000_0000);
									expectedFlags[2:0] = 3'b000;
									if (Flags != expectedFlags)
									begin
										$display ("ERROR at time: %d", $time);										
										$display ("Expected value: %d, Actual Value: %d, Opcode: %b", expectedC, C, Opcode);
										$display ("Expected flag %b, Actual flag %b", expectedFlags, Flags);
										#5 -> terminate_sim;
									end	
								end
								
								SUB:
								begin
									expectedC = A - B;
									if (C != expectedC)
									begin
										$display ("ERROR at time: %d", $time);
										$display ("Expected value: %d, Actual Value: %d, Opcode: %b", expectedC, C, Opcode);
										#5 -> terminate_sim;
									end
									
									expectedFlags[4] = (C == 16'b0000_0000_0000_0000);
									// Check for overflow
									expectedFlags[2] = ((~A[15] && ~B[15] && C[15]) || (A[15] && B[15] && ~C[15]));
									// Set the Carry(3), negative(1), and low(0) flags to 0
									expectedFlags[1:0] = 2'b00; expectedFlags[3] = 1'b0;
								end
								
								CMP:
								begin
								
								end
								
								CMPU:
								begin
								
								end
							//Opcode Second Half
							endcase
						end
						
						// ADDI
						4'b0101:
						begin
							// reserved for ADDI, add immediate, ONLY
							// that way, when this is called, ALU knows immediately that it just wants to do an add immediate
							// concatenate (sp?) the last 4 bits of opcode with the last 4 bits of B in a temporary register
						end
						
						// ADDUI
						4'b0110:
						begin
							// for ADDUI, add unsigned immediate
							// just like above in ADDI, except for unsigned integers
						end
						
						// ADDCI	
						4'b0111:
						begin
							// ADDCI, add with a carry and an immediate (?)
							// same as the previous two cases, except with a carry
						end
						
						// Shifts
						4'b1000:
						begin
							// opcode is for ALL shifts
							case (Opcode[3:0])
								LSHI:
								// Left shift of A by B bits
								begin
									expectedC = A << B;
									if (C != expectedC)
									begin
										$display ("ERROR at time: %d", $time);
										$display ("Expected value: %d, Actual Value: %d, Opcode: %b", expectedC, C, Opcode);
										#5 -> terminate_sim;
									end
									
									expectedFlags = {(C == 16'b0000_0000_0000_0000), 4'b0000};
									if (Flags != expectedFlags)
									begin
										$display ("ERROR at time: %d", $time);										
										$display ("Expected value: %d, Actual Value: %d, Opcode: %b", expectedC, C, Opcode);
										$display ("Expected flag %b, Actual flag %b", expectedFlags, Flags);
										#5 -> terminate_sim;
									end
								end
								LSH:
								begin
									// Left shift of A by 1 bit (no sign extension)
									expectedC = A << 1;
									if (C != expectedC)
									begin
										$display ("ERROR at time: %d", $time);
										$display ("Expected value: %d, Actual Value: %d, Opcode: %b", expectedC, C, Opcode);
										#5 -> terminate_sim;
									end
									
									expectedFlags = {(C == 16'b0000_0000_0000_0000), 4'b0000};
									if (Flags != expectedFlags)
									begin
										$display ("ERROR at time: %d", $time);										
										$display ("Expected value: %d, Actual Value: %d, Opcode: %b", expectedC, C, Opcode);
										$display ("Expected flag %b, Actual flag %b", expectedFlags, Flags);
										#5 -> terminate_sim;
									end
								end					
						
						// For shift cases
						endcase
					// For shifts
					end
				
				// Opcode First Half
				endcase
				
			// for Opcode
			end
				
		// for i to 1000
		end
		
	// initial
	end
      
endmodule

