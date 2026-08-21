require("ibl").setup({
  indent = { char = require("core.icons").ui.indent },
  scope = { enabled = true, show_start = false, show_end = false },
  exclude = { filetypes = { "help", "dashboard", "NvimTree", "lazy", "mason", "trouble" } },
})
