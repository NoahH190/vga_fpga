Welcome! These instructions help an AI coding agent become productive in this repo (a small VGA text-console FPGA project).

Key goals for agents interacting with this repository:
- Preserve the project's timing-first design: 640x480 @ 60 Hz, 25.175 MHz pixel clock (many modules assume 8x16 glyphs, 80x30 text grid).
- Avoid changing established signal names and timing interfaces without confirming (examples: `clk_pix`, `de`, `hcount`, `vcount`, `hsync`, `vsync`).

Useful high-level architecture (must-read files):
- `src/pixel_clk_gen.v` — pixel clock generator (simple divider / placeholder for a PLL/DCM). Keep the output named `clk_pix` and `locked` where present.
- `src/vga_timing.v` — horizontal/vertical counters, `de`, `hsync`, `vsync`, `hcount`, `vcount`.
- `rom.v` — font/ascii ROM. This file contains the glyph bitmap data and uses a BRAM-friendly case structure.
- `src/tpg.v` — test pattern generator used by early bring-up.
- `src/top_text_console.v` — top-level integration point (currently empty in tree; use this as the integration hub).

Project conventions and patterns (specific, not generic):
- Timing-first, pipeline-aware design: many modules assume 1-cycle read latency from ROMs/RAMs. When adding pipeline registers, adjust tap points for `hcount`/`vcount` and `hcount[2:0]` used to select glyph bit within a byte.
- Tile addressing convention: character column = hcount[9:3], row = vcount[8:4], scanline = vcount[3:0]; character address = row*80 + col (0..2399). Implementations may clamp values when `de` is low.
- Dual-clock/domains: character memory is expected to be dual-port (pixel-read at `clk_pix`, writer on `sys_clk`). Use proper CDC (2-FF synchronizers) for control/status registers.
- ROM/BRAM pragmas: `rom.v` uses `(* rom_style = "block" *)` and case statements for synthesis-friendly ROM inference. Follow this style when adding ROM data.
- Pixel values: palette/DAC typically use 3:3:2 or 3:3:3 bit splits. Keep signal names like `rgb_r`, `rgb_g`, `rgb_b` where possible.

Developer workflows and commands (what I discovered):
- Simulation: testbenches are under `tb/` (e.g., `timing_tb.v`, `renderer_tb.v`). Run them with your standard Verilog simulator (Icarus/ModelSim/Verilator). There is no repo-level script; use your toolchain's normal invocation.
- Synthesis/FPGA build: constraints are in `constraints/board_pins.xdc`. The project target clock expects a 25.175 MHz pixel clock; `pixel_clk_gen.v` currently implements a simple divider (25 MHz). Replace with a device-specific PLL/DCM IP for final builds.

Files to read first when making changes:
- `guidlines.md` — high-level plan and module list (this is the authoritative design doc).
- `docs/timing.md` — explicit timing constants (porches, sync widths, totals).
- `rom.v` — glyph ROM (large file; don't reformat or compress it unless updating glyphs).
- `src/pixel_clk_gen.v` and `src/vga_timing.v` — timing glue and important signal names.

Editing rules for AI agents (short checklist):
1. Do not change visible signal/interface names (`clk_pix`, `de`, `hcount`, `vcount`, `hsync`, `vsync`, `clk_in`) unless updating all call sites.
2. When adding registers across clock domains, add 2-flop synchronizers for single-bit control signals and use dual-port RAM for framebuffer data.
3. Keep ROM initialisation style consistent: use case statements with `(* rom_style = "block" *)` for large data blobs.
4. For timing-sensitive paths (glyph fetch -> pixel mux -> DAC), prefer inserting staged registers and update corresponding testbenches to match new latency.
5. Preserve existing file-level formatting for large generated blobs (e.g., `rom.v`) — don't reformat the whole file in a single commit.

Examples pulled from the repo (explicit patterns to follow):
- Addressing: use `col = hcount[9:3]; row = vcount[8:4]; scanline = vcount[3:0];` when translating pixel coordinates to glyph memory.
- ROM interface: synchronous read with registered address then combinational case -> data, similar to `rom.v`'s `addr_reg` and case block.

When you cannot infer required behavior from code: ask for clarification. For example:
- If a change affects physical pins or timing (porches/clocking) — request target FPGA board and preferred PLL settings.
- If adding a new bus or register map entry — request the intended host interface (UART, memory-mapped bus, Wishbone/AXI-lite).

If you modify or add a top-level file, update `guidlines.md` or `docs/` with a 1–2 line note describing the change and why.

Next steps for maintainers: review and confirm any missing build steps or preferred simulator command. If you want, tell me the preferred simulator and FPGA toolchain and I will add explicit run commands into this file.

---
If anything in here is unclear or you want additional sections (e.g., simulator commands, FPGA toolchain notes, or a module dependency graph), tell me what toolchain you use and I will iterate.
