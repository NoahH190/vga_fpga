module vga_timing_test;
    reg clk_pix, resetn;  
    wire[9:0] hcount, vcount;
    wire hsync, locked;
    vga_timing_block vt1 (clk_pix, resetn, hcount, vcount, hsync, locked);
 
initial begin 
    $dumpfile("vga_timing.vcd");
    $dumpvars(0,vga_timing_test);
    
    clk_pix = 0; b = 0; #10;
    clk_pix = 0; b = 1; #10;
    clk_pix = 1; b = 0; #10;
    clk_pix = 1; b = 1; #10;

    $finish;
end




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