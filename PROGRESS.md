# Bend GUI Text Input — Progress Log

## Goal
Build a Bend GUI text input application with a readable Minecraft-style pixel font, displayed via WSLg on Windows.

## Setup
- **Windows Bend**: `C:\Users\simon\.bend\bin\bend.cmd` (v2.0.5, Bun 1.4.2)
- **WSL Bend**: `~/.bend/bin/bend` wrapper → `~/.bun/bin/bun` (native WSL bun)
- **WSL packages**: `clang` (v18), `build-essential`, `libasound2-dev`, `libx11-dev`
- **WSLg**: `/mnt/wslg/runtime-dir/wayland-0` socket

## Key Bend Constraints Learned
- No hex literals, no matching on computed values, `let` can't precede `match`
- Functions must be defined before use
- `+` prefix for Data/reusable arguments
- `List<&2, U32>` for reusable lists
- **Key events**: pattern `Key{code, down}` (not `Key{code, True{}}`)
- **Can't assign Nat literals** like `+x = 28n` — must inline: `Nat.mul(line, 28n)`
- `Gui.flat` disabled (`False{}`) to prevent text garbling (slower but correct)

## Font Evolution
| Version | Font | Scale | Char Cell | Chars/Line | Status |
|---------|------|-------|-----------|------------|--------|
| v1 | 3×5 | 2× | 4×6 | 21 | Garbled |
| v2 | 3×5 | 3× | 4×8 | 15 | Garbled |
| v3 | 3×5 | 4× | 4×10 | 12 | Garbled |
| v4 | 3×5 | 6× | 4×14 | 9 | Readable but tiny |
| v5 | 5×6 | 6× | 6×14 | 14 | Readable |
| **v6 (current)** | **7×9** | **3×** | **8×12** | **21** | **Working!** |

## What Works
- ✅ WSL2 + WSLg + native bun + clang toolchain
- ✅ C backend patches: resizable window (`window_open.c`, `window_frame.c`)
- ✅ Bend compiles without errors (both interpreter and native binary)
- ✅ Window opens via WSLg: "Bend - Text Input" 512×256
- ✅ Key input: characters appear immediately on keypress
- ✅ Text direction: correct reading order (fixed via `List.len` + reverse indexing)
- ✅ Multi-line wrapping: 21 chars/line at 3× scale
- ✅ Backspace handling (codes 8, 127, 65288) — fixed to delete last char
- ✅ Enter clears input
- ✅ Escape/Close quits app
- ✅ 7×9 Minecraft font: 63 bits/glyph stored as two U32 (lo: bits 0-31, hi: bits 32-62)
- ✅ `Font.get_lo` / `Font.get_hi` lookup tables (77 chars: A-Z, a-z, 0-9, punctuation)
- ✅ `Font.pixel` extracts bits correctly from both halves
- ✅ Native binary runs via WSLg (`~/gui_app`)
- ✅ Windows launcher: `run_gui.bat`

## Files
- `C:\Users\simon\Desktop\bend-test\gui_app.bend` — main app (~280 lines)
- `C:\Users\simon\Desktop\bend-test\run_gui.bat` — Windows launcher
- `C:\Users\simon\Desktop\bend-test\gen_font.js` — 5×6 font generator (Node.js)
- `C:\Users\simon\Desktop\bend-test\gen_font7x9.js` — 7×9 Minecraft font generator (Node.js)
- `~/.bend/bin/bend` (WSL) — wrapper using `~/.bun/bin/bun`
- `~/.bend/clone/bend2/effs/window_open.c` — patched: `SDL_WINDOW_RESIZABLE`
- `~/.bend/clone/bend2/effs/window_frame.c` — patched: `SDL_WINDOWEVENT_RESIZED` handler

## Commands
```bash
# Windows: compile
& "$env:USERPROFILE\.bend\bin\bend.cmd" gui_app.bend

# WSL: copy file
cp /mnt/c/Users/simon/Desktop/bend-test/gui_app.bend ~/gui_app.bend

# WSL: build native binary
export DISPLAY=:0; export WAYLAND_DISPLAY=wayland-0; export XDG_RUNTIME_DIR=/mnt/wslg/runtime-dir
~/.bend/bin/bend ~/gui_app.bend -o ~/gui_app

# WSL: run (window appears on Windows desktop)
~/gui_app

# Windows: launch via WSLg
run_gui.bat
```

## Troubleshooting
- **"no display"**: Close fullscreen games, or `wsl --shutdown` then reopen Ubuntu
- **WSLg socket**: Check `/mnt/wslg/runtime-dir/wayland-0` exists
- **Env vars needed**: `DISPLAY=:0`, `WAYLAND_DISPLAY=wayland-0`, `XDG_RUNTIME_DIR=/mnt/wslg/runtime-dir`

## Next Steps (Optional Polish)
- [ ] Cursor blink / position indicator
- [ ] Text selection / clipboard
- [ ] Scrollback for multi-line history
- [ ] Increase window size for more lines
- [ ] Color themes

## Changelog
- **2026-09-19**: Fixed backspace handling — added explicit `Key{8, True{}}`, `Key{127, True{}}`, `Key{65288, True{}}` cases in `Gui.on_event` to call `Gui.on_backspace`. Removed dead code (`Gui.on_key_go`, `Gui.on_key`, `Gui.on_char*`, `Gui.on_backspace_go`). Cleaned up test files (HTML, C, old Bend scripts, binaries). Rebuilt native binary. Verified: typing, backspace, Enter, Escape, multi-line wrapping all work.