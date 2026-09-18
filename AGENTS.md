# AGENTS.md

## Bend Setup (Windows)

Bend is installed at `~/.bend/`. The `bend` command is at `~/.bend/bin/bend.cmd`.

### Commands

- `bend <file.bend>` - check and run a Bend file
- `bend <file.bend> -o <out>` - build a binary (.c for C, .js for JS)
- `bend guide` - print the full Bend guide
- `bend base` - print the Base library
- `bend --version` - print the version

### Using Bend

- Run `bend guide` to learn the language
- Use `LAWS.bend` to keep important rules
- Run `bend PROOF.bend` before committing
- Parallelize the code whenever possible

### Notes

- Bend compiles to C (needs clang 19+), Metal (macOS), CUDA (Linux), or JavaScript
- For quick iteration, use the JS target: `bend file.bend -o out.js`
- Windows support is limited; use WSL for full feature support
- Requires Bun (installed automatically) and Git

### Setup on Windows

1. Install Bun: `npm install -g bun --allow-scripts=bun`
2. Clone Bend: `git clone https://github.com/bendlang/bend.git ~/.bend/app/clone`
3. Create junction: `mklink /J ~/.bend/current ~/.bend/app/clone`
4. Add `~/.bend/bin` to PATH
5. Fix Windows path bug in bend.ts (line 1022: use path.dirname instead of lastIndexOf)
