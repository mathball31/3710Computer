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
 * 3 = carry flag
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
	begin
//			$monitor("A: %0d, B: %0d, C: %0d, Flags[1:0]:
//%b, time:%0d", A, B, C, Flags[1:0], $time );
//Instead of the $display stmt in the loop, you could use just this
//monitor statement which is executed everytime there is an event on any
//signal in the argument list.

		// Initialize Inputs
		A = 0;
		B = 0;

		// Wait 100 ns for global reset to finish
/*****
		// One vector-by-vector case simulation
		#10;
	        Opcode = 2'b11;
		A = 4'b0010; B = 4'b0011;
		#10
		A = 4'b1111; B = 4'b 1110;
		//$display("A: %b, B: %b, C:%b, Flags[1:0]: %b, time:%d", A, B, C, Flags[1:0], $time);
****/
			// random simulation
			for (i = 0; i < 1000; i = 1+1)
			begin
				#10;
				A = $random % 1000;
				B = $random % 1000;
				expectedC = 16'bx;
				expectedFlags = 5'bx;

				//check all opcodes
				for( Opcode = 0; Opcode < 4'b1111; Opcode = Opcode+1)
				begin
					#10;
					expectedC = 16'bx;
					expectedFlags = 5'bx;
					
					//check first half of Opcode
					case (Opcode[7:4])
						//basic ops
						4'b0000:
						begin
							case (Opcode[3:0])
								AND:
								begin
									//test value
									expectedC = A & B;
									if (C != expectedC)
									begin
										$display ("ERROR at time: %d", $time);
										$display ("Expected value: %d, Actual Value: %d", expectedC, C);
									end
									//test flags
									expectedFlags = {(C == 16'b0000_0000_0000_0000), 4'b000};
									if (Flags != expectedFlags)
									begin
										$display ("ERROR at time: %d", $time);
										$display ("Expected value: %d, Actual Value: %d", expectedFlags, Flags);
									end
								end
								
								OR:
								begin
								end
								
								XOR:
								begin
								end
								
								NOT:
								begin
								end
								
								ADD:
								begin
								end
								
								ADDU:
								begin
								end
								
								ADDC:
								begin
								end
								
								ADDCU:
								begin
								end
								
								SUB:
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
						end
						
					//Opcode First Half
					endcase
				//for Opcode
				end
			//for i to 1000
			end

				
				
				
		/*		
		//Random simulation
		for( i = 0; i< 10; i = i+ 1)
		begin
			#10
			A = $random % 1000;
			B = $random % 1000;
			$display("A: %0d, B: %0d, C: %0d, Flags[1:0]: %b, time:%0d", A, B, C, Flags[1:0], $time );
		end
		$finish(2);
		
		// Add stimulus here
		*/
	// initial
	end
      
endmodule

