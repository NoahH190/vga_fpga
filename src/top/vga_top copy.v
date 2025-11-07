module vga_top (
    input wire clk_pix,     // pixel clock ~25 MHz
    input wire resetn,
    output wire hsync,
    output wire vsync,
    output reg [2:0] rgb_r,       // 3 bits red
    output reg [2:0] rgb_g,       // 3 bits green
    output reg [2:0] rgb_b
)


    wire [9:0] hcount:
    wire [9:0] vcount:
    wire de;
    wire vga_hsync;
    wire vga_vsync;
    
    vga_timing vga_timing_1 (
        .clk_pix(clk_pix),
        .resetn(resetn),
        .hcount(hcount),
        .vcount(vcount),
        .hsync(hsync),
        .vsync(vsync),
        .de()
    );

    assign rgb_r = vga_vid ? 3'b111 : 3'b000;
    assign rgb_g = vga_vid ? 3'b111 : 3'b000;
    assign rgb_b = vga_vid ? 3'b111 : 3'b000;
    assign hsync = ~vga_hsync;
    assign vsync = ~vga_vsync;

endmodule





