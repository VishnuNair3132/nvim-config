require("bufferline").setup({
  options = {
    diagnostics = "nvim_lsp",
    separator_style = "slant",
    show_buffer_close_icons = false,
    offsets = {
      { filetype = "NvimTree", text = "Files", highlight = "Directory", separator = true },
    },
  },
})
