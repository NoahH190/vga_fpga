module pixel_tpg(
  input  wire clk_pix,     // pixel clock ~25 MHz
  input  wire resetn,
  input  wire [9:0] hcount,      // from vga_timing
  input  wire [9:0] vcount,
  input  wire de,          // data enable (active area)
  input  wire [1:0] mode,        // 0=color bars,1=grid,2=checker,3=char-cell markers
  output reg [2:0] rgb_r,       // 3 bits red
  output reg [2:0] rgb_g,       // 3 bits green
  output reg [2:0] rgb_b        // 2 bits blue (or 3 if available)
);

always @(posedge clk_pix) begin
  if (resetn) begin
    
  end else if(de) begin
    rgb_r <= 3'b000;
    rgb_g <= 3'b000;     
    rgb_b <= 3'b000;
    end else if (mode == 2'b00) begin //colour bars
      if ((hcount => 80 && hcount <= 159) || (hcount => 320 && hcount <= 399) || (hcount => 560 && hcount <= 639))
        rgb_r <= 3'b111;
      else if ((hcount => 160 && hcount <= 239) || (hcount => 400 && hcount <= 479) || (hcount => 640 && hcount <= 719))
        rgb_g <= 3'b111;
      else ((hcount => 240 && hcount <= 319) || (hcount => 480 && hcount <= 559))
        rgb_b <= 3'b111;
    end 
    else if (mode == 2'b01) begin //grid
      if (() || () || ())
        rgb_r <= 3'b111;
      else if (() || () || ())
        rgb_g <= 3'b111;
      else (() || ())
        rgb_b <= 3'b111;     
    end 
    else if (mode == 2'b10) begin //checker
      if (() || () || ())
        rgb_r <= 3'b111;
      else if (() || () || ())
        rgb_g <= 3'b111;
      else (() || ())
        rgb_b <= 3'b111;
    end 
    else if (mode == 2'b11) begin //cell markers
      if (() || () || ())
        rgb_r <= 3'b111;
      else if (() || () || ())
        rgb_g <= 3'b111;
      else (() || ())
        rgb_b <= 3'b111;
    end

end