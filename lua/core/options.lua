local o = vim.opt

-- UI
o.number = true
o.relativenumber = true
o.cursorline = true
o.signcolumn = "yes"
o.termguicolors = true
o.scrolloff = 8
o.sidescrolloff = 8
o.wrap = false
o.splitright = true
o.splitbelow = true
o.showmode = false          -- lualine already shows it
o.pumheight = 12
o.winborder = "rounded"     -- 0.11+: rounded floats everywhere
o.laststatus = 3            -- single global statusline

-- Indent
o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.softtabstop = 4
o.smartindent = true
o.breakindent = true

-- Search
o.ignorecase = true
o.smartcase = true
o.hlsearch = true
o.incsearch = true
o.inccommand = "split"

-- Files / undo
o.swapfile = false
o.backup = false
o.undofile = true
o.undodir = vim.fn.stdpath("state") .. "/undo"
o.updatetime = 250
o.timeoutlen = 400
o.confirm = true

-- Wayland clipboard (needs wl-clipboard installed)
o.clipboard = "unnamedplus"

-- Completion
o.completeopt = { "menu", "menuone", "noselect" }

-- Folding via treesitter, but open by default
o.foldmethod = "expr"
o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
o.foldlevelstart = 99

local icons = require("core.icons")
o.fillchars = { eob = " ", fold = " ", foldopen = icons.fold.open, foldclose = icons.fold.closed }
o.list = true
o.listchars = { tab = icons.ui.tab, trail = icons.ui.trail, nbsp = icons.ui.nbsp }

vim.g.netrw_banner = 0
