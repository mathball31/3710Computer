`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:30:00 09/13/2018
// Design Name: 
// Module Name:    datapath
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

module datapath(Opcode, Cin, RegEnable, Clk, Reset, Flags, AluBus); // needs output -- Michelle
	input [15:0] Opcode, RegEnable;
		// Opcode: [15:12], [7:4] = operation code for ALU
		//				[11:8] = number for input A
		//				[3:0] = number for input B
	
	input Clk, Cin, Reset;
	// add output
	
	output [4:0] Flags;
	output [15:0] AluBus;
	
	wire [15:0] r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15;
	wire [15:0] muxAout, muxBout;

	RegBank regFile(AluBus, r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, RegEnable, Clk, Reset);

	Mux muxA(r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, Opcode[11:8], muxAout);

	Mux muxB(r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, Opcode[3:0], muxBout);

	ALU alu(muxAout, muxBout, AluBus, {Opcode[15:12], Opcode[7:4]}, Flags, Cin);

endmodule


module Mux(r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, regNum, out);

	input [15:0] r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15;
	input [3:0] regNum;
	output reg [15:0] out;
	
	always @(regNum)
	begin
		case (regNum)
			0: out = r0;
			1: out = r1;
			2: out = r2;
			3: out = r3;
			4: out = r4;
			5: out = r5;
			6: out = r6;
			7: out = r7;
			8: out = r8;
			9: out = r9;
			10: out = r10;
			11: out = r11;
			12: out = r12;
			13: out = r13;
			14: out = r14;
			15: out = r15;			
		
		endcase
	end

endmodule
