module palette_dac (
    input wire clk_pix,
    input wire resetn,
    input wire [7:0] rgb_index,
    output reg [2:0] r,
    output reg [2:0] b,
    output reg [2:0] g,
)