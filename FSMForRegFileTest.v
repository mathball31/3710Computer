`timescale 1ns / 1ps

module FSMForRegFileTest(display, state, rout);		// outputs
		
	output [27:0] display;
	output [15:0] rout;
	output reg [4:0] state;
	
	reg resetFlag, clk, reset;
	reg [4:0] flags;
	wire [4:0] flags_temp;		// connects the output of datapath to the register
	reg [15:0] initVal;		// initial value to load into r0, used to be tempVal
	reg cin;
	reg [15:0] opCode, enCode;		// the codes to execute
	integer i;
	
	// add codes
	parameter r0_1add = 16'b0000_0001_0101_0000;
	parameter r0_2add = 16'b0000_0010_0101_0000;			// r0 and r2
	parameter r1_3add = 16'b0000_0011_0101_0001;			// r1 and r3
	parameter r2_4add = 16'b0000_0100_0101_0010;			// r2 and r4
	parameter r3_5add = 16'b0000_0101_0101_0011;			// r3 and r5
	parameter r4_6add = 16'b0000_0110_0101_0100;			// r4 and r6
	parameter r5_7add = 16'b0000_0111_0101_0101;			// r5 and r7
	parameter r6_8add = 16'b0000_1000_0101_0110;			// r6 and r8
	parameter r7_9add = 16'b0000_1001_0101_0111;			// r7 and r9
	parameter r8_10add = 16'b0000_1010_0101_1000;			// r8 and r10
	parameter r9_11add = 16'b0000_1011_0101_1001;			// r9 and r11
	parameter r10_12add = 16'b0000_1100_0101_1010;			// r10 and r12
	parameter r11_13add = 16'b0000_1101_0101_1011;			// r11 and r13
	parameter r12_14add = 16'b0000_1110_0101_1100;			// r12 and r14
	parameter r13_15add = 16'b0000_1111_0101_1101;			// r13 and r15
//	parameter r15add = 16'b0000_1111_0101_1110;			
	
	parameter r1movr2 = 16'b0000_0010_1101_0001;
	parameter r2movr3 = 16'b0000_0011_1101_0010;
	parameter r3movr4 = 16'b0000_0100_1101_0011;
	parameter r4movr5 = 16'b0000_0101_1101_0100;
	parameter r5movr6 = 16'b0000_0110_1101_0101;
	parameter r6movr7 = 16'b0000_0111_1101_0110;
	parameter r7movr8 = 16'b0000_1000_1101_0111;
	parameter r8movr9 = 16'b0000_1001_1101_1000;
	parameter r9movr10 = 16'b0000_1010_1101_1001;
	parameter r10movr11 = 16'b0000_1011_1101_1010;
	parameter r11movr12 = 16'b0000_1100_1101_1011;
	parameter r12movr13 = 16'b0000_1101_1101_1100;
	parameter r13movr14 = 16'b0000_1110_1101_1101;
	parameter r14movr15 = 16'b0000_1111_1101_1110;
	
	// enable codes
	// opcodes and registers
	// This variable encases all of the opcodes and the two registers for adding
	// from [15:12] and [7:4], those are the opcodes
	// while [11:8] is for the A input and [3:0] is for the B input
	// it will make more sense to check this out in the datapath file
	// All operations are add, so this doesn't change much - just the registers
//	parameter r0_en = 16'b0000_0000_0000_0001;
//	parameter r1_en = 16'b0000_0000_0000_0010;
//	parameter r2_en = 16'b0000_0000_0000_0100;
//	parameter r3_en = 16'b0000_0000_0000_1000;
//	parameter r4_en = 16'b0000_0000_0001_0000;
//	parameter r5_en = 16'b0000_0000_0010_0000;
//	parameter r6_en = 16'b0000_0000_0100_0000;
//	parameter r7_en = 16'b0000_0000_1000_0000;
//	parameter r8_en = 16'b0000_0001_0000_0000;
//	parameter r9_en = 16'b0000_0010_0000_0000;
//	parameter r10_en = 16'b0000_0100_0000_0000;
//	parameter r11_en = 16'b0000_1000_0000_0000;
//	parameter r12_en = 16'b0001_0000_0000_0000;
//	parameter r13_en = 16'b0010_0000_0000_0000;
//	parameter r14_en = 16'b0100_0000_0000_0000;
//	parameter r15_en = 16'b1000_0000_0000_0000;
		
	// Always initialize values before doing stuff
	initial
	begin
		#100;
		initVal = 16'b0000_0000_0000_0001;
		flags = 5'b00000;
		cin = 1'b0;             // no carry in initially, but should be set if needed.
		clk = 1;
		reset = 1;
		state = 4'b0000;
		
		for (i = 0; i <= 30; i = i + 1)
		begin
			clk = ~clk;
			$display("state = %b   rout = %b  ", state, rout);
			#5;
		end
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
		begin
			// checks to see if the reset button has been pressed
			state = 5'b00000;
			reset = 1'b0;
		end
			
		else
		begin
			state = state + 5'b00001;	// increase the state by one
												// There is no need to add this to every case - it already happens
												// every time the positive edge rises
			if(state >= 5'b11110)
				state = 5'b11110;		// keep it at the last state so can be displayed
			
			// checks to see if there is a carry in
			// This happens every posedge of the clock, so no need to place in every state
			flags = flags_temp;
			cin = flags[3];

			case(state)
				0:		// Add immediate (1) into r0
					begin
						opCode = 16'b0101_0000_0000_0001;  // 0101 - add immediate 0000 - register 0 - value 1
					end
				1: // Add immediate (1) into r1
					begin
						opCode = 16'b0101_0001_0000_0001;  // add immediate value of 1 into register 
					end
				2: // r1 = r0 + r1
					begin
						opCode = r0_1add;
					end
				3: // Move r1 -> r2
					begin
						opCode = r1movr2;
					end
				4: // r2 = r0 + r2
					begin
						opCode = r0_2add;
					end
				5: // Move r2 -> r3
					begin
						opCode = r2movr3;
					end
				6: // r3 = r1 + r3
					begin
						opCode = r1_3add;
					end
				7: // Move r3 -> r4
					begin
						opCode = r3movr4;
					end
				8: // r4 = r4 + r2
					begin
						opCode = r2_4add;

					end
				9: // Move r4 -> 45
					begin
						opCode = r4movr5;

					end
				10: // r5 = r3 + r5
					begin
						opCode = r3_5add;

					end
				11: // Move r5 -> r6
					begin
						opCode = r5movr6;

					end
				12: // r6 = r6 + r4
					begin
						opCode = r4_6add;

					end
				13: // Move r6 -> r7
					begin
						opCode = r6movr7;
;
					end
				14: // r7 = r5 + r7
					begin
						opCode = r5_7add;

					end
				15: // Move r7 -> r8
					begin
						opCode = r7movr8;
					end
				16: // r8 = r6 + r8
					begin
						opCode = r6_8add;

					end
				17: // Move r8 -> r9
					begin
						opCode = r8movr9;
					end
				18: // r9 = r7 + r9
					begin
						opCode = r7_9add;

					end
				19: // Move r9 -> r10
					begin
						opCode = r9movr10;
					end
				20: // r10 = r8 + r10
					begin
						opCode = r8_10add;

					end
				21: // Move r10 -> r11
					begin
						opCode = r10movr11;
					end
				22: // r11 = r9 + r11
					begin
						opCode = r9_11add;

					end
				23: // Move r11 -> r12
					begin
						opCode = r11movr12;
					end
				24: // r12 = r10 + r12
					begin
						opCode = r10_12add;

					end
				25: // Move r12 -> r13
					begin
						opCode = r12movr13;
					end
				26: // r13 = r11 + r13
					begin
						opCode = r11_13add;

					end
				27: // Move r13 -> r14
					begin
						opCode = r13movr14;
					end
				28: // r14 = r12 + r14
					begin
						opCode = r12_14add;

					end
				29: // Move r14 -> r15
					begin
						opCode = r14movr15;
					end
				30: // r15 = r13 + r15
					begin
						opCode = r13_15add;

					end
				default:
					opCode = 16'bx;
			endcase
		end
	end
		
		// at the end of the always block, display the value
		// Do it before the datapath so all values can be displayed
		hexTo7Seg disp3(.hex_input(rout[15:12]), .seven_seg_out(display[27:21]));
		hexTo7Seg disp2(.hex_input(rout[11:8]), .seven_seg_out(display[20:14]));
		hexTo7Seg disp1(.hex_input(rout[7:4]), .seven_seg_out(display[13:7]));
		hexTo7Seg disp0(.hex_input(rout[3:0]), .seven_seg_out(display[6:0]));

		// calling other modules inside an always block doesn't work - which is why the FSM this was based on
		// had everything OUTside of the always block and used variables for the parameters. 
		datapath dp(addCode, cin, clk, reset, flags_temp, rout);
endmodule
