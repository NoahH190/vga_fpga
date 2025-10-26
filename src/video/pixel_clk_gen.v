module pixel_clk_gen(
    input wire clk_in,  //system clock, 100 MHz
    input wire resetn,
    output reg clk_pix,   //25 MHz (should be 25.175 but wtv)
);

// create a clock divider to get a pixel clock of 25 MHz, divide by 4

    localparam divisor = 2;
    reg [31:0] counter = 32'd0;

    always @(posedge clk_in or negedge resetn) begin
        if (!resetn) begin 
            counter <= 32'd0;
            clk_pix <= 1'b0;
        end else begin 
            if(counter >= divisor - 1) begin
                clk_pix <= ~clk_pix;
                counter <= 32'd0;
            end else 
                counter <= counter + 1;
        end
    end
    
endmodule 