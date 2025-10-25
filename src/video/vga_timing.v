module vga_timing_640x480(
    parameter H_VISIBLE = 640,
    parameter H_FRONT_PORCH = 16,
    parameter H_SYNC_PULSE = 96,
    parameter H_BACK_PORCH = 48,
    parameter V_VISIBLE = 480,
    parameter V_FRONT_PORCH = 10,
    parameter V_SYNC_PULSE = 2,
    parameter V_BACK_PORCH = 29
    )(
    input wire clk_pix,
    input wire resetn,
    output wire [9:0] hcount,
    output wire [9:0] vcount,
    output wire hsync,
    output wire vsync,
    output wire de
);

localparam H_TOTAL = H_VISIBLE + H_FRONT_PORCH + H_SYNC_PULSE + H_BACK_PORCH;
localparam V_TOTAL = V_VISIBLE + V_FRONT_PORCH + V_SYNC_PULSE + V_BACK_PORCH;

always @(posedge clk_pix or posedge resetn) begin
    if (resetn) begin
        hcount <= 0;
        vcount <= 0;
    end else begin
        if (hcount == H_TOTAL - 1) begin
            hcount <= 0;
            if (vcount == V_TOTAL - 1)
                vcount <= 0;
            else
                vcount <= vcount + 1;
        end else begin
            hcount <= hcount + 1;
        end
    end
end

// Sync generation — active low typical
always @(posedge clk_pix) begin
    hsync <= ~((hcount >= (H_VISIBLE + H_FRONT_PORCH)) &&
                (hcount <  (H_VISIBLE + H_FRONT_PORCH + H_SYNC_PULSE)));
    vsync <= ~((vcount >= (V_VISIBLE + V_FRONT_PORCH)) &&
                (vcount <  (V_VISIBLE + V_FRONT_PORCH + V_SYNC_PULSE)));
end

// Data enable active during visible area
assign de = (hcount < H_VISIBLE) && (vcount < V_VISIBLE);

endmodule