module tb;

	localparam	ADDRESS_WIDTH = 4,
					DATA_WIDTH = 8;

   reg tb_clock;
   reg tb_we;
   reg [ADDRESS_WIDTH-1:0] tb_addr_a, tb_addr_b;
   reg [DATA_WIDTH-1:0]	tb_din;

   wire [DATA_WIDTH-1:0] tb_dout_read_first, tb_dout_write_first, tb_dout_another_write_first; 
   
   
initial begin
	tb_clock = 1;
	forever
		#5 tb_clock = ~tb_clock;
end


integer i = 0, j = 0;

initial begin
$dumpvars(0);
//$dumpvars(0, inst_read_first_memory.ram[0]);
//$dumpvars(0, inst_read_first_memory.ram[1]);
//$dumpvars(0, inst_read_first_memory.ram[2]);
//$dumpvars(0, inst_read_first_memory.ram[3]);
//$dumpvars(0, inst_read_first_memory.ram[4]);
//
//$dumpvars(0, inst_write_first_memory.ram[0]);
//$dumpvars(0, inst_write_first_memory.ram[1]);
//$dumpvars(0, inst_write_first_memory.ram[2]);
//$dumpvars(0, inst_write_first_memory.ram[3]);
//$dumpvars(0, inst_write_first_memory.ram[4]);
tb_we = 0;
tb_addr_a = 0;
tb_addr_b = 0;
tb_din = 0;
#10;
repeat (10)  begin
	repeat (5) @(negedge  tb_clock);
	tb_we = 1;
	i = i + 1;
	j = j + 1;
	tb_din = j;
	tb_addr_a = i;
	tb_addr_b = i;
	
	@(negedge  tb_clock);
	j = j + 1;
	tb_din = j;
end
$finish;
end

write_first_memory #(ADDRESS_WIDTH, DATA_WIDTH) inst_write_first_memory (tb_clock, tb_we, tb_addr_a, tb_addr_b, tb_din, tb_dout_write_first);
read_first_memory #(ADDRESS_WIDTH, DATA_WIDTH) inst_read_first_memory(tb_clock, tb_we, tb_addr_a, tb_addr_b, tb_din, tb_dout_read_first);
another_write_first #(ADDRESS_WIDTH, DATA_WIDTH) inst_draft_memory(tb_clock, tb_we, tb_addr_a, tb_addr_b, tb_din, tb_dout_another_write_first);

endmodule

module write_first_memory
	#(
		parameter	ADDRESS_WIDTH = 8,
					DATA_WIDTH = 8
	)
	(
		input	wire	[0:0]				clock,
		input	wire	[0:0]				we,
		input	wire	[ADDRESS_WIDTH-1:0]	addr_a, addr_b,
		input	wire	[DATA_WIDTH-1:0]	din,
		output	wire		[DATA_WIDTH-1:0]	dout
	);

   reg [DATA_WIDTH-1:0] ram [2**ADDRESS_WIDTH-1:0];
   
   integer i = 0;

   initial begin
   		for(i=0; i < 2**ADDRESS_WIDTH; i=i+1)
   			ram[i] = 100;
   end
   
   always @(posedge clock) begin
   	
      if (we)  // write operation
        ram[addr_a] <= din;
   end
   
   assign dout = ram[addr_b];
   
endmodule

module read_first_memory
	#(
		parameter	ADDRESS_WIDTH = 8,
					DATA_WIDTH = 8
	)
	(
		input	wire	[0:0]				clock,
		input	wire	[0:0]				we,
		input	wire	[ADDRESS_WIDTH-1:0]	addr_a, addr_b,
		input	wire	[DATA_WIDTH-1:0]	din,
		output reg		[DATA_WIDTH-1:0]	dout
	);

   reg [DATA_WIDTH-1:0] ram [2**ADDRESS_WIDTH-1:0];

   integer i = 0;

   initial begin
   		for(i=0; i < 2**ADDRESS_WIDTH; i=i+1)
   			ram[i] = 100;
   end

   always @(posedge clock) begin
      
   	dout <= ram[addr_b];	
      if (we)  // write operation
         ram[addr_a] <= din;
   end

endmodule

module another_write_first
	#(
		parameter	ADDRESS_WIDTH = 8,
					DATA_WIDTH = 8
	)
	(
		input	wire	[0:0]				clock,
		input	wire	[0:0]				we,
		input	wire	[ADDRESS_WIDTH-1:0]	addr_a, addr_b,
		input	wire	[DATA_WIDTH-1:0]	din,
		output wire		[DATA_WIDTH-1:0]	dout
	);

   reg [DATA_WIDTH-1:0] ram [2**ADDRESS_WIDTH-1:0];

   integer i = 0;

   initial begin
   		for(i=0; i < 2**ADDRESS_WIDTH; i=i+1)
   			ram[i] = 100;
   end

   reg [ADDRESS_WIDTH-1:0] addr_b_r;
   
   always@(posedge clock) begin
      addr_b_r <= addr_b;
   end

   always @(posedge clock) begin
      if (we)  // write operation
         ram[addr_a] <= din;
   end

   assign dout = ram[addr_b_r];

endmodule