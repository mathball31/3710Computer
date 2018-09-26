// Quartus Prime Verilog Template
// Simple Dual Port RAM with separate read/write addresses and
// single read/write clock

module mem
#(parameter DATA_WIDTH = 16, parameter ADDR_WIDTH = 10)
(
	input [(DATA_WIDTH-1):0] data,
	input [(ADDR_WIDTH-1):0] read_addr, write_addr,
	input we, clk,
	output reg [(DATA_WIDTH-1):0] q
);

	// Declare the RAM variable
	// recall that ** means raise to the power of
	// 16 bit word and 512 addr_width (2^10), which equals one block
	reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];
	
	// initializing memory
	initial begin
		// use $readmemb if want to read in binarary
		// right now, reading in hex
		$readmemh("commandList.txt", ram);
	end

	always @ (posedge clk)
	begin
		// Write - if we (write enable) = 1, then you wanna write data
		if (we)
			ram[write_addr] <= data;		// write the data into the ram at a specific address

		// Read (if read_addr == write_addr, return OLD data).
		// To return NEW data, use = (blocking write) rather than <= (non-blocking write)
		// in the write assignment.
		// NOTE: NEW data may require extra bypass logic around the RAM.
		q <= ram[read_addr];
	end

endmodule
