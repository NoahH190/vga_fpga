# VGA 640x480 @ 60 Hz Timing Specification

## Horizontal Timing

| Segment       | Pixels | Range (Cumulative) |
|----------------|--------|--------------------|
| Visible area   | 640    | 0 – 639            |
| Front porch    | 16     | 640 – 655          |
| Sync pulse     | 96     | 656 – 751          |
| Back porch     | 48     | 752 – 799          |
| **Total**      | **800** |                    |

## Vertical Timing

| Segment       | Lines  | Range (Cumulative) |
|----------------|--------|--------------------|
| Visible area   | 480    | 0 – 479            |
| Front porch    | 10     | 480 – 489          |
| Sync pulse     | 2      | 490 – 491          |
| Back porch     | 33     | 492 – 524          |
| **Total**      | **525** |                    |

**Notes:**
- Pixel clock: 25.175 MHz
- Frame rate: 59.94 Hz (nominal 60 Hz)
- HSYNC active low during pixels 656–751
- VSYNC active low during lines 490–491
