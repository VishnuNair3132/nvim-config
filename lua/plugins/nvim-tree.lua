require("nvim-tree").setup({
  view = { width = 34, side = "left", preserve_window_proportions = true },
  renderer = {
    group_empty = true,
    indent_markers = { enable = true },
    icons = { git_placement = "after" },
  },
  filters = { dotfiles = false, custom = { "^.git$", "node_modules" } },
  git = { enable = true, ignore = false },
  actions = { open_file = { quit_on_open = false, window_picker = { enable = false } } },
  diagnostics = { enable = true, show_on_dirs = true },
  update_focused_file = { enable = true, update_root = false },
})

vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "File explorer" })
vim.keymap.set("n", "<leader>o", "<cmd>NvimTreeFindFile<CR>", { desc = "Reveal file in tree" })
