module char_buffer (
  input  wire clk_a, we_a,
  input  wire [11:0] addr_a,
  input  wire [15:0] data_a,

  input  wire clk_b,
  input  wire [11:0] addr_b,
  output reg [15:0] data_b
);
  reg [15:0] mem [0:2399];

  // Write port
  always @(posedge clk_a)
    if (we_a)
      mem[addr_a] <= data_a;

  // Read port
  always @(posedge clk_b)
    data_b <= mem[addr_b];
endmodule
