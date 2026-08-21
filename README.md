# Neovim config — Fedora / Sway

Packer-based, modular, no lazy.nvim. Requires **Neovim 0.11+** (uses the native
`vim.lsp.config` / `lsp/` directory API).

## 1. System packages (Fedora)

```bash
sudo dnf install -y neovim git make cmake gcc gcc-c++ unzip \
    ripgrep fd-find wl-clipboard python3-pip lazygit \
    nodejs npm golang java-21-openjdk-devel lldb gdb bear ShellCheck
```

- `wl-clipboard` is what makes `"+y` work under Sway. Without it the system
  clipboard silently does nothing.
- `ripgrep` + `fd-find` are what Telescope actually shells out to.
- Install a Nerd Font for the icons, e.g.
  `sudo dnf install jetbrains-mono-nerd-fonts` (or drop the TTFs in
  `~/.local/share/fonts` and run `fc-cache -fv`), then set it in your terminal —
  for foot: `font=JetBrainsMono Nerd Font:size=11` in `~/.config/foot/foot.ini`.

## 2. Install the config

```bash
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null
cp -r nvim ~/.config/nvim
nvim   # packer bootstraps itself and runs PackerSync on first launch
```

Quit and reopen once packer finishes, then:

```
:InstallTools     " installs every LSP, debug adapter and formatter via Mason
:TSUpdate
:checkhealth
```

## 3. Layout

```
~/.config/nvim/
├── init.lua                  entry point, sets leader, requires the 4 modules
├── lua/
│   ├── core/                 no plugins involved
│   │   ├── init.lua
│   │   ├── options.lua
│   │   ├── keymaps.lua
│   │   └── autocmds.lua
│   ├── plugins/
│   │   ├── init.lua          packer bootstrap + THE plugin list
│   │   └── <plugin>.lua      one settings file per plugin
│   ├── lsp/
│   │   ├── init.lua          shared capabilities + vim.lsp.enable(...)
│   │   ├── attach.lua        LspAttach keymaps, inlay hints, doc highlight
│   │   └── diagnostics.lua   signs, virtual text, jump maps
│   └── custom/               your stuff, loaded last so it overrides
├── lsp/                      <- native 0.11 server defs, one file per server
│   ├── clangd.lua  gopls.lua  ts_ls.lua  eslint.lua  lua_ls.lua
└── after/ftplugin/java.lua   jdtls launcher (per-project workspace)
```

Adding a server is two steps: drop `lsp/<name>.lua`, add `"<name>"` to the
`vim.lsp.enable{}` list in `lua/lsp/init.lua`.

Adding a plugin: `use({...})` in `lua/plugins/init.lua` with
`config = cfg("name")`, then create `lua/plugins/name.lua`. Saving that file
auto-runs `:PackerCompile`; run `:PackerSync` to fetch.

## 4. Keybindings — full reference

Leader is `<Space>`. Bindings marked **(buf)** only exist in a buffer where the
relevant thing is active (an LSP client, a git repo, a `.java` file). Press
`<leader>` and pause to get the which-key popup, or `<leader>fk` to fuzzy-search
every mapping live.

### Editing & movement

| Key | Mode | Action |
|---|---|---|
| `jk` | i | Exit insert mode |
| `<Esc>` | n | Clear search highlight |
| `<leader>w` / `<leader>q` | n | Write / quit |
| `J` / `K` | v | Move selection down / up |
| `<` / `>` | v | Indent, keeping selection |
| `<leader>p` | x | Paste over selection without clobbering the register |
| `<leader>D` | n,v | Delete to the black hole register |
| `<C-d>` / `<C-u>` / `n` / `N` | n | Scroll & search, cursor recentred |
| `s` / `S` | n,x,o | Flash jump / flash treesitter (**replaces vim's `s`**) |
| `-` | n | Open parent directory in oil |
| `gcc` / `gc` | n / v | Comment line / selection (Comment.nvim) |
| `ys` / `cs` / `ds` | n | Add / change / delete surround (nvim-surround) |

### Windows, buffers, terminal

| Key | Mode | Action |
|---|---|---|
| `<C-h/j/k/l>` | n | Move to window left/down/up/right |
| `<C-Up/Down/Left/Right>` | n | Resize window |
| `<S-h>` / `<S-l>` | n | Previous / next buffer |
| `<leader>bd` | n | Delete buffer |
| `<C-\>` | n,i | Toggle floating terminal |
| `<leader>th` / `<leader>tv` | n | Terminal horizontal / vertical |
| `<Esc><Esc>` | t | Leave terminal insert mode |

### Find (telescope)

| Key | Action |
|---|---|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fw` | Grep word under cursor |
| `<leader>fb` | Buffers |
| `<leader>fr` | Recent files |
| `<leader>fh` | Help tags |
| `<leader>fk` | Keymaps |
| `<leader>fd` | Diagnostics |
| `<leader>fs` / `<leader>fS` | Document / workspace symbols |
| `<leader>ft` | TODO comments |
| `<leader>/` | Fuzzy search in current buffer |

Inside a picker: `<C-j>`/`<C-k>` move, `<C-q>` sends results to the quickfix
list, `<Esc>` closes.

### LSP **(buf)**

| Key | Mode | Action |
|---|---|---|
| `gd` / `gr` | n | Definition / references |
| `gi` / `gt` / `gD` | n | Implementation / type definition / declaration |
| `K` | n | Hover |
| `<C-s>` | n,i | Signature help |
| `<leader>lr` | n | Rename |
| `<leader>la` | n,v | Code action |
| `<leader>lf` | n,v | Format buffer / selection (conform) |
| `<leader>lh` | n | Toggle inlay hints |
| `<leader>ld` | n | Line diagnostics float |
| `<leader>li` / `<leader>lR` | n | LSP health / restart server |
| `<leader>lm` | n | Open Mason |
| `[d` / `]d` | n | Previous / next diagnostic |
| `[e` / `]e` | n | Previous / next **error** |

### Java **(buf, `.java` only)**

| Key | Action |
|---|---|
| `<leader>jo` | Organize imports |
| `<leader>jv` / `<leader>jc` | Extract variable / constant |
| `<leader>jm` | Extract method (works in visual mode too) |
| `<leader>jt` / `<leader>jT` | Test nearest method / test class |

### Debug (nvim-dap)

| Key | Action |
|---|---|
| `<F5>` | Continue / start |
| `<F10>` / `<F11>` / `<F12>` | Step over / into / out |
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Conditional breakpoint |
| `<leader>dl` | Log point |
| `<leader>dc` | Run to cursor |
| `<leader>de` | Evaluate expression (n and v) |
| `<leader>dr` | Toggle REPL |
| `<leader>du` | Toggle DAP UI |
| `<leader>dt` | Terminate session |

### Git

Three tools, three jobs: **gitsigns** while editing, **lazygit** for flow-heavy
work (rebase, branches, stashes), **fugitive** for conflicts and archaeology.

*gitsigns — in-buffer hunks* **(buf)**

| Key | Action |
|---|---|
| `]h` / `[h` | Next / previous hunk |
| `<leader>gp` | Preview hunk |
| `<leader>gr` | Reset hunk (n and v) |
| `<leader>gS` | Stage hunk |
| `<leader>gb` / `<leader>gB` | Blame line / toggle inline blame |
| `<leader>gd` | Diff this |

*telescope + lazygit*

| Key | Action |
|---|---|
| `<leader>gg` | Lazygit (floating) |
| `<leader>gs` / `<leader>gc` | Git status / commits (telescope) |

*fugitive*

| Key | Action |
|---|---|
| `<leader>gG` | Git status buffer (`:Git`) |
| `<leader>ga` | Stage current file (`:Gwrite`) |
| `<leader>gl` / `<leader>gL` | Log for repo / current file |
| `<leader>gm` | Blame, scrollbound buffer |
| `<leader>gD` | Diff against index |
| `<leader>gM` | **3-way merge split** for conflicts |
| `<leader>g2` / `<leader>g3` | Conflict: take ours (`//2`) / theirs (`//3`) |
| `<leader>gP` | Git push |
| `<leader>gx` | Open current line on GitHub (n and v, rhubarb) |
| `:Conflicts` | Put every unmerged file in the quickfix list |

Inside `:Git` status: `s` stage, `u` unstage, `=` toggle inline diff, `cc` commit,
`dv` diff the file. Inside blame: `<CR>` open the commit, `o` open in a split,
`-` reblame at the parent commit.

**Resolving a conflict:** `:Conflicts` to list them, `]q` to walk to one,
`<leader>gM` for the 3-way split, then `<leader>g2` / `<leader>g3` on each
conflicted hunk, `:Gwrite` to stage the result.

**The thing only fugitive can do:** `:Gedit HEAD~3:%` opens that revision of the
current file as an ordinary buffer — searchable, yankable, diffable.
`:Gread HEAD~1:%` pulls an old version into the buffer you are in.

### Diagnostics list (trouble) & quickfix

| Key | Action |
|---|---|
| `<leader>xx` / `<leader>xd` | Diagnostics: workspace / buffer |
| `<leader>xs` | Symbols |
| `<leader>xq` / `<leader>xl` | Quickfix / location list |
| `<leader>co` | Open quickfix |
| `[q` / `]q` | Previous / next quickfix entry |
| `>` / `<` | Expand / collapse context (in the quickfix window) |
| `q` | Close help, quickfix, man, lspinfo, checkhealth, dap floats |

### Treesitter text objects

| Key | Action |
|---|---|
| `af` / `if` | Around / inside function |
| `ac` / `ic` | Around / inside class |
| `aa` / `ia` | Around / inside parameter |
| `ai` / `ii` | Around / inside conditional |
| `al` / `il` | Around / inside loop |
| `]f` / `[f` | Next / previous function start |
| `]c` / `[c` | Next / previous class start |
| `<leader>a` / `<leader>A` | Swap parameter with next / previous |
| `<C-space>` / `<BS>` | Expand / shrink selection by node |

These are registered per-buffer and only for languages whose parser ships
the matching query — all ten exist in C, but `ac`/`ic` (class) are absent in
Lua, for instance. That's expected, not a broken mapping.

### Files, TODOs, theme

| Key | Action |
|---|---|
| `<leader>e` / `<leader>o` | Toggle file tree / reveal current file |
| `]t` / `[t` | Next / previous TODO comment |
| `<leader>ut` | Toggle light/dark (`modus-themes-toggle`) |
| `<leader>uT` | Colorscheme picker (`M-x load-theme`) |

### Commands

| Command | What it does |
|---|---|
| `:InstallTools` | Install every LSP, DAP adapter and formatter via Mason |
| `:LoadTheme <name>` | Set and remember a colorscheme (tab-completes) |
| `:FormatToggle` | Toggle format-on-save globally |
| `:FormatToggle!` | Toggle format-on-save for this buffer only |
| `:DiagnosticsToggle` | Toggle diagnostics |
| `:Lint` | Run linters for this buffer |
| `:Conflicts` | Put every unmerged file in the quickfix list |

## 5. Per-language notes

**C/C++** — clangd is only as good as your `compile_commands.json`.
CMake: `cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -B build`, then
`ln -s build/compile_commands.json .`. Plain Makefiles: `bear -- make`.
Debugging uses codelldb; compile with `-g`.

**Go** — `gopls` picks up `go.work`/`go.mod` automatically. Debugging goes
through `dap-go`, which drives `delve`; `<leader>dt` in a `_test.go` file has a
"debug nearest test" config registered by the plugin.

**Java** — jdtls is started per project from `after/ftplugin/java.lua` and keeps
its workspace in `~/.cache/nvim/jdtls-workspace/<project>`. First open of a big
Gradle/Maven project takes a minute while it imports; watch the fidget spinner.
If it goes sideways, delete that workspace dir and reopen. `JAVA_HOME` must point
at a JDK 21+ for jdtls itself even if your project targets an older release.

**JS/TS** — `ts_ls` for intelligence, `eslint` LSP for lint + fix-on-save,
prettierd for formatting. Debugging via `js-debug-adapter` (node targets;
browser debugging needs a `pwa-chrome` adapter block, not included).

## 6. Theme

The config ships Emacs-derived colorschemes instead of a generic Neovim one:

| Theme | What it is |
|---|---|
| `modus_vivendi` / `modus_operandi` | **default.** Protesilaos' Modus themes — these are the accessible themes bundled *with* Emacs since 28.1. Dark and light, WCAG AAA contrast, deliberately flat. |
| `doom-one` | The Doom Emacs default. What most people picture as "Emacs, modern". |
| `zenburn` | Started life as an Emacs theme in 2003. Low contrast, warm greys. |
| `ef-*` | Protesilaos' ef-themes, a whole family. Run the picker to browse them. |

- `<leader>ut` — toggle light/dark, the equivalent of `modus-themes-toggle`
- `<leader>uT` — live-preview picker, the equivalent of `M-x load-theme`
- `:LoadTheme <name>` — set one directly

Your choice is written to `~/.local/state/nvim/colorscheme.txt` and restored on
next launch. To change the default, edit `DEFAULT` at the top of
`lua/plugins/colorscheme.lua`.

Note the config only *looks* like Emacs — the keybindings stay Vim. `which-key`
is the closest thing to Emacs behaviour here, and it's a direct port of Emacs'
`which-key.el`.

## 7. What was actually tested

Booted on **Neovim 0.11.2** with all 47 plugins installed. Verified:

- packer compiles with zero config errors; 28/28 runtime checks pass
- colorscheme applies, `<leader>ut` toggles dark -> light
- telescope (incl. the compiled fzf sorter) and ui-select both load
- treesitter parsers compile; highlighter attaches and returns correct captures
  (`type.builtin` on `int`); `foldexpr` works
- DAP adapters registered for c, cpp, go, javascript, typescript
- C / Java / TS / Go / Lua files open and save cleanly with correct indent rules
- **fugitive**: `:Conflicts` populates the quickfix, `Gdiffsplit!` produces a
  true 3-window merge view, and `diffget //2` resolved a real conflict cleanly;
  `Gedit HEAD~1:f.txt` returned the correct historical content; gitsigns'
  bindings verified unaffected
- **real LSP round-trip** against lua-language-server 3.13.6: attaches with
  correct `root_dir`, cmp capabilities merged in (`snippetSupport: true`),
  buffer-local keymaps bound, inlay hints on, hover responds, 101 completion
  items for `vim.`, 6 diagnostics on a broken file in ~5s

**Not verified:** Mason's package installs — its registry index could not be
fetched in the test environment, so `:InstallTools` itself is untested. The
servers it installs are exercised above via a manually installed binary, so the
LSP path around it is known good. jdtls specifically is untested end to end.

## 8. Things worth knowing

- **packer.nvim is unmaintained** (archived upstream in 2023). It still works
  fine, but if you ever want off it, `paq-nvim` or `mini.deps` are the closest
  drop-in replacements, and Neovim 0.12 ships `vim.pack` in core.
- Format-on-save is on. `:FormatToggle` disables it globally, `:FormatToggle!`
  for the current buffer only.
- If you edit `lua/plugins/init.lua`, remember packer serialises `config` with
  `string.dump()`, which drops upvalues. Use the string form (`cfg()` returns a
  string for exactly this reason) — a closure capturing a local will fail at
  runtime with "attempt to concatenate upvalue".
- Every binding above was verified to exist at runtime (69/70 global+buffer
  checks; the one absence is the filetype-dependent `ac` noted above).
- Watch out for prefix collisions when adding leader maps: a mapping that is a
  prefix of others makes all of them wait out `timeoutlen` first. This is why
  black-hole delete is `<leader>D` and not `<leader>d` — the latter would have
  stalled every debugger binding by 400ms.
- `:checkhealth` after any weirdness — it catches missing `rg`, `fd`, `node`,
  clipboard providers, and treesitter compiler issues.
