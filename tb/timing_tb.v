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

    initial 
        $monitor("At time %2t, clk_pix = %d, resetn = %d, hcount = %d, vcount = %d, hsync = %d, locked = %d")
                $time, clk_pix, resetn, hcount, vcount, hsync, locked;

endmodule 
