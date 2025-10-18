module vga_timing_640x480(
    input wire clk_pix,
    input wire resetn,
    output wire [9:0] hcount,
    output wire [9:0] vcount,
    output wire hsync,
    output wire de,
)

always @(posedge clk_pix or posedge resetn) begin 
    if(resetn) begin

    end else begin 
        hcount <= hcount + 1;
    end
end
