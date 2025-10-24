module vga_top (
    input wire clk_pix,     // pixel clock ~25 MHz
    input wire resetn,
    output wire hsync; 
    output wire vsync;
    output reg [2:0] rgb_r,       // 3 bits red
    output reg [2:0] rgb_g,       // 3 bits green
    output reg [2:0] rgb_b
)
    vga_timing vga_timing_1 (
        .clk_pix(clk_pix),
        .resetn(resetn),
        .hcount(),
        .vcount(),
        .hsync(hsync),
        .vsync(vsync),
        .de()
    )

    pixel_tpg pixel_tpg_1(
        .clk_pix(clk_pixel),     
        .resetn(),
        .hcount(vga_timing.hcount),      
        .vcount(vga_timing.vcount),
        .de(timing.de),         
        .mode(),        
        .rgb_r(),       
        .rgb_g(),       
        .rgb_b()
    )





