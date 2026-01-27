module mem_read_write
#(
    parameter DATA_SIZE = 6 // nb bits 
)
  (
   input wire                   clk,
   input wire                   reset_n,
   input wire                   mem_sel,
   input wire [DATA_SIZE-1:0]   mem_data_i, // mem to write
   input wire                   we,         // write enable 
   output wire                  mem_ready,
   output wire [31:0]           mem_data_o // mem to read
   );

   reg [DATA_SIZE-1:0]          data = 'b0;

   assign mem_data_o = {{(32-DATA_SIZE){1'b0}}, data};
   assign mem_ready = mem_sel;

   always @(posedge clk or negedge reset_n)
     if (!reset_n) 
       data <= 'b0;
     else if (mem_sel)
       if (we) data <= mem_data_i;

endmodule // mem_read_write