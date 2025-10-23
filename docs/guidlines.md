# VGA Text Console Project — 14‑Day Build Plan

## Assumptions
- Target mode: **640×480 @ 60 Hz** (25.175 MHz pixel clock; 25.000 MHz fallback if monitor tolerant).
- Char cell: **8×16** pixels → **80×30** text grid (2400 cells).
- Character storage: 8-bit ASCII.
- Attribute storage: 8 bits (3-bit FG, 3-bit BG, 1-bit invert, 1-bit blink). Pack char+attr = **16 bits/cell** (or two 8-bit planes).
- Font ROM: **256 glyphs × 16 rows × 8 bits** = 4096 bytes.
- Colours: simple **3:3:2** or **3:3:3** RGB out (board-dependent).

## Top-Level Modules (build these)
1. `pixel_clk_gen`
2. `vga_timing_640x480`
3. `tile_addr` (x,y → col,row, scanline)
4. `charbuf_dp` (dual-port text/attr memory)
5. `font_rom_8x16`
6. `glyph_fetch` (gets glyph row byte)
7. `attr_decode` (FG/BG + blink/invert → RGB index)
8. `pixel_mux` (glyph bit → FG/BG select → palette)
9. `palette_dac` (RGB bits → pins)
10. `cursor_blink` (overlay XOR/invert on current cell)
11. `scroll_engine` (circular row base or copy-down)
12. `writer_if` (memory-mapped or UART text sink)
13. Test scaffolds: `timing_tb`, `renderer_tb`, `writer_tb`, `top_tb`

## Standard Interfaces
- **Timing bus:** `pix_clk, de, hsync, vsync, hcount[9:0], vcount[9:0]`
- **Tile addressing:** `hcount, vcount` → `col[6:0]` (0..79), `row[5:0]` (0..29), `scanline[3:0]` (0..15)
- **Char buffer read:** `addr = row*80 + col` (0..2399). Port A read @ `pix_clk`; Port B write @ `sys_clk` or `pix_clk`. Data: `{attr[7:0], char[7:0]}`
- **Font ROM:** `{char[7:0], scanline[3:0]}` → `glyph_row[7:0]`
- **Writer IF (mem-mapped):** `we, addr[11:0], wdata[15:0], ready`
- **Palette/DAC:** `rgb_index[8:0]` → `R[2:0], G[2:0], B[1:0 or 2:0]`

---

## Day-by-Day Plan

### Day 1 — Spec + Repo + Pinout
**Work**
- Freeze assumptions. Confirm PLL/DCM for 25.175 MHz (or 25.000 MHz fallback).
- Define **register map**:
  - `0x0000–0x095F` (2400 words): `{attr,char}` per cell (row-major).
  - `0x0A00`: control bits (cursor enable, blink enable, invert, scroll mode).
  - `0x0A01`: cursor position `{row[5:0], col[6:0]}`.
  - `0x0A02`: scroll base row (0..29) for circular-buffer mode.
- Repo structure:
  ```
  /src
  /tb
  /docs
  /assets
  /constraints
  ```
**Acceptance**: Specs documented; constraints compile without unresolved pins.

### Day 2 — `pixel_clk_gen` + `vga_timing_640x480`
**Work**
- Implement PLL/DCM for 25.175 MHz.
- Timing constants:
  - H: vis=640, fp=16, sync=96, bp=48 → total=800.
  - V: vis=480, fp=10, sync=2, bp=33 → total=525.
  - HSYNC active low during [640+16, 640+16+96).
  - VSYNC active low during [480+10, 480+10+2).
- Generate `de` for visible region.
**Acceptance**: TB checks period, HS/VS polarity/width, totals; `de` area = 640×480.

### Day 3 — Test Pattern Generator
**Work**
- Module that paints color bars from `hcount`, `vcount`.
- Route through `palette_dac` to VGA pins.
**Acceptance**: Stable image on monitor; no rolling/tearing.

### Day 4 — Font ROM asset + loader
**Work**
- Choose **8×16** monospace bitmap; convert to `.hex/.mem` with `{char, scanline}` addressing.
- Build `font_rom_8x16` (sync read, 1-cycle latency).
**Acceptance**: TB probes glyph rows and matches known patterns.

### Day 5 — Dual-port character buffer
**Work**
- `charbuf_dp`: True dual-port RAM, depth=2400, width=16.
- Port A read @ `pix_clk`; Port B write @ `sys_clk`.
- Optional write strobes per byte.
**Acceptance**: Randomized TB writes/reads match; no X-propagation.

### Day 6 — Tile addressing + glyph fetch
**Work**
- `tile_addr`:
  - `col = hcount[9:3]` (÷8), clamp 0..79 when `de`.
  - `row = vcount[8:4]` (÷16), clamp 0..29 when `de`.
  - `scanline = vcount[3:0]`.
- `glyph_fetch`:
  - Read `{attr,char}` from `charbuf_dp` at `col,row`.
  - ROM addr `{char,scanline}`.
  - Pipeline for latency; tap `glyph_row[7 - hcount[2:0]]`.
**Acceptance**: TB verifies pixel-to-bit alignment across char boundaries.

### Day 7 — Attribute decode + palette + pixel mux
**Work**
- `attr_decode`: handles invert, blink, cursor overlay; emits `is_fg`, `fg_idx`, `bg_idx`.
- `pixel_mux`: `rgb_index = is_fg ? fg_idx : bg_idx`.
- `palette_dac`: map to board pins.
**Acceptance**: TB covers all attr combinations → correct RGB selection.

### Day 8 — Cursor + Blink timers
**Work**
- `cursor_blink`: divider to ~0.5–1 Hz; cursor pos registers.
- Compare live `row,col`; output `cursor_on_here`.
**Acceptance**: TB shows correct period and one-cell overlay.

### Day 9 — Writer interface + “Hello” loader
**Work**
- `writer_if`: `we, addr, wdata, ready` (1-cycle).
- Optional init sequencer to fill “HELLO WORLD” and colours on row 0.
**Acceptance**: Hardware displays text in row 0 with colours.

### Day 10 — Scrolling engine
**Recommended (A) Circular row base**
- Keep `row_base` (0..29). `row_display = (row_base + row) % 30`.
- Advance on newline at bottom; clear next physical row.
**Alternative (B) Copy-down**
- Shift rows [1..29] → [0..28]; clear last row.
**Acceptance**: TB “prints” 100 lines; hardware shows clean wrap/clear.

### Day 11 — UART text sink
**Work**
- UART RX (e.g., 115200 baud).
- `text_sink`: handle ASCII, `\n`, `\r`, `\b`, tabs, wrapping; write `{attr,char}` through `writer_if`.
**Acceptance**: Serial text appears in real time; no drops (use small FIFO if needed).

### Day 12 — Full top integration + on-board tuning
**Work**
- Wire all modules: timing → addressing → charbuf → font → attr → mux → DAC.
- Add cursor, scroll, writer (UART).
- Tune porches ±2–4 clocks if monitor picky (keep totals).
**Acceptance**: Stable text, blinking cursor, UART updates, correct colours.

### Day 13 — Verification, timing, polish
**Work**
- Add assertions: pulse widths, totals, bounds, UART FIFO.
- Meet timing at 25.175 MHz; add pipeline regs in renderer if needed.
- Document resource usage, CDC, and bring-up steps.
**Acceptance**: Clean sim, timing met, docs written.

### Day 14 — Attributes & UX extras
**Work**
- Palette registers (optional).
- Add underline attribute (force bottom scanline 1 when set).
- Simple UART commands: clear screen, home, set colours.
- Record demo; finalize README.
**Acceptance**: Demo shows colours, scroll, cursor, and commands.

---

## Acceptance Checklist
- Timing: HS=96, VS=2; totals 800×525; `de` = 640×480.
- Glyph alignment: 8-pixel columns, 16-pixel rows; no skew.
- Latency alignment: char/attr and glyph row in phase with pixel.
- Cursor blink: ~0.5–1 Hz; only target cell affected.
- Scroll: clean advance and clear; no tearing.
- Throughput: 115200 baud, no dropped characters.
- Colours: verify ≥8 FG × 8 BG combinations.
- CDC: 2-FF sync for control if `sys_clk` ≠ `pix_clk`; dual-port RAM for data.

## Resource Budget (typical)
- Font ROM: 4 KB BRAM.
- Char buffer: 2400×16 ≈ 38.4 Kb → 2–3 BRAMs.
- Logic: few hundred LUTs for timing, renderer, UART.

## Common Pitfalls & Mitigations
- Off-by-one porches → assert widths/totals in TB.
- Read latency mismatch → add renderer pipeline stage; assert alignment.
- Tearing on writes → dual-port avoids contention; optionally gate writes during `de=0`.
- 25 MHz vs 25.175 MHz → many monitors accept 25.000; otherwise use exact PLL.

## Stretch Goals
- Double-buffered char RAM.
- 9×16 font with line-drawing chars.
- ANSI subset for colours/moves.
- AXI-Lite/APB/Wishbone adapter instead of UART.