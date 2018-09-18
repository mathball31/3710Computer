`timescale 1ns / 1ps

module FSMForRegFileTest(display, state, rout);		// outputs
		
	output [27:0] display;
	output [15:0] rout;
	output reg [3:0] state;
	
	reg resetFlag, clk, reset;
	reg [4:0] flags;
	wire [4:0] flags_temp;		// connects the output of datapath to the register
	reg [15:0] initVal;		// initial value to load into r0, used to be tempVal
	reg cin;
	reg [15:0] addCode, enCode;		// the codes to execute
	integer i;
	
	// add codes
	parameter r1add = 16'b0000_0001_0101_0000;			// r0 and r1
	parameter r2add = 16'b0000_0010_0101_0001;			// r1 and r2
	parameter r3add = 16'b0000_0011_0101_0010;			// r2 and r3
	parameter r4add = 16'b0000_0100_0101_0011;			// r3 and r4
	parameter r5add = 16'b0000_0101_0101_0100;			// r4 and r5
	parameter r6add = 16'b0000_0110_0101_0101;			// r5 and r6
	parameter r7add = 16'b0000_0111_0101_0110;			// r6 and r7
	parameter r8add = 16'b0000_1000_0101_0111;			// r7 and r8
	parameter r9add = 16'b0000_1001_0101_1000;			// r8 and r9
	parameter r10add = 16'b0000_1010_0101_1001;			// r9 and r10
	parameter r11add = 16'b0000_1011_0101_1010;			// r10 and r11
	parameter r12add = 16'b0000_1100_0101_1011;			// r11 and r12
	parameter r13add = 16'b0000_1101_0101_1100;			// r12 and r13
	parameter r14add = 16'b0000_1110_0101_1101;			// r13 and r14
	parameter r15add = 16'b0000_1111_0101_1110;			// r15 and r15
	
	// enable codes
	// opcodes and registers
	// This variable encases all of the opcodes and the two registers for adding
	// from [15:12] and [7:4], those are the opcodes
	// while [11:8] is for the A input and [3:0] is for the B input
	// it will make more sense to check this out in the datapath file
	// All operations are add, so this doesn't change much - just the registers
	parameter r0_en = 16'b0000_0000_0000_0001;
	parameter r1_en = 16'b0000_0000_0000_0010;
	parameter r2_en = 16'b0000_0000_0000_0100;
	parameter r3_en = 16'b0000_0000_0000_1000;
	parameter r4_en = 16'b0000_0000_0001_0000;
	parameter r5_en = 16'b0000_0000_0010_0000;
	parameter r6_en = 16'b0000_0000_0100_0000;
	parameter r7_en = 16'b0000_0000_1000_0000;
	parameter r8_en = 16'b0000_0001_0000_0000;
	parameter r9_en = 16'b0000_0010_0000_0000;
	parameter r10_en = 16'b0000_0100_0000_0000;
	parameter r11_en = 16'b0000_1000_0000_0000;
	parameter r12_en = 16'b0001_0000_0000_0000;
	parameter r13_en = 16'b0010_0000_0000_0000;
	parameter r14_en = 16'b0100_0000_0000_0000;
	parameter r15_en = 16'b1000_0000_0000_0000;
		
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
			state = 4'b0000;
			reset = 1'b0;
		end
			
		else
		begin
			state = state + 4'b0001;	// increase the state by one
												// There is no need to add this to every case - it already happens
												// every time the positive edge rises
			if(state >= 4'b1111)
				state = 4'b1111;		// keep it at the last state so can be displayed
			
			// checks to see if there is a carry in
			// This happens every posedge of the clock, so no need to place in every state
			flags = flags_temp;
			cin = flags[3];

			case(state)
				0:		// used to be load and enCode = r0_en, but changed to just setting enCode and addCode = 0
					begin
						enCode = r1_en;
						addCode = 16'b0101_0001_0000_0001;
						// this is much easier than redoing all the numbers and adding a default case.
					end
				1: // Add R0, R1 -> R2
					begin
//								load = 1'b0;
						addCode = r1add;
						enCode = r2_en;
					end
				2: // Add R1, R2 -> R3
					begin
						addCode = r2add;
						enCode = r3_en;
					end
				3: // Add R2, R3 -> R4
					begin
						addCode = r3add;
						enCode = r4_en;
					end
				4: // Add R3, R4 -> R5
					begin
						addCode = r4add;
						enCode = r5_en;
					end
				5: // Add R4, R5 -> R6
					begin
						addCode = r5add;
						enCode = r6_en;
					end
				6: // Add R5, R6 -> R7
					begin
						addCode = r6add;
						enCode = r7_en;
					end
				7: // Add R6, R7 -> R8
					begin
						addCode = r7add;
						enCode = r8_en;
					end
				8: // Add R7, R8 -> R9
					begin
						addCode = r8add;
						enCode = r9_en;
					end
				9: // Add R8, R9 -> R10
					begin
						addCode = r9add;
						enCode = r10_en;
					end
				10: // Add R9, R10 -> R11
					begin
						addCode = r10add;
						enCode = r11_en;
					end
				11: // Add R10, R11 -> R12
					begin
						addCode = r11add;
						enCode = r12_en;
					end
				12: // Add R11, R12 -> R13
					begin
						addCode = r12add;
						enCode = r13_en;
					end
				13: // Add R12, R13 -> R14
					begin
						addCode = r13add;
						enCode = r14_en;
					end
				14: // Add R13, R14 -> R15
					begin
						addCode = r14add;
						enCode = r15_en;
					end
				15: 
					// last case, stop here
					begin
						
					end
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
