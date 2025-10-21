module vga_timing_top;
    reg clk_pix, resetn;  
    wire[9:0] hcount, vcount;
    wire hsync, locked;
    vga_timing_block vt1 (clk_pix, resetn, hcount, vcount, hsync, locked);
 
initial begin 
    $dumpfile("vga_timing");
    $dumpvars(0,vga_timing_test);


vga_timing_640x480 dut (
    .clk_pix,
    .resetn,
    .hcount,
    .vcount,
    .hsync,
    .de
);

pixel_clk_gen0 dut2 (
    .clk_in,  //system clock, 100 MHz
    .resetn,
    .clk_pix,   //25 MHz (should be 25.175 but wtv)
    .locked
);