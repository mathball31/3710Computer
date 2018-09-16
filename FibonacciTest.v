/*'timescale 1ns / 1ps

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

// Is this necessary? ~ Bev
ALU uut (
	.A(r0),
)
*/
/**
	This code below is directly taken from my version of Lab 6 of 3700
	It's commented so it doesn't screw anything up with it's wrong variables and all that\
	
		integer temp = 6'b0000000;
	
	initial 
	begin
		// Initialize Inputs
		R = 0;
		clk = 0;
		data = 4'b0000;
	end
		
	always clk = #10 ~clk;
	
	always @(posedge clk)
		begin
			$display("state = %b	r1 = %b	r2 = %b	rout = %b", state, r1, r2, rout);
		end

**/

//endmodule

	
/**	
module FSM(clk, R, data, cath, an,
	state, r1, r2, rout);
	
	input clk, R;				// clock and reset
	input [3:0] data;			// outside data - immediate values, test?
	output [1:7] cath;		// cathode
	output [3:0] an;			// anode - the odes are for the display
	
	output reg [15:0] state, r1, r2;
	output [15:0] rout;		// output of the ALU - also known as C or ALUbus
	
	reg reset;
	reg [1:0] aluc;			// opcode
	reg [15:0] tempVal;		// value to pose as the ALUbus input for the registers when they're enabled (?)
	
	parameter ADD = 4'b0101;
	
	initial
		begin
			state = 16'b0000_0000_0000_0000;
			r1 = 16'b0000_0000_0000_0000;
			r2 = 16'b0000_0000_0000_0000;
			rout = 16'b0000_0000_0000_0000;			// instantiate to eliminate latches
			tempVal = 16'b0000_0000_0000_0001;		// make it equal to one
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
						1:		// load values of registers 0 and 1
							begin
							r1 = RegBank reg(tempVal, 16'b0000_0000_0000_0001, clk, R);		// r0
							r2 = RegBank reg(tempVal, 16'b0000_0000_0000_0010, clk, R);		// r1
							
							// RegBank reg0(tempVal, r0-r15 outputs, 16'b0000_0000_0000_0001, clk, R);
							// ^^ syntax probably looks more like that
							
							// I don't know if this is the right syntax, but that's how I imagine it
							// may have something to do with all the outputs but I dunno
							// regEnable works by flipping the corresponding bit to the register
							// for example
							end
						2: // adds the two registers and stores it to 
							r2 = 4'b0011;
						3: // add r1, r2 and store to rout
							aluc = ADD;
						4: // set r2 = rout
							r2 = rout;
						5: // bitwise OR of r1, r2
							aluc = OR;
						6: // r1 = rout
							r1 = rout;
						7: // not r1, set it to rout
							aluc = NOT;
						8: // r1 = rout
							r1 = rout;
						9: // XOR r1, r2, store in rout, keep the display as is
							aluc = XOR;
						default:
							begin
								// just set them to 0 if something happens
								r1 = 16'b0000_0000_0000_0000;
								r2 = 16'b0000_0000_0000_0000;
								rout = 16'b0000_0000_0000_0000;
							end
					endcase
				end
		end

	Display disp(clk, rout, cath, an);
	ALU alu(r1, r2, aluc, rout);
	
endmodule
**/