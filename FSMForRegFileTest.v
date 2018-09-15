/**
	For the FSM, taken from the code used in 3700
		Recall that each register should be enabled only when in use
		EX: R0 will be enabled in the state where R0 = R0 + R1
			Then R1 will be enabled when R1 = R1 + R2 etc.
		Each register is a D-flip-flop
		
	First always block checks for if reset button has been pushed
		flip a flag if it has
	
	Second always block is the state machine
		Check if reset has been pushed
			if yes, reset the state to 5'b00000
			else
				Increase the state by 1
				Check to see if it exceeds 15 (16?) states
					if yes, remain at that number until reset
					Or do something else
				Case statements!
					State 1
						Enable R0, add R1, R0 -> R0
					State 2
						Enable R1, add R2, R1 -> R1
					State 3
						Enable R2, add R3, R2 -> R2
					...
					Default case
						Not sure what to do here
						Model says to set inputs to 0, but those are registers, so do not do
						
	For case statements
		when they find the case and execute it, they leave the case statement - ALWAYS
		
	After the case statement exits, do work
		such as displaying the information
		and computing them
		May need more inputs or variables for opcodes and displays
			
**/
	

module FSMForRegFileTest(clk, reset, data, cath, an,
	state, r1, r2, rout);
	
	input clk, reset;				// clock and reset
	input [3:0] data;			// outside data - immediate values, test?
	output [3:0] hexOutput;
	
	output reg [3:0] state;
	output reg [15:0] r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15;
	output [15:0] rout;		// output of the ALU - also known as C or ALUbus
	
	reg reset;
	reg [7:0] opCode;			// opcode
	reg [4:0] flags;
	reg [15:0] tempVal;		// value to pose as the ALUbus input for the registers when they're enabled (?)
	reg cin;
	
	output reg [27:0] Display;
	
	parameter ADD = 4'b0101;
	
	initial
		begin
			state = 16'b0000_0000_0000_0000;
			r0 = 16'b0000_0000_0000_0001;    // Preset value for r0
			r1 = 16'b0000_0000_0000_0001;    // Preset value for r1
			r2 = 16'b0000_0000_0000_0000;
			r3 = 16'b0000_0000_0000_0000;
			r4 = 16'b0000_0000_0000_0000;
			r5 = 16'b0000_0000_0000_0000;
			r6 = 16'b0000_0000_0000_0000;
			r7 = 16'b0000_0000_0000_0000;
			r8 = 16'b0000_0000_0000_0000;
			r9 = 16'b0000_0000_0000_0000;
			r10 = 16'b0000_0000_0000_0000;
			r11 = 16'b0000_0000_0000_0000;
			r12 = 16'b0000_0000_0000_0000;
			r13 = 16'b0000_0000_0000_0000;
			r14 = 16'b0000_0000_0000_0000;
			r15 = 16'b0000_0000_0000_0000;    //r15 will be what is displayed.
			                             // instantiate to eliminate latches
			tempVal = 16'b0000_0000_0000_0001;		// make it equal to one
			
			flags = 5'b00000;
			opCode = 8'b0000_0101;  // Opcode for "add"
			cin = 1'b0;             // no carry in initially, but should be set if needed.
		end
	
	// for each rising positive edge of the clock
	// check to see if the reset button has been pressed
	always @(posedge clk)
		begin
			if(R == 1'b1)
				reset = 1'b1;
			else	// R = 1'b0
				reset = 1'b0;
		end
		
	always @(posedge clk)
		begin
			if(reset == 1'b1)
				// checks to see if the reset button has been pressed
				state = 4'b0000;
			else
				begin
					state = state + 4'b1;		// increase the state by one
					if(state > 4'b1001)
						state = 4'b1001;		// keep it at the last state?

					case(state)
					/* 1. You can preset the values in the register file. *** will choose this for now
					 * 2.You can equip the register file with a load capability and use the FSM to load the values.
					 * 3.You can design the FSM to set up the controls that will simulate an add immediate 
					 *    instructionLCDFSMALUOP that adds R0 to one value and writes it back to R0, 
					 *    then do the same with the the second valueand register R1.  **/
						0:		// load values of registers 0 and 1
							begin
							r1 = RegBank reg(tempVal, 16'b0000_0000_0000_0001, clk, R);		// r0
							r2 = RegBank reg(tempVal, 16'b0000_0000_0000_0010, clk, R);		// r1
							
							// RegBank reg0(tempVal, r0-r15 outputs, 16'b0000_0000_0000_0001, clk, R);
							// ^^ syntax probably looks more like that
							
							end
						1: // add r0 and r1, store it to r2
							ALU (.A(r0), .B(r1), .C(r2), .Opcode(opcode), .Flags(flags), .Cin(cin));
							if (flags[3] == 1)
								cin = 1;
							state = state + 1'b1;
						2: // add r1 and r2, store it to r3
							ALU (.A(r1), .B(r2), .C(r3), .Opcode(opcode), .Flags(flags), .Cin(cin));
							if (flags[3] == 1)
								cin = 1;
							state = state + 1'b1;
						3: // add r2 and r3, store it to r4
							ALU (.A(r2), .B(r3), .C(r4), .Opcode(opcode), .Flags(flags), .Cin(cin));
							if (flags[3] == 1)
								cin = 1;
							state = state + 1'b1;
						4: // add r3 and r4, store it to r5
							ALU (.A(r3), .B(r4), .C(r5), .Opcode(opcode), .Flags(flags), .Cin(cin));
							if (flags[3] == 1)
								cin = 1;
							state = state + 1'b1;
						5: // add r4 and r5, store it to r6
							ALU (.A(r4), .B(r5), .C(r6), .Opcode(opcode), .Flags(flags), .Cin(cin));
							if (flags[3] == 1)
								cin = 1;
							state = state + 1'b1;
						6: // add r5 and r6, store it to r7
							ALU (.A(r5), .B(r6), .C(r7), .Opcode(opcode), .Flags(flags), .Cin(cin));
							if (flags[3] == 1)
								cin = 1;
							state = state + 1'b1;
						7: // add r6 and r7, store it to r8
							ALU (.A(r6), .B(r7), .C(r8), .Opcode(opcode), .Flags(flags), .Cin(cin));
							if (flags[3] == 1)
								cin = 1;
							state = state + 1'b1;
						8: // add r7 and r8, store it to r9
							ALU (.A(r7), .B(r8), .C(r9), .Opcode(opcode), .Flags(flags), .Cin(cin));
							if (flags[3] == 1)
								cin = 1;
							state = state + 1'b1;
						9: // r8 + r9 = r10
							ALU (.A(r8), .B(r9), .C(r10), .Opcode(opcode), .Flags(flags), .Cin(cin));
							if (flags[3] == 1)
								cin = 1;
							state = state + 1'b1;
						10: // r9 + r10 = r11
							ALU (.A(r9), .B(r10), .C(r11), .Opcode(opcode), .Flags(flags), .Cin(cin));
							if (flags[3] == 1)
								cin = 1;
							state = state + 1'b1;
						11: // r10 + r11 = r12
							ALU (.A(r10), .B(r11), .C(r12), .Opcode(opcode), .Flags(flags), .Cin(cin));
							if (flags[3] == 1)
								cin = 1;
							state = state + 1'b1;
						12: // r11 + r12 = r13
							ALU (.A(r11), .B(r12), .C(r13), .Opcode(opcode), .Flags(flags), .Cin(cin));
							if (flags[3] == 1)
								cin = 1;
							state = state + 1'b1;
						13: // r12 + r13 = r14
							ALU (.A(r12), .B(r13), .C(r14), .Opcode(opcode), .Flags(flags), .Cin(cin));
							if (flags[3] == 1)
								cin = 1;
							state = state + 1'b1;
						14: // r13 + r14 = r15
							ALU (.A(r13), .B(r13), .C(r15), .Opcode(opcode), .Flags(flags), .Cin(cin));
							if (flags[3] == 1)
								cin = 1;
							state = state + 1'b1;
						15: // r15 = display out
							hexTo7Seg (.hex_input(r15[15:12], .seven_seg_out(Display[27:21]));
							hexTo7Seg (.hex_input(r15[11:8], .seven_seg_out(Display[20:14]));
							hexTo7Seg (.hex_input(r15[7:4], .seven_seg_out(Display[13:7]));
							hexTo7Seg (.hex_input(r15[3:0], .seven_seg_out(Display[6:0]));
							
						
						default:
							begin
								// just set them to 0 if something happens
								r1 = 16'b0000_0000_0000_0000;
								r2 = 16'b0000_0000_0000_0000;
							end
					endcase
					state = state + 1'b1;
				end
		end

	Display disp(clk, rout, cath, an);
	ALU alu(r1, r2, aluc, rout);
	
endmodule
**/