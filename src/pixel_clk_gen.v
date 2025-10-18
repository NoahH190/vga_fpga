module pixel_clk_gen(
    input wire clk_in,  //system clock, 100 MHz
    input wire resetn,
    output wire clk_pix,   //25.175 MHz
    output wire locked
)

// create a clock divider to get a pixel clock of 25.175 MHz, divide by 3.972

    localparam divisor = 4;
    reg [31:0] counter = 32'd0;

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin 
            counter <= 32'd0;
            clock_out <= 1'b0;
        end else begin 
            counter <= counter + 1;
            if(counter >= divisor - 1) begin
                clock_pix <= ~clock_pix;
                counter <= 32'd0;
            end
        end
    end

endmodule 