require("trouble").setup({ focus = true })
local map = vim.keymap.set
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Diagnostics (workspace)" })
map("n", "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Diagnostics (buffer)" })
map("n", "<leader>xs", "<cmd>Trouble symbols toggle<CR>", { desc = "Symbols" })
map("n", "<leader>xq", "<cmd>Trouble qflist toggle<CR>", { desc = "Quickfix list" })
map("n", "<leader>xl", "<cmd>Trouble loclist toggle<CR>", { desc = "Location list" })
