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
    else if (mode == 2'b01) begin //checker
      if ((hcount >= 134 && hcount <= 143) ||
      (hcount >= 188 && hcount <= 197) ||
      (hcount >= 242 && hcount <= 251) ||
      (hcount >= 296 && hcount <= 305) ||
      (hcount >= 350 && hcount <= 359) ||
      (hcount >= 404 && hcount <= 413) ||
      (hcount >= 458 && hcount <= 467) ||
      (hcount >= 512 && hcount <= 521) ||
      (hcount >= 566 && hcount <= 575) ||
      (hcount >= 620 && hcount <= 629) ||
      (vcount >= 23  && vcount <= 32)  ||
      (vcount >= 77  && vcount <= 86)  ||
      (vcount >= 131 && vcount <= 140) ||
      (vcount >= 185 && vcount <= 194) ||
      (vcount >= 239 && vcount <= 248) ||
      (vcount >= 293 && vcount <= 302) ||
      (vcount >= 347 && vcount <= 356) ||
      (vcount >= 401 && vcount <= 410) ||
      (vcount >= 455 && vcount <= 464))
        rgb_r <= 3'b111;
      else if ( ((hcount >= 134 && hcount <= 143) && ((vcount >= 23  && vcount <= 32) ||
      (vcount >= 131 && vcount <= 140) ||
      (vcount >= 239 && vcount <= 248) ||
      (vcount >= 347 && vcount <= 356) ||
      (vcount >= 455 && vcount <= 464))) ||

      ((hcount >= 188 && hcount <= 197) && ((vcount >= 77  && vcount <= 86)  ||
      (vcount >= 185 && vcount <= 194) ||
      (vcount >= 293 && vcount <= 302) ||
      (vcount >= 401 && vcount <= 410))) ||

      ((hcount >= 242 && hcount <= 251) && ((vcount >= 23  && vcount <= 32)  ||
      (vcount >= 131 && vcount <= 140) ||
      (vcount >= 239 && vcount <= 248) ||
      (vcount >= 347 && vcount <= 356) ||
      (vcount >= 455 && vcount <= 464))) ||

      ((hcount >= 296 && hcount <= 305) && ((vcount >= 77  && vcount <= 86)  ||
      (vcount >= 185 && vcount <= 194) ||
      (vcount >= 293 && vcount <= 302) ||
      (vcount >= 401 && vcount <= 410))) ||

      ((hcount >= 350 && hcount <= 359) && ((vcount >= 23  && vcount <= 32)  ||
      (vcount >= 131 && vcount <= 140) ||
      (vcount >= 239 && vcount <= 248) ||
      (vcount >= 347 && vcount <= 356) ||
      (vcount >= 455 && vcount <= 464))) ||

      ((hcount >= 404 && hcount <= 413) && ((vcount >= 77  && vcount <= 86)  ||
      (vcount >= 185 && vcount <= 194) ||
      (vcount >= 293 && vcount <= 302) ||
      (vcount >= 401 && vcount <= 410))) ||

      ((hcount >= 458 && hcount <= 467) && ((vcount >= 23  && vcount <= 32)  ||
      (vcount >= 131 && vcount <= 140) ||
      (vcount >= 239 && vcount <= 248) ||
      (vcount >= 347 && vcount <= 356) ||
      (vcount >= 455 && vcount <= 464))) ||

      ((hcount >= 512 && hcount <= 521) && ((vcount >= 77  && vcount <= 86)  ||
      (vcount >= 185 && vcount <= 194) ||
      (vcount >= 293 && vcount <= 302) ||
      (vcount >= 401 && vcount <= 410))) ||

      ((hcount >= 566 && hcount <= 575) && ((vcount >= 23  && vcount <= 32)  ||
      (vcount >= 131 && vcount <= 140) ||
      (vcount >= 239 && vcount <= 248) ||
      (vcount >= 347 && vcount <= 356) ||
      (vcount >= 455 && vcount <= 464))) ||

      ((hcount >= 620 && hcount <= 629) && ((vcount >= 77  && vcount <= 86)  ||
      (vcount >= 185 && vcount <= 194) ||
      (vcount >= 293 && vcount <= 302) ||
      (vcount >= 401 && vcount <= 410))) )
        rgb_g <= 3'b111;
      else
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