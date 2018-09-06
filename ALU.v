`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:54:08 08/30/2011 
// Design Name: 
// Module Name:    alu 
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
module ALU( A, B, C, Opcode, Flags
    );
input [15:0] A, B;
input [7:0] Opcode;
output reg [15:0] C;
/* ZCFNL
 * 4 = Zero flag
 * 3 = carry flag
 * 2 = Overflow flag
 * 1 = Negative flag
 * 0 = Low flag
 */
output reg [4:0] Flags;

// opcode hi = 0000
parameter AND = 4'b0001;
parameter OR = 4'b0010;
parameter XOR = 4'b0011;
parameter NOT = 4'b0100;
parameter ADD = 4'b0101;
parameter ADDU = 4'b0110;
parameter ADDC = 4'b0111;

parameter SUB = 4'b1001;

parameter CMP = 4'b1011;
parameter LSHI = 4'b1100;

// opcode hi = 1000
parameter LSH = 4'b0100

// ADDI is assigned to opcode hi = 0101
// ADDUI = opcode hi 0110

// parameter ADDCU = 8'b???
// parameter ADDCUI = 8'b???? immmHi;
// parameter ADDCI = immHi;		0111
// parameter SUBI = immHi;		1001
// parameter CMPI = immHi;	1011
// parameter CMPU = 8'b???
// parameter CMPUI = 8'b??? immHi;
parameter RSH = 8'b???
parameter RSHI = 8'b???? immHi;
parameter ALSH = 8'b???
parameter ARSH = 8'b???
parameter WAIT = 8'b0000 0000;


/* We will do: ADD, ADDI, ADDU, ADDUI, ADDC, ADDCU, ADDCUI, ADDCI, SUB, SUBI, CMP, CMPI, CMPU/I, AND,
OR, XOR, NOT, LSH, LSHI, RSH, RSHI, ALSH, ARSH, NOP/WAIT      */


always @(A, B, Opcode)
begin
	case (Opcode[7:4])
		4'b0000:
			begin
			case (Opcode[3:0])
			// to the ALU, add immediate is the same as add, therefore just use fall-through
			ADDI:
			ADD:
				begin
				C = A + B;
				
				// Set the Zero flag (4)
				if (C == 16'b0000_0000_0000_0000) 
					Flags[4] = 1'b1;
				else 
					Flags[4] = 1'b0;
					
				// Set the Overflow Flag (2)
				if((~A[15] & ~B[15] & C[15]) | (A[15] & B[15] & ~C[15])) 
					Flags[2] = 1'b1;
				else Flags[2] = 1'b0;

				// Set the Carry(3), negative(1), and low(0) flags to 0
				Flags[1:0] = 2'b00; Flags[3] = 1'b0;
				end
			
			ADDUI:
			ADDU:
				begin
				// The carry flag is set with the C assignment
				{Flags[3], C} = A + B;
				
				// Set the 0 flag(4)
				if (C == 16'b0000_0000_0000_0000)
					Flags[4] = 1'b1; 
				else Flags[4] = 1'b0;
				
				// The rest of the flags will be 0
				Flags[2:0] = 3'b000;
				end
				
			// Same as add, but there is an additional carry being added to the first bit
			ADDCI
			ADDC:
				begin
				C = A + B + 1;
				
				// Set the Zero flag (4)
				if (C == 16'b0000_0000_0000_0000) 
					Flags[4] = 1'b1;
				else 
					Flags[4] = 1'b0;
					
				// Set the Overflow Flag (2)
				if((~A[15] & ~B[15] & C[15]) | (A[15] & B[15] & ~C[15])) 
					Flags[2] = 1'b1;
				else Flags[2] = 1'b0;

				// Set the Carry(3), negative(1), and low(0) flags to 0
				Flags[1:0] = 2'b00; Flags[3] = 1'b0;
				end
				
			ADDCUI:
			ADDCU:
				begin
				// The carry flag is set with the C assignment
				{Flags[3], C} = A + B + 1;
				
				// Set the zero flag(4)
				if (C == 16'b0000_0000_0000_0000) 
					Flags[4] = 1'b1; 
				else Flags[4] = 1'b0;
				
				// The rest of the flags will be 0
				Flags[2:0] = 3'b000;
				end
			
			SUBI:
			SUB:
				begin
				C = A - B;
				// Set the zero(4) flag
				if (C == 16'b0000_0000_0000_0000) 
					Flags[4] = 1'b1;
				else 
					Flags[4] = 1'b0;
				
				// Set the overflow flag (2)
				if( (~A[15] & ~B[15] & C[15]) | (A[15] & B[15] & ~C[15]) ) 
					Flags[2] = 1'b1;
				else 
					Flags[2] = 1'b0;
				
				// Set the Carry(3), negative(1), and low(0) flags to 0
				Flags[1:0] = 2'b00; Flags[3] = 1'b0;
				end
			
			CMPI:
			CMP:
				begin
				if( $signed(A) < $signed(B) ) 
					Flags[1:0] = 2'b11;
				else 
					Flags[1:0] = 2'b00;
				C = 16'b0000_0000_0000_0000;
				Flags[4:2] = 3'b000;
				
				// both positive or both negative
				if( A[15] == B[15] )
				begin
					if (A < B) 
						Flags[1:0] = 2'b11;
					else 
						Flags[1:0] = 2'b00;
				end
				
				// If A is negative, and different from B, don't set negative and low flags
				else if (A[15] == 1'b0) 
					Flags[1:0] = 2'b00;
					
				// If A is positive, and different from B, set the low flag
				else 
					Flags[1:0] = 2'b01;
				Flags[4:2] = 3'b000;
				end
			
			CMPUI:
			CMPU:
				begin
				// ...
				end
			
			AND:
				begin
				C = A & B;
				if (C == 16'b0000_0000_0000_0000)
					Flags[4] = 1'b1;
				else
					Flags[4] = 1'b0;
				// Set the carry(3), overflow(2), negative(1), and low(0) flags to 0
				Flags[3:0] = 4'b0000;
				end
				
			OR:
				begin
				C = A | B;
				if (C == 16'b0000_0000_0000_0000)
					Flags[4] = 1'b1;
				else
					Flags[4] = 1'b0;
				Flags[3:0] = 4'b0000;
				end
				
			XOR:
				begin
				C = A ^ B;
				if (C == 16'b0000_0000_0000_0000)
					Flags[4] = 1'b1;
				else
					Flags[4] = 1'b0;
				Flags[3:0] = 4'b0000;
				end
				
			NOT:
				begin
				C = ~A;
				if (C == 16'b0000_0000_0000_0000)
					Flags[4] = 1'b1;
				else
					Flags[4] = 1'b0;
				Flags[3:0] = 4'b0000;
				end
				
			LSHI:
				// Left shift of A by B bits
				begin
				C = A << B;
				if (C == 16'b0000_0000_0000_0000)
					Flags[4] = 1'b1;
				else
					Flags[4] = 1'b0;
				Flags[3:0] = 4'b0000;
				end
			LSH:
				begin
				// Left shift of A by 1 bit (no sign extension)
				C = A << 1;
				if (C == 16'b0000_0000_0000_0000)
					Flags[4] = 1'b1;
				else
					Flags[4] = 1'b0;
				Flags [3:0] = 4'b0000;
				end
				
			RSHI:
				// Right shift of A by B bits
				begin
				C = A >> B;
				if (C == 16'b0000_0000_0000_0000)
					Flags[4] = 1'b1;
				else
					Flags[4] = 1'b0;
				Flags [3:0] = 4'b0000;
				end
				
			RSH:
				begin
				// Right shift of A by 1 bit (no sign extension)
				C = A >> 1;
				if (C = 16'b0000_0000_0000_0000)
					Flags[4] = 1'b1;
				else
					Flags[4] = 1'b0;
				Flags [3:0] = 4'b0000;
				end
			
			ALSH:
				begin
				// Implement left shift of A by 1 bit (with sign extension)
				if (A[15] == 1'b1)
					begin
					C = A << 1;
					C[15] = 1'b1;
					// This result can't be zero
					Flags[4] = 1'b0;
					end
				else
					begin
					C = A << 1;
					if (C == 16'b0000_0000_0000_0000)
						Flags[4] = 1'b1;
					else
						Flags[4] = 1'b0;
					end
				Flags[3:0] = 4'b0000;
				end
				
			ARSH:
				begin
				// right shift of A by 1 bit (with sign extension)
				if (A[15] == 1'b1)
					C = A >> 1;
					begin
					C[15] = 1'b1;
					// This result can't be zero
					Flags[4] = 1'b0;
				else
					begin
					C = A >> 1;
					if (C == 16'b0000_0000_0000_0000)
						Flags[4] = 1'b1;
					else
						Flags[4] = 1'b0;
					end
				Flags[3:0] = 4'b0000;
				end
				
			NOP:
				// "No operation", keep all operators and flags the same
				begin
				C = 16'bx;
				Flags[4:0] = 5'b00000;
				end
				
			WAIT:
				// help
				begin
				
				end
				
			default: 
				begin
					C = 16'bx;
					Flags = 5'b00000;
				end
			endcase
	endcase
end

endmodule
