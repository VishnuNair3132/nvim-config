-- Edit a directory like a buffer. Complements nvim-tree; use whichever fits.
require("oil").setup({
  default_file_explorer = false,
  view_options = { show_hidden = true },
  keymaps = { ["q"] = "actions.close" },
})
vim.keymap.set("n", "-", "<cmd>Oil<CR>", { desc = "Open parent directory (oil)" })
