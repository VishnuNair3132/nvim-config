require("toggleterm").setup({
  size = function(term)
    if term.direction == "horizontal" then return 15 end
    if term.direction == "vertical" then return vim.o.columns * 0.4 end
  end,
  open_mapping = [[<C-\>]],
  direction = "float",
  float_opts = { border = "rounded" },
  shade_terminals = true,
})

local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })

vim.keymap.set("n", "<leader>gg", function() lazygit:toggle() end, { desc = "Lazygit" })
vim.keymap.set("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Terminal horizontal" })
vim.keymap.set("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", { desc = "Terminal vertical" })
