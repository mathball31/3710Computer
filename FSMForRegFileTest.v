`timescale 1ns / 1ps

module FSMForRegFileTest(
	clk, reset,						// inputs
	display, state, rout);		// outputs
	
	input clk, reset;
	
	output [27:0] display;
	output [15:0] rout;
	output reg [3:0] state;
	
	reg resetFlag;
	reg [4:0] flags;
	reg [15:0] initVal;		// initial value to load into r0, used to be tempVal
	reg cin;
	reg load;		// tells when to load the value into r0
	// codes to enable the specific register
	reg [15:0] r0_en, r1_en, r2_en, r3_en, r4_en, r5_en, r6_en, r7_en, r8_en, r9_en, r10_en, r11_en, r12_en, r13_en, r14_en, r15_en;
	reg [15:0] r1add, r2add, r3add, r4add, r5add, r6add, r7add, r8add, r9add, r10add, r11add, r12add, r13add, r14add, r15add;
	reg [15:0] addCode, enCode;		// the codes to execute
	
	// almost like a dummy variable for the outputs of RegBank, not sure if we need them
	wire [15:0] r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15;
	
	
	// Always initialize values before doing stuff
	initial
		begin
			initVal = 16'b0000_0000_0000_0001;
			flags = 5'b00000;
			cin = 1'b0;             // no carry in initially, but should be set if needed.
			load = 1'b0;
			
			// enable codes
			r0_en = 16'b0000_0000_0000_0001;
			r1_en = 16'b0000_0000_0000_0010;
			r2_en = 16'b0000_0000_0000_0100;
			r3_en = 16'b0000_0000_0000_1000;
			r4_en = 16'b0000_0000_0001_0000;
			r5_en = 16'b0000_0000_0010_0000;
			r6_en = 16'b0000_0000_0100_0000;
			r7_en = 16'b0000_0000_1000_0000;
			r8_en = 16'b0000_0001_0000_0000;
			r9_en = 16'b0000_0010_0000_0000;
			r10_en = 16'b0000_0100_0000_0000;
			r11_en = 16'b0000_1000_0000_0000;
			r12_en = 16'b0001_0000_0000_0000;
			r13_en = 16'b0010_0000_0000_0000;
			r14_en = 16'b0100_0000_0000_0000;
			r15_en = 16'b1000_0000_0000_0000;
			
			// opcodes and registers
			// This variable encases all of the opcodes and the two registers for adding
			// from [15:12] and [7:4], those are the opcodes
			// while [11:8] is for the A input and [3:0] is for the B input
			// it will make more sense to check this out in the datapath file
			// All operations are add, so this doesn't change much - just the registers
			r1add = 16'b0000_0000_0101_0001;			// r0 and r1
			r2add = 16'b0000_0001_0101_0010;			// r1 and r2
			r3add = 16'b0000_0010_0101_0011;			// r2 and r3
			r4add = 16'b0000_0011_0101_0100;			// r3 and r4
			r5add = 16'b0000_0100_0101_0101;			// r4 and r5
			r6add = 16'b0000_0101_0101_0110;			// r5 and r6
			r7add = 16'b0000_0110_0101_0111;			// r6 and r7
			r8add = 16'b0000_0111_0101_1000;			// r7 and r8
			r9add = 16'b0000_1000_0101_1001;			// r8 and r9
			r10add = 16'b0000_1001_0101_1010;			// r9 and r10
			r11add = 16'b0000_1010_0101_1011;			// r10 and r11
			r12add = 16'b0000_1011_0101_1100;			// r11 and r12
			r13add = 16'b0000_1100_0101_1101;			// r12 and r13
			r14add = 16'b0000_1101_0101_1110;			// r13 and r14
			r15add = 16'b0000_1110_0101_1111;			// r15 and r15
			
		end

	// for each rising positive edge of the clock
	// check to see if the reset button has been pressed
	always @(posedge clk)
		begin
			if(reset == 1'b1)
				resetFlag = 1'b1;
			else	// R = 1'b0
				resetFlag = 1'b0;
		end

	always @(posedge clk)
		begin		
			if(resetFlag == 1'b1)
				// checks to see if the reset button has been pressed
				state = 4'b0000;
			else
				begin
					state = state + 4'b1;	// increase the state by one
													// There is no need to add this to every case - it already happens
													// every time the positive edge rises
					if(state > 4'b1111)
						state = 4'b1111;		// keep it at the last state so can be displayed
					
					// checks to see if there is a carry in
					// This happens every posedge of the clock, so no need to place in every state
					if (flags[3] == 1)
						cin = 1;

					case(state)
						0:		// used to be load and enCode = r0_en, but changed to just setting enCode and addCode = 0
							begin
								enCode = 16'b0000_0000_0000_0000;
								addCode = 16'b0000_0000_0000_0000;
								// this is much easier than redoing all the numbers and adding a default case.
							end
						1: // Add R0, R1 -> R1
							begin
								load = 1'b0;
								addCode = r1add;
								enCode = r1_en;
							end
						2: // Add R1, R2 -> R2
							begin
								addCode = r2add;
								enCode = r2_en;
							end
						3: // Add R2, R3 -> R3
							begin
								addCode = r3add;
								enCode = r3_en;
							end
						4: // Add R3, R4 -> R4
							begin
								addCode = r4add;
								enCode = r4_en;
							end
						5: // Add R4, R5 -> R5
							begin
								addCode = r5add;
								enCode = r5_en;
							end
						6: // Add R5, R6 -> R6
							begin
								addCode = r6add;
								enCode = r6_en;
							end
						7: // Add R6, R7 -> R7
							begin
								addCode = r7add;
								enCode = r7_en;
							end
						8: // Add R7, R8 -> R8
							begin
								addCode = r8add;
								enCode = r8_en;
							end
						9: // Add R8, R9 -> R9
							begin
								addCode = r9add;
								enCode = r9_en;
							end
						10: // Add R9, R10 -> R10
							begin
								addCode = r10add;
								enCode = r10_en;
							end
						11: // Add R10, R11 -> R11
							begin
								addCode = r11add;
								enCode = r11_en;
							end
						12: // Add R11, R12 -> R12
							begin
								addCode = r12add;
								enCode = r12_en;
							end
						13: // Add R12, R13 -> R13
							begin
								addCode = r13add;
								enCode = r13_en;
							end
						14: // Add R13, R14 -> R14
							begin
								addCode = r14add;
								enCode = r14_en;
							end
						15: // Add R14, R15 -> R15
							// last case, stop here
							begin
								addCode = r15add;
								enCode = r15_en;
							end
					endcase
				end
		end

			// load the value into r0 once
			// TODO this is causing compiler issues and I'm trying to figure it out - Bev
//			if(load == 1'b1)
//				RegBank reg0( initVal, r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, enCode, clk, reset);
//		RegBank reg0( initVal, r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, 16'b0000_0000_0000_0001, clk, reset);
		
		// doing this will probably cause the program to load the value each time, but cannot think of another way to do it
		RegBank reg0( initVal, r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r0_en, clk, reset);

		
		// at the end of the always block, display the value
		// Do it before the datapath so all values can be displayed
		hexTo7Seg disp3(.hex_input(rout[15:12]), .seven_seg_out(display[27:21]));
		hexTo7Seg disp2(.hex_input(rout[11:8]), .seven_seg_out(display[20:14]));
		hexTo7Seg disp1(.hex_input(rout[7:4]), .seven_seg_out(display[13:7]));
		hexTo7Seg disp0(.hex_input(rout[3:0]), .seven_seg_out(display[6:0]));

		// calling other modules inside an always block doesn't work - which is why the FSM this was based on
		// had everything OUTside of the always block and used variables for the parameters. 
		datapath dp(addCode, cin, enCode, clk, reset, flags, rout);
		
endmodule
