# AGENTS.md

## Bend Setup (Windows)

Bend is installed at `~/.bend/`. The `bend` command is at `~/.bend/bin/bend.cmd`.
Bend version: 2.0.5. Runtime: Bun 1.4.2.

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

### Setup on Windows

1. Install Bun: `npm install -g bun --allow-scripts=bun`
2. Clone Bend: `git clone https://github.com/bendlang/bend.git ~/.bend/app/clone`
3. Create junction: `mklink /J ~/.bend/current ~/.bend/app/clone`
4. Add `~/.bend/bin` to PATH
5. Fix Windows path bug in bend.ts (line 1022: use path.dirname instead of lastIndexOf)

### Known Issues

- Path bug fix is local only - `git pull` in ~/.bend/app/clone will overwrite it
- Native GUI (App.run) does NOT work on Windows - only macOS (Metal) and Linux (X11)
- C compilation needs clang 19+ and POSIX headers (pthread) - MinGW gcc won't work
- See PROGRESS.md for full details on errors, syntax gotchas, and recommendations
