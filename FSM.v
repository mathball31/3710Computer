

module FSM(data, opcode, mux_A_sel, mux_B_sel, pc_sel, imm_sel, mem_w_en_a, mem_w_en_b, reg_en, flag_en, pc_en);

	input [15:0] data;
	output reg [15:0] opcode, reg_en;
	output reg [3:0] mux_A_sel, mux_B_sel;
	output reg pc_sel, imm_sel, mem_w_en_a, mem_w_en_b, flag_en, pc_en;
	
	wire [15:0] mux_out;
	

//	
//	RegBank regFile(AluBus, r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, RegEnable, Clk, Reset);
//
//	RegMux muxA(r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, Opcode[11:8], muxAout);
//
//	RegMux muxB(r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, Opcode[3:0], muxBout);
//
//	ALU alu(muxAout, muxBout, Opcode, Flags, Cin, ALUbus);
//	
//	Memory mem(data_a, data_b, addr_a, addr_b, we_a, we_b, clk, mem_out_a, mem_out_b);
//	
//	ProgramCounter pc(clk, reset, pc_en, pc_ld, pc_in, pc_out);

	initial
	begin
		pc_sel = 1'b1; // TODO modify depending on state
		imm_sel = 1'b0; // TODO modify depending on state
		mem_w_en_a = 1'b0; // TODO modify depending on state
		mem_w_en_b = 1'b0; // TODO modify depending on state
		flag_en = 1'b1; // TODO modify depending on state
		pc_en = 1'b1; // TODO modify depending on state
	end
	
	// For reg to reg, data from memory is the opcode.
	always @ *
	begin
		opcode = data;
		mux_A_sel = opcode[11:8];
		mux_B_sel = opcode[3:0];
		
		reg_en = mux_out;
	end
	

	
	
	Mux4to16 regEnable(opcode[11:8], mux_out);


endmodule

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





