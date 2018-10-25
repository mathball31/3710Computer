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
/*
This module handles the interactions between the ALU and register file.
*/
module datapath(Opcode, Cin, Clk, Reset, Flags, AluBus);
	input [15:0] Opcode;
		// Opcode: [15:12], [7:4] = operation code for ALU
		//				[11:8] = number for input A (dest)
		//				[3:0] = number for input B
	
	input Clk, Cin, Reset;
	// add output
	
	output [4:0] Flags;
	output [15:0] AluBus;
	
	wire [15:0] r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15;
	wire [15:0] muxAout, muxBout;
	wire [15:0] RegEnable;		// output of the Mux4to16 module, to be put into RegBank
	
	Mux4to16 regEnable(Opcode[11:8], RegEnable);
	
	RegBank regFile(AluBus, r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, RegEnable, Clk, Reset);

	RegMux muxA(r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, Opcode[11:8], muxAout);

	RegMux muxB(r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, Opcode[3:0], muxBout);
	
	ALU alu(muxAout, muxBout, AluBus, Opcode, Flags, Cin);
	
	//programCounter(Clk, Reset, 

endmodule
/*
module programCounter(Clk, Reset, pc_en, pc_ld, pc_in, pc_out);
	input Clk, Reset, pc_en, pc_ld;
	input [9:0] pc_in;
	output reg [9:0] pc_out;
	
	always @ (posedge Clk)
	begin
		if (pc_en)
		begin
			if (pc_ld)
			begin
				pc_out = pc_in;
			end
			else
			begin
				pc_out = pc_out + 1;
			end
		end
		else
		begin
			pc_out = pc_out;
		end
		else if (Reset) 
		begin
			pc_out = 0;
		end
	end
endmodule
*/
module Mux4to16(s, decoder_out);

	input [3:0] s;
	output reg [15:0] decoder_out;
	
	always @ (s)
	begin
		case (s)
			4'h0 : decoder_out = 16'h0001;
			4'h1 : decoder_out = 16'h0002;
			4'h2 : decoder_out = 16'h0004;
			4'h3 : decoder_out = 16'h0008;
			4'h4 : decoder_out = 16'h0010;
			4'h5 : decoder_out = 16'h0020;
			4'h6 : decoder_out = 16'h0040;
			4'h7 : decoder_out = 16'h0080;
			4'h8 : decoder_out = 16'h0100;
			4'h9 : decoder_out = 16'h0200;
			4'hA : decoder_out = 16'h0400;
			4'hB : decoder_out = 16'h0800;
			4'hC : decoder_out = 16'h1000;
			4'hD : decoder_out = 16'h2000;
			4'hE : decoder_out = 16'h4000;
			4'hF : decoder_out = 16'h8000;
		endcase
	end
	
endmodule

/*
This module selects an output from an register depending on regNum
	out = r[regNum]
*/
module RegMux(r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, regNum, out);

	input [15:0] r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15;
	input [3:0] regNum;
	output reg [15:0] out;
	
	always @(regNum, r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15)
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
