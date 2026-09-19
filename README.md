# Bend GUI Experiment

A text input application built with [Bend](https://github.com/HigherOrderCO/Bend) — a massively parallel, functional language — running on Windows via WSL2 and WSLg.

<img width="524" height="287" alt="Notepad Screenshot" src="https://github.com/user-attachments/assets/006d401f-e839-443e-aa8e-8a4385e20f82" />

## What is this?

This project explores building GUI applications in Bend, a language designed for parallel computation. The app renders a Minecraft-style 7x9 pixel font, handles keyboard input (typing, backspace, enter, escape), and displays text in a window using SDL2 through WSLg.

## Features

- **7x9 pixel font** — 63-bit glyphs stored as two U32 values (A-Z, a-z, 0-9, punctuation)
- **Real-time keyboard input** — characters render immediately on keypress
- **Multi-line wrapping** — 21 characters per line at 3x scale
- **Backspace and Enter** — full editing support
- **512x256 window** — rendered on Windows desktop via WSLg

## Setup

### Prerequisites

- Windows with WSL2 enabled
- WSLg (Windows Subsystem for Linux GUI)
- [Bend](https://github.com/HigherOrderCO/Bend) installed (in ~/.bend/)
- clang and build-essential in WSL
- Bun (for Bend runtime)

### Running

**Via Windows launcher (easiest):**
```cmd
run_gui.bat
```

**Manual build and run:**
```bash
# Copy the source to WSL
cp /mnt/c/Users/.../Desktop/bend-gui-experiment/gui_app.bend ~/gui_app.bend

# Set display environment
export DISPLAY=:0
export WAYLAND_DISPLAY=wayland-0
export XDG_RUNTIME_DIR=/mnt/wslg/runtime-dir

# Build native binary
~/.bend/bin/bend ~/gui_app.bend -o ~/gui_app

# Run (window appears on Windows desktop)
~/gui_app
```

## Project Structure

| File | Description |
|------|-------------|
| `gui_app.bend` | Main application (~280 lines) |
| `run_gui.bat` | Windows launcher script |
| `gen_font.js` | 5x6 font generator (Node.js) |
| `gen_font7x9.js` | 7x9 Minecraft font generator (Node.js) |
| `PROGRESS.md` | Detailed development log |

## How it works

The Bend program defines a `Gui` data type that holds input state and cursor position. A quadtree-based rendering system recursively subdivides the screen, using the font lookup tables to determine pixel colors. Keyboard events are processed through a pattern-matching event handler that appends characters to an input list.

## Contributing

Pull requests are welcome! Feel free to experiment with:

- Cursor blink / position indicator
- Text selection and clipboard support
- Scrollback for multi-line history
- Color themes
- Larger window sizes

## Acknowledgments

Built on [Bend](https://github.com/HigherOrderCO/Bend) by HigherOrderCO, with WSLg support for running GUI applications on Windows.
