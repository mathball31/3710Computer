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
module alu( A, B, C, Opcode, Flags
    );
input [15:0] A, B;
input [1:0] Opcode;
output reg [15:0] C;
output reg [4:0] Flags;

parameter ADDU = 2'b00;
parameter ADD = 2'b01;
parameter SUB = 2'b10;
parameter CMP = 2'b11;

always @(A, B, Opcode)
begin
	case (Opcode)
	ADDU:
		begin
		{Flags[3], C} = A + B;
		// perhaps if ({Flags[3], C} == 5'b00000) ....
		if (C == 16'b000000000000) Flags[4] = 1'b1; 
		else Flags[4] = 1'b0;
		Flags[2:0] = 3'b000;
		end
	ADD:
		begin
		C = A + B;
		if (C == 16'b000000000000) Flags[4] = 1'b1;
		else Flags[4] = 1'b0;
		if( (~A[15] & ~B[15] & C[15]) | (A[15] & B[15] & ~C[15]) ) Flags[2] = 1'b1;
		else Flags[2] = 1'b0;
		Flags[1:0] = 2'b00; Flags[3] = 1'b0;

		end
	SUB:
		begin
		C = A - B;
		if (C == 16'b000000000000) Flags[4] = 1'b1;
		else Flags[4] = 1'b0;
		if( (~A[15] & ~B[15] & C[15]) | (A[15] & B[15] & ~C[15]) ) Flags[2] = 1'b1;
		else Flags[2] = 1'b0;
		Flags[1:0] = 2'b00; Flags[3] = 1'b0;
		end
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
		
		// C = ?? if I don;t specify, then I'm in trouble.
		C = 16'b000000000000;
		end
	default: 
		begin
			C = 16'b000000000000;
			Flags = 5'b00000;
		end
	endcase
end

endmodule
