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

    end else if (mode == 2'b01) begin //grid

    end else if (mode == 2'b10) begin //checker

    end else if (mode == 2'b11) begin //cell markers

    end

end