
// Quartus Prime Verilog Template
// True Dual Port RAM with single clock

module mem
#(parameter DATA_WIDTH = 16, parameter ADDR_WIDTH = 10)
(
	input [DATA_WIDTH-1:0] data_a, data_b,
	input [ADDR_WIDTH-1:0] addr_a, addr_b,
	input we_a, we_b, clk,
	output reg [DATA_WIDTH-1:0] q_a, q_b
);

	integer i;
	
	// Declare the RAM variable
	// recall that ** means raise to the power of
	// 16 bit word and 512 addr_width (2^10), which equals two blocks
	reg [DATA_WIDTH-1:0] ram[0:2**ADDR_WIDTH-1];
	
	// initializing memory
	initial begin
		// use $readmemb if want to read in binarary
		// right now, reading in hex
		$readmemh("hex_mem.mem", ram);
		
//		for(i=0;i<2**ADDR_WIDTH;i=i+1)
//			ram[i] = 0;
	end
	
	// Read (if read_addr == write_addr, return OLD data).
	// To return NEW data, use = (blocking write) rather than <= (non-blocking write).
	// NOTE: NEW data may require extra bypass logic around the RAM.
	always @(posedge clk)
	begin
	if(we_a && we_b)
		begin
			if(addr_a == addr_b)
			begin
				// both write enables on, writing to same address
				// give precedence to port A
				ram[addr_a] <= data_a;
				q_a <= data_a;				// reads out the value that has been written
			end
			
			else
			begin
				// both write enables on, writing to different address
				// write from both ports
				ram[addr_a] <= data_a;
				q_a <= data_a;

				ram[addr_b] <= data_b;
				q_b <= data_b;
			end
		end
		
		else if(we_a)
		begin
			// want to write from port A
			ram[addr_a] <= data_a;
			q_a <= data_a;

			// read from port B
			q_b <= ram[addr_b];
		end
		
		else if(we_b)
		begin
			ram[addr_b] <= data_b;
			q_b <= ram[addr_b];

			q_a <= data_a;
		end
		else
		begin
			// the enables aren't on, so just read
			q_a <= ram[addr_a];
			q_b <= ram[addr_b];
		end
	end
endmodule
