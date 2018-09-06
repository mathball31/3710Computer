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

parameter ADD = 8'b0000 0101;
parameter ADDI = 8'b0101 immHi;
parameter ADDU = 8'b0000 0110;
parameter ADDUI = 8'b0110 imm;
parameter ADDC = 8'b0000 0111;
parameter ADDCU = 8'b???
parameter ADDCUI = 8'b???? immmHi;
parameter ADDCI = 8'b0111 immHi;
parameter SUB = 8'b0000 1001;
parameter SUBI = 8'b1001 immHi;
parameter CMP = 8'b0000 1011;
parameter CMPI = 8'b1011 immHi;
parameter CMPU = 8'b???
parameter CMPUI = 8'b??? immHi;
parameter AND = 8'b0000 0001;
parameter OR = 8'b0000 0010;
parameter XOR = 8'b0000 0011;
parameter NOT = 8'b???
parameter LSH = 8'b1000 0100
parameter LSHI = 8'b0000 1100;
parameter RSH = 8'b???
parameter RSHI = 8'b???? immHi;
parameter ALSH = 8'b???
parameter ARSH = 8'b???
parameter NOP = 8'b???
parameter WAIT = 8'b0000 0000;


/* We will do: ADD, ADDI, ADDU, ADDUI, ADDC, ADDCU, ADDCUI, ADDCI, SUB, SUBI, CMP, CMPI, CMPU/I, AND,
OR, XOR, NOT, LSH, LSHI, RSH, RSHI, ALSH, ARSH, NOP/WAIT      */



always @(A, B, Opcode)
begin
	case (Opcode)
	
	// to the ALU, add immediate is the same as add, therefore just use fall-through
	ADDI:
	ADD:
		begin
		C = A + B;
		
		// Set the Zero flag (4)
		if (C == 16'b000000000000) 
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
		if (C == 16'b000000000000) Flags[4] = 1'b1; 
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
		if (C == 16'b000000000000) 
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
		if (C == 16'b000000000000) Flags[4] = 1'b1; 
		else Flags[4] = 1'b0;
		
		// The rest of the flags will be 0
		Flags[2:0] = 3'b000;
		end
	
	SUBI:
	SUB:
		begin
		C = A - B;
		// Set the zero(4) flag
		if (C == 16'b000000000000) Flags[4] = 1'b1;
		else Flags[4] = 1'b0;
		
		// Set the overflow flag (2)
		if( (~A[15] & ~B[15] & C[15]) | (A[15] & B[15] & ~C[15]) ) Flags[2] = 1'b1;
		else Flags[2] = 1'b0;
		
		// Set the Carry(3), negative(1), and low(0) flags to 0
		Flags[1:0] = 2'b00; Flags[3] = 1'b0;
		end
	
	CMPI:
	CMP:
		begin
		if( $signed(A) < $signed(B) ) Flags[1:0] = 2'b11;
		else Flags[1:0] = 2'b00;
		C = 16'b000000000000;
		Flags[4:2] = 3'b000;
		// both positive or both negative
		if( A[15] == B[15] )
		begin
			if (A < B) Flags[1:0] = 2'b11;
			else Flags[1:0] = 2'b00;
		end
		else if (A[3] == 1'b0) Flags[1:0] = 2'b00;
		else Flags[1:0] = 2'b01;
		Flags[4:2] = 3'b000;
		
		C = 16'b000000000000;
		end
	
	CMPUI:
	CMPU:
		begin
		// ...
		end
	
	AND:
		begin
		// ...
		end
	OR:
		begin
		// ...
		end
	XOR:
		begin
		// ...
		end
	NOT:
		begin
		// ...
		end
		
	LSHI:
	LSH:
		begin
		// ...
		end
		
	RSHI:
	RSH:
		begin
		// ...
		end

		
	default: 
		begin
			C = 16'b000000000000;
			Flags = 5'b00000;
		end
	endcase
end

endmodule
