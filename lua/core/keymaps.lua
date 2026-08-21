local map = vim.keymap.set

-- Sanity
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Write" })
map("n", "<leader>q", "<cmd>confirm q<CR>", { desc = "Quit" })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

-- Resize
map("n", "<C-Up>", "<cmd>resize +2<CR>")
map("n", "<C-Down>", "<cmd>resize -2<CR>")
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>")
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>")

-- Buffers
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Prev buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

-- Move lines
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Keep cursor centred
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Paste/delete without clobbering the register
map("x", "<leader>p", [["_dP]], { desc = "Paste over without yanking" })
-- NB: <leader>D, not <leader>d -- the whole <leader>d* namespace belongs to
-- the debugger, and a mapping that is a *prefix* of others makes every one of
-- them wait out 'timeoutlen' before firing.
map({ "n", "v" }, "<leader>D", [["_d]], { desc = "Delete to black hole" })

-- Terminal
map("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Terminal normal mode" })

-- Quickfix
map("n", "<leader>co", "<cmd>copen<CR>", { desc = "Quickfix open" })
map("n", "[q", "<cmd>cprev<CR>zz", { desc = "Prev quickfix" })
map("n", "]q", "<cmd>cnext<CR>zz", { desc = "Next quickfix" })
