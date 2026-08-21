local telescope = require("telescope")
local actions = require("telescope.actions")
local icons = require("core.icons")

telescope.setup({
  defaults = {
    prompt_prefix = icons.ui.prompt,
    selection_caret = icons.ui.caret,
    path_display = { "truncate" },
    sorting_strategy = "ascending",
    layout_config = {
      horizontal = { prompt_position = "top", preview_width = 0.55 },
      width = 0.9, height = 0.85,
    },
    file_ignore_patterns = { "%.git/", "node_modules/", "target/", "build/", "%.class" },
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
        ["<Esc>"] = actions.close,
      },
    },
  },
  pickers = {
    find_files = { hidden = true },
    buffers = { sort_mru = true, ignore_current_buffer = true },
  },
  extensions = {
    fzf = { fuzzy = true, override_generic_sorter = true, override_file_sorter = true },
    ["ui-select"] = { require("telescope.themes").get_dropdown() },
  },
})

pcall(telescope.load_extension, "fzf")
pcall(telescope.load_extension, "ui-select")

local b = require("telescope.builtin")
local map = vim.keymap.set
map("n", "<leader>ff", b.find_files,  { desc = "Find files" })
map("n", "<leader>fg", b.live_grep,   { desc = "Live grep" })
map("n", "<leader>fw", b.grep_string, { desc = "Grep word under cursor" })
map("n", "<leader>fb", b.buffers,     { desc = "Buffers" })
map("n", "<leader>fh", b.help_tags,   { desc = "Help tags" })
map("n", "<leader>fk", b.keymaps,     { desc = "Keymaps" })
map("n", "<leader>fr", b.oldfiles,    { desc = "Recent files" })
map("n", "<leader>fd", b.diagnostics, { desc = "Diagnostics" })
map("n", "<leader>fs", b.lsp_document_symbols, { desc = "Document symbols" })
map("n", "<leader>fS", b.lsp_dynamic_workspace_symbols, { desc = "Workspace symbols" })
map("n", "<leader>gc", b.git_commits, { desc = "Git commits" })
map("n", "<leader>gs", b.git_status,  { desc = "Git status" })
map("n", "<leader>/",  b.current_buffer_fuzzy_find, { desc = "Search in buffer" })
