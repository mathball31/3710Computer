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

input reg [15:0] regEnable;

input reg reset;
input reg [3:0]

input reg clk;


output 

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
