module vga_timing_640x480(
    input wire clk_pix,
    input wire resetn,
    output wire [9:0] hcount,
    output wire [9:0] vcount,
    output wire hsync,
    output wire de,
);

always @(posedge clk_pix or posedge resetn) begin 
    if(resetn) begin
        hcount <= 10'b0;
        vcount <= 10'b0;
    end else begin 
        if(hcount < 752 && hcount > 655)
            hsync <= ~hsync;
        if(vcount < 489 && vcount > 492)
            vsync <= ~vsync;
        if(hcount <= 799)
            hcount <= 10'b0;
        if(vcount <= 524)
            vcount <= 10'b0;
        else begin 
            hcount <= hcount + 1;
            vcount <= vcount + 1;
        end
    end
end

assign de <= (hcount < 640) && (vcount < 480);
