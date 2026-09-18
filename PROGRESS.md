# Bend on Windows - Progress Report

## What Works

- **Bend type-checks and runs on Windows** via the Bun/JS backend
- `bend hello.bend` prints "Hello, world!" successfully
- `bend file.bend -o file.js` compiles to JavaScript
- `bend file.bend -o file.c` emits C source (but can't compile natively - needs pthreads/X11)

## Setup Steps (verified working)

1. `npm install -g bun --allow-scripts=bun` (installs Bun 1.4.2)
2. `git clone https://github.com/bendlang/bend.git ~/.bend/app/clone`
3. `mklink /J ~/.bend\current ~/.bend\app\clone` (junction, not symlink - no admin needed)
4. Create `~/.bend/bin/bend.cmd`:
   ```
   @echo off
   bun "%USERPROFILE%\.bend\current\bend2\main.ts" %*
   ```
5. Add `~/.bend/bin` to user PATH

## Bug Fixed: Windows Path Separator

**File:** `~/.bend/current/bend2/bend.ts`, line 1022

**Original code (broken on Windows):**
```js
const dir = file.slice(0, file.lastIndexOf("/") + 1);
```

**Problem:** On Windows, `fs.realpathSync()` returns paths with backslashes
(e.g. `C:\Users\simon\.bend\app\clone\bend2\base.bend`). `lastIndexOf("/")`
returns -1, so `dir` becomes an empty string. This breaks foreign imports in
`base.bend` (like `import "./effs/print.c"`) because they resolve relative to
CWD instead of base.bend's directory. Error: `ENOENT: no such file or
directory, lstat '<CWD>\effs'`.

**Fixed code:**
```js
const dir = path.dirname(file).replace(/\\/g, "/") + "/";
```

**Note:** This fix lives in the cloned repo at `~/.bend/app/clone/bend.ts`. It
will be overwritten if you `git pull`. The upstream repo does not support
Windows natively.

## What Doesn't Work

### Native Window/GUI

Bend's window system (`App.run`, `Window.open`) only has backends for:
- **macOS:** Metal + AppKit (`#ifdef __OBJC__` in `window_open.c`)
- **Linux:** X11 (`#elif defined(__linux__)` in `window_open.c`)
- **Windows/other:** Falls through to `ENOTSUP` error

The JS backend also doesn't support windows (`window_open.js` throws
"no display" immediately).

**Bottom line:** No native GUI on Windows. The `gui_hello.bend` file compiles
and type-checks but can't open a window.

### C Compilation

`bend file.bend -o file.c` emits C, but compiling on Windows fails:
- MinGW gcc lacks `pthread.h`
- No X11 headers for the window system
- Would need clang 19+ and WSL or cross-compilation

### Bend's Known Limitations (from README)

- "No Windows (WSL works)"
- Recursion must be terminating (use `@unsafe` to disable)
- Values are affine: closures/arrays can't be shared freely
- No type classes, traits, or macros
- Strings are linked lists (slow text processing)

## Bend Syntax Gotchas (affine types)

Bend is affine by default - variables can only be used once. Common errors:

| Error | Fix |
|-------|-----|
| `offset (consumed more than once)` | Add `+` prefix: `+offset: U32` |
| `a match cannot scrutinize a computed value` | Extract to a separate `def` |
| `cannot infer` on lambdas | Use `Maybe.bind` pattern or separate def |

Pattern for chaining Maybe operations (from demos):
```bend
def events(events: List<Event>, +offset: U32) -> Maybe<U32>:
  match events:
    case []:
      Some{offset}
    case e <> rest:
      Maybe.bind(&1, U32, U32, event(e, offset), m => events(rest, m))
```

## Files in This Project

- `AGENTS.md` - Agent instructions for using Bend
- `PROGRESS.md` - This file
- `hello.bend` - Working "Hello, world!" program
- `gui_hello.bend` - GUI source (compiles, no Windows window support)
- `gui_hello.html` - Standalone HTML canvas demo (not Bend-related)

## Recommendations for Future Work

1. **WSL approach:** Install WSL2, then follow Linux setup. Bend GUI works
   with X11. This is the officially supported path.
2. **Upstream fix:** The path bug fix should go upstream to bendlang/bend.
3. **C compilation:** If clang 19+ is installed (e.g. via LLVM releases),
   native compilation might work for non-GUI programs, but still needs
   pthreads (available in MinGW-w64 or clang targetting POSIX).
4. **HTML bridge:** The JS output (`bend file.bend -o file.js`) could
   theoretically be adapted for browser use by replacing Node.js builtins
   with browser equivalents, but this would be non-trivial.
