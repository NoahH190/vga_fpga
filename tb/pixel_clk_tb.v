module pixel_clk_tb();

    reg clk_in;
    reg resetn;
    wire clk_pix;
    wire locked;

    // Instantiate the pixel clock generator
    pixel_clk_gen uut (
        .clk_in(clk_in),
        .resetn(resetn),
        .clk_pix(clk_pix),
        .locked(locked)
    );

    // Generate system clock (100 MHz)
    initial begin
        $dumpfile("pixel_clk_tb.vcd"); $dumpvars;
        clk_in = 0;
        forever #5 clk_in = ~clk_in; // 10 ns period
    end

    // Test sequence
    initial begin
        $dumpfile("pixel_clk_tb_2.vcd"); $dumpvars;
        resetn = 0;
        #20; // Hold reset for 20 ns
        resetn = 1;

        #2000; // Run for 2000 ns

        // Finish simulation
        $finish;
    end