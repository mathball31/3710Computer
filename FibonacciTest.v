'timescale 1ns / 1ps


module FibonacciTest;

input reg [15:0] r0;
input reg [15:0] r1;
input reg [15:0] r2;
input reg [15:0] r3;
input reg [15:0] r4;
input reg [15:0] r5;
input reg [15:0] r6;
input reg [15:0] r7;
input reg [15:0] r8;
input reg [15:0] r9;
input reg [15:0] r10;
input reg [15:0] r11;
input reg [15:0] r12;
input reg [15:0] r13;
input reg [15:0] r14;
input reg [15:0] r15;

// from numbers from 0-15, flip ONLY the corresponding reg bit to 1 
// when enabling that specific register
input reg [15:0] regEnable;

input reg reset;
input reg [3:0]

input reg clk;

// Not sure what was supposed to happen here - Bev
// output ;

// Instantiate the Unit Under Test (UUT)
regfile uut (
	.r0(r0),
	.r1(r1),
	.r2(r2),
	.r3(r3),
	.r4(r4),
	.r5(r5),
	.r6(r6),
	.r7(r7),
	.r8(r8),
	.r9(r9),
	.r10(r10),
	.r11(r11),
	.r12(r12),
	.r14(r14),
	.r15(r15),
	.clk(clk),
	.regEnable(regEnable),
	.reset(reset)
);

ALU uut (
	.A(r0),
)

/**
	For the FSM, taken from the code used in 3700
		Recall that each register should be enabled only when in use
		EX: R0 will be enabled in the state where R0 = R0 + R1
			Then R1 will be enabled when R1 = R1 + R2 etc.
		Each register is a D-flip-flop
		
	First initialize the values
		such as state = 4'b0000
	
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
			(I don't know why I don't remember this)
	After the case statement exits, do work
		such as displaying the information
		and computing them
		May need more inputs or variables for opcodes and displays
			
**/
