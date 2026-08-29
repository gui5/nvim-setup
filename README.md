# Modern Full-Stack Neovim 0.12 Configuration

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Neovim](https://img.shields.io/badge/Neovim-0.12+-57A143?logo=neovim&logoColor=white)](https://neovim.io)
[![Lua](https://img.shields.io/badge/Lua-5.1-000080?logo=lua&logoColor=white)](https://www.lua.org)

A fast, modular, and fully-featured Neovim 0.12 configuration tailored for **C & C++**, **Rust**, **Web Development (React, TypeScript, JavaScript, HTML, CSS, Tailwind)**, **Python**, and **Go (Golang)** software engineering.

---

## 🚀 Cross-Platform Installation (Ubuntu, Arch, Fedora, macOS)

Run the included automated setup script:
```bash
./setup.sh
```

---

## 🌟 Highlights

- **⚡ Fast & Modern**: Built natively for Neovim 0.12 using the native `vim.lsp.config` & `vim.lsp.enable()` API and `lazy.nvim`.
- **🧠 Full Multi-Language Intelligence**:
  - **C & C++**: `clangd` + `clangd_extensions` (AST view, type hierarchy, source/header switch, memory layout).
  - **Rust**: `mrcjkb/rustaceanvim` + `rust-analyzer` (macro expansion, docs.rs, runnables/testables, clippy check on save, parent module navigation).
  - **Markdown & Documentation**: `marksman` LSP + `render-markdown.nvim` (in-buffer rich styling for headings, codeblocks, checkboxes, callouts) + `markdown-preview.nvim` (live browser preview).
  - **Web & React**: `ts_ls` (TypeScript/JS), `tailwindcss` (Tailwind completions), `html`, `cssls`, `eslint`, `emmet_language_server`.
  - **Python**: `pyright` (type analysis & completions) + `ruff` (lightning-fast linting & code actions).
  - **Go (Golang)**: `gopls` (auto-imports, staticcheck, parameter inlay hints, placeholders).
  - **CMake & Lua**: `neocmakelsp` + `lua_ls`.
- **🚀 Ultra-fast Autocompletion**: Powered by `blink.cmp` (Rust-powered fuzzy matcher) with snippet and argument placeholder support.
- **🌲 Rich Treesitter & Auto-tagging**: Syntax highlighting for 25+ languages, textobjects, and `nvim-ts-autotag` for auto-closing/renaming JSX/HTML tags.
- **🐞 Native Debugging (DAP)**:
  - C/C++ & Rust: Native `gdb` (Linux) & `lldb-dap` (macOS).
  - Go: `delve` via `nvim-dap-go` (`<leader>dgt` to debug tests).
  - Python: `debugpy` via `nvim-dap-python` (`<leader>dpt` to debug test methods).
  - Visual DAP UI & inline virtual text variables.
- **🛠️ Multi-Language Floating Runners**:
  - `<leader>rc`: Compile/run active file (C, C++, Rust `cargo run`, Python, Go, Node, TSX, Bash, Lua) in a clean floating window.
  - `<leader>rt`: Run test suites in a floating window (Rust `cargo test`, CTest for CMake, `pytest` for Python, `go test` for Go, `npm test` for JS/TS).
- **✨ Formatting (`conform.nvim`)**: Prettier (JS/TS/React/HTML/CSS/JSON/Markdown), Rustfmt (Rust), Ruff (Python), Gofumpt/Goimports (Go), Clang-Format (C/C++), StyLua (Lua).
- **🎨 Visuals & QoL**: `moonfly` theme, inline Tailwind/CSS color badges (`brenoprata10/nvim-highlight-colors`), `trouble.nvim` diagnostics, `harpoon2`, `diffview.nvim`, `bufferline.nvim`, `todo-comments.nvim`, `oil.nvim`, and `neo-tree.nvim`.

---

## 📂 Architecture & Directory Layout

```
~/.config/nvim/
├── init.lua                      # Root entry point
├── lua/
│   ├── config/
│   │   ├── init.lua              # Sets <leader> (" ") & configures runtime PATH
│   │   ├── options.lua           # Neovim 0.12 options, clipboard & diagnostic style
│   │   ├── keymaps.lua           # Global navigation & editing keybindings
│   │   ├── autocmds.lua          # Autocommands (highlight on yank, buffer options)
│   │   └── lazy.lua              # lazy.nvim bootstrapper
│   └── plugins/
│       ├── lsp.lua               # Multi-language LSP (Clangd, TS, Tailwind, Pyright, Ruff, Gopls, Marksman)
│       ├── rust.lua              # rustaceanvim (Rust Analyzer, macro expansion, runnables)
│       ├── markdown.lua          # render-markdown.nvim & markdown-preview.nvim
│       ├── completion.lua        # blink.cmp autocompletion & snippets
│       ├── treesitter.lua        # nvim-treesitter, textobjects & nvim-ts-autotag
│       ├── dap.lua               # nvim-dap suite (GDB, LLDB, Delve, Debugpy)
│       ├── build.lua             # cmake-tools.nvim & multi-language floating runners
│       ├── formatting.lua        # conform.nvim (Prettier, Rustfmt, Ruff, Gofumpt, Clang-Format, StyLua)
│       ├── trouble.lua           # trouble.nvim diagnostics & symbols outline
│       ├── harpoon.lua           # Harpoon2 fast file switcher
│       ├── toggleterm.lua        # Toggleterm floating / split terminal
│       ├── surround.lua          # nvim-surround delimiter editor
│       ├── bufferline.lua        # bufferline.nvim visual tabs with LSP badges
│       ├── todo.lua              # todo-comments.nvim highlighter & search
│       ├── indent.lua            # indent-blankline.nvim active scope guides
│       ├── diffview.lua          # diffview.nvim git diff & merge resolver
│       ├── telescope.lua         # Telescope fuzzy finder
│       ├── ui.lua                # moonfly theme, colorizer, lualine, which-key, dressing
│       └── editor.lua            # neo-tree.nvim, oil.nvim, gitsigns, mini.pairs
├── demo/
│   ├── c_sample/                 # C Makefile sample project
│   ├── cpp_cmake_sample/         # Multi-file C++20 CMake project
│   ├── rust_sample/              # Rust 2021 Cargo project with tests
│   ├── web_react_ts/             # React 19 + TypeScript + Tailwind demo
│   ├── python_sample/            # Python 3 module + unittest demo
│   └── go_sample/                # Go module + unit tests demo
├── setup.sh                      # Universal cross-platform setup installer
└── README.md                     # Documentation & keymap guide
```

---

## ⌨️ Keybindings Cheat Sheet

Leader key is set to **`<Space>`**. Pressing `<Space>` will bring up an interactive `which-key` menu showing available commands.

### 1. Code & LSP Intelligence (`<leader>c`)

| Keymap | Action | Description |
|---|---|---|
| `gd` | Go to Definition | Jump to symbol definition |
| `gD` | Go to Declaration | Jump to symbol declaration |
| `gi` | Go to Implementation | Jump to interface implementation |
| `gt` | Go to Type Definition | Jump to type definition |
| `gr` | References | List all references |
| `K` | Hover Doc | View documentation / type signature |
| `<C-k>` (insert) | Signature Help | View parameter hints while typing |
| `<leader>cr` | Rename Symbol | Rename variable/function across project |
| `<leader>ca` | Code Action | Apply quick fixes, imports, and suggestions |
| `<leader>cM` | Expand Macro | Expand Rust macro recursively at cursor (`rustaceanvim`) |
| `<leader>cd` | Open Docs.rs | Open official online documentation for symbol (`rustaceanvim`) |
| `<leader>cR` | Rust Runnables | Interactively choose and run Rust binaries/benchmarks |
| `<leader>ct` | Rust Testables | Interactively choose and run Rust unit/integration tests |
| `<leader>ce` | Explain Error | Show official Rust error code explanation (e.g. E0382) |
| `<leader>cp` | Parent Module | Jump to parent module in Rust |
| `<leader>ch` | Switch Source/Header | Instant toggle between `.h`/`.hpp` and `.c`/`.cpp` |
| `<leader>cT` | Type Hierarchy | Explore base and derived classes (C++) |
| `<leader>cs` | Code Outline | Open Trouble symbols outline (functions, structs) |
| `<leader>cl` | LSP Definitions/Refs | Open Trouble LSP definitions/references panel |
| `<leader>cf` | Format Buffer | Format with Prettier, Rustfmt, Ruff, Gofumpt, or Clang-Format |
| `<leader>th` | Toggle Inlay Hints | Show / hide variable types and parameter hints inline |
| `<leader>tf` | Toggle Auto-format | Enable / disable format-on-save |

---

### 2. Multi-Language Runners & Testing (`<leader>r`)

| Keymap | Action | Description |
|---|---|---|
| `<leader>rc` | Run Active File | Executes current file in a **floating window** (C, C++, Rust `cargo run`, Python, Go, JS, TS, Bash, Lua) |
| `<leader>rt` | Run Test Suite | Runs tests in a **floating window** (`cargo test`, `go test`, `pytest`, `npm test`, `ctest`) |
| `<leader>ra` | AddressSanitizer (ASan) | Compiles & runs C/C++ with `-fsanitize=address,undefined` |
| `<leader>rv` | Valgrind Leak Check | Runs full memory leak check in a floating window |
| `<leader>rm` | Run Make | Executes `make` in current project root |

---

### 3. Debugging with DAP (`<leader>d` / Function Keys)

| Keymap | Action | Description |
|---|---|---|
| `<F5>` | Start / Continue | Launch or resume execution in debugger |
| `<F10>` | Step Over | Next source line (step over function calls) |
| `<F11>` | Step Into | Step into function call |
| `<F12>` | Step Out | Finish current stack frame and return |
| `<leader>db` | Toggle Breakpoint | Set / remove breakpoint at cursor |
| `<leader>dB` | Conditional Breakpoint | Set breakpoint with condition expression |
| `<leader>dp` | Log Point | Print message when hit without stopping |
| `<leader>dc` | Run to Cursor | Continue execution until reaching cursor line |
| `<leader>du` | Toggle DAP UI | Open / close visual debugging panels (variables, watches, stack) |
| `<leader>dr` | Open REPL | Open interactive debugger prompt |
| `<leader>dl` | Run Last | Re-run previous debug session |
| `<leader>dx` | Terminate Debugger | Stop debugging process |
| `<leader>dgt` | Debug Go Test | Run & debug current Go unit test under cursor |
| `<leader>dgl` | Debug Last Go Test | Re-run last Go test debug session |
| `<leader>dpt` | Debug Python Test | Debug current Python test method |
| `<leader>dpc` | Debug Python Class | Debug current Python test class |

---

### 4. Diagnostics & Trouble Panel (`<leader>x`)

| Keymap | Action | Description |
|---|---|---|
| `<leader>xx` | Project Diagnostics | Open Trouble bottom panel showing all workspace errors |
| `<leader>xX` | Buffer Diagnostics | Open Trouble panel filtered to current buffer |
| `<leader>xt` | Project TODOs | Open Trouble panel showing all `TODO:`, `FIXME:`, `BUG:` comments |
| `<leader>xL` | Location List | Open Location List in Trouble |
| `<leader>xQ` | Quickfix List | Open Quickfix List in Trouble |
| `[d` / `]d` | Diagnostic Jump | Jump to previous / next error or warning |

---

### 5. Harpoon2 Quick Navigation (`<leader>a` & `<leader>h`)

| Keymap | Action | Description |
|---|---|---|
| `<leader>a` | Add File to Harpoon | Bookmark the current file |
| `<leader>h` | Harpoon Quick Menu | Open popup menu of bookmarked files |
| `<leader>1` – `<leader>5` | Jump to File 1-5 | Instant jump to slot 1, 2, 3, 4, or 5 |

---

### 6. Terminal & Toggles (`<leader>t` / `<C-\>`)

| Keymap | Action | Description |
|---|---|---|
| `<C-\>` | Toggle Floating Terminal | Dropdown terminal from anywhere (normal & terminal mode) |
| `<leader>tt` | Toggle Floating Terminal | Open / close floating terminal window |
| `<leader>th` | Toggle Horizontal Split | Open / close horizontal terminal split |
| `<leader>tv` | Toggle Vertical Split | Open / close vertical terminal split |
| `<Esc><Esc>` | Normal Mode | Exit terminal insert mode back to normal mode |

---

### 7. Visual Tabs & Bufferline (`<leader>b` / `<S-h>` / `<S-l>`)

| Keymap | Action | Description |
|---|---|---|
| `<S-h>` / `<S-l>` | Previous / Next Tab | Switch active buffer tab |
| `<leader>bp` | Pin Tab | Pin / unpin current buffer tab |
| `<leader>bc` | Pick & Close Tab | Interactively pick a tab to close |
| `<leader>bl` / `<leader>br` | Close Left / Right | Close all tabs to the left or right |
| `<leader>bd` | Delete Buffer | Close current buffer safely |

---

### 8. Git & Diffview (`<leader>g`)

| Keymap | Action | Description |
|---|---|---|
| `<leader>gd` | Diffview Open | Open full-screen side-by-side Git diff viewer |
| `<leader>gD` | Diffview Close | Close Diffview |
| `<leader>ghf` | File History | View Git commit history of current file |
| `<leader>ghF` | Branch History | View Git commit history of entire repository |
| `[h` / `]h` | Jump Git Hunk | Jump to previous / next modified hunk |
| `<leader>ghp` | Preview Hunk | Floating preview of changes in current hunk |
| `<leader>gb` | Git Blame | Show Git blame for current line |

---

### 9. File Explorers & Trees

| Keymap | Action | Description |
|---|---|---|
| `<leader>e` | Toggle Neo-tree | Open / close sidebar file explorer |
| `<leader>fe` | Reveal in Neo-tree | Focus current file in Neo-tree |
| `-` or `<leader>o` | Open Oil.nvim | Edit directory files directly like a buffer |

---

### 10. Search & Telescope (`<leader>f`)

| Keymap | Action | Description |
|---|---|---|
| `<leader>ff` | Find Files | Fuzzy search project files |
| `<leader>fg` | Live Grep | Search file contents with Ripgrep |
| `<leader>fb` | Buffers | Search open buffers |
| `<leader>ft` | Find TODOs | Search all `TODO:`, `FIXME:`, `BUG:`, `NOTE:` comments |
| `<leader>fs` | Document Symbols | Fuzzy search functions, classes, structs |
| `<leader>fS` | Workspace Symbols | Search symbols across the entire codebase |
| `<leader>fd` | Diagnostics | List project warnings and errors |
| `<leader>fh` | Help Tags | Search Neovim documentation |
| `<leader>fk` | Keymaps | Search all registered keybindings |
| `<leader>fr` | Resume Search | Re-open last Telescope search |

---

### 11. Clipboard & Visual Yanking (System Clipboard Integration)

| Keymap / Motion | Mode | Action | Description |
|---|---|---|---|
| `y` | Visual (`v`/`V`/`<C-v>`) | Yank to System Clipboard | Copies highlighted text directly to OS system clipboard (`+` register) |
| `<leader>y` | Normal & Visual | Explicit Copy | Yank selection or motion to system clipboard |
| `<leader>Y` | Normal | Yank Whole Line | Copy current entire line to system clipboard |
| `<leader>p` | Normal & Visual | Paste from System | Paste contents of OS system clipboard |
| `<leader>P` | Normal & Visual | Paste Before | Paste before cursor from system clipboard |
| `<leader>p` | Visual Select (`x`) | Replace Selection | Overwrite selection without polluting your yank register |

---

### 12. Surround Motions (`nvim-surround`)

| Motion | Action | Result |
|---|---|---|
| `ysiw"` | Surround word with `"` | `foo` ➔ `"foo"` |
| `ysiw>` | Surround word with `<>` | `int` ➔ `<int>` |
| `ysiw)` | Surround word with `()` | `val` ➔ `(val)` |
| `cs"'` | Change `"` to `'` | `"foo"` ➔ `'foo'` |
| `ds"` | Delete surrounding `"` | `"foo"` ➔ `foo` |
| `ds)` | Delete surrounding `()` | `(val)` ➔ `val` |

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

